Imports AjaxControlToolkit

Partial Class App_Presentation_NieuweAutoAanmaken
    Inherits System.Web.UI.Page

    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim autobll As New AutoBLL
        Dim autoOptiebll As New AutoOptieBLL
        Dim auto As Autos.tblAutoRow
        Dim autoOptie As New AutoOptie
        Dim autodal As New AutoDAL

        'Row initialiseren
        Dim temptable As New Autos.tblAutoDataTable
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
        'auto.parkeerPlaatsID = Convert.ToInt32(CType(Me.frvNieuweAuto.FindControl("txtAutoParkeerplaats"), TextBox).Text)
        auto.filiaalID = CType(Me.frvNieuweAuto.FindControl("ddlFiliaal"), DropDownList).SelectedValue
        auto.autoDagTarief = CType(Me.frvNieuweAuto.FindControl("txtAutoDagTarief"), TextBox).Text
        auto.autoKMTotOlieVerversing = 0

        'Foto toevoegen
        Dim img As FileUpload = CType(frvNieuweAuto.FindControl("fupAutoFoto"), FileUpload)
        Dim img_byte As Byte() = Nothing

        Dim test As String = img.FileName

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

        'auto.autoFoto = img_byte

        'Auto toevoegen.
        If (autobll.AddAuto(auto)) Then
            'yeuy, geslaagd
            Dim autoID As Integer = autodal.getAutoIDByKenteken(auto.autoKenteken)
            autoOptie.AutoID = autoID
            Dim i As Integer

            For i = 0 To CType(frvNieuweAuto.FindControl("lstVoegtoeID"), ListBox).Items.Count - 1
                autoOptie.OptieID = CType(frvNieuweAuto.FindControl("lstVoegtoeID"), ListBox).Items(i).Text
                autoOptiebll.autoOptieAdd(autoOptie)
            Next

            'Extra foto
            autodal.InsertFoto(autoID, img.FileName, "image/jpeg", img_byte)
        Else
            'kut 
        End If
        
    End Sub

    

    ' Protected Sub btnToevoegen_Click(ByVal sender As Object, ByVal e As System.EventArgs)
    '  CType(frvNieuweAuto.FindControl("lstOpties"), ListBox).Items.Add(CType(frvNieuweAuto.FindControl("ddlOpties"), DropDownList).SelectedValue)
    ' End Sub

    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        'Waardes ophalen uit ddlOpties
        Dim ddlOpties As DropDownList = CType(frvNieuweAuto.FindControl("ddlOpties"), DropDownList)
        Dim text As String = ddlOpties.SelectedItem.Text
        Dim value As Integer = ddlOpties.SelectedItem.Value

        'Waardes in de optielijst steken
        Dim lstOpties As ListBox = CType(frvNieuweAuto.FindControl("lstOpties"), ListBox)
        lstOpties.Items.Add(New ListItem(text, value))
    End Sub

    Private Sub MaakNieuweOptieControlsZichtbaar(ByVal isZichtbaar As Boolean)
        CType(frvNieuweAuto.FindControl("lblOptieNaam"), Label).Visible = isZichtbaar
        CType(frvNieuweAuto.FindControl("txtOptieNaam"), TextBox).Visible = isZichtbaar
        CType(frvNieuweAuto.FindControl("lblOptiePrijs"), Label).Visible = isZichtbaar
        CType(frvNieuweAuto.FindControl("txtOptiePrijs"), TextBox).Visible = isZichtbaar
        CType(frvNieuweAuto.FindControl("btnVoegoptietoe"), Button).Visible = isZichtbaar
        CType(frvNieuweAuto.FindControl("btnNieuweOptie"), Button).Visible = Not isZichtbaar
    End Sub

    Protected Sub btnNieuweOptie_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        MaakNieuweOptieControlsZichtbaar(True)
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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        MaakNieuweOptieControlsZichtbaar(False)
    End Sub
End Class
