Public Class BeheerSporttakken
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

    Private Sub DetailToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DetailToolStripMenuItem.Click
        Dim MyDataRowView As DataRowView
        Dim iSportID As Int16 = Me.cboSporttak.SelectedValue

        If iSportID = -1 Then
            MessageBox.Show("U heeft geen sport geselecteerd!")
            Exit Sub
        End If

        'Data uit de DataRowView overkopiëren
        MyDataRowView = frmHoofdMenu.mySQLConnection.f_ToonSportDetails(iSportID)

        Me.txtSportNaam.DataBindings.Add("text", MyDataRowView, "SportNaam")
        Me.txtSportNaam.DataBindings.Clear()

        Call MenuEnab(3)
    End Sub

    Private Sub CancelToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelToolStripMenuItem.Click
        Call MenuEnab(1)
        Call ConEnab(False)
        mBlnNewSport = False
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
        If (CheckClear()) Then
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
            MsgBox("Er zijn één of meerdere velden niet ingevuld.")
        End If
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        If (frmHoofdMenu.mySQLConnection.f_VerwijderSport(Me.cboSporttak.SelectedValue, Me.cboSporttak.SelectedIndex)) Then
            Call ConClear()
            MsgBox("Sport verwijderd.")
        End If
    End Sub

    Private Function CheckClear() As Boolean
        Dim blntest As Boolean = True
        If (Me.txtSportNaam.Text = String.Empty) Then
            Return blntest = False
            Exit Function
        End If
        Return blntest
    End Function

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        Me.Close()
    End Sub

    Private Sub cboSporttak_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboSporttak.SelectedIndexChanged
        Call ConClear()
        Call MenuEnab(1)
        Call ConEnab(False)
    End Sub
End Class