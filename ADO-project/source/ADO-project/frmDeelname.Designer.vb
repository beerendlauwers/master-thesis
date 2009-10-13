<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmDeelname
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.mnuDeelnameBeheer = New System.Windows.Forms.MenuStrip
        Me.BeheerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OverviewToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.SaveToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.cboDeelnameStudent = New System.Windows.Forms.ComboBox
        Me.lblDeelnameStudent = New System.Windows.Forms.Label
        Me.cboDeelnameSport = New System.Windows.Forms.ComboBox
        Me.lblDeelnameSport = New System.Windows.Forms.Label
        Me.txtNiveau = New System.Windows.Forms.TextBox
        Me.lblNiveau = New System.Windows.Forms.Label
        Me.cboNiveau = New System.Windows.Forms.ComboBox
        Me.lblNiveauCombo = New System.Windows.Forms.Label
        Me.btnOpslaan = New System.Windows.Forms.Button
        Me.grpNieuweDeelname = New System.Windows.Forms.GroupBox
        Me.mnuDeelnameBeheer.SuspendLayout()
        Me.grpNieuweDeelname.SuspendLayout()
        Me.SuspendLayout()
        '
        'mnuDeelnameBeheer
        '
        Me.mnuDeelnameBeheer.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BeheerToolStripMenuItem})
        Me.mnuDeelnameBeheer.Location = New System.Drawing.Point(0, 0)
        Me.mnuDeelnameBeheer.Name = "mnuDeelnameBeheer"
        Me.mnuDeelnameBeheer.Size = New System.Drawing.Size(514, 24)
        Me.mnuDeelnameBeheer.TabIndex = 0
        Me.mnuDeelnameBeheer.Text = "Deelnamebeheer"
        '
        'BeheerToolStripMenuItem
        '
        Me.BeheerToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OverviewToolStripMenuItem, Me.SaveToolStripMenuItem, Me.ExitToolStripMenuItem})
        Me.BeheerToolStripMenuItem.Name = "BeheerToolStripMenuItem"
        Me.BeheerToolStripMenuItem.Size = New System.Drawing.Size(53, 20)
        Me.BeheerToolStripMenuItem.Text = "Beheer"
        '
        'OverviewToolStripMenuItem
        '
        Me.OverviewToolStripMenuItem.Name = "OverviewToolStripMenuItem"
        Me.OverviewToolStripMenuItem.Size = New System.Drawing.Size(131, 22)
        Me.OverviewToolStripMenuItem.Text = "Overzicht"
        '
        'SaveToolStripMenuItem
        '
        Me.SaveToolStripMenuItem.Name = "SaveToolStripMenuItem"
        Me.SaveToolStripMenuItem.Size = New System.Drawing.Size(131, 22)
        Me.SaveToolStripMenuItem.Text = "Opslaan"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(131, 22)
        Me.ExitToolStripMenuItem.Text = "Sluiten"
        '
        'cboDeelnameStudent
        '
        Me.cboDeelnameStudent.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboDeelnameStudent.FormattingEnabled = True
        Me.cboDeelnameStudent.Location = New System.Drawing.Point(98, 22)
        Me.cboDeelnameStudent.Name = "cboDeelnameStudent"
        Me.cboDeelnameStudent.Size = New System.Drawing.Size(168, 21)
        Me.cboDeelnameStudent.TabIndex = 1
        '
        'lblDeelnameStudent
        '
        Me.lblDeelnameStudent.AutoSize = True
        Me.lblDeelnameStudent.Location = New System.Drawing.Point(6, 25)
        Me.lblDeelnameStudent.Name = "lblDeelnameStudent"
        Me.lblDeelnameStudent.Size = New System.Drawing.Size(44, 13)
        Me.lblDeelnameStudent.TabIndex = 2
        Me.lblDeelnameStudent.Text = "Student"
        '
        'cboDeelnameSport
        '
        Me.cboDeelnameSport.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboDeelnameSport.FormattingEnabled = True
        Me.cboDeelnameSport.Location = New System.Drawing.Point(98, 50)
        Me.cboDeelnameSport.Name = "cboDeelnameSport"
        Me.cboDeelnameSport.Size = New System.Drawing.Size(168, 21)
        Me.cboDeelnameSport.TabIndex = 3
        '
        'lblDeelnameSport
        '
        Me.lblDeelnameSport.AutoSize = True
        Me.lblDeelnameSport.Location = New System.Drawing.Point(6, 53)
        Me.lblDeelnameSport.Name = "lblDeelnameSport"
        Me.lblDeelnameSport.Size = New System.Drawing.Size(32, 13)
        Me.lblDeelnameSport.TabIndex = 4
        Me.lblDeelnameSport.Text = "Sport"
        '
        'txtNiveau
        '
        Me.txtNiveau.Location = New System.Drawing.Point(98, 111)
        Me.txtNiveau.Name = "txtNiveau"
        Me.txtNiveau.Size = New System.Drawing.Size(168, 20)
        Me.txtNiveau.TabIndex = 5
        '
        'lblNiveau
        '
        Me.lblNiveau.AutoSize = True
        Me.lblNiveau.Location = New System.Drawing.Point(6, 114)
        Me.lblNiveau.Name = "lblNiveau"
        Me.lblNiveau.Size = New System.Drawing.Size(74, 13)
        Me.lblNiveau.TabIndex = 6
        Me.lblNiveau.Text = "Nieuw Niveau"
        '
        'cboNiveau
        '
        Me.cboNiveau.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboNiveau.FormattingEnabled = True
        Me.cboNiveau.Location = New System.Drawing.Point(98, 77)
        Me.cboNiveau.Name = "cboNiveau"
        Me.cboNiveau.Size = New System.Drawing.Size(168, 21)
        Me.cboNiveau.TabIndex = 7
        '
        'lblNiveauCombo
        '
        Me.lblNiveauCombo.AutoSize = True
        Me.lblNiveauCombo.Location = New System.Drawing.Point(6, 80)
        Me.lblNiveauCombo.Name = "lblNiveauCombo"
        Me.lblNiveauCombo.Size = New System.Drawing.Size(41, 13)
        Me.lblNiveauCombo.TabIndex = 8
        Me.lblNiveauCombo.Text = "Niveau"
        '
        'btnOpslaan
        '
        Me.btnOpslaan.Location = New System.Drawing.Point(272, 108)
        Me.btnOpslaan.Name = "btnOpslaan"
        Me.btnOpslaan.Size = New System.Drawing.Size(57, 24)
        Me.btnOpslaan.TabIndex = 9
        Me.btnOpslaan.Text = "Opslaan"
        Me.btnOpslaan.UseVisualStyleBackColor = True
        '
        'grpNieuweDeelname
        '
        Me.grpNieuweDeelname.Controls.Add(Me.lblDeelnameStudent)
        Me.grpNieuweDeelname.Controls.Add(Me.btnOpslaan)
        Me.grpNieuweDeelname.Controls.Add(Me.lblNiveau)
        Me.grpNieuweDeelname.Controls.Add(Me.cboDeelnameStudent)
        Me.grpNieuweDeelname.Controls.Add(Me.txtNiveau)
        Me.grpNieuweDeelname.Controls.Add(Me.lblNiveauCombo)
        Me.grpNieuweDeelname.Controls.Add(Me.lblDeelnameSport)
        Me.grpNieuweDeelname.Controls.Add(Me.cboNiveau)
        Me.grpNieuweDeelname.Controls.Add(Me.cboDeelnameSport)
        Me.grpNieuweDeelname.Location = New System.Drawing.Point(17, 51)
        Me.grpNieuweDeelname.Name = "grpNieuweDeelname"
        Me.grpNieuweDeelname.Size = New System.Drawing.Size(482, 143)
        Me.grpNieuweDeelname.TabIndex = 10
        Me.grpNieuweDeelname.TabStop = False
        Me.grpNieuweDeelname.Text = "Voeg Deelname Toe"
        '
        'frmDeelname
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.grpNieuweDeelname)
        Me.Controls.Add(Me.mnuDeelnameBeheer)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MainMenuStrip = Me.mnuDeelnameBeheer
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmDeelname"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Deelnamebeheer"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.mnuDeelnameBeheer.ResumeLayout(False)
        Me.mnuDeelnameBeheer.PerformLayout()
        Me.grpNieuweDeelname.ResumeLayout(False)
        Me.grpNieuweDeelname.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents mnuDeelnameBeheer As System.Windows.Forms.MenuStrip
    Friend WithEvents BeheerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OverviewToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SaveToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents cboDeelnameStudent As System.Windows.Forms.ComboBox
    Friend WithEvents lblDeelnameStudent As System.Windows.Forms.Label
    Friend WithEvents cboDeelnameSport As System.Windows.Forms.ComboBox
    Friend WithEvents lblDeelnameSport As System.Windows.Forms.Label
    Friend WithEvents txtNiveau As System.Windows.Forms.TextBox
    Friend WithEvents lblNiveau As System.Windows.Forms.Label
    Friend WithEvents cboNiveau As System.Windows.Forms.ComboBox
    Friend WithEvents lblNiveauCombo As System.Windows.Forms.Label
    Friend WithEvents btnOpslaan As System.Windows.Forms.Button
    Friend WithEvents grpNieuweDeelname As System.Windows.Forms.GroupBox
End Class
