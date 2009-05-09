<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmBeheerSporttakken
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
        Me.cboSporttak = New System.Windows.Forms.ComboBox
        Me.lblSporttak = New System.Windows.Forms.Label
        Me.mnuBeheerSporttakken = New System.Windows.Forms.MenuStrip
        Me.BeheerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DetailToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.NewToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DeleteToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.SaveToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.CancelToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.lblNaam = New System.Windows.Forms.Label
        Me.txtSportNaam = New System.Windows.Forms.TextBox
        Me.grpSport = New System.Windows.Forms.GroupBox
        Me.picNaamGeldig = New System.Windows.Forms.PictureBox
        Me.lblNaamgeldig = New System.Windows.Forms.Label
        Me.mnuBeheerSporttakken.SuspendLayout()
        Me.grpSport.SuspendLayout()
        CType(Me.picNaamGeldig, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'cboSporttak
        '
        Me.cboSporttak.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboSporttak.FormattingEnabled = True
        Me.cboSporttak.Location = New System.Drawing.Point(98, 22)
        Me.cboSporttak.Name = "cboSporttak"
        Me.cboSporttak.Size = New System.Drawing.Size(168, 21)
        Me.cboSporttak.TabIndex = 0
        '
        'lblSporttak
        '
        Me.lblSporttak.AutoSize = True
        Me.lblSporttak.Location = New System.Drawing.Point(6, 25)
        Me.lblSporttak.Name = "lblSporttak"
        Me.lblSporttak.Size = New System.Drawing.Size(50, 13)
        Me.lblSporttak.TabIndex = 1
        Me.lblSporttak.Text = "Sporttak:"
        '
        'mnuBeheerSporttakken
        '
        Me.mnuBeheerSporttakken.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BeheerToolStripMenuItem})
        Me.mnuBeheerSporttakken.Location = New System.Drawing.Point(0, 0)
        Me.mnuBeheerSporttakken.Name = "mnuBeheerSporttakken"
        Me.mnuBeheerSporttakken.Size = New System.Drawing.Size(514, 24)
        Me.mnuBeheerSporttakken.TabIndex = 2
        Me.mnuBeheerSporttakken.Text = "Sporttakkenbeheer"
        '
        'BeheerToolStripMenuItem
        '
        Me.BeheerToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DetailToolStripMenuItem, Me.NewToolStripMenuItem, Me.EditToolStripMenuItem, Me.DeleteToolStripMenuItem, Me.SaveToolStripMenuItem, Me.CancelToolStripMenuItem, Me.ExitToolStripMenuItem})
        Me.BeheerToolStripMenuItem.Name = "BeheerToolStripMenuItem"
        Me.BeheerToolStripMenuItem.Size = New System.Drawing.Size(53, 20)
        Me.BeheerToolStripMenuItem.Text = "Beheer"
        '
        'DetailToolStripMenuItem
        '
        Me.DetailToolStripMenuItem.Name = "DetailToolStripMenuItem"
        Me.DetailToolStripMenuItem.Size = New System.Drawing.Size(130, 22)
        Me.DetailToolStripMenuItem.Text = "Detail"
        '
        'NewToolStripMenuItem
        '
        Me.NewToolStripMenuItem.Name = "NewToolStripMenuItem"
        Me.NewToolStripMenuItem.Size = New System.Drawing.Size(130, 22)
        Me.NewToolStripMenuItem.Text = "Nieuw"
        '
        'EditToolStripMenuItem
        '
        Me.EditToolStripMenuItem.Name = "EditToolStripMenuItem"
        Me.EditToolStripMenuItem.Size = New System.Drawing.Size(130, 22)
        Me.EditToolStripMenuItem.Text = "Wijzig"
        '
        'DeleteToolStripMenuItem
        '
        Me.DeleteToolStripMenuItem.Name = "DeleteToolStripMenuItem"
        Me.DeleteToolStripMenuItem.Size = New System.Drawing.Size(130, 22)
        Me.DeleteToolStripMenuItem.Text = "Verwijder"
        '
        'SaveToolStripMenuItem
        '
        Me.SaveToolStripMenuItem.Name = "SaveToolStripMenuItem"
        Me.SaveToolStripMenuItem.Size = New System.Drawing.Size(130, 22)
        Me.SaveToolStripMenuItem.Text = "Opslaan"
        '
        'CancelToolStripMenuItem
        '
        Me.CancelToolStripMenuItem.Name = "CancelToolStripMenuItem"
        Me.CancelToolStripMenuItem.Size = New System.Drawing.Size(130, 22)
        Me.CancelToolStripMenuItem.Text = "Annuleer"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(130, 22)
        Me.ExitToolStripMenuItem.Text = "Sluiten"
        '
        'lblNaam
        '
        Me.lblNaam.AutoSize = True
        Me.lblNaam.Location = New System.Drawing.Point(6, 56)
        Me.lblNaam.Name = "lblNaam"
        Me.lblNaam.Size = New System.Drawing.Size(38, 13)
        Me.lblNaam.TabIndex = 3
        Me.lblNaam.Text = "Naam:"
        '
        'txtSportNaam
        '
        Me.txtSportNaam.Location = New System.Drawing.Point(98, 53)
        Me.txtSportNaam.MaxLength = 50
        Me.txtSportNaam.Name = "txtSportNaam"
        Me.txtSportNaam.Size = New System.Drawing.Size(168, 20)
        Me.txtSportNaam.TabIndex = 4
        '
        'grpSport
        '
        Me.grpSport.Controls.Add(Me.picNaamGeldig)
        Me.grpSport.Controls.Add(Me.lblSporttak)
        Me.grpSport.Controls.Add(Me.lblNaamgeldig)
        Me.grpSport.Controls.Add(Me.txtSportNaam)
        Me.grpSport.Controls.Add(Me.cboSporttak)
        Me.grpSport.Controls.Add(Me.lblNaam)
        Me.grpSport.Location = New System.Drawing.Point(17, 51)
        Me.grpSport.Name = "grpSport"
        Me.grpSport.Size = New System.Drawing.Size(482, 83)
        Me.grpSport.TabIndex = 11
        Me.grpSport.TabStop = False
        Me.grpSport.Text = "Sportbeheer"
        '
        'picNaamGeldig
        '
        Me.picNaamGeldig.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.picNaamGeldig.Location = New System.Drawing.Point(270, 56)
        Me.picNaamGeldig.Name = "picNaamGeldig"
        Me.picNaamGeldig.Size = New System.Drawing.Size(17, 14)
        Me.picNaamGeldig.TabIndex = 31
        Me.picNaamGeldig.TabStop = False
        '
        'lblNaamgeldig
        '
        Me.lblNaamgeldig.AutoSize = True
        Me.lblNaamgeldig.ForeColor = System.Drawing.Color.Firebrick
        Me.lblNaamgeldig.Location = New System.Drawing.Point(293, 56)
        Me.lblNaamgeldig.Name = "lblNaamgeldig"
        Me.lblNaamgeldig.Size = New System.Drawing.Size(80, 13)
        Me.lblNaamgeldig.TabIndex = 30
        Me.lblNaamgeldig.Text = "Naam Ongeldig"
        '
        'frmBeheerSporttakken
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.grpSport)
        Me.Controls.Add(Me.mnuBeheerSporttakken)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MainMenuStrip = Me.mnuBeheerSporttakken
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmBeheerSporttakken"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Sporttakbeheer"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.mnuBeheerSporttakken.ResumeLayout(False)
        Me.mnuBeheerSporttakken.PerformLayout()
        Me.grpSport.ResumeLayout(False)
        Me.grpSport.PerformLayout()
        CType(Me.picNaamGeldig, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents cboSporttak As System.Windows.Forms.ComboBox
    Friend WithEvents lblSporttak As System.Windows.Forms.Label
    Friend WithEvents mnuBeheerSporttakken As System.Windows.Forms.MenuStrip
    Friend WithEvents BeheerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DetailToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents NewToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents EditToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SaveToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CancelToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents lblNaam As System.Windows.Forms.Label
    Friend WithEvents txtSportNaam As System.Windows.Forms.TextBox
    Friend WithEvents grpSport As System.Windows.Forms.GroupBox
    Friend WithEvents picNaamGeldig As System.Windows.Forms.PictureBox
    Friend WithEvents lblNaamgeldig As System.Windows.Forms.Label
End Class
