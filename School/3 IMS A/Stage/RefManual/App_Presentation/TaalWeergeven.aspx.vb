
Partial Class App_Presentation_TaalWeergeven
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Session("LeesTaal") IsNot Nothing) Then
            Me.lblWeergave.InnerHtml = Session("LeesTaal")
            Session("LeesTaal") = Nothing
        Else
            Me.lblWeergave.InnerText = "Geen taal geladen."
        End If
    End Sub
End Class
