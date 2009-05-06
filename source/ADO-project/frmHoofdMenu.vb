Public Class frmHoofdMenu
    Public mySQLConnection As clDataViaSql
    Public myAccessConnection As clDataViaAccess
    Public BlnSQLConnectieGelukt As Boolean
    Public BlnAccessConnectieGelukt As Boolean
    Private HuidigForm As Form = New frmStart()

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.
        mySQLConnection = New clDataViaSql
        myAccessConnection = New clDataViaAccess
    End Sub

    Private Sub StudentenToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StudentenToolStripMenuItem1.Click
        Call ClearOtherWindows()
        HuidigForm = New BeheerStudent()
        HuidigForm.MdiParent = Me
        HuidigForm.Show()
    End Sub

    Private Sub SporttakkenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SporttakkenToolStripMenuItem.Click
        Call ClearOtherWindows()
        HuidigForm = New BeheerSporttakken()
        HuidigForm.MdiParent = Me
        HuidigForm.Show()
    End Sub

    Private Sub DeelnameToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeelnameToolStripMenuItem.Click
        Call ClearOtherWindows()
        HuidigForm = New Deelname()
        HuidigForm.MdiParent = Me
        HuidigForm.Show()
    End Sub

    Private Sub ClearOtherWindows()
        If (HuidigForm.Created) Then
            HuidigForm.Close()
        End If
    End Sub

    Private Sub frmHoofdMenu_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        HuidigForm.MdiParent = Me
        HuidigForm.Show()
    End Sub
End Class
