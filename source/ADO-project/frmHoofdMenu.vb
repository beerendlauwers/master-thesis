Public Class frmHoofdMenu
    Public myConnection As clDataViaSql
    Public BlnConnectieGelukt As Boolean

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.
        myConnection = New clDataViaSql
    End Sub

    Private Sub StudentenToolStripMenuItem1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles StudentenToolStripMenuItem1.Click
        Dim frm2 As BeheerStudent = New BeheerStudent()
        frm2.MdiParent = Me
        frm2.Show()
    End Sub

    Private Sub SporttakkenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SporttakkenToolStripMenuItem.Click
        Dim frm3 As BeheerSporttakken = New BeheerSporttakken()
        frm3.MdiParent = Me

        frm3.Show()
    End Sub

    Private Sub DeelnameToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeelnameToolStripMenuItem.Click
        Dim frm4 As Deelname = New Deelname()
        frm4.MdiParent = Me
        frm4.Show()
    End Sub

    Private Sub frmHoofdMenu_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        BlnConnectieGelukt = myConnection.f_VerbindMetDatabase()

    End Sub
End Class
