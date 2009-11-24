
Partial Class App_Presentation_NieuweGebruikerAanmaken
    Inherits System.Web.UI.Page

    Protected Sub frvNieuweGebruiker_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles frvNieuweGebruiker.ItemInserting
        If (Page.IsValid()) Then
            'Paswoord omzetten naar MD5-hash en opslaan
            e.Values.Item(1) = FormsAuthentication.HashPasswordForStoringInConfigFile(e.Values.Item(1), "MD5")
        End If
    End Sub

    Protected Sub InsertButton0_Click(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub
End Class
