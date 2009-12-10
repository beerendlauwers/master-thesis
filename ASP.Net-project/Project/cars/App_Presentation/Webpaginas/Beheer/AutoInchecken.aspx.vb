
Partial Class App_Presentation_Webpaginas_Beheer_AutoInchecken
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim autobll As New AutoBLL
        Dim kentekens() As String = autobll.GetAllKentekens()

        For Each waarde In kentekens
            Me.ddlKenteken.Items.Add(waarde)
        Next

    End Sub
End Class
