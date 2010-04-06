
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
                ctl = label
            Else
                Dim linkbutton As New LinkButton()
                linkbutton.Text = index + 1
                ctl = linkbutton
            End If

            r.Cells(0).Controls.Add(ctl)
        Next index

    End Sub

    Protected Sub GridView1_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView1.PreRender
        
    End Sub

    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GridView1.RowCommand
        If e.CommandName = "Select" Then
            Dim row As GridViewRow = GridView1.Rows(e.CommandArgument)
            Dim tag As String = row.Cells(1).Text
            Dim qst As String = "~/App_Presentation/page.aspx?tag=" + tag

            Response.Redirect(qst)
        ElseIf e.CommandName = "BekijkArtikel" Then
            Session("artikelID") = "neger"
        End If

    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Dim titel As String = e.Row.Cells(0).ToString
        If e.Row.Cells.Count > 1 Then
            e.Row.Cells(1).Visible = False
            If e.Row.Cells(0).ToString = "System.Web.UI.WebControls.DataControlFieldHeaderCell" Then
                Dim form As New HtmlGenericControl("form")
                form.Attributes.Add("method", "post")
                form.Attributes.Add("action", "page.aspx")

                Dim input As New HtmlGenericControl("input")
                input.Attributes.Add("type", "hidden")
                input.Attributes.Add("value", e.Row.Cells(1).Text)
                input.Attributes.Add("name", "ArtikelID")

                Dim btn As New HtmlGenericControl("input")
                btn.Attributes.Add("type", "submit")
                btn.Attributes.Add("value", "Bekijken")
                btn.Attributes.Add("style", "visibility:hidden;")

                form.Controls.Add(input)
                form.Controls.Add(btn)

                e.Row.Cells(2).Controls.Add(form)

            Else
                Dim form As New HtmlGenericControl("form")
                form.Attributes.Add("method", "post")
                form.Attributes.Add("action", "page.aspx")

                Dim input As New HtmlGenericControl("input")
                input.Attributes.Add("type", "hidden")
                input.Attributes.Add("value", e.Row.Cells(1).Text)
                input.Attributes.Add("name", "ArtikelID")

                Dim btn As New HtmlGenericControl("input")
                btn.Attributes.Add("type", "submit")
                btn.Attributes.Add("value", "Bekijken")

                form.Controls.Add(input)
                form.Controls.Add(btn)

                e.Row.Cells(2).Controls.Add(form)
            End If
        End If


    End Sub

    Protected Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Unload
        'Session("tag") = Nothing
    End Sub
End Class
