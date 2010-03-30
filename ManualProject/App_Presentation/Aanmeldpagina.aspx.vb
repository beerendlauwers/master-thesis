
Partial Class App_Presentation_Aanmeldpagina
    Inherits System.Web.UI.Page

    Protected Sub btnAanmelden_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAanmelden.Click
        If txtGebruikersNaam.Text = "Appligen" And txtPaswd.Text = "Appligen" Then
            Session("login") = 1
            Response.Redirect("~/App_Presentation/AlleArtikels.aspx")
        Else
            Session("login") = 0
            lblRes.Text = "Verkeerde Login"
        End If


    End Sub

    Protected Sub btnLogOut_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogOut.Click
        Session.Abandon()
        Response.Redirect("~/App_Presentation/Default.aspx")
    End Sub
End Class
