
Partial Class App_Presentation_MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Tree.GetTrees() Is Nothing) Then
            Tree.BouwTrees()
        End If

        ArtikelToevoegen.HRef = "~/App_Presentation/invoerenTekst.aspx"
        ArtikelBewerken.HRef = "~/App_Presentation/ArtikelBewerken.aspx"
        ArtikelVerwijderen.HRef = "~/App_Presentation/verwijderenTekst.aspx"

        'Testsysteempje
        Dim taal As Integer = 0
        Dim bedrijf As Integer = 0
        Dim versie As Integer = 0

        Dim rootlist As New HtmlGenericControl("ul")

        Dim htmlcode As String = String.Empty

        Dim t As Tree = Tree.GetTree(taal, versie, bedrijf)
        Dim root As Node = t.RootNode

        htmlcode = String.Concat(htmlcode, "<br/><div>", t.Bedrijf.Naam, "</div>")

        htmlcode = t.BeginNieuweLijst(htmlcode, root, -1)

        Dim t2 As Tree = Tree.GetTree(taal, versie, 1)
        Dim root2 As Node = t2.RootNode

        htmlcode = String.Concat(htmlcode, "<br/><div>", t2.Bedrijf.Naam, "</div>")

        htmlcode = t.BeginNieuweLijst(htmlcode, root2, -1)

        Dim boomdiv As HtmlGenericControl = Me.FindControl("divBoomStructuur")
        boomdiv.InnerHtml = htmlcode

    End Sub

    Protected Sub ImageButton1_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton1.Click
        Response.Redirect("~/App_Presentation/zoekresultaten.aspx?tag=" + txtZoek.Text + "&bedrijfID=" + "4" + "&versieID=" + "0" + "&taalID=" + "0")
    End Sub
End Class

