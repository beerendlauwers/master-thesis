
Partial Class App_Presentation_Webpaginas_ReservatieBevestigen
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (IsPostBack) Then
            Return
        End If

        If Request.QueryString("autoID") IsNot Nothing And _
        Request.QueryString("begindat") IsNot Nothing And _
        Request.QueryString("einddat") IsNot Nothing Then

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
                If (KijkNaOfReservatieBevestigdIs(reservatie)) Then

                    Me.divFoutmelding.Visible = True
                    Me.lblFoutDetails.Text = "Deze auto werd reeds gereserveerd voor deze datum."
                    Return

                    'Anders  gaan we nakijken of er reeds een (onbevestigde)
                    'reservatie is voor deze auto.
                ElseIf (TijdelijkeReservatieNakijken(reservatie)) Then

                    'Deze reservatie bestaat, maar is onbevestigd.

                    'Als de gebruiker anoniem is, moet hij maar eerst eens inloggen.
                    If (Not User.Identity.IsAuthenticated) Then

                        Me.updReservatieBevestigen.Visible = False
                        Me.divInloggen.Visible = True

                    Else 'Als deze gebruiker ingelogd is, dan kan hij de reservatie
                        'voor zich reserveren.
                        MaakReservatieBevestigingsOverzicht(reservatie)
                    End If


                Else 'Er is nog geen enkele reservatie. REAP THE SPOILS OF WAR

                    'Maar enkel als deze reservatie niet conflicteert met een andere!
                    If (Not AutoIsBeschikbaarVoorPeriode(begindat, einddat, autoID)) Then
                        Me.divFoutmelding.Visible = True
                        Me.lblFoutDetails.Text = "Deze auto werd reeds gereserveerd voor deze datum."
                        Return
                    End If

                    'Als de gebruiker anoniem is, kan hij de auto tijdelijk reserveren,
                    'maar voor een permanente reservatie moet hij ingelogd zijn.
                    If (Not User.Identity.IsAuthenticated) Then
                        'Tijdelijke reservatie toevoegen
                        TijdelijkeReservatieToevoegen(reservatie)

                        Me.updReservatieBevestigen.Visible = False
                        Me.divInloggen.Visible = True

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
                Me.divFoutmelding.Visible = True
                Me.lblFoutDetails.Text = "Een belangrijke parameter (auto, begindatum of einddatum) werd fout meegegeven."
                Return
            End Try

        Else
            Me.divFoutmelding.Visible = True
            Me.lblFoutDetails.Text = "Een belangrijke parameter (auto, begindatum of einddatum) werd niet meegegeven."
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
        Try
            'Reservatie toevoegen
            Dim r As Reservaties.tblReservatieRow = ReservatieToevoegen(res)

            'Nazicht toevoegen
            NazichtToevoegenVoorReservatie(r)

        Catch ex As Exception
            Throw ex
            Return False
        End Try
    End Function

    Private Function ReservatieToevoegen(ByRef res As Reservatie) As Reservaties.tblReservatieRow
        Dim dt As New Reservaties.tblReservatieDataTable
        Dim r As Reservaties.tblReservatieRow = dt.NewRow

        'Basisreservatieinformatie.
        r.userID = res.UserID
        r.autoID = res.AutoID
        r.reservatieStatus = 0
        r.reservatieBegindat = res.Begindatum
        r.reservatieEinddat = res.Einddatum

        'Deze reservatie is nog niet bevestigd.
        r.reservatieIsBevestigd = res.IsBevestigd
        r.reservatieLaatstBekeken = Now

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

        Dim reservatiebll As New ReservatieBLL
        reservatiebll.InsertReservatie(r)
        reservatiebll = Nothing

        Return r
    End Function

    Private Sub NazichtToevoegenVoorReservatie(ByRef r As Reservaties.tblReservatieRow)
        Dim controlebll As New ControleBLL
        Dim reservatiebll As New ReservatieBLL

        'Een nazicht van deze auto na deze reservatie registreren
        Dim nazichtdt As New Onderhoud.tblControleDataTable
        Dim nazichtrow As Onderhoud.tblControleRow = nazichtdt.NewRow

        'Dit is een nazicht
        nazichtrow.controleIsNazicht = True


        'ReservatieID ophalen
        Dim reservatie As New Reservatie
        reservatie.AutoID = r.autoID
        reservatie.Begindatum = r.reservatieBegindat
        reservatie.Einddatum = r.reservatieEinddat
        Dim reservatieID As Integer = reservatiebll.GetSpecificReservatieByDatumAndAutoID(reservatie).Item("reservatieID")

        'ReservatieID in nazichtrow steken
        nazichtrow.reservatieID = reservatieID

        'Dummy-medewerker
        nazichtrow.medewerkerID = New Guid("7a73f865-ec29-4efd-bf09-70a9f9493d21")

        'AutoID
        nazichtrow.autoID = r.autoID

        'Een nazicht is altijd onmiddellijk na de reservatie en duurt 1 dag
        nazichtrow.controleBegindat = DateAdd(DateInterval.Day, 1, r.reservatieEinddat)
        nazichtrow.controleEinddat = DateAdd(DateInterval.Day, 1, r.reservatieEinddat)

        'Dummy-waardes
        nazichtrow.controleKilometerstand = 0
        nazichtrow.controleBrandstofkost = 0

        'Controle toevoegen.
        ControleBLL.InsertNazicht(nazichtrow)

    End Sub

    Public Sub AnoniemeGebruikerDoorsturen()

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

    Private Function AutoIsBeschikbaarVoorPeriode(ByVal begindat As Date, ByVal einddat As Date, ByVal autoID As Integer) As Boolean
        Dim autobll As New AutoBLL

        Dim dt As Autos.tblAutoDataTable = autobll.GetSpecificAutoByPeriode(begindat, einddat, autoID)

        If (dt.Rows.Count > 0) Then
            Return True
        Else
            Return False
        End If
    End Function

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
        huurprijs = ((r.Einddatum - r.Begindatum).TotalDays + 1) * a.autoDagTarief
        huurprijs = huurprijs + optiekosten
        Me.lblHuurPrijs.Text = String.Concat(huurprijs.ToString, " €")

        Me.updReservatieBevestigen.Visible = True

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
            Dim res As New Reservatie

            Dim autoID As Integer = Convert.ToInt32(Request.QueryString("autoID"))
            Dim begindat As Date = Date.Parse(Request.QueryString("begindat"))
            Dim einddat As Date = Date.Parse(Request.QueryString("einddat"))

            res.AutoID = autoID
            res.Begindatum = begindat
            res.Einddatum = einddat

            Dim row As Reservaties.tblReservatieRow = reservatiebll.GetSpecificReservatieByDatumAndAutoID(res)

            row.reservatieIsBevestigd = 1

            row.userID = New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())

            reservatiebll.UpdateReservatie(row)

            Me.btnBevestigen.Visible = False
            Me.lblResultaat.Visible = True
            Me.lblResultaat.Text = "Auto bevestigd."
            Me.imgResultaat.ImageUrl = "~\App_Presentation\Images\tick.gif"

        Catch
            Me.lblResultaat.Text = "Er is een fout gebeurd. Gelieve het opnieuw te proberen."
            Me.lblResultaat.Visible = True
            Me.imgResultaat.ImageUrl = "~\App_Presentation\Images\remove.png"
        Finally
            reservatiebll = Nothing
        End Try
    End Sub

End Class
