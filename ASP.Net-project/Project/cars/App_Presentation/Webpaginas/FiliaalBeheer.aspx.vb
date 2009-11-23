
Partial Class App_Presentation_Webpaginas_FiliaalBeheer
    Inherits System.Web.UI.Page


    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegtoe.Click
        Dim pfiliaal As New Filiaal
        Dim bllFiliaal As New FiliaalBLL

        pfiliaal.FiliaalLocatie = txtLocatie.Text
        pfiliaal.FiliaalNaam = txtFiliaalNaam.Text
        pfiliaal.FiliaalAdres = txtAdres.Text

        bllFiliaal.AddFiliaal(pfiliaal)
        ddlFiliaal.DataBind()


    End Sub

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click

        Dim pfiliaalID As Integer
        Dim bblFiliaal As New FiliaalBLL
        pfiliaalID = ddlFiliaal.SelectedValue
        bblFiliaal.DeleteFiliaal(pfiliaalID)
        ddlFiliaal.DataBind()
    End Sub
End Class
