Imports System.Data

Partial Class App_Presentation_Webpaginas_Beheer_NieuwOnderhoud
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.lblFoutiefID.Visible = False
        Me.divVolledigFormulier.Visible = True

        If Request.QueryString("controleID") IsNot Nothing Or ViewState("autoID") IsNot Nothing Then

            If (Not IsPostBack) Then

                Try
                    Dim controleID As Integer = Convert.ToInt32(Request.QueryString("controleID"))

                    Dim controlebll As New ControleBLL
                    Dim c As Onderhoud.tblControleRow = controlebll.GetControleByControleID(controleID)
                    controlebll = Nothing

                    If (c.controleIsUitgevoerd = True) Then
                        ViewState("controleIsUitgevoerd") = True
                        Me.lblHoofdTitel.Text = "Onderhoud Wijzigen"
                    Else
                        ViewState("controleIsUitgevoerd") = False
                        Me.lblHoofdTitel.Text = "Onderhoud Uitvoeren"
                    End If

                    'AutoID opslaan in viewstate
                    ViewState("autoID") = c.autoID
                    ViewState("controleID") = controleID

                    'Autogegevens ophalen
                    HaalAutoGegevensOpEnSteekInViewstate()

                    'Onderhoudsdatum invullen
                    Me.lblOnderhoudsDatum.Text = Format(c.controleBegindat, "dd/MM/yyyy")

                    'Beschadigingsoverzicht vullen
                    VulBeschadigingsOverzicht()

                    'DDLKlantNieuweBeschadiging vullen
                    VulddlKlantNieuweBeschadiging()

                    'Onderhoudsactieoverzicht vullen
                    VulOnderhoudsActieOverzicht()

                    'Standaardonderhoudsacties vullen
                    VulddlPrefabOnderhoudsActies()

                    'Kijken of dit onderhoud een nazicht is
                    Me.chkIsNazicht.Checked = c.controleIsNazicht
                    If Me.chkIsNazicht.Checked Then
                        chkIsNazicht_CheckedChanged(sender, e)

                        'Checken of dit nazicht al een reservatie heeft
                        Dim reservatiebll As New ReservatieBLL
                        Dim klantbll As New KlantBLL

                        If DBNull.Value.Equals(c.Item("reservatieID")) Then
                            'nope, nog geen reservatie. We zullen aardig zijn en een 
                            'dropdownlist met reservaties van deze auto aanmaken
                            Dim tr As New HtmlGenericControl("tr")
                            Dim tekst As New HtmlGenericControl("td")
                            Dim ddl As New HtmlGenericControl("td")

                            tekst.InnerText = "Selecteer reservatie:"
                            Dim ddlReservaties As New DropDownList
                            ddlReservaties.ID = "ddlReservaties"

                            Dim reservaties As Reservaties.tblReservatieDataTable = reservatiebll.GetAllIngecheckteReservatiesByAutoID(c.autoID)

                            For Each res As Reservaties.tblReservatieRow In reservaties

                                Dim p As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(res.userID).Rows(0)

                                Dim weergave As String = String.Concat(p.userNaam, " ", p.userVoornaam, " (", Format(res.reservatieBegindat, "dd/MM/yyyy"), " - ", Format(res.reservatieEinddat, "dd/MM/yyyy"))

                                Dim item As New ListItem(weergave, res.reservatieID)
                                ddlReservaties.Items.Add(item)

                            Next res

                            If reservaties.Rows.Count = 0 Then
                                'Dit onderhoud kan geen nazicht zijn,
                                'want er nog niet eens reservaties voor deze auto
                                Me.chkIsNazicht.Visible = False
                                Me.chkIsNazicht.Checked = False
                                chkIsNazicht_CheckedChanged(sender, e)
                                Dim lbl As New HtmlGenericControl("td")
                                lbl.InnerText = "Dit onderhoud kan geen nazicht zijn, want deze auto is nog nooit gereserveerd geweest."
                                lbl.Attributes.Add("colspan", "2")
                                tr.Controls.Add(lbl)

                                Me.lblNazichtIsOnmogelijk.Text = "Dit onderhoud kan geen nazicht zijn, want deze auto is nog nooit gereserveerd geweest."
                                Me.lblNazichtIsOnmogelijk.Visible = True
                            Else
                                Me.lblNazichtIsOnmogelijk.Visible = False
                                ddlReservaties.DataBind()
                                ddl.Controls.Add(ddlReservaties)
                                tr.Controls.Add(tekst)
                                tr.Controls.Add(ddl)
                            End If

                            Me.plcGeenReservatieID.Controls.Add(tr)

                        End If

                    End If

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

                If b.beschadigingAangerichtDoorKlant.ToString = "7a73f865-ec29-4efd-bf09-70a9f9493d21" Then
                    weergaverow.Item("KlantNaamVoornaam") = "Niet door een klant aangericht"
                Else
                    Dim profiel As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(b.beschadigingAangerichtDoorKlant).Rows(0)
                    weergaverow.Item("KlantNaamVoornaam") = String.Concat(profiel.userNaam, " ", profiel.userVoornaam)
                End If

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
            Dim dubbels(oudereservaties.Rows.Count - 1) As String
            Dim i As Integer = 0

            For Each row As Reservaties.tblReservatieRow In oudereservaties

                If (Me.lblOnderhoudsDatum.Text > row.reservatieEinddat) Then

                    'Klant ophalen
                    Dim dt As Klanten.tblUserProfielDataTable = klantbll.GetUserProfielByUserID(row.userID)

                    If dt.Rows.Count = 0 Then Continue For
                    Dim p As Klanten.tblUserProfielRow = dt.Rows(0)

                    'Even nakijken of deze klant al in de dropdown zit.
                    Dim isDubbel As Boolean = False
                    Dim naamvoornaam As String = String.Concat(p.userNaam, " ", p.userVoornaam)
                    For Each naam In dubbels
                        If (naamvoornaam = naam) Then
                            isDubbel = True
                        End If
                    Next naam

                    If (Not isDubbel) Then
                        Dim item As New ListItem(naamvoornaam, p.userID.ToString)
                        Me.ddlKlantNieuweBeschadiging.Items.Add(item)
                        Me.ddlKlanten.Items.Add(item)
                        dubbels(i) = naamvoornaam
                        i = i + 1
                    End If

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

#End Region

#Region "Methods voor beschadiging toe te voegen"

    Private Function ToevoegFormulierBeschadigingIsGeldig() As Boolean

        Me.divBeschToevoegenFeedback.Visible = False

        If Me.ddlKlantNieuweBeschadiging.SelectedValue = String.Empty And _
            Me.chkLaatsteKlantWasVerantwoordelijk.Checked = False And _
            Me.chkGeenKlant.Checked = False Then
            Me.imgBeschToevoegenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschToevoegenFeedback.Text = "Gelieve een optie te kiezen bij ""Klant die de beschadiging toebracht""."
            Me.divBeschToevoegenFeedback.Visible = True
            Return False
        End If

        Try
            Dim datum As Date = Date.Parse(Me.txtDatumOpmerkingNieuweBeschadiging.Text)

            If datum > Now Then
                Me.imgBeschToevoegenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
                Me.lblBeschToevoegenFeedback.Text = "Een beschadiging kan niet in de toekomst worden opgemerkt."
                Me.divBeschToevoegenFeedback.Visible = True
                Return False
            End If

        Catch
            Me.imgBeschToevoegenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschToevoegenFeedback.Text = "Gelieve de datum van opmerking correct in te vullen."
            Me.divBeschToevoegenFeedback.Visible = True
            Return False
        End Try

        If Me.txtOmschrijvingNieuweBeschadiging.InnerText = String.Empty Then
            Me.imgBeschToevoegenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschToevoegenFeedback.Text = "Gelieve de omschrijving van de beschadiging in te vullen."
            Me.divBeschToevoegenFeedback.Visible = True
            Return False
        End If

        If Session("beschadigingFoto") Is Nothing Or Session("beschadigingFotoType") Is Nothing Then
            Me.imgBeschToevoegenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschToevoegenFeedback.Text = "Gelieve een foto van de beschadiging toe te voegen."
            Me.divBeschToevoegenFeedback.Visible = True
            Return False
        End If

        Return True

    End Function

    Protected Sub chkLaatsteKlantWasVerantwoordelijk_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkLaatsteKlantWasVerantwoordelijk.CheckedChanged

        If Me.chkGeenKlant.Checked Then
            Me.chkGeenKlant.Checked = False
        End If

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

    Protected Sub chkGeenKlant_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkGeenKlant.CheckedChanged
        If Me.chkLaatsteKlantWasVerantwoordelijk.Checked Then
            Me.chkLaatsteKlantWasVerantwoordelijk.Checked = False
        End If

        Me.ddlKlantNieuweBeschadiging.Visible = True
        Me.lblRecentsteKlant.Visible = False
        Me.ddlKlantNieuweBeschadiging.Enabled = Not Me.chkGeenKlant.Checked
    End Sub

    Protected Sub btnBeschadigingToevoegen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBeschadigingToevoegen.Click

        If (Not ToevoegFormulierBeschadigingIsGeldig()) Then Return

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
        ElseIf (Me.chkGeenKlant.Checked) Then
            b.beschadigingAangerichtDoorKlant = New Guid("7a73f865-ec29-4efd-bf09-70a9f9493d21")
        Else
            b.beschadigingAangerichtDoorKlant = New Guid(Me.ddlKlantNieuweBeschadiging.SelectedValue)
        End If

        b.controleID = ViewState("controleID")

        Dim beschadigingID As Integer = beschadigingsbll.InsertBeschadiging(b)

        If (beschadigingID = -10) Then
            Me.imgBeschToevoegenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschToevoegenFeedback.Text = "Er is een fout gebeurd tijdens het opslaan van de beschadiging. Gelieve het opnieuw te proberen."
            Me.divBeschToevoegenFeedback.Visible = True
            Return
        End If

        'Opslaan in viewstate
        If ViewState("BeschadigingenVanDitOnderhoud") Is Nothing Then ViewState("BeschadigingenVanDitOnderhoud") = String.Empty
        ViewState("BeschadigingenVanDitOnderhoud") = String.Concat(ViewState("BeschadigingenVanDitOnderhoud"), beschadigingID, ";")

        VoegFotoToeVanBeschadiging(beschadigingID)

        VulBeschadigingsOverzicht()

        ClearBeschadigingToevoegen()

        Me.imgBeschToevoegenFeedback.ImageUrl = "~\App_Presentation\Images\tick.gif"
        Me.lblBeschToevoegenFeedback.Text = "Beschadiging toegevoegd."
        Me.divBeschToevoegenFeedback.Visible = True

    End Sub

    Private Sub ClearBeschadigingToevoegen()
        Me.txtDatumOpmerkingNieuweBeschadiging.Text = Format(Now, "dd/MM/yyyy")
        Me.txtOmschrijvingNieuweBeschadiging.InnerText = String.Empty
        Me.chkIsHersteldNieuweBeschadiging.Checked = False
        Me.txtKostNieuweBeschadiging.Text = String.Empty
        Session("beschadigingFoto") = Nothing
        Session("beschadigingFotoType") = Nothing
    End Sub

#End Region

#Region "Methods voor beschadiging te wijzigen"

    Private Function WijzigFormulierBeschadigingIsGeldig() As Boolean

        Me.divBeschWijzigenFeedback.Visible = False

        If Me.ddlKlanten.SelectedValue = String.Empty And _
            Me.chkNietDoorKlantAangericht.Checked = False Then
            Me.imgBeschWijzigenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschWijzigenFeedback.Text = "Gelieve een optie te kiezen bij ""Klant die de beschadiging toebracht""."
            Me.divBeschWijzigenFeedback.Visible = True
            Return False
        End If

        Try
            Dim datum As Date = Date.Parse(Me.txtDatumVanOpmerking.Text)

            If datum > Now Then
                Me.imgBeschWijzigenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
                Me.lblBeschWijzigenFeedback.Text = "Een beschadiging kan niet in de toekomst worden opgemerkt."
                Me.divBeschWijzigenFeedback.Visible = True
            End If
        Catch
            Me.imgBeschWijzigenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschWijzigenFeedback.Text = "Gelieve de datum van opmerking correct in te vullen."
            Me.divBeschWijzigenFeedback.Visible = True
            Return False
        End Try

        If Me.txtOmschrijving.InnerText = String.Empty Then
            Me.imgBeschWijzigenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschWijzigenFeedback.Text = "Gelieve de omschrijving van de beschadiging in te vullen."
            Me.divBeschWijzigenFeedback.Visible = True
            Return False
        End If

        If Me.chkIsHersteld.Checked Then
            Try
                Double.Parse(Me.txtHerstellingskost.Text)
            Catch
                Me.imgBeschWijzigenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
                Me.lblBeschWijzigenFeedback.Text = "Gelieve de herstellingskost correct in te vullen."
                Me.divBeschWijzigenFeedback.Visible = True
                Return False
            End Try
        End If

        Return True

    End Function

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
        Else
            Me.txtHerstellingskost.Text = String.Empty
        End If

        If b.beschadigingAangerichtDoorKlant.ToString = "7a73f865-ec29-4efd-bf09-70a9f9493d21" Then
            Me.chkNietDoorKlantAangericht.Checked = True
            Me.ddlKlanten.Visible = False
        Else
            Me.ddlKlanten.Visible = True

            If ddlKlanten.Items.Count = 0 Then
                Me.lblWijzigBeschGeenKlantenTeKiezen.Visible = True
                Me.ddlKlanten.Visible = False
            Else
                Me.lblWijzigBeschGeenKlantenTeKiezen.Visible = False
                Me.ddlKlanten.Visible = True
            End If

            For i As Integer = 0 To Me.ddlKlanten.Items.Count - 1
                If (Me.ddlKlanten.Items(i).Value = b.beschadigingAangerichtDoorKlant.ToString()) Then
                    Me.ddlKlanten.Items(i).Selected = True
                Else
                    Me.ddlKlanten.Items(i).Selected = False
                End If
            Next i


        End If

    End Sub

    Protected Sub chkNietDoorKlantAangericht_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkNietDoorKlantAangericht.CheckedChanged
        Me.ddlKlanten.Visible = Not Me.chkNietDoorKlantAangericht.Checked

        If ddlKlanten.Items.Count = 0 Then
            Me.lblWijzigBeschGeenKlantenTeKiezen.Visible = True
            Me.ddlKlanten.Visible = False
        Else
            Me.lblWijzigBeschGeenKlantenTeKiezen.Visible = False
            Me.ddlKlanten.Visible = True
        End If

        If Me.chkNietDoorKlantAangericht.Checked Then
            Me.lblWijzigBeschGeenKlantenTeKiezen.Visible = False
            Me.ddlKlanten.Visible = False
        End If

    End Sub

    Protected Sub chkIsHersteld_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkIsHersteld.CheckedChanged

        Me.lblHerstellingskost.Visible = Me.chkIsHersteld.Checked()
        Me.txtHerstellingskost.Visible = Me.chkIsHersteld.Checked()

        If Not Me.chkIsHersteld.Checked Then
            Me.txtHerstellingskost.Text = String.Empty
        End If

    End Sub

    Protected Sub btnBeschadigingWijzigen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBeschadigingWijzigen.Click

        If Not WijzigFormulierBeschadigingIsGeldig() Then Return

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

        If Not beschadigingbll.UpdateBeschadiging(b) Then
            Me.imgBeschWijzigenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschWijzigenFeedback.Text = "Er is een fout gebeurd tijdens het opslaan van de wijzigen. Gelieve het opnieuw te proberen."
            Me.divBeschWijzigenFeedback.Visible = True
            Return
        End If

        VulBeschadigingsOverzicht()

        Me.imgBeschWijzigenFeedback.ImageUrl = "~\App_Presentation\Images\tick.gif"
        Me.lblBeschWijzigenFeedback.Text = "Beschadiging gewijzigd."
        Me.divBeschWijzigenFeedback.Visible = True
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

        If (fotobll.InsertBeschadigingAutoFoto(r) = False) Then
            'Fout tijdens toevoegen foto
            Me.imgBeschToevoegenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschToevoegenFeedback.Text = "Er is een fout gebeurd tijdens het opslaan van de foto. Mogelijk is de foto niet zichtbaar."
            Me.divBeschToevoegenFeedback.Visible = True
        End If

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

#Region "Methods voor onderhoudsactie toe te voegen"

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

    Private Sub ClearOnderhoudsActieToevoegen()
        Me.divBeschToevoegenFeedback.Visible = False
        Me.txtAndereOnderhoudsActie.Text = String.Empty
        Me.txtKostOnderhoudsActie.Text = String.Empty
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


#End Region

#Region "Methods voor onderhoudsactie te wijzigen"

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

    Private Sub PasKostAanActieWijzigen()
        Dim actiebll As New ActieBLL
        Me.txtOnderhoudskostWijzigen.Text = actiebll.GetActieByActieID(Me.ddlPrefabOnderhoudsActies.SelectedValue).actieKost
        actiebll = Nothing
    End Sub

    Protected Sub ddlPrefabOnderhoudsActiesWijzigen_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPrefabOnderhoudsActiesWijzigen.SelectedIndexChanged
        PasKostAanActieWijzigen()
    End Sub

    Protected Sub ddlOnderhoudsActieWijzigen_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlOnderhoudsActieWijzigen.SelectedIndexChanged
        ClearVeldenActieWijzigen()
        VulActieWijzigen()
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

#End Region

#Region "Methods voor onderhoudsactie te verwijderen"

    Protected Sub btnOnderhoudsActieVerwijderen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOnderhoudsActieVerwijderen.Click
        Dim controleactiebll As New ControleActieBLL
        Dim r As Onderhoud.tblControleActieRow = controleactiebll.GetControleActieByControleIDAndActieID(ViewState("controleID"), Me.ddlOnderhoudsActiesVerwijderen.SelectedValue)

        If Not controleactiebll.DeleteControleActie(r.ControleActieID) Then
            Me.imgBeschVerwijderenFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblBeschVerwijderenFeedback.Text = "Er is een fout gebeurd bij het verwijderen van de beschadgiging. Gelieve het opnieuw te proberen."
            Me.divBeschVerwijderenFeedback.Visible = True
            Return
        End If

        Me.imgBeschVerwijderenFeedback.ImageUrl = "~\App_Presentation\Images\tick.gif"
        Me.lblBeschVerwijderenFeedback.Text = "Beschadiging verwijderd."
        Me.divBeschVerwijderenFeedback.Visible = True

        VulOnderhoudsActieOverzicht()

        ClearVeldenActieWijzigen()
        ClearOnderhoudsActieToevoegen()
    End Sub

#End Region

#Region "Parkinglayout generatiecode"

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

#Region "Methods voor nazicht"

    Private Function OnderhoudFormulierIsGeldig() As Boolean

        Me.divOnderhoudOpslaanFeedback.Visible = False

        Try
            Dim tekst As String = Me.lblNazichtBerekendeBrandstofkost.Text.Replace("€", String.Empty).Trim
            Dim kost As Double = Double.Parse(tekst)
        Catch
            Me.divOnderhoudOpslaanFeedback.Visible = True
            Me.imgOnderhoudOpslaanFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblOnderhoudOpslaanFeedback.Text = "Gelieve een geldige brandstofkost te bepalen."
            Return False
        End Try

        Try
            Dim km As Double = Double.Parse(Me.txtNazichtHuidigeKilometerstand.Text)

            If Me.lblNazichtVorigKilometerstand.Text > km Then
                Me.divOnderhoudOpslaanFeedback.Visible = True
                Me.imgOnderhoudOpslaanFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
                Me.lblOnderhoudOpslaanFeedback.Text = "De huidige kilometerstand kan niet kleiner zijn dan de vorige kilometerstand."
                Return False
            End If
        Catch
            Me.divOnderhoudOpslaanFeedback.Visible = True
            Me.imgOnderhoudOpslaanFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblOnderhoudOpslaanFeedback.Text = "Gelieve een geldige kilometerstand in te vullen."
            Return False
        End Try

        Return True

    End Function

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

            If aantalLiters < 0 Then
                Me.lblNazichtBerekendeBrandstofkost.Text = String.Empty
                Return
            End If

            If aantalLiters > ViewState("autoTankInhoud") Then
                Me.lblNazichtBerekendeBrandstofkost.Text = String.Empty
                Return
            End If

            If ViewState("autoTankInhoud") - aantalLiters < 0 Then
                Me.lblNazichtBerekendeBrandstofkost.Text = "0 €"
                Return
            End If

            Dim totaalkost As Double = (ViewState("autoTankInhoud") - aantalLiters) * ViewState("brandstofKostPerLiter")
            Me.lblNazichtBerekendeBrandstofkost.Text = String.Concat(totaalkost, " €")
        Catch
            Me.lblNazichtBerekendeBrandstofkost.Text = String.Empty
            Return
        End Try
    End Sub

#End Region

    Protected Sub btnOnderhoudOpslaan_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOnderhoudOpslaan.Click

        'Indien dit een nazicht is, die velden nakijken
        If Me.chkIsNazicht.Checked Then
            If Not OnderhoudFormulierIsGeldig() Then Return
        End If

        'Controle wegschrijven

        Dim controlebll As New ControleBLL
        Dim c As Onderhoud.tblControleRow = controlebll.GetControleByControleID(ViewState("controleID"))

        c.controleIsNazicht = Me.chkIsNazicht.Checked

        'Medewerker die de controle heeft uitgevoerd
        c.medewerkerID = New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())

        'Deze controle werd uitgevoerd.
        c.controleIsUitgevoerd = True

        If Me.chkIsNazicht.Checked Then

            'Brandstofkost van de controle wegschrijven
            c.controleBrandstofkost = Double.Parse(Me.lblNazichtBerekendeBrandstofkost.Text.Replace("€", String.Empty).Trim)

            'Kilometerstand van de controle wegschrijven
            c.controleKilometerstand = Double.Parse(Me.txtNazichtHuidigeKilometerstand.Text)

            'Auto updaten.

            Dim autobll As New AutoBLL
            Dim a As Autos.tblAutoRow = autobll.GetAutoByAutoID(ViewState("autoID")).Rows(0)

            'Kilometerstand updaten
            a.autoHuidigeKilometerstand = Me.txtNazichtHuidigeKilometerstand.Text

            'Kilometer tot olieverversing updaten indien nodig
            If Me.txtNazichtHuidigeKilometerstand.Text > ViewState("autoKMTotOlieVerversing") Then
                For i As Integer = 0 To Me.ddlPrefabOnderhoudsActiesWijzigen.Items.Count - 1

                    If Me.ddlPrefabOnderhoudsActiesWijzigen.Items(i).Text.Contains("Olie vervangen") Then
                        a.autoKMTotOlieVerversing = a.autoHuidigeKilometerstand + 10000
                        Me.imgOlieNietVerversd.Visible = False
                        Me.lblOlieNietVerversd.Visible = False
                    Else
                        Me.imgOlieNietVerversd.Visible = True
                        Me.lblOlieNietVerversd.Visible = True
                    End If
                Next
            Else
                Me.imgOlieNietVerversd.Visible = False
                Me.lblOlieNietVerversd.Visible = False
            End If

            'Parkeerplaats updaten indien nodig
            If Not Me.txtAutoParkeerplaats.Text = String.Empty Then
                a.parkeerPlaatsID = Me.txtAutoParkeerplaats.Text
            End If

            'Auto updaten
            If Not autobll.UpdateAuto(a) Then
                Me.divOnderhoudOpslaanFeedback.Visible = True
                Me.imgOnderhoudOpslaanFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
                Me.lblOnderhoudOpslaanFeedback.Text = "Er is iets misgelopen tijdens het opslaan van de autogegevens. Gelieve het opnieuw te proberen."
            End If

            autobll = Nothing

        End If

        'Alles is in orde, wegschrijven
        If controlebll.UpdateControle(c) Then
            Me.divOnderhoudOpslaanFeedback.Visible = True
            Me.imgOnderhoudOpslaanFeedback.ImageUrl = "~\App_Presentation\Images\tick.gif"
            Me.lblOnderhoudOpslaanFeedback.Text = "Onderhoud opgeslagen."
            Me.btnOnderhoudOpslaan.Visible = False

        Else
            Me.divOnderhoudOpslaanFeedback.Visible = True
            Me.imgOnderhoudOpslaanFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.lblOnderhoudOpslaanFeedback.Text = "Er is iets misgelopen tijdens het opslaan van het onderhoud. Gelieve het opnieuw te proberen."
        End If

        controlebll = Nothing

    End Sub

End Class
