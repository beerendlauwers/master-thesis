Partial Class App_Presentation_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Testsysteempje
        Dim taal As Integer = 0
        Dim bedrijf As Integer = 0
        Dim versie As Integer = 0

        Dim rootlist As New HtmlGenericControl("ul")

        Dim htmlcode As String = String.Empty

        Dim tree As Tree = tree.GetTree(taal, versie, bedrijf)
        Dim root As Node = tree.RootNode

        'Dim watch As New Stopwatch()
        'watch.Start()
        Response.Write(tree.BeginNieuweLijst(htmlcode, root))
        'watch.Stop()
    End Sub


End Class
