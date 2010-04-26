
Partial Class App_Presentation_MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Nakijken of gebruiker deze pagina wel mag zien
        CheckOfIngelogd()

        'Kijk na of de boomstructuren en dergelijke ingeladen zijn in het geheugen
        CheckDataStructures()

        'Nakijken of er een taalwijziging is aangevraagd
        CheckVoorTaalWijziging()

        'Rest van Masterpagecontent genereren
        GenereerContent()
        'txtZoek.Attributes.Add("onkeyup", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('ctl00_lnkZoeken').click();return false;}} else {SetButtonStatus(this);} ")
    End Sub

    Private Sub CheckOfIngelogd()
        If Session("isIngelogd") Is Nothing Or Session("isIngelogd") = False Then
            Session("vorigePagina") = Page.Request.Url.AbsolutePath
            Response.Redirect("~/Default.aspx")
        End If
    End Sub

    Private Sub CheckDataStructures()

        If (Tree.GetTrees() Is Nothing) Then
            Tree.BouwTrees()
        End If

        If (Bedrijf.GetBedrijven() Is Nothing) Then
            Bedrijf.BouwBedrijfLijst()
        End If

        If (Taal.GetTalen() Is Nothing) Then
            Taal.BouwTaalLijst()
        End If

        If (Versie.GetVersies() Is Nothing) Then
            Versie.BouwVersieLijst()
        End If

        If (XML.GetToolTips() Is Nothing) Then
            XML.ParseTooltips()
        End If

        If (Lokalisatie.Talen() Is Nothing) Then
            Lokalisatie.ParseLocalisatieStrings()
        End If

    End Sub

    Public Sub CheckVoorTaalWijziging()

        Dim control As String = Page.Request.Params.Get("__EVENTTARGET")
        Dim arg As String = Page.Request.Params.Get("__EVENTARGUMENT")

        If control IsNot Nothing And arg IsNot Nothing Then
            If control.Contains("lnkTaal") Then
                Session("taal") = Integer.Parse(arg)
            End If
        End If

    End Sub

    Private Sub GenereerContent()

        'Bepaalde content verstoppen
        VerstopContent()

        'Gelokaliseerde tekst genereren
        GenereerGelokaliseerdeTekst()

        'Variabelen in de header initialiseren (nodig voor zijbalk)
        Page.Header.DataBind()

        'Zijbalk genereren
        GenereerZijbalk()

        'Links dynamisch populeren
        PopuleerLinks()

        'JavaScript laden
        LaadJavascript()

    End Sub

#Region "Contentgeneratie"

    Private Sub VerstopContent()
        If Session("login") = 0 Then
            liBeheer.Visible = False
            liArtikelBeheer.Visible = False
            liArtikelBewerken.Visible = False
            ulBeheer.visible = False
        End If

        If Session("login") = 1 Then
            liAanmeld.Visible = False
        End If
    End Sub

    Private Sub LaadJavascript()
        If MasterBody.Attributes.Item("onload") Is Nothing Then
            MasterBody.Attributes.Add("onload", String.Concat("SetButtonStatus(document.getElementById('", txtZoek.ClientID, "')); "))
        Else
            MasterBody.Attributes.Item("onload") = String.Concat(MasterBody.Attributes.Item("onload"), "SetButtonStatus(document.getElementById('", txtZoek.ClientID, "')); ")
        End If
    End Sub

    Private Sub GenereerGelokaliseerdeTekst()
        divCategorienTekst.InnerHtml = Lokalisatie.GetString("CATEGORIEN")
        lblZoek.Text = Lokalisatie.GetString("ZOEKENOP")
        spanBeheer.InnerText = Lokalisatie.GetString("BEHEER")
        spanBeheerAanmeld.InnerHtml = Lokalisatie.GetString("BEHEER")
        spanTalen.InnerHtml = Lokalisatie.GetString("TALEN")
    End Sub

    Private Sub GenereerZijbalk()
        'Taal ophalen
        Dim taalID As Integer = Session("taal")

        'Versie ophalen
        Dim versieID As Integer = Session("versie")

        'Bedrijven ophalen

        'De Appligen-structuur krijgen we altijd te zien
        Dim appligen As Bedrijf = Bedrijf.GetBedrijf("AAAFinancials")

        Dim anderBedrijfID As Integer
        'Kijken of we een geldige bedrijftag hadden binnengekregen
        If Not Session("bedrijf") = -1000 Then
            anderBedrijfID = Session("bedrijf")
            'Even checken of het geldige bedrijf dat we hebben binnengekregen niet nog eens Appligen is
            If appligen.ID = anderBedrijfID Then
                anderBedrijfID = -1000
            End If
        Else
            anderBedrijfID = -1000
        End If

        'Lijststructuren genereren voor bedrijven
        Dim htmlcode As String = String.Empty

        'Appligen-structuur genereren
        htmlcode = Genereerstructuur(taalID, versieID, appligen.ID, htmlcode)

        'Ander bedrijf genereren
        If Not anderBedrijfID = -1000 Then
            htmlcode = Genereerstructuur(taalID, versieID, anderBedrijfID, htmlcode)
        End If

        'HTML-code in de linkerzijbalk plaatsen
        Dim boomdiv As HtmlGenericControl = Me.FindControl("divBoomStructuur")
        boomdiv.InnerHtml = htmlcode
    End Sub

    Private Sub GenereerTaalkeuze()
        Dim split() As String = Page.AppRelativeVirtualPath.Split("/")
        Dim pagina As String = split(split.Length - 1)

        If pagina = "page.aspx" Then
            pagina = "Default.aspx"
        End If

        Dim code As String = String.Empty
        For Each t As Taal In Taal.GetTalen
            If t.ID = Session("taal") Then
                code = String.Concat(code, "<li><a href=""#""""><STRONG>", t.TaalNaam, "</STRONG></a></li>")
            Else
                code = String.Concat(code, "<li><a id=""ctl00_lnkTaal", t.ID.ToString, """ href=""javascript:WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions(&quot;ctl00$lnkTaal", t.ID.ToString, "&quot;,&quot;", t.ID.ToString, "&quot;, false, &quot;&quot;, &quot;", pagina, "&quot;, false, true))""""" + ">", t.TaalNaam, "</a></li>")
            End If
        Next

        Dim ul As HtmlGenericControl = Me.FindControl("ulTalen")
        ul.InnerHtml = code
    End Sub

    Private Sub PopuleerLinks()

        ArtikelToevoegen.HRef = "~/App_Presentation/ArtikelToevoegen.aspx"
        ArtikelBewerken.HRef = "~/App_Presentation/ArtikelBewerken.aspx"
        ArtikelVerwijderen.HRef = "~/App_Presentation/ArtikelVerwijderen.aspx"

        GenereerTaalkeuze()
    End Sub

    Private Function Genereerstructuur(ByVal taal As Integer, ByVal versie As Integer, ByVal bedrijf As Integer, ByRef html As String) As String

        Dim t As Tree = Tree.GetTree(taal, versie, bedrijf)
        Dim root As Node = t.RootNode

        Dim oudehtml As String = html
        html = String.Concat(oudehtml, "<br/><div><strong>", t.Bedrijf.Naam, "</strong></div>")
        Dim originelehtml As String = String.Concat(oudehtml, "<br/><div><strong>", t.Bedrijf.Naam, "</strong></div>")

        html = t.BeginNieuweLijst(html, root, -1)
        If html = originelehtml Then html = String.Concat(html, Lokalisatie.GetString("GEENCATEGORIEN"))

        Return html
    End Function

    Protected Function GenereerLaadTekst() As String
        Return Lokalisatie.GetString("LAADSCHERMTEKST")
    End Function

#End Region
End Class

