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
        Me.mnuHoofdMenu = New System.Windows.Forms.MenuStrip
        Me.SuspendLayout()
        '
        'mnuHoofdMenu
        '
        Me.mnuHoofdMenu.Location = New System.Drawing.Point(0, 0)
        Me.mnuHoofdMenu.Name = "mnuHoofdMenu"
        Me.mnuHoofdMenu.Size = New System.Drawing.Size(516, 24)
        Me.mnuHoofdMenu.TabIndex = 0
        Me.mnuHoofdMenu.Text = "Hoofdmenu"
        '
        'frmHoofdMenu
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(516, 529)
        Me.Controls.Add(Me.mnuHoofdMenu)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.IsMdiContainer = True
        Me.MainMenuStrip = Me.mnuHoofdMenu
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmHoofdMenu"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "ADO"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents mnuHoofdMenu As System.Windows.Forms.MenuStrip

End Class
