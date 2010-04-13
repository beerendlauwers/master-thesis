Imports Manual
Imports System.Diagnostics
Imports System.IO
Imports System.Drawing
Imports System.Web.HttpUtility

Partial Class App_Presentation_ArtikelBewerken
    Inherits System.Web.UI.Page

    Private artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties
    Private taaldal As New TaalDAL
    Private bedrijfIsKlaar As Boolean = False
    Private versieIsKlaar As Boolean = False
    Private taalIsKlaar As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Paginatitel
        Page.Title = "Artikel Bewerken"

        If Session("login") = 1 Then
            divLoggedIn.Visible = True
        Else
            divLoggedIn.Visible = False
            Session("vorigePagina") = Page.Request.Url.AbsolutePath
            Response.Redirect("Aanmeldpagina.aspx")
        End If

        'Als de pagina de eerste keer laadt
        If Not Page.IsPostBack Then

            'Dropdowns laden
            LaadDropdowns()

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

        LaadTooltips()

        Dim body As HtmlGenericControl = Master.FindControl("MasterBody")

        Dim js As String = String.Concat("if( this.checked ){ var tr = document.getElementsByName('trRad'); tr.style.display='none';}")
        JavaScript.VoerJavaScriptUitOn(rdbAlleTalen, js, "onclick")
        JavaScript.VoerJavaScriptUitOn(rdbEnkeleTaal, js, "onclick")

        'De zoekknop op disabled zetten als erop geklikt wordt
        JavaScript.ZetButtonOpDisabledOnClick(btnZoek, "Laden...", True)
        'De wijzigknop op disabled zetten als erop geklikt wordt
        JavaScript.ZetButtonOpDisabledOnClick(btnUpdate, "Opslaan...", True)

        JavaScript.ZetButtonOpDisabledOnClick(btnImageToevoegen, "Bezig met toevoegen..", True, True)
        JavaScript.ZetButtonOpDisabledOnClick(btnSjablonen, "Bezig met toevoegen..", True, True)

        If Not IsPostBack Then
            LaadTemplates()
        End If
        txtTag.Attributes.Add("onClick", "trVisible()")
        rdbAlleTalen.Attributes.Add("onClick", "trInvisible()")
        rdbEnkeleTaal.Attributes.Add("onClick", "trInvisible()")
    End Sub

    Protected Sub btnZoek_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoek.Click

        'Zoekwaardes ophalen
        Dim zoekTag As String = Me.txtZoekTag.Text.Trim
        Dim zoekTitel As String = Me.txtZoekTitel.Text.Trim

        'Dropdownwaardes ophalen
        Dim versies As String = Util.LeesDropdown(ddlVersieVerfijnen)
        Dim bedrijven As String = Util.LeesDropdown(ddlBedrijfVerfijnen)
        Dim talen As String = Util.LeesDropdown(ddlTaalVerfijnen)
        Dim isFInaal As String = Util.LeesDropdown(ddlIsFInaalVerfijnen)


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
        Dim dr As Manual.tblTaalRow
        dr = taaldal.GetTaalByID(artikel.Taal)
        artikel.Tag = dr("TaalTag") + "_" + txtTag.Text
        artikel.Tekst = Editor1.Content
        artikel.Titel = txtTitel.Text

        If ckbFinal.Checked = True Then
            artikel.IsFinal = 1
        Else
            artikel.IsFinal = 0
        End If

        'Checken of een ander artikel reeds deze titel heeft
        If artikeldal.checkArtikelByTitelEnID(artikel.Titel, artikel.Bedrijf, artikel.Versie, artikel.Taal, artikel.ID) IsNot Nothing Then
            Util.SetError("Update mislukt: Er bestaat reeds een artikel met deze titel in deze structuur.", lblresultaat, imgResultaat)
            Me.divFeedback.Visible = True
            Return
        End If

        'Checken of een ander artikel niet dezelfde tag heeft
        If artikeldal.checkArtikelByTag(artikel.Tag, artikel.Bedrijf, artikel.Versie, artikel.Taal, artikel.ID) IsNot Nothing Then
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
                        Dim err As New ErrorLogger(fout, "ARTIKELBEWERKEN_0003")
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
        Me.divFeedback.Visible = True

        grdvLijst.DataBind()
    End Sub

#Region "Gridview Event Handlers"

    Protected Sub grdvLijst_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdvLijst.RowCommand
        If e.CommandName = "Select" Then
            Dim row As GridViewRow = grdvLijst.Rows(e.CommandArgument)
            Dim artikeltag As String = row.Cells(1).Text
            LaadArtikel(artikeltag)
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

        JavaScript.VoegJavascriptToeAanEndRequest(Me, "VeranderEditorScherm(200);")

        ArtikelFunctiesZichtbaar(True)

        Session("artikelID") = artikel.ID
        txtTitel.Text = artikel.Titel
        Dim tag() As String = Split(artikel.Tag, "_")
        txtTag.Text = tag(1)
        Editor1.Content = artikel.Tekst
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

        updBewerken.Update()

        Me.divFeedback.Visible = False
    End Sub

    Private Sub LaadCategorien()

        Dim t As Tree = Tree.GetTree(Me.ddlTaal.SelectedValue, Me.ddlVersie.SelectedValue, Me.ddlBedrijf.SelectedValue)
        Me.ddlCategorie.Items.Clear()

        Me.ddlCategorie.Items.Add(New ListItem("root_node", "0"))

        t.VulCategorieDropdown(Me.ddlCategorie, t.RootNode, -1)

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
    End Sub

    Protected Sub ddlTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTaal.SelectedIndexChanged
        ViewState("taalID") = ddlTaal.SelectedValue
        LaadCategorien()
    End Sub

    Protected Sub ddlVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlVersie.SelectedIndexChanged
        ViewState("versieID") = ddlVersie.SelectedValue
        LaadCategorien()
    End Sub

#End Region

    Private Sub LaadDropdowns()

        ddlBedrijfVerfijnen.Items.Clear()
        ddlBedrijfVerfijnen.Items.Add(New ListItem("Alles", "-1000"))
        For Each b As Bedrijf In Bedrijf.GetBedrijven
            ddlBedrijfVerfijnen.Items.Add(New ListItem(b.Naam, b.ID))
        Next b

        ddlVersieVerfijnen.Items.Clear()
        ddlVersieVerfijnen.Items.Add(New ListItem("Alles", "-1000"))
        For Each v As Versie In Versie.GetVersies
            ddlVersieVerfijnen.Items.Add(New ListItem(v.VersieNaam, v.ID))
        Next v

        ddlTaalVerfijnen.Items.Clear()
        ddlTaalVerfijnen.Items.Add(New ListItem("Alles", "-1000"))
        For Each t As Taal In Taal.GetTalen
            ddlTaalVerfijnen.Items.Add(New ListItem(t.TaalNaam, t.ID))
        Next t

        ddlIsFInaalVerfijnen.Items.Clear()
        ddlIsFInaalVerfijnen.Items.Add(New ListItem("Alles", "-1000"))
        ddlIsFInaalVerfijnen.Items.Add(New ListItem("Ja", "1"))
        ddlIsFInaalVerfijnen.Items.Add(New ListItem("Nee", "0"))

        Me.ddlBedrijf.Items.Clear()
        For Each b As Bedrijf In Bedrijf.GetBedrijven
            Dim item As New ListItem(b.Naam, b.ID)
            Me.ddlBedrijf.Items.Add(item)
        Next

        Me.ddlTaal.Items.Clear()
        For Each t As Taal In Taal.GetTalen
            Dim item As New ListItem(t.TaalNaam, t.ID)
            Me.ddlTaal.Items.Add(item)
        Next

        Me.ddlVersie.Items.Clear()
        For Each v As Versie In Versie.GetVersies
            Dim item As New ListItem(v.VersieNaam, v.ID)
            Me.ddlVersie.Items.Add(item)
        Next

        LaadCategorien()

    End Sub

    Private Sub LaadTooltips()

        'Nieuwe lijst van tooltips definiëren
        Dim lijst As New List(Of Tooltip)

        'Alle tooltips voor onze pagina toevoegen
        lijst.Add(New Tooltip("tipZoekTitel", XML.GetTip("ARTIKELBEWERKEN_ZOEKTITEL")))
        lijst.Add(New Tooltip("tipTaalVerfijnen", XML.GetTip("ARTIKELVERWIJDEREN_TAAL")))
        lijst.Add(New Tooltip("tipBedrijfVerfijnen", XML.GetTip("ARTIKELVERWIJDEREN_BEDRIJF")))
        lijst.Add(New Tooltip("tipVersieVerfijnen", XML.GetTip("ARTIKELVERWIJDEREN_VERSIE")))
        lijst.Add(New Tooltip("tipIsFinaalVerfijnen", XML.GetTip("ARTIKELVERWIJDEREN_ISFINAAL")))
        lijst.Add(New Tooltip("tipZoekTag", XML.GetTip("ARTIKELBEWERKEN_ZOEKTAG")))
        lijst.Add(New Tooltip("tipTag", XML.GetTip("ARTIKELBEWERKEN_TAG")))
        lijst.Add(New Tooltip("tipTitel", XML.GetTip("ARTIKELBEWERKEN_TITEL")))
        lijst.Add(New Tooltip("tipTaal", XML.GetTip("ARTIKELBEWERKEN_TAAL")))
        lijst.Add(New Tooltip("tipBedrijf", XML.GetTip("ARTIKELBEWERKEN_BEDRIJF")))
        lijst.Add(New Tooltip("tipVersie", XML.GetTip("ARTIKELBEWERKEN_VERSIE")))
        lijst.Add(New Tooltip("tipCategorie", XML.GetTip("ARTIKELBEWERKEN_CATEGORIE")))
        lijst.Add(New Tooltip("tipFinaal", XML.GetTip("ARTIKELBEWERKEN_FINAAL")))
        lijst.Add(New Tooltip("tipUpload", XML.GetTip("ARTIKELBEWERKEN_AFBEELDING")))
        lijst.Add(New Tooltip("tipSjabloon", XML.GetTip("ARTIKELTOEVOEGEN_SJABLOON")))


        'Tooltips op de pagina zetten via scriptmanager als het een postback is, anders gewoon in de onload functie van de body.
        If Page.IsPostBack Then
            Tooltip.VoegTipToeAanEndRequest(Me, lijst)
        Else
            Dim body As HtmlGenericControl = Master.FindControl("MasterBody")
            Tooltip.VoegTipToeAanBody(body, lijst)
        End If

    End Sub

    Private Sub LaadTemplates()

        'Directory ophalen
        Dim di As New IO.DirectoryInfo(String.Concat(Server.MapPath("~/"), "Templates"))

        'Alle templates ophalen
        Dim templatelijst As New List(Of IO.FileInfo)
        For Each file As IO.FileInfo In di.GetFiles
            templatelijst.Add(file)
        Next

        'Alle geldige XML-XSL combinaties opslaan
        Dim xmllijst As New List(Of XML)
        For Each template As IO.FileInfo In templatelijst
            If template.Extension = ".xml" Then
                For Each xsltemplate As IO.FileInfo In templatelijst
                    If xsltemplate.Name.Replace(".xsl", String.Empty) = template.Name.Replace(".xml", String.Empty) And xsltemplate.Extension = ".xsl" Then
                        lstSjablonen.Items.Add(template.Name.Replace(".xml", String.Empty))
                    End If
                Next
            End If
        Next template

    End Sub

    Private Function CheckOfBestandBestaat(ByVal filename As String) As String

        If File.Exists(String.Concat(Server.MapPath("~/App_Presentation/Uploads/Images/"), filename)) Then
            Dim r As New Random
            Dim bestand As String() = filename.Split(".")
            filename = String.Concat(bestand(0), "_", r.Next, r.Next, r.Next, ".", bestand(1))

            If bestand.Count > 2 Then
                For i As Integer = 2 To bestand.Count - 1
                    filename = String.Concat(filename, ".", bestand(i))
                Next
            End If

            Return CheckOfBestandBestaat(filename)
        Else
            Return filename
        End If

    End Function

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
                Editor1.Content = String.Concat(Editor1.Content, XML.LeesXMLFile(x))

            End If
        End If
    End Sub

    Protected Sub btnImageToevoegen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnImageToevoegen.Click

        If uplAfbeelding.PostedFile IsNot Nothing Then

            Dim type As String = Path.GetExtension(uplAfbeelding.FileName)
            If type = ".gif" Or type = ".jpeg" Or type = ".jpg" Or type = ".png" Then

                'Checken of bestand bestaat en bestandsnaam veranderen indien nodig
                Dim filename As String = CheckOfBestandBestaat(uplAfbeelding.FileName)

                'Afbeelding opslaan
                uplAfbeelding.SaveAs(String.Concat(Server.MapPath("~/App_Presentation/Uploads/Images/"), filename))

                'Afbeelding in editor plaatsen
                Dim img As String = String.Concat("<img src=""Uploads/Images/", filename, """/>")
                Editor1.Content = String.Concat(Editor1.Content, img)

                'Editor vergroten
                Dim image As System.Drawing.Image = System.Drawing.Image.FromStream(uplAfbeelding.PostedFile.InputStream)
                Dim hoogte As Integer = image.PhysicalDimension.Height
                Editor1.Height = New Unit(Editor1.Height.Value + hoogte + 50)
                updContent.Update()
            End If

        End If
    End Sub

    Protected Sub rdbAlleTalen_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdbAlleTalen.CheckedChanged
        trRadio.Visible = False
    End Sub

    Protected Sub rdbEnkeleTaal_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdbEnkeleTaal.CheckedChanged
        trRadio.Visible = False
    End Sub
End Class
