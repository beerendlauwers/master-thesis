<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmVergelijkemails
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
        Me.lstEnkelAccess = New System.Windows.Forms.ListBox
        Me.lblText1 = New System.Windows.Forms.Label
        Me.lblText2 = New System.Windows.Forms.Label
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.SluitenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.lstEmailsAccess = New System.Windows.Forms.ListBox
        Me.lstEmailsSQL = New System.Windows.Forms.ListBox
        Me.lblEmailsAccess = New System.Windows.Forms.Label
        Me.lblEmailsSQL = New System.Windows.Forms.Label
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'lstEnkelAccess
        '
        Me.lstEnkelAccess.FormattingEnabled = True
        Me.lstEnkelAccess.Location = New System.Drawing.Point(134, 276)
        Me.lstEnkelAccess.Name = "lstEnkelAccess"
        Me.lstEnkelAccess.Size = New System.Drawing.Size(223, 238)
        Me.lstEnkelAccess.TabIndex = 0
        '
        'lblText1
        '
        Me.lblText1.AutoSize = True
        Me.lblText1.Location = New System.Drawing.Point(131, 238)
        Me.lblText1.Name = "lblText1"
        Me.lblText1.Size = New System.Drawing.Size(226, 13)
        Me.lblText1.TabIndex = 1
        Me.lblText1.Text = "De volgende E-mail adressen staan in Access,"
        '
        'lblText2
        '
        Me.lblText2.AutoSize = True
        Me.lblText2.Location = New System.Drawing.Point(180, 251)
        Me.lblText2.Name = "lblText2"
        Me.lblText2.Size = New System.Drawing.Size(128, 13)
        Me.lblText2.TabIndex = 2
        Me.lblText2.Text = "maar niet in MSSQL2005."
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SluitenToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(514, 24)
        Me.MenuStrip1.TabIndex = 3
        Me.MenuStrip1.Text = "mnuMenu"
        '
        'SluitenToolStripMenuItem
        '
        Me.SluitenToolStripMenuItem.Name = "SluitenToolStripMenuItem"
        Me.SluitenToolStripMenuItem.Size = New System.Drawing.Size(51, 20)
        Me.SluitenToolStripMenuItem.Text = "Sluiten"
        '
        'lstEmailsAccess
        '
        Me.lstEmailsAccess.FormattingEnabled = True
        Me.lstEmailsAccess.Location = New System.Drawing.Point(12, 53)
        Me.lstEmailsAccess.Name = "lstEmailsAccess"
        Me.lstEmailsAccess.Size = New System.Drawing.Size(223, 173)
        Me.lstEmailsAccess.TabIndex = 4
        '
        'lstEmailsSQL
        '
        Me.lstEmailsSQL.FormattingEnabled = True
        Me.lstEmailsSQL.Location = New System.Drawing.Point(279, 53)
        Me.lstEmailsSQL.Name = "lstEmailsSQL"
        Me.lstEmailsSQL.Size = New System.Drawing.Size(223, 173)
        Me.lstEmailsSQL.TabIndex = 5
        '
        'lblEmailsAccess
        '
        Me.lblEmailsAccess.AutoSize = True
        Me.lblEmailsAccess.Location = New System.Drawing.Point(12, 37)
        Me.lblEmailsAccess.Name = "lblEmailsAccess"
        Me.lblEmailsAccess.Size = New System.Drawing.Size(94, 13)
        Me.lblEmailsAccess.TabIndex = 6
        Me.lblEmailsAccess.Text = "Emails Uit Access:"
        '
        'lblEmailsSQL
        '
        Me.lblEmailsSQL.AutoSize = True
        Me.lblEmailsSQL.Location = New System.Drawing.Point(277, 37)
        Me.lblEmailsSQL.Name = "lblEmailsSQL"
        Me.lblEmailsSQL.Size = New System.Drawing.Size(80, 13)
        Me.lblEmailsSQL.TabIndex = 7
        Me.lblEmailsSQL.Text = "Emails Uit SQL:"
        '
        'frmVergelijkemails
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.lblEmailsSQL)
        Me.Controls.Add(Me.lblEmailsAccess)
        Me.Controls.Add(Me.lstEmailsSQL)
        Me.Controls.Add(Me.lstEmailsAccess)
        Me.Controls.Add(Me.lblText2)
        Me.Controls.Add(Me.lblText1)
        Me.Controls.Add(Me.lstEnkelAccess)
        Me.Controls.Add(Me.MenuStrip1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MainMenuStrip = Me.MenuStrip1
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmVergelijkemails"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Vergelijking E-mailadressen"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents lstEnkelAccess As System.Windows.Forms.ListBox
    Friend WithEvents lblText1 As System.Windows.Forms.Label
    Friend WithEvents lblText2 As System.Windows.Forms.Label
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents SluitenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents lstEmailsAccess As System.Windows.Forms.ListBox
    Friend WithEvents lstEmailsSQL As System.Windows.Forms.ListBox
    Friend WithEvents lblEmailsAccess As System.Windows.Forms.Label
    Friend WithEvents lblEmailsSQL As System.Windows.Forms.Label
End Class
