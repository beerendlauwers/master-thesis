
Partial Class App_Presentation_Aanmeldpagina
    Inherits System.Web.UI.Page

    Protected Sub btnAanmelden_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAanmelden.Click
        Try
            'Juiste paswoord en username ophalen
            Dim login As String() = XML.GetBeheerLogin(Server.MapPath("~/App_Data/beheerlogin.xml")).Split(",")
            Dim user As String = login(0)
            Dim pass As String = login(1)

            If txtGebruikersNaam.Text.Trim = user And txtPaswd.Text = pass Then
                Session("login") = 1
                divRes.Visible = True

                If lblVorige.Text IsNot Nothing And Not lblVorige.Text = String.Empty Then
                    Dim str As String = lblVorige.Text
                    Dim st() As String = Split(str, "/")
                    Dim link As String = String.Concat("~", "/", st(2), "/", st(3))
                    Response.Redirect(link, False)
                Else
                    Response.Redirect("~/App_Presentation/AlleArtikels.aspx", False)
                End If

            Else
                Session("login") = Nothing
                divRes.Visible = True
                Util.SetError("Verkeerde login.", lblRes, imgRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnAanmelden, ex.Message)
        End Try
    End Sub

    Protected Sub btnLogOut_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogOut.Click
        Session("login") = Nothing
        Response.Redirect("~/App_Presentation/Default.aspx", False)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            JavaScript.ZetButtonOpDisabledOnClick(btnAanmelden, "Aanmelden...", False)
            JavaScript.ZetButtonOpDisabledOnClick(btnLogOut, "Afmelden...", False)
        End If

        If Session("login") = 1 Then
            divWelAangemeld.Visible = True
            divNietAangemeld.Visible = False
        Else
            Session("login") = Nothing
            divNietAangemeld.Visible = True
            divWelAangemeld.Visible = False
        End If

        If Not Request.UrlReferrer Is Nothing Then
            If Not Request.UrlReferrer.LocalPath = "/ReferenceManual/App_Presentation/Aanmeldpagina.aspx" Then
                lblVorige.Text = Request.UrlReferrer.LocalPath
            End If
        End If
    End Sub
End Class
