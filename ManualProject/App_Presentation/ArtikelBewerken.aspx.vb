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
        'Paginatitel
        Page.Title = "Artikel Bewerken"

        Util.CheckOfBeheerder(Page.Request.Url.AbsolutePath)

        'Als de pagina de eerste keer laadt
        If Not Page.IsPostBack Then

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
                    JavaScript.VoegJavascriptToeAanBody(Master.FindControl("MasterBody"), "VeranderEditorScherm(200);")
                End If
            ElseIf Page.Request.QueryString("tag") IsNot Nothing Then
                Dim tag As String = Page.Request.QueryString("tag")
                LaadArtikel(tag)
                JavaScript.VoegJavascriptToeAanBody(Master.FindControl("MasterBody"), "VeranderEditorScherm(200);")
            End If

        End If

        If IsPostBack Then
            JavaScript.VoegJavascriptToeAanEndRequest(Me, "if (CKEDITOR.instances['ctl00_ContentPlaceHolder1_EditorBewerken']) {CKEDITOR.remove(CKEDITOR.instances['ctl00_ContentPlaceHolder1_EditorBewerken']); CKEDITOR.replace('ctl00_ContentPlaceHolder1_EditorBewerken');CKFinder.SetupCKEditor( null, 'JS/ckfinder/' ); alert('en we zijn klaar'); }")
        End If

        LaadZoekTooltips()
        LaadJavascript()

        'txtTag.Attributes.Add("onClick", "trVisible()")
        'rdbAlleTalen.Attributes.Add("onClick", "trInvisible()")
        'rdbEnkeleTaal.Attributes.Add("onClick", "trInvisible()")
        Dim str() As String = Split(ddlTaal.SelectedItem.Text, "-")
        str(1) = Trim(str(1))
        lblTaalTag.InnerHtml = str(1)
        ddlModule.DataBind()
        lblTagvoorbeeld.InnerHtml = ddlVersie.SelectedItem.Text + "_" + lblTaalTag.InnerHtml + "_" + ddlBedrijf.SelectedItem.Text + "_" + ddlModule.SelectedItem.Text + "_" + txtTag.Text
    End Sub

    Protected Sub btnZoek_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoek.Click
        ZoekresultatenWeergeven()
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

            For i As Integer = 0 To dttitel.Rows.Count - 1
                Dim dr As Data.DataRow = dt.NewRow
                dr = dttitel.Rows(i)
                dt.ImportRow(dr)
            Next
            If dttekst.Rows.Count > 0 Then
                For i As Integer = 0 To dttekst.Rows.Count - 1
                    Dim dr As Data.DataRow = dt.NewRow
                    dr = dttekst.Rows(i)
                    dt.ImportRow(dr)
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

        If Me.ddlCategorie.Items.Count = 0 Then
            Util.SetError("U dient een categorie op te geven.", lblresultaat, imgResultaat)
            Me.divFeedback.Visible = True
            Return
        End If

        Dim artikel As New Artikel

        artikel.ID = Session("artikelID")
        artikel.Bedrijf = ddlBedrijf.SelectedValue
        artikel.Categorie = ddlCategorie.SelectedValue
        artikel.Taal = ddlTaal.SelectedValue
        artikel.Versie = ddlVersie.SelectedValue
        artikel.Tag = lblTagvoorbeeld.InnerHtml
        artikel.Tekst = EditorBewerken.Value
        artikel.Titel = txtTitel.Text

        If ckbFinal.Checked = True Then
            artikel.IsFinal = 1
        Else
            artikel.IsFinal = 0
        End If

        'Checken of een ander artikel reeds deze titel heeft
        If artikeldal.checkArtikelByTitelEnID(artikel.Titel, artikel.Bedrijf, artikel.Versie, artikel.Taal, artikel.ID).Count > 0 Then
            Util.SetError("Update mislukt: Er bestaat reeds een artikel met deze titel in deze structuur.", lblresultaat, imgResultaat)
            Me.divFeedback.Visible = True
            Return
        End If

        'Checken of een ander artikel niet dezelfde tag heeft
        If artikeldal.checkArtikelByTag(artikel.Tag, artikel.Bedrijf, artikel.Versie, artikel.Taal, artikel.ID).Count > 0 Then
            Util.SetError("Update mislukt: Er bestaat reeds een artikel met deze tag.", lblresultaat, imgResultaat)
            Me.divFeedback.Visible = True
            Return
        End If
        If rdbAlleTalen.Checked Then
            Dim taaldal As New TaalDAL
            Dim oudetag As String = Session("oudetag")
            Dim i As Integer
            i = taaldal.updateTagTalen(oudetag, artikel.Tag)
            If i = 0 Then
                lblresultaat.Text = "De tags zijn misschien niet correct aangepast."
            End If
        End If
        If artikeldal.updateArtikel(artikel) = True Then

            'Boomstructuur in het geheugen updaten.

            'We halen de tree op waar dit artikel in werd opgeslagen
            Dim tree As Tree = tree.GetTree(artikel.Taal, artikel.Versie, artikel.Bedrijf)

            If tree Is Nothing Then
                Dim fout As String = String.Concat("De opgevraagde tree (zie parameters) bestaat niet in het geheugen.")
                Dim err As New ErrorLogger(fout, "ARTIKELBEWERKEN_0001")
                err.Args.Add("Taal = " & artikel.Taal.ToString)
                err.Args.Add("Versie = " & artikel.Versie.ToString)
                err.Args.Add("Bedrijf = " & artikel.Bedrijf.ToString)
                ErrorLogger.WriteError(err)
            End If

            'We zoeken het artikel op en updaten het.
            Dim node As Node = tree.DoorzoekTreeVoorNode(artikel.ID, Global.ContentType.Artikel)

            If node Is Nothing Then
                Util.SetWarn("Update geslaagd met waarschuwing: Kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met wijzigingen te maken.", lblresultaat, imgResultaat)
                ArtikelFunctiesZichtbaar(False)
                Me.divFeedback.Visible = True

                Dim fout As String = String.Concat("De opgevraagde node (zie parameters) bestaat niet in het geheugen.")
                Dim err As New ErrorLogger(fout, "ARTIKELBEWERKEN_0002")
                err.Args.Add("ID = " & artikel.ID.ToString)
                err.Args.Add("Type = " & Global.ContentType.Artikel.ToString)
                ErrorLogger.WriteError(err)

                Return
            Else
                node.Titel = artikel.Titel

                Dim oudeparent As Node = tree.VindParentVanNode(node)
                Dim nieuweparent As Node = tree.DoorzoekTreeVoorNode(artikel.Categorie, Global.ContentType.Categorie)

                If nieuweparent IsNot oudeparent Then

                    If oudeparent Is Nothing Then
                        Dim fout As String = String.Concat("De opgevraagde node (zie parameters) bestaat niet in het geheugen.")
                        Dim err As New ErrorLogger(fout, "ARTIKELBEWERKEN_0003")
                        err.Args.Add("ID = " & node.ID.ToString)
                        err.Args.Add("Type = " & Global.ContentType.Artikel.ToString)
                        ErrorLogger.WriteError(err)
                    End If

                    If nieuweparent Is Nothing Then
                        Dim fout As String = String.Concat("De opgevraagde node (zie parameters) bestaat niet in het geheugen.")
                        Dim err As New ErrorLogger(fout, "ARTIKELBEWERKEN_0004")
                        err.Args.Add("ID = " & artikel.Categorie.ToString)
                        err.Args.Add("Type = " & Global.ContentType.Categorie.ToString)
                        ErrorLogger.WriteError(err)
                    End If

                    If nieuweparent Is Nothing Or oudeparent Is Nothing Then
                        Util.SetWarn("Update geslaagd met waarschuwing: Kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met wijzigingen te maken.", lblresultaat, imgResultaat)
                        ArtikelFunctiesZichtbaar(False)
                        Me.divFeedback.Visible = True
                        Return
                    Else
                        nieuweparent.AddChild(node)
                        oudeparent.RemoveChild(node)
                    End If

                End If

            End If

            Util.SetOK("Update geslaagd.", lblresultaat, imgResultaat)
            Me.divFeedback.Visible = True
        Else
            Util.SetError("Update mislukt: Kon niet met de database verbinden.", lblresultaat, imgResultaat)
            Me.divFeedback.Visible = True
        End If
        ArtikelFunctiesZichtbaar(False)
        ZoekresultatenWeergeven()
        Me.divFeedback.Visible = True

    End Sub

#Region "Gridview Event Handlers"

    Protected Sub grdvLijst_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdvLijst.RowCommand
        If e.CommandName = "Select" Then

            Dim row As GridViewRow = grdvLijst.Rows(e.CommandArgument)
            Dim artikeltag As String = row.Cells(1).Text
            Dim artikelID As Integer = Integer.Parse(row.Cells(7).Text)
            LaadArtikel(artikelID)
        End If
    End Sub

    Protected Sub grdvLijst_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdvLijst.RowDataBound
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
    End Sub

#End Region

#Region "Artikelfuncties"

    Private Sub LaadArtikel(ByVal id As Integer)
        Dim artikel As New Artikel(artikeldal.GetArtikelByID(id))
        ArtikelInladen(artikel)
    End Sub

    Private Sub LaadArtikel(ByVal tag As String)

        Dim artikel As New Artikel(artikeldal.GetArtikelByTag(tag))
        ArtikelInladen(artikel)
    End Sub

    Private Sub ArtikelInladen(ByVal artikel As Artikel)

        ArtikelFunctiesZichtbaar(True)

        Session("artikelID") = artikel.ID
        txtTitel.Text = artikel.Titel

        lblTagvoorbeeld.InnerHtml = artikel.Tag
        Dim tag() As String = Split(artikel.Tag, "_")

        txtTag.Text = tag(tag.Count - 1)
        ddlModule.SelectedValue = tag(tag.Count - 2)
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
        updBewerken.Update()

        Me.divFeedback.Visible = False
    End Sub

    Private Sub LaadCategorien()

        Dim t As Tree = Tree.GetTree(Me.ddlTaal.SelectedValue, Me.ddlVersie.SelectedValue, Me.ddlBedrijf.SelectedValue)
        Util.LeesCategorien(ddlCategorie, t)

        If Me.ddlCategorie.Items.Count = 0 Then
            Me.ddlCategorie.Visible = False
            Me.lblGeenCategorie.Visible = True
        Else
            Me.ddlCategorie.Visible = True
            Me.lblGeenCategorie.Visible = False

            Try
                Dim categorieWaarde As Integer = Session("categorieWaarde")
                ddlCategorie.SelectedValue = categorieWaarde
            Catch
                ddlCategorie.SelectedIndex = 0
            End Try
        End If

    End Sub

    Private Sub ArtikelFunctiesZichtbaar(ByVal zichtbaar As Boolean)
        Me.divInvullen.Visible = zichtbaar
        Me.divFeedback.Visible = False
        Me.btnUpdate.Visible = zichtbaar
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
        'Util.LeesTalen(ddlTaal)
        Util.LeesVersies(ddlVersie)

        Me.ddlTaal.Items.Clear()
        For Each t As Taal In Taal.GetTalen
            Dim item As New ListItem(t.TaalNaam + " - " + t.TaalTag, t.ID)
            Me.ddlTaal.Items.Add(item)
        Next

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
        If lstSjablonen.SelectedItem IsNot Nothing Then
            If Not lstSjablonen.SelectedItem.Text = String.Empty Then

                Dim template As String = lstSjablonen.SelectedItem.Text
                Dim x As New XML(String.Concat(Server.MapPath("~/Templates/"), template, ".xml"), String.Concat(Server.MapPath("~/Templates/"), template, ".xsl"))
                EditorBewerken.Value = String.Concat(EditorBewerken.Value, XML.LeesXMLFile(x))

            End If
        End If
    End Sub

    Protected Sub rdbAlleTalen_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdbAlleTalen.CheckedChanged
        trRadio.Visible = False
    End Sub

    Protected Sub rdbEnkeleTaal_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdbEnkeleTaal.CheckedChanged
        trRadio.Visible = False
    End Sub
    Public Sub gettag()
        Dim strtag() As String = Split(ddlTaal.SelectedItem.Text, "-")
        strtag(1) = Trim(strtag(1))
        lblTaalTag.InnerHtml = strtag(1)
        lblTagvoorbeeld.InnerHtml = ddlVersie.SelectedItem.Text + "_" + lblTaalTag.InnerHtml + "_" + ddlBedrijf.SelectedItem.Text + "_" + ddlModule.SelectedItem.Text + "_" + txtTag.Text
    End Sub

    Protected Sub ddlModule_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlModule.DataBound
        lblTagvoorbeeld.InnerHtml = ddlVersie.SelectedItem.Text + "_" + lblTaalTag.InnerHtml + "_" + ddlBedrijf.SelectedItem.Text + "_" + ddlModule.SelectedItem.Text + "_" + txtTag.Text
    End Sub

    Protected Sub ddlModule_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlModule.SelectedIndexChanged
        gettag()
    End Sub
End Class
