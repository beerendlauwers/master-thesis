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
        Me.prgDatabaseAanmaken = New System.Windows.Forms.ProgressBar
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
        Me.BeheerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OpenConfigToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ConfigOpslaanToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.LegenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.AanleggenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.grpQueries = New System.Windows.Forms.GroupBox
        Me.btnDataVerwijderen = New System.Windows.Forms.Button
        Me.btnStoredProcedureVerwijderen = New System.Windows.Forms.Button
        Me.lstData = New System.Windows.Forms.ListBox
        Me.lstStoredProcedures = New System.Windows.Forms.ListBox
        Me.btnPopuleerDatabase = New System.Windows.Forms.Button
        Me.picDataGevonden = New System.Windows.Forms.PictureBox
        Me.btnDataToevoegen = New System.Windows.Forms.Button
        Me.lblDataGevonden = New System.Windows.Forms.Label
        Me.lblExtraData = New System.Windows.Forms.Label
        Me.btnStoredProcedureToevoegen = New System.Windows.Forms.Button
        Me.lblStoredProcedures = New System.Windows.Forms.Label
        Me.picDatabaseGepopuleerd = New System.Windows.Forms.PictureBox
        Me.lblDatabaseGepopuleerd = New System.Windows.Forms.Label
        Me.ConfigToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OpenenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OpslaanToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.LegenToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem
        Me.mnuConfig = New System.Windows.Forms.MenuStrip
        Me.ConfigToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem
        Me.OpenenToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem
        Me.OpslaanToolStripMenuItem1 = New System.Windows.Forms.ToolStripMenuItem
        Me.LegenToolStripMenuItem2 = New System.Windows.Forms.ToolStripMenuItem
        Me.TerugNaarConfiguratieschermToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.grpInstellingen.SuspendLayout()
        CType(Me.picSQLGeldig, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.grpQueries.SuspendLayout()
        CType(Me.picDataGevonden, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.picDatabaseGepopuleerd, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.mnuConfig.SuspendLayout()
        Me.SuspendLayout()
        '
        'grpInstellingen
        '
        Me.grpInstellingen.Controls.Add(Me.prgDatabaseAanmaken)
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
        'prgDatabaseAanmaken
        '
        Me.prgDatabaseAanmaken.Enabled = False
        Me.prgDatabaseAanmaken.Location = New System.Drawing.Point(407, 100)
        Me.prgDatabaseAanmaken.Maximum = 5
        Me.prgDatabaseAanmaken.Name = "prgDatabaseAanmaken"
        Me.prgDatabaseAanmaken.Size = New System.Drawing.Size(75, 10)
        Me.prgDatabaseAanmaken.Step = 1
        Me.prgDatabaseAanmaken.TabIndex = 16
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
        'AanleggenToolStripMenuItem
        '
        Me.AanleggenToolStripMenuItem.Name = "AanleggenToolStripMenuItem"
        Me.AanleggenToolStripMenuItem.Size = New System.Drawing.Size(141, 20)
        Me.AanleggenToolStripMenuItem.Text = "Terug Naar Gebruikconfig"
        '
        'grpQueries
        '
        Me.grpQueries.Controls.Add(Me.btnDataVerwijderen)
        Me.grpQueries.Controls.Add(Me.btnStoredProcedureVerwijderen)
        Me.grpQueries.Controls.Add(Me.lstData)
        Me.grpQueries.Controls.Add(Me.lstStoredProcedures)
        Me.grpQueries.Controls.Add(Me.btnPopuleerDatabase)
        Me.grpQueries.Controls.Add(Me.picDataGevonden)
        Me.grpQueries.Controls.Add(Me.btnDataToevoegen)
        Me.grpQueries.Controls.Add(Me.lblDataGevonden)
        Me.grpQueries.Controls.Add(Me.lblExtraData)
        Me.grpQueries.Controls.Add(Me.btnStoredProcedureToevoegen)
        Me.grpQueries.Controls.Add(Me.lblStoredProcedures)
        Me.grpQueries.Location = New System.Drawing.Point(12, 238)
        Me.grpQueries.Name = "grpQueries"
        Me.grpQueries.Size = New System.Drawing.Size(490, 268)
        Me.grpQueries.TabIndex = 6
        Me.grpQueries.TabStop = False
        Me.grpQueries.Text = "Query-Instellingen"
        '
        'btnDataVerwijderen
        '
        Me.btnDataVerwijderen.Location = New System.Drawing.Point(404, 19)
        Me.btnDataVerwijderen.Name = "btnDataVerwijderen"
        Me.btnDataVerwijderen.Size = New System.Drawing.Size(58, 22)
        Me.btnDataVerwijderen.TabIndex = 29
        Me.btnDataVerwijderen.Text = "Verwijder"
        Me.btnDataVerwijderen.UseVisualStyleBackColor = True
        '
        'btnStoredProcedureVerwijderen
        '
        Me.btnStoredProcedureVerwijderen.Location = New System.Drawing.Point(179, 19)
        Me.btnStoredProcedureVerwijderen.Name = "btnStoredProcedureVerwijderen"
        Me.btnStoredProcedureVerwijderen.Size = New System.Drawing.Size(58, 22)
        Me.btnStoredProcedureVerwijderen.TabIndex = 28
        Me.btnStoredProcedureVerwijderen.Text = "Verwijder"
        Me.btnStoredProcedureVerwijderen.UseVisualStyleBackColor = True
        '
        'lstData
        '
        Me.lstData.FormattingEnabled = True
        Me.lstData.Location = New System.Drawing.Point(248, 44)
        Me.lstData.Name = "lstData"
        Me.lstData.Size = New System.Drawing.Size(228, 186)
        Me.lstData.TabIndex = 27
        '
        'lstStoredProcedures
        '
        Me.lstStoredProcedures.FormattingEnabled = True
        Me.lstStoredProcedures.Location = New System.Drawing.Point(9, 44)
        Me.lstStoredProcedures.Name = "lstStoredProcedures"
        Me.lstStoredProcedures.Size = New System.Drawing.Size(228, 186)
        Me.lstStoredProcedures.TabIndex = 26
        '
        'btnPopuleerDatabase
        '
        Me.btnPopuleerDatabase.Enabled = False
        Me.btnPopuleerDatabase.Location = New System.Drawing.Point(27, 234)
        Me.btnPopuleerDatabase.Name = "btnPopuleerDatabase"
        Me.btnPopuleerDatabase.Size = New System.Drawing.Size(184, 23)
        Me.btnPopuleerDatabase.TabIndex = 25
        Me.btnPopuleerDatabase.Text = "Populeer Database"
        Me.btnPopuleerDatabase.UseVisualStyleBackColor = True
        '
        'picDataGevonden
        '
        Me.picDataGevonden.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.picDataGevonden.Location = New System.Drawing.Point(300, 239)
        Me.picDataGevonden.Name = "picDataGevonden"
        Me.picDataGevonden.Size = New System.Drawing.Size(17, 14)
        Me.picDataGevonden.TabIndex = 17
        Me.picDataGevonden.TabStop = False
        '
        'btnDataToevoegen
        '
        Me.btnDataToevoegen.Location = New System.Drawing.Point(336, 19)
        Me.btnDataToevoegen.Name = "btnDataToevoegen"
        Me.btnDataToevoegen.Size = New System.Drawing.Size(62, 23)
        Me.btnDataToevoegen.TabIndex = 24
        Me.btnDataToevoegen.Text = "Voeg Toe"
        Me.btnDataToevoegen.UseVisualStyleBackColor = True
        '
        'lblDataGevonden
        '
        Me.lblDataGevonden.AutoSize = True
        Me.lblDataGevonden.ForeColor = System.Drawing.Color.Firebrick
        Me.lblDataGevonden.Location = New System.Drawing.Point(321, 239)
        Me.lblDataGevonden.Name = "lblDataGevonden"
        Me.lblDataGevonden.Size = New System.Drawing.Size(155, 13)
        Me.lblDataGevonden.TabIndex = 16
        Me.lblDataGevonden.Text = "Standaarddata Niet Gevonden."
        Me.lblDataGevonden.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblExtraData
        '
        Me.lblExtraData.AutoSize = True
        Me.lblExtraData.Location = New System.Drawing.Point(270, 24)
        Me.lblExtraData.Name = "lblExtraData"
        Me.lblExtraData.Size = New System.Drawing.Size(60, 13)
        Me.lblExtraData.TabIndex = 22
        Me.lblExtraData.Text = "Extra Data:"
        '
        'btnStoredProcedureToevoegen
        '
        Me.btnStoredProcedureToevoegen.Location = New System.Drawing.Point(115, 19)
        Me.btnStoredProcedureToevoegen.Name = "btnStoredProcedureToevoegen"
        Me.btnStoredProcedureToevoegen.Size = New System.Drawing.Size(62, 22)
        Me.btnStoredProcedureToevoegen.TabIndex = 18
        Me.btnStoredProcedureToevoegen.Text = "Voeg Toe"
        Me.btnStoredProcedureToevoegen.UseVisualStyleBackColor = True
        '
        'lblStoredProcedures
        '
        Me.lblStoredProcedures.AutoSize = True
        Me.lblStoredProcedures.Location = New System.Drawing.Point(11, 24)
        Me.lblStoredProcedures.Name = "lblStoredProcedures"
        Me.lblStoredProcedures.Size = New System.Drawing.Size(98, 13)
        Me.lblStoredProcedures.TabIndex = 16
        Me.lblStoredProcedures.Text = "Stored Procedures:"
        '
        'picDatabaseGepopuleerd
        '
        Me.picDatabaseGepopuleerd.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.picDatabaseGepopuleerd.Location = New System.Drawing.Point(177, 509)
        Me.picDatabaseGepopuleerd.Name = "picDatabaseGepopuleerd"
        Me.picDatabaseGepopuleerd.Size = New System.Drawing.Size(17, 14)
        Me.picDatabaseGepopuleerd.TabIndex = 27
        Me.picDatabaseGepopuleerd.TabStop = False
        '
        'lblDatabaseGepopuleerd
        '
        Me.lblDatabaseGepopuleerd.AutoSize = True
        Me.lblDatabaseGepopuleerd.ForeColor = System.Drawing.Color.Firebrick
        Me.lblDatabaseGepopuleerd.Location = New System.Drawing.Point(200, 510)
        Me.lblDatabaseGepopuleerd.Name = "lblDatabaseGepopuleerd"
        Me.lblDatabaseGepopuleerd.Size = New System.Drawing.Size(142, 13)
        Me.lblDatabaseGepopuleerd.TabIndex = 26
        Me.lblDatabaseGepopuleerd.Text = "Database Niet Gepopuleerd."
        '
        'ConfigToolStripMenuItem
        '
        Me.ConfigToolStripMenuItem.Name = "ConfigToolStripMenuItem"
        Me.ConfigToolStripMenuItem.Size = New System.Drawing.Size(50, 20)
        Me.ConfigToolStripMenuItem.Text = "Config"
        '
        'OpenenToolStripMenuItem
        '
        Me.OpenenToolStripMenuItem.Name = "OpenenToolStripMenuItem"
        Me.OpenenToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.OpenenToolStripMenuItem.Text = "Openen"
        '
        'OpslaanToolStripMenuItem
        '
        Me.OpslaanToolStripMenuItem.Name = "OpslaanToolStripMenuItem"
        Me.OpslaanToolStripMenuItem.Size = New System.Drawing.Size(152, 22)
        Me.OpslaanToolStripMenuItem.Text = "Opslaan"
        '
        'LegenToolStripMenuItem1
        '
        Me.LegenToolStripMenuItem1.Name = "LegenToolStripMenuItem1"
        Me.LegenToolStripMenuItem1.Size = New System.Drawing.Size(152, 22)
        Me.LegenToolStripMenuItem1.Text = "Legen"
        '
        'mnuConfig
        '
        Me.mnuConfig.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ConfigToolStripMenuItem1, Me.TerugNaarConfiguratieschermToolStripMenuItem})
        Me.mnuConfig.Location = New System.Drawing.Point(0, 0)
        Me.mnuConfig.Name = "mnuConfig"
        Me.mnuConfig.Size = New System.Drawing.Size(514, 24)
        Me.mnuConfig.TabIndex = 28
        Me.mnuConfig.Text = "Configuratie"
        '
        'ConfigToolStripMenuItem1
        '
        Me.ConfigToolStripMenuItem1.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OpenenToolStripMenuItem1, Me.OpslaanToolStripMenuItem1, Me.LegenToolStripMenuItem2})
        Me.ConfigToolStripMenuItem1.Name = "ConfigToolStripMenuItem1"
        Me.ConfigToolStripMenuItem1.Size = New System.Drawing.Size(50, 20)
        Me.ConfigToolStripMenuItem1.Text = "Config"
        '
        'OpenenToolStripMenuItem1
        '
        Me.OpenenToolStripMenuItem1.Name = "OpenenToolStripMenuItem1"
        Me.OpenenToolStripMenuItem1.Size = New System.Drawing.Size(152, 22)
        Me.OpenenToolStripMenuItem1.Text = "Openen"
        '
        'OpslaanToolStripMenuItem1
        '
        Me.OpslaanToolStripMenuItem1.Name = "OpslaanToolStripMenuItem1"
        Me.OpslaanToolStripMenuItem1.Size = New System.Drawing.Size(152, 22)
        Me.OpslaanToolStripMenuItem1.Text = "Opslaan"
        '
        'LegenToolStripMenuItem2
        '
        Me.LegenToolStripMenuItem2.Name = "LegenToolStripMenuItem2"
        Me.LegenToolStripMenuItem2.Size = New System.Drawing.Size(152, 22)
        Me.LegenToolStripMenuItem2.Text = "Legen"
        '
        'TerugNaarConfiguratieschermToolStripMenuItem
        '
        Me.TerugNaarConfiguratieschermToolStripMenuItem.Name = "TerugNaarConfiguratieschermToolStripMenuItem"
        Me.TerugNaarConfiguratieschermToolStripMenuItem.Size = New System.Drawing.Size(130, 20)
        Me.TerugNaarConfiguratieschermToolStripMenuItem.Text = "Terug naar Instellingen"
        '
        'frmNieuweDatabase
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.mnuConfig)
        Me.Controls.Add(Me.picDatabaseGepopuleerd)
        Me.Controls.Add(Me.grpQueries)
        Me.Controls.Add(Me.lblDatabaseGepopuleerd)
        Me.Controls.Add(Me.grpInstellingen)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmNieuweDatabase"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Nieuwe Database Aanmaken"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.grpInstellingen.ResumeLayout(False)
        Me.grpInstellingen.PerformLayout()
        CType(Me.picSQLGeldig, System.ComponentModel.ISupportInitialize).EndInit()
        Me.grpQueries.ResumeLayout(False)
        Me.grpQueries.PerformLayout()
        CType(Me.picDataGevonden, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.picDatabaseGepopuleerd, System.ComponentModel.ISupportInitialize).EndInit()
        Me.mnuConfig.ResumeLayout(False)
        Me.mnuConfig.PerformLayout()
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
    Friend WithEvents BeheerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OpenConfigToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ConfigOpslaanToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LegenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AanleggenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents grpQueries As System.Windows.Forms.GroupBox
    Friend WithEvents btnDatabaseAanmaken As System.Windows.Forms.Button
    Friend WithEvents lblStoredProcedures As System.Windows.Forms.Label
    Friend WithEvents btnStoredProcedureToevoegen As System.Windows.Forms.Button
    Friend WithEvents btnDataToevoegen As System.Windows.Forms.Button
    Friend WithEvents lblExtraData As System.Windows.Forms.Label
    Friend WithEvents picDataGevonden As System.Windows.Forms.PictureBox
    Friend WithEvents lblDataGevonden As System.Windows.Forms.Label
    Friend WithEvents btnPopuleerDatabase As System.Windows.Forms.Button
    Friend WithEvents picDatabaseGepopuleerd As System.Windows.Forms.PictureBox
    Friend WithEvents lblDatabaseGepopuleerd As System.Windows.Forms.Label
    Friend WithEvents prgDatabaseAanmaken As System.Windows.Forms.ProgressBar
    Friend WithEvents lstData As System.Windows.Forms.ListBox
    Friend WithEvents lstStoredProcedures As System.Windows.Forms.ListBox
    Friend WithEvents btnStoredProcedureVerwijderen As System.Windows.Forms.Button
    Friend WithEvents btnDataVerwijderen As System.Windows.Forms.Button
    Friend WithEvents ConfigToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OpenenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OpslaanToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LegenToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents mnuConfig As System.Windows.Forms.MenuStrip
    Friend WithEvents ConfigToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OpenenToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OpslaanToolStripMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents LegenToolStripMenuItem2 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents TerugNaarConfiguratieschermToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
End Class
