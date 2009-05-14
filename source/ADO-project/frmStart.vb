Public Class frmStart
    Public mLabels As frmHoofdMenu.LabelSettings

#Region "Form Load"
    Private Sub frmStart_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.lblSQLServerTekst.Text = mLabels.SQLServer
        Me.lblSQLDatabaseTekst.Text = mLabels.SQLDataBase
        Me.lblSQLGebruikerTekst.Text = mLabels.SQLGebruiker
        Me.lblDatabaseAccessTekst.Text = mLabels.AccessDataBase
        Me.lblTabelAccessTekst.Text = mLabels.AccessTabel
        Me.lblKolomAccessTekst.Text = mLabels.AccessKolom
    End Sub
#End Region

#Region "Buttons"
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
        Call frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmVergelijkemails()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub

    Private Sub btnExporteerNaarOracle_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExporteerNaarOracle.Click
        Call frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmExporteerNaarOracle()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub

    Private Sub BtnExporteerNaarXML_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BtnExporteerNaarXML.Click
        Call frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmExporteerNaarXML()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub

    Private Sub btnImporteerUitExcel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImporteerUitExcel.Click
        Call frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmImporteerUitExcel()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub
#End Region

    Private Sub btnConfigWijzigen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConfigWijzigen.Click
        Call frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmConfig()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub

    Private Sub btnVerbindMetMySQL_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnVerbindMetMySQL.Click
        Call frmHoofdMenu.mySQLConnection.verbindingmysql()
    End Sub
End Class