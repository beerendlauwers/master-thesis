
Partial Class App_Presentation_verwijderenTekst
    Inherits System.Web.UI.Page
    
    Protected Sub btnZoek_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoek.Click
        Dim titel As String = txtSearchTitel.Text.Trim
        Dim tekst As String = txtSearchText.Text.Trim

        If titel.Length > 0 Then
            titel = "%" + txtSearchTitel.Text + "%"
            grdResultaten.DataSource = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelGegevensByTitel(titel)
            grdResultaten.DataBind()
            Me.grdResultaten.Visible = True
            Me.lblSelecteerArtikel.Visible = True
        ElseIf tekst.Length > 0 Then
            tekst = """*" + txtSearchText.Text + "*"""
            grdResultaten.DataSource = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelGegevensByTekst(tekst)
            grdResultaten.DataBind()
            Me.grdResultaten.Visible = True
            Me.lblSelecteerArtikel.Visible = True
        End If

        If Me.grdResultaten.Rows.Count = 0 Then
            Me.lblSelecteerArtikel.Text = "Er werden geen artikels gevonden."
        Else
            Me.lblSelecteerArtikel.Text = "Selecteer een artikel om te verwijderen."
        End If

    End Sub

    Public Function zoektext(ByVal text As String, ByVal str As String) As Boolean
        Dim stri As String = str
        Dim txt As String = text
        Dim reeks(50) As String
        Dim teller As Integer
        Dim test As String = " "
        reeks(0) = test
        For t As Integer = 0 To stri.Length()
            reeks = text.Split(" ")
            teller = teller + 1
        Next
        Dim teller1 As Integer = reeks.Length - 1
        For t As Integer = 0 To teller1 - 1
            test = test + reeks(t)
        Next
        'lblWut.Text = test
        'Dim re1 As String = ".*?" 'Non-greedy match on filler
        'Dim re2 As String = reeks(0)   'Word 1
        'Dim re3 As String = "( )" 'White Space 1
        'Dim re4 As String = reeks(1)    'Word 2
        'Dim re5 As String = "( )" 'White Space 2
        'Dim re6 As String = reeks(2)   'Word 3
        'Dim re7 As String = "( )" 'White Space 3
        'Dim re8 As String = reeks(3)  'Word 4
        'Dim re9 As String = "(!)" 'Any Single Character 1

        'Dim r As Regex = New Regex(re1 + re2 + re3 + re4 + re5 + re6 + re7 + re8 + re9, RegexOptions.IgnoreCase Or RegexOptions.Singleline)
        'Dim m As Match = r.Match(txt)
        'If (m.Success) Then
        '    lblWut.Text = str
        '    Return True
        'Else
        '    Return False
        'End If
        Return True
    End Function

    Protected Sub grdResultaten_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdResultaten.RowCommand
        If e.CommandName = "Select" Then

            Dim row As GridViewRow = Me.grdResultaten.Rows(e.CommandArgument)

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
                    Me.lblRes.Text = "Verwijderen geslaagd met waarschuwing: Het artikel komt niet voor in de boomstructuur. Herbouw de boomstructuur als u klaar bent met wijzigingen door te voeren."
                    Return
                End If

                Dim parent As Node = tree.VindParentVanNode(node)

                If (parent Is Nothing) Then
                    Me.lblRes.Text = "Verwijderen geslaagd met waarschuwing: Het artikel staat niet onder een categorie in de boomstructuur. Herbouw de boomstructuur als u klaar bent met wijzigingen door te voeren."
                    Return
                End If

                parent.VerwijderKind(node)

                Me.lblRes.Text = "Verwijderen geslaagd."
            Else
                Me.lblRes.Text = "Verwijderen mislukt: Kon niet verbinden met de database."
            End If

            Me.grdResultaten.DataBind()

            Dim javascript As String = String.Concat("function verwijderKind_", artikel.ID, "() { document.getElementById(child_", artikel.ID, ").style.display = ""none""; }")

            Page.ClientScript.RegisterStartupScript(Me.GetType(), String.Concat("verwijderKind_", artikel.ID), javascript, True)

            Dim body As HtmlGenericControl = Master.FindControl("MasterBody")
            body.Attributes.Add("onload", String.Concat("verwijderKind_", artikel.ID, "();"))

        End If
    End Sub
End Class

