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
            ddlModule.DataBind()
            LaadDropdowns()
            LaadTemplates()

            If Page.Request.QueryString("tag") IsNot Nothing And Page.Request.QueryString("versie") IsNot Nothing And Page.Request.QueryString("bedrijf") IsNot Nothing And Page.Request.QueryString("taal") IsNot Nothing Then
                txtTag.Text = Page.Request.QueryString("tag")
                Dim dr As Manual.tblTaalRow = taaldal.getTaalByNaam(Page.Request.QueryString("taal"))
                Dim taalid As Integer = dr("taalID")
                ddlTaal.SelectedValue = taalid
                Dim strtag() As String = Split(ddlTaal.SelectedItem.Text, "-")
                strtag(1) = Trim(strtag(1))
                lblTaalTag.InnerHtml = strtag(1)
                ddlVersie.SelectedValue = Page.Request.QueryString("versie")
                ddlBedrijf.SelectedValue = Page.Request.QueryString("bedrijf")

                lblTagvoorbeeld.InnerHtml = ddlVersie.SelectedItem.Text + "_" + lblTaalTag.InnerHtml + "_" + ddlBedrijf.SelectedItem.Text + "_" + ddlModule.SelectedItem.Text + "_" + txtTag.Text

            End If
        Else
            lblTagvoorbeeld.InnerHtml = ddlVersie.SelectedItem.Text + "_" + lblTaalTag.InnerHtml + "_" + ddlBedrijf.SelectedItem.Text + "_" + ddlModule.SelectedItem.Text + "_" + txtTag.Text
        End If

    End Sub

    Private Sub LaadDropdowns()

        Util.LeesVersies(ddlVersie)
        'Util.LeesTalen(ddlTaal)
        Util.LeesBedrijven(ddlBedrijf)

        Me.ddlTaal.Items.Clear()
        For Each taal As Taal In taal.GetTalen
            ddlTaal.Items.Add(New ListItem(taal.TaalNaam + " - " + taal.TaalTag, taal.ID))
        Next

        LaadCategorien()

    End Sub

    Private Sub LaadCategorien()

        Dim strtag() As String = Split(ddlTaal.SelectedItem.Text, "-")
        strtag(1) = Trim(strtag(1))
        lblTaalTag.InnerHtml = strtag(1)
        lblTagvoorbeeld.InnerHtml = ddlVersie.SelectedItem.Text + "_" + strtag(1) + "_" + ddlBedrijf.SelectedItem.Text + "_" + ddlModule.SelectedItem.Text + "_" + txtTag.Text

        Dim t As Tree = Tree.GetTree(Me.ddlTaal.SelectedValue, Me.ddlVersie.SelectedValue, Me.ddlBedrijf.SelectedValue)
        Util.LeesCategorien(ddlCategorie, t)

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
        JavaScript.ZetButtonOpDisabledOnClick(btnSjablonen, "Bezig met toevoegen..", True)
    End Sub

    Private Sub LaadTemplates()
        XML.GetTemplates(lstSjablonen)
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
        Util.TooltipsToevoegen(Me, lijst)

    End Sub

    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegtoe.Click
        Dim checken() As WebControl = {txtTag, txtTitel, ddlCategorie, ddlBedrijf, ddlModule, ddlTaal, ddlVersie}

        If Util.Valideer(checken) Then
            Dim artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties

            Dim tekst As String = EditorToevoegen.Value
            Dim tag As String = txtTag.Text.Trim
            Dim titel As String = txtTitel.Text.Trim

            Dim FK_versie As Integer = ddlVersie.SelectedValue
            Dim FK_Bedrijf As Integer = ddlBedrijf.SelectedValue
            Dim FK_categorie As Integer = ddlCategorie.SelectedValue
            Dim FK_taal As Integer = ddlTaal.SelectedValue
            Dim str As String = lblTagvoorbeeld.InnerHtml
            tag = str
            Dim finaal As Integer
            If ckbFinaal.Checked = True Then
                finaal = 1
            Else
                finaal = 0
            End If

            'Checken of een ander artikel niet al dezelfde naam heeft
            If artikeldal.checkArtikelByTitel(titel, FK_Bedrijf, FK_versie, FK_taal).Count > 0 Then
                Util.SetError("Toevoegen Mislukt: Er bestaat reeds een artikel met deze titel in deze structuur.", lblresultaat, imgResultaat)
                divFeedback.Visible = True
                divNogEenArtikelToevoegen.Visible = False
                Return
            End If
            'Checken of een ander artikel niet dezelfde tag heeft
            If artikeldal.checkArtikelByTag(tag, FK_Bedrijf, FK_versie, FK_taal).Count > 0 Then
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
        Else
            Util.SetError("Gelieve alle velden in te vullen.", lblresultaat, imgResultaat)
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

    Protected Sub btnSjablonen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSjablonen.Click
        If lstSjablonen.SelectedItem IsNot Nothing Then
            If Not lstSjablonen.SelectedItem.Text = String.Empty Then

                Dim template As String = lstSjablonen.SelectedItem.Text
                Dim x As New XML(String.Concat(Server.MapPath("~/Templates/"), template, ".xml"), String.Concat(Server.MapPath("~/Templates/"), template, ".xsl"))
                EditorToevoegen.Value = String.Concat(EditorToevoegen.Value, XML.LeesXMLFile(x))

            End If
        End If
    End Sub

    Protected Sub ddlModule_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlModule.SelectedIndexChanged
        Dim strtag() As String = Split(ddlTaal.SelectedItem.Text, "-")
        strtag(1) = Trim(strtag(1))
        lblTaalTag.InnerHtml = strtag(1)
        lblTagvoorbeeld.InnerHtml = ddlVersie.SelectedItem.Text + "_" + strtag(1) + "_" + ddlBedrijf.SelectedItem.Text + "_" + ddlModule.SelectedItem.Text + "_" + txtTag.Text

    End Sub
End Class
