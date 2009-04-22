Public Class Deelname
    Private mBlnNewNiveau As Boolean = False

    Private Sub Deelname_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'Alle textvelden disablen
        Call ConEnab(False)
        Call MenuEnab(1)
        Me.btnOpslaan.Enabled = False

        If (frmHoofdMenu.BlnConnectieGelukt) Then
            'De tblStudent ophalen
            Me.cboDeelnameStudent.DataSource = frmHoofdMenu.myConnection.p_datavStud
            Me.cboDeelnameStudent.DisplayMember = "StudentNaam"
            Me.cboDeelnameStudent.ValueMember = "StudentID"
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
                Me.OverviewToolStripMenuItem.Enabled = True
                Me.SaveToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = True
            Case 2 '<Nieuw Niveau> is geselecteerd
                Me.OverviewToolStripMenuItem.Enabled = True
                Me.SaveToolStripMenuItem.Enabled = False
                Me.ExitToolStripMenuItem.Enabled = True
        End Select
    End Sub

    Private Sub ConEnab(ByVal BlnEnabled As Boolean)
        Me.txtNiveau.Enabled = BlnEnabled
    End Sub

    Private Sub ConClear()
        Me.txtNiveau.Text = String.Empty
    End Sub

    Private Function CheckClear() As Boolean
        Dim blntest As Boolean = True
        If (Me.txtNiveau.Text = String.Empty) Then
            Return blntest = False
            Exit Function
        End If
        Return blntest
    End Function

    Private Function CheckCombos() As Boolean
        Dim blntest As Boolean = True
        If (Me.cboDeelnameStudent.Text = String.Empty Or Me.cboDeelnameSport.Text = String.Empty Or Me.cboNiveau.Text = String.Empty) Then
            Return blntest = False
        End If
        Return blntest
    End Function

    Private Sub cboNiveau_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboNiveau.SelectedIndexChanged
        If Me.cboNiveau.Text = "< Nieuw Niveau >" Then
            mBlnNewNiveau = True
            Call ConEnab(True)
            Call ConClear()
            Call MenuEnab(2)
        End If
    End Sub

    Private Sub cboNiveau_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboNiveau.TextChanged
        Call ConEnab(False)
        Call ConClear()
        Call MenuEnab(1)
    End Sub

    Private Sub btnOpslaan_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOpslaan.Click
        If (CheckClear()) Then
            If (mBlnNewNiveau) Then
                'Als er een nieuwe sport wordt toegevoegd, voeren we deze functie uit:
                Dim newID = frmHoofdMenu.myConnection.f_NieuwNiveau(Me.txtNiveau.Text)
            End If
            Call MenuEnab(1)
            Call ConEnab(False)
            Call ConClear()
        Else
            MsgBox("Er zijn één of meerdere velden niet ingevuld.")
        End If
    End Sub

    Private Sub txtNiveau_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtNiveau.TextChanged
        If (CheckClear()) Then
            Me.btnOpslaan.Enabled = True
        Else
            Me.btnOpslaan.Enabled = False
        End If
    End Sub

    Private Sub SaveToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveToolStripMenuItem.Click
        If (CheckCombos()) Then
            If Me.cboNiveau.Text = "< Nieuw Niveau >" Then
                Exit Sub
            End If
            frmHoofdMenu.myConnection.f_NieuweDeelname(Me.cboDeelnameStudent.SelectedValue, Me.cboDeelnameSport.SelectedValue, Me.cboNiveau.SelectedValue)
            MessageBox.Show("Deelname opgeslagen.", "Deelname Opgeslagen")
        End If
    End Sub

    Private Sub OverviewToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OverviewToolStripMenuItem.Click
        Dim frm As frmDeelnameOverzicht = New frmDeelnameOverzicht()
        frm.ShowDialog()
    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        Me.Close()
    End Sub
End Class