Imports System.Text.RegularExpressions

Public Class frmBeheerSporttakken
    Private mBlnNewSport As Boolean = False

    Private Sub BeheerSporttakken_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        'Alle textvelden disablen
        Call ConEnab(False)
        Call MenuEnab(1)

        'De tblSport ophalen
        If (frmHoofdMenu.BlnSQLConnectieGelukt) Then
            Me.cboSporttak.DataSource = frmHoofdMenu.mySQLConnection.p_datavSport
            Me.cboSporttak.DisplayMember = "SportNaam"
            Me.cboSporttak.ValueMember = "SportID"
        End If
    End Sub

    Private Sub DetailToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DetailToolStripMenuItem.Click
        Dim MyDataRowView As DataRowView
        Dim iSportID As Int16 = Me.cboSporttak.SelectedValue

        If iSportID = -1 Or Me.cboSporttak.Text = String.Empty Then
            MessageBox.Show("U heeft geen sport geselecteerd!")
            Exit Sub
        End If

        'Data uit de DataRowView overkopiëren
        MyDataRowView = frmHoofdMenu.mySQLConnection.f_ToonSportDetails(iSportID)
        Me.txtSportNaam.Text = MyDataRowView.Item("SportNaam").ToString
        Call MenuEnab(3)
    End Sub

    Private Sub NewToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewToolStripMenuItem.Click
        Call MenuEnab(2)
        Call ConEnab(True)
        Call ConClear()
        Me.txtSportNaam.Focus()
        mBlnNewSport = True
    End Sub

    Private Sub EditToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditToolStripMenuItem.Click
        Call ConEnab(True)
        Call MenuEnab(4)
        mBlnNewSport = False
    End Sub
    Private Sub SaveToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveToolStripMenuItem.Click
        If (CheckClear(Me.txtSportNaam.Text)) Then
            If (mBlnNewSport) Then
                'Als er een nieuwe sport wordt toegevoegd, voeren we deze functie uit:
                Dim newID = frmHoofdMenu.mySQLConnection.f_NieuweSport(Me.txtSportNaam.Text)
            Else
                'Anders voeren we de update-functie uit:
                frmHoofdMenu.mySQLConnection.f_UpdateSport(Me.txtSportNaam.Text, Me.cboSporttak.SelectedValue, Me.cboSporttak.SelectedIndex)
            End If
            Call MenuEnab(1)
            Call ConEnab(False)
        Else
            MessageBox.Show("Er zijn één of meerdere velden niet ingevuld.", "Ongeldig formulier", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        If (frmHoofdMenu.mySQLConnection.f_VerwijderSport(Me.cboSporttak.SelectedValue, Me.cboSporttak.SelectedIndex)) Then
            Call ConClear()
            MessageBox.Show("Sport verwijderd.","Sport Verwijderd",MessageBoxButtons.OK,MessageBoxIcon.Information)
        End If
    End Sub

    Private Sub CancelToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelToolStripMenuItem.Click
        Call MenuEnab(1)
        Call ConEnab(False)
        mBlnNewSport = False
    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        frmHoofdMenu.ToonStartScherm()
    End Sub

    Private Sub cboSporttak_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboSporttak.SelectedIndexChanged
        Call ConClear()
        Call MenuEnab(1)
        Call ConEnab(False)
    End Sub

    Private Sub txtSportNaam_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSportNaam.TextChanged
        SetGeldig(CheckClear(Me.txtSportNaam.Text), Me.lblNaamgeldig, Me.picNaamGeldig, "Naam")
    End Sub

    Private Function CheckClear(ByVal tekst As String) As Boolean
        If (tekst = String.Empty Or BestaatUitSpatiesOfTabs(tekst)) Then
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

    Private Sub MenuEnab(ByVal i_situatie As String)
        Select Case i_situatie
            Case 1 'Form load
                Me.EditToolStripMenuItem.Enabled = False
                Me.DetailToolStripMenuItem.Enabled = True
                Me.SaveToolStripMenuItem.Enabled = False
                Me.NewToolStripMenuItem.Enabled = True
                Me.DeleteToolStripMenuItem.Enabled = False
                Me.CancelToolStripMenuItem.Enabled = False
                Me.ExitToolStripMenuItem.Enabled = True
            Case 2 'Geklikt op New
                Me.EditToolStripMenuItem.Enabled = False
                Me.DetailToolStripMenuItem.Enabled = False
                Me.SaveToolStripMenuItem.Enabled = True
                Me.NewToolStripMenuItem.Enabled = False
                Me.DeleteToolStripMenuItem.Enabled = False
                Me.CancelToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = False
            Case 3 'Geklikt op Detail
                Me.EditToolStripMenuItem.Enabled = True
                Me.DetailToolStripMenuItem.Enabled = False
                Me.SaveToolStripMenuItem.Enabled = False
                Me.NewToolStripMenuItem.Enabled = False
                Me.DeleteToolStripMenuItem.Enabled = True
                Me.CancelToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = True
            Case 4 'Geklikt op Edit
                Me.EditToolStripMenuItem.Enabled = False
                Me.DetailToolStripMenuItem.Enabled = False
                Me.SaveToolStripMenuItem.Enabled = True
                Me.NewToolStripMenuItem.Enabled = False
                Me.DeleteToolStripMenuItem.Enabled = False
                Me.CancelToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = False
        End Select
    End Sub

    Private Sub ConEnab(ByVal BlnEnabled As Boolean)
        Me.txtSportNaam.Enabled = BlnEnabled
    End Sub

    Private Sub ConClear()
        Me.txtSportNaam.Text = String.Empty
    End Sub

    Private Sub SetGeldig(ByVal Geldig As Boolean, ByVal LabelControl As Label, ByVal ImageControl As PictureBox, ByVal LabelString As String)
        If (Geldig) Then
            ImageControl.Image = My.Resources.tick
            LabelControl.Text = String.Concat(LabelString, " Geldig")
            LabelControl.ForeColor = Color.ForestGreen
        Else
            ImageControl.Image = My.Resources.remove
            LabelControl.Text = String.Concat(LabelString, " Ongeldig")
            LabelControl.ForeColor = Color.Firebrick
        End If
    End Sub
End Class