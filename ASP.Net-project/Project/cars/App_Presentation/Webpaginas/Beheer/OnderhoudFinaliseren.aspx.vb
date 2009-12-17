
Partial Class App_Presentation_Webpaginas_Beheer_OnderhoudFinaliseren
    Inherits System.Web.UI.Page

    <Serializable()> _
    Structure Beschadigingen
        Public userID As String
        Public beschadiging As List(Of Integer)
        Public beschadigingskost As List(Of Double)
        Public beschadigingomschrijving As List(Of String)
    End Structure

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.divError.Visible = False
        If Request.QueryString("controleID") IsNot Nothing Then
            Try

                Dim controleID As Integer = Convert.ToInt32(Request.QueryString("controleID"))

                Dim controlebll As New ControleBLL
                Dim klantbll As New KlantBLL

                'Onderhoud ophalen
                Dim c As Onderhoud.tblControleRow = controlebll.GetControleByControleID(controleID)

                'Even kijken of deze pagina getoond mag worden
                If c.controleIsUitgevoerd = False Then
                    Me.updOnderhoudFinaliseren.Visible = False
                    Me.divError.Visible = True
                    Me.lblFout.Text = "Dit onderhoud is nog niet uitgevoerd."
                    Return
                End If

                Dim onderhoudbll As New OnderhoudBLL
                Dim o As Onderhoud.tblNodigOnderhoudRow = onderhoudbll.GetNodigOnderhoudByControleID(controleID)

                If o Is Nothing Then
                    Me.updOnderhoudFinaliseren.Visible = False
                    Me.divError.Visible = True
                    Me.lblFout.Text = "Dit onderhoud werd reeds gefinaliseerd."
                    Return
                End If

                Dim r As Reservaties.tblReservatieRow
                If c.controleIsNazicht Then
                    'Reservatie ophalen. Deze gaan we gebruiken om te bepalen
                    ' welke klant de nazichtkosten moet betalen
                    Dim reservatiebll As New ReservatieBLL
                    r = reservatiebll.GetReservatieByReservatieID(c.reservatieID)
                    ViewState("reservatieID") = c.reservatieID
                    reservatiebll = Nothing
                End If

                'Nu, omdat in 1 onderhoud meerdere beschadigingen kunnen worden opgemerkt,
                'en niet noodzakelijk alle beschadigingen aan één klant worden toegekend,
                'moeten we een overzichtje geven van alle beschadigingen per klant.

                'Beschadigingen opgemerkt tijdens dit onderhoud ophalen
                Dim beschadigingbll As New BeschadigingBLL
                Dim beschadigingen As Onderhoud.tblAutoBeschadigingDataTable = beschadigingbll.GetAllBeschadigingByAutoID(c.autoID)

                'Deze ViewState-variabele gaat alle beschadigingen bijhouden per klant
                ViewState("beschadigingsLijst") = New List(Of Beschadigingen)

                'KlantenIDs ophalen
                Dim klantenIDs() As String = HaalKlantenOpVanBeschadigingen(beschadigingen)

                'Voor elke ID een overzichtje maken
                For Each ID As String In klantenIDs

                    'Even checken of we geen NULL ID hebben
                    If ID Is Nothing Then Continue For

                    'En checken of dit niet de DUMMY-MEDEWERKER is, want die
                    'beschadigingen zijn voor het bedrijf
                    If ID = "7a73f865-ec29-4efd-bf09-70a9f9493d21" Then Continue For

                    'Profiel ophalen van deze klant
                    Dim p As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(New Guid(ID)).Rows(0)

                    'Dit is onze hoofddiv, die we in plcKostenVoorKlanten gaan steken
                    Dim div As New HtmlGenericControl("div")

                    'Alle beschadigingen van deze klant verzamelen
                    Dim filterview As Data.DataView = beschadigingen.DefaultView
                    filterview.RowFilter = String.Concat("beschadigingAangerichtDoorKlant = '", ID, "'")
                    Dim gefilterdebeschadigingen As Data.DataTable = filterview.ToTable

                    If gefilterdebeschadigingen.Rows.Count > 0 Then

                        'Klantheader toevoegen
                        Dim lbl As New Label
                        lbl.Text = String.Concat("<h2>Kosten voor klant ", p.userNaam, " ", p.userVoornaam, "</h2>")
                        div.Controls.Add(lbl)

                        'Beschadigingsheader
                        Dim header As New HtmlGenericControl("h3")
                        header.InnerText = "Beschadigingen"
                        div.Controls.Add(header)

                        'Beschadigingstabel, headers
                        Dim tabel As HtmlGenericControl = MaakheaderVoorBeschadigingsTabel()

                        'Voor elke beschadiging een rijtje toevoegen aan onze
                        'programmatorisch aangemaakte tabel
                        For i As Integer = 0 To gefilterdebeschadigingen.Rows.Count - 1
                            tabel.Controls.Add(MaakRijVoorBeschadiging(gefilterdebeschadigingen.Rows(i), ID))
                        Next i

                        'Vervolledigde beschadigingstabel toevoegen
                        div.Controls.Add(tabel)

                    End If

                    If c.controleIsNazicht And r IsNot Nothing Then

                        If (ID = r.userID.ToString) Then
                            'Deze klant moet de nazichtkosten betalen.
                            div = MaakNazichtkostenTabel(div, c)

                        End If

                    End If

                    'Heel het overzicht van deze klant toevoegen aan placeholder
                    Me.divKlantKosten.Controls.add(div)

                Next ID

                'Onderhoudsdetails
                OnderhoudsDetailsToevoegen(c)


            Catch
                Me.updOnderhoudFinaliseren.Visible = False
                Me.divError.Visible = True
                Me.lblFout.Text = "Een belangrijke parameter (controleID) werd incorrect meegegeven."
                Return
            End Try
        Else
            Me.updOnderhoudFinaliseren.Visible = False
            Me.divError.Visible = True
            Me.lblFout.Text = "Een belangrijke parameter (controleID) werd incorrect meegegeven."
        End If

    End Sub

    Private Function HaalKlantenOpVanBeschadigingen(ByRef beschadigingen As Onderhoud.tblAutoBeschadigingDataTable) As String()

        'Eerst alle klanten die een beschadigingen zijn toegekend verzamelen.
        Dim klantenIDs(beschadigingen.Count - 1) As String
        Dim dubbels(beschadigingen.Count - 1) As String
        Dim i As Integer = 0

        For Each beschadiging As Onderhoud.tblAutoBeschadigingRow In beschadigingen
            Dim klantIsDubbel As Boolean = False

            For Each klant In dubbels
                If beschadiging.beschadigingAangerichtDoorKlant.ToString() = klant Then
                    klantIsDubbel = True
                    Exit For
                End If
            Next

            If Not klantIsDubbel Then
                klantenIDs(i) = beschadiging.beschadigingAangerichtDoorKlant.ToString()
                i = i + 1
            End If

        Next beschadiging

        ReDim Preserve klantenIDs(i)

        Return klantenIDs

    End Function

    Private Function MaakheaderVoorBeschadigingsTabel() As HtmlGenericControl

        Dim tabel As New HtmlGenericControl("table")
        Dim rij As New HtmlGenericControl("tr")
        Dim th1 As New HtmlGenericControl("th")
        th1.InnerText = "Omschrijving"
        Dim th2 As New HtmlGenericControl("th")
        th2.InnerText = "Is hersteld"
        Dim th3 As New HtmlGenericControl("th")
        th3.InnerText = "Kost"
        rij.Controls.Add(th1)
        rij.Controls.Add(th2)
        rij.Controls.Add(th3)
        tabel.Controls.Add(rij)

        Return tabel
    End Function

    Private Function MaakNazichtkostenTabel(ByRef div As HtmlGenericControl, ByRef c As Onderhoud.tblControleRow) As HtmlGenericControl

        Dim header As New HtmlGenericControl("h3")
        header.InnerText = "Nazichtkosten"
        div.Controls.Add(header)

        Dim tabel As New HtmlGenericControl("table")
        Dim rij As New HtmlGenericControl("tr")
        Dim tekst As New HtmlGenericControl("td")
        Dim waarde As New HtmlGenericControl("td")

        tekst.InnerText = "Brandstofkost:"
        waarde.InnerText = String.Concat(c.controleBrandstofkost, " €")

        rij.Controls.Add(tekst)
        rij.Controls.Add(waarde)

        tabel.Controls.Add(rij)

        div.Controls.Add(tabel)

        Return div
    End Function

    Private Function MaakRijVoorBeschadiging(ByRef rij As Data.DataRow, ByRef ID As String) As HtmlGenericControl

        Dim tr As New HtmlGenericControl("tr")
        Dim omschrijving As New HtmlGenericControl("td")
        Dim isHersteld As New HtmlGenericControl("td")
        Dim kost As New HtmlGenericControl("td")

        Dim beschadigingsLijst As List(Of Beschadigingen) = ViewState("beschadigingsLijst")

        Dim IDgevonden As Boolean = False
        For Each lijst In beschadigingsLijst
            If lijst.userID = ID Then
                lijst.beschadiging.Add(rij.Item("autoBeschadigingID"))
                lijst.beschadigingskost.Add(rij.Item("beschadigingKost"))
                lijst.beschadigingomschrijving.Add(rij.Item("beschadigingOmschrijving"))
                IDgevonden = True
                Exit For
            End If
        Next

        If Not IDgevonden Then
            Dim lijst As Beschadigingen
            lijst.userID = ID

            lijst.beschadiging = New List(Of Integer)
            lijst.beschadigingomschrijving = New List(Of String)
            lijst.beschadigingskost = New List(Of Double)

            lijst.beschadiging.Add(rij.Item("autoBeschadigingID"))
            lijst.beschadigingskost.Add(rij.Item("beschadigingKost"))
            lijst.beschadigingomschrijving.Add(rij.Item("beschadigingOmschrijving"))

            beschadigingsLijst.Add(lijst)
        End If

        ViewState("beschadigingsLijst") = beschadigingsLijst

        omschrijving.InnerText = rij.Item("beschadigingOmschrijving")

        If rij.Item("beschadigingIsHersteld") Then
            isHersteld.InnerText = "Ja"
            kost.InnerText = rij.Item("beschadigingKost")
        Else
            isHersteld.InnerText = "Nee"
            kost.InnerText = "Niet hersteld"
        End If

        tr.Controls.Add(omschrijving)
        tr.Controls.Add(isHersteld)
        tr.Controls.Add(kost)

        Return tr
    End Function

    Private Sub OnderhoudsDetailsToevoegen(ByRef c As Onderhoud.tblControleRow)

        Me.lblBeginDatum.Text = Format(c.controleBegindat, "dd/MM/yyyy")
        Me.lblEinddatum.Text = Format(c.controleEinddat, "dd/MM/yyyy")

        Dim klantbll As New KlantBLL
        Dim medewerker As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(c.medewerkerID).Rows(0)
        Me.lblMedewerker.Text = String.Concat(medewerker.userNaam, " ", medewerker.userVoornaam)

        If c.controleIsNazicht Then
            Me.lblWasNazicht.Text = "Ja"
        Else
            Me.lblWasNazicht.Text = "Nee"
        End If

    End Sub

    Protected Sub btnOnderhoudFinaliseren_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOnderhoudFinaliseren.Click

        Dim controleID As Integer = Convert.ToInt32(Request.QueryString("controleID"))

        Dim controlebll As New ControleBLL
        Dim c As Onderhoud.tblControleRow = controlebll.GetControleByControleID(controleID)

        Dim onderhoudbll As New OnderhoudBLL
        Dim o As Onderhoud.tblNodigOnderhoudRow = onderhoudbll.GetNodigOnderhoudByControleID(controleID)

        If o Is Nothing Then
            Me.updOnderhoudFinaliseren.Visible = False
            Me.divError.Visible = True
            Me.lblFout.Text = "Dit onderhoud werd reeds gefinaliseerd."
            Return
        End If

        'Controle verwijderen uit nodig onderhoud
        onderhoudbll.VerwijderNodigOnderhoud(o.nodigOnderhoudID)

        'Alles wegschrijven naar factuurlijnen

        'reservatieID ophalen
        Dim r As Reservaties.tblReservatieRow
        Dim reservatiebll As New ReservatieBLL
        If ViewState("reservatieID") IsNot Nothing Then
            r = ReservatieBLL.GetReservatieByReservatieID(ViewState("reservatieID"))
        End If

        Dim beschadigingsLijst As List(Of Beschadigingen) = ViewState("beschadigingsLijst")

        Dim factuurbll As New FactuurBLL

        If r IsNot Nothing Then 'nazicht, we schrijven het weg op de reservatiefactuur

            Dim nazichtBetaald As Boolean = False
            For Each lijst In beschadigingsLijst

                If r.userID.ToString = lijst.userID Then
                    'dit is de klant die de nazichtkosten moet betalen.
                    'we gaan ook alle beschadigingen die hij heeft aangebracht 
                    'op de factuur van de reservatie zetten.

                    Dim dt As New Reservaties.tblFactuurlijnDataTable
                    Dim f As Reservaties.tblFactuurlijnRow = dt.NewRow

                    If Not nazichtBetaald Then
                        f.factuurlijnCode = 1 'Brandstofkost
                        f.factuurlijnKost = c.controleBrandstofkost
                        f.factuurlijnTekst = "Brandstofkost"
                        f.reservatieID = r.reservatieID

                        'Brandstofkost
                        factuurbll.InsertFactuurLijn(f)

                        nazichtBetaald = True
                    End If


                    If lijst.beschadiging.Count > 0 Then
                        r.factuurIsInWacht = 1
                        reservatiebll.UpdateReservatie(r)
                    End If

                    Exit For
                End If

            Next

        End If

        Me.btnOnderhoudFinaliseren.Visible = False
        Me.divFeedback.Visible = True
        Me.imgFeedback.ImageUrl = "~\App_Presentation\Images\tick.gif"
        Me.lblFeedback.Text = "Onderhoud gefinaliseerd."

        'Alle andere beschadigingen worden gewoon bijgehouden in tblAutoBeschadiging

    End Sub
End Class
