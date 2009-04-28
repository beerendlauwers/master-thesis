Public Class BeheerStudent
    Private mBlnNewStudent As Boolean = False
    Private HuidigForm As Form = New frmListbox()

    Private Sub frmViaSql_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Combobox invullen
        Me.cboStudentNaam.Items.Add("Naam")
        Me.cboStudentNaam.Items.Add("Voornaam")
        Me.cboStudentNaam.SelectedIndex = 0

        'Alle textvelden disablen
        Call ConEnab(False)
        Call MenuEnab(1)

        'De tblStudent ophalen
        If (frmHoofdMenu.BlnConnectieGelukt) Then
            Me.cboNaamData.DataSource = frmHoofdMenu.myConnection.p_datavStud
        End If
    End Sub

    Private Sub DetailToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DetailToolStripMenuItem.Click
        Dim MyDataRowView As DataRowView
        Dim iStudentID As Int16 = Me.cboNaamData.SelectedValue

        If iStudentID = -1 Then
            MessageBox.Show("U heeft geen student geselecteerd!")
            Exit Sub
        End If

        'Data uit de DataRowView overkopiëren
        MyDataRowView = frmHoofdMenu.myConnection.f_ToonStudentDetails(iStudentID)

        Me.txtNaam.DataBindings.Add("text", MyDataRowView, "StudentNaam")
        Me.txtNaam.DataBindings.Clear()
        Me.txtVoornaam.DataBindings.Add("text", MyDataRowView, "StudentVoornaam")
        Me.txtVoornaam.DataBindings.Clear()
        Me.txtGSM.DataBindings.Add("text", MyDataRowView, "StudentGSM")
        Me.txtGSM.DataBindings.Clear()
        Me.txtSchoolMail.DataBindings.Add("text", MyDataRowView, "StudentSchoolEmail")
        Me.txtSchoolMail.DataBindings.Clear()
        Me.txtPriveMail.DataBindings.Add("text", MyDataRowView, "StudentPriveEmail")
        Me.txtPriveMail.DataBindings.Clear()
        Me.dtpGebDat.DataBindings.Add("text", MyDataRowView, "StudentGebDat")
        Me.dtpGebDat.DataBindings.Clear()
        Me.txtFinRek.DataBindings.Add("text", MyDataRowView, "StudentFinRek")
        Me.txtFinRek.DataBindings.Clear()

        Call MenuEnab(3)
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
                Me.btnStudentMail.Enabled = True
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
        Dim TextControl As Control
        For Each TextControl In Controls
            If TextControl.Name.Substring(0, 3) = "txt" Then
                TextControl.Enabled = BlnEnabled
            End If
        Next
        Me.dtpGebDat.Enabled = BlnEnabled
        Me.btnStudentMail.Enabled = BlnEnabled
    End Sub

    Private Sub ConClear()
        Dim TextControl As Control
        For Each TextControl In Controls
            If TextControl.Name.Substring(0, 3) = "txt" Then
                TextControl.Text = String.Empty
            End If
        Next
        Me.dtpGebDat.Value = "01-01-1980"
    End Sub


    Private Sub CancelToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelToolStripMenuItem.Click
        Call MenuEnab(1)
        Call ConEnab(False)
        mBlnNewStudent = False
    End Sub

    Private Sub NewToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewToolStripMenuItem.Click
        Call MenuEnab(2)
        Call ConEnab(True)
        Call ConClear()
        Me.txtNaam.Focus()
        mBlnNewStudent = True
    End Sub

    Private Sub EditToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditToolStripMenuItem.Click
        Call ConEnab(True)
        Call MenuEnab(4)
        mBlnNewStudent = False
    End Sub

    Private Sub SaveToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveToolStripMenuItem.Click
        If (CheckClear()) Then
            If (mBlnNewStudent) Then
                'Als er een nieuwe student wordt toegevoegd, voeren we deze functie uit:
                Dim newID = frmHoofdMenu.myConnection.f_NieuweStudent(Me.txtNaam.Text, Me.txtVoornaam.Text, Me.txtGSM.Text, Me.txtSchoolMail.Text, Me.txtPriveMail.Text, Me.dtpGebDat.Text, Me.txtFinRek.Text)
            Else
                'Anders voeren we de update-functie uit:
                frmHoofdMenu.myConnection.f_UpdateStudent(Me.txtNaam.Text, Me.txtVoornaam.Text, Me.txtGSM.Text, Me.txtSchoolMail.Text, Me.txtPriveMail.Text, Me.dtpGebDat.Text, Me.txtFinRek.Text, Me.cboNaamData.SelectedValue, Me.cboNaamData.SelectedIndex)
            End If
            Call MenuEnab(1)
            Call ConEnab(False)
        Else
            MsgBox("Er zijn één of meerdere velden niet ingevuld.")
        End If
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        If (frmHoofdMenu.myConnection.f_VerwijderStudent(Me.cboNaamData.SelectedValue, Me.cboNaamData.SelectedIndex)) Then
            Call ConClear()
            MsgBox("Student verwijderd.")
        End If
    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        Me.Close()
    End Sub

    Private Function CheckClear() As Boolean
        Dim blntest As Boolean = True
        Dim TextControl As Control
        For Each TextControl In Controls
            If TextControl.Name.Substring(0, 3) = "txt" Then
                If (TextControl.Text = String.Empty) Then
                    Return blntest = False
                    Exit Function
                End If
            End If
        Next
        Return blntest
    End Function

    Private Sub cboStudentNaam_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboStudentNaam.TextChanged

        frmHoofdMenu.myConnection.s_FilterStudentOp(Me.cboStudentNaam.Text)

        If (Me.cboStudentNaam.Text = "Naam") Then
            Me.cboNaamData.DisplayMember = "StudentNaam"
        Else
            Me.cboNaamData.DisplayMember = "StudentVoornaam"
        End If
        Me.cboNaamData.ValueMember = "StudentID"

        Call MenuEnab(1)
        Call ConClear()
        Call ConEnab(False)
    End Sub

    Private Sub cboNaamData_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboNaamData.TextChanged
        Call MenuEnab(1)
        Call ConClear()
        Call ConEnab(False)
    End Sub

    Private Sub btnStudentMail_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStudentMail.Click
        Process.Start("mailto:" & Me.txtSchoolMail.Text & "?subject=Vult zelf is iets in luierik!! &body=")
    End Sub

    Private Sub EmailVergelijkenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EmailVergelijkenToolStripMenuItem.Click
        HuidigForm = New frmListbox()
        'HuidigForm.MdiParent = Me
        HuidigForm.Show()
    End Sub

    Private Sub MenuStrip1_ItemClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ToolStripItemClickedEventArgs) Handles MenuStrip1.ItemClicked

    End Sub
End Class