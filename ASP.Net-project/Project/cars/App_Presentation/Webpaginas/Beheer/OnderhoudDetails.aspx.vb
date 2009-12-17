
Partial Class App_Presentation_Webpaginas_Beheer_OnderhoudDetails
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.divError.Visible = False
        If Request.QueryString("controleID") IsNot Nothing Then
            Try
                Dim controleID As Integer = Convert.ToInt32(Request.QueryString("controleID"))

                Me.repOnderhoudBeschadiging.DataSource = MaakOverzichtsDataTable()
                Me.repOnderhoudBeschadiging.DataBind()

            Catch ex As Exception
                Me.updOnderhoudDetails.Visible = False
                Me.divError.Visible = True
                Me.lblFout.Text = "Een belangrijke parameter (controleID) werd incorrect meegegeven."
                Return
            End Try
        Else
            Me.updOnderhoudDetails.Visible = False
            Me.divError.Visible = True
            Me.lblFout.Text = "Een belangrijke parameter (controleID) werd incorrect meegegeven."
            Return
        End If
    End Sub

    Private Function MaakOverzichtsDataTable() As Data.DataTable
        Try
            Dim controleID As Integer = Convert.ToInt32(Request.QueryString("controleID"))

            Dim controlebll As New ControleBLL
            Dim c As Onderhoud.tblControleRow = controlebll.GetControleByControleID(controleID)

            Me.lblBeginDatum.Text = c.controleBegindat
            Me.lblEindDatum.Text = c.controleEinddat

            Dim klantbll As New KlantBLL
            Dim m As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(c.medewerkerID).Rows(0)

            Me.lblMedewerker.Text = String.Concat(m.userNaam, " ", m.userVoornaam)

            If c.controleIsNazicht Then
                Me.lblBrandstofkost.Text = c.controleBrandstofkost
                Me.divNazicht.Visible = True
                Me.lblWasNazicht.Text = "Ja"
            Else
                Me.divNazicht.Visible = False
                Me.lblWasNazicht.Text = "Nee"
            End If


            Dim beschadigingbll As New BeschadigingBLL
            Dim beschadigingen As Onderhoud.tblAutoBeschadigingDataTable = beschadigingbll.GetAllBeschadigingByControleID(controleID)

            Dim overzichtdatatable As New Data.DataTable
            Dim overzichtrow As Data.DataRow
            'Eigen kolommen toevoegen
            overzichtdatatable.Columns.Add("Klant", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Omschrijving", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("IsHersteld", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Kost", Type.GetType("System.String"))

            'Data overzetten

            For Each beschadiging As Onderhoud.tblAutoBeschadigingRow In beschadigingen
                overzichtrow = overzichtdatatable.NewRow

                Dim p As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(beschadiging.beschadigingAangerichtDoorKlant).Rows(0)
                overzichtrow.Item("Klant") = String.Concat(p.userNaam, " ", p.userVoornaam)
                overzichtrow.Item("Omschrijving") = beschadiging.beschadigingOmschrijving

                If beschadiging.beschadigingIsHersteld Then
                    overzichtrow.Item("IsHersteld") = "Ja"
                    overzichtrow.Item("Kost") = beschadiging.beschadigingKost
                Else
                    overzichtrow.Item("IsHersteld") = "Nee"
                    overzichtrow.Item("Kost") = "Niet hersteld"
                End If

            Next

            If overzichtdatatable.Rows.Count = 0 Then
                Me.divBeschadigingen.Visible = False
            Else
                Me.divBeschadigingen.Visible = True
            End If

            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
