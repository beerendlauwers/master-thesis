
Partial Class App_Presentation_MaakModules
    Inherits System.Web.UI.Page
    Dim adapter As New ManualTableAdapters.tblModuleTableAdapter
    Dim dal As New ModuleDAL
    Protected Sub btnMaakAan_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMaakAan.Click
        For i As Integer = 0 To GridView1.Rows.Count - 1
            Dim modu As String = GridView1.Rows(i).Cells(0).Text
            adapter.Insert(modu)
        Next
        Dim dt As Manual.tblModuleDataTable
        dt = dal.GetAllModules()
        If dt.Rows.Count > 0 Then
            MsgBox("Insert is gelukt.")
        End If

    End Sub

    Protected Sub btnVolledig_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolledig.Click
        Dim r As Integer
        r = dal.vulontbrekendemodulesaan()
        If Not r = -1 Then
            MsgBox("Modules zijn toegvoegd of alles was al aanwezig")
        End If
    End Sub
End Class
