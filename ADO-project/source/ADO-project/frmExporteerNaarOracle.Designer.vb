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
        Me.btnHaalDataOp = New System.Windows.Forms.Button
        Me.lblOracleGebruiker = New System.Windows.Forms.Label
        Me.lblOraclePaswoord = New System.Windows.Forms.Label
        Me.txtOracleGebruiker = New System.Windows.Forms.TextBox
        Me.txtOraclePaswoord = New System.Windows.Forms.TextBox
        Me.txtOracleKolom = New System.Windows.Forms.TextBox
        Me.txtOracleTabel = New System.Windows.Forms.TextBox
        Me.lblOracleKolom = New System.Windows.Forms.Label
        Me.lblOracleTabel = New System.Windows.Forms.Label
        Me.lstOracleData = New System.Windows.Forms.ListBox
        Me.lstSQLData = New System.Windows.Forms.ListBox
        Me.lstVerschil = New System.Windows.Forms.ListBox
        Me.btnImporteerOracle = New System.Windows.Forms.Button
        Me.grpOracle = New System.Windows.Forms.GroupBox
        Me.picDataOpgehaald = New System.Windows.Forms.PictureBox
        Me.lblDataOpgehaald = New System.Windows.Forms.Label
        Me.lblOracleData = New System.Windows.Forms.Label
        Me.lblSQLData = New System.Windows.Forms.Label
        Me.lblVerschil = New System.Windows.Forms.Label
        Me.mnuMenu.SuspendLayout()
        Me.grpOracle.SuspendLayout()
        CType(Me.picDataOpgehaald, System.ComponentModel.ISupportInitialize).BeginInit()
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
        Me.txtOracleServer.Location = New System.Drawing.Point(9, 42)
        Me.txtOracleServer.Name = "txtOracleServer"
        Me.txtOracleServer.Size = New System.Drawing.Size(349, 20)
        Me.txtOracleServer.TabIndex = 1
        '
        'lblOracleServer
        '
        Me.lblOracleServer.AutoSize = True
        Me.lblOracleServer.Location = New System.Drawing.Point(6, 26)
        Me.lblOracleServer.Name = "lblOracleServer"
        Me.lblOracleServer.Size = New System.Drawing.Size(75, 13)
        Me.lblOracleServer.TabIndex = 2
        Me.lblOracleServer.Text = "Oracle Server:"
        '
        'btnHaalDataOp
        '
        Me.btnHaalDataOp.Enabled = False
        Me.btnHaalDataOp.Location = New System.Drawing.Point(385, 42)
        Me.btnHaalDataOp.Name = "btnHaalDataOp"
        Me.btnHaalDataOp.Size = New System.Drawing.Size(75, 56)
        Me.btnHaalDataOp.TabIndex = 5
        Me.btnHaalDataOp.Text = "Haal Data Op"
        Me.btnHaalDataOp.UseVisualStyleBackColor = True
        '
        'lblOracleGebruiker
        '
        Me.lblOracleGebruiker.AutoSize = True
        Me.lblOracleGebruiker.Location = New System.Drawing.Point(6, 76)
        Me.lblOracleGebruiker.Name = "lblOracleGebruiker"
        Me.lblOracleGebruiker.Size = New System.Drawing.Size(56, 13)
        Me.lblOracleGebruiker.TabIndex = 6
        Me.lblOracleGebruiker.Text = "Gebruiker:"
        '
        'lblOraclePaswoord
        '
        Me.lblOraclePaswoord.AutoSize = True
        Me.lblOraclePaswoord.Location = New System.Drawing.Point(5, 102)
        Me.lblOraclePaswoord.Name = "lblOraclePaswoord"
        Me.lblOraclePaswoord.Size = New System.Drawing.Size(57, 13)
        Me.lblOraclePaswoord.TabIndex = 7
        Me.lblOraclePaswoord.Text = "Paswoord:"
        '
        'txtOracleGebruiker
        '
        Me.txtOracleGebruiker.Location = New System.Drawing.Point(68, 76)
        Me.txtOracleGebruiker.Name = "txtOracleGebruiker"
        Me.txtOracleGebruiker.Size = New System.Drawing.Size(290, 20)
        Me.txtOracleGebruiker.TabIndex = 8
        '
        'txtOraclePaswoord
        '
        Me.txtOraclePaswoord.Location = New System.Drawing.Point(68, 102)
        Me.txtOraclePaswoord.Name = "txtOraclePaswoord"
        Me.txtOraclePaswoord.Size = New System.Drawing.Size(290, 20)
        Me.txtOraclePaswoord.TabIndex = 9
        Me.txtOraclePaswoord.UseSystemPasswordChar = True
        '
        'txtOracleKolom
        '
        Me.txtOracleKolom.Location = New System.Drawing.Point(68, 154)
        Me.txtOracleKolom.Name = "txtOracleKolom"
        Me.txtOracleKolom.Size = New System.Drawing.Size(290, 20)
        Me.txtOracleKolom.TabIndex = 13
        '
        'txtOracleTabel
        '
        Me.txtOracleTabel.Location = New System.Drawing.Point(68, 128)
        Me.txtOracleTabel.Name = "txtOracleTabel"
        Me.txtOracleTabel.Size = New System.Drawing.Size(290, 20)
        Me.txtOracleTabel.TabIndex = 12
        '
        'lblOracleKolom
        '
        Me.lblOracleKolom.AutoSize = True
        Me.lblOracleKolom.Location = New System.Drawing.Point(5, 154)
        Me.lblOracleKolom.Name = "lblOracleKolom"
        Me.lblOracleKolom.Size = New System.Drawing.Size(39, 13)
        Me.lblOracleKolom.TabIndex = 11
        Me.lblOracleKolom.Text = "Kolom:"
        '
        'lblOracleTabel
        '
        Me.lblOracleTabel.AutoSize = True
        Me.lblOracleTabel.Location = New System.Drawing.Point(6, 128)
        Me.lblOracleTabel.Name = "lblOracleTabel"
        Me.lblOracleTabel.Size = New System.Drawing.Size(37, 13)
        Me.lblOracleTabel.TabIndex = 10
        Me.lblOracleTabel.Text = "Tabel:"
        '
        'lstOracleData
        '
        Me.lstOracleData.FormattingEnabled = True
        Me.lstOracleData.Location = New System.Drawing.Point(42, 256)
        Me.lstOracleData.Name = "lstOracleData"
        Me.lstOracleData.Size = New System.Drawing.Size(120, 95)
        Me.lstOracleData.TabIndex = 14
        '
        'lstSQLData
        '
        Me.lstSQLData.FormattingEnabled = True
        Me.lstSQLData.Location = New System.Drawing.Point(182, 256)
        Me.lstSQLData.Name = "lstSQLData"
        Me.lstSQLData.Size = New System.Drawing.Size(120, 95)
        Me.lstSQLData.TabIndex = 15
        '
        'lstVerschil
        '
        Me.lstVerschil.FormattingEnabled = True
        Me.lstVerschil.Location = New System.Drawing.Point(317, 256)
        Me.lstVerschil.Name = "lstVerschil"
        Me.lstVerschil.Size = New System.Drawing.Size(120, 95)
        Me.lstVerschil.TabIndex = 16
        '
        'btnImporteerOracle
        '
        Me.btnImporteerOracle.Enabled = False
        Me.btnImporteerOracle.Location = New System.Drawing.Point(310, 357)
        Me.btnImporteerOracle.Name = "btnImporteerOracle"
        Me.btnImporteerOracle.Size = New System.Drawing.Size(136, 23)
        Me.btnImporteerOracle.TabIndex = 17
        Me.btnImporteerOracle.Text = "Importeer In Oracle"
        Me.btnImporteerOracle.UseVisualStyleBackColor = True
        '
        'grpOracle
        '
        Me.grpOracle.Controls.Add(Me.txtOracleServer)
        Me.grpOracle.Controls.Add(Me.lblOracleServer)
        Me.grpOracle.Controls.Add(Me.btnHaalDataOp)
        Me.grpOracle.Controls.Add(Me.lblOracleGebruiker)
        Me.grpOracle.Controls.Add(Me.lblOraclePaswoord)
        Me.grpOracle.Controls.Add(Me.txtOracleGebruiker)
        Me.grpOracle.Controls.Add(Me.txtOraclePaswoord)
        Me.grpOracle.Controls.Add(Me.txtOracleKolom)
        Me.grpOracle.Controls.Add(Me.lblOracleTabel)
        Me.grpOracle.Controls.Add(Me.txtOracleTabel)
        Me.grpOracle.Controls.Add(Me.lblOracleKolom)
        Me.grpOracle.Location = New System.Drawing.Point(12, 42)
        Me.grpOracle.Name = "grpOracle"
        Me.grpOracle.Size = New System.Drawing.Size(482, 179)
        Me.grpOracle.TabIndex = 18
        Me.grpOracle.TabStop = False
        Me.grpOracle.Text = "Details Oracleconnectie"
        '
        'picDataOpgehaald
        '
        Me.picDataOpgehaald.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.picDataOpgehaald.Location = New System.Drawing.Point(343, 383)
        Me.picDataOpgehaald.Name = "picDataOpgehaald"
        Me.picDataOpgehaald.Size = New System.Drawing.Size(17, 14)
        Me.picDataOpgehaald.TabIndex = 31
        Me.picDataOpgehaald.TabStop = False
        '
        'lblDataOpgehaald
        '
        Me.lblDataOpgehaald.AutoSize = True
        Me.lblDataOpgehaald.ForeColor = System.Drawing.Color.Firebrick
        Me.lblDataOpgehaald.Location = New System.Drawing.Point(366, 383)
        Me.lblDataOpgehaald.Name = "lblDataOpgehaald"
        Me.lblDataOpgehaald.Size = New System.Drawing.Size(120, 13)
        Me.lblDataOpgehaald.TabIndex = 30
        Me.lblDataOpgehaald.Text = "Data Niet Geïmporteerd"
        '
        'lblOracleData
        '
        Me.lblOracleData.AutoSize = True
        Me.lblOracleData.Location = New System.Drawing.Point(39, 240)
        Me.lblOracleData.Name = "lblOracleData"
        Me.lblOracleData.Size = New System.Drawing.Size(92, 13)
        Me.lblOracleData.TabIndex = 32
        Me.lblOracleData.Text = "Sporten in Oracle:"
        '
        'lblSQLData
        '
        Me.lblSQLData.AutoSize = True
        Me.lblSQLData.Location = New System.Drawing.Point(179, 240)
        Me.lblSQLData.Name = "lblSQLData"
        Me.lblSQLData.Size = New System.Drawing.Size(82, 13)
        Me.lblSQLData.TabIndex = 33
        Me.lblSQLData.Text = "Sporten in SQL:"
        '
        'lblVerschil
        '
        Me.lblVerschil.AutoSize = True
        Me.lblVerschil.Location = New System.Drawing.Point(314, 240)
        Me.lblVerschil.Name = "lblVerschil"
        Me.lblVerschil.Size = New System.Drawing.Size(133, 13)
        Me.lblVerschil.TabIndex = 34
        Me.lblVerschil.Text = "Sporten nog niet in Oracle:"
        '
        'frmExporteerNaarOracle
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.lblVerschil)
        Me.Controls.Add(Me.lblSQLData)
        Me.Controls.Add(Me.lblOracleData)
        Me.Controls.Add(Me.picDataOpgehaald)
        Me.Controls.Add(Me.grpOracle)
        Me.Controls.Add(Me.lblDataOpgehaald)
        Me.Controls.Add(Me.btnImporteerOracle)
        Me.Controls.Add(Me.lstVerschil)
        Me.Controls.Add(Me.lstSQLData)
        Me.Controls.Add(Me.lstOracleData)
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
        Me.grpOracle.ResumeLayout(False)
        Me.grpOracle.PerformLayout()
        CType(Me.picDataOpgehaald, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents mnuMenu As System.Windows.Forms.MenuStrip
    Friend WithEvents SluitenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents txtOracleServer As System.Windows.Forms.TextBox
    Friend WithEvents lblOracleServer As System.Windows.Forms.Label
    Friend WithEvents btnHaalDataOp As System.Windows.Forms.Button
    Friend WithEvents lblOracleGebruiker As System.Windows.Forms.Label
    Friend WithEvents lblOraclePaswoord As System.Windows.Forms.Label
    Friend WithEvents txtOracleGebruiker As System.Windows.Forms.TextBox
    Friend WithEvents txtOraclePaswoord As System.Windows.Forms.TextBox
    Friend WithEvents txtOracleKolom As System.Windows.Forms.TextBox
    Friend WithEvents txtOracleTabel As System.Windows.Forms.TextBox
    Friend WithEvents lblOracleKolom As System.Windows.Forms.Label
    Friend WithEvents lblOracleTabel As System.Windows.Forms.Label
    Friend WithEvents lstOracleData As System.Windows.Forms.ListBox
    Friend WithEvents lstSQLData As System.Windows.Forms.ListBox
    Friend WithEvents lstVerschil As System.Windows.Forms.ListBox
    Friend WithEvents btnImporteerOracle As System.Windows.Forms.Button
    Friend WithEvents grpOracle As System.Windows.Forms.GroupBox
    Friend WithEvents picDataOpgehaald As System.Windows.Forms.PictureBox
    Friend WithEvents lblDataOpgehaald As System.Windows.Forms.Label
    Friend WithEvents lblOracleData As System.Windows.Forms.Label
    Friend WithEvents lblSQLData As System.Windows.Forms.Label
    Friend WithEvents lblVerschil As System.Windows.Forms.Label
End Class
