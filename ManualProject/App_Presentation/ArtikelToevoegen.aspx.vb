Imports Manual
Imports System.Diagnostics

Partial Class App_Presentation_invoerenTest
    Inherits System.Web.UI.Page

    Private artikel As Manual.tblArtikelRow
    Private adap As New ManualTableAdapters.tblArtikelTableAdapter
    Private bedrijfIsKlaar As Boolean = False
    Private versieIsKlaar As Boolean = False
    Private taalIsKlaar As Boolean = False
    Private xml As New iksemel

    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegtoe.Click

        Dim tekst As String = Editor1.Content
        Dim tag As String = txtTag.Text.Trim
        Dim titel As String = txtTitel.Text.Trim

        Dim FK_versie As Integer = ddlVersie.SelectedValue
        Dim FK_Bedrijf As Integer = ddlBedrijf.SelectedValue
        Dim FK_categorie As Integer = ddlCategorie.SelectedValue
        Dim FK_taal As Integer = ddlTaal.SelectedValue

        Dim finaal As Integer
        If ckbFinaal.Checked = True Then
            finaal = 1
        Else
            finaal = 0
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
                lblresultaat.Text = "Toevoegen Geslaagd."
                lblresultaat.ForeColor = System.Drawing.ColorTranslator.FromHtml("#86CC7C")
                imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\tick.gif"
                Me.btnVoegtoe.Visible = False
            Else
                lblresultaat.Text = String.Concat("Toevoegen Geslaagd met waarschuwing: ", boodschap)
                lblresultaat.ForeColor = System.Drawing.ColorTranslator.FromHtml("#EAB600")
                imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\warning.png"
                Me.btnVoegtoe.Visible = False
            End If

        Else
            lblresultaat.Text = "Toevoegen Mislukt: Kon niet verbinden met de database."
            lblresultaat.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E3401E")
            imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\remove.png"
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
        Me.ddlCategorie.DataSource = DatabaseLink.GetInstance.GetCategorieFuncties.GetAllCategorieBy(Me.ddlTaal.SelectedValue, Me.ddlBedrijf.SelectedValue, Me.ddlVersie.SelectedValue)
        Me.ddlCategorie.DataBind()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.Title = "Artikel Toevoegen"

        'De opslaanknop op disabled zetten als erop geklikt wordt
        JavaScript.ZetButtonOpDisabledOnClick(btnVoegtoe, "Opslaan...", )

        LaadTooltips()

        If Not IsPostBack Then
            Editor1.Content = xml.alles
        End If

        If Session("login") = 1 Then
            divLoggedIn.Visible = True
        Else
            divLoggedIn.Visible = False
            lblLogin.Visible = True
            lblLogin.Text = "U bent niet ingelogd."
            ImageButton1.Visible = True
        End If

    End Sub

    Private Sub LaadTooltips()

        'Nieuwe lijst van tooltips definiëren
        Dim lijst As New List(Of Tooltip)

        'Alle tooltips voor onze pagina toevoegen
        lijst.Add(New Tooltip("tipTag", "De <b>unieke</b> tag van het nieuwe artikel. Mag enkel letters, nummers en een underscore ( _ ) bevatten."))
        lijst.Add(New Tooltip("tipTitel", "De titel van het nieuwe artikel."))
        lijst.Add(New Tooltip("tipTaal", "De taal van het nieuwe artikel."))
        lijst.Add(New Tooltip("tipBedrijf", "Het bedrijf waaronder dit artikel zal worden gepubliceerd."))
        lijst.Add(New Tooltip("tipVersie", "De versie waartoe het nieuwe artikel toebehoort. Dit nummer slaat op de versie van de applicatie, en niet op de versie van het artikel."))
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
        lblFile.Text = ""
        If FileUpload1.HasFile Then
            Dim fileextension As String
            fileextension = System.IO.Path.GetExtension(FileUpload1.FileName)
            If fileextension = ".jpg" Or fileextension = ".png" Or fileextension = ".gif" Then
                Dim tekst As String
                Dim htmltekst As String
                tekst = FileUpload1.FileName
                htmltekst = "<img src=""CSS/images/" + FileUpload1.FileName + """ style=""width: 400px; height: 300px;"" />"
                Dim loc As Integer
                loc = Editor1.Content.Length
                Dim content As String
                content = Editor1.Content
                content = content + "<br />" + htmltekst
                Editor1.Content = content
                FileUpload1.SaveAs("C:/ReferenceManual/App_Presentation/CSS/Images/" + FileUpload1.FileName)
            Else
                lblFile.ForeColor = Drawing.Color.Red
                lblFile.Text = "U kan enkel Jpg, png of gif afbeeldingen in u artikel gebruiken."
            End If
        Else
            lblFile.ForeColor = Drawing.Color.Red
            lblFile.Text = "U hebt geen afbeelding geselecteerd."
        End If
    End Sub

    Protected Sub ImageButton1_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton1.Click
        Response.Redirect("Aanmeldpagina.aspx")
    End Sub
End Class
