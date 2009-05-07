Public Class frmStart

    Private Sub btlnStudentenBeheer_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btlnStudentenBeheer.Click
        Call frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmBeheerStudent()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub

    Private Sub btnSportBeheer_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSportBeheer.Click
        Call frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmBeheerSporttakken()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub

    Private Sub btnDeelnameBeheer_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDeelnameBeheer.Click
        Call frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmDeelname()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub

    Private Sub btnVergelijkMetAccess_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnVergelijkMetAccess.Click
        Dim VergelijkEmails As Form = New frmVergelijkemails()
        VergelijkEmails.Show()
    End Sub

    Private Sub btnExporteerNaarOracle_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExporteerNaarOracle.Click

    End Sub

    Private Sub BtnExporteerNaarXML_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BtnExporteerNaarXML.Click
        Call frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmExporteernaarXML()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub

    Private Sub btnImporteerUitExcel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImporteerUitExcel.Click
        Call frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmImporteerUitExcel()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub
End Class