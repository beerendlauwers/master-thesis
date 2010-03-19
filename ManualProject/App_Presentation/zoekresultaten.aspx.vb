
Partial Class App_Presentation_zoekresultaten
    Inherits System.Web.UI.Page
    Dim artikeldal As New ArtikelDAL


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString.Count > 0 Then
            If Request.QueryString("tag").Length > 0 Then

                Dim taal As Integer = Request.QueryString("taalID")
                Dim bedrijf As Integer = Request.QueryString("BedrijfID")
                Dim versie As Integer = Request.QueryString("VersieID")
                Dim tag As String = "%" + Request.QueryString("tag") + "%"
                If tag = "%%%%" Then
                    lblRes.Text = "ongeldige zoekcriteria."
                Else
                    Dim dt As Data.DataTable
                    dt = artikeldal.getArtikelsForSearch(bedrijf, versie, taal, tag)
                    If dt.Rows.Count = 0 Then
                        lblRes.Text = "Geen resultaten."
                    Else
                        GridView1.DataSource = dt
                        GridView1.DataBind()
                    End If
                End If
            End If
        Else
            lblRes.Text = "Geen zoektermen meegegeven."
        End If
    End Sub

    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GridView1.RowCommand
        If e.CommandArgument = "select" Then
            Dim row As GridViewRow = GridView1.Rows(e.CommandArgument)
            Dim tag As String = row.Cells(1).Text
            Dim qst As String = "~/App_Presentation/page.aspx?tag=" + tag
            Response.Redirect(qst)
        End If
    End Sub
End Class
