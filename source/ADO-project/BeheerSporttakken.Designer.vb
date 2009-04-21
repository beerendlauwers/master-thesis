<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class BeheerSporttakken
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
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.BeheerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DetailsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.NewToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DeleteToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.SaveToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.CancelToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.lblNaam = New System.Windows.Forms.Label
        Me.txtSportNaam = New System.Windows.Forms.TextBox
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'cboSporttak
        '
        Me.cboSporttak.FormattingEnabled = True
        Me.cboSporttak.Location = New System.Drawing.Point(151, 53)
        Me.cboSporttak.Name = "cboSporttak"
        Me.cboSporttak.Size = New System.Drawing.Size(121, 21)
        Me.cboSporttak.TabIndex = 0
        '
        'lblSporttak
        '
        Me.lblSporttak.AutoSize = True
        Me.lblSporttak.Location = New System.Drawing.Point(27, 56)
        Me.lblSporttak.Name = "lblSporttak"
        Me.lblSporttak.Size = New System.Drawing.Size(50, 13)
        Me.lblSporttak.TabIndex = 1
        Me.lblSporttak.Text = "Sporttak:"
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BeheerToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(284, 24)
        Me.MenuStrip1.TabIndex = 2
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'BeheerToolStripMenuItem
        '
        Me.BeheerToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DetailsToolStripMenuItem, Me.NewToolStripMenuItem, Me.EditToolStripMenuItem, Me.DeleteToolStripMenuItem, Me.SaveToolStripMenuItem, Me.CancelToolStripMenuItem, Me.ExitToolStripMenuItem})
        Me.BeheerToolStripMenuItem.Name = "BeheerToolStripMenuItem"
        Me.BeheerToolStripMenuItem.Size = New System.Drawing.Size(53, 20)
        Me.BeheerToolStripMenuItem.Text = "Beheer"
        '
        'DetailsToolStripMenuItem
        '
        Me.DetailsToolStripMenuItem.Name = "DetailsToolStripMenuItem"
        Me.DetailsToolStripMenuItem.Size = New System.Drawing.Size(117, 22)
        Me.DetailsToolStripMenuItem.Text = "Detail"
        '
        'NewToolStripMenuItem
        '
        Me.NewToolStripMenuItem.Name = "NewToolStripMenuItem"
        Me.NewToolStripMenuItem.Size = New System.Drawing.Size(117, 22)
        Me.NewToolStripMenuItem.Text = "New"
        '
        'EditToolStripMenuItem
        '
        Me.EditToolStripMenuItem.Name = "EditToolStripMenuItem"
        Me.EditToolStripMenuItem.Size = New System.Drawing.Size(117, 22)
        Me.EditToolStripMenuItem.Text = "Edit"
        '
        'DeleteToolStripMenuItem
        '
        Me.DeleteToolStripMenuItem.Name = "DeleteToolStripMenuItem"
        Me.DeleteToolStripMenuItem.Size = New System.Drawing.Size(117, 22)
        Me.DeleteToolStripMenuItem.Text = "Delete"
        '
        'SaveToolStripMenuItem
        '
        Me.SaveToolStripMenuItem.Name = "SaveToolStripMenuItem"
        Me.SaveToolStripMenuItem.Size = New System.Drawing.Size(117, 22)
        Me.SaveToolStripMenuItem.Text = "Save"
        '
        'CancelToolStripMenuItem
        '
        Me.CancelToolStripMenuItem.Name = "CancelToolStripMenuItem"
        Me.CancelToolStripMenuItem.Size = New System.Drawing.Size(117, 22)
        Me.CancelToolStripMenuItem.Text = "Cancel"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(117, 22)
        Me.ExitToolStripMenuItem.Text = "Exit"
        '
        'lblNaam
        '
        Me.lblNaam.AutoSize = True
        Me.lblNaam.Location = New System.Drawing.Point(27, 94)
        Me.lblNaam.Name = "lblNaam"
        Me.lblNaam.Size = New System.Drawing.Size(38, 13)
        Me.lblNaam.TabIndex = 3
        Me.lblNaam.Text = "Naam:"
        '
        'txtSportNaam
        '
        Me.txtSportNaam.Location = New System.Drawing.Point(151, 94)
        Me.txtSportNaam.Name = "txtSportNaam"
        Me.txtSportNaam.Size = New System.Drawing.Size(121, 20)
        Me.txtSportNaam.TabIndex = 4
        '
        'BeheerSporttakken
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(284, 264)
        Me.Controls.Add(Me.txtSportNaam)
        Me.Controls.Add(Me.lblNaam)
        Me.Controls.Add(Me.lblSporttak)
        Me.Controls.Add(Me.cboSporttak)
        Me.Controls.Add(Me.MenuStrip1)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "BeheerSporttakken"
        Me.Text = "BeheerSporttakken"
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents cboSporttak As System.Windows.Forms.ComboBox
    Friend WithEvents lblSporttak As System.Windows.Forms.Label
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents BeheerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DetailsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents NewToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents EditToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SaveToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CancelToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents lblNaam As System.Windows.Forms.Label
    Friend WithEvents txtSportNaam As System.Windows.Forms.TextBox
End Class
