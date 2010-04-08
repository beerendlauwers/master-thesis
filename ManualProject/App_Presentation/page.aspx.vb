Imports Manual

Partial Class App_Presentation_page
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Titel bepalen
        Page.Title = "Ongeldig Artikel"

        'Querystring checken op geldigheid
        Dim type As Integer = CheckQueryString()

        If type = 0 Then 'Geen geldige ID of tag!
            Return
        Else
            'Artikel uitlezen
            Dim artikel As Artikel = LeesArtikel(type)
            If artikel Is Nothing Then 'Geen artikel gevonden!
                Return
            Else
                'Checken of de gebruiker dit artikel wel mag zien
                If CheckArtikel(artikel) Then
                    ToonArtikel(artikel)
                End If
            End If
        End If

    End Sub

    Private Function LeesArtikel(ByVal type As Integer) As Artikel

        Dim row As tblArtikelRow = Nothing

        If type = 2 Then
            Dim tag As String = Request.QueryString("tag")
            tag = tag.Trim

            If tag = String.Empty Then
                Me.lblTitel.Text = "Ongeldig artikel."
                Return Nothing
            End If

            row = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelByTag(tag)

            If (row Is Nothing) Then
                Me.lblTitel.Text = "Er werd geen artikel gevonden met deze tag."
                Return Nothing
            End If
        Else
            Dim id As Integer = Integer.Parse(Request.QueryString("id"))

            row = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelByID(id)

            If (row Is Nothing) Then
                Me.lblTitel.Text = "Er werd geen artikel gevonden met dit ID."
                Return Nothing
            End If

        End If

        If row IsNot Nothing Then
            Return New Artikel(row)
        Else
            Return Nothing
        End If
    End Function

    Private Function CheckQueryString() As Integer

        Dim geldigeTag As Boolean = True
        Dim geldigID As Boolean = True

        If (Request.QueryString("tag") Is Nothing) Then
            Me.lblTitel.Text = "Ongeldig artikel."
            geldigeTag = False
        End If

        If (TryCast(Request.QueryString("tag"), String) Is Nothing) Then
            Me.lblTitel.Text = "Ongeldig artikel."
            geldigeTag = False
        End If

        If (Request.QueryString("id") Is Nothing) Then
            Me.lblTitel.Text = "Ongeldig artikel."
            geldigID = False
        End If

        If (Not IsNumeric(Request.QueryString("id"))) Then
            Me.lblTitel.Text = "Ongeldig artikel."
            geldigID = False
        End If

        If geldigeTag = False Then
            If geldigID = False Then
                Return 0
            Else
                Return 1
            End If
        Else
            Return 2
        End If

    End Function

    Private Function CheckArtikel(ByRef a As Artikel) As Boolean

        Dim ingelogdeVersie As Integer = Session("versie")
        Dim ingelogdBedrijf As Integer = Session("bedrijf")

        If Not ingelogdeVersie = a.Versie Then
            Me.lblTitel.Text = "Ongeldig artikel."
            Return False
        End If

        If Not (ingelogdBedrijf = a.Bedrijf Or a.Bedrijf = 0) Then
            Me.lblTitel.Text = "Ongeldig artikel."
            Return False
        End If

        Return True

    End Function

    Private Sub ToonArtikel(ByRef a As Artikel)

        Me.lblTekst.Text = a.Tekst
        Me.lblTitel.Text = a.Titel

        'Paginatitel veranderen
        Page.Title = a.Titel

        'Link 'Dit artikel bewerken' zichtbaar maken en link invullen
        Master.FindControl("liArtikelBewerken").Visible = True
        Dim linkArtikelBewerken As HyperLink = Master.FindControl("hrefArtikelBewerken")
        linkArtikelBewerken.NavigateUrl = String.Concat("ArtikelBewerken.aspx?id=", a.ID)

        'De boomstructuur uitklappen
        Dim tree As Tree = tree.GetTree(a.Taal, a.Versie, a.Bedrijf)

        If tree Is Nothing Then Return

        Dim nodeartikel As Node = tree.DoorzoekTreeVoorNode(a.ID, Global.ContentType.Artikel)

        If nodeartikel Is Nothing Then Return

        KlapBoomStructuurUit(tree, nodeartikel)

    End Sub

    Private Sub KlapBoomStructuurUit(ByRef tree As Tree, ByRef nodeartikel As Node)

        Dim javascript As String = String.Concat("function KlapCategorienUit() { ")

        Dim nodeparent As Node = tree.VindParentVanNode(nodeartikel)
        While (nodeparent IsNot Nothing)

            If (nodeparent Is tree.RootNode) Then
                Exit While
            End If

            javascript = String.Concat(javascript, "Effect.toggle('parent_", nodeparent.ID, "', 'slide', { duration: 0.5 }); veranderDropdown('imgtab_", nodeparent.ID, "'); ")
            nodeparent = tree.VindParentVanNode(nodeparent)

            If (nodeparent Is tree.RootNode) Then
                Exit While
            End If
        End While

        javascript = String.Concat(javascript, "return false; }")

        Page.ClientScript.RegisterStartupScript(Me.GetType(), "UitklappenCategorien", javascript, True)

        Dim body As HtmlGenericControl = Master.FindControl("MasterBody")
        body.Attributes.Add("onload", "KlapCategorienUit();")

    End Sub

End Class
