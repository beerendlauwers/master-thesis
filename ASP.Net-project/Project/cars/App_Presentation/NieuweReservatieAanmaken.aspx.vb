
Partial Class App_Presentation_NieuweReservatieAanmaken
    Inherits System.Web.UI.Page

    Protected Overrides Sub Render(ByVal writer As System.Web.UI.HtmlTextWriter)

        Page.ClientScript.RegisterForEventValidation(ddlCategorie.UniqueID, "")
        Page.ClientScript.RegisterForEventValidation(txtBegindatum.UniqueID, "")
        Page.ClientScript.RegisterForEventValidation(txtEinddatum.UniqueID, "")
        MyBase.Render(writer)

    End Sub

    Protected Sub txtEinddatum_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtEinddatum.TextChanged
        ChangeOverView()
    End Sub

    Protected Sub txtBegindatum_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtBegindatum.TextChanged
       ChangeOverView()
    End Sub

    Protected Sub ddlCategorie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCategorie.SelectedIndexChanged
         ChangeOverView()
    End Sub

    Private Function MaakOverzichtsDataTable(ByRef datatable As Auto_s.tblAutoDataTable) As Data.DataTable

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

        'Data overzetten
        Dim autobll As New AutoBLL
        For i As Integer = 0 To datatable.Rows.Count - 1
            overzichtrow = overzichtdatatable.NewRow()

            overzichtrow("autoID") = datatable.Rows(i).Item("autoID")
            overzichtrow("autoFoto") = datatable.Rows(i).Item("autoFoto")
            overzichtrow("modelnaam") = autobll.GetModelNameByModelID(datatable.Rows(i).Item("modelID"))

            overzichtdatatable.Rows.Add(overzichtrow)
        Next

        Return overzichtdatatable
    End Function


    Private Sub ChangeOverView()
        'Haal argumenten uit form
        Dim categorie As String = Me.ddlCategorie.SelectedValue
        Dim begindatum As Date = Me.txtBegindatum.Text
        Dim einddatum As Date = Me.txtEinddatum.Text
        Dim kleur As String = Me.ddlKleur.Text

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
            'Haal datatable op met argumenten
            Dim autobll As New AutoBLL
            Dim datatable As Auto_s.tblAutoDataTable = autobll.GetBeschikbareAutosBy(categorie, begindatum, einddatum, kleur)

            'Verwerk datatable tot overzichtsdatatable
            repOverzicht.DataSource = MaakOverzichtsDataTable(datatable)
        Else
            repOverzicht.DataSource = Nothing
        End If
        repOverzicht.DataBind()

    End Sub

    Protected Sub btnOverzicht_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOverzicht.Click
        If (Page.IsValid) Then
            ChangeOverView()
        End If
    End Sub

    Protected Sub ddlKleur_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlKleur.SelectedIndexChanged
        ChangeOverView()
    End Sub
End Class
