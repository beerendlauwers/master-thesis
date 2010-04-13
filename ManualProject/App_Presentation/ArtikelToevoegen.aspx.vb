Imports Manual
Imports System.Diagnostics
Imports System.IO
Imports System.Drawing

Partial Class App_Presentation_invoerenTest
    Inherits System.Web.UI.Page
    Private taaldal As New TaalDAL
    Private artikel As Manual.tblArtikelRow
    Private adap As New ManualTableAdapters.tblArtikelTableAdapter
    Private bedrijfIsKlaar As Boolean = False
    Private versieIsKlaar As Boolean = False
    Private taalIsKlaar As Boolean = False

    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegtoe.Click

        Dim tekst As String = Editor1.Content
        Dim tag As String = txtTag.Text.Trim
        Dim titel As String = txtTitel.Text.Trim

        Dim FK_versie As Integer = ddlVersie.SelectedValue
        Dim FK_Bedrijf As Integer = ddlBedrijf.SelectedValue
        Dim FK_categorie As Integer = ddlCategorie.SelectedValue
        Dim FK_taal As Integer = ddlTaal.SelectedValue
        Dim dr As Manual.tblTaalRow
        dr = taaldal.GetTaalByID(FK_taal)
        tag = dr("TaalTag") + "_" + tag
        Dim finaal As Integer
        If ckbFinaal.Checked = True Then
            finaal = 1
        Else
            finaal = 0
        End If

        'Checken of een ander artikel niet al dezelfde naam heeft
        If DatabaseLink.GetInstance.GetArtikelFuncties.checkArtikelByTitel(titel, FK_Bedrijf, FK_versie, FK_taal) IsNot Nothing Then
            Util.SetError("Toevoegen Mislukt: Er bestaat reeds een artikel met deze titel in deze structuur.", lblresultaat, imgResultaat)
            divFeedback.Visible = True
            Return
        End If

        'Checken of een ander artikel niet dezelfde tag heeft
        If DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelByTag(tag) IsNot Nothing Then
            Util.SetWarn("Toevoegen Mislukt: Er bestaat reeds een artikel met deze tag.", lblresultaat, imgResultaat)
            divFeedback.Visible = True
            Return
        End If

        Dim insertGelukt As Boolean = adap.Insert(titel, FK_categorie, FK_taal, FK_Bedrijf, FK_versie, tekst, tag, finaal)
        If insertGelukt = True Then

            'Nu gaan we de boomstructuur in het geheugen updaten.

            'We halen de tree op waar dit artikel in werd opgeslagen
            Dim tree As Tree = tree.GetTree(FK_taal, FK_versie, FK_Bedrijf)

            'We proberen het artikel toe te voegen.
            Dim boodschap As String = tree.VoegArtikelToeAanCategorie(tag, FK_categorie)

            'Boodschap nakijken voor een foutboodschap
            If boodschap = "OK" Then
                Util.SetOK("Toevoegen Geslaagd.", lblresultaat, imgResultaat)
                Me.btnVoegtoe.Visible = False
            Else
                Util.SetWarn(String.Concat("Toevoegen Geslaagd met waarschuwing: ", boodschap), lblresultaat, imgResultaat)
                Me.btnVoegtoe.Visible = False
            End If

        Else
            Util.SetError("Toevoegen Mislukt: Kon niet verbinden met de database.", lblresultaat, imgResultaat)
        End If

        divFeedback.Visible = True
       

    End Sub

    Protected Sub ddlBedrijf_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBedrijf.DataBound
        bedrijfIsKlaar = True

        If bedrijfIsKlaar And versieIsKlaar And taalIsKlaar Then
            LaadCategorien()
        End If
    End Sub

    Protected Sub ddlTaal_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTaal.DataBound
        taalIsKlaar = True

        If bedrijfIsKlaar And versieIsKlaar And taalIsKlaar Then
            LaadCategorien()
        End If
    End Sub

    Protected Sub ddlVersie_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlVersie.DataBound
        versieIsKlaar = True

        If bedrijfIsKlaar And versieIsKlaar And taalIsKlaar Then
            LaadCategorien()
        End If
    End Sub

    Protected Sub ddlBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBedrijf.SelectedIndexChanged
        LaadCategorien()
    End Sub

    Protected Sub ddlTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTaal.SelectedIndexChanged
        LaadCategorien()
    End Sub

    Protected Sub ddlVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlVersie.SelectedIndexChanged
        LaadCategorien()
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
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.Title = "Artikel Toevoegen"

        If Session("login") = 1 Then
            divLoggedIn.Visible = True
        Else
            divLoggedIn.Visible = False
            Session("vorigePagina") = Page.Request.Url.AbsolutePath
            Response.Redirect("Aanmeldpagina.aspx")
        End If

        'De opslaanknop op disabled zetten als erop geklikt wordt
        JavaScript.ZetButtonOpDisabledOnClick(btnVoegtoe, "Opslaan...", )
        JavaScript.ZetButtonOpDisabledOnClick(btnImageToevoegen, "Bezig met toevoegen..", True, True)
        JavaScript.ZetButtonOpDisabledOnClick(btnSjablonen, "Bezig met toevoegen..", True, True)

        LaadTooltips()

        If Not IsPostBack Then
            LaadTemplates()
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

    Private Sub LaadTooltips()

        'Nieuwe lijst van tooltips definiëren
        Dim lijst As New List(Of Tooltip)

        'Alle tooltips voor onze pagina toevoegen
        lijst.Add(New Tooltip("tipTag", XML.GetTip("ARTIKELTOEVOEGEN_TAG")))
        lijst.Add(New Tooltip("tipTitel", XML.GetTip("ARTIKELTOEVOEGEN_TITEL")))
        lijst.Add(New Tooltip("tipTaal", XML.GetTip("ARTIKELTOEVOEGEN_TAAL")))
        lijst.Add(New Tooltip("tipBedrijf", XML.GetTip("ARTIKELTOEVOEGEN_BEDRIJF")))
        lijst.Add(New Tooltip("tipVersie", XML.GetTip("ARTIKELTOEVOEGEN_VERSIE")))
        lijst.Add(New Tooltip("tipCategorie", XML.GetTip("ARTIKELTOEVOEGEN_CATEGORIE")))
        lijst.Add(New Tooltip("tipFinaal", XML.GetTip("ARTIKELTOEVOEGEN_FINAAL")))
        lijst.Add(New Tooltip("tipUpload", XML.GetTip("ARTIKELTOEVOEGEN_AFBEELDING")))
        lijst.Add(New Tooltip("tipSjabloon", XML.GetTip("ARTIKELTOEVOEGEN_SJABLOON")))

        'Tooltips op de pagina zetten via scriptmanager als het een postback is, anders gewoon in de onload functie van de body.
        If Page.IsPostBack Then
            Tooltip.VoegTipToeAanEndRequest(Me, lijst)
        Else
            Dim body As HtmlGenericControl = Master.FindControl("MasterBody")
            Tooltip.VoegTipToeAanBody(body, lijst)
        End If

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
End Class
