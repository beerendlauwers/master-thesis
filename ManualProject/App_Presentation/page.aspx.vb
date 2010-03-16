Imports Manual

Partial Class App_Presentation_page
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Master.FindControl("liArtikelBewerken").Visible = True


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

        If (geldigID Or geldigeTag) Then

            Dim row As tblArtikelRow

            If (geldigeTag) Then
                Dim tag As String = Request.QueryString("tag")
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
                Dim id As Integer = Integer.Parse(Request.QueryString("id"))

                row = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelByID(id)

                If (row Is Nothing) Then
                    Me.lblTitel.Text = "Er werd geen artikel gevonden met dit ID."
                    Return
                End If
            End If

            Dim artikel As New Artikel(row)
            Me.lblTekst.Text = artikel.Tekst
            Me.lblTitel.Text = artikel.Titel

            'De boomstructuur uitklappen
            Dim tree As Tree = tree.GetTree(artikel.Taal, artikel.Versie, artikel.Bedrijf)
            Dim nodeartikel As Node = tree.DoorzoekTreeVoorNode(artikel.ID, Global.ContentType.Artikel)

            Dim javascript As String = String.Concat("function dapsap() { ")

            Dim nodeparent As Node = tree.VindParentVanNode(nodeartikel)
            While (nodeparent IsNot Nothing)
                javascript = String.Concat(javascript, "Effect.toggle('parent_", nodeparent.ID, "', 'slide', { duration: 0.5 }); veranderDropdown('imgtab_", nodeparent.ID, "'); ")
                nodeparent = tree.VindParentVanNode(nodeparent)

                If (nodeparent Is tree.RootNode) Then
                    Exit While
                End If
            End While

            javascript = String.Concat(javascript, "return false; }")

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "testen", javascript, True)

            Dim body As HtmlGenericControl = Master.FindControl("MasterBody")
            body.Attributes.Add("onload", "dapsap();")

        End If



    End Sub
End Class
