
Partial Class App_Presentation_Webpaginas_Beheer_AutoWijzigen
    Inherits System.Web.UI.Page

    Private bllauto As New AutoBLL
    Private autoOptiebll As New AutoOptieBLL
    Private bllOptie As New OptieBLL
    Private bllautoOptie As New AutoOptieBLL

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim kenteken As String = Request.QueryString("autoKenteken")
        Dim dr As Autos.tblAutoRow
        Dim dtKleur As New Data.DataTable
        Dim dtAutoOptie As New Data.DataTable
        Dim dtOptie As New Autos.tblOptieDataTable
        Dim dtOptieByID As New Autos.tblOptieDataTable


        dr = bllauto.GetAutoByKenteken(kenteken)
        dtAutoOptie = autoOptiebll.GetAutoOptieByAutoID(dr.autoID)
        dtKleur = bllauto.getdistinctKleur
        dtOptie = bllOptie.GetAllOptiesByAutoID(dr.autoID)


        txtTarief.Text = dr.autoDagTarief
        txtOlie.Text = dr.autoKMTotOlieVerversing

        If Not IsPostBack Then
            For i As Integer = 0 To dtAutoOptie.Rows.Count - 1
                Dim optieID As Integer = dtAutoOptie.Rows(i)("optieID")
                dtOptieByID = bllOptie.getOptieByOptieID(optieID)
                lstOpties.Items.Add(New ListItem(dtOptieByID.Rows(0)("optieOmschrijving"), (optieID)))
            Next

            For i As Integer = 0 To dtKleur.Rows.Count - 1
                ddlKleur.Items.Add(dtKleur.Rows(i)("autoKleur"))
            Next
            ddlKleur.SelectedValue = dr.autoKleur
            ddlFiliaal.SelectedValue = dr.filiaalID
            ddlStatus.SelectedValue = dr.statusID
        End If

        'If (IsPostBack) Then
        '    For i As Integer = 1 To Page.Request.Form.Keys.Count - 1
        '        Dim str As String = Page.Request.Form.Keys(i)

        '        If str Is Nothing Then Continue For

        '        If str.Contains("ctl00$plcMain$frvNieuweAuto$btn_") Then
        '            'Eerst de buttons terug maken
        '            UpdateParkeerOverzicht()

        '            Dim control As String = str.Remove(str.Length - 2)
        '            Dim button As ImageButton = Page.FindControl(control)
        '            control = button.ID.Remove(0, 4)
        '            Dim nummers() As String = control.Split("_")
        '            Dim rij As Integer = Convert.ToInt32(nummers(0))
        '            Dim kolom As Integer = Convert.ToInt32(nummers(1))

        '            Dim kolommen() As String = MaakKolommenAan()
        '            Me.lblAutoParkeerplaats.Text = String.Concat(kolommen(kolom), "-", rij + 1)

        '            Dim parkeerbll As New ParkeerBLL
        '            Dim p As Autos.tblParkeerPlaatsRow = parkeerbll.GetParkeerPlaatsByRijKolomFiliaalID(Me.ddlFiliaal.SelectedValue, rij, kolom)
        '            parkeerbll = Nothing
        '            Me.txtAutoParkeerplaats.Text = p.parkeerPlaatsID


        '            Return
        '        End If
        '    Next
        'End If
    End Sub
    Protected Sub btnVoegoptietoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegoptietoe.Click
        Dim pOptie As New Optie
        Dim bllOptie As New OptieBLL

        pOptie.Omschrijving = txtOptieNaam.Text
        pOptie.Prijs = txtOptiePrijs.Text
        bllOptie.AddOptie(pOptie)

        DataBind()

    End Sub

    Protected Sub btnVerwijderLijst_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVerwijderLijst.Click
        If lstOpties.SelectedValue.ToString = String.Empty Then

        Else
            Dim kenteken As String = Request.QueryString("autoKenteken")
            Dim dr As Autos.tblAutoRow
            dr = bllauto.GetAutoByKenteken(kenteken)
            Dim autoID As Integer = dr.autoID
            Dim optieID As Integer = lstOpties.SelectedValue
            For i As Integer = 0 To lstOptiesAdd.Items.Count - 1
                Dim index As Integer = lstOpties.SelectedIndex
                If lstOpties.SelectedItem.Text = lstOptiesAdd.Items(i).Text Then
                    lstOptiesAdd.Items.RemoveAt(i)
                    i = lstOptiesAdd.Items.Count
                End If
            Next
            lstOpties.Items.RemoveAt(lstOpties.SelectedIndex)


            bllautoOptie.deleteAutoOptie(autoID, optieID)
            lstOpties.DataBind()
                End If

    End Sub


    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegtoe.Click
        Dim check As Boolean = True
        For i As Integer = 0 To lstOpties.Items.Count - 1
            If ddlOpties.SelectedValue = lstOpties.Items(i).Value Then
                check = False
            End If
        Next
        If check = True Then
            lstOptiesAdd.Items.Add(New ListItem(ddlOpties.SelectedItem.ToString, ddlOpties.SelectedValue))
            lstOpties.Items.Add(New ListItem(ddlOpties.SelectedItem.ToString, ddlOpties.SelectedValue))
            lblReedsOptie.Text = ""
        Else
            lblReedsOptie.Text = "De auto heeft deze optie reeds."
        End If
    End Sub

    Protected Sub btnNieuweOptie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNieuweOptie.Click
        lblOptieNaam.Visible = True
        txtOptieNaam.Visible = True
        lblOptiePrijs.Visible = True
        txtOptiePrijs.Visible = True
        btnVoegoptietoe.Visible = True
        btnNieuweOptie.Visible = True
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOptiesWijzigen.Click
        Dim autooptiebll As New AutoOptieBLL
        Dim dt2 As New Autos.tblAutoOptieDataTable
        Dim r As Autos.tblAutoOptieRow = dt2.NewRow
        Dim kenteken As String = Request.QueryString("autoKenteken")
        Dim dr As Autos.tblAutoRow
        dr = bllauto.GetAutoByKenteken(kenteken)
        Dim autoID As Integer = dr.autoID
        r.autoID = autoID

        For i As Integer = 0 To lstOptiesAdd.Items.Count - 1
            r.optieID = lstOptiesAdd.Items(i).Value
            If autooptiebll.autoOptieAdd(r) Then
                lblGeslaagd.Text = "Wijziging doorgevoerd."
            End If
        Next
        lstOptiesAdd.Items.Clear()
    End Sub

    Protected Sub btnAlgemeen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAlgemeen.Click
        Dim dt As New Autos.tblAutoDataTable
        Dim dr As Autos.tblAutoRow = dt.NewRow
        Dim kenteken As String = Request.QueryString("autoKenteken")
        Dim drid As Autos.tblAutoRow
        drid = bllauto.GetAutoByKenteken(kenteken)
        Dim autoID As Integer = drid.autoID
        dr.autoID = autoID
        dr.autoDagTarief = txtTarief.Text
        dr.autoKleur = ddlKleur.SelectedValue
        dr.autoKMTotOlieVerversing = txtOlie.Text
        dr.filiaalID = ddlFiliaal.SelectedValue
        dr.statusID = ddlStatus.SelectedValue
        If bllauto.autoWijzigen(dr) = True Then
            lblAlgemeengeslaagd.Text = "Wijziging uitgevoerd."
        Else
            lblAlgemeengeslaagd.Text = "Auto heeft nog reservaties. U kunt nu nog geen wijzigingen doorvoeren."
        End If
    End Sub

    'Protected Sub imgParkeerPlaats_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgParkeerPlaats.Click
    '    UpdateParkeerOverzicht()
    'End Sub

    'Private Sub UpdateParkeerOverzicht()
    '    Dim filiaalID As Integer = ddlFiliaal.SelectedValue

    '    Dim filiaalbll As New FiliaalBLL
    '    Dim f As Autos.tblFiliaalRow = filiaalbll.GetFiliaalByFiliaalID(ddlFiliaal.SelectedValue).Rows(0)
    '    filiaalbll = Nothing

    '    Dim kolommen As Integer = f.parkingAantalKolommen
    '    Dim rijen As Integer = f.parkingAantalRijen

    '    If (f.parkingAantalKolommen = 0 And f.parkingAantalRijen = 0) Then
    '        Me.lblGeenOverzicht.Text = "Dit filiaal heeft nog geen parkeeroverzicht."
    '        Me.lblGeenOverzicht.Visible = True
    '    Else
    '        Me.lblGeenOverzicht.Visible = False

    '        ''Haal alles van DB binnen
    '        'Dim parkeermatrix(,) As Integer = HaalParkingOpVanFiliaal(f.filiaalID, kolommen, rijen)

    '        ''Maak Overzicht
    '        'MaakParkingLayoutOverzicht(parkeermatrix)
    '    End If
    '    Dim parkeermatrix(,) As Integer = HaalParkingOpVanFiliaal(f.filiaalID, kolommen, rijen)

    '    'Maak Overzicht
    '    MaakParkingLayoutOverzicht(parkeermatrix)

    '    updParkingOverzicht.Update()
    'End Sub

    'Private Function HaalParkingOpVanFiliaal(ByVal filiaalID As Integer, ByVal aantalKolommen As Integer, ByVal aantalRijen As Integer) As Integer(,)
    '    Dim parkeerbll As New ParkeerBLL
    '    Dim kolomdt As Data.DataTable = parkeerbll.GetParkeerPlaatsKolommenByFiliaalID(filiaalID)
    '    Dim parkeerdt As Autos.tblParkeerPlaatsDataTable = parkeerbll.GetParkeerPlaatsenByFiliaalID(filiaalID)
    '    Dim parkeermatrix(aantalKolommen, aantalRijen) As Integer

    '    'Opsplitsen in kolommen en rijen
    '    For kolom As Integer = 0 To aantalKolommen - 1
    '        Dim filteredview As Data.DataView = parkeerdt.DefaultView
    '        filteredview.RowFilter = String.Concat("parkeerPlaatsKolom = ", kolomdt.Rows(kolom).Item(0).ToString.Trim)

    '        Dim filtereddt As Data.DataTable = filteredview.ToTable

    '        For rij As Integer = 0 To aantalRijen - 1
    '            parkeermatrix(kolomdt.Rows(kolom).Item(0), rij) = filtereddt.Rows(rij).Item("parkeerPlaatsType")
    '        Next

    '    Next

    '    Return parkeermatrix

    'End Function


    'Private Sub MaakParkingLayoutOverzicht(ByRef parkeermatrix(,) As Integer)

    '    Dim kolommen() As String = MaakKolommenAan()

    '    Dim aantalkolommen As Integer = parkeermatrix.GetUpperBound(0)
    '    Dim aantalrijen As Integer = parkeermatrix.GetUpperBound(1)

    '    Dim table As New HtmlGenericControl("table")

    '    'Vul de kolomheaders in van de tabel.
    '    table.Controls.Add(MaakKolomHeaders(kolommen, aantalkolommen))

    '    'Eigenlijke vakken invullen.
    '    Dim i As Integer = 0
    '    Dim j As Integer = 0

    '    While i < aantalrijen
    '        Dim tablerow As New HtmlGenericControl("tr")

    '        'Header van de rij toevoegen.
    '        tablerow.Controls.Add(MaakRijHeader(i))

    '        'Eigenlijke vakjes toevoegen.
    '        While j < aantalkolommen

    '            tablerow.Controls.Add(MaakVakje(i, j, parkeermatrix))
    '            j = j + 1
    '        End While

    '        table.Controls.Add(tablerow)
    '        i = i + 1
    '        j = 0
    '    End While

    '    plcParkingLayout.Controls.Add(table)

    'End Sub

    'Private Function MaakVakje(ByVal i As Integer, ByVal j As Integer, ByRef parkeermatrix(,) As Integer) As HtmlGenericControl
    '    Dim waarde As Integer = parkeermatrix(j, i)
    '    Dim tabledata As New HtmlGenericControl("td")
    '    Dim button As New ImageButton()

    '    With button
    '        .ID = String.Concat("btn_", i, "_", j)
    '        .BackColor = Drawing.ColorTranslator.FromHtml("#D4E0E8")
    '        .Height = 16
    '        .Width = 16
    '    End With

    '    Dim autobll As New AutoBLL
    '    Dim parkeerbll As New ParkeerBLL
    '    Dim p As Autos.tblParkeerPlaatsRow = parkeerbll.GetParkeerPlaatsByRijKolomFiliaalID(Me.ddlFiliaal.SelectedValue, i, j)

    '    If (autobll.CheckOfParkeerPlaatsAutoBevat(p.parkeerPlaatsID)) Then
    '        button.ImageUrl = "~/App_Presentation/Images/car.png"
    '        button.CssClass = "art-vakje-ParkingBeheer-GeenParking"
    '        button.Enabled = False
    '    Else
    '        If waarde = 0 Then
    '            button.ImageUrl = "~/App_Presentation/Images/parkeerplaats.png"
    '            button.CssClass = "art-vakje-ParkingBeheer"
    '            button.Enabled = True
    '        ElseIf waarde = 1 Then
    '            button.ImageUrl = "~/App_Presentation/Images/rijweg.png"
    '            button.CssClass = "art-vakje-ParkingBeheer-GeenParking"
    '            button.Enabled = False
    '        ElseIf waarde = 2 Then
    '            button.ImageUrl = "~/App_Presentation/Images/house.png"
    '            button.CssClass = "art-vakje-ParkingBeheer-GeenParking"
    '            button.Enabled = False
    '        ElseIf waarde = 4 Then
    '            button.ImageUrl = "~/App_Presentation/Images/spacer.gif"
    '            button.CssClass = "art-vakje-ParkingBeheer-GeenParking"
    '            button.Enabled = False
    '        Else
    '            button.ImageUrl = "~/App_Presentation/Images/spacer.gif"
    '            button.CssClass = "art-vakje-ParkingBeheer-GeenParking"
    '            button.Enabled = False
    '        End If
    '    End If




    '    tabledata.Controls.Add(button)
    '    tabledata.Attributes.Add("align", "center")

    '    'Met deze hoop viewstate-variabelen kunnen we het meest recente overzicht opslaan.
    '    ViewState(button.ID) = waarde

    '    Return tabledata
    'End Function

    'Private Function MaakRijHeader(ByVal i As Integer) As HtmlGenericControl

    '    Dim rijheader As New HtmlGenericControl("th")
    '    Dim headerlabel As New Label()

    '    headerlabel.Text = i + 1
    '    rijheader.Controls.Add(headerlabel)
    '    rijheader.Attributes.Add("align", "center")

    '    Return rijheader
    'End Function

    'Private Function MaakKolomHeaders(ByVal kolommen() As String, ByVal aantalkolommen As Integer) As HtmlGenericControl

    '    Dim headerrow As New HtmlGenericControl("tr")

    '    'Ongebruikt vakje linksboven
    '    headerrow.Controls.Add(New HtmlGenericControl("th"))

    '    '<th> tag toevoegen voor elke kolom
    '    Dim i As Integer = 0
    '    While i < aantalkolommen

    '        Dim kolomheader As New HtmlGenericControl("th")
    '        Dim headerlabel As New Label()

    '        headerlabel.Text = kolommen(i)
    '        kolomheader.Controls.Add(headerlabel)
    '        kolomheader.Attributes.Add("align", "center")
    '        headerrow.Controls.Add(kolomheader)

    '        i = i + 1
    '    End While

    '    Return headerrow
    'End Function

    'Private Function MaakKolommenAan() As String()
    '    Dim beginkolommen() As String = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
    '    Dim totaalkolommen(675) As String

    '    Dim i As Integer = 0
    '    For Each letter In beginkolommen
    '        For Each tweedeletter In beginkolommen
    '            totaalkolommen(i) = String.Concat(letter, tweedeletter)
    '            i = i + 1
    '        Next
    '    Next

    '    Return totaalkolommen
    'End Function

    Protected Sub btnVerwijderen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVerwijderen.Click
        Dim kenteken As String = Request.QueryString("autoKenteken")
        Dim dr As Autos.tblAutoRow
        dr = bllauto.GetAutoByKenteken(kenteken)
        Dim autoID As Integer = dr.autoID

        If bllauto.DeleteAuto(autoID) = True Then
            lblVerwijder.Text = "Auto is verwijderd. (Daar gaat u spijt van krijgen)."
        Else
            lblVerwijder.Text = "Auto kan niet verwijderd worden indien er nog reservaties voor lopen."
        End If

    End Sub
End Class
