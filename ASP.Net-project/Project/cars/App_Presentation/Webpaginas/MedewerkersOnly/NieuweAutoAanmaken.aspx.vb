Imports AjaxControlToolkit

Partial Class App_Presentation_NieuweAutoAanmaken
    Inherits System.Web.UI.Page

    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim autobll As New AutoBLL
        Dim autoOptiebll As New AutoOptieBLL
        Dim auto As Auto_s.tblAutoRow
        Dim autoOptie As New AutoOptie
        Dim autodal As New AutoDAL

        'Row initialiseren
        Dim temptable As New Auto_s.tblAutoDataTable
        auto = temptable.NewRow
        temptable = Nothing

        'Alle waardes uit de controls in de formview lezen
        auto.categorieID = CType(Me.frvNieuweAuto.FindControl("ddlCategorie"), DropDownList).SelectedValue
        auto.modelID = CType(Me.frvNieuweAuto.FindControl("ddlModel"), DropDownList).SelectedValue
        auto.autoKleur = CType(Me.frvNieuweAuto.FindControl("txtAutoKleur"), TextBox).Text
        auto.autoBouwjaar = CType(Me.frvNieuweAuto.FindControl("txtAutoBouwjaar"), TextBox).Text
        auto.brandstofID = CType(Me.frvNieuweAuto.FindControl("ddlBrandstofType"), DropDownList).SelectedValue
        auto.autoKenteken = CType(Me.frvNieuweAuto.FindControl("txtAutoKenteken"), TextBox).Text
        auto.statusID = CType(Me.frvNieuweAuto.FindControl("ddlStatus"), DropDownList).SelectedValue
        auto.autoParkeerplaats = CType(Me.frvNieuweAuto.FindControl("txtAutoParkeerplaats"), TextBox).Text
        auto.filiaalID = CType(Me.frvNieuweAuto.FindControl("ddlFiliaal"), DropDownList).SelectedValue
        auto.autoDagTarief = CType(Me.frvNieuweAuto.FindControl("txtAutoDagTarief"), TextBox).Text
        auto.autoKMTotOlieVerversing = 0

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

        auto.autoFoto = img_byte

        'Auto toevoegen.
        If (autobll.AddAuto(auto)) Then
            'yeuy, geslaagd
            autoOptie.AutoID = autodal.getAutoID(auto.autoKenteken)
            Dim i As Integer

            For i = 0 To CType(frvNieuweAuto.FindControl("lstVoegtoeID"), ListBox).Items.Count - 1
                autoOptie.OptieID = CType(frvNieuweAuto.FindControl("lstVoegtoeID"), ListBox).Items(i).Text
                autoOptiebll.autoOptieAdd(autoOptie)
            Next
        Else
            'kut 
        End If
        
    End Sub

    

    ' Protected Sub btnToevoegen_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    '  CType(frvNieuweAuto.FindControl("lstOpties"), ListBox).Items.Add(CType(frvNieuweAuto.FindControl("ddlOpties"), DropDownList).SelectedValue)
    ' End Sub

    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        CType(frvNieuweAuto.FindControl("lstOpties"), ListBox).Items.Add(CType(frvNieuweAuto.FindControl("ddlOpties"), DropDownList).SelectedItem)
        CType(frvNieuweAuto.FindControl("lstVoegtoeID"), ListBox).Items.Add(CType(frvNieuweAuto.FindControl("ddlOpties"), DropDownList).SelectedValue)
    End Sub

    Protected Sub btnNieuweOptie_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        CType(frvNieuweAuto.FindControl("txtOptieNaam"), TextBox).Visible = True
        CType(frvNieuweAuto.FindControl("txtOptiePrijs"), TextBox).Visible = True
        CType(frvNieuweAuto.FindControl("btnVoegoptietoe"), Button).Visible = True
    End Sub

    Protected Sub btnVoegoptietoe_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim pOptie As New Optie
        Dim bllOptie As New OptieBLL

        pOptie.Omschrijving = CType(frvNieuweAuto.FindControl("txtOptieNaam"), TextBox).Text
        pOptie.Prijs = CType(frvNieuweAuto.FindControl("txtOptiePrijs"), TextBox).Text
        bllOptie.AddOptie(pOptie)

        DataBind()

    End Sub

    Protected Sub btnVerwijderLijst_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        CType(frvNieuweAuto.FindControl("lstOpties"), ListBox).Items.RemoveAt(CType(frvNieuweAuto.FindControl("lstOpties"), ListBox).SelectedIndex)
    End Sub

    Public Sub New()

    End Sub
End Class
