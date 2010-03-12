
Partial Class App_Presentation_MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Tree.GetTrees() Is Nothing) Then
            Tree.BouwTrees()
        End If

    End Sub

End Class

