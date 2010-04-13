Imports Manual

Partial Class App_Presentation_invoerenTest
    Inherits System.Web.UI.Page
    Private taaldal As New TaalDAL
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Paginatitel
        Page.Title = "Artikel Toevoegen"

        'Nakijken of de bezoeker wel ingelogd is als beheerder
        Util.CheckOfBeheerder(Page.Request.Url.AbsolutePath)

        'Javascript laden
        LaadJavaScript()

        'Tooltips laden
        LaadTooltips()

        'Templates en dropdowns laden
        If Not IsPostBack Then
            LaadCategorien()
            LaadTemplates()
        End If
    End Sub

    Private Sub LaadCategorien()

        Me.ddlVersie.Items.Clear()
        For Each v As Versie In Versie.GetVersies
            ddlVersie.Items.Add(New ListItem(v.VersieNaam, v.ID))
        Next

        Me.ddlTaal.Items.Clear()
        For Each taal As Taal In taal.GetTalen
            ddlTaal.Items.Add(New ListItem(taal.TaalNaam, taal.ID))
        Next

        Me.ddlBedrijf.Items.Clear()
        For Each b As Bedrijf In Bedrijf.GetBedrijven
            ddlBedrijf.Items.Add(New ListItem(b.Naam, b.ID))
        Next

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

    Private Sub LaadJavaScript()
        'De opslaanknop op disabled zetten als erop geklikt wordt
        JavaScript.ZetButtonOpDisabledOnClick(btnVoegtoe, "Opslaan...", )
        JavaScript.ZetButtonOpDisabledOnClick(btnSjablonen, "Bezig met toevoegen..", True, True)
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
        lijst.Add(New Tooltip("tipTagArtikelToevoegen"))
        lijst.Add(New Tooltip("tipTitelArtikelToevoegen"))
        lijst.Add(New Tooltip("tipTaalArtikelToevoegen"))
        lijst.Add(New Tooltip("tipBedrijfArtikelToevoegen"))
        lijst.Add(New Tooltip("tipVersieArtikelToevoegen"))
        lijst.Add(New Tooltip("tipCategorieArtikelToevoegen"))
        lijst.Add(New Tooltip("tipFinaalArtikelToevoegen"))
        lijst.Add(New Tooltip("tipSjabloonArtikelToevoegen"))

        'Tooltips op de pagina zetten via scriptmanager als het een postback is, anders gewoon in de onload functie van de body.
        If Page.IsPostBack Then
            Tooltip.VoegTipToeAanEndRequest(Me, lijst)
        Else
            Dim body As HtmlGenericControl = Master.FindControl("MasterBody")
            Tooltip.VoegTipToeAanBody(body, lijst)
        End If

    End Sub

    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegtoe.Click
        Dim artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties

        Dim tekst As String = EditorToevoegen.Value
        Dim tag As String = txtTag.Text.Trim
        Dim titel As String = txtTitel.Text.Trim

        Dim FK_versie As Integer = ddlVersie.SelectedValue
        Dim FK_Bedrijf As Integer = ddlBedrijf.SelectedValue
        Dim FK_categorie As Integer = ddlCategorie.SelectedValue
        Dim FK_taal As Integer = ddlTaal.SelectedValue

        tag = String.Concat(Taal.GetTaal(FK_taal).TaalNaam, "_", tag)

        Dim finaal As Integer
        If ckbFinaal.Checked = True Then
            finaal = 1
        Else
            finaal = 0
        End If

        'Checken of een ander artikel niet al dezelfde naam heeft
        If artikeldal.checkArtikelByTitel(titel, FK_Bedrijf, FK_versie, FK_taal) IsNot Nothing Then
            Util.SetError("Toevoegen Mislukt: Er bestaat reeds een artikel met deze titel in deze structuur.", lblresultaat, imgResultaat)
            divFeedback.Visible = True
            divNogEenArtikelToevoegen.Visible = False
            Return
        End If

        'Checken of een ander artikel niet dezelfde tag heeft
        If artikeldal.GetArtikelByTag(tag) IsNot Nothing Then
            Util.SetWarn("Toevoegen Mislukt: Er bestaat reeds een artikel met deze tag.", lblresultaat, imgResultaat)
            divFeedback.Visible = True
            divNogEenArtikelToevoegen.Visible = False
            Return
        End If

        Dim insertGelukt As Boolean = artikeldal.StdAdapter.Insert(titel, FK_categorie, FK_taal, FK_Bedrijf, FK_versie, tekst, tag, finaal)
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
                divNogEenArtikelToevoegen.Visible = True
            Else
                Util.SetWarn(String.Concat("Toevoegen Geslaagd met waarschuwing: ", boodschap), lblresultaat, imgResultaat)
                Me.btnVoegtoe.Visible = False
                divNogEenArtikelToevoegen.Visible = True
            End If

        Else
            Util.SetError("Toevoegen Mislukt: Kon niet verbinden met de database.", lblresultaat, imgResultaat)
            divNogEenArtikelToevoegen.Visible = False
        End If

        divFeedback.Visible = True

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

    Protected Sub btnSjablonen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSjablonen.Click
        If lstSjablonen.SelectedItem IsNot Nothing Then
            If Not lstSjablonen.SelectedItem.Text = String.Empty Then

                Dim template As String = lstSjablonen.SelectedItem.Text
                Dim x As New XML(String.Concat(Server.MapPath("~/Templates/"), template, ".xml"), String.Concat(Server.MapPath("~/Templates/"), template, ".xsl"))
                EditorToevoegen.Value = String.Concat(EditorToevoegen.Value, XML.LeesXMLFile(x))

            End If
        End If
    End Sub

End Class
