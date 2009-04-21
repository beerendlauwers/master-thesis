Public Class BeheerStudent
    Private mycon As clDataViaSql
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mycon = New clDataViaSql
    End Sub
    Private Sub frmViaSql_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim blncongelukt As Boolean
        'Call conenab(False)
        'Call MenuEnab(1)
        blncongelukt = mycon.funConsql()


        Me.cboNaamData.DataSource = mycon.p_datavStud
        Me.cboNaamData.DisplayMember = "StudentNaam"
        Me.cboNaamData.ValueMember = "StudentID"

    End Sub
    Private Sub DetailToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DetailToolStripMenuItem.Click
        Dim mydrv As DataRowView
        Dim intidStud As Int16
        intidStud = Me.cboNaamData.SelectedValue
        If intidStud = -1 Then
            MessageBox.Show("U moet een werknemer selecteren!")
            Exit Sub
        End If
        mydrv = mycon.studentdetails(intidStud)
        Me.txtNaam.DataBindings.Add("text", mydrv, "StudentNaam")
        Me.txtNaam.DataBindings.Clear()
        Me.txtVoornaam.DataBindings.Add("text", mydrv, "StudentVoornaam")
        Me.txtVoornaam.DataBindings.Clear()
        Me.txtGSM.DataBindings.Add("text", mydrv, "StudentVoornaam")
        Me.txtGSM.DataBindings.Clear()
        Me.txtSchoolMail.DataBindings.Add("text", mydrv, "StudentVoornaam")
        Me.txtSchoolMail.DataBindings.Clear()
        Me.txtPriveMail.DataBindings.Add("text", mydrv, "StudentVoornaam")
        Me.txtPriveMail.DataBindings.Clear()
        Me.txtGebDatum.DataBindings.Add("text", mydrv, "StudentVoornaam")
        Me.txtGebDatum.DataBindings.Clear()
        Me.txtFinRek.DataBindings.Add("text", mydrv, "StudentVoornaam")
        Me.txtFinRek.DataBindings.Clear()

        Call MenuEnab(3)
    End Sub

    Private Sub MenuEnab(ByVal i_situatie As String)
        Select i_situatie
            Case 1 'frm load
                Me.EditToolStripMenuItem.Enabled = False
                Me.DetailToolStripMenuItem.Enabled = True
                Me.SaveToolStripMenuItem.Enabled = False
                Me.NewToolStripMenuItem.Enabled = True
                Me.DeleteToolStripMenuItem.Enabled = False
                Me.CancelToolStripMenuItem.Enabled = False
                Me.ExitToolStripMenuItem.Enabled = True
            Case 3 'detail
                Me.EditToolStripMenuItem.Enabled = True
                Me.DetailToolStripMenuItem.Enabled = False
                Me.SaveToolStripMenuItem.Enabled = True
                Me.NewToolStripMenuItem.Enabled = True
                Me.DeleteToolStripMenuItem.Enabled = True
                Me.CancelToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = True
        End Select
    End Sub

    Private Sub BeheerStudent_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub
End Class