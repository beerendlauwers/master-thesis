Public Class Deelname
    Private mBlnNewDeelname As Boolean = False

    Private Sub Deelname_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'Alle textvelden disablen
        'Call ConEnab(False)
        Call MenuEnab(1)

        If (frmHoofdMenu.BlnConnectieGelukt) Then
            'De tblStudent ophalen
            Me.cboDeelnameStudent.DataSource = frmHoofdMenu.myConnection.p_datavStud
            Me.cboDeelnameStudent.DisplayMember = "StudentNaam"
            Me.cboDeelnameSport.ValueMember = "StudentID"
            'De tblSport ophalen
            Me.cboDeelnameSport.DataSource = frmHoofdMenu.myConnection.p_datavSport
            Me.cboDeelnameSport.DisplayMember = "SportNaam"
            Me.cboDeelnameSport.ValueMember = "SportID"
            'De tblNiveau ophalen
            Me.cboNiveau.DataSource = frmHoofdMenu.myConnection.p_datavNiveau
            Me.cboNiveau.DisplayMember = "Niveau"
            Me.cboNiveau.ValueMember = "NiveauID"
        End If
    End Sub

    Private Sub MenuEnab(ByVal i_situatie As String)
        Select Case i_situatie
            Case 1 'Form load
                Me.EditToolStripMenuItem.Enabled = False
                Me.DetailsToolStripMenuItem.Enabled = True
                Me.SaveToolStripMenuItem.Enabled = False
                Me.NewToolStripMenuItem.Enabled = True
                Me.DeleteToolStripMenuItem.Enabled = False
                Me.CancelToolStripMenuItem.Enabled = False
                Me.ExitToolStripMenuItem.Enabled = True
            Case 2 'Geklikt op New
                Me.EditToolStripMenuItem.Enabled = False
                Me.DetailsToolStripMenuItem.Enabled = False
                Me.SaveToolStripMenuItem.Enabled = True
                Me.NewToolStripMenuItem.Enabled = False
                Me.DeleteToolStripMenuItem.Enabled = False
                Me.CancelToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = False
            Case 3 'Geklikt op Detail
                Me.EditToolStripMenuItem.Enabled = True
                Me.DetailsToolStripMenuItem.Enabled = False
                Me.SaveToolStripMenuItem.Enabled = False
                Me.NewToolStripMenuItem.Enabled = False
                Me.DeleteToolStripMenuItem.Enabled = True
                Me.CancelToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = True
            Case 4 'Geklikt op Edit
                Me.EditToolStripMenuItem.Enabled = False
                Me.DetailsToolStripMenuItem.Enabled = False
                Me.SaveToolStripMenuItem.Enabled = True
                Me.NewToolStripMenuItem.Enabled = False
                Me.DeleteToolStripMenuItem.Enabled = False
                Me.CancelToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = False
        End Select
    End Sub

    Private Sub ConEnab(ByVal BlnEnabled As Boolean)

    End Sub
End Class