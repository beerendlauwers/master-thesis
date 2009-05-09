<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmNieuweDatabase
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
        Me.grpInstellingen = New System.Windows.Forms.GroupBox
        Me.btnDatabaseAanmaken = New System.Windows.Forms.Button
        Me.chkSQLOpslaan = New System.Windows.Forms.CheckBox
        Me.picSQLGeldig = New System.Windows.Forms.PictureBox
        Me.lblSQLGeldig = New System.Windows.Forms.Label
        Me.txtSQLPaswoord = New System.Windows.Forms.TextBox
        Me.txtSQLGebruiker = New System.Windows.Forms.TextBox
        Me.lblSQLPaswoord = New System.Windows.Forms.Label
        Me.lblSQLGebruiker = New System.Windows.Forms.Label
        Me.chkIntegratedSecurity = New System.Windows.Forms.CheckBox
        Me.txtSQLDatabase = New System.Windows.Forms.TextBox
        Me.lblSQLDatabase = New System.Windows.Forms.Label
        Me.lblSQLServer = New System.Windows.Forms.Label
        Me.txtSQLServer = New System.Windows.Forms.TextBox
        Me.mnuConfig = New System.Windows.Forms.MenuStrip
        Me.BeheerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OpenConfigToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ConfigOpslaanToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.LegenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.NieuweDatabaseAanleggenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.grpQueries = New System.Windows.Forms.GroupBox
        Me.btnPopuleerDatabase = New System.Windows.Forms.Button
        Me.picDataGevonden = New System.Windows.Forms.PictureBox
        Me.btnManueelExtraData = New System.Windows.Forms.Button
        Me.lblDataGevonden = New System.Windows.Forms.Label
        Me.txtExtraData = New System.Windows.Forms.TextBox
        Me.lblExtraData = New System.Windows.Forms.Label
        Me.btnManueelStartData = New System.Windows.Forms.Button
        Me.txtStartData = New System.Windows.Forms.TextBox
        Me.lblStartData = New System.Windows.Forms.Label
        Me.btnManeelStoredProcedures = New System.Windows.Forms.Button
        Me.txtStoredProcedures = New System.Windows.Forms.TextBox
        Me.lblStoredProcedures = New System.Windows.Forms.Label
        Me.picDatabaseGepopuleerd = New System.Windows.Forms.PictureBox
        Me.lblDatabaseGepopuleerd = New System.Windows.Forms.Label
        Me.grpInstellingen.SuspendLayout()
        CType(Me.picSQLGeldig, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.mnuConfig.SuspendLayout()
        Me.grpQueries.SuspendLayout()
        CType(Me.picDataGevonden, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.picDatabaseGepopuleerd, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'grpInstellingen
        '
        Me.grpInstellingen.Controls.Add(Me.btnDatabaseAanmaken)
        Me.grpInstellingen.Controls.Add(Me.chkSQLOpslaan)
        Me.grpInstellingen.Controls.Add(Me.picSQLGeldig)
        Me.grpInstellingen.Controls.Add(Me.lblSQLGeldig)
        Me.grpInstellingen.Controls.Add(Me.txtSQLPaswoord)
        Me.grpInstellingen.Controls.Add(Me.txtSQLGebruiker)
        Me.grpInstellingen.Controls.Add(Me.lblSQLPaswoord)
        Me.grpInstellingen.Controls.Add(Me.lblSQLGebruiker)
        Me.grpInstellingen.Controls.Add(Me.chkIntegratedSecurity)
        Me.grpInstellingen.Controls.Add(Me.txtSQLDatabase)
        Me.grpInstellingen.Controls.Add(Me.lblSQLDatabase)
        Me.grpInstellingen.Controls.Add(Me.lblSQLServer)
        Me.grpInstellingen.Controls.Add(Me.txtSQLServer)
        Me.grpInstellingen.Location = New System.Drawing.Point(12, 43)
        Me.grpInstellingen.Name = "grpInstellingen"
        Me.grpInstellingen.Size = New System.Drawing.Size(490, 191)
        Me.grpInstellingen.TabIndex = 4
        Me.grpInstellingen.TabStop = False
        Me.grpInstellingen.Text = "SQL-Server Instellingen"
        '
        'btnDatabaseAanmaken
        '
        Me.btnDatabaseAanmaken.Enabled = False
        Me.btnDatabaseAanmaken.Location = New System.Drawing.Point(407, 50)
        Me.btnDatabaseAanmaken.Name = "btnDatabaseAanmaken"
        Me.btnDatabaseAanmaken.Size = New System.Drawing.Size(75, 44)
        Me.btnDatabaseAanmaken.TabIndex = 15
        Me.btnDatabaseAanmaken.Text = "Database Aanmaken"
        Me.btnDatabaseAanmaken.UseVisualStyleBackColor = True
        '
        'chkSQLOpslaan
        '
        Me.chkSQLOpslaan.AutoSize = True
        Me.chkSQLOpslaan.Location = New System.Drawing.Point(6, 168)
        Me.chkSQLOpslaan.Name = "chkSQLOpslaan"
        Me.chkSQLOpslaan.Size = New System.Drawing.Size(134, 17)
        Me.chkSQLOpslaan.TabIndex = 12
        Me.chkSQLOpslaan.Text = "Opslaan in configuratie"
        Me.chkSQLOpslaan.UseVisualStyleBackColor = True
        '
        'picSQLGeldig
        '
        Me.picSQLGeldig.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.picSQLGeldig.Location = New System.Drawing.Point(411, 169)
        Me.picSQLGeldig.Name = "picSQLGeldig"
        Me.picSQLGeldig.Size = New System.Drawing.Size(17, 14)
        Me.picSQLGeldig.TabIndex = 11
        Me.picSQLGeldig.TabStop = False
        '
        'lblSQLGeldig
        '
        Me.lblSQLGeldig.AutoSize = True
        Me.lblSQLGeldig.ForeColor = System.Drawing.Color.Firebrick
        Me.lblSQLGeldig.Location = New System.Drawing.Point(434, 169)
        Me.lblSQLGeldig.Name = "lblSQLGeldig"
        Me.lblSQLGeldig.Size = New System.Drawing.Size(49, 13)
        Me.lblSQLGeldig.TabIndex = 10
        Me.lblSQLGeldig.Text = "Ongeldig"
        '
        'txtSQLPaswoord
        '
        Me.txtSQLPaswoord.Location = New System.Drawing.Point(77, 129)
        Me.txtSQLPaswoord.MaxLength = 128
        Me.txtSQLPaswoord.Name = "txtSQLPaswoord"
        Me.txtSQLPaswoord.Size = New System.Drawing.Size(240, 20)
        Me.txtSQLPaswoord.TabIndex = 9
        Me.txtSQLPaswoord.UseSystemPasswordChar = True
        '
        'txtSQLGebruiker
        '
        Me.txtSQLGebruiker.Location = New System.Drawing.Point(77, 101)
        Me.txtSQLGebruiker.MaxLength = 128
        Me.txtSQLGebruiker.Name = "txtSQLGebruiker"
        Me.txtSQLGebruiker.Size = New System.Drawing.Size(240, 20)
        Me.txtSQLGebruiker.TabIndex = 8
        '
        'lblSQLPaswoord
        '
        Me.lblSQLPaswoord.AutoSize = True
        Me.lblSQLPaswoord.Location = New System.Drawing.Point(6, 132)
        Me.lblSQLPaswoord.Name = "lblSQLPaswoord"
        Me.lblSQLPaswoord.Size = New System.Drawing.Size(57, 13)
        Me.lblSQLPaswoord.TabIndex = 7
        Me.lblSQLPaswoord.Text = "Paswoord:"
        '
        'lblSQLGebruiker
        '
        Me.lblSQLGebruiker.AutoSize = True
        Me.lblSQLGebruiker.Location = New System.Drawing.Point(6, 104)
        Me.lblSQLGebruiker.Name = "lblSQLGebruiker"
        Me.lblSQLGebruiker.Size = New System.Drawing.Size(56, 13)
        Me.lblSQLGebruiker.TabIndex = 6
        Me.lblSQLGebruiker.Text = "Gebruiker:"
        '
        'chkIntegratedSecurity
        '
        Me.chkIntegratedSecurity.AutoSize = True
        Me.chkIntegratedSecurity.Location = New System.Drawing.Point(27, 77)
        Me.chkIntegratedSecurity.Name = "chkIntegratedSecurity"
        Me.chkIntegratedSecurity.Size = New System.Drawing.Size(210, 17)
        Me.chkIntegratedSecurity.TabIndex = 5
        Me.chkIntegratedSecurity.Text = "Inloggen met geîntegreerde beveiliging"
        Me.chkIntegratedSecurity.UseVisualStyleBackColor = True
        '
        'txtSQLDatabase
        '
        Me.txtSQLDatabase.Enabled = False
        Me.txtSQLDatabase.Location = New System.Drawing.Point(77, 51)
        Me.txtSQLDatabase.Name = "txtSQLDatabase"
        Me.txtSQLDatabase.Size = New System.Drawing.Size(324, 20)
        Me.txtSQLDatabase.TabIndex = 4
        '
        'lblSQLDatabase
        '
        Me.lblSQLDatabase.AutoSize = True
        Me.lblSQLDatabase.Location = New System.Drawing.Point(6, 54)
        Me.lblSQLDatabase.Name = "lblSQLDatabase"
        Me.lblSQLDatabase.Size = New System.Drawing.Size(56, 13)
        Me.lblSQLDatabase.TabIndex = 3
        Me.lblSQLDatabase.Text = "Database:"
        '
        'lblSQLServer
        '
        Me.lblSQLServer.AutoSize = True
        Me.lblSQLServer.Location = New System.Drawing.Point(6, 25)
        Me.lblSQLServer.Name = "lblSQLServer"
        Me.lblSQLServer.Size = New System.Drawing.Size(65, 13)
        Me.lblSQLServer.TabIndex = 2
        Me.lblSQLServer.Text = "SQL-Server:"
        '
        'txtSQLServer
        '
        Me.txtSQLServer.Location = New System.Drawing.Point(77, 22)
        Me.txtSQLServer.Name = "txtSQLServer"
        Me.txtSQLServer.Size = New System.Drawing.Size(407, 20)
        Me.txtSQLServer.TabIndex = 1
        '
        'mnuConfig
        '
        Me.mnuConfig.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BeheerToolStripMenuItem, Me.NieuweDatabaseAanleggenToolStripMenuItem})
        Me.mnuConfig.Location = New System.Drawing.Point(0, 0)
        Me.mnuConfig.Name = "mnuConfig"
        Me.mnuConfig.Size = New System.Drawing.Size(514, 24)
        Me.mnuConfig.TabIndex = 5
        Me.mnuConfig.Text = "Configuratie"
        '
        'BeheerToolStripMenuItem
        '
        Me.BeheerToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OpenConfigToolStripMenuItem, Me.ConfigOpslaanToolStripMenuItem, Me.LegenToolStripMenuItem})
        Me.BeheerToolStripMenuItem.Name = "BeheerToolStripMenuItem"
        Me.BeheerToolStripMenuItem.Size = New System.Drawing.Size(50, 20)
        Me.BeheerToolStripMenuItem.Text = "Config"
        '
        'OpenConfigToolStripMenuItem
        '
        Me.OpenConfigToolStripMenuItem.Name = "OpenConfigToolStripMenuItem"
        Me.OpenConfigToolStripMenuItem.Size = New System.Drawing.Size(124, 22)
        Me.OpenConfigToolStripMenuItem.Text = "Openen"
        '
        'ConfigOpslaanToolStripMenuItem
        '
        Me.ConfigOpslaanToolStripMenuItem.Name = "ConfigOpslaanToolStripMenuItem"
        Me.ConfigOpslaanToolStripMenuItem.Size = New System.Drawing.Size(124, 22)
        Me.ConfigOpslaanToolStripMenuItem.Text = "Opslaan"
        '
        'LegenToolStripMenuItem
        '
        Me.LegenToolStripMenuItem.Name = "LegenToolStripMenuItem"
        Me.LegenToolStripMenuItem.Size = New System.Drawing.Size(124, 22)
        Me.LegenToolStripMenuItem.Text = "Legen"
        '
        'NieuweDatabaseAanleggenToolStripMenuItem
        '
        Me.NieuweDatabaseAanleggenToolStripMenuItem.Name = "NieuweDatabaseAanleggenToolStripMenuItem"
        Me.NieuweDatabaseAanleggenToolStripMenuItem.Size = New System.Drawing.Size(141, 20)
        Me.NieuweDatabaseAanleggenToolStripMenuItem.Text = "Terug Naar Gebruikconfig"
        '
        'grpQueries
        '
        Me.grpQueries.Controls.Add(Me.btnPopuleerDatabase)
        Me.grpQueries.Controls.Add(Me.picDataGevonden)
        Me.grpQueries.Controls.Add(Me.btnManueelExtraData)
        Me.grpQueries.Controls.Add(Me.lblDataGevonden)
        Me.grpQueries.Controls.Add(Me.txtExtraData)
        Me.grpQueries.Controls.Add(Me.lblExtraData)
        Me.grpQueries.Controls.Add(Me.btnManueelStartData)
        Me.grpQueries.Controls.Add(Me.txtStartData)
        Me.grpQueries.Controls.Add(Me.lblStartData)
        Me.grpQueries.Controls.Add(Me.btnManeelStoredProcedures)
        Me.grpQueries.Controls.Add(Me.txtStoredProcedures)
        Me.grpQueries.Controls.Add(Me.lblStoredProcedures)
        Me.grpQueries.Location = New System.Drawing.Point(12, 240)
        Me.grpQueries.Name = "grpQueries"
        Me.grpQueries.Size = New System.Drawing.Size(490, 203)
        Me.grpQueries.TabIndex = 6
        Me.grpQueries.TabStop = False
        Me.grpQueries.Text = "Query-Instellingen"
        '
        'btnPopuleerDatabase
        '
        Me.btnPopuleerDatabase.Enabled = False
        Me.btnPopuleerDatabase.Location = New System.Drawing.Point(157, 174)
        Me.btnPopuleerDatabase.Name = "btnPopuleerDatabase"
        Me.btnPopuleerDatabase.Size = New System.Drawing.Size(184, 23)
        Me.btnPopuleerDatabase.TabIndex = 25
        Me.btnPopuleerDatabase.Text = "Populeer Database"
        Me.btnPopuleerDatabase.UseVisualStyleBackColor = True
        '
        'picDataGevonden
        '
        Me.picDataGevonden.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.picDataGevonden.Location = New System.Drawing.Point(351, 96)
        Me.picDataGevonden.Name = "picDataGevonden"
        Me.picDataGevonden.Size = New System.Drawing.Size(17, 14)
        Me.picDataGevonden.TabIndex = 17
        Me.picDataGevonden.TabStop = False
        '
        'btnManueelExtraData
        '
        Me.btnManueelExtraData.Location = New System.Drawing.Point(407, 112)
        Me.btnManueelExtraData.Name = "btnManueelExtraData"
        Me.btnManueelExtraData.Size = New System.Drawing.Size(75, 37)
        Me.btnManueelExtraData.TabIndex = 24
        Me.btnManueelExtraData.Text = "Selecteer Bestand"
        Me.btnManueelExtraData.UseVisualStyleBackColor = True
        '
        'lblDataGevonden
        '
        Me.lblDataGevonden.AutoSize = True
        Me.lblDataGevonden.ForeColor = System.Drawing.Color.Firebrick
        Me.lblDataGevonden.Location = New System.Drawing.Point(374, 96)
        Me.lblDataGevonden.Name = "lblDataGevonden"
        Me.lblDataGevonden.Size = New System.Drawing.Size(108, 13)
        Me.lblDataGevonden.TabIndex = 16
        Me.lblDataGevonden.Text = "Data Niet Gevonden."
        Me.lblDataGevonden.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'txtExtraData
        '
        Me.txtExtraData.Location = New System.Drawing.Point(106, 121)
        Me.txtExtraData.Name = "txtExtraData"
        Me.txtExtraData.Size = New System.Drawing.Size(293, 20)
        Me.txtExtraData.TabIndex = 23
        '
        'lblExtraData
        '
        Me.lblExtraData.AutoSize = True
        Me.lblExtraData.Location = New System.Drawing.Point(4, 124)
        Me.lblExtraData.Name = "lblExtraData"
        Me.lblExtraData.Size = New System.Drawing.Size(60, 13)
        Me.lblExtraData.TabIndex = 22
        Me.lblExtraData.Text = "Extra Data:"
        '
        'btnManueelStartData
        '
        Me.btnManueelStartData.Location = New System.Drawing.Point(409, 56)
        Me.btnManueelStartData.Name = "btnManueelStartData"
        Me.btnManueelStartData.Size = New System.Drawing.Size(75, 37)
        Me.btnManueelStartData.TabIndex = 21
        Me.btnManueelStartData.Text = "Manueel Selecteren"
        Me.btnManueelStartData.UseVisualStyleBackColor = True
        '
        'txtStartData
        '
        Me.txtStartData.Location = New System.Drawing.Point(108, 65)
        Me.txtStartData.Name = "txtStartData"
        Me.txtStartData.Size = New System.Drawing.Size(293, 20)
        Me.txtStartData.TabIndex = 20
        '
        'lblStartData
        '
        Me.lblStartData.AutoSize = True
        Me.lblStartData.Location = New System.Drawing.Point(6, 68)
        Me.lblStartData.Name = "lblStartData"
        Me.lblStartData.Size = New System.Drawing.Size(53, 13)
        Me.lblStartData.TabIndex = 19
        Me.lblStartData.Text = "Startdata:"
        '
        'btnManeelStoredProcedures
        '
        Me.btnManeelStoredProcedures.Location = New System.Drawing.Point(409, 13)
        Me.btnManeelStoredProcedures.Name = "btnManeelStoredProcedures"
        Me.btnManeelStoredProcedures.Size = New System.Drawing.Size(75, 37)
        Me.btnManeelStoredProcedures.TabIndex = 18
        Me.btnManeelStoredProcedures.Text = "Manueel Selecteren"
        Me.btnManeelStoredProcedures.UseVisualStyleBackColor = True
        '
        'txtStoredProcedures
        '
        Me.txtStoredProcedures.Location = New System.Drawing.Point(110, 22)
        Me.txtStoredProcedures.Name = "txtStoredProcedures"
        Me.txtStoredProcedures.Size = New System.Drawing.Size(293, 20)
        Me.txtStoredProcedures.TabIndex = 17
        '
        'lblStoredProcedures
        '
        Me.lblStoredProcedures.AutoSize = True
        Me.lblStoredProcedures.Location = New System.Drawing.Point(6, 25)
        Me.lblStoredProcedures.Name = "lblStoredProcedures"
        Me.lblStoredProcedures.Size = New System.Drawing.Size(98, 13)
        Me.lblStoredProcedures.TabIndex = 16
        Me.lblStoredProcedures.Text = "Stored Procedures:"
        '
        'picDatabaseGepopuleerd
        '
        Me.picDatabaseGepopuleerd.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.picDatabaseGepopuleerd.Location = New System.Drawing.Point(177, 446)
        Me.picDatabaseGepopuleerd.Name = "picDatabaseGepopuleerd"
        Me.picDatabaseGepopuleerd.Size = New System.Drawing.Size(17, 14)
        Me.picDatabaseGepopuleerd.TabIndex = 27
        Me.picDatabaseGepopuleerd.TabStop = False
        '
        'lblDatabaseGepopuleerd
        '
        Me.lblDatabaseGepopuleerd.AutoSize = True
        Me.lblDatabaseGepopuleerd.ForeColor = System.Drawing.Color.Firebrick
        Me.lblDatabaseGepopuleerd.Location = New System.Drawing.Point(200, 446)
        Me.lblDatabaseGepopuleerd.Name = "lblDatabaseGepopuleerd"
        Me.lblDatabaseGepopuleerd.Size = New System.Drawing.Size(142, 13)
        Me.lblDatabaseGepopuleerd.TabIndex = 26
        Me.lblDatabaseGepopuleerd.Text = "Database Niet Gepopuleerd."
        '
        'frmNieuweDatabase
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.picDatabaseGepopuleerd)
        Me.Controls.Add(Me.grpQueries)
        Me.Controls.Add(Me.lblDatabaseGepopuleerd)
        Me.Controls.Add(Me.mnuConfig)
        Me.Controls.Add(Me.grpInstellingen)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmNieuweDatabase"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "frmNieuweDatabase"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.grpInstellingen.ResumeLayout(False)
        Me.grpInstellingen.PerformLayout()
        CType(Me.picSQLGeldig, System.ComponentModel.ISupportInitialize).EndInit()
        Me.mnuConfig.ResumeLayout(False)
        Me.mnuConfig.PerformLayout()
        Me.grpQueries.ResumeLayout(False)
        Me.grpQueries.PerformLayout()
        CType(Me.picDataGevonden, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.picDatabaseGepopuleerd, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents grpInstellingen As System.Windows.Forms.GroupBox
    Friend WithEvents chkSQLOpslaan As System.Windows.Forms.CheckBox
    Friend WithEvents picSQLGeldig As System.Windows.Forms.PictureBox
    Friend WithEvents lblSQLGeldig As System.Windows.Forms.Label
    Friend WithEvents txtSQLPaswoord As System.Windows.Forms.TextBox
    Friend WithEvents txtSQLGebruiker As System.Windows.Forms.TextBox
    Friend WithEvents lblSQLPaswoord As System.Windows.Forms.Label
    Friend WithEvents lblSQLGebruiker As System.Windows.Forms.Label
    Friend WithEvents chkIntegratedSecurity As System.Windows.Forms.CheckBox
    Friend WithEvents txtSQLDatabase As System.Windows.Forms.TextBox
    Friend WithEvents lblSQLDatabase As System.Windows.Forms.Label
    Friend WithEvents lblSQLServer As System.Windows.Forms.Label
    Friend WithEvents txtSQLServer As System.Windows.Forms.TextBox
    Friend WithEvents mnuConfig As System.Windows.Forms.MenuStrip
    Friend WithEvents BeheerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OpenConfigToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ConfigOpslaanToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LegenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents NieuweDatabaseAanleggenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents grpQueries As System.Windows.Forms.GroupBox
    Friend WithEvents btnDatabaseAanmaken As System.Windows.Forms.Button
    Friend WithEvents lblStoredProcedures As System.Windows.Forms.Label
    Friend WithEvents txtStoredProcedures As System.Windows.Forms.TextBox
    Friend WithEvents btnManeelStoredProcedures As System.Windows.Forms.Button
    Friend WithEvents btnManueelStartData As System.Windows.Forms.Button
    Friend WithEvents txtStartData As System.Windows.Forms.TextBox
    Friend WithEvents lblStartData As System.Windows.Forms.Label
    Friend WithEvents btnManueelExtraData As System.Windows.Forms.Button
    Friend WithEvents txtExtraData As System.Windows.Forms.TextBox
    Friend WithEvents lblExtraData As System.Windows.Forms.Label
    Friend WithEvents picDataGevonden As System.Windows.Forms.PictureBox
    Friend WithEvents lblDataGevonden As System.Windows.Forms.Label
    Friend WithEvents btnPopuleerDatabase As System.Windows.Forms.Button
    Friend WithEvents picDatabaseGepopuleerd As System.Windows.Forms.PictureBox
    Friend WithEvents lblDatabaseGepopuleerd As System.Windows.Forms.Label
End Class
