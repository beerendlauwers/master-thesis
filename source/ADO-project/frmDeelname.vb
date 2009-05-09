Imports System.Text.RegularExpressions

Public Class frmDeelname
    Private mBlnNewNiveau As Boolean = False

    Private Sub Deelname_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'Alle textvelden disablen
        Call ConEnab(False)
        Call MenuEnab(1)
        Me.btnOpslaan.Enabled = False

        If (frmHoofdMenu.BlnSQLConnectieGelukt) Then
            'De tblStudent ophalen
            Me.cboDeelnameStudent.DataSource = frmHoofdMenu.mySQLConnection.p_datavStud
            Me.cboDeelnameStudent.DisplayMember = "StudentNaam"
            Me.cboDeelnameStudent.ValueMember = "StudentID"
            'De tblSport ophalen
            Me.cboDeelnameSport.DataSource = frmHoofdMenu.mySQLConnection.p_datavSport
            Me.cboDeelnameSport.DisplayMember = "SportNaam"
            Me.cboDeelnameSport.ValueMember = "SportID"
            'De tblNiveau ophalen
            Me.cboNiveau.DataSource = frmHoofdMenu.mySQLConnection.p_datavNiveau
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
        If (Me.txtNiveau.Text = String.Empty Or BestaatUitSpatiesOfTabs(Me.txtNiveau.Text)) Then
            Return False
        Else
            Return True
        End If
    End Function

    Private Function BestaatUitSpatiesOfTabs(ByVal Text As String) As Boolean
        If (Text.Length > 0) Then
            'Het patroon \s is gelijk aan een spatie, tab of line break
            Dim bestaatuitwitruimtes As Match = Regex.Match(Text, "^\s*$")
            If (bestaatuitwitruimtes.Success) Then
                Return True
            Else
                Return False
            End If
        End If

        Return True
    End Function

    Private Function CheckCombos() As Boolean
        If (Me.cboDeelnameStudent.Text = String.Empty Or Me.cboDeelnameSport.Text = String.Empty Or Me.cboNiveau.Text = String.Empty) Then
            Return False
        Else
            Return True
        End If
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
                'Als er een nieuw niveau wordt toegevoegd, voeren we deze functie uit:
                Dim newID = frmHoofdMenu.mySQLConnection.f_NieuwNiveau(Me.txtNiveau.Text)
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
                MessageBox.Show("Gelieve een niveau te selecteren.")
                Exit Sub
            End If
            frmHoofdMenu.mySQLConnection.f_NieuweDeelname(Me.cboDeelnameStudent.SelectedValue, Me.cboDeelnameSport.SelectedValue, Me.cboNiveau.SelectedValue)
            MessageBox.Show("Deelname opgeslagen.", "Deelname Opgeslagen")
        Else
            MessageBox.Show("U moet een optie selecteren uit alle dropdown-boxes.")
        End If
    End Sub

    Private Sub OverviewToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OverviewToolStripMenuItem.Click
        Dim frm As frmDeelnameOverzicht = New frmDeelnameOverzicht()
        frm.ShowDialog()
    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        frmHoofdMenu.ToonStartScherm()
    End Sub

    Private Sub MenuStrip1_ItemClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ToolStripItemClickedEventArgs) Handles mnuDeelnameBeheer.ItemClicked

    End Sub
End Class