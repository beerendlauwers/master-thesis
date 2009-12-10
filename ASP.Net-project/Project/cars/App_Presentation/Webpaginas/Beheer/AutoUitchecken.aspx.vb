
Partial Class App_Presentation_Webpaginas_Beheer_AutoUitchecken
    Inherits System.Web.UI.Page

    Protected Sub btnZoekKlant_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoekKlant.Click

        Me.lblError.Text = String.Empty

        If (Not Me.txtNaam.Text = String.Empty And Not Me.txtVoornaam.Text = String.Empty) Then
            ZoekOpNaamEnVoornaam(Me.txtNaam.Text, Me.txtVoornaam.Text)
        ElseIf (Not Me.txtRijbewijs.Text = String.Empty) Then
            ZoekOpRijbewijs(Me.txtRijbewijs.Text)
        ElseIf (Not Me.txtIdenteitskaart.Text = String.Empty) Then
            ZoekOpIdentiteitsKaart(Me.txtIdenteitskaart.Text)
        Else
            Me.lblError.Text = "Gelieve een filteroptie te kiezen."
            Me.divRepeater.Visible = False
            Return
        End If
    End Sub

    Private Sub ZoekOpNaamEnVoornaam(ByVal naam As String, ByVal voornaam As String)
        Dim klantbll As New KlantBLL

        Dim profiel As Klanten.tblUserProfielDataTable = klantbll.GetUserProfielByNaamEnVoornaam(naam, voornaam)

        If (profiel.Rows.Count = 0) Then
            Me.lblError.Text = "Er werd geen klant gevonden op deze combinatie van naam en voornaam."
            Me.divRepeater.Visible = False
            Return
        Else
            Me.repKlant.DataSource = profiel
            Me.repKlant.DataBind()
            Me.divRepeater.Visible = True

            Dim user As Klanten.tblUserProfielRow = profiel.Rows(0)
            If (user.userIsBedrijf) Then
                HaalChauffeurGegevensOpVanKlant(user.userID)
            End If

            HaalReservatieGegevensOpVanKlant(user.userID)
        End If
    End Sub

    Private Sub ZoekOpRijbewijs(ByVal rijbewijs As String)
        Dim klantbll As New KlantBLL

        Dim profiel As Klanten.tblUserProfielDataTable = klantbll.GetUserProfielByRijbewijs(rijbewijs)

        If (profiel.Rows.Count = 0) Then
            Me.lblError.Text = "Er werd geen klant gevonden die dit rijbewijsnummer heeft."
            Me.divRepeater.Visible = False
            Return
        Else
            Me.repKlant.DataSource = profiel
            Me.repKlant.DataBind()
            Me.divRepeater.Visible = True

            Dim user As Klanten.tblUserProfielRow = profiel.Rows(0)
            If (user.userIsBedrijf) Then
                HaalChauffeurGegevensOpVanKlant(user.userID)
            End If

            HaalReservatieGegevensOpVanKlant(user.userID)
        End If
    End Sub

    Private Sub ZoekOpIdentiteitsKaart(ByVal identiteitskaartnr As String)
        Dim klantbll As New KlantBLL

        Dim profiel As Klanten.tblUserProfielDataTable = klantbll.GetUserProfielByIdentiteitskaartNr(identiteitskaartnr)

        If (profiel.Rows.Count = 0) Then
            Me.lblError.Text = "Er werd geen klant gevonden die dit identiteitskaartnummer heeft."
            Me.divRepeater.Visible = False
            Return
        Else
            Me.repKlant.DataSource = profiel
            Me.repKlant.DataBind()
            Me.divRepeater.Visible = True

            Dim user As Klanten.tblUserProfielRow = profiel.Rows(0)
            If (user.userIsBedrijf) Then
                HaalChauffeurGegevensOpVanKlant(user.userID)
            End If

            HaalReservatieGegevensOpVanKlant(user.userID)
        End If
    End Sub

    Private Sub HaalChauffeurGegevensOpVanKlant(ByRef userID As Guid)
        Dim chauffeurbll As New ChauffeurBLL
        Dim chauffeurs As Klanten.tblChauffeurDataTable = chauffeurbll.GetChauffeurByUserID(userID)

        If (chauffeurs.Rows.Count = 0) Then
            Me.divChauffeurs.Visible = False
        Else
            Me.repChauffeurs.DataSource = chauffeurs
            Me.repChauffeurs.DataBind()
            Me.divChauffeurs.Visible = True
        End If
    End Sub

    Private Sub HaalReservatieGegevensOpVanKlant(ByRef userID As Guid)

        'UserID opslaan. Is handig voor later.
        ViewState("userID") = userID.ToString

        Dim reservatiebll As New ReservatieBLL
        Dim autobll As New AutoBLL
        Dim parkeerbll As New ParkeerBLL

        'Dit is onze weergavetabel.
        Dim weergavetabel As New Data.DataTable
        weergavetabel.Columns.Add("FiliaalID", Type.GetType("System.Int32"))
        weergavetabel.Columns.Add("Kenteken", Type.GetType("System.String"))
        weergavetabel.Columns.Add("MerkModel", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Parkeerplaats", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Begindatum", Type.GetType("System.DateTime"))
        weergavetabel.Columns.Add("Einddatum", Type.GetType("System.DateTime"))
        weergavetabel.Columns.Add("Data", Type.GetType("System.String"))

        'Maandfilter ophalen.
        Dim maand As Date = MaakDatumFilter()

        'Alle beschikbare (reservatieStatus = 0) reservaties voor onze klant ophalen.
        Dim reservaties As Reservaties.tblReservatieDataTable = reservatiebll.GetAllBeschikbareReservatiesInMaandByUserID(userID, maand)

        For Each reservatie As Reservaties.tblReservatieRow In reservaties
            'Auto ophalen
            Dim auto As Autos.tblAutoRow = autobll.GetAutoByAutoID(reservatie.autoID).Rows(0)

            'Nieuwe overzichtsrij
            Dim overzichtrij As Data.DataRow = weergavetabel.NewRow

            'Alle data invullen
            overzichtrij.Item("FiliaalID") = auto.filiaalID
            overzichtrij.Item("Kenteken") = auto.autoKenteken
            overzichtrij.Item("MerkModel") = autobll.GetAutoNaamByAutoID(auto.autoID)
            overzichtrij.Item("Parkeerplaats") = MaakParkeerPlaatsString(parkeerbll.GetParkeerPlaatsByID(auto.parkeerPlaatsID).Rows(0))
            overzichtrij.Item("Begindatum") = Date.Parse(reservatie.reservatieBegindat)
            overzichtrij.Item("Einddatum") = Date.Parse(reservatie.reservatieEinddat)
            overzichtrij.Item("Data") = String.Concat(reservatie.reservatieID, ",", auto.autoID)

            'Rij toevoegen
            weergavetabel.Rows.Add(overzichtrij)
        Next

        If (weergavetabel.Rows.Count = 0) Then
            Me.lblGeenReservaties.Text = "Er werden geen reservaties gevonden voor deze klant."
            Me.lblGeenReservaties.Visible = True
            Me.divReservatieOverzicht.Visible = False
        Else

            'Een beetje filteren op filiaal.

            'Eerst een lege tabel met dezelfde vorm klaarstomen
            Dim gefilterdetabel As Data.DataTable = weergavetabel.Clone()
            gefilterdetabel.Clear()

            'Dan alle rijen inlezen van de gefilterde weergavetabel
            For Each row As Data.DataRow In weergavetabel.Select(String.Concat("FiliaalID = ", Me.ddlFiliaal.SelectedValue))
                gefilterdetabel.ImportRow(row)
            Next

            If (gefilterdetabel.Rows.Count = 0) Then
                Me.lblGeenReservaties.Text = "Er werden geen reservaties gevonden voor deze klant voor deze filiaal."
                Me.lblGeenReservaties.Visible = True
                Me.divReservatieOverzicht.Visible = False
            Else
                Me.repReservatieOverzicht.DataSource = gefilterdetabel
                Me.repReservatieOverzicht.DataBind()
                Me.lblGeenReservaties.Visible = False
                Me.divReservatieOverzicht.Visible = True
            End If



        End If

    End Sub

    Private Function MaakParkeerPlaatsString(ByRef p As Autos.tblParkeerPlaatsRow) As String
        Dim kolommen() As String = MaakKolommenAan()
        Return String.Concat(kolommen(p.parkeerPlaatsKolom), p.parkeerPlaatsRij + 1)
    End Function

    Private Function MaakKolommenAan() As String()
        Dim beginkolommen() As String = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
        Dim totaalkolommen(675) As String

        Dim i As Integer = 0
        For Each letter In beginkolommen
            For Each tweedeletter In beginkolommen
                totaalkolommen(i) = String.Concat(letter, tweedeletter)
                i = i + 1
            Next
        Next

        Return totaalkolommen
    End Function

    Protected Sub repReservatieOverzicht_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles repReservatieOverzicht.ItemCommand
        Try
            Dim waardes() As String = e.CommandArgument.ToString.Split(",")
            Dim reservatieID As Integer = waardes(0)
            Dim autoID As Integer = waardes(1)

            Dim reservatiebll As New ReservatieBLL
            Dim reservatie As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(reservatieID).Rows(0)

            'Reservatiestatus 2 betekent: Uitgecheckt (maar nog niet teruggekomen!)
            reservatie.reservatieStatus = 2
            reservatie.reservatieUitgechecktDoorMedewerker = New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())

            If (reservatiebll.UpdateReservatie(reservatie)) Then
                'Gelukt!

                Dim autobll As New AutoBLL
                Dim auto As Autos.tblAutoRow = autobll.GetAutoByAutoID(autoID).Rows(0)
                auto.statusID = 6 'Verhuurd

                If (autobll.UpdateAuto(auto)) Then
                    'Gelukt!
                    Me.lblResultaat.Text = "De auto werd succesvol uitgecheckt."
                    Me.imgResultaat.ImageUrl = "~\App_Presentation\Images\tick.gif"
                    Me.divRepeater.Visible = False
                Else
                    Me.lblResultaat.Text = "Er was een probleem bij het aanpassen van de autogegevens. Contacteer de systeembeheerder."
                    Me.imgResultaat.ImageUrl = "~\App_Presentation\Images\remove.png"
                End If

            Else
                Me.lblResultaat.Text = "Er was een probleem bij het aanpassen van de reservatiegegevens. Contacteer de systeembeheerder."
                Me.imgResultaat.ImageUrl = "~\App_Presentation\Images\remove.png"
            End If

            Me.lblResultaat.Visible = True
            Me.imgResultaat.Visible = True

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub btnMaandVroeger_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMaandVroeger.Click
        MaakDatumFilter(-1)

        Dim userID As Guid = New Guid(ViewState("userID").ToString)

        HaalReservatieGegevensOpVanKlant(userID)
    End Sub

    Protected Sub btnMaandLater_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMaandLater.Click
        MaakDatumFilter(1)

        Dim userID As Guid = New Guid(ViewState("userID").ToString)

        HaalReservatieGegevensOpVanKlant(userID)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            Dim filiaalbll As New FiliaalBLL
            Me.ddlFiliaal.DataSource = filiaalbll.GetAllFilialen()
            Me.ddlFiliaal.DataValueField = "filiaalID"
            Me.ddlFiliaal.DataTextField = "filiaalNaam"
            Me.ddlFiliaal.DataBind()
            filiaalbll = Nothing
        End If

        Me.lblResultaat.Visible = False
        Me.imgResultaat.Visible = False

    End Sub

    Private Function MaakDatumFilter(Optional ByVal aantalMaanden As Integer = 0) As Date

        'Check of de viewStates bestaan
        If (ViewState("maand") Is Nothing) Then ViewState("maand") = Now.Month
        If (ViewState("jaar") Is Nothing) Then ViewState("jaar") = Now.Year

        'Check of parameter is meegegeven
        If (Not aantalMaanden = 0) Then

            If (ViewState("maand") + aantalMaanden = 13) Then
                'We willen naar januari van volgend jaar
                ViewState("jaar") = ViewState("jaar") + 1
                ViewState("maand") = 1
            ElseIf (ViewState("maand") + aantalMaanden = 0) Then
                'We willen naar december van vorig jaar
                ViewState("jaar") = ViewState("jaar") - 1
                ViewState("maand") = 12
            Else
                'We incrementeren / decrementeren de maand in de ViewState
                ' en slaan die opnieuw op.
                Dim tempmaand As Date = Date.Parse(String.Concat("01/", ViewState("maand"), "/", Now.Year))
                ViewState("maand") = DateAdd(DateInterval.Month, aantalMaanden, tempmaand).Month
            End If
        End If

        'De uiteindelijke maand aanmaken
        Dim maand As Date = Date.Parse(String.Concat("01/", ViewState("maand"), "/", ViewState("jaar")))

        'Maandfilter in het label gooien
        Me.lblReservatieOverzichtMaand.Text = Format(maand, "MMMM yyyy")

        Return maand
    End Function

    Protected Sub ddlFiliaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlFiliaal.SelectedIndexChanged
        Dim userID As Guid = New Guid(ViewState("userID").ToString)

        HaalReservatieGegevensOpVanKlant(userID)
    End Sub
End Class
