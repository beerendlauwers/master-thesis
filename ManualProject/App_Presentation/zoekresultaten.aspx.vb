
Partial Class App_Presentation_zoekresultaten
    Inherits System.Web.UI.Page
    Dim artikeldal As New ArtikelDAL


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim tag As String
        If Request.QueryString("tag") IsNot Nothing Then
            tag = "%" + Request.QueryString("tag") + "%"
            Dim dttitel As Data.DataTable = artikeldal.GetArtikelGegevensByTitel(tag)
            Dim dttekst As Data.DataTable = artikeldal.GetArtikelGegevensByTekst(tag)
            Dim dt As New Data.DataTable

            dt = dttekst.Clone()
            For i As Integer = 0 To dttekst.Rows.Count - 1
                Dim dr As Data.DataRow = dt.NewRow
                dr = dttekst.Rows(i)
                dt.ImportRow(dr)
            Next
            For i2 As Integer = 0 To dttitel.Rows.Count - 1
                Dim dr As Data.DataRow = dt.NewRow
                dr = dttitel.Rows(i2)
                dt.ImportRow(dr)
            Next
            GridView1.DataSource = dt
            GridView1.DataBind()
        Else
            lblRes.Text = "U hebt geen zoekcriteria meegegeven."
        End If
    End Sub

    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GridView1.RowCommand


        Dim row As GridViewRow = GridView1.Rows(e.CommandArgument)
        Dim tag As String = row.Cells(1).Text
        Dim qst As String = "~/App_Presentation/page.aspx?tag=" + tag
        Response.Redirect(qst)
    End Sub
End Class
