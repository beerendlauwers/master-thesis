
Partial Class App_Presentation_Webpaginas_ReservatieBevestigen
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("autoID") IsNot Nothing And _
        Request.QueryString("begindat") IsNot Nothing And _
        Request.QueryString("einddat") IsNot Nothing Then

            If (IsPostBack) Then
                Return
            End If

            'We hebben een nieuwe geldige reservatie binnengekregen. Het eerste wat
            'we doen is hem opslaan in de database, maar hem nog niet bevestigen.
            'Op deze manier zullen andere gebruikers niet met dezelfde auto bezig zijn,
            'wat wel kan gebeuren als een anonieme bezoeker zijn gebruikersgegevens is
            'aan het invullen.

            Try
                Dim autoID As Integer = Convert.ToInt32(Request.QueryString("autoID"))
                Dim begindat As Date = Date.Parse(Request.QueryString("begindat"))
                Dim einddat As Date = Date.Parse(Request.QueryString("einddat"))

                Dim userID As Guid
                If (User.Identity.IsAuthenticated) Then
                    userID = New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())
                Else
                    'Dit is een anonieme gebruiker
                    userID = New Guid("7a73f865-ec29-4efd-bf09-70a9f9493d21")
                End If

                'Reeds al wat gegevens verzamelen
                Dim reservatie As New Reservatie
                With reservatie
                    .AutoID = autoID
                    .Begindatum = begindat
                    .Einddatum = einddat
                    .UserID = userID
                    .IsBevestigd = False
                End With

                'Nakijken of deze auto is bevestigd door een gebruiker.
                'Zoja, dan flikkeren we de bezoeker eruit. Niets te doen hier.
                If (KijkNaOfReservatieBevestigdIs(reservatie)) Then
                    Response.Redirect("~/App_Presentation/Webpaginas/Default.aspx")


                    'Anders  gaan we nakijken of er reeds een (onbevestigde)
                    'reservatie is voor deze auto.
                ElseIf (TijdelijkeReservatieNakijken(reservatie)) Then

                    'Deze reservatie bestaat, maar is onbevestigd.

                    'Als de gebruiker anoniem is, moet hij maar eerst eens inloggen.
                    If (Not User.Identity.IsAuthenticated) Then
                        Response.Redirect("~/App_Presentation/Webpaginas/Default.aspx")
                    Else 'Als deze gebruiker ingelogd is, dan kan hij de reservatie
                        'voor zich reserveren.
                        MaakReservatieBevestigingsOverzicht(reservatie)
                    End If


                Else 'Er is nog geen enkele reservatie. REAP THE SPOILS OF WAR

                    'Als de gebruiker anoniem is, kan hij de auto tijdelijk reserveren,
                    'maar voor een permanente reservatie moet hij ingelogd zijn.
                    If (Not User.Identity.IsAuthenticated) Then
                        'Tijdelijke reservatie toevoegen
                        TijdelijkeReservatieToevoegen(reservatie)
                        'Doorsturen naar NieuweGebruikerAanmaken.aspx
                        AnoniemeGebruikerDoorsturen()
                        Return
                    End If

                    'Als de gebruiker ingelogd is, kan hij de auto tijdelijk reserveren
                    'en direct het overzicht bezien. 
                    If (User.Identity.IsAuthenticated) Then
                        TijdelijkeReservatieToevoegen(reservatie)
                        MaakReservatieBevestigingsOverzicht(reservatie)
                        Return
                    End If


                End If

            Catch ex As Exception
                Throw ex
        End Try
        End If
    End Sub

    Private Function TijdelijkeReservatieNakijken(ByRef res As Reservatie) As Boolean
        Dim reservatiebll As New ReservatieBLL
        Dim row As Reservaties.tblReservatieRow = reservatiebll.GetSpecificReservatieByDatumAndAutoID(res)

        If (row IsNot Nothing) Then
            Return True
        Else
            Return False
        End If

    End Function

    Private Function TijdelijkeReservatieToevoegen(ByRef res As Reservatie) As Boolean
        Dim reservatiebll As New ReservatieBLL
        Dim autobll As New AutoBLL
        Dim statusbll As New StatusBLL

        Try
            Dim dt As New Reservaties.tblReservatieDataTable
            Dim r As Reservaties.tblReservatieRow = dt.NewRow

            'Basisreservatieinformatie.
            r.userID = res.UserID
            r.autoID = res.AutoID
            r.reservatieBegindat = res.Begindatum
            r.reservatieEinddat = res.Einddatum

            'Deze reservatie is nog niet bevestigd.
            r.reservatieIsBevestigd = res.IsBevestigd

            'Deze eerste medewerker zou moeten worden ingevuld als een echte medewerker
            'als we de functionaliteit toevoegen dat een medewerker een reservatie voor een klant
            'kan toevoegen. Niet erg moeilijk, maar niet vergeten.
            r.reservatieGereserveerdDoorMedewerker = New Guid("7a73f865-ec29-4efd-bf09-70a9f9493d21")

            'De volgende twee medewerkers worden enkel aangepast bij een in- of uitcheckprocedure.
            r.reservatieIngechecktDoorMedewerker = New Guid("7a73f865-ec29-4efd-bf09-70a9f9493d21")
            r.reservatieUitgechecktDoorMedewerker = New Guid("7a73f865-ec29-4efd-bf09-70a9f9493d21")

            r.verkoopscontractOpmerking = String.Empty
            r.verkoopscontractIsOndertekend = 0

            r.factuurBijschrift = String.Empty
            r.factuurIsInWacht = 0

            reservatiebll.InsertReservatie(r)

            'Status veranderen van "Beschikbaar" naar "Gereserveerd"
            Dim a As Autos.tblAutoRow = autobll.GetAutoByAutoID(res.AutoID).Rows(0)
            a.statusID = statusbll.GetStatusByStatusNaam("Gereserveerd").Rows(0).Item("autostatusID")
            autobll.UpdateAuto(a)

        Catch ex As Exception
            Throw ex
            Return False
        Finally
            reservatiebll = Nothing
            autobll = Nothing
            statusbll = Nothing
        End Try
    End Function

    Private Sub AnoniemeGebruikerDoorsturen()

        'Alles opslaan in een cookie
        Dim tempCookie As New HttpCookie("reservatieCookie")
        tempCookie.Expires = DateTime.Now.AddDays(2)
        tempCookie("autoID") = Request.QueryString("autoID")
        tempCookie("begindat") = Request.QueryString("begindat")
        tempCookie("einddat") = Request.QueryString("einddat")
        Response.Cookies.Add(tempCookie)

        'En wegsturen maar
        Response.Redirect("~/App_Presentation/Webpaginas/NieuweGebruikerAanmaken.aspx")

    End Sub

    Private Sub MaakReservatieBevestigingsOverzicht(ByRef r As Reservatie)

        Dim autobll As New AutoBLL
        Dim a As Autos.tblAutoRow = autobll.GetAutoByAutoID(r.AutoID).Rows(0)

        Me.lblMerkModel.Text = autobll.GetAutoNaamByAutoID(r.AutoID)
        Me.lblKleur.Text = a.autoKleur

        Me.lblPeriode.Text = String.Concat(Format(r.Begindatum, "dd/MM/yyyy"), " - ", Format(r.Einddatum, "dd/MM/yyyy"))

        Me.imgFoto.Attributes.Add("src", String.Concat("~\App_Presentation\AutoFoto.ashx?autoID=", r.AutoID))

        Dim optiebll As New OptieBLL
        Dim dt As Autos.tblOptieDataTable = optiebll.GetAllOptiesByAutoID(a.autoID)

        Dim optiekosten As Double = 0
        For Each optie As Autos.tblOptieRow In dt
            Dim tr As New HtmlGenericControl("tr")

            Dim tdlinks As New HtmlGenericControl("td")
            Dim optienaam As New Label
            optienaam.Text = optie.optieOmschrijving

            Dim tdrechts As New HtmlGenericControl("td")
            Dim optiekost As New Label
            optiekost.Text = optie.optieKost.ToString
            optiekosten = optie.optieKost

            tdlinks.Controls.Add(optienaam)
            tdrechts.Controls.Add(optiekost)
            tr.Controls.Add(tdlinks)
            tr.Controls.Add(tdrechts)
            Me.plcOpties.Controls.Add(tr)
        Next optie

        Me.tdFoto.Attributes.Add("rowspan", 6 + dt.Count)

        Dim huurprijs As Double
        huurprijs = (r.Einddatum - r.Begindatum).TotalDays * a.autoDagTarief
        huurprijs = huurprijs + optiekosten
        Me.lblHuurPrijs.Text = String.Concat(huurprijs.ToString, " €")

    End Sub

    Private Function KijkNaOfReservatieBevestigdIs(ByRef r As Reservatie) As Boolean
        Dim reservatiebll As New ReservatieBLL

        Dim row As Reservaties.tblReservatieRow = reservatiebll.GetSpecificReservatieByDatumAndAutoID(r)

        If (row Is Nothing) Then
            Return False
        End If

        reservatiebll = Nothing
        Return row.reservatieIsBevestigd
    End Function

    Protected Sub btnBevestigen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBevestigen.Click
        Dim reservatiebll As New ReservatieBLL

        Try
            Dim autoID As Integer = Convert.ToInt32(Request.QueryString("autoID"))
            Dim begindat As Date = Date.Parse(Request.QueryString("begindat"))
            Dim einddat As Date = Date.Parse(Request.QueryString("einddat"))

            Dim reservatie As New Reservatie
            reservatie.AutoID = autoID
            reservatie.Begindatum = begindat
            reservatie.Einddatum = einddat

            Dim row As Reservaties.tblReservatieRow = reservatiebll.GetSpecificReservatieByDatumAndAutoID(reservatie)

            row.reservatieIsBevestigd = 1

            reservatiebll.UpdateReservatie(row)

            Me.btnBevestigen.Visible = False
            Me.lblResultaat.Visible = True
            Me.lblResultaat.Text = "Auto toegevoegd."
            Me.imgResultaat.ImageUrl = "~\App_Presentation\Images\tick.gif"


        Catch ex As Exception
            Me.lblResultaat.Text = "Er is een fout gebeurd. Gelieve de auto te wijzigen in uw reservatieoverzicht."
            Me.imgResultaat.ImageUrl = "~\App_Presentation\Images\remove.gif"
        Finally
            reservatiebll = Nothing
        End Try
    End Sub

End Class
