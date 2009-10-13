<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmConnecteerMetMySQL
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
        Me.grpMySQL = New System.Windows.Forms.GroupBox
        Me.lblMySQLDatabase = New System.Windows.Forms.Label
        Me.txtMySQLDatabase = New System.Windows.Forms.TextBox
        Me.picConnectieGeldig = New System.Windows.Forms.PictureBox
        Me.txtMySQLServer = New System.Windows.Forms.TextBox
        Me.lblConnectieGeldig = New System.Windows.Forms.Label
        Me.lblMySQLServer = New System.Windows.Forms.Label
        Me.lblMySQLGebruiker = New System.Windows.Forms.Label
        Me.lblMySQLPaswoord = New System.Windows.Forms.Label
        Me.txtMySQLGebruiker = New System.Windows.Forms.TextBox
        Me.txtMySQLPaswoord = New System.Windows.Forms.TextBox
        Me.txtMySQLKolom = New System.Windows.Forms.TextBox
        Me.lblMySQLTabel = New System.Windows.Forms.Label
        Me.txtMySQLTabel = New System.Windows.Forms.TextBox
        Me.lblMySQLKolom = New System.Windows.Forms.Label
        Me.btnDataInvoegen = New System.Windows.Forms.Button
        Me.lstTestData = New System.Windows.Forms.ListBox
        Me.txtDataInvoer = New System.Windows.Forms.TextBox
        Me.lblVoegTestDataToe = New System.Windows.Forms.Label
        Me.grpData = New System.Windows.Forms.GroupBox
        Me.picOphaalGeldig = New System.Windows.Forms.PictureBox
        Me.dtgDataMySQL = New System.Windows.Forms.DataGridView
        Me.lblOphaalGeldig = New System.Windows.Forms.Label
        Me.mnuMenu = New System.Windows.Forms.MenuStrip
        Me.SluitenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.btnDataToevoegen = New System.Windows.Forms.Button
        Me.grpMySQL.SuspendLayout()
        CType(Me.picConnectieGeldig, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.grpData.SuspendLayout()
        CType(Me.picOphaalGeldig, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dtgDataMySQL, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.mnuMenu.SuspendLayout()
        Me.SuspendLayout()
        '
        'grpMySQL
        '
        Me.grpMySQL.Controls.Add(Me.lblMySQLDatabase)
        Me.grpMySQL.Controls.Add(Me.txtMySQLDatabase)
        Me.grpMySQL.Controls.Add(Me.picConnectieGeldig)
        Me.grpMySQL.Controls.Add(Me.txtMySQLServer)
        Me.grpMySQL.Controls.Add(Me.lblConnectieGeldig)
        Me.grpMySQL.Controls.Add(Me.lblMySQLServer)
        Me.grpMySQL.Controls.Add(Me.lblMySQLGebruiker)
        Me.grpMySQL.Controls.Add(Me.lblMySQLPaswoord)
        Me.grpMySQL.Controls.Add(Me.txtMySQLGebruiker)
        Me.grpMySQL.Controls.Add(Me.txtMySQLPaswoord)
        Me.grpMySQL.Controls.Add(Me.txtMySQLKolom)
        Me.grpMySQL.Controls.Add(Me.lblMySQLTabel)
        Me.grpMySQL.Controls.Add(Me.txtMySQLTabel)
        Me.grpMySQL.Controls.Add(Me.lblMySQLKolom)
        Me.grpMySQL.Location = New System.Drawing.Point(12, 42)
        Me.grpMySQL.Name = "grpMySQL"
        Me.grpMySQL.Size = New System.Drawing.Size(482, 206)
        Me.grpMySQL.TabIndex = 19
        Me.grpMySQL.TabStop = False
        Me.grpMySQL.Text = "Details MySQL-connectie"
        '
        'lblMySQLDatabase
        '
        Me.lblMySQLDatabase.AutoSize = True
        Me.lblMySQLDatabase.Location = New System.Drawing.Point(6, 68)
        Me.lblMySQLDatabase.Name = "lblMySQLDatabase"
        Me.lblMySQLDatabase.Size = New System.Drawing.Size(56, 13)
        Me.lblMySQLDatabase.TabIndex = 34
        Me.lblMySQLDatabase.Text = "Database:"
        '
        'txtMySQLDatabase
        '
        Me.txtMySQLDatabase.Location = New System.Drawing.Point(68, 68)
        Me.txtMySQLDatabase.Name = "txtMySQLDatabase"
        Me.txtMySQLDatabase.Size = New System.Drawing.Size(290, 20)
        Me.txtMySQLDatabase.TabIndex = 35
        '
        'picConnectieGeldig
        '
        Me.picConnectieGeldig.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.picConnectieGeldig.Location = New System.Drawing.Point(404, 185)
        Me.picConnectieGeldig.Name = "picConnectieGeldig"
        Me.picConnectieGeldig.Size = New System.Drawing.Size(17, 14)
        Me.picConnectieGeldig.TabIndex = 33
        Me.picConnectieGeldig.TabStop = False
        '
        'txtMySQLServer
        '
        Me.txtMySQLServer.Location = New System.Drawing.Point(9, 42)
        Me.txtMySQLServer.MaxLength = 100
        Me.txtMySQLServer.Name = "txtMySQLServer"
        Me.txtMySQLServer.Size = New System.Drawing.Size(467, 20)
        Me.txtMySQLServer.TabIndex = 1
        '
        'lblConnectieGeldig
        '
        Me.lblConnectieGeldig.AutoSize = True
        Me.lblConnectieGeldig.ForeColor = System.Drawing.Color.Firebrick
        Me.lblConnectieGeldig.Location = New System.Drawing.Point(427, 185)
        Me.lblConnectieGeldig.Name = "lblConnectieGeldig"
        Me.lblConnectieGeldig.Size = New System.Drawing.Size(49, 13)
        Me.lblConnectieGeldig.TabIndex = 32
        Me.lblConnectieGeldig.Text = "Ongeldig"
        '
        'lblMySQLServer
        '
        Me.lblMySQLServer.AutoSize = True
        Me.lblMySQLServer.Location = New System.Drawing.Point(6, 26)
        Me.lblMySQLServer.Name = "lblMySQLServer"
        Me.lblMySQLServer.Size = New System.Drawing.Size(79, 13)
        Me.lblMySQLServer.TabIndex = 2
        Me.lblMySQLServer.Text = "MySQL Server:"
        '
        'lblMySQLGebruiker
        '
        Me.lblMySQLGebruiker.AutoSize = True
        Me.lblMySQLGebruiker.Location = New System.Drawing.Point(6, 93)
        Me.lblMySQLGebruiker.Name = "lblMySQLGebruiker"
        Me.lblMySQLGebruiker.Size = New System.Drawing.Size(56, 13)
        Me.lblMySQLGebruiker.TabIndex = 6
        Me.lblMySQLGebruiker.Text = "Gebruiker:"
        '
        'lblMySQLPaswoord
        '
        Me.lblMySQLPaswoord.AutoSize = True
        Me.lblMySQLPaswoord.Location = New System.Drawing.Point(5, 119)
        Me.lblMySQLPaswoord.Name = "lblMySQLPaswoord"
        Me.lblMySQLPaswoord.Size = New System.Drawing.Size(57, 13)
        Me.lblMySQLPaswoord.TabIndex = 7
        Me.lblMySQLPaswoord.Text = "Paswoord:"
        '
        'txtMySQLGebruiker
        '
        Me.txtMySQLGebruiker.Location = New System.Drawing.Point(68, 93)
        Me.txtMySQLGebruiker.Name = "txtMySQLGebruiker"
        Me.txtMySQLGebruiker.Size = New System.Drawing.Size(290, 20)
        Me.txtMySQLGebruiker.TabIndex = 8
        '
        'txtMySQLPaswoord
        '
        Me.txtMySQLPaswoord.Location = New System.Drawing.Point(68, 119)
        Me.txtMySQLPaswoord.Name = "txtMySQLPaswoord"
        Me.txtMySQLPaswoord.Size = New System.Drawing.Size(290, 20)
        Me.txtMySQLPaswoord.TabIndex = 9
        Me.txtMySQLPaswoord.UseSystemPasswordChar = True
        '
        'txtMySQLKolom
        '
        Me.txtMySQLKolom.Location = New System.Drawing.Point(68, 171)
        Me.txtMySQLKolom.Name = "txtMySQLKolom"
        Me.txtMySQLKolom.Size = New System.Drawing.Size(290, 20)
        Me.txtMySQLKolom.TabIndex = 13
        '
        'lblMySQLTabel
        '
        Me.lblMySQLTabel.AutoSize = True
        Me.lblMySQLTabel.Location = New System.Drawing.Point(6, 145)
        Me.lblMySQLTabel.Name = "lblMySQLTabel"
        Me.lblMySQLTabel.Size = New System.Drawing.Size(37, 13)
        Me.lblMySQLTabel.TabIndex = 10
        Me.lblMySQLTabel.Text = "Tabel:"
        '
        'txtMySQLTabel
        '
        Me.txtMySQLTabel.Location = New System.Drawing.Point(68, 145)
        Me.txtMySQLTabel.Name = "txtMySQLTabel"
        Me.txtMySQLTabel.Size = New System.Drawing.Size(290, 20)
        Me.txtMySQLTabel.TabIndex = 12
        '
        'lblMySQLKolom
        '
        Me.lblMySQLKolom.AutoSize = True
        Me.lblMySQLKolom.Location = New System.Drawing.Point(5, 171)
        Me.lblMySQLKolom.Name = "lblMySQLKolom"
        Me.lblMySQLKolom.Size = New System.Drawing.Size(39, 13)
        Me.lblMySQLKolom.TabIndex = 11
        Me.lblMySQLKolom.Text = "Kolom:"
        '
        'btnDataInvoegen
        '
        Me.btnDataInvoegen.Enabled = False
        Me.btnDataInvoegen.Location = New System.Drawing.Point(6, 197)
        Me.btnDataInvoegen.Name = "btnDataInvoegen"
        Me.btnDataInvoegen.Size = New System.Drawing.Size(120, 21)
        Me.btnDataInvoegen.TabIndex = 5
        Me.btnDataInvoegen.Text = "Invoegen En Ophalen"
        Me.btnDataInvoegen.UseVisualStyleBackColor = True
        '
        'lstTestData
        '
        Me.lstTestData.FormattingEnabled = True
        Me.lstTestData.Location = New System.Drawing.Point(11, 61)
        Me.lstTestData.Name = "lstTestData"
        Me.lstTestData.Size = New System.Drawing.Size(106, 134)
        Me.lstTestData.TabIndex = 20
        '
        'txtDataInvoer
        '
        Me.txtDataInvoer.Location = New System.Drawing.Point(5, 35)
        Me.txtDataInvoer.MaxLength = 50
        Me.txtDataInvoer.Name = "txtDataInvoer"
        Me.txtDataInvoer.Size = New System.Drawing.Size(108, 20)
        Me.txtDataInvoer.TabIndex = 21
        '
        'lblVoegTestDataToe
        '
        Me.lblVoegTestDataToe.AutoSize = True
        Me.lblVoegTestDataToe.Location = New System.Drawing.Point(23, 19)
        Me.lblVoegTestDataToe.Name = "lblVoegTestDataToe"
        Me.lblVoegTestDataToe.Size = New System.Drawing.Size(83, 13)
        Me.lblVoegTestDataToe.TabIndex = 34
        Me.lblVoegTestDataToe.Text = "Voeg Data Toe:"
        '
        'grpData
        '
        Me.grpData.Controls.Add(Me.btnDataToevoegen)
        Me.grpData.Controls.Add(Me.picOphaalGeldig)
        Me.grpData.Controls.Add(Me.dtgDataMySQL)
        Me.grpData.Controls.Add(Me.lblOphaalGeldig)
        Me.grpData.Controls.Add(Me.lblVoegTestDataToe)
        Me.grpData.Controls.Add(Me.btnDataInvoegen)
        Me.grpData.Controls.Add(Me.txtDataInvoer)
        Me.grpData.Controls.Add(Me.lstTestData)
        Me.grpData.Location = New System.Drawing.Point(12, 264)
        Me.grpData.Name = "grpData"
        Me.grpData.Size = New System.Drawing.Size(482, 218)
        Me.grpData.TabIndex = 35
        Me.grpData.TabStop = False
        Me.grpData.Text = "Details Data"
        '
        'picOphaalGeldig
        '
        Me.picOphaalGeldig.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.picOphaalGeldig.Location = New System.Drawing.Point(341, 200)
        Me.picOphaalGeldig.Name = "picOphaalGeldig"
        Me.picOphaalGeldig.Size = New System.Drawing.Size(17, 15)
        Me.picOphaalGeldig.TabIndex = 35
        Me.picOphaalGeldig.TabStop = False
        '
        'dtgDataMySQL
        '
        Me.dtgDataMySQL.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dtgDataMySQL.Location = New System.Drawing.Point(141, 18)
        Me.dtgDataMySQL.Name = "dtgDataMySQL"
        Me.dtgDataMySQL.Size = New System.Drawing.Size(325, 179)
        Me.dtgDataMySQL.TabIndex = 35
        '
        'lblOphaalGeldig
        '
        Me.lblOphaalGeldig.AutoSize = True
        Me.lblOphaalGeldig.ForeColor = System.Drawing.Color.Firebrick
        Me.lblOphaalGeldig.Location = New System.Drawing.Point(364, 200)
        Me.lblOphaalGeldig.Name = "lblOphaalGeldig"
        Me.lblOphaalGeldig.Size = New System.Drawing.Size(110, 13)
        Me.lblOphaalGeldig.TabIndex = 34
        Me.lblOphaalGeldig.Text = "Data Niet Opgehaald."
        '
        'mnuMenu
        '
        Me.mnuMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SluitenToolStripMenuItem})
        Me.mnuMenu.Location = New System.Drawing.Point(0, 0)
        Me.mnuMenu.Name = "mnuMenu"
        Me.mnuMenu.Size = New System.Drawing.Size(514, 24)
        Me.mnuMenu.TabIndex = 36
        Me.mnuMenu.Text = "MenuStrip1"
        '
        'SluitenToolStripMenuItem
        '
        Me.SluitenToolStripMenuItem.Name = "SluitenToolStripMenuItem"
        Me.SluitenToolStripMenuItem.Size = New System.Drawing.Size(51, 20)
        Me.SluitenToolStripMenuItem.Text = "Sluiten"
        '
        'btnDataToevoegen
        '
        Me.btnDataToevoegen.Location = New System.Drawing.Point(115, 34)
        Me.btnDataToevoegen.Name = "btnDataToevoegen"
        Me.btnDataToevoegen.Size = New System.Drawing.Size(19, 23)
        Me.btnDataToevoegen.TabIndex = 36
        Me.btnDataToevoegen.Text = "+"
        Me.btnDataToevoegen.UseVisualStyleBackColor = True
        '
        'frmConnecteerMetMySQL
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.mnuMenu)
        Me.Controls.Add(Me.grpData)
        Me.Controls.Add(Me.grpMySQL)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmConnecteerMetMySQL"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Verbind Met MySQL"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.grpMySQL.ResumeLayout(False)
        Me.grpMySQL.PerformLayout()
        CType(Me.picConnectieGeldig, System.ComponentModel.ISupportInitialize).EndInit()
        Me.grpData.ResumeLayout(False)
        Me.grpData.PerformLayout()
        CType(Me.picOphaalGeldig, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.dtgDataMySQL, System.ComponentModel.ISupportInitialize).EndInit()
        Me.mnuMenu.ResumeLayout(False)
        Me.mnuMenu.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents grpMySQL As System.Windows.Forms.GroupBox
    Friend WithEvents txtMySQLServer As System.Windows.Forms.TextBox
    Friend WithEvents lblMySQLServer As System.Windows.Forms.Label
    Friend WithEvents btnDataInvoegen As System.Windows.Forms.Button
    Friend WithEvents lblMySQLGebruiker As System.Windows.Forms.Label
    Friend WithEvents lblMySQLPaswoord As System.Windows.Forms.Label
    Friend WithEvents txtMySQLGebruiker As System.Windows.Forms.TextBox
    Friend WithEvents txtMySQLPaswoord As System.Windows.Forms.TextBox
    Friend WithEvents txtMySQLKolom As System.Windows.Forms.TextBox
    Friend WithEvents lblMySQLTabel As System.Windows.Forms.Label
    Friend WithEvents txtMySQLTabel As System.Windows.Forms.TextBox
    Friend WithEvents lblMySQLKolom As System.Windows.Forms.Label
    Friend WithEvents picConnectieGeldig As System.Windows.Forms.PictureBox
    Friend WithEvents lblConnectieGeldig As System.Windows.Forms.Label
    Friend WithEvents lstTestData As System.Windows.Forms.ListBox
    Friend WithEvents txtDataInvoer As System.Windows.Forms.TextBox
    Friend WithEvents lblVoegTestDataToe As System.Windows.Forms.Label
    Friend WithEvents grpData As System.Windows.Forms.GroupBox
    Friend WithEvents picOphaalGeldig As System.Windows.Forms.PictureBox
    Friend WithEvents dtgDataMySQL As System.Windows.Forms.DataGridView
    Friend WithEvents lblOphaalGeldig As System.Windows.Forms.Label
    Friend WithEvents mnuMenu As System.Windows.Forms.MenuStrip
    Friend WithEvents SluitenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents lblMySQLDatabase As System.Windows.Forms.Label
    Friend WithEvents txtMySQLDatabase As System.Windows.Forms.TextBox
    Friend WithEvents btnDataToevoegen As System.Windows.Forms.Button
End Class
