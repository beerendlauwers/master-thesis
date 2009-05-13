<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmExporteerNaarOracle
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
        Me.mnuMenu = New System.Windows.Forms.MenuStrip
        Me.SluitenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.txtOracleServer = New System.Windows.Forms.TextBox
        Me.lblOracleServer = New System.Windows.Forms.Label
        Me.lblOracleDatabase = New System.Windows.Forms.Label
        Me.txtOracleDatabase = New System.Windows.Forms.TextBox
        Me.btnTestConnectie = New System.Windows.Forms.Button
        Me.mnuMenu.SuspendLayout()
        Me.SuspendLayout()
        '
        'mnuMenu
        '
        Me.mnuMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SluitenToolStripMenuItem})
        Me.mnuMenu.Location = New System.Drawing.Point(0, 0)
        Me.mnuMenu.Name = "mnuMenu"
        Me.mnuMenu.Size = New System.Drawing.Size(514, 24)
        Me.mnuMenu.TabIndex = 0
        Me.mnuMenu.Text = "MenuStrip1"
        '
        'SluitenToolStripMenuItem
        '
        Me.SluitenToolStripMenuItem.Name = "SluitenToolStripMenuItem"
        Me.SluitenToolStripMenuItem.Size = New System.Drawing.Size(51, 20)
        Me.SluitenToolStripMenuItem.Text = "Sluiten"
        '
        'txtOracleServer
        '
        Me.txtOracleServer.Location = New System.Drawing.Point(43, 68)
        Me.txtOracleServer.Name = "txtOracleServer"
        Me.txtOracleServer.Size = New System.Drawing.Size(349, 20)
        Me.txtOracleServer.TabIndex = 1
        '
        'lblOracleServer
        '
        Me.lblOracleServer.AutoSize = True
        Me.lblOracleServer.Location = New System.Drawing.Point(40, 52)
        Me.lblOracleServer.Name = "lblOracleServer"
        Me.lblOracleServer.Size = New System.Drawing.Size(75, 13)
        Me.lblOracleServer.TabIndex = 2
        Me.lblOracleServer.Text = "Oracle Server:"
        '
        'lblOracleDatabase
        '
        Me.lblOracleDatabase.AutoSize = True
        Me.lblOracleDatabase.Location = New System.Drawing.Point(40, 102)
        Me.lblOracleDatabase.Name = "lblOracleDatabase"
        Me.lblOracleDatabase.Size = New System.Drawing.Size(90, 13)
        Me.lblOracleDatabase.TabIndex = 3
        Me.lblOracleDatabase.Text = "Oracle Database:"
        '
        'txtOracleDatabase
        '
        Me.txtOracleDatabase.Location = New System.Drawing.Point(43, 118)
        Me.txtOracleDatabase.Name = "txtOracleDatabase"
        Me.txtOracleDatabase.Size = New System.Drawing.Size(349, 20)
        Me.txtOracleDatabase.TabIndex = 4
        '
        'btnTestConnectie
        '
        Me.btnTestConnectie.Location = New System.Drawing.Point(418, 80)
        Me.btnTestConnectie.Name = "btnTestConnectie"
        Me.btnTestConnectie.Size = New System.Drawing.Size(75, 56)
        Me.btnTestConnectie.TabIndex = 5
        Me.btnTestConnectie.Text = "test connectie"
        Me.btnTestConnectie.UseVisualStyleBackColor = True
        '
        'frmExporteerNaarOracle
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.btnTestConnectie)
        Me.Controls.Add(Me.txtOracleDatabase)
        Me.Controls.Add(Me.lblOracleDatabase)
        Me.Controls.Add(Me.lblOracleServer)
        Me.Controls.Add(Me.txtOracleServer)
        Me.Controls.Add(Me.mnuMenu)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MainMenuStrip = Me.mnuMenu
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmExporteerNaarOracle"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Exporteer Naar Oracle"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.mnuMenu.ResumeLayout(False)
        Me.mnuMenu.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents mnuMenu As System.Windows.Forms.MenuStrip
    Friend WithEvents SluitenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents txtOracleServer As System.Windows.Forms.TextBox
    Friend WithEvents lblOracleServer As System.Windows.Forms.Label
    Friend WithEvents lblOracleDatabase As System.Windows.Forms.Label
    Friend WithEvents txtOracleDatabase As System.Windows.Forms.TextBox
    Friend WithEvents btnTestConnectie As System.Windows.Forms.Button
End Class
