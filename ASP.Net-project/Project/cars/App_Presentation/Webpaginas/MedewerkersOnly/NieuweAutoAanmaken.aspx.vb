Imports AjaxControlToolkit

Partial Class App_Presentation_NieuweAutoAanmaken
    Inherits System.Web.UI.Page

    Protected Sub InsertButton0_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim autobll As New AutoBLL

        Dim auto As New Auto

        'Alle waardes uit de controls in de formview lezen
        auto.Categorie = CType(Me.frvNieuweAuto.FindControl("ddlCategorie"), DropDownList).SelectedValue
        auto.Model = CType(Me.frvNieuweAuto.FindControl("ddlModel"), DropDownList).SelectedValue
        auto.Kleur = CType(Me.frvNieuweAuto.FindControl("autoKleurTextBox0"), TextBox).Text
        auto.Bouwjaar = CType(Me.frvNieuweAuto.FindControl("autoBouwjaarTextBox0"), TextBox).Text
        auto.Brandstoftype = CType(Me.frvNieuweAuto.FindControl("ddlBrandstofType"), DropDownList).SelectedValue
        auto.Kenteken = CType(Me.frvNieuweAuto.FindControl("autoKentekenTextBox0"), TextBox).Text
        auto.Status = CType(Me.frvNieuweAuto.FindControl("ddlStatus"), DropDownList).SelectedValue
        auto.Parkeerplaats = CType(Me.frvNieuweAuto.FindControl("autoParkeerplaatsTextBox0"), TextBox).Text
        auto.Filiaal = CType(Me.frvNieuweAuto.FindControl("ddlFiliaal"), DropDownList).SelectedValue
        auto.Dagtarief = CType(Me.frvNieuweAuto.FindControl("autoDagTariefTextBox0"), TextBox).Text
        auto.KmTotOnderhoud = 0

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

        auto.Foto = img_byte

        'Auto toevoegen.
        autobll.AddAuto(auto)

    End Sub
End Class
