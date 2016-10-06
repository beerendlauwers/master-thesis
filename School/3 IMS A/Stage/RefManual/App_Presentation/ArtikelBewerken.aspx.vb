Imports Manual
Imports System.Diagnostics
Imports System.IO
Imports System.Drawing
Imports System.Web.HttpUtility

Partial Class App_Presentation_ArtikelBewerken
    Inherits System.Web.UI.Page
    Private artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties
    Private taaldal As TaalDAL = DatabaseLink.GetInstance.GetTaalFuncties
 

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            'Paginatitel
            Page.Title = "Artikel Bewerken"

            Util.CheckOfBeheerder(Page.Request.Url.AbsolutePath)

            'Als de pagina de eerste keer laadt
            If Not IsPostBack Then

                'Dropdowns laden
                LaadDropdowns()

                'Templates laden
                LaadTemplates()

                'Artikelcontrols verstoppen
                ArtikelFunctiesZichtbaar(False)

                'Checken voor een meegegeven ID
                If Page.Request.QueryString("id") IsNot Nothing Then
                    If IsNumeric(Page.Request.QueryString("id")) = True Then

                        Dim id As Integer = Page.Request.QueryString("id")
                        LaadArtikel(id)
                    End If
                    'hier gaan we kijken of de beheerder terugkomt van de beheerpagina waar hij net een categorie toevoegde omdat er nog geen
                    'was voor zijn gewenste versie, bedrijf en taal.
                    'nadeel is hier opnieuw dat wanneer de beheerder al tekst heeft ingevoerd in de editor die verloren gaat bij het gaan naar de beheerpagina.
                    'Maar de beheerder wordt van dit gevaar op de hoogte gebracht zodat hij zijn content eerst kan opslagen.
                ElseIf Page.Request.QueryString("taal") IsNot Nothing And Page.Request.QueryString("versie") IsNot Nothing And Page.Request.QueryString("bedrijf") IsNot Nothing And Page.Request.QueryString("module") IsNot Nothing And Page.Request.QueryString("titel") IsNot Nothing And Page.Request.QueryString("Artikeltag") IsNot Nothing And Page.Request.QueryString("ArtikelID") IsNot Nothing Then
                    ViewState("artikelID") = Page.Request.QueryString("ArtikelID")
                    Dim dr As tblArtikelRow = artikeldal.GetArtikelByID(ViewState("artikelID"))
                    EditorBewerken.Value = dr("Tekst")
                    txtTitel.Text = Page.Request.QueryString("titel")
                    txtTag.Text = Page.Request.QueryString("Artikeltag")
                    ddlBedrijf.SelectedValue = Page.Request.QueryString("bedrijf")
                    ddlVersie.SelectedValue = Page.Request.QueryString("versie")
                    ddlModule.SelectedValue = Page.Request.QueryString("module")
                    ddlTaal.SelectedValue = Page.Request.QueryString("taal")
                    LaadCategorien()
                    ddlCategorie.SelectedValue = Page.Request.QueryString("CategorieID")
                    ArtikelFunctiesZichtbaar(True)

                ElseIf Page.Request.QueryString("tag") IsNot Nothing Then
                    Dim tag As String = Page.Request.QueryString("tag")
                    LaadArtikel(tag)
                End If

            End If

            LaadZoekTooltips()
            LaadJavascript()
            gettag()
        Catch ex As Exception
            Util.OnverwachteFout(Me, ex.Message)
        End Try
    End Sub

    Protected Sub btnZoek_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoek.Click
        Try
            ZoekresultatenWeergeven()
        Catch ex As Exception
            Util.OnverwachteFout(btnZoek, ex.Message)
        End Try
    End Sub

    Private Sub ZoekresultatenWeergeven()

        'Zoekwaardes ophalen
        Dim zoekTag As String = Me.txtZoekTag.Text.Trim
        Dim zoekTitel As String = Me.txtZoekTitel.Text.Trim

        'Dropdownwaardes ophalen
        Dim versies As String = Util.DropdownUitlezen(ddlVersieVerfijnen)
        Dim bedrijven As String = Util.DropdownUitlezen(ddlBedrijfVerfijnen)
        Dim talen As String = Util.DropdownUitlezen(ddlTaalVerfijnen)
        Dim isFInaal As String = Util.DropdownUitlezen(ddlIsFInaalVerfijnen)

        Dim dt As New Data.DataTable

        If zoekTitel.Length > 0 Then

            Dim zoekTekst As String = String.Concat("""*", zoekTitel, "*""")
            zoekTitel = String.Concat("%", zoekTitel, "%")
            Dim dttitel As Data.DataTable = artikeldal.GetArtikelGegevensByTitel(zoekTitel, isFInaal, versies, bedrijven, talen)
            Dim dttekst As Data.DataTable = artikeldal.GetArtikelGegevensByTekst(zoekTekst, isFInaal, versies, bedrijven, talen)

            If dttitel.Rows.Count > 0 Then
                dt = dttitel.Clone
            ElseIf dttekst.Rows.Count > 0 Then
                dt = dttekst.Clone
            End If
            Dim bool As Boolean = True
            For i As Integer = 0 To dttitel.Rows.Count - 1
                Dim dr As Data.DataRow = dt.NewRow
                dr = dttitel.Rows(i)
                For x As Integer = 0 To dt.Rows.Count - 1
                    If dt.Rows(x)("ArtikelID") = dr("ArtikelID") Then
                        bool = False
                    End If
                Next
                If bool = True Then
                    dt.ImportRow(dr)
                End If
                bool = True
            Next
            If dttekst.Rows.Count > 0 Then
                For i As Integer = 0 To dttekst.Rows.Count - 1
                    Dim dr As Data.DataRow = dt.NewRow
                    dr = dttekst.Rows(i)
                    For q As Integer = 0 To dt.Rows.Count - 1
                        If dt.Rows(q)("ArtikelID") = dr("ArtikelID") Then
                            bool = False
                        End If
                    Next
                    If bool = True Then
                        dt.ImportRow(dr)
                    End If
                    bool = True
                Next
            End If

        ElseIf zoekTag.Length > 0 Then
            zoekTag = String.Concat("%", zoekTag, "%")
            dt = artikeldal.GetArtikelGegevensByTag(zoekTag, isFInaal, versies, bedrijven, talen)
        End If

        grdvLijst.DataSource = dt
        grdvLijst.DataBind()
        grdvLijst.Visible = True

        Me.divResultatenTonen.Visible = True
        JavaScript.VoegJavascriptToeAanEndRequest(Me, "Effect.toggle('divZoekResultaten', 'slide');")

        updBewerken.Update()
        updZoeken.Update()

        ArtikelFunctiesZichtbaar(False)
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        Try
            If Me.ddlCategorie.Items.Count = 0 Then
                Util.SetError("U dient een categorie op te geven.", lblresultaat, imgResultaat)
                Me.divFeedback.Style.Item("display") = "inline"
                Return
            End If
            Dim artikelIDtest As Integer = ViewState("artikelID")
            Dim origineelArtikel As tblArtikelRow = artikeldal.GetArtikelByID(ViewState("artikelID"))
            If origineelArtikel Is Nothing Then
                Util.OnverwachteFout(btnUpdate, "Het opgevraagde artikel kon niet gevonden worden in de database.")
                Util.SetError("Update mislukt: Kon niet met de database verbinden.", lblresultaat, imgResultaat)
                Me.divFeedback.Style.Item("display") = "inline"
                Return
            End If

            Dim artikel As New Artikel

            artikel.ID = ViewState("artikelID")
            artikel.Bedrijf = ddlBedrijf.SelectedValue
            artikel.Categorie = ddlCategorie.SelectedValue
            artikel.Taal = ddlTaal.SelectedValue
            artikel.Versie = ddlVersie.SelectedValue
            artikel.Tag = lblTagvoorbeeld.InnerHtml
            artikel.Tekst = HttpUtility.HtmlDecode(EditorBewerken.Value)
            artikel.Titel = txtTitel.Text

            If ckbFinal.Checked = True Then
                artikel.IsFinal = 1
            Else
                artikel.IsFinal = 0
            End If

            'Checken of een ander artikel reeds deze titel heeft
            If artikeldal.checkArtikelByTitelEnID(artikel.Titel, artikel.Bedrijf, artikel.Versie, artikel.Taal, artikel.ID).Count > 0 Then
                Util.SetError("Update mislukt: Er bestaat reeds een artikel met deze titel in deze structuur.", lblresultaat, imgResultaat)
                Me.divFeedback.Style.Item("display") = "inline"
                Return
            End If

            'Checken of een ander artikel niet dezelfde tag heeft
            If artikeldal.checkArtikelByTagByID(artikel.Tag, artikel.Bedrijf, artikel.Versie, artikel.Taal, artikel.ID).Count > 0 Then
                Util.SetError("Update mislukt: Er bestaat reeds een artikel met deze tag.", lblresultaat, imgResultaat)
                Me.divFeedback.Style.Item("display") = "inline"
                Return
            End If

            If rdbAlleTalen.Checked Then
                Dim taaldal As New TaalDAL
                Dim oudetag As String = Session("oudetag")
                Dim i As Integer
                i = taaldal.updateTagTalen(oudetag, artikel.Tag, -1, -1)
                If i = 0 Then
                    lblresultaat.Text = "De tags zijn misschien niet correct aangepast."
                End If
            ElseIf rdbTalenperVersieBedrijf.Checked Then
                Dim taaldal As New TaalDAL
                Dim oudetag As String = Session("oudetag")
                Dim i As Integer
                i = taaldal.updateTagTalen(oudetag, artikel.Tag, artikel.Bedrijf, artikel.Versie)
                If i = 0 Then
                    lblresultaat.Text = "De tags zijn misschien niet correct aangepast."
                End If
            End If

            If artikeldal.updateArtikel(artikel) = True Then

                'Boomstructuur in het geheugen updaten.

                'We halen de tree op waar dit artikel in werd opgeslagen
                Dim oudetree As Tree = Tree.GetTree(origineelArtikel.FK_Taal, origineelArtikel.FK_Versie, origineelArtikel.FK_Bedrijf)

                If oudetree Is Nothing Then
                    Dim fout As String = String.Concat("De opgevraagde tree (zie parameters) bestaat niet in het geheugen.")
                    Dim err As New ErrorLogger(fout, "ARTIKELBEWERKEN_0001")
                    err.Args.Add("Taal = " & origineelArtikel.FK_Taal.ToString)
                    err.Args.Add("Versie = " & origineelArtikel.FK_Versie.ToString)
                    err.Args.Add("Bedrijf = " & origineelArtikel.FK_Bedrijf.ToString)
                    ErrorLogger.WriteError(err)
                End If

                'We halen de nieuwe tree op
                Dim nieuwetree As Tree = Tree.GetTree(artikel.Taal, artikel.Versie, artikel.Bedrijf)

                If nieuwetree Is Nothing Then
                    Dim fout As String = String.Concat("De opgevraagde tree (zie parameters) bestaat niet in het geheugen.")
                    Dim err As New ErrorLogger(fout, "ARTIKELBEWERKEN_0002")
                    err.Args.Add("Taal = " & artikel.Taal.ToString)
                    err.Args.Add("Versie = " & artikel.Versie.ToString)
                    err.Args.Add("Bedrijf = " & artikel.Bedrijf.ToString)
                    ErrorLogger.WriteError(err)
                End If

                'Nakijken of het artikel verplaatst is geweest
                If Not oudetree.Naam = nieuwetree.Naam Then 'artikel is verplaatst

                    'Artikel uit oude tree verwijderen
                    Dim oudenode As Node = oudetree.DoorzoekTreeVoorNode(origineelArtikel.ArtikelID, Global.ContentType.Artikel)

                    If oudenode Is Nothing Then
                        Dim fout As String = String.Concat("De opgevraagde node (zie parameters) bestaat niet in het geheugen.")
                        Dim err As New ErrorLogger(fout, "ARTIKELBEWERKEN_0003")
                        err.Args.Add("ID = " & origineelArtikel.ArtikelID.ToString)
                        err.Args.Add("Type = " & Global.ContentType.Artikel.ToString)
						err.Args.Add("Tree = " & oudetree.Naam)
                        ErrorLogger.WriteError(err)
                    End If

                    oudetree.VindParentVanNode(oudenode).RemoveChild(oudenode)

                    'Artikel in nieuwe tree toevegen
                    Dim nieuwenode As New Node(artikel.ID, Global.ContentType.Artikel, artikel.Titel, 0)
                    Dim parent As Node = nieuwetree.DoorzoekTreeVoorNode(artikel.Categorie, Global.ContentType.Categorie)
                    parent.AddChild(nieuwenode)
                Else 'het is niet verplaatst

                    'We zoeken het artikel op en updaten het.
                    Dim tree As Tree = tree.GetTree(artikel.Taal, artikel.Versie, artikel.Bedrijf)

                    If tree Is Nothing Then
                        Dim fout As String = String.Concat("De opgevraagde tree (zie parameters) bestaat niet in het geheugen.")
                        Dim err As New ErrorLogger(fout, "ARTIKELBEWERKEN_0004")
                        err.Args.Add("Taal = " & artikel.Taal.ToString)
                        err.Args.Add("Versie = " & artikel.Versie.ToString)
                        err.Args.Add("Bedrijf = " & artikel.Bedrijf.ToString)
                        ErrorLogger.WriteError(err)

                        Util.SetWarn("Update geslaagd met waarschuwing: Kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met wijzigingen te maken.", lblresultaat, imgResultaat)
                        ArtikelFunctiesZichtbaar(False)
                        Me.divFeedback.Visible = True
                        Return
                    End If

                    Dim node As Node = tree.DoorzoekTreeVoorNode(artikel.ID, Global.ContentType.Artikel)

                    If node Is Nothing Then
                        Util.SetWarn("Update geslaagd met waarschuwing: Kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met wijzigingen te maken.", lblresultaat, imgResultaat)
                        ArtikelFunctiesZichtbaar(False)
                        Me.divFeedback.Visible = True

                        Dim fout As String = String.Concat("De opgevraagde node (zie parameters) bestaat niet in het geheugen.")
                        Dim err As New ErrorLogger(fout, "ARTIKELBEWERKEN_0005")
                        err.Args.Add("ID = " & artikel.ID.ToString)
                        err.Args.Add("Type = " & Global.ContentType.Artikel.ToString)
						err.Args.Add("Tree = " & tree.Naam)
                        ErrorLogger.WriteError(err)

                        Return
                    Else
                        node.Titel = artikel.Titel
                    End If
                End If

                Util.SetOK("Update geslaagd.", lblresultaat, imgResultaat)
                Me.divFeedback.Style.Item("display") = "inline"
            Else
                Util.SetError("Update mislukt: Kon niet met de database verbinden.", lblresultaat, imgResultaat)
                Me.divFeedback.Style.Item("display") = "inline"
            End If
            ArtikelFunctiesZichtbaar(False)
            ZoekresultatenWeergeven()
            Me.divFeedback.Style.Item("display") = "inline"
            Me.divResultatenTonen.Style.Item("display") = "inline"

        Catch ex As Exception
            Util.OnverwachteFout(btnUpdate, ex.Message)
        End Try
    End Sub

#Region "Gridview Event Handlers"

    Protected Sub grdvLijst_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdvLijst.RowCommand
        Try
            If e.CommandName = "Select" Then

                Dim row As GridViewRow = grdvLijst.Rows(e.CommandArgument)
                Dim artikeltag As String = row.Cells(1).Text
                Dim artikelID As Integer = Integer.Parse(row.Cells(7).Text)
                LaadArtikel(artikelID)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(Me, ex.Message)
        End Try
    End Sub

    Protected Sub grdvLijst_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdvLijst.RowDataBound
        Try
            If (e.Row.Cells(0).Text = "Titel" And e.Row.Cells(1).Text = "Tag" And e.Row.Cells(2).Text = "Versie" And e.Row.Cells(3).Text = "Bedrijf" And e.Row.Cells(4).Text = "Taal") Then
                e.Row.Cells(6).Text = "Artikel Wijzigen"
            End If

            If e.Row.Cells.Count > 1 Then
                e.Row.Cells(0).Text = HtmlDecode(e.Row.Cells(0).Text)

                If e.Row.Cells(5).Text = "1" Then
                    e.Row.Cells(5).Text = "Ja"
                ElseIf e.Row.Cells(5).Text = "0" Then
                    e.Row.Cells(5).Text = "Nee"
                End If
            End If
            e.Row.Cells(7).Visible = False
        Catch ex As Exception
            Util.OnverwachteFout(Me, ex.Message)
        End Try
    End Sub

#End Region

#Region "Artikelfuncties"

    Private Sub LaadArtikel(ByVal id As Integer)
        Dim artikel As New Artikel(artikeldal.GetArtikelByID(id))

        If artikel Is Nothing Then
            Util.OnverwachteFout(btnUpdate, String.Concat("Het opgevraagde artikel """, id, """ werd niet in de database gevonden."))
            Return
        End If

        ArtikelInladen(artikel)
    End Sub

    Private Sub LaadArtikel(ByVal tag As String)
        Dim artikel As New Artikel(artikeldal.GetArtikelByTag(tag))

        If artikel Is Nothing Then
            Util.OnverwachteFout(btnUpdate, String.Concat("Het opgevraagde artikel met de tag """, tag, """ werd niet in de database gevonden."))
            Return
        End If

        ArtikelInladen(artikel)
    End Sub

    Private Sub ArtikelInladen(ByVal artikel As Artikel)

        ArtikelFunctiesZichtbaar(True)

        ViewState("artikelID") = artikel.ID
        txtTitel.Text = artikel.Titel

        lblTagvoorbeeld.InnerHtml = artikel.Tag
        Dim tag() As String = Split(artikel.Tag, "_")

        Try
            txtTag.Text = tag(tag.Count - 1)
        Catch ex As Exception
            Dim err As New ErrorLogger(String.Concat("Het laatste gedeelte van de tag """, artikel.Tag, """ van artikel #", artikel.ID, " kon niet geladen worden."),"ARTIKELBEWERKEN_0006")
            ErrorLogger.WriteError(err)
            Return
        End Try

        Try
            ddlModule.SelectedValue = tag(tag.Count - 2)
        Catch ex As Exception
            Dim err As New ErrorLogger(String.Concat("Het modulegedeelte van de tag """, artikel.Tag, """ van artikel #", artikel.ID, " kon niet geladen worden."),"ARTIKELBEWERKEN_0007")
            Try
                err.Args.Add("Module die werd geprobeerd: " & tag(tag.Count - 2))
            Catch
                'We konden het argument niet meegeven, niets doen
            End Try
            ErrorLogger.WriteError(err)
            Return
        End Try

        EditorBewerken.Value = artikel.Tekst

        ddlBedrijf.SelectedValue = artikel.Bedrijf
        ddlTaal.SelectedValue = artikel.Taal
        ddlVersie.SelectedValue = artikel.Versie
        Session("oudetag") = artikel.Tag
        LaadCategorien()

        ddlCategorie.SelectedValue = artikel.Categorie

        If artikel.IsFinal = 1 Then
            ckbFinal.Checked = True
        Else
            ckbFinal.Checked = False
        End If

        LaadBewerkToolTips()

        Me.divFeedback.Style.Item("display") = "none"
        updBewerken.Update()
    End Sub

    Private Sub LaadCategorien()
        gettag()
        Dim t As Tree = Tree.GetTree(Me.ddlTaal.SelectedValue, Me.ddlVersie.SelectedValue, Me.ddlBedrijf.SelectedValue)
        Util.LeesCategorien(ddlCategorie, t)

        If Me.ddlCategorie.Items.Count = 0 Then
            Me.ddlCategorie.Visible = False
            Me.lblGeenCategorie.Visible = True
            Me.btnUpdate.Enabled = False
            Me.hplAddCategorie.NavigateUrl = "~/App_Presentation/Beheer.aspx?index=4&versie=" + ddlVersie.SelectedValue + "&bedrijf=" + ddlBedrijf.SelectedValue + "&taal=" + ddlTaal.SelectedValue + "&module=" + ddlModule.SelectedValue + "&tag=" + txtTag.Text + "&titel=" + txtTitel.Text + "&ArtikelID=" + ViewState("artikelID").ToString + "&Edit=1"
            Me.hplAddCategorie.Visible = True
            updContent.Update()
            Me.warning.Visible = True

        Else
            Me.ddlCategorie.Visible = True
            Me.lblGeenCategorie.Visible = False
            Me.btnUpdate.Enabled = True
            Me.hplAddCategorie.Visible = False
            Me.warning.Visible = False

            updContent.Update()

            Try
                Dim categorieWaarde As Integer = Session("categorieWaarde")
                ddlCategorie.SelectedValue = categorieWaarde
            Catch
                ddlCategorie.SelectedIndex = 0
            End Try
        End If

    End Sub

    Private Sub ArtikelFunctiesZichtbaar(ByVal zichtbaar As Boolean)
        Dim waarde As String = String.Empty
        If zichtbaar Then
            waarde = "inline"
        Else
            waarde = "none"
        End If

        Me.divInvullen.Style.Item("display") = waarde
        Me.divFeedback.Style.Item("display") = "none"
        Me.btnUpdate.Style.Item("display") = waarde
    End Sub

#End Region

#Region "Dropdownlist Event Handlers"

    Protected Sub ddlBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBedrijf.SelectedIndexChanged
        ViewState("bedrijfID") = ddlBedrijf.SelectedValue
        LaadCategorien()
        gettag()
    End Sub

    Protected Sub ddlTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTaal.SelectedIndexChanged
        ViewState("taalID") = ddlTaal.SelectedValue
        LaadCategorien()
        gettag()
    End Sub

    Protected Sub ddlVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlVersie.SelectedIndexChanged
        ViewState("versieID") = ddlVersie.SelectedValue
        LaadCategorien()
        gettag()
    End Sub

#End Region

    Private Sub LaadDropdowns()

        ddlBedrijfVerfijnen.Items.Add(New ListItem("Alles", "-1000"))
        Util.LeesBedrijven(ddlBedrijfVerfijnen, False)

        ddlVersieVerfijnen.Items.Add(New ListItem("Alles", "-1000"))
        Util.LeesVersies(ddlVersieVerfijnen, False)

        ddlTaalVerfijnen.Items.Add(New ListItem("Alles", "-1000"))
        Util.LeesTalen(ddlTaalVerfijnen, False)

        ddlIsFInaalVerfijnen.Items.Clear()
        ddlIsFInaalVerfijnen.Items.Add(New ListItem("Alles", "-1000"))
        ddlIsFInaalVerfijnen.Items.Add(New ListItem("Ja", "1"))
        ddlIsFInaalVerfijnen.Items.Add(New ListItem("Nee", "0"))

        Util.LeesBedrijven(ddlBedrijf)
        Util.LeesVersies(ddlVersie)

        Me.ddlTaal.Items.Clear()
        For Each t As Taal In Taal.GetTalen
            Dim item As New ListItem(t.TaalNaam + " - " + t.TaalTag, t.ID)
            Me.ddlTaal.Items.Add(item)
        Next
        ddlModule.DataBind()
        LaadCategorien()



    End Sub

    Private Sub LaadBewerkToolTips()
        'Nieuwe lijst van tooltips definiëren
        Dim lijst As New List(Of Tooltip)

        lijst.Add(New Tooltip("tipTag"))
        lijst.Add(New Tooltip("tipTitel"))
        lijst.Add(New Tooltip("tipTaal"))
        lijst.Add(New Tooltip("tipBedrijf"))
        lijst.Add(New Tooltip("tipVersie"))
        lijst.Add(New Tooltip("tipCategorie"))
        lijst.Add(New Tooltip("tipFinaal"))
        lijst.Add(New Tooltip("tipSjabloon"))

        Util.TooltipsToevoegen(Me, lijst)
    End Sub

    Private Sub LaadZoekTooltips()

        'Nieuwe lijst van tooltips definiëren
        Dim lijst As New List(Of Tooltip)

        'Alle tooltips voor onze pagina toevoegen
        lijst.Add(New Tooltip("tipZoekTitel"))
        lijst.Add(New Tooltip("tipTaalVerfijnen"))
        lijst.Add(New Tooltip("tipBedrijfVerfijnen"))
        lijst.Add(New Tooltip("tipVersieVerfijnen"))
        lijst.Add(New Tooltip("tipIsFinaalVerfijnen"))
        lijst.Add(New Tooltip("tipZoekTag"))

        Util.TooltipsToevoegen(Me, lijst)

    End Sub

    Private Sub LaadTemplates()
        XML.GetTemplates(lstSjablonen)
    End Sub

    Private Sub LaadJavascript()

        Dim body As HtmlGenericControl = Master.FindControl("MasterBody")

        'De zoekknop op disabled zetten als erop geklikt wordt
        JavaScript.ZetButtonOpDisabledOnClick(btnZoek, "Laden...")
        'De wijzigknop op disabled zetten als erop geklikt wordt
        JavaScript.ZetButtonOpDisabledOnClick(btnUpdate, "Opslaan...")

        JavaScript.ZetButtonOpDisabledOnClick(btnSjablonen, "Bezig met toevoegen..", True)

    End Sub

    Sub ValideerZoekTerm(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        ' Default Value
        args.IsValid = True

        Dim resultaten As String = String.Concat(Me.txtZoekTag.Text, Me.txtZoekTitel.Text)

        If resultaten = String.Empty Then
            args.IsValid = False
        End If

        divResultatenTonen.Visible = False
    End Sub

    Protected Sub btnSjablonen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSjablonen.Click
        Try
            If lstSjablonen.SelectedItem IsNot Nothing Then
                If Not lstSjablonen.SelectedItem.Text = String.Empty Then

                    Dim template As String = lstSjablonen.SelectedItem.Text
                    Dim x As New XML(String.Concat(Server.MapPath("~/Templates/"), template, ".xml"), String.Concat(Server.MapPath("~/Templates/"), template, ".xsl"))
                    EditorBewerken.Value = String.Concat(EditorBewerken.Value, XML.LeesXMLFile(x))

                End If
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnSjablonen, ex.Message)
        End Try
    End Sub
    ''' <summary>
    ''' hier wordt het label waarin een voorbeeld van de tag te zien is gevuld met de nodige waarden.
    ''' Dit wordt uitgevoerd elke keer er een dropdown van waarde verandert
    ''' Als er in de textbox voor de tag iets getypt wordt, wordt er javascript code uitgevoerd.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub gettag()

        If ddlTaal.SelectedItem Is Nothing Then
            Dim err As New ErrorLogger("De dropdownlist voor taal was leeg.","ARTIKELBEWERKEN_0008")
            ErrorLogger.WriteError(err)
            Return
        End If

        Dim strtag() As String = Split(ddlTaal.SelectedItem.Text, "-")

        Try
            strtag(1) = Trim(strtag(1))
            lblTaalTag.InnerHtml = strtag(1)
        Catch ex As Exception
            Dim err As New ErrorLogger(String.Concat("De waarde in de dropdownlist taal kon niet worden opgesplitst op het teken ""-"". Waarde: ", ddlTaal.SelectedItem.Text),"ARTIKELBEWERKEN_0009")
            ErrorLogger.WriteError(err)
            Return
        End Try

        Dim bedrijfdal As New BedrijfDAL
        Dim dr As tblBedrijfRow = bedrijfdal.GetBedrijfByID(ddlBedrijf.SelectedValue)

        If dr Is Nothing Then
            Dim err As New ErrorLogger(String.Concat("Het bedrijf met ID ", ddlBedrijf.SelectedValue, " werd niet gevonden in de database."),"ARTIKELBEWERKEN_0009")
            ErrorLogger.WriteError(err)
            Return
        End If

        Dim bedrijftag As String = dr("tag")
        lblBedrijftag.InnerHtml = bedrijftag
        lblTagvoorbeeld.InnerHtml = ddlVersie.SelectedItem.Text + "_" + strtag(1) + "_" + bedrijftag + "_" + ddlModule.SelectedItem.Text + "_" + txtTag.Text
    End Sub

    Protected Sub ddlModule_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlModule.DataBound
        Try
            gettag()
        Catch ex As Exception
            Util.OnverwachteFout(Me, ex.Message)
        End Try
    End Sub

    Protected Sub ddlModule_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlModule.SelectedIndexChanged
        Try
            gettag()
        Catch ex As Exception
            Util.OnverwachteFout(Me, ex.Message)
        End Try
    End Sub
End Class
