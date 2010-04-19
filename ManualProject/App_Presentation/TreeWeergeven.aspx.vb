
Partial Class App_Presentation_TreeWeergeven
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Session("LeesTree") IsNot Nothing) Then
            Me.lblWeergave.InnerHtml = Session("LeesTree")
            Session("LeesTree") = Nothing
        Else
            Me.lblWeergave.InnerText = "Geen boomstructuur geladen."
        End If

        If (Session("LeesTreeTitel") IsNot Nothing) Then
            Page.Title = Session("LeesTreeTitel")
            Session("LeesTreeTitel") = Nothing
        End If
    End Sub
End Class
