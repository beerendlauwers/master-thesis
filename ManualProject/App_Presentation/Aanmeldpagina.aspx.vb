
Partial Class App_Presentation_Aanmeldpagina
    Inherits System.Web.UI.Page

    Protected Sub btnAanmelden_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAanmelden.Click

        'Juiste paswoord en username ophalen
        Dim login As String() = XML.GetBeheerLogin(Server.MapPath("~/App_Data/beheerlogin.xml")).Split(",")
        Dim user As String = login(0)
        Dim pass As String = login(1)

        If txtGebruikersNaam.Text = user And txtPaswd.Text = pass Then
            Session("login") = 1
            Response.Redirect("~/App_Presentation/AlleArtikels.aspx")
        Else
            Session("login") = 0
            lblRes.Text = "Verkeerde Login."
        End If


    End Sub

    Protected Sub btnLogOut_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogOut.Click
        Session.Abandon()
        Response.Redirect("~/App_Presentation/Default.aspx")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        JavaScript.ZetButtonOpDisabledOnClick(btnAanmelden, "Aanmelden...")
        JavaScript.ZetButtonOpDisabledOnClick(btnLogOut, "Afmelden...", True, True)

        If Session("login") = 1 Then
            divWelAangemeld.Visible = True
            divNietAangemeld.Visible = False
        Else
            divNietAangemeld.Visible = True
            divWelAangemeld.Visible = False
        End If
    End Sub
End Class
