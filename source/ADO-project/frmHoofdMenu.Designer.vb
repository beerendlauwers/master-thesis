<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmHoofdMenu
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
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.StudentenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.StudentenToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem
        Me.SporttakkenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DeelnameToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.StudentenToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(516, 24)
        Me.MenuStrip1.TabIndex = 0
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'StudentenToolStripMenuItem
        '
        Me.StudentenToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.StudentenToolStripMenuItem1, Me.SporttakkenToolStripMenuItem, Me.DeelnameToolStripMenuItem})
        Me.StudentenToolStripMenuItem.Name = "StudentenToolStripMenuItem"
        Me.StudentenToolStripMenuItem.Size = New System.Drawing.Size(58, 20)
        Me.StudentenToolStripMenuItem.Text = "Bestand"
        '
        'StudentenToolStripMenuItem1
        '
        Me.StudentenToolStripMenuItem1.Name = "StudentenToolStripMenuItem1"
        Me.StudentenToolStripMenuItem1.Size = New System.Drawing.Size(142, 22)
        Me.StudentenToolStripMenuItem1.Text = "Studenten"
        '
        'SporttakkenToolStripMenuItem
        '
        Me.SporttakkenToolStripMenuItem.Name = "SporttakkenToolStripMenuItem"
        Me.SporttakkenToolStripMenuItem.Size = New System.Drawing.Size(142, 22)
        Me.SporttakkenToolStripMenuItem.Text = "sporttakken"
        '
        'DeelnameToolStripMenuItem
        '
        Me.DeelnameToolStripMenuItem.Name = "DeelnameToolStripMenuItem"
        Me.DeelnameToolStripMenuItem.Size = New System.Drawing.Size(142, 22)
        Me.DeelnameToolStripMenuItem.Text = "deelname"
        '
        'frmHoofdMenu
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(516, 529)
        Me.Controls.Add(Me.MenuStrip1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.IsMdiContainer = True
        Me.MainMenuStrip = Me.MenuStrip1
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmHoofdMenu"
        Me.Text = "frmHoofdMenu"
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents StudentenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents StudentenToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SporttakkenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeelnameToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
