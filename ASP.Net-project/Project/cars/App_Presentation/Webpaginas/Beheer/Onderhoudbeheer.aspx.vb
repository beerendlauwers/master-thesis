
Partial Class App_Presentation_Webpaginas_Beheer_Onderhoudbeheer
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Not IsPostBack) Then

            'Alle kentekens ophalen
            DDlAutosVullen()

            'Alle tabs invullen op basis van de eerste optie
            KalenderVullenByAuto(Me.ddlAutos.SelectedValue)
            ToekomstigOnderhoudVullenByAuto(Me.ddlAutos.SelectedValue)
            OnderhoudshistoriekVullenByAuto(Me.ddlAutos.SelectedValue)

            'Onderhoud van vandaag invullen
            OnderhoudVanVandaagVullen()
        End If

    End Sub

    Private Sub ToekomstigOnderhoudVullenByAuto(ByVal autoID As Integer)

        Dim onderhoudbll As New OnderhoudBLL
        Dim autobll As New AutoBLL
        Dim onderhouden As Onderhoud.tblNodigOnderhoudDataTable = onderhoudbll.GetAllToekomstigNodigOnderhoudByAutoID(autoID)

        Dim auto As Autos.tblAutoRow = autobll.GetAutoByAutoID(autoID).Rows(0)
        Me.lblAuto.Text = autobll.GetAutoNaamByAutoID(auto.autoID)

        If (onderhouden.Rows.Count = 0) Then
            Me.divToekomstigOnderhoud.Visible = False
            Me.lblGeenToekomstigOnderhoud.Text = "Er zijn geen toekomstige onderhouden voor deze auto."
            Me.lblGeenToekomstigOnderhoud.Visible = True
        End If

        'Dit is onze weergavetabel.
        Dim weergavetabel As New Data.DataTable
        weergavetabel.Columns.Add("Begindatum", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Einddatum", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Omschrijving", Type.GetType("System.String"))
        weergavetabel.Columns.Add("controleID", Type.GetType("System.Int32"))

        For Each onderhoud As Onderhoud.tblNodigOnderhoudRow In onderhouden
            'Nieuwe overzichtsrij
            Dim overzichtrij As Data.DataRow = weergavetabel.NewRow

            'Alle data invullen
            overzichtrij.Item("Begindatum") = Format(onderhoud.nodigOnderhoudBegindat, "dd/MM/yyyy")
            overzichtrij.Item("Einddatum") = Format(onderhoud.nodigOnderhoudEinddat, "dd/MM/yyyy")
            overzichtrij.Item("Omschrijving") = onderhoud.nodigOnderhoudOmschrijving
            overzichtrij.Item("controleID") = onderhoud.controleID

            'Rij toevoegen
            weergavetabel.Rows.Add(overzichtrij)
        Next onderhoud

        If (weergavetabel.Rows.Count = 0) Then
            Me.divToekomstigOnderhoud.Visible = False
            Me.lblGeenToekomstigOnderhoud.Text = "Er zijn geen toekomstige onderhouden voor deze auto."
            Me.lblGeenToekomstigOnderhoud.Visible = True
        Else
            Me.repToekomstigOnderhoud.DataSource = weergavetabel
            Me.repToekomstigOnderhoud.DataBind()
            Me.divToekomstigOnderhoud.Visible = True
            Me.lblGeenToekomstigOnderhoud.Visible = False
        End If
    End Sub

    Private Sub DDlAutosVullen()
        Dim autobll As New AutoBLL
        Dim autos As Autos.tblAutoDataTable = autobll.GetAllAutos()
        Me.ddlAutos.DataSource = autos
        Me.ddlAutos.DataBind()
        autobll = Nothing
    End Sub

    Private Sub OnderhoudVanVandaagVullen()

        Dim onderhoudbll As New OnderhoudBLL
        Dim autobll As New AutoBLL
        Dim onderhouden As Onderhoud.tblNodigOnderhoudDataTable = onderhoudbll.GetAllNodigOnderhoudVoorVandaag()

        'Dit is onze weergavetabel.
        Dim weergavetabel As New Data.DataTable
        weergavetabel.Columns.Add("Kenteken", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Begindatum", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Einddatum", Type.GetType("System.String"))
        weergavetabel.Columns.Add("MerkModel", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Omschrijving", Type.GetType("System.String"))
        weergavetabel.Columns.Add("controleID", Type.GetType("System.Int32"))

        For Each onderhoud As Onderhoud.tblNodigOnderhoudRow In onderhouden
            'Auto ophalen
            Dim auto As Autos.tblAutoRow = autobll.GetAutoByAutoID(onderhoud.autoID).Rows(0)

            'Nieuwe overzichtsrij
            Dim overzichtrij As Data.DataRow = weergavetabel.NewRow

            'Alle data invullen
            overzichtrij.Item("Kenteken") = auto.autoKenteken
            overzichtrij.Item("MerkModel") = autobll.GetAutoNaamByAutoID(auto.autoID)
            overzichtrij.Item("Begindatum") = Format(onderhoud.nodigOnderhoudBegindat, "dd/MM/yyyy")
            overzichtrij.Item("Einddatum") = Format(onderhoud.nodigOnderhoudEinddat, "dd/MM/yyyy")
            overzichtrij.Item("Omschrijving") = onderhoud.nodigOnderhoudOmschrijving
            overzichtrij.Item("controleID") = onderhoud.controleID

            'Rij toevoegen
            weergavetabel.Rows.Add(overzichtrij)
        Next onderhoud

        If (weergavetabel.Rows.Count = 0) Then
            Me.divOnderhoudVandaag.Visible = False
            Me.lblGeenOnderhoudVandaag.Text = "Er zijn geen geplande onderhouden voor vandaag."
            Me.lblGeenOnderhoudVandaag.Visible = True
        Else
            Me.repOnderhoudVoorVandaag.DataSource = weergavetabel
            Me.repOnderhoudVoorVandaag.DataBind()
            Me.divOnderhoudVandaag.Visible = True
            Me.lblGeenOnderhoudVandaag.Visible = False
        End If

    End Sub

    Private Sub OnderhoudshistoriekVullenByAuto(ByVal autoID As Integer)

        Dim controlebll As New ControleBLL
        Dim autobll As New AutoBLL
        Dim oudecontroles As Onderhoud.tblControleDataTable = controlebll.GetAllOudeControlesByAutoID(autoID)

        If (oudecontroles.Rows.Count = 0) Then
            Me.divOnderhoudsHistoriek.Visible = False
            Me.lblGeenOnderhoudsHistoriek.Text = "Er werden geen oude onderhouden gevonden voor deze auto."
            Me.lblGeenOnderhoudsHistoriek.Visible = True
        End If

        'Dit is onze weergavetabel.
        Dim weergavetabel As New Data.DataTable
        weergavetabel.Columns.Add("Begindatum", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Einddatum", Type.GetType("System.String"))
        weergavetabel.Columns.Add("IsNazicht", Type.GetType("System.String"))
        weergavetabel.Columns.Add("controleID", Type.GetType("System.Int32"))

        Dim auto As Autos.tblAutoRow = autobll.GetAutoByAutoID(autoID).Rows(0)
        For Each controle As Onderhoud.tblControleRow In oudecontroles
            'Nieuwe overzichtsrij
            Dim overzichtrij As Data.DataRow = weergavetabel.NewRow

            'Alle data invullen
            overzichtrij.Item("Begindatum") = Format(controle.controleEinddat, "dd/MM/yyyy")
            overzichtrij.Item("Einddatum") = Format(controle.controleEinddat, "dd/MM/yyyy")
            If (controle.controleIsNazicht) Then
                overzichtrij.Item("IsNazicht") = "Ja"
            Else
                overzichtrij.Item("IsNazicht") = "Nee"
            End If
            overzichtrij.Item("controleID") = controle.controleID

            'Rij toevoegen
            weergavetabel.Rows.Add(overzichtrij)
        Next controle

        If (weergavetabel.Rows.Count = 0) Then
            Me.divOnderhoudsHistoriek.Visible = False
            Me.lblGeenOnderhoudsHistoriek.Text = "Er werden geen oude onderhouden gevonden voor deze auto."
            Me.lblGeenOnderhoudsHistoriek.Visible = True
        Else
            Me.repOnderhoudsHistoriek.DataSource = weergavetabel
            Me.repOnderhoudsHistoriek.DataBind()
            Me.divOnderhoudsHistoriek.Visible = True
            Me.lblGeenOnderhoudsHistoriek.Visible = False
        End If
    End Sub

    Private Sub KalenderVullenByAuto(ByVal autoID As Integer)

        Dim reservatiebll As New ReservatieBLL
        'Alle reservaties van deze auto ophalen en opslaan
        Session("autoReservaties") = reservatiebll.GetAllReservatiesByAutoID(autoID)
        reservatiebll = Nothing

        'Nodig onderhoud ophalen en opslaan
        Dim onderhoudbll As New OnderhoudBLL
        Session("autoOnderhoud") = onderhoudbll.GetAllNodigOnderhoudByAutoID(autoID)
        onderhoudbll = Nothing

    End Sub

    Protected Sub ddlAutos_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAutos.SelectedIndexChanged
        KalenderVullenByAuto(Me.ddlAutos.SelectedValue)
        ToekomstigOnderhoudVullenByAuto(Me.ddlAutos.SelectedValue)
        OnderhoudshistoriekVullenByAuto(Me.ddlAutos.SelectedValue)
    End Sub

    Protected Sub calAutoSchema_DayRender(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DayRenderEventArgs) Handles calAutoSchema.DayRender

        Try

            e.Cell.Text = e.Day.DayNumberText

            Dim reservaties As Reservaties.tblReservatieDataTable = CType(Session("autoReservaties"), Reservaties.tblReservatieDataTable)
            Dim onderhoud As Onderhoud.tblNodigOnderhoudDataTable = CType(Session("autoOnderhoud"), Onderhoud.tblNodigOnderhoudDataTable)

            If reservaties IsNot Nothing Then
                For Each res As Reservaties.tblReservatieRow In reservaties
                    If (e.Day.Date >= res.reservatieBegindat And e.Day.Date <= res.reservatieEinddat) Then
                        e.Cell.BackColor = Drawing.ColorTranslator.FromHtml("#A87B5D")
                        e.Cell.Text = e.Day.DayNumberText
                        Dim img As New Image
                        img.ImageUrl = "~\App_Presentation\Images\car.png"
                        e.Cell.Controls.Add(img)
                    End If
                Next res
            End If

            If onderhoud IsNot Nothing Then
                For Each o As Onderhoud.tblNodigOnderhoudRow In onderhoud
                    If (e.Day.Date >= o.nodigOnderhoudBegindat And e.Day.Date <= o.nodigOnderhoudEinddat) Then
                        e.Cell.BackColor = Drawing.ColorTranslator.FromHtml("#ACC3D2")
                        e.Cell.Text = e.Day.DayNumberText

                        Dim img As New Image
                        img.ImageUrl = "~\App_Presentation\Images\wrench.png"
                        e.Cell.Controls.Add(img)

                    End If
                Next o
            End If


        Catch
        End Try

    End Sub

    Protected Sub btnOnderhoudPlannen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOnderhoudPlannen.Click

        If OnderhoudPlannenFormulierIsGeldig() Then

            Dim controlebll As New ControleBLL
            Dim dt As New Onderhoud.tblControleDataTable
            Dim c As Onderhoud.tblControleRow = dt.NewRow

            c.autoID = Me.ddlAutos.SelectedValue
            c.reservatieID = -999
            c.controleBegindat = Date.Parse(Me.txtBegindatum.Text)
            c.controleEinddat = Date.Parse(Me.txtEinddatum.Text)
            c.controleIsNazicht = 0
            c.controleKilometerstand = 0
            c.controleBrandstofkost = 0
            c.medewerkerID = New Guid("7a73f865-ec29-4efd-bf09-70a9f9493d21")
            c.controleIsUitgevoerd = 0
            Dim omschrijving As String = Me.txtOmschrijving.Innertext

            If controlebll.InsertGeplandeControle(c, omschrijving) Then
                'Gelukt!
                Me.lblFeedback.Text = "Onderhoud gepland."
                Me.imgFeedback.ImageURL = "~\App_Presentation\Images\tick.gif"
                Me.lblfeedback.forecolor = Drawing.Color.Green

                KalenderVullenByAuto(Me.ddlAutos.SelectedValue)
                ToekomstigOnderhoudVullenByAuto(Me.ddlAutos.SelectedValue)
                OnderhoudshistoriekVullenByAuto(Me.ddlAutos.SelectedValue)
            End If

        End If

    End Sub

    Private Function OnderhoudPlannenFormulierIsGeldig() As Boolean
        Me.lblFeedback.Text = String.Empty
        Me.imgFeedback.ImageURL = "~\App_Presentation\Images\spacer.gif"
        Me.lblfeedback.forecolor = Drawing.Color.Red

        Dim begindat, einddat As Date

        Try
            begindat = Date.Parse(Me.txtBegindatum.Text)
            einddat = Date.Parse(Me.txtEinddatum.Text)
        Catch
            Me.lblFeedback.Text = "Gelieve in beide velden een geldige datum te zetten."
            Me.imgFeedback.ImageURL = "~\App_Presentation\Images\remove.png"
            Return False
        End Try

        If begindat.Date < Now.Date Or einddat.Date < Now.Date Then
            Me.lblFeedback.Text = "Een gepland onderhoud kan niet in het verleden gebeuren."
            Me.imgFeedback.ImageURL = "~\App_Presentation\Images\remove.png"
            Return False
        End If

        If begindat > einddat Then
            Me.lblFeedback.Text = "De begindatum kan niet later vallen dan de einddatum."
            Me.imgFeedback.ImageURL = "~\App_Presentation\Images\remove.png"
            Return False
        End If

        If Me.txtOmschrijving.Innertext = String.Empty Then
            Me.lblFeedback.Text = "Gelieve het omschrijvingsveld in te vullen."
            Me.imgFeedback.ImageURL = "~\App_Presentation\Images\remove.png"
            Return False
        End If

        Dim autobll As New AutoBLL
        Dim tempdt As Autos.tblAutoDataTable = autobll.GetGeldigeAutosVoorPeriode(begindat, einddat, autobll.GetAutoByAutoID(Me.ddlAutos.SelectedValue))
        autobll = Nothing

        If tempdt.Rows.Count = 0 Then
            Me.lblFeedback.Text = "Deze auto is reeds bezet gedurende deze periode."
            Me.imgFeedback.ImageURL = "~\App_Presentation\Images\remove.png"
            Return False
        End If

        Return True
    End Function

End Class
