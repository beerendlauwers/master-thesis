Imports Manual

Partial Class App_Presentation_page
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Titel bepalen
        Page.Title = "Ongeldig Artikel"

        'Querystring checken op geldigheid
        Dim geldigeTag As Boolean = True
        Dim geldigID As Boolean = True

        If (Page.Request.Form.Count = 0) Then
            Me.lblTitel.Text = "Ongeldig artikel."
            geldigeTag = False
        Else
            If (TryCast(Page.Request.Form(0), String) Is Nothing) Then
                Me.lblTitel.Text = "Ongeldig artikel."
                geldigeTag = False
            End If
        End If

        
        If (Page.Request.Form.Count = 0) Then
            Me.lblTitel.Text = "Ongeldig artikel."
            geldigID = False
        End If

        If (Not IsNumeric(Page.Request.Form)) Then
            Me.lblTitel.Text = "Ongeldig artikel."
            geldigID = False
        End If

        'Artikel ophalen op basis van ID of Tag
        If (geldigID Or geldigeTag) Then

            Dim row As tblArtikelRow

            If (geldigeTag) Then
                Dim tag As String = Page.Request.Form(0)
                tag = tag.Trim

                If tag = String.Empty Then
                    Me.lblTitel.Text = "Ongeldig artikel."
                    Return
                End If

                row = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelByTag(tag)

                If (row Is Nothing) Then
                    Me.lblTitel.Text = "Er werd geen artikel gevonden met deze tag."
                    Return
                End If
            Else
                Dim id As Integer = Integer.Parse(Page.Request.Form(0))

                row = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelByID(id)

                If (row Is Nothing) Then
                    Me.lblTitel.Text = "Er werd geen artikel gevonden met dit ID."
                    Return
                End If
            End If

            'Artikel uitlezen en weergeven op pagina
            Dim artikel As New Artikel(row)
            Me.lblTekst.Text = artikel.Tekst
            Me.lblTitel.Text = artikel.Titel

            'Paginatitel veranderen
            Page.Title = artikel.Titel

            'Link 'Dit artikel bewerken' zichtbaar maken en link invullen
            Master.FindControl("liArtikelBewerken").Visible = True
            Dim linkArtikelBewerken As HyperLink = Master.FindControl("hrefArtikelBewerken")
            linkArtikelBewerken.NavigateUrl = String.Concat("ArtikelBewerken.aspx?id=", artikel.ID)

            'De boomstructuur uitklappen
            Dim tree As Tree = tree.GetTree(artikel.Taal, artikel.Versie, artikel.Bedrijf)

            If tree Is Nothing Then Return

            Dim nodeartikel As Node = tree.DoorzoekTreeVoorNode(artikel.ID, Global.ContentType.Artikel)

            If nodeartikel Is Nothing Then Return

            KlapBoomStructuurUit(tree, nodeartikel)

        End If
       
        'For i As Integer = 0 To Page.Request.Form.Count - 1
        '    ddlForm.Items.Add(Page.Request.Form(i))
        'Next
    End Sub

    Private Sub KlapBoomStructuurUit(ByRef tree As Tree, ByRef nodeartikel As Node)

        Dim javascript As String = String.Concat("function KlapCategorienUit() { ")

        Dim nodeparent As Node = Tree.VindParentVanNode(nodeartikel)
        While (nodeparent IsNot Nothing)

            If (nodeparent Is Tree.RootNode) Then
                Exit While
            End If

            javascript = String.Concat(javascript, "Effect.toggle('parent_", nodeparent.ID, "', 'slide', { duration: 0.5 }); veranderDropdown('imgtab_", nodeparent.ID, "'); ")
            nodeparent = Tree.VindParentVanNode(nodeparent)

            If (nodeparent Is Tree.RootNode) Then
                Exit While
            End If
        End While

        javascript = String.Concat(javascript, "return false; }")

        Page.ClientScript.RegisterStartupScript(Me.GetType(), "UitklappenCategorien", javascript, True)

        Dim body As HtmlGenericControl = Master.FindControl("MasterBody")
        body.Attributes.Add("onload", "KlapCategorienUit();")

    End Sub

End Class
