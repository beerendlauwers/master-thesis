
Partial Class App_Presentation_Webpaginas_FiliaalBeheer
    Inherits System.Web.UI.Page


    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegtoe.Click
        Dim dt As New Autos.tblFiliaalDataTable
        Dim pfiliaal As Autos.tblFiliaalRow = dt.NewRow
        Dim bllFiliaal As New FiliaalBLL

        pfiliaal.filiaalLocatie = String.Concat(txtLocatie.Text, ", ", txtAdres.Text)
        pfiliaal.filiaalNaam = txtFiliaalNaam.Text
        pfiliaal.parkingAantalKolommen = 0
        pfiliaal.parkingAantalRijen = 0

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
