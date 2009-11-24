
Partial Class App_Presentation_NieuweReservatieAanmaken
    Inherits System.Web.UI.Page

    Protected Overrides Sub Render(ByVal writer As System.Web.UI.HtmlTextWriter)

        'Page.ClientScript.RegisterForEventValidation(ddlCategorie.UniqueID, "")
        'Page.ClientScript.RegisterForEventValidation(ddlKleur.UniqueID, "")
        'Page.ClientScript.RegisterForEventValidation(txtBegindatum.UniqueID, "")
        'Page.ClientScript.RegisterForEventValidation(txtEinddatum.UniqueID, "")
        MyBase.Render(writer)

    End Sub

    Protected Sub txtEinddatum_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtEinddatum.TextChanged
        'ChangeOverView()
    End Sub

    Protected Sub txtBegindatum_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtBegindatum.TextChanged
        'ChangeOverView()
    End Sub

    Protected Sub ddlCategorie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCategorie.SelectedIndexChanged
        'ResetddlKleur()
        'updOverview.Update()
        'System.Threading.Thread.Sleep(1000)
        'ChangeOverView()
    End Sub

    Protected Sub ddlKleur_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlKleur.SelectedIndexChanged
        'ChangeOverView()
    End Sub

    Private Function MaakOverzichtsDataTable(ByRef datatable As Auto_s.tblAutoDataTable) As Data.DataTable
        Try
            Dim overzichtdatatable As New Data.DataTable
            Dim overzichtcolumn As New Data.DataColumn
            Dim overzichtrow As Data.DataRow

            'Kolommen van originele tabel overkopiëren
            Dim columnnaam As String = String.Empty
            Dim columntype As System.Type
            For i As Integer = 0 To datatable.Columns.Count - 1
                columnnaam = datatable.Columns(i).ColumnName
                columntype = datatable.Columns(i).DataType
                overzichtdatatable.Columns.Add(columnnaam, columntype)
            Next

            'Eigen kolommen toevoegen
            overzichtdatatable.Columns.Add("modelnaam", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("fotoID", Type.GetType("System.Int32"))
            overzichtdatatable.Columns.Add("begindat", Type.GetType("System.DateTime"))
            overzichtdatatable.Columns.Add("einddat", Type.GetType("System.DateTime"))
            overzichtdatatable.Columns.Add("klantID", Type.GetType("System.Int32"))

            'Data overzetten
            Dim autobll As New AutoBLL
            Dim klantbll As New KlantBLL
            For i As Integer = 0 To datatable.Rows.Count - 1
                overzichtrow = overzichtdatatable.NewRow()

                overzichtrow("autoID") = datatable.Rows(i).Item("autoID")
                overzichtrow("autoKenteken") = datatable.Rows(i).Item("autoKenteken")
                overzichtrow("autoKleur") = datatable.Rows(i).Item("autoKleur")
                overzichtrow("fotoID") = autobll.GetFotoIDByAutoID(overzichtrow("autoID"))
                overzichtrow("modelnaam") = autobll.GetModelNameByModelID(datatable.Rows(i).Item("modelID"))
                overzichtrow("begindat") = Date.Parse(Me.txtBegindatum.Text)
                overzichtrow("einddat") = Date.Parse(Me.txtEinddatum.Text)
                overzichtrow("klantID") = klantbll.GetKlantIDByKlantNaam(User.Identity.Name)

                overzichtdatatable.Rows.Add(overzichtrow)
            Next

            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Sub ResetddlKleur()
        ddlKleur.SelectedValue = 0
        ccdKleur.SelectedValue = 0
    End Sub

    Private Sub ChangeOverView()
        'Haal argumenten uit form
        updOverview.Update()

        Dim categorie As String = Me.ddlCategorie.SelectedValue
        Dim begindatum As Date = Me.txtBegindatum.Text
        Dim einddatum As Date = Me.txtEinddatum.Text
        Dim kleur As String = Me.ddlKleur.SelectedItem.Text
        Dim merk As String = Me.ddlMerk.SelectedValue

        'ff valideren
        Dim geenfouteninpagina As Boolean = True
        lblCategorieVerkeerd.Text = String.Empty
        lblDatumVerkeerd.Text = String.Empty

        If (categorie = String.Empty) Then
            lblDatumVerkeerd.ForeColor = Drawing.Color.Red
            lblCategorieVerkeerd.Text = "U dient een geldige categorie op te geven."
            geenfouteninpagina = False
        End If

        If (begindatum > einddatum) Then
            lblDatumVerkeerd.ForeColor = Drawing.Color.Red
            lblDatumVerkeerd.Text = "De begindatum kan niet later vallen dan de einddatum."
            geenfouteninpagina = False
        End If

        If (geenfouteninpagina) Then
            Try
                'Zet array met filteropties in elkaar
                Dim filterOpties(10) As String
                filterOpties(0) = categorie
                filterOpties(1) = kleur
                filterOpties(2) = merk
                'automodel = filterOpties(3)
                'brandstoftype = filterOpties(4)
                'bouwjaar = filterOpties(5)

                'Haal datatable op met argumenten
                Dim autobll As New AutoBLL
                Dim datatable As Auto_s.tblAutoDataTable = autobll.GetBeschikbareAutosBy(begindatum, einddatum, filterOpties)

                'Verwerk datatable tot overzichtsdatatable
                Dim dt As Data.DataTable = MaakOverzichtsDataTable(datatable)

                If (dt.Rows.Count > 0) Then
                    lblGeenAutos.Visible = False
                    repOverzicht.DataSource = dt
                Else
                    lblGeenAutos.Text = "Er zijn geen auto's die aan uw zoekvoorwaarden voldoen."
                    lblGeenAutos.Visible = True
                End If
            Catch ex As Exception
                Throw ex
            End Try

        Else
            repOverzicht.DataSource = Nothing
        End If

        repOverzicht.DataBind()

    End Sub

    Protected Sub btnToonOverzicht_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnToonOverzicht.Click
        ChangeOverView()
    End Sub
End Class
