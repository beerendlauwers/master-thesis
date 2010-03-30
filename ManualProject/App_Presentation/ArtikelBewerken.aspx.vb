Imports Manual
Imports System.Diagnostics

Partial Class App_Presentation_ArtikelBewerken
    Inherits System.Web.UI.Page

    Private artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties
    Private bedrijfIsKlaar As Boolean = False
    Private versieIsKlaar As Boolean = False
    Private taalIsKlaar As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.ID = "StampFactsControl"
        'Paginatitel
        Page.Title = "Artikel Bewerken"

        'De zoekknop op disabled zetten als erop geklikt wordt
        JavaScript.ZetButtonOpDisabledOnClick(btnZoek, "Laden...", True)
        'De wijzigknop op disabled zetten als erop geklikt wordt
        JavaScript.ZetButtonOpDisabledOnClick(btnUpdate, "Opslaan...", True)

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
        Dim div As HtmlGenericControl = Me.FindControl("LoggedIn")
        If Session("login") = 1 Then

            divLoggedIn.Visible = True
        Else
            divLoggedIn.Visible = False
            lblLogin.Visible = True
            lblLogin.Text = "U bent niet ingelogd."
            ImageButton1.Visible = True
        End If

    End Sub

    Protected Sub btnZoek_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoek.Click
        Dim titel As String

        Dim zoekterm As String = "%" + Me.txtZoekTitel.Text.Trim + "%"

        Dim grdvLijst As GridView = updZoeken.FindControl("grdvLijst")

        titel = txtZoekTitel.Text
        If titel.Length > 0 Then
            titel = "%" + Me.txtZoekTitel.Text + "%"
            Dim dttitel As Data.DataTable = artikeldal.GetArtikelGegevensByTitel(titel)
            Dim dttekst As Data.DataTable = artikeldal.GetArtikelGegevensByTekst(titel)
            Dim dt As New Data.DataTable

            If dttitel.Rows.Count > 0 Then
                dt = dttitel.Clone
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
            ElseIf dttekst.Rows.Count > 0 Then
                dt = dttekst.Clone
                For i As Integer = 0 To dttekst.Rows.Count - 1
                    Dim dr As Data.DataRow = dt.NewRow
                    dr = dttekst.Rows(i)
                    dt.ImportRow(dr)
                Next
                If dttitel.Rows.Count > 0 Then
                    For i As Integer = 0 To dttitel.Rows.Count - 1
                        Dim dr As Data.DataRow = dt.NewRow
                        dr = dttitel.Rows(i)
                        dt.ImportRow(dr)
                    Next
                End If
            End If


            grdvLijst.DataSource = dt
            grdvLijst.DataBind()
            grdvLijst.Visible = True

            Me.divResultatenTonen.Visible = True
            JavaScript.VoegJavascriptToeAanEndRequest(Me, "Effect.toggle('divZoekResultaten', 'slide');")

        End If

        updBewerken.Update()
        updZoeken.Update()

        ArtikelFunctiesZichtbaar(False)

    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click

        If Me.ddlCategorie.Items.Count = 0 Then
            Me.lblresultaat.Text = "U dient een categorie op te geven."
            Me.imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\remove.png"
            Me.divFeedback.Visible = True
            Return
        End If

        Dim artikel As New Artikel

        artikel.ID = Session("artikelID")
        artikel.Bedrijf = ddlBedrijf.SelectedValue
        artikel.Categorie = ddlCategorie.SelectedValue
        artikel.Tag = txtTag.Text
        artikel.Tekst = Editor1.Content
        artikel.Titel = txtTitel.Text
        artikel.Versie = ddlVersie.SelectedValue
        If ckbFinal.Checked = True Then
            artikel.IsFinal = 1
        Else
            artikel.IsFinal = 0
        End If
        If artikeldal.updateArtikel(artikel) = True Then

            'Boomstructuur in het geheugen updaten.

            'We halen de tree op waar dit artikel in werd opgeslagen
            Dim tree As Tree = tree.GetTree(artikel.Taal, artikel.Versie, artikel.Bedrijf)

            'We zoeken het artikel op en updaten het.
            Dim node As Node = tree.DoorzoekTreeVoorNode(artikel.ID, Global.ContentType.Artikel)

            If node Is Nothing Then
                Me.lblresultaat.Text = "Update geslaagd met waarschuwing: Kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met wijzigingen te maken."
                ArtikelFunctiesZichtbaar(False)
                imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\warning.png"
                Me.divFeedback.Visible = True
                Return
            Else
                node.Titel = artikel.Titel

                Dim oudeparent As Node = tree.VindParentVanNode(node)
                Dim nieuweparent As Node = tree.DoorzoekTreeVoorNode(artikel.Categorie, Global.ContentType.Categorie)

                If nieuweparent IsNot oudeparent Then

                    If oudeparent Is Nothing Or nieuweparent Is Nothing Then
                        Me.lblresultaat.Text = "Update geslaagd met waarschuwing: Kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met wijzigingen te maken."
                        ArtikelFunctiesZichtbaar(False)
                        imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\warning.png"
                        Me.divFeedback.Visible = True
                        Return
                    Else
                        nieuweparent.AddChild(node)
                        oudeparent.RemoveChild(node)
                    End If

                End If

            End If

            lblresultaat.Text = "Update geslaagd."
            imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\tick.gif"
            Me.divFeedback.Visible = True
        Else
            Me.lblresultaat.Text = "Update mislukt: Kon niet met de database verbinden."
            Me.imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\remove.png"
            Me.divFeedback.Visible = True
        End If

        ArtikelFunctiesZichtbaar(False)
        Me.divFeedback.Visible = True
    End Sub

#Region "Gridview Event Handlers"

    Protected Sub grdvLijst_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdvLijst.RowCommand
        If e.CommandName = "Select" Then
            Dim upd As UpdatePanel = Me.FindControl("updToevoegen")
            Dim grdvLijst As GridView = updZoeken.FindControl("grdvLijst")
            Dim row As GridViewRow = grdvLijst.Rows(e.CommandArgument)


            Dim artikeltag As String = row.Cells(1).Text
            LaadArtikel(artikeltag)
        End If
    End Sub

    Protected Sub grdvLijst_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdvLijst.RowDataBound
        If (e.Row.Cells(0).Text = "Titel" And e.Row.Cells(1).Text = "Tag" And e.Row.Cells(2).Text = "Versie" And e.Row.Cells(3).Text = "Bedrijf" And e.Row.Cells(4).Text = "Taal") Then
            e.Row.Cells(5).Text = "Artikel Wijzigen"
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
        txtTag.Text = artikel.Tag
        Editor1.Content = artikel.Tekst
        ddlBedrijf.SelectedValue = artikel.Bedrijf
        ddlTaal.SelectedValue = artikel.Taal
        ddlVersie.SelectedValue = artikel.Versie

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
        lijst.Add(New Tooltip("tipZoekTitel", "Een (gedeelte van) de titel waarop u wilt zoeken."))
        lijst.Add(New Tooltip("tipTag", "De <b>unieke</b> tag van het artikel. Mag enkel letters, nummers en een underscore ( _ ) bevatten."))
        lijst.Add(New Tooltip("tipTitel", "De titel van het artikel."))
        lijst.Add(New Tooltip("tipTaal", "De taal van het artikel."))
        lijst.Add(New Tooltip("tipBedrijf", "Het bedrijf waaronder dit artikel zal worden gepubliceerd."))
        lijst.Add(New Tooltip("tipVersie", "De versie waartoe het artikel toebehoort. Dit nummer slaat op de versie van de applicatie, en niet op de versie van het artikel."))
        lijst.Add(New Tooltip("tipCategorie", "De categorie waaronder dit artikel zal worden gepubliceerd. De 'root_node' categorie is het beginpunt van de structuur."))
        lijst.Add(New Tooltip("tipFinaal", "Bepaalt of het artikel gefinaliseerd is of niet."))
        lijst.Add(New Tooltip("tipUpload", "Hiermee kan u afbeeldingen uploaden. Na het uploaden van 1 afbeelding kan u gewoon een volgende afbeelding uploaden."))

        'Tooltips op de pagina zetten via scriptmanager als het een postback is, anders gewoon in de onload functie van de body.
        If Page.IsPostBack Then
            Tooltip.VoegTipToeAanEndRequest(Me, lijst)
        Else
            Dim body As HtmlGenericControl = Master.FindControl("MasterBody")
            Tooltip.VoegTipToeAanBody(body, lijst)
        End If

    End Sub


    Protected Sub btnImageAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim lblFile As New Label
        lblFile = updBewerken.FindControl("lblFile")
        lblFile.Text = ""
        Dim FileUpload2 As FileUpload
        FileUpload2 = updBewerken.FindControl("FileUpload2")
        'lblFile.Text = FileUpload2.FileName
        'lblFile.Visible = True
        If FileUpload2.HasFile Then
            Dim fileextension As String
            fileextension = System.IO.Path.GetExtension(FileUpload2.FileName)
            If fileextension = ".jpg" Or fileextension = ".png" Or fileextension = ".gif" Then
                Dim tekst As String
                Dim htmltekst As String
                tekst = FileUpload2.FileName
                htmltekst = "<img src=""CSS/images/" + FileUpload2.FileName + """ style=""width: 400px; height: 300px;"" />"
                Dim loc As Integer
                loc = Editor1.Content.Length
                Dim content As String
                content = Editor1.Content
                content = content + "<br />" + htmltekst
                Editor1.Content = content
                FileUpload2.SaveAs("C:/ReferenceManual/App_Presentation/CSS/Images/" + FileUpload2.FileName)
            Else
                lblFile.ForeColor = Drawing.Color.Red
                lblFile.Text = "U kan enkel Jpg, png of gif afbeeldingen in u artikel gebruiken."
            End If
        Else
            lblFile.ForeColor = Drawing.Color.Red
            lblFile.Text = "Er is iets misgelopen, probeer de afbeelding opnieuw te uploaden."
        End If
    End Sub
    Protected Sub ImageButton1_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton1.Click
        Response.Redirect("Aanmeldpagina.aspx")
    End Sub
    
End Class
