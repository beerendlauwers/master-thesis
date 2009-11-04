
Partial Class App_Presentation_Webpaginas_Login
    Inherits System.Web.UI.Page

    Protected Sub Page_PreLoad(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreLoad
        Response.Redirect("~/App_Presentation/Webpaginas/Default.aspx")
    End Sub
End Class
