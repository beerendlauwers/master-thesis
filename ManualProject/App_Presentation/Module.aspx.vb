
Partial Class App_Presentation_Module
    Inherits System.Web.UI.Page

    Protected Sub grdvmodule_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdvmodule.DataBound
        Dim r As GridViewRow = grdvmodule.BottomPagerRow

        For index As Integer = 0 To grdvmodule.PageCount - 1
            Dim ctl As WebControl = Nothing

            If index = grdvmodule.PageIndex Then
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

    Protected Sub grdvmodule_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdvmodule.RowDataBound
        If e.Row.Cells.Count > 1 Then
            e.Row.Cells(1).Visible = False
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("module") IsNot Nothing Then
            ddlModule.SelectedValue = Session("module")
        Else

        End If

        Dim str As String = Session("versie")
        Dim str2 As String = Session("bedrijf")
        Dim str1 As String = Session("taal")

        Dim control As String = Page.Request.Params.Get("__EVENTTARGET")

        If control IsNot Nothing And Not control = String.Empty Then
            grdvmodule.DataBind()
            If TryCast(Page.FindControl(control), LinkButton) IsNot Nothing Then
                Dim ctl As LinkButton = Page.FindControl(control)
                grdvmodule.PageIndex = Integer.Parse(ctl.Text) - 1
            End If
        End If
        GenereerGelokaliseerdeTekst()
    End Sub

    Private Sub GenereerGelokaliseerdeTekst()
        Master.CheckVoorTaalWijziging()
        grdvmodule.EmptyDataText = Lokalisatie.GetString("GEENDATAGEVONDEN")
        Page.Title = Lokalisatie.GetString("MODPAGINATITEL")
        For Each d As DataControlField In grdvmodule.Columns
            If d.SortExpression = "titel" Then d.HeaderText = Lokalisatie.GetString("ZOEKEN_TITEL")
        Next
    End Sub
End Class
