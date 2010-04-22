
Partial Class App_Presentation_Module
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("module") IsNot Nothing Then
            ddlModule.SelectedValue = Session("module")
        End If

        Util.LeesPaginaNummer(Me, grdvmodule)

        GenereerGelokaliseerdeTekst()
        JavaScript.ShadowBoxLaderTonenBijElkePostback(Me)
    End Sub

    Protected Sub grdvmodule_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdvmodule.DataBound
        Util.LaadPaginering(grdvmodule)
        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub

    Protected Sub grdvmodule_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdvmodule.RowCommand
        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub

    Protected Sub grdvmodule_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdvmodule.RowDataBound
        If e.Row.Cells.Count > 1 Then
            e.Row.Cells(1).Visible = False
        End If
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
