
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

        Dim holder As ContentPlaceHolder = Me.FindControl("ContentPlaceHolderSideBar")
        Dim boomdiv As HtmlGenericControl = holder.FindControl("divBoomStructuur")
        Dim dap As Object = holder.Controls.Item(0)
        Dim dap2 As Object = holder.Controls.Item(1)
        boomdiv.InnerHtml = t.BeginNieuweLijst(htmlcode, root, -1)

    End Sub

End Class

