
Partial Class App_Presentation_Webpaginas_Beheer_AutoInchecken
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            Me.lblDatum.Text = DateTime.Now.Date()

            Me.chkProblematisch.Checked = False

            Dim filiaalbll As New FiliaalBLL
            Me.ddlFiliaal.DataSource = filiaalbll.GetAllFilialen()
            Me.ddlFiliaal.DataValueField = "filiaalID"
            Me.ddlFiliaal.DataTextField = "filiaalNaam"
            Me.ddlFiliaal.DataBind()
            filiaalbll = Nothing

        End If

    End Sub

    Protected Sub cmdCheckIn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmdCheckIn.Click

        Try

            ' Reservatie ophalen
            Dim BLLReservatie As New ReservatieBLL
            Dim r As Reservaties.tblReservatieRow = BLLReservatie.GetReservatieByReservatieID(ViewState("reservatieID"))

            ' Auto ophalen
            Dim BLLAuto As New AutoBLL
            Dim a As Autos.tblAutoRow = BLLAuto.GetAutoByAutoID(r.autoID).Rows(0)

            ' Klant ophalen
            Dim BLLKlant As New KlantBLL
            Dim DTKlant As Klanten.tblUserProfielDataTable = BLLKlant.GetUserProfielByUserID(r.userID)
            Dim p As Klanten.tblUserProfielRow

            If DTKlant.Rows.Count > 0 Then
                p = DTKlant.Rows(0)
            Else
                lblResultaat.Text = "Er was een probleem met het ophalen van de profielgegevens. Vraag de klant deze gegevens na te kijken."
            End If

            ' Instellen Gegevens

            ' Reservatie
            ' Reservatiestatus 4 betekent: uitgecheckt en opnieuw ingecheckt
            r.reservatieStatus = 4
            r.reservatieIngechecktDoorMedewerker = New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())

            ' Autostatus veranderen naar 'Beschikbaar'
            a.statusID = 1

            ' Klant
            p.userIsProblematisch = Me.chkProblematisch.Checked

            If p.userIsProblematisch Then
                p.userCommentaar = Me.txtCommentaar.InnerText
            End If

            ' Wegschrijven gegevens
            If (BLLReservatie.UpdateReservatie(r)) Then
                'Gelukt!

                If (BLLAuto.UpdateAuto(a)) Then
                    'Gelukt!
                    lblResultaat.Text = "De auto werd succesvol ingecheckt."
                Else
                    lblResultaat.Text = "Er was een probleem bij het aanpassen van de autogegevens. Contacteer de systeembeheerder."
                End If

                If (BLLKlant.UpdateUserProfiel(p)) Then
                    'Gelukt!
                    lblResultaat.Text = "De auto werd succesvol ingecheckt."
                    Me.divIncheckFormulier.Visible = False
                Else
                    lblResultaat.Text = "Er was een probleem bij het aanpassen van de klantgegevens. Contacteer de systeembeheerder."
                End If

            Else
                lblResultaat.Text = "Er was een probleem bij het aanpassen van de reservatiegegevens. Contacteer de systeembeheerder."
            End If

            Me.lblResultaat.Visible = True

        Catch ex As Exception
            Throw ex
        End Try


    End Sub

    Protected Sub btnToonReservaties_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnToonReservaties.Click

        Me.lblError.Text = String.Empty

        If (Not Me.txtNaam.Text = String.Empty And Not Me.txtVoornaam.Text = String.Empty) Then
            ZoekOpNaamEnVoornaam(Me.txtNaam.Text, Me.txtVoornaam.Text)
        ElseIf (Not Me.txtRijbewijs.Text = String.Empty) Then
            ZoekOpRijbewijs(Me.txtRijbewijs.Text)
        ElseIf (Not Me.txtIdenteitskaart.Text = String.Empty) Then
            ZoekOpIdentiteitsKaart(Me.txtIdenteitskaart.Text)
        Else
            Me.lblError.Text = "Gelieve een filteroptie te kiezen."
            Return
        End If

        Me.divIncheckFormulier.Visible = False
    End Sub

    Private Sub ZoekOpNaamEnVoornaam(ByVal naam As String, ByVal voornaam As String)
        Dim klantbll As New KlantBLL

        Dim profiel As Klanten.tblUserProfielDataTable = klantbll.GetUserProfielByNaamEnVoornaam(naam, voornaam)

        If (profiel.Rows.Count = 0) Then
            Me.lblError.Text = "Er werd geen klant gevonden op deze combinatie van naam en voornaam."
            Return
        Else
            Dim p As Klanten.tblUserProfielRow = profiel.Rows(0)

            Me.chkProblematisch.Checked = p.userIsProblematisch

            ViewState("userID") = p.userID
            VulReservaties()
        End If
    End Sub

    Private Sub ZoekOpRijbewijs(ByVal rijbewijs As String)
        Dim klantbll As New KlantBLL

        Dim profiel As Klanten.tblUserProfielDataTable = klantbll.GetUserProfielByRijbewijs(rijbewijs)

        If (profiel.Rows.Count = 0) Then
            Me.lblError.Text = "Er werd geen klant gevonden die dit rijbewijsnummer heeft."
            Return
        Else
            Dim p As Klanten.tblUserProfielRow = profiel.Rows(0)

            Me.chkProblematisch.Checked = p.userIsProblematisch

            ViewState("userID") = p.userID
            VulReservaties()
        End If
    End Sub

    Private Sub ZoekOpIdentiteitsKaart(ByVal identiteitskaartnr As String)
        Dim klantbll As New KlantBLL

        Dim profiel As Klanten.tblUserProfielDataTable = klantbll.GetUserProfielByIdentiteitskaartNr(identiteitskaartnr)

        If (profiel.Rows.Count = 0) Then
            Me.lblError.Text = "Er werd geen klant gevonden die dit identiteitskaartnummer heeft."
            Return
        Else
            Dim p As Klanten.tblUserProfielRow = profiel.Rows(0)

            Me.chkProblematisch.Checked = p.userIsProblematisch

            ViewState("userID") = p.userID
            VulReservaties()
        End If


    End Sub

    Private Sub VulReservaties()

        Dim userID As New Guid(ViewState("userID").ToString)

        Dim reservatiebll As New ReservatieBLL
        Dim autobll As New AutoBLL
        Dim parkeerbll As New ParkeerBLL

        'Dit is onze weergavetabel.
        Dim weergavetabel As New Data.DataTable
        weergavetabel.Columns.Add("FiliaalID", Type.GetType("System.Int32"))
        weergavetabel.Columns.Add("Kenteken", Type.GetType("System.String"))
        weergavetabel.Columns.Add("MerkModel", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Parkeerplaats", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Begindatum", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Einddatum", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Data", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Display", Type.GetType("System.String"))

        'Alle uitgecheckte (reservatieStatus = 2) reservaties voor onze klant ophalen.
        Dim reservaties As Reservaties.tblReservatieDataTable = reservatiebll.GetAllUitgecheckteReservatiesByUserID(userID)

        For Each reservatie As Reservaties.tblReservatieRow In reservaties
            'Auto ophalen
            Dim auto As Autos.tblAutoRow = autobll.GetAutoByAutoID(reservatie.autoID).Rows(0)

            'Nieuwe overzichtsrij
            Dim overzichtrij As Data.DataRow = weergavetabel.NewRow

            'Alle data invullen
            overzichtrij.Item("FiliaalID") = auto.filiaalID
            overzichtrij.Item("Kenteken") = auto.autoKenteken
            overzichtrij.Item("MerkModel") = autobll.GetAutoNaamByAutoID(auto.autoID)
            overzichtrij.Item("Begindatum") = Format(reservatie.reservatieBegindat, "dd/MM/yyyy")
            overzichtrij.Item("Einddatum") = Format(reservatie.reservatieEinddat, "dd/MM/yyyy")
            overzichtrij.Item("Data") = String.Concat(reservatie.reservatieID, ",", auto.autoID)

            If ViewState("geselecteerdeAuto") IsNot Nothing Then
                If (ViewState("geselecteerdeAuto") = auto.autoID) Then
                    overzichtrij.Item("Display") = "Inline"
                Else
                    overzichtrij.Item("Display") = "None"
                End If
            Else
                overzichtrij.Item("Display") = "None"
            End If

            'Rij toevoegen
            weergavetabel.Rows.Add(overzichtrij)
        Next

        If (weergavetabel.Rows.Count = 0) Then
            Me.lblGeenReservaties.Text = "Er werden geen reservaties gevonden voor deze klant."
            Me.lblGeenReservaties.Visible = True
            Me.divReservatieOverzicht.Visible = False
        Else

            ViewState("geselecteerdeAuto") = -1

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

    Protected Sub ddlFiliaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlFiliaal.SelectedIndexChanged
        VulReservaties()
        Me.divIncheckFormulier.Visible = False
    End Sub


    Protected Sub repReservatieOverzicht_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles repReservatieOverzicht.ItemCommand
        Try
            Dim waardes() As String = e.CommandArgument.ToString.Split(",")
            Dim reservatieID As Integer = waardes(0)
            Dim autoID As Integer = waardes(1)

            ViewState("autoID") = autoID
            ViewState("reservatieID") = reservatieID

            ViewState("geselecteerdeAuto") = autoID

            Me.divIncheckFormulier.Visible = True

            VulReservaties()
            Me.lblBoete.Text = String.Concat(BerekenBoete(), " €")

        Catch
        End Try
    End Sub

    Private Function BerekenBoete() As Double
        Dim reservatiebll As New ReservatieBLL
        Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(ViewState("reservatieID"))

        Dim uur As Integer = 9
        Dim dag As Integer = r.reservatieEinddat.Day
        Dim maand As Integer = r.reservatieEinddat.Month
        Dim jaar As Integer = r.reservatieEinddat.Year
        Dim GeenBoeteAlsIngechecktVoorDatum As Date = Date.Parse(String.Concat(dag, "/", maand, "/", jaar, " ", uur, ":00:00"))
        If (GeenBoeteAlsIngechecktVoorDatum > Me.lblDatum.Text) Then
            'Man die kerel heeft geluk
            Return 0
        End If

        Dim autobll As New AutoBLL
        Dim a As Autos.tblAutoRow = autobll.GetAutoByAutoID(ViewState("autoID")).Rows(0)

        Return (Date.Parse(Me.lblDatum.Text) - r.reservatieEinddat).TotalDays * a.autoDagTarief
    End Function

    Protected Sub chkProblematisch_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkProblematisch.CheckedChanged
        Me.divCommentaarVak.Visible = Me.chkProblematisch.Checked
    End Sub


End Class
