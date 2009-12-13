Imports System.Data

Partial Class App_Presentation_Webpaginas_Beheer_NieuwOnderhoud
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.lblFoutiefID.Visible = False
        Me.divVolledigFormulier.Visible = True

        If Request.QueryString("autoID") IsNot Nothing Or ViewState("autoID") IsNot Nothing Then

            If (Not IsPostBack) Then

                Try
                    Dim autoID As Integer = Convert.ToInt32(Request.QueryString("autoID"))
                    ViewState("autoID") = autoID

                    'Onderhoudsdatum invullen
                    Me.txtOnderhoudsdatum.Text = Format(Now, "dd/MM/yyyy")

                    'Nieuw onderhoud aanmaken
                    If ViewState("onderhoudAangemaakt") Is Nothing Then ViewState("onderhoudAangemaakt") = False
                    If ViewState("onderhoudAangemaakt") = False Then
                        MaakNieuwOnderhoudAan()
                        ViewState("onderhoudAangemaakt") = True
                    End If

                    'Beschadigingsoverzicht vullen
                    VulBeschadigingsOverzicht()

                    'DDLKlantNieuweBeschadiging vullen
                    VulddlKlantNieuweBeschadiging()

                    'Onderhoudsactieoverzicht vullen
                    VulOnderhoudsActieOverzicht()

                    'Standaardonderhoudsacties vullen
                    VulddlPrefabOnderhoudsActies()

                    Me.txtDatumOpmerkingNieuweBeschadiging.Text = Format(Now, "dd/MM/yyyy")

                Catch ex As Exception
                    Throw ex
                End Try

            End If

            'Bij een postback gaan we kijken of deze van een parkeeroverzichtsknop komt.
            If (IsPostBack) Then
                For i As Integer = 1 To Page.Request.Form.Keys.Count - 1
                    Dim str As String = Page.Request.Form.Keys(i)

                    If str Is Nothing Then Continue For

                    If str.Contains("ctl00$plcMain$btn_") Then
                        'Eerst de buttons terug maken
                        UpdateParkeerOverzicht()

                        Dim control As String = str.Remove(str.Length - 2)
                        Dim button As ImageButton = Page.FindControl(control)
                        control = button.ID.Remove(0, 4)
                        Dim nummers() As String = control.Split("_")
                        Dim rij As Integer = Convert.ToInt32(nummers(0))
                        Dim kolom As Integer = Convert.ToInt32(nummers(1))

                        Dim kolommen() As String = MaakKolommenAan()
                        Me.lblNazichtParkeerPlaats.Text = String.Concat(kolommen(kolom), "-", rij + 1)

                        Dim parkeerbll As New ParkeerBLL
                        Dim p As Autos.tblParkeerPlaatsRow = parkeerbll.GetParkeerPlaatsByRijKolomFiliaalID(ViewState("filiaalID"), rij, kolom)
                        parkeerbll = Nothing
                        Me.txtAutoParkeerplaats.Text = p.parkeerPlaatsID

                        Me.plcParkingLayout.Visible = False

                        Return
                    End If
                Next
            End If

        Else
            Me.divVolledigFormulier.Visible = False
            Me.lblFoutiefID.Visible = True
            Me.lblFoutiefID.Text = "Een belangrijke parameter (autoID) werd foutief meegegeven."
        End If
    End Sub

#Region "Methods voor overzichten en dropdownlists"

    Private Sub VulBeschadigingsOverzicht()
        Try
            Dim autoID As Integer = Convert.ToInt32(ViewState("autoID"))

            Dim beschadigingbll As New BeschadigingBLL
            Dim klantbll As New KlantBLL

            'Beschadigingen ophalen
            Dim beschadigingdt As Onderhoud.tblAutoBeschadigingDataTable = beschadigingbll.GetAllBeschadigingByAutoID(autoID)

            Dim weergavetabel As New Data.DataTable
            weergavetabel.Columns.Add("BeschadigingID", Type.GetType("System.Int32"))
            weergavetabel.Columns.Add("KlantNaamVoornaam", Type.GetType("System.String"))
            weergavetabel.Columns.Add("DatumOpmerking", Type.GetType("System.DateTime"))
            weergavetabel.Columns.Add("Omschrijving", Type.GetType("System.String"))
            weergavetabel.Columns.Add("IsHersteld", Type.GetType("System.String"))
            weergavetabel.Columns.Add("Herstellingskost", Type.GetType("System.String"))
            weergavetabel.Columns.Add("IsOudeBeschadiging", Type.GetType("System.String"))

            Dim weergaverow As DataRow = weergavetabel.NewRow

            For Each b As Onderhoud.tblAutoBeschadigingRow In beschadigingdt
                weergaverow.Item("BeschadigingID") = b.autoBeschadigingID

                Dim profiel As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(b.beschadigingAangerichtDoorKlant).Rows(0)
                weergaverow.Item("KlantNaamVoornaam") = String.Concat(profiel.userNaam, " ", profiel.userVoornaam)

                weergaverow.Item("DatumOpmerking") = b.beschadigingDatum

                weergaverow.Item("Omschrijving") = b.beschadigingOmschrijving

                If (b.beschadigingIsHersteld) Then
                    weergaverow.Item("IsHersteld") = "Ja"
                Else
                    weergaverow.Item("IsHersteld") = "Nee"
                End If

                If (b.beschadigingKost = -1) Then
                    weergaverow.Item("Herstellingskost") = "Niet hersteld"
                Else
                    weergaverow.Item("Herstellingskost") = b.beschadigingKost.ToString
                End If

                If (ViewState("controleID") = b.controleID) Then
                    weergaverow.Item("IsOudeBeschadiging") = "Nee"
                Else
                    weergaverow.Item("IsOudeBeschadiging") = "Ja"
                End If

                'Rij toevoegen
                weergavetabel.Rows.Add(weergaverow)

                'Nieuwe rij maken
                weergaverow = weergavetabel.NewRow

            Next

            ViewState("aantalBeschadigingen") = weergavetabel.Rows.Count

            If (weergavetabel.Rows.Count = 0) Then
                Me.divBeschadigingsoverzicht.Visible = False
                Me.lblGeenBeschadigingen.Text = "Er werden geen beschadigingen gevonden voor deze auto."
                Me.lblGeenBeschadigingen.Visible = True

                Me.divBeschadigingWijzigen.Visible = False
                Me.lblBeschadigingWijzigenKanNiet.Visible = True

                Me.divBeschadigingVerwijderen.Visible = False
                Me.lblBeschadigingVerwijderenKanNiet.Visible = True
            Else


                VulddlBeschadigingen(beschadigingdt)


                Me.repBeschadigingsOverzicht.DataSource = weergavetabel
                Me.repBeschadigingsOverzicht.DataBind()

                Me.lblGeenBeschadigingen.Visible = False
                Me.divBeschadigingsoverzicht.Visible = True

                Me.divBeschadigingWijzigen.Visible = True
                Me.lblBeschadigingWijzigenKanNiet.Visible = False

                Me.divBeschadigingVerwijderen.Visible = True
                Me.lblBeschadigingVerwijderenKanNiet.Visible = False
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub VulddlKlantNieuweBeschadiging()
        Try
            Me.ddlKlanten.Items.Clear()
            Me.ddlKlantNieuweBeschadiging.Items.Clear()

            Dim autoID As Integer = Convert.ToInt32(ViewState("autoID"))

            Dim reservatiebll As New ReservatieBLL
            Dim klantbll As New KlantBLL

            'Alle reservaties ophalen van deze auto
            Dim oudereservaties As Reservaties.tblReservatieDataTable = reservatiebll.GetAllReservatiesByAutoID(autoID)

            For Each row As Reservaties.tblReservatieRow In oudereservaties

                If (Me.txtOnderhoudsdatum.Text > row.reservatieEinddat) Then

                    'Klant van deze reservatie ophalen
                    Dim klant As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(row.userID).Rows(0)

                    'Toevoegen aan DDL
                    Dim item As New ListItem(String.Concat(klant.userNaam, " ", klant.userVoornaam), klant.userID.ToString)
                    Me.ddlKlantNieuweBeschadiging.Items.Add(item)
                    Me.ddlKlanten.Items.Add(item)

                End If
            Next

            Me.ddlKlantNieuweBeschadiging.DataBind()
            Me.ddlKlanten.DataBind()

            If (ViewState("aantalBeschadigingen") > 0) Then
                VulBeschadigingWijzigen()
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub VulddlBeschadigingen(ByRef beschadigingdt As Onderhoud.tblAutoBeschadigingDataTable)
        Me.ddlBeschadigingen.Items.Clear()
        Me.ddlBeschadigingenVerwijderen.Items.Clear()

        Dim autoID As Integer = Convert.ToInt32(ViewState("autoID"))

        For Each r As Onderhoud.tblAutoBeschadigingRow In beschadigingdt
            Dim item As New ListItem(String.Concat("#", r.autoBeschadigingID, " - ", Format(r.beschadigingDatum, "dd/MM/yyyy")), r.autoBeschadigingID)
            Me.ddlBeschadigingen.Items.Add(item)
            Me.ddlBeschadigingenVerwijderen.Items.Add(item)
        Next

        Me.ddlBeschadigingen.DataBind()
        Me.ddlBeschadigingenVerwijderen.DataBind()

        If (beschadigingdt.Rows.Count > 0) Then
            VulBeschadigingWijzigen()
        End If

    End Sub

#End Region

#Region "Methods voor beschadiging toe te voegen"

    Protected Sub chkLaatsteKlantWasVerantwoordelijk_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkLaatsteKlantWasVerantwoordelijk.CheckedChanged

        Me.ddlKlantNieuweBeschadiging.Enabled = Not Me.chkLaatsteKlantWasVerantwoordelijk.Checked
        Me.ddlKlantNieuweBeschadiging.Visible = Not Me.chkLaatsteKlantWasVerantwoordelijk.Checked

        Me.lblRecentsteKlant.Visible = Me.chkLaatsteKlantWasVerantwoordelijk.Checked

        If (Me.chkLaatsteKlantWasVerantwoordelijk.Checked) Then
            Dim reservatiebll As New ReservatieBLL
            Dim klantbll As New KlantBLL

            Dim r As Reservaties.tblReservatieRow = reservatiebll.GetMeestRecenteReservatieByAutoID(ViewState("autoID"))

            'ff checken
            If r Is Nothing Then
                Me.ddlKlantNieuweBeschadiging.Enabled = True
                Me.ddlKlantNieuweBeschadiging.Visible = True
                Me.lblRecentsteKlant.Visible = False
                Me.chkLaatsteKlantWasVerantwoordelijk.Checked = False
                Return
            End If

            'Klant van deze reservatie ophalen
            Dim klant As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(r.userID).Rows(0)

            'In label steken
            Me.lblRecentsteKlant.Text = String.Concat(klant.userNaam, " ", klant.userVoornaam)
            ViewState("lblRecentsteKlantUserID") = klant.userID.ToString
        End If
    End Sub

    Protected Sub chkIsHersteldNieuweBeschadiging_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkIsHersteldNieuweBeschadiging.CheckedChanged

        Me.lblKostNieuweBeschadiging.Visible = Me.chkIsHersteldNieuweBeschadiging.Checked()
        Me.txtKostNieuweBeschadiging.Visible = Me.chkIsHersteldNieuweBeschadiging.Checked()

    End Sub

    Protected Sub btnBeschadigingToevoegen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBeschadigingToevoegen.Click

        Dim beschadigingsbll As New BeschadigingBLL

        Dim dt As New Onderhoud.tblAutoBeschadigingDataTable
        Dim b As Onderhoud.tblAutoBeschadigingRow = dt.NewRow

        b.autoID = ViewState("autoID")
        b.beschadigingDatum = Date.Parse(Me.txtDatumOpmerkingNieuweBeschadiging.Text)
        b.beschadigingOmschrijving = Me.txtOmschrijvingNieuweBeschadiging.InnerText
        b.beschadigingIsHersteld = Me.chkIsHersteldNieuweBeschadiging.Checked

        'Deze beschadiging is momenteel nog niet doorverrekend.
        b.beschadigingIsDoorverrekend = 0

        If (Me.chkIsHersteldNieuweBeschadiging.Checked) Then
            b.beschadigingKost = Convert.ToDouble(Me.txtKostNieuweBeschadiging.Text)
        Else
            b.beschadigingKost = -1
        End If

        If (Me.chkLaatsteKlantWasVerantwoordelijk.Checked) Then
            b.beschadigingAangerichtDoorKlant = New Guid(ViewState("lblRecentsteKlantUserID").ToString)
        Else
            b.beschadigingAangerichtDoorKlant = New Guid(Me.ddlKlantNieuweBeschadiging.SelectedValue)
        End If

        b.controleID = ViewState("controleID")

        Dim beschadigingID As Integer = beschadigingsbll.InsertBeschadiging(b)

        'Opslaan in viewstate
        If ViewState("BeschadigingenVanDitOnderhoud") Is Nothing Then ViewState("BeschadigingenVanDitOnderhoud") = String.Empty
        ViewState("BeschadigingenVanDitOnderhoud") = String.Concat(ViewState("BeschadigingenVanDitOnderhoud"), beschadigingID, ";")

        VoegFotoToeVanBeschadiging(beschadigingID)

        VulBeschadigingsOverzicht()

        ClearBeschadigingToevoegen()

    End Sub

    Private Sub ClearBeschadigingToevoegen()
        Me.txtDatumOpmerkingNieuweBeschadiging.Text = Format(Now, "dd/MM/yyyy")
        Me.txtOmschrijvingNieuweBeschadiging.InnerText = String.Empty
        Me.chkIsHersteldNieuweBeschadiging.Checked = False
        Me.txtKostNieuweBeschadiging.Text = String.Empty
    End Sub

#End Region

#Region "Methods voor beschadiging te wijzigen"

    Protected Sub ddlBeschadigingen_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBeschadigingen.SelectedIndexChanged
        VulBeschadigingWijzigen()
    End Sub

    Private Sub VulBeschadigingWijzigen()

        Dim beschadigingID As Integer = Me.ddlBeschadigingen.SelectedValue

        Dim beschadigingbll As New BeschadigingBLL

        Dim b As Onderhoud.tblAutoBeschadigingRow = beschadigingbll.GetBeschadigingByBeschadigingID(beschadigingID)

        If b Is Nothing Then Return

        Me.txtDatumVanOpmerking.Text = Format(b.beschadigingDatum, "dd/MM/yyyy")
        Me.txtOmschrijving.InnerText = b.beschadigingOmschrijving
        Me.chkIsHersteld.Checked = b.beschadigingIsHersteld

        Me.lblHerstellingskost.Visible = b.beschadigingIsHersteld
        Me.txtHerstellingskost.Visible = b.beschadigingIsHersteld

        If (b.beschadigingIsHersteld) Then
            Me.txtHerstellingskost.Text = b.beschadigingKost
        End If

        For i As Integer = 0 To Me.ddlKlanten.Items.Count - 1
            If (Me.ddlKlanten.Items(i).Value = b.beschadigingAangerichtDoorKlant.ToString()) Then
                Me.ddlKlanten.Items(i).Selected = True
            Else
                Me.ddlKlanten.Items(i).Selected = False
            End If
        Next i

    End Sub

    Protected Sub chkIsHersteld_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkIsHersteld.CheckedChanged

        Me.lblHerstellingskost.Visible = Me.chkIsHersteld.Checked()
        Me.txtHerstellingskost.Visible = Me.chkIsHersteld.Checked()

    End Sub

    Protected Sub btnBeschadigingWijzigen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBeschadigingWijzigen.Click
        Dim beschadigingbll As New BeschadigingBLL

        Dim b As Onderhoud.tblAutoBeschadigingRow = beschadigingbll.GetBeschadigingByBeschadigingID(Me.ddlBeschadigingen.SelectedValue)

        b.beschadigingDatum = Date.Parse(Me.txtDatumVanOpmerking.Text)
        b.beschadigingOmschrijving = Me.txtOmschrijving.InnerText
        b.beschadigingIsHersteld = Me.chkIsHersteld.Checked

        If (Me.chkIsHersteld.Checked) Then
            b.beschadigingKost = Convert.ToDouble(Me.txtHerstellingskost.Text)
        Else
            b.beschadigingKost = -1
        End If

        If (Me.chkLaatsteKlantWasVerantwoordelijk.Checked) Then
            b.beschadigingAangerichtDoorKlant = New Guid(Me.ddlKlanten.SelectedValue)
        End If

        beschadigingbll.UpdateBeschadiging(b)

        VulBeschadigingsOverzicht()
    End Sub

    Private Sub ClearBeschadigingWijzigen()
        Me.txtDatumVanOpmerking.Text = Format(Now, "dd/MM/yyyy")
        Me.txtOmschrijving.InnerText = String.Empty
        Me.chkIsHersteld.Checked = False
        Me.txtHerstellingskost.Text = String.Empty
    End Sub

#End Region

#Region "Methods voor beschadiging te verwijderen"

    Protected Sub btnBeschadigingVerwijderen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBeschadigingVerwijderen.Click
        Dim beschadigingbll As New BeschadigingBLL

        'Verwijderen uit viewstate
        If ViewState("BeschadigingenVanDitOnderhoud") IsNot Nothing Then

            Dim numberarray() As String = ViewState("BeschadigingenVanDitOnderhoud").ToString.Split(";")
            Dim nieuwestring As String = String.Empty

            For Each number As String In numberarray

                If Not number = Me.ddlBeschadigingenVerwijderen.SelectedValue Then
                    nieuwestring = String.Concat(nieuwestring, number, ";")
                End If

            Next number

        End If

        'Echt verwijderen
        beschadigingbll.DeleteBeschadiging(Me.ddlBeschadigingenVerwijderen.SelectedValue)

        ClearBeschadigingWijzigen()

        VulBeschadigingsOverzicht()

    End Sub

#End Region

#Region "Methods om foto toe te voegen"

    Private Sub VoegFotoToeVanBeschadiging(ByVal beschadigingID As Integer)

        Dim fotobll As New AutoFotoBLL
        Dim dt As New Autos.tblAutofotoDataTable
        Dim r As Autos.tblAutofotoRow = dt.NewRow

        r.autoID = ViewState("autoID")

        'Decodeer het lblAutoFoto-formulierveld naar een byte-array
        r.autoFoto = Convert.FromBase64String(Session("beschadigingFoto"))

        r.autoFotoType = Session("beschadigingFotoType").ToString

        r.autoFotoDatum = Now

        r.autoFotoVoorReservatie = 0

        r.beschadigingID = beschadigingID

        fotobll.InsertBeschadigingAutoFoto(r)

        fotobll = Nothing
        dt = Nothing
        r = Nothing
    End Sub

    Public Sub FotoGeupload()
        Dim upload As AjaxControlToolkit.AsyncFileUpload = Me.fupFotoBeschadiging

        Try
            Dim grootte As Integer = upload.PostedFile.InputStream.Length
            Dim file As Byte() = New Byte(grootte) {}
            upload.PostedFile.InputStream.Read(file, 0, grootte)

            'Encodeer het bestandje naar stringformaat en slaag het op in het formulier
            Session("beschadigingFoto") = Convert.ToBase64String(file)

            'Slaag het content-type op
            Session("beschadigingFotoType") = upload.PostedFile.ContentType
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region

    Protected Sub imgParkeerPlaats_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgParkeerPlaats.Click
        UpdateParkeerOverzicht()
    End Sub

    Private Sub UpdateParkeerOverzicht()
        Dim filiaalID As Integer = ViewState("filiaalID")

        Dim filiaalbll As New FiliaalBLL
        Dim f As Autos.tblFiliaalRow = filiaalbll.GetFiliaalByFiliaalID(ViewState("filiaalID")).Rows(0)
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
        Dim p As Autos.tblParkeerPlaatsRow = parkeerbll.GetParkeerPlaatsByRijKolomFiliaalID(ViewState("filiaalID"), i, j)

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

    Private Sub MaakNieuwOnderhoudAan()
        Dim controlebll As New ControleBLL

        Dim dt As New Onderhoud.tblControleDataTable
        Dim c As Onderhoud.tblControleRow = dt.NewRow

        c.autoID = ViewState("autoID")
        c.medewerkerID = New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())
        c.controleBegindat = Me.txtOnderhoudsdatum.Text
        c.controleEinddat = Me.txtOnderhoudsdatum.Text
        'Momenteel op 0 laten
        c.controleIsNazicht = 0

        Dim controleID As Integer = controlebll.InsertNieuweControle(c)

        ViewState("controleID") = controleID

        'Voor parkeerplaats
        HaalAutoGegevensOpEnSteekInViewstate()
    End Sub

    Private Sub HaalAutoGegevensOpEnSteekInViewstate()
        Dim autobll As New AutoBLL
        Dim r As Autos.tblAutoRow = autobll.GetAutoByAutoID(ViewState("autoID")).Rows(0)

        Dim brandstofbll As New BrandstofBLL
        Dim b As Autos.tblBrandstofRow = brandstofbll.GetBrandstofByBrandstofID(r.brandstofID)

        ViewState("brandstofKostPerLiter") = b.brandstofKostPerLiter
        ViewState("filiaalID") = r.filiaalID
        ViewState("autoTankInhoud") = r.autoTankInhoud
        ViewState("autoHuidigeKilometerstand") = r.autoHuidigeKilometerstand
        ViewState("autoKMTotOlieVerversing") = r.autoKMTotOlieVerversing
    End Sub

    Private Sub VulOnderhoudsActieOverzicht()
        Dim actiebll As New ActieBLL

        Dim weergavetabel As Onderhoud.tblActieDataTable = actiebll.GetAllActiesByControleID(ViewState("controleID"))

        If weergavetabel.Rows.Count = 0 Then
            Me.divOnderhoudsActieOverzicht.Visible = False
            Me.lblGeenOnderhoudsActies.Visible = True

            Me.divOnderhoudsActieVerwijderen.Visible = False
            Me.lblOnderhoudsActieVerwijderenKanNiet.Visible = True

            Me.divOnderhoudsActieWijzigen.Visible = False
            Me.lblOnderhoudsActiesWijzigenKanNiet.Visible = True

        Else

            VulddlOnderhoudsActieWijzigen(weergavetabel)

            Me.divOnderhoudsActieOverzicht.Visible = True
            Me.lblGeenOnderhoudsActies.Visible = False

            Me.divOnderhoudsActieVerwijderen.Visible = True
            Me.lblOnderhoudsActieVerwijderenKanNiet.Visible = False

            Me.divOnderhoudsActieWijzigen.Visible = True
            Me.lblOnderhoudsActiesWijzigenKanNiet.Visible = False

            Me.RepOnderhoudsActies.DataSource = weergavetabel
            Me.RepOnderhoudsActies.DataBind()
        End If
    End Sub

    Private Sub VulddlPrefabOnderhoudsActies()
        Me.ddlPrefabOnderhoudsActies.Items.Clear()
        Me.ddlPrefabOnderhoudsActiesWijzigen.Items.Clear()

        Dim actiebll As New ActieBLL
        Dim dt As Onderhoud.tblActieDataTable = actiebll.GetAllStandaardActies()

        Me.ddlPrefabOnderhoudsActies.DataSource = dt
        Me.ddlPrefabOnderhoudsActies.DataBind()
        PasKostAanActieToevoegen()

        Me.ddlPrefabOnderhoudsActiesWijzigen.DataSource = dt
        Me.ddlPrefabOnderhoudsActiesWijzigen.DataBind()
        PasKostAanActieWijzigen()
    End Sub

    Private Sub ClearOnderhoudsActieToevoegen()
        Me.txtAndereOnderhoudsActie.Text = String.Empty
        Me.txtKostOnderhoudsActie.Text = String.Empty
    End Sub

    Protected Sub btnOnderhoudsActieToevoegen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOnderhoudsActieToevoegen.Click

        Dim actieID As Integer = -1

        'Als we bezig zijn met een non-standaard actie,
        'slagen we hem eerst op
        If Not Me.txtAndereOnderhoudsActie.Text = String.Empty And _
            Not Me.txtKostOnderhoudsActie.Text = String.Empty And _
            Me.rdbAndereActieToevoegen.Checked Then

            Dim actiebll As New ActieBLL

            Dim dt As New Onderhoud.tblActieDataTable
            Dim a As Onderhoud.tblActieRow = dt.NewRow

            a.actieIsStandaard = 0
            a.actieKost = Me.txtKostOnderhoudsActie.Text
            a.actieOmschrijving = Me.txtAndereOnderhoudsActie.Text

            actieID = actiebll.InsertActie(a)

        ElseIf (Me.rdbStandaardActieToevoegen.Checked) Then
            actieID = Me.ddlPrefabOnderhoudsActies.SelectedValue
        Else
            Return
        End If

        'Controleactie toevoegen
        Dim controleactiebll As New ControleActieBLL
        Dim tempdt As New Onderhoud.tblControleActieDataTable
        Dim r As Onderhoud.tblControleActieRow = tempdt.NewRow

        r.actieID = actieID
        r.controleID = ViewState("controleID")

        controleactiebll.InsertControleactie(r)

        VulOnderhoudsActieOverzicht()

        ClearOnderhoudsActieToevoegen()

    End Sub

    Protected Sub ddlPrefabOnderhoudsActies_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPrefabOnderhoudsActies.SelectedIndexChanged
        PasKostAanActieToevoegen()
    End Sub

    Private Sub PasKostAanActieToevoegen()
        Dim actiebll As New ActieBLL
        Me.txtKostOnderhoudsActie.Text = actiebll.GetActieByActieID(Me.ddlPrefabOnderhoudsActies.SelectedValue).actieKost
        actiebll = Nothing
    End Sub

    Private Sub PasKostAanActieWijzigen()
        Dim actiebll As New ActieBLL
        Me.txtOnderhoudskostWijzigen.Text = actiebll.GetActieByActieID(Me.ddlPrefabOnderhoudsActies.SelectedValue).actieKost
        actiebll = Nothing
    End Sub

    Protected Sub ddlPrefabOnderhoudsActiesWijzigen_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPrefabOnderhoudsActiesWijzigen.SelectedIndexChanged
        PasKostAanActieWijzigen()
    End Sub

    Protected Sub rdbStandaardActieToevoegen_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdbStandaardActieToevoegen.CheckedChanged

        ClearOnderhoudsActieToevoegen()

        If (Me.rdbStandaardActieToevoegen.Checked) Then
            Me.txtAndereOnderhoudsActie.Enabled = False
            Me.txtKostOnderhoudsActie.Enabled = False
            Me.ddlPrefabOnderhoudsActies.Enabled = True
            PasKostAanActieToevoegen()

        ElseIf (Me.rdbAndereActieToevoegen.Checked) Then
            Me.txtAndereOnderhoudsActie.Enabled = True
            Me.txtKostOnderhoudsActie.Enabled = True
            Me.ddlPrefabOnderhoudsActies.Enabled = False
        End If
    End Sub

    Protected Sub rdbAndereActieToevoegen_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdbAndereActieToevoegen.CheckedChanged
        ClearOnderhoudsActieToevoegen()

        If (Me.rdbStandaardActieToevoegen.Checked) Then
            Me.txtAndereOnderhoudsActie.Enabled = False
            Me.txtKostOnderhoudsActie.Enabled = False
            Me.ddlPrefabOnderhoudsActies.Enabled = True
            PasKostAanActieToevoegen()

        ElseIf (Me.rdbAndereActieToevoegen.Checked) Then
            Me.txtAndereOnderhoudsActie.Enabled = True
            Me.txtKostOnderhoudsActie.Enabled = True
            Me.ddlPrefabOnderhoudsActies.Enabled = False
        End If
    End Sub

    Private Sub VulddlOnderhoudsActieWijzigen(ByRef actiedt As Onderhoud.tblActieDataTable)
        Me.ddlOnderhoudsActieWijzigen.Items.Clear()
        Me.ddlOnderhoudsActiesVerwijderen.Items.Clear()

        Dim autoID As Integer = Convert.ToInt32(ViewState("autoID"))

        For Each a As Onderhoud.tblActieRow In actiedt
            Dim item As New ListItem(String.Concat("#", a.actieID, " - ", a.actieOmschrijving), a.actieID)
            Me.ddlOnderhoudsActieWijzigen.Items.Add(item)
            Me.ddlOnderhoudsActiesVerwijderen.Items.Add(item)
        Next a

        Me.ddlOnderhoudsActieWijzigen.DataBind()
        Me.ddlOnderhoudsActiesVerwijderen.DataBind()

        If (actiedt.Rows.Count > 0) Then
            VulActieWijzigen()
        End If

    End Sub

    Protected Sub ddlOnderhoudsActieWijzigen_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlOnderhoudsActieWijzigen.SelectedIndexChanged
        ClearVeldenActieWijzigen()
        VulActieWijzigen()
    End Sub

    Private Sub VulActieWijzigen()
        Dim actiebll As New ActieBLL
        Dim a As Onderhoud.tblActieRow = actiebll.GetActieByActieID(Me.ddlOnderhoudsActieWijzigen.SelectedValue)

        If (a.actieIsStandaard) Then

            For i As Integer = 0 To Me.ddlPrefabOnderhoudsActiesWijzigen.Items.Count - 1
                If (a.actieID = Me.ddlPrefabOnderhoudsActiesWijzigen.Items(i).Value) Then
                    Me.ddlPrefabOnderhoudsActiesWijzigen.Items(i).Selected = True
                Else
                    Me.ddlPrefabOnderhoudsActiesWijzigen.Items(i).Selected = False
                End If
            Next i

            Me.rdbStandaardActieWijzigen.Checked = True
            Me.rdbAndereActieWijzigen.Checked = False

        Else
            Me.rdbStandaardActieWijzigen.Checked = False
            Me.rdbAndereActieWijzigen.Checked = True

            Me.txtAndereActieWijzigen.Text = a.actieOmschrijving
        End If

        Me.txtOnderhoudskostWijzigen.Text = a.actieKost

        VeldenActieWijzigenAanpassen()
    End Sub

    Private Sub VeldenActieWijzigenAanpassen()

        If (Me.rdbStandaardActieWijzigen.Checked) Then
            Me.txtAndereActieWijzigen.Enabled = False
            Me.txtOnderhoudskostWijzigen.Enabled = False
            Me.rdbAndereActieWijzigen.Checked = False
            Me.rdbStandaardActieWijzigen.Checked = True
            Me.ddlPrefabOnderhoudsActiesWijzigen.Enabled = True
        ElseIf (Me.rdbAndereActieWijzigen.Checked) Then
            Me.txtAndereActieWijzigen.Enabled = True
            Me.txtOnderhoudskostWijzigen.Enabled = True
            Me.rdbAndereActieWijzigen.Checked = True
            Me.rdbStandaardActieWijzigen.Checked = False
            Me.ddlPrefabOnderhoudsActiesWijzigen.Enabled = False
        Else
            Return
        End If

    End Sub

    Private Sub ClearVeldenActieWijzigen()
        Me.txtAndereActieWijzigen.Text = String.Empty
        Me.txtOnderhoudskostWijzigen.Text = String.Empty
    End Sub

    Protected Sub rdbAndereActieWijzigen_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdbAndereActieWijzigen.CheckedChanged
        ClearVeldenActieWijzigen()
        VeldenActieWijzigenAanpassen()
    End Sub

    Protected Sub rdbStandaardActieWijzigen_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdbStandaardActieWijzigen.CheckedChanged
        ClearVeldenActieWijzigen()
        VeldenActieWijzigenAanpassen()
    End Sub

    Protected Sub btnOnderhoudsActieWijzigen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOnderhoudsActieWijzigen.Click

        Dim actieID As Integer = -1

        If (Me.rdbAndereActieWijzigen.Checked) Then

            Dim actiebll As New ActieBLL
            Dim oudeactie As Onderhoud.tblActieRow = actiebll.GetActieByActieID(Me.ddlOnderhoudsActieWijzigen.SelectedValue)

            If oudeactie.actieIsStandaard = 1 Then

                'We zijn overgestapt van een standaardactie naar een niet-standaardactie
                'Nieuwe actie toevoegen, dus (we kunnen de standaardacties niet overschrijven)

                Dim dt As New Onderhoud.tblActieDataTable
                Dim nieuweactie As Onderhoud.tblActieRow = dt.NewRow

                nieuweactie.actieIsStandaard = 0
                nieuweactie.actieKost = Me.txtOnderhoudskostWijzigen.Text
                nieuweactie.actieOmschrijving = Me.txtAndereActieWijzigen.Text

                'Nieuwe actie erin steken
                actieID = actiebll.InsertActie(nieuweactie)
            Else
                'Gewoon de waarde gebruiken van de oude actie
                actieID = Me.ddlOnderhoudsActieWijzigen.SelectedValue
            End If

        ElseIf (Me.rdbStandaardActieWijzigen.Checked) Then
            'Waarde gebruiken uit de standaardacties-dropdown
            actieID = Me.ddlPrefabOnderhoudsActiesWijzigen.SelectedValue
        Else
            Return
        End If

        'Controleactie wijzigen
        Dim controleactiebll As New ControleActieBLL
        Dim r As Onderhoud.tblControleActieRow = controleactiebll.GetControleActieByControleIDAndActieID(ViewState("controleID"), Me.ddlOnderhoudsActieWijzigen.SelectedValue)

        'actieID updaten
        r.actieID = actieID

        controleactiebll.UpdateControleActie(r)

        VulOnderhoudsActieOverzicht()

        ClearVeldenActieWijzigen()
    End Sub

    Protected Sub btnOnderhoudsActieVerwijderen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOnderhoudsActieVerwijderen.Click
        Dim controleactiebll As New ControleActieBLL
        Dim r As Onderhoud.tblControleActieRow = controleactiebll.GetControleActieByControleIDAndActieID(ViewState("controleID"), Me.ddlOnderhoudsActiesVerwijderen.SelectedValue)
        controleactiebll.DeleteControleActie(r.ControleActieID)

        VulOnderhoudsActieOverzicht()

        ClearVeldenActieWijzigen()
        ClearOnderhoudsActieToevoegen()
    End Sub

    Protected Sub chkIsNazicht_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkIsNazicht.CheckedChanged

        Me.divNazichtOpties.Visible = Me.chkIsNazicht.Checked

        If (Me.chkIsNazicht.Checked) Then
            Me.lblNazichtTankInhoud.Text = String.Concat(ViewState("autoTankInhoud"), "  liter")
            Me.lblNazichtVorigKilometerstand.Text = ViewState("autoHuidigeKilometerstand")

            If ViewState("autoHuidigeKilometerstand") > ViewState("autoKMTotOlieVerversing") Then
                Me.divOlieMoetVerversdWorden.Visible = True
            Else
                Me.divOlieMoetVerversdWorden.Visible = False
            End If

        End If
    End Sub

    Protected Sub txtNazichtHuidigeKilometerstand_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtNazichtHuidigeKilometerstand.TextChanged
        If Me.txtNazichtHuidigeKilometerstand.Text > ViewState("autoKMTotOlieVerversing") Then
            Me.divOlieMoetVerversdWorden.Visible = True
        Else
            Me.divOlieMoetVerversdWorden.Visible = False
        End If
    End Sub

    Protected Sub btnBerekenBrandstofKost_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBerekenBrandstofKost.Click
        Try
            Dim aantalLiters As Double = Convert.ToDouble(Me.txtNazichtTankNaInchecken.Text)

            Dim totaalkost As Double = (ViewState("autoTankInhoud") - aantalLiters) * ViewState("brandstofKostPerLiter")
            Me.lblNazichtBerekendeBrandstofkost.Text = String.Concat(totaalkost, " €")
        Catch
            Return
        End Try
    End Sub
End Class
