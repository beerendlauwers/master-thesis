
Partial Class App_Presentation_zoekresultaten
    Inherits System.Web.UI.Page
    Dim artikeldal As New ArtikelDAL
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim form As String = Page.Request.Form("ctl00$txtZoek")
            If form Is Nothing Then
            ElseIf form = "%%" Then
            Else
                Session("tag") = form
                GridView1.DataBind()
            End If
        End If
        If Page.Request.Form("ctl00$lnkZoeken.x") Is Nothing Then

        Else
            Dim form As String = Page.Request.Form("ctl00$txtZoek")
            If form Is Nothing Then
            ElseIf form = "%%" Then
            Else
                Session("tag") = form
                GridView1.DataBind()
            End If
        End If

        If GridView1.Rows.Count > 0 Then
            lblSort.Visible = True

            Page.Title = String.Concat("Zoekresultaten voor de term '", Session("tag"), "'")
        End If

        Dim control As String = Page.Request.Params.Get("__EVENTTARGET")

        If control IsNot Nothing And Not control = String.Empty Then
            GridView1.DataBind()
            If TryCast(Page.FindControl(control), LinkButton) IsNot Nothing Then
                Dim ctl As LinkButton = Page.FindControl(control)
                GridView1.PageIndex = Integer.Parse(ctl.Text) - 1
            End If
        End If

    End Sub

    Protected Sub GridView1_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.DataBound
        Dim r As GridViewRow = GridView1.BottomPagerRow

        For index As Integer = 0 To GridView1.PageCount - 1
            Dim ctl As WebControl = Nothing

            If index = GridView1.PageIndex Then
                Dim label As New Label
                label.Text = index + 1
                label.CssClass = "gridview_bignumber"
                label.ID = String.Concat("lblPaginaNummer_" + label.Text)
                ctl = label
            Else
                Dim linkbutton As New LinkButton()
                linkbutton.Text = index + 1
                linkbutton.ID = String.Concat("lnbPaginaNummer_" + linkbutton.Text)
                ctl = linkbutton
            End If

            r.Cells(0).Controls.Add(ctl)
        Next index

    End Sub

    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GridView1.RowCommand
        If e.CommandName = "Select" Then
            Dim row As GridViewRow = GridView1.Rows(e.CommandArgument)
            Dim tag As String = row.Cells(1).Text
            Dim qst As String = "~/App_Presentation/page.aspx?tag=" + tag
            Response.Redirect(qst)
        ElseIf e.CommandName = "BekijkArtikel" Then

        End If

    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Dim titel As String
        titel = e.Row.Cells(0).Text
        Server.HtmlEncode(titel)
        e.Row.Cells(0).Text = Server.HtmlDecode(titel)
    End Sub

End Class
