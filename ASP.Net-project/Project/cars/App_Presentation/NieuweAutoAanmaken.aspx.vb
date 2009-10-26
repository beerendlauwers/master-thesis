Imports AjaxControlToolkit

Partial Class App_Presentation_NieuweAutoAanmaken
    Inherits System.Web.UI.Page

    Protected Sub frvNieuweAuto_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles frvNieuweAuto.ItemInserting
        'Hack omdat we een CascadingDropDown gebruiken
        e.Values("modelID") = ddlModel.SelectedValue

        'KMTotOlieVerversing = 0
        e.Values("autoKMTotOlieVerversing") = 0

        'Foto toevoegen
        Dim img As FileUpload = CType(frvNieuweAuto.FindControl("fupAutoFoto"), FileUpload)
        Dim img_byte As Byte() = Nothing

        If img.HasFile AndAlso Not img.PostedFile Is Nothing Then
            'foto in bestand steken
            Dim File As HttpPostedFile = img.PostedFile
            'Byte array de lengte van het bestand maken
            img_byte = New Byte(File.ContentLength - 1) {}
            'Bestandsdata in de byte array gooien
            File.InputStream.Read(img_byte, 0, File.ContentLength)
        Else 'Indien er geen foto is geüpload, zetten we "geen_foto" in het fotoveld
            Dim encoding As New System.Text.ASCIIEncoding()
            img_byte = encoding.GetBytes("geen_foto")
        End If

        e.Values("autoFoto") = img_byte
    End Sub
End Class
