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

        'Bij het laden van de pagina verstoppen we de controls om nieuwe opties aan te maken
        If (Not IsPostBack) Then
            MaakNieuweOptieControlsZichtbaar(False)
        End If

        'BIj een postback gaan we kijken of deze van een parkeeroverzichtsknop komt.
        If (IsPostBack) Then
            For i As Integer = 1 To Page.Request.Form.Keys.Count - 1
                Dim str As String = Page.Request.Form.Keys(i)

                If str Is Nothing Then Continue For

                If str.Contains("ctl00$plcMain$frvNieuweAuto$btn_") Then
                    'Eerst de buttons terug maken
                    UpdateParkeerOverzicht()

                    Dim control As String = str.Remove(str.Length - 2)
                    Dim button As ImageButton = Page.FindControl(control)
                    control = button.ID.Remove(0, 4)
                    Dim nummers() As String = control.Split("_")
                    Dim rij As Integer = Convert.ToInt32(nummers(0))
                    Dim kolom As Integer = Convert.ToInt32(nummers(1))

                    Dim kolommen() As String = MaakKolommenAan()
                    Me.lblAutoParkeerplaats.Text = String.Concat(kolommen(kolom), "-", rij + 1)

                    Dim parkeerbll As New ParkeerBLL
                    Dim p As Autos.tblParkeerPlaatsRow = parkeerbll.GetParkeerPlaatsByRijKolomFiliaalID(Me.ddlFiliaal.SelectedValue, rij, kolom)
                    parkeerbll = Nothing
                    Me.txtAutoParkeerplaats.Text = p.parkeerPlaatsID


                    Return
                End If
            Next
        End If

        'Bouwjaarvelden instantiëren
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
        auto.autoTankInhoud = CType(Me.frvNieuweAuto.FindControl("txtTankInhoud"), TextBox).Text
        auto.autoHuidigeKilometerstand = CType(Me.frvNieuweAuto.FindControl("txtHuidigeKilometerstand"), TextBox).Text
        auto.autoKenteken = CType(Me.frvNieuweAuto.FindControl("txtAutoKenteken"), TextBox).Text
        auto.statusID = CType(Me.frvNieuweAuto.FindControl("ddlStatus"), DropDownList).SelectedValue
        auto.parkeerPlaatsID = Convert.ToInt32(CType(Me.frvNieuweAuto.FindControl("txtAutoParkeerplaats"), TextBox).Text)
        auto.filiaalID = CType(Me.frvNieuweAuto.FindControl("ddlFiliaal"), DropDownList).SelectedValue
        auto.autoDagTarief = CType(Me.frvNieuweAuto.FindControl("txtAutoDagTarief"), TextBox).Text
        auto.autoKMTotOlieVerversing = 20000

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
        CType(Me.frvNieuweAuto.FindControl("lblAutoParkeerplaats"), Label).Visible = True
        CType(Me.frvNieuweAuto.FindControl("imgParkeerPlaats"), ImageButton).Visible = True
        Me.lblAutoParkeerplaats.Text = "Geen parkeerplaats"
        CType(Me.frvNieuweAuto.FindControl("updParkingOverzicht"), UpdatePanel).Update()

    End Sub

    Protected Sub ddlFiliaal_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlFiliaal.DataBound
        CType(Me.frvNieuweAuto.FindControl("lblAutoParkeerplaats"), Label).Visible = True
        CType(Me.frvNieuweAuto.FindControl("imgParkeerPlaats"), ImageButton).Visible = True
        Me.lblAutoParkeerplaats.Text = "Geen parkeerplaats"
        CType(Me.frvNieuweAuto.FindControl("updParkingOverzicht"), UpdatePanel).Update()

    End Sub

    Protected Sub imgParkeerPlaats_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgParkeerPlaats.Click
        UpdateParkeerOverzicht()
    End Sub

    Private Sub UpdateParkeerOverzicht()
        Dim filiaalID As Integer = Me.ddlFiliaal.SelectedValue

        Dim filiaalbll As New FiliaalBLL
        Dim f As Autos.tblFiliaalRow = filiaalbll.GetFiliaalByFiliaalID(Me.ddlFiliaal.SelectedValue).Rows(0)
        filiaalbll = Nothing

        Dim kolommen As Integer = f.parkingAantalKolommen
        Dim rijen As Integer = f.parkingAantalRijen

        If (f.parkingAantalKolommen = 0 And f.parkingAantalRijen = 0) Then
            Me.lblGeenOverzicht.Text = "Deze filiaal heeft nog geen parkeeroverzicht."
            Me.lblGeenOverzicht.Visible = True
        Else
            Me.lblGeenOverzicht.Visible = False

            'Haal alles van DB binnen
            Dim parkeermatrix(,) As Integer = HaalParkingOpVanFiliaal(f.filiaalID, kolommen, rijen)

            'Maak Overzicht
            MaakParkingLayoutOverzicht(parkeermatrix)
        End If

        CType(Me.frvNieuweAuto.FindControl("updParkingOverzicht"), UpdatePanel).Update()
    End Sub

    Private Function HaalParkingOpVanFiliaal(ByVal filiaalID As Integer, ByVal aantalKolommen As Integer, ByVal aantalRijen As Integer) As Integer(,)
        Dim parkeerbll As New ParkeerBLL
        Dim kolomdt As Data.DataTable = parkeerbll.GetParkeerPlaatsKolommenByFiliaalID(filiaalID)
        Dim parkeerdt As Autos.tblParkeerPlaatsDataTable = parkeerbll.GetParkeerPlaatsenByFiliaalID(filiaalID)
        Dim parkeermatrix(aantalKolommen, aantalRijen) As Integer

        'Opsplitsen in kolommen en rijen
        For kolom As Integer = 0 To aantalKolommen - 1
            Dim filteredview As Data.DataView = parkeerdt.DefaultView
            filteredview.RowFilter = String.Concat("parkeerPlaatsKolom = ", kolomdt.Rows(kolom).Item(0).ToString.Trim)

            Dim filtereddt As Data.DataTable = filteredview.ToTable

            For rij As Integer = 0 To aantalRijen - 1
                parkeermatrix(kolomdt.Rows(kolom).Item(0), rij) = filtereddt.Rows(rij).Item("parkeerPlaatsType")
            Next

        Next

        Return parkeermatrix

    End Function

#Region "Parkinglayout generatiecode"

    Private Sub MaakParkingLayoutOverzicht(ByRef parkeermatrix(,) As Integer)

        Dim kolommen() As String = MaakKolommenAan()

        Dim aantalkolommen As Integer = parkeermatrix.GetUpperBound(0)
        Dim aantalrijen As Integer = parkeermatrix.GetUpperBound(1)

        Dim table As New HtmlGenericControl("table")

        'Vul de kolomheaders in van de tabel.
        table.Controls.Add(MaakKolomHeaders(kolommen, aantalkolommen))

        'Eigenlijke vakken invullen.
        Dim i As Integer = 0
        Dim j As Integer = 0

        While i < aantalrijen
            Dim tablerow As New HtmlGenericControl("tr")

            'Header van de rij toevoegen.
            tablerow.Controls.Add(MaakRijHeader(i))

            'Eigenlijke vakjes toevoegen.
            While j < aantalkolommen

                tablerow.Controls.Add(MaakVakje(i, j, parkeermatrix))
                j = j + 1
            End While

            table.Controls.Add(tablerow)
            i = i + 1
            j = 0
        End While

        plcParkingLayout.Controls.Add(table)

    End Sub

    Private Function MaakVakje(ByVal i As Integer, ByVal j As Integer, ByRef parkeermatrix(,) As Integer) As HtmlGenericControl
        Dim waarde As Integer = parkeermatrix(j, i)
        Dim tabledata As New HtmlGenericControl("td")
        Dim button As New ImageButton()

        With button
            .ID = String.Concat("btn_", i, "_", j)
            .BackColor = Drawing.ColorTranslator.FromHtml("#D4E0E8")
            .Height = 16
            .Width = 16
        End With

        Dim autobll As New AutoBLL
        Dim parkeerbll As New ParkeerBLL
        Dim p As Autos.tblParkeerPlaatsRow = parkeerbll.GetParkeerPlaatsByRijKolomFiliaalID(Me.ddlFiliaal.SelectedValue, i, j)

        If (autobll.CheckOfParkeerPlaatsAutoBevat(p.parkeerPlaatsID)) Then
            button.ImageUrl = "~/App_Presentation/Images/car.png"
            button.CssClass = "art-vakje-ParkingBeheer-GeenParking"
            button.Enabled = False
        Else
            If waarde = 0 Then
                button.ImageUrl = "~/App_Presentation/Images/parkeerplaats.png"
                button.CssClass = "art-vakje-ParkingBeheer"
                button.Enabled = True
            ElseIf waarde = 1 Then
                button.ImageUrl = "~/App_Presentation/Images/rijweg.png"
                button.CssClass = "art-vakje-ParkingBeheer-GeenParking"
                button.Enabled = False
            ElseIf waarde = 2 Then
                button.ImageUrl = "~/App_Presentation/Images/house.png"
                button.CssClass = "art-vakje-ParkingBeheer-GeenParking"
                button.Enabled = False
            ElseIf waarde = 4 Then
                button.ImageUrl = "~/App_Presentation/Images/spacer.gif"
                button.CssClass = "art-vakje-ParkingBeheer-GeenParking"
                button.Enabled = False
            Else
                button.ImageUrl = "~/App_Presentation/Images/spacer.gif"
                button.CssClass = "art-vakje-ParkingBeheer-GeenParking"
                button.Enabled = False
            End If
        End If


        

        tabledata.Controls.Add(button)
        tabledata.Attributes.Add("align", "center")

        'Met deze hoop viewstate-variabelen kunnen we het meest recente overzicht opslaan.
        ViewState(button.ID) = waarde

        Return tabledata
    End Function

    Private Function MaakRijHeader(ByVal i As Integer) As HtmlGenericControl

        Dim rijheader As New HtmlGenericControl("th")
        Dim headerlabel As New Label()

        headerlabel.Text = i + 1
        rijheader.Controls.Add(headerlabel)
        rijheader.Attributes.Add("align", "center")

        Return rijheader
    End Function

    Private Function MaakKolomHeaders(ByVal kolommen() As String, ByVal aantalkolommen As Integer) As HtmlGenericControl

        Dim headerrow As New HtmlGenericControl("tr")

        'Ongebruikt vakje linksboven
        headerrow.Controls.Add(New HtmlGenericControl("th"))

        '<th> tag toevoegen voor elke kolom
        Dim i As Integer = 0
        While i < aantalkolommen

            Dim kolomheader As New HtmlGenericControl("th")
            Dim headerlabel As New Label()

            headerlabel.Text = kolommen(i)
            kolomheader.Controls.Add(headerlabel)
            kolomheader.Attributes.Add("align", "center")
            headerrow.Controls.Add(kolomheader)

            i = i + 1
        End While

        Return headerrow
    End Function

    Private Function MaakKolommenAan() As String()
        Dim beginkolommen() As String = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
        Dim totaalkolommen(675) As String

        Dim i As Integer = 0
        For Each letter In beginkolommen
            For Each tweedeletter In beginkolommen
                totaalkolommen(i) = String.Concat(letter, tweedeletter)
                i = i + 1
            Next
        Next

        Return totaalkolommen
    End Function

#End Region


End Class
