
Partial Class App_Presentation_ArtikelBewerken
    Inherits System.Web.UI.Page
    Private artikel As New ArtikelDAL

    Protected Sub btnZoek_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoek.Click
        Dim str As String
        Dim dt As New Data.DataTable

        str = "%" + txtSearch.Text + "%"
        dt = artikel.getArtikelsByTitel(str)
        txtTitel.Text = dt.Rows(0)("titel")
        txtTag.Text = dt.Rows(0)("tag")
        Editor1.Content = dt.Rows(0)("tekst")
        ddlBedrijf.SelectedValue = dt.Rows(0)("FK_Bedrijf")
    End Sub
End Class
