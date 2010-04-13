Partial Class App_Presentation_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.Title = "Startpagina"
        Dim str1(100) As String
        For i As Integer = 0 To Page.Request.Form.Count - 1
            str1(i) = Page.Request.Form(i)
            Dim taal() As String = Split(str1(i), "$")
            If taal.Length > 1 Then
                taal(1) = taal(1).Substring(3)
                If taal(1) = "Nederlands" Then
                    lblWelkom.Text = "Welkom op de Appligen Reference Manual. Gebruik de menustructuur in de linkerzijbalk of de zoekbalk rechtsboven om een artikel te bezichtigen."
                ElseIf taal(1) = "français" Then
                    lblWelkom.Text = "Bienvenue sur le Reference Manual de Appligen. Utilisez le structure à gauche ou recherchez un article."
                Else
                    lblWelkom.Text = "Welcome to the Reference Manual of Appligen. Use the menustructure to the left to navigate to an article or type a word in the search-area."

                End If
            End If
        Next
    End Sub


End Class
