Public Class frmHoofdMenu

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
End Class
