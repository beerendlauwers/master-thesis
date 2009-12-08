Imports AjaxControlToolkit
Imports System.IO

Partial Class App_Presentation_NieuweAutoAanmaken
    Inherits System.Web.UI.Page

    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            If Not Me.valAutoKenteken.IsValid Then
                Return
            End If

            'Auto toevoegen
            If (AutoToevoegen()) Then
                Dim autobll As New AutoBLL

                'autoID ophalen
                Dim autoID As Integer = autobll.getAutoIDByKenteken(Me.txtAutoKenteken.Text)

                'Opties toevoegen
                VoegOptiesToeAanAuto(autoID)

                'Foto toevoegen
                VoegFotoToeVanAuto(autoID)

                Response.Redirect("~/App_Presentation/Webpaginas/Beheer/NieuweAutoAanmaken.aspx")

            Else
                'kut 
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

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

        If (Not IsPostBack) Then
            MaakNieuweOptieControlsZichtbaar(False)
        End If

        Me.valAutoBouwjaar.MaximumValue = Now.Year
        Dim waarschuwingstekst As String = String.Concat("Gelieve een jaar op te geven tussen 1900 en ", Now.Year, ".")
        Me.valAutoBouwjaar.MinimumValueMessage = waarschuwingstekst
        Me.valAutoBouwjaar.MinimumValueBlurredText = waarschuwingstekst
        Me.valAutoBouwjaar.MaximumValueMessage = waarschuwingstekst
        Me.valAutoBouwjaar.MaximumValueBlurredMessage = waarschuwingstekst
    End Sub

    Protected Sub txtAutoKenteken_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        If Me.valAutoKenteken.IsValid Then
            Dim autobll As New AutoBLL
            If autobll.CheckOfKentekenReedsBestaat(Me.txtAutoKenteken.Text) Then
                Me.valAutoKenteken.IsValid = False
                Me.lblAutoKentekenIncorrect.Visible = True
            Else
                Me.lblAutoKentekenIncorrect.Visible = False
            End If
        End If

    End Sub

    Public Sub FotoGeupload()
        Dim upload As AjaxControlToolkit.AsyncFileUpload = CType(Me.frvNieuweAuto.FindControl("uplFoto"), AjaxControlToolkit.AsyncFileUpload)
        Try
            Dim grootte As Integer = upload.PostedFile.InputStream.Length
            Dim file As Byte() = New Byte(grootte) {}
            upload.PostedFile.InputStream.Read(file, 0, grootte)

            'Encodeer het bestandje naar stringformaat en slaag het op in het formulier
            Session("autoFoto") = Convert.ToBase64String(file)

            'Slaag het content-type op
            Session("autoFotoType") = upload.PostedFile.ContentType
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Function AutoToevoegen() As Boolean
        Dim autobll As New AutoBLL

        'Row initialiseren
        Dim temptable As New Autos.tblAutoDataTable
        Dim auto As Autos.tblAutoRow = temptable.NewRow
        temptable = Nothing

        'Alle waardes uit de controls in de formview lezen
        auto.categorieID = CType(Me.frvNieuweAuto.FindControl("ddlCategorie"), DropDownList).SelectedValue
        auto.modelID = CType(Me.frvNieuweAuto.FindControl("ddlModel"), DropDownList).SelectedValue
        auto.autoKleur = CType(Me.frvNieuweAuto.FindControl("txtAutoKleur"), TextBox).Text
        auto.autoBouwjaar = CType(Me.frvNieuweAuto.FindControl("txtAutoBouwjaar"), TextBox).Text
        auto.brandstofID = CType(Me.frvNieuweAuto.FindControl("ddlBrandstofType"), DropDownList).SelectedValue
        auto.autoKenteken = CType(Me.frvNieuweAuto.FindControl("txtAutoKenteken"), TextBox).Text
        auto.statusID = CType(Me.frvNieuweAuto.FindControl("ddlStatus"), DropDownList).SelectedValue
        auto.parkeerPlaatsID = Convert.ToInt32(CType(Me.frvNieuweAuto.FindControl("txtAutoParkeerplaats"), TextBox).Text)
        auto.filiaalID = CType(Me.frvNieuweAuto.FindControl("ddlFiliaal"), DropDownList).SelectedValue
        auto.autoDagTarief = CType(Me.frvNieuweAuto.FindControl("txtAutoDagTarief"), TextBox).Text
        auto.autoKMTotOlieVerversing = 0

        Return autobll.AddAuto(auto)

    End Function

    Private Sub VoegFotoToeVanAuto(ByVal autoID As Integer)

        Dim fotobll As New AutoFotoBLL
        Dim dt As New Autos.tblAutofotoDataTable
        Dim r As Autos.tblAutofotoRow = dt.NewRow

        r.autoID = autoID

        'Decodeer het lblAutoFoto-formulierveld naar een byte-array
        r.autoFoto = Convert.FromBase64String(Session("autoFoto"))

        r.autoFotoType = Session("autoFotoType").ToString
        r.autoFotoDatum = Now

        r.autoFotoVoorReservatie = 1

        fotobll.InsertAutoFoto(r)

        fotobll = Nothing
        dt = Nothing
        r = Nothing
    End Sub

    Private Sub VoegOptiesToeAanAuto(ByVal autoID As Integer)
        Dim autooptiebll As New AutoOptieBLL
        Dim dt As New Autos.tblAutoOptieDataTable
        Dim r As Autos.tblAutoOptieRow = dt.NewRow

        r.autoID = autoID

        For i As Integer = 0 To CType(frvNieuweAuto.FindControl("lstOpties"), ListBox).Items.Count - 1
            r.optieID = CType(frvNieuweAuto.FindControl("lstOpties"), ListBox).Items(i).Value
            autooptiebll.autoOptieAdd(r)
        Next
    End Sub

    Protected Sub ddlFiliaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        If (CType(Me.frvNieuweAuto.FindControl("ddlFiliaal"), DropDownList).SelectedValue = 6) Then
            'Dummy filiaal, terug verstoppen
            CType(Me.frvNieuweAuto.FindControl("txtAutoParkeerplaats"), TextBox).Enabled = False
            CType(Me.frvNieuweAuto.FindControl("imgParkeerPlaats"), ImageButton).Visible = False
            CType(Me.frvNieuweAuto.FindControl("updParkingOverzicht"), UpdatePanel).Update()
            Return
        End If

        If (CType(Me.frvNieuweAuto.FindControl("txtAutoParkeerplaats"), TextBox).Enabled) Then
            Return
        End If

        CType(Me.frvNieuweAuto.FindControl("txtAutoParkeerplaats"), TextBox).Enabled = True
        CType(Me.frvNieuweAuto.FindControl("imgParkeerPlaats"), ImageButton).Visible = True
        CType(Me.frvNieuweAuto.FindControl("updParkingOverzicht"), UpdatePanel).Update()
    End Sub
End Class
