Imports System.Web.HttpUtility


Partial Class App_Presentation_verwijderenTekst
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.Title = "Artikel Verwijderen"
        Util.CheckOfBeheerder(Page.Request.Url.AbsolutePath)

        If Not Request.UrlReferrer Is Nothing Then
            Dim vorige As String = Request.UrlReferrer.LocalPath
            If vorige = "/ReferenceManual/App_Presentation/AlleArtikels.aspx" Then
                Session("alleArtikels") = vorige
            End If
        End If
        LaadJavaScript()
        LaadTooltips()

        If Not IsPostBack Then
            LaadDropdowns()
        End If

    End Sub

    Private Sub LaadTooltips()

        'Nieuwe lijst van tooltips definiëren
        Dim lijst As New List(Of Tooltip)

        'Alle tooltips voor onze pagina toevoegen
        lijst.Add(New Tooltip("tipZoekTitelVerwijderen"))
        lijst.Add(New Tooltip("tipZoekTagVerwijderen"))
        lijst.Add(New Tooltip("tipTaalKeuze"))
        lijst.Add(New Tooltip("tipBedrijfKeuze"))
        lijst.Add(New Tooltip("tipVersieKeuze"))
        lijst.Add(New Tooltip("tipIsFinaalKeuze"))
        Util.TooltipsToevoegen(Me, lijst)

    End Sub

    Private Sub LaadJavaScript()

        JavaScript.ZetButtonOpDisabledOnClick(btnZoek, "Laden...", True)
        JavaScript.ZetButtonOpDisabledOnClick(btnAnnuleer, "Annuleren...", True)
        JavaScript.ZetButtonOpDisabledOnClick(btnOK, "Verwijderen...")

    End Sub

    Private Sub LaadDropdowns()

        ddlBedrijf.Items.Clear()
        ddlBedrijf.Items.Add(New ListItem("Alles", "-1000"))
        For Each b As Bedrijf In Bedrijf.GetBedrijven
            ddlBedrijf.Items.Add(New ListItem(b.Naam, b.ID))
        Next b

        ddlVersie.Items.Clear()
        ddlVersie.Items.Add(New ListItem("Alles", "-1000"))
        For Each v As Versie In Versie.GetVersies
            ddlVersie.Items.Add(New ListItem(v.VersieNaam, v.ID))
        Next v

        ddlTaal.Items.Clear()
        ddlTaal.Items.Add(New ListItem("Alles", "-1000"))
        For Each t As Taal In Taal.GetTalen
            ddlTaal.Items.Add(New ListItem(t.TaalNaam, t.ID))
        Next t

        ddlIsFInaal.Items.Clear()
        ddlIsFInaal.Items.Add(New ListItem("Alles", "-1000"))
        ddlIsFInaal.Items.Add(New ListItem("Ja", "1"))
        ddlIsFInaal.Items.Add(New ListItem("Nee", "0"))

    End Sub

    Sub ValideerZoekTerm(ByVal sender As Object, ByVal args As ServerValidateEventArgs)
        ' Default Value
        args.IsValid = True

        Dim resultaten As String = String.Concat(Me.txtSearchTag.Text, Me.txtSearchTitel.Text)

        If resultaten = String.Empty Then
            args.IsValid = False
        End If
    End Sub

    Protected Sub btnZoek_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoek.Click
        HaalArtikelGegevensOp()
        'JavaScript.VoegJavascriptToeAanEndRequest(Me, "Effect.toggle('gridview', 'slide');")
    End Sub

    Private Sub HaalArtikelGegevensOp()

        Dim zoekTitel As String = txtSearchTitel.Text.Trim
        Dim zoekTag As String = txtSearchTag.Text.Trim

        'Dropdownwaardes ophalen
        Dim versies As String = Util.DropdownUitlezen(ddlVersie)
        Dim bedrijven As String = Util.DropdownUitlezen(ddlBedrijf)
        Dim talen As String = Util.DropdownUitlezen(ddlTaal)
        Dim isFInaal As String = Util.DropdownUitlezen(ddlIsFInaal)

        Dim dt As New Data.DataTable

        If zoekTitel.Length > 0 Then

            Dim zoekTekst As String = String.Concat("""*", zoekTitel, "*""")
            zoekTitel = String.Concat("%", zoekTitel, "%")
            Dim dttitel As Data.DataTable = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelGegevensByTitel(zoekTitel, isFInaal, versies, bedrijven, talen)
            Dim dttekst As Data.DataTable = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelGegevensByTekst(zoekTekst, isFInaal, versies, bedrijven, talen)

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
            dt = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelGegevensByTag(zoekTag, isFInaal, versies, bedrijven, talen)
        End If

        grdResultaten.DataSource = dt
        grdResultaten.DataBind()

        Me.grdResultaten.Style.Item("display") = "inline"
        Me.lblSelecteerArtikel.Style.Item("display") = "inline"

        If Me.grdResultaten.Rows.Count = 0 Then
            Me.lblSelecteerArtikel.Text = "Er werden geen artikels gevonden."
        Else
            Me.lblSelecteerArtikel.Text = "Selecteer een artikel om te verwijderen."
        End If

        Me.divFeedback.Style.Item("display") = "none"
    End Sub

    Protected Sub grdResultaten_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdResultaten.RowCommand
        If e.CommandName = "Select" Then

            Dim row As GridViewRow = Me.grdResultaten.Rows(e.CommandArgument)
            hdnRowID.Value = e.CommandArgument.ToString

            lblArtikeltitel.Text = row.Cells(0).Text
            updConfirmatie.Update()

            HaalArtikelGegevensOp()
            'sJavaScript.VoegJavascriptToeAanEndRequest(Me, "document.getElementById('gridview').style.display = 'inline';")

            mpeConfirmatie.Show()

        End If


    End Sub

    Protected Sub grdResultaten_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdResultaten.RowDataBound
        Dim row As GridViewRow = e.Row

        If row.Cells.Count > 1 Then

            row.Cells(0).Text = HtmlDecode(row.Cells(0).Text)

            If row.Cells(5).Text = "1" Then
                row.Cells(5).Text = "Ja"
            ElseIf row.Cells(5).Text = "0" Then
                row.Cells(5).Text = "Nee"
            End If

        End If

    End Sub

    Private Sub VerwijderArtikel(ByRef row As GridViewRow)

        Dim artikeltag As String = row.Cells(1).Text
        Dim artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties

        'Artikel ophalen en in object opslaan
        Dim artikel As New Artikel(artikeldal.GetArtikelByTag(artikeltag))

        'Artikel verwijderen uit database
        If artikeldal.verwijderArtikel(artikel.ID) = True Then

            'Artikel verwijderen uit de boomstructuur
            'We halen de tree op waar dit artikel in werd opgeslagen
            Dim tree As Tree = tree.GetTree(artikel.Taal, artikel.Versie, artikel.Bedrijf)

            Dim node As Node = tree.DoorzoekTreeVoorNode(artikel.ID, Global.ContentType.Artikel)

            If (node Is Nothing) Then
                Util.SetWarn("Verwijderen geslaagd met waarschuwing: Het artikel komt niet voor in de boomstructuur. Herbouw de boomstructuur als u klaar bent met wijzigingen door te voeren.", lblResultaat, imgResultaat)
                HaalArtikelGegevensOp()
                Return
            End If

            Dim parent As Node = tree.VindParentVanNode(node)

            If (parent Is Nothing) Then
                Util.SetWarn("Verwijderen geslaagd met waarschuwing: Het artikel staat niet onder een categorie in de boomstructuur. Herbouw de boomstructuur als u klaar bent met wijzigingen door te voeren.", lblResultaat, imgResultaat)
                HaalArtikelGegevensOp()
                Return
            End If

            parent.VerwijderKind(node)
            Util.SetOK("Verwijderen Geslaagd.", lblResultaat, imgResultaat)
        Else
            Util.SetError("Verwijderen mislukt: Kon niet verbinden met de database.", lblResultaat, imgResultaat)
        End If

        HaalArtikelGegevensOp()
        Me.divFeedback.Style.Item("display") = "inline"

    End Sub

    Protected Sub btnOK_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOK.Click

        If Session("rechtstreeksVerwijderen") IsNot Nothing Then
            If Session("rechtstreeksVerwijderen") = 1 Then
                Dim tag As String = Session("tag")
                VerwijderArtikel(tag)
                Session("rechtstreeksVerwijderen") = Nothing
                Session("tag") = Nothing
                Response.Redirect("~/App_Presentation/AlleArtikels.aspx")
            End If
        Else
            Dim row As GridViewRow = grdResultaten.Rows(hdnRowID.Value)
            VerwijderArtikel(row)
        End If

        HaalArtikelGegevensOp()
        'JavaScript.VoegJavascriptToeAanEndRequest(Me, "document.getElementById('gridview').style.display = 'inline';")
    End Sub

    Protected Sub btnAnnuleer_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAnnuleer.Click
        HaalArtikelGegevensOp()
        JavaScript.VoegJavascriptToeAanEndRequest(Me, "document.getElementById('gridview').style.display = 'inline';")
        mpeConfirmatie.Hide()
        Dim str As String = Session("alleArtikels")
        If str = "/ReferenceManual/App_Presentation/AlleArtikels.aspx" Then
            Response.Redirect("AlleArtikels.aspx")
        End If
    End Sub
    Private Sub VerwijderArtikel(ByVal tag As String)
        Dim artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties

        'Artikel ophalen en in object opslaan
        Dim artikel As New Artikel(artikeldal.GetArtikelByTag(tag))

        'Artikel verwijderen uit database
        If artikeldal.verwijderArtikel(artikel.ID) = True Then

            'Artikel verwijderen uit de boomstructuur
            'We halen de tree op waar dit artikel in werd opgeslagen
            Dim tree As Tree = tree.GetTree(artikel.Taal, artikel.Versie, artikel.Bedrijf)

            Dim node As Node = tree.DoorzoekTreeVoorNode(artikel.ID, Global.ContentType.Artikel)

            If (node Is Nothing) Then
                Util.SetWarn("Verwijderen geslaagd met waarschuwing: Het artikel komt niet voor in de boomstructuur. Herbouw de boomstructuur als u klaar bent met wijzigingen door te voeren.", lblResultaat, imgResultaat)
                HaalArtikelGegevensOp()
                Return
            End If

            Dim parent As Node = tree.VindParentVanNode(node)

            If (parent Is Nothing) Then
                Util.SetWarn("Verwijderen geslaagd met waarschuwing: Het artikel staat niet onder een categorie in de boomstructuur. Herbouw de boomstructuur als u klaar bent met wijzigingen door te voeren.", lblResultaat, imgResultaat)
                HaalArtikelGegevensOp()
                Return
            End If

            parent.VerwijderKind(node)
            Util.SetOK("Verwijderen Geslaagd.", lblResultaat, imgResultaat)
            Dim str As String = "Verwijderen geslaagd"
            'MsgBox(str, MsgBoxStyle.OkOnly)
        Else
            Util.SetError("Verwijderen mislukt: Kon niet verbinden met de database.", lblResultaat, imgResultaat)
        End If

        HaalArtikelGegevensOp()
        Me.divFeedback.Style.Item("display") = "inline"
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        If Request.QueryString("tag") IsNot Nothing Then
            Session("tag") = Request.QueryString("tag")
            Session("rechtstreeksVerwijderen") = 1
            If Not IsPostBack Then
                mpeConfirmatie.Show()
            End If
        End If
    End Sub
End Class

