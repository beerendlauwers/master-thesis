<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmStart
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
        Me.BeheerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.OpenConfigToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ConfigOpslaanToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.txtSQLServer = New System.Windows.Forms.TextBox
        Me.lblSQLServer = New System.Windows.Forms.Label
        Me.grpInstellingen = New System.Windows.Forms.GroupBox
        Me.btnSQLTestConnectie = New System.Windows.Forms.Button
        Me.chkSQLOpslaan = New System.Windows.Forms.CheckBox
        Me.pctSQLGeldig = New System.Windows.Forms.PictureBox
        Me.lblSQLGeldig = New System.Windows.Forms.Label
        Me.txtSQLPaswoord = New System.Windows.Forms.TextBox
        Me.txtSQLGebruiker = New System.Windows.Forms.TextBox
        Me.lblSQLPaswoord = New System.Windows.Forms.Label
        Me.lblSQLGebruiker = New System.Windows.Forms.Label
        Me.chkIntegratedSecurity = New System.Windows.Forms.CheckBox
        Me.txtSQLDatabase = New System.Windows.Forms.TextBox
        Me.lblSQLDatabase = New System.Windows.Forms.Label
        Me.grpAccess = New System.Windows.Forms.GroupBox
        Me.txtAccessKolom = New System.Windows.Forms.TextBox
        Me.lblAccessKolom = New System.Windows.Forms.Label
        Me.txtAccessTabel = New System.Windows.Forms.TextBox
        Me.lblAccessTabel = New System.Windows.Forms.Label
        Me.pctAccessGeldig = New System.Windows.Forms.PictureBox
        Me.btnAccessOpenen = New System.Windows.Forms.Button
        Me.lblAccessGeldig = New System.Windows.Forms.Label
        Me.txtAccessBestand = New System.Windows.Forms.TextBox
        Me.lblAccessBestand = New System.Windows.Forms.Label
        Me.chkAccessOpslaan = New System.Windows.Forms.CheckBox
        Me.btnUseConfig = New System.Windows.Forms.Button
        Me.MenuStrip1.SuspendLayout()
        Me.grpInstellingen.SuspendLayout()
        CType(Me.pctSQLGeldig, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.grpAccess.SuspendLayout()
        CType(Me.pctAccessGeldig, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BeheerToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(514, 24)
        Me.MenuStrip1.TabIndex = 0
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'BeheerToolStripMenuItem
        '
        Me.BeheerToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OpenConfigToolStripMenuItem, Me.ConfigOpslaanToolStripMenuItem})
        Me.BeheerToolStripMenuItem.Name = "BeheerToolStripMenuItem"
        Me.BeheerToolStripMenuItem.Size = New System.Drawing.Size(50, 20)
        Me.BeheerToolStripMenuItem.Text = "Config"
        '
        'OpenConfigToolStripMenuItem
        '
        Me.OpenConfigToolStripMenuItem.Name = "OpenConfigToolStripMenuItem"
        Me.OpenConfigToolStripMenuItem.Size = New System.Drawing.Size(157, 22)
        Me.OpenConfigToolStripMenuItem.Text = "Openen"
        '
        'ConfigOpslaanToolStripMenuItem
        '
        Me.ConfigOpslaanToolStripMenuItem.Name = "ConfigOpslaanToolStripMenuItem"
        Me.ConfigOpslaanToolStripMenuItem.Size = New System.Drawing.Size(157, 22)
        Me.ConfigOpslaanToolStripMenuItem.Text = "Opslaan"
        '
        'txtSQLServer
        '
        Me.txtSQLServer.Location = New System.Drawing.Point(77, 22)
        Me.txtSQLServer.Name = "txtSQLServer"
        Me.txtSQLServer.Size = New System.Drawing.Size(407, 20)
        Me.txtSQLServer.TabIndex = 1
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
        'grpInstellingen
        '
        Me.grpInstellingen.Controls.Add(Me.btnSQLTestConnectie)
        Me.grpInstellingen.Controls.Add(Me.chkSQLOpslaan)
        Me.grpInstellingen.Controls.Add(Me.pctSQLGeldig)
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
        Me.grpInstellingen.TabIndex = 3
        Me.grpInstellingen.TabStop = False
        Me.grpInstellingen.Text = "SQL-Server Instellingen"
        '
        'btnSQLTestConnectie
        '
        Me.btnSQLTestConnectie.Location = New System.Drawing.Point(408, 105)
        Me.btnSQLTestConnectie.Name = "btnSQLTestConnectie"
        Me.btnSQLTestConnectie.Size = New System.Drawing.Size(75, 42)
        Me.btnSQLTestConnectie.TabIndex = 13
        Me.btnSQLTestConnectie.Text = "Test Connectie"
        Me.btnSQLTestConnectie.UseVisualStyleBackColor = True
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
        'pctSQLGeldig
        '
        Me.pctSQLGeldig.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.pctSQLGeldig.Location = New System.Drawing.Point(411, 169)
        Me.pctSQLGeldig.Name = "pctSQLGeldig"
        Me.pctSQLGeldig.Size = New System.Drawing.Size(17, 14)
        Me.pctSQLGeldig.TabIndex = 11
        Me.pctSQLGeldig.TabStop = False
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
        Me.txtSQLDatabase.Location = New System.Drawing.Point(77, 51)
        Me.txtSQLDatabase.Name = "txtSQLDatabase"
        Me.txtSQLDatabase.Size = New System.Drawing.Size(407, 20)
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
        'grpAccess
        '
        Me.grpAccess.Controls.Add(Me.txtAccessKolom)
        Me.grpAccess.Controls.Add(Me.lblAccessKolom)
        Me.grpAccess.Controls.Add(Me.txtAccessTabel)
        Me.grpAccess.Controls.Add(Me.lblAccessTabel)
        Me.grpAccess.Controls.Add(Me.pctAccessGeldig)
        Me.grpAccess.Controls.Add(Me.btnAccessOpenen)
        Me.grpAccess.Controls.Add(Me.lblAccessGeldig)
        Me.grpAccess.Controls.Add(Me.txtAccessBestand)
        Me.grpAccess.Controls.Add(Me.lblAccessBestand)
        Me.grpAccess.Controls.Add(Me.chkAccessOpslaan)
        Me.grpAccess.Location = New System.Drawing.Point(12, 247)
        Me.grpAccess.Name = "grpAccess"
        Me.grpAccess.Size = New System.Drawing.Size(489, 154)
        Me.grpAccess.TabIndex = 4
        Me.grpAccess.TabStop = False
        Me.grpAccess.Text = "MS-Access Instellingen"
        '
        'txtAccessKolom
        '
        Me.txtAccessKolom.Location = New System.Drawing.Point(69, 82)
        Me.txtAccessKolom.Name = "txtAccessKolom"
        Me.txtAccessKolom.Size = New System.Drawing.Size(209, 20)
        Me.txtAccessKolom.TabIndex = 20
        '
        'lblAccessKolom
        '
        Me.lblAccessKolom.AutoSize = True
        Me.lblAccessKolom.Location = New System.Drawing.Point(7, 85)
        Me.lblAccessKolom.Name = "lblAccessKolom"
        Me.lblAccessKolom.Size = New System.Drawing.Size(39, 13)
        Me.lblAccessKolom.TabIndex = 19
        Me.lblAccessKolom.Text = "Kolom:"
        '
        'txtAccessTabel
        '
        Me.txtAccessTabel.Location = New System.Drawing.Point(69, 54)
        Me.txtAccessTabel.Name = "txtAccessTabel"
        Me.txtAccessTabel.Size = New System.Drawing.Size(209, 20)
        Me.txtAccessTabel.TabIndex = 18
        '
        'lblAccessTabel
        '
        Me.lblAccessTabel.AutoSize = True
        Me.lblAccessTabel.Location = New System.Drawing.Point(7, 57)
        Me.lblAccessTabel.Name = "lblAccessTabel"
        Me.lblAccessTabel.Size = New System.Drawing.Size(37, 13)
        Me.lblAccessTabel.TabIndex = 17
        Me.lblAccessTabel.Text = "Tabel:"
        '
        'pctAccessGeldig
        '
        Me.pctAccessGeldig.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.pctAccessGeldig.Location = New System.Drawing.Point(411, 132)
        Me.pctAccessGeldig.Name = "pctAccessGeldig"
        Me.pctAccessGeldig.Size = New System.Drawing.Size(17, 14)
        Me.pctAccessGeldig.TabIndex = 14
        Me.pctAccessGeldig.TabStop = False
        '
        'btnAccessOpenen
        '
        Me.btnAccessOpenen.Location = New System.Drawing.Point(408, 13)
        Me.btnAccessOpenen.Name = "btnAccessOpenen"
        Me.btnAccessOpenen.Size = New System.Drawing.Size(75, 41)
        Me.btnAccessOpenen.TabIndex = 16
        Me.btnAccessOpenen.Text = "Bestand Openen..."
        Me.btnAccessOpenen.UseVisualStyleBackColor = True
        '
        'lblAccessGeldig
        '
        Me.lblAccessGeldig.AutoSize = True
        Me.lblAccessGeldig.ForeColor = System.Drawing.Color.Firebrick
        Me.lblAccessGeldig.Location = New System.Drawing.Point(434, 132)
        Me.lblAccessGeldig.Name = "lblAccessGeldig"
        Me.lblAccessGeldig.Size = New System.Drawing.Size(49, 13)
        Me.lblAccessGeldig.TabIndex = 13
        Me.lblAccessGeldig.Text = "Ongeldig"
        '
        'txtAccessBestand
        '
        Me.txtAccessBestand.Location = New System.Drawing.Point(69, 24)
        Me.txtAccessBestand.Name = "txtAccessBestand"
        Me.txtAccessBestand.Size = New System.Drawing.Size(333, 20)
        Me.txtAccessBestand.TabIndex = 15
        '
        'lblAccessBestand
        '
        Me.lblAccessBestand.AutoSize = True
        Me.lblAccessBestand.Location = New System.Drawing.Point(7, 27)
        Me.lblAccessBestand.Name = "lblAccessBestand"
        Me.lblAccessBestand.Size = New System.Drawing.Size(56, 13)
        Me.lblAccessBestand.TabIndex = 14
        Me.lblAccessBestand.Text = "Database:"
        '
        'chkAccessOpslaan
        '
        Me.chkAccessOpslaan.AutoSize = True
        Me.chkAccessOpslaan.Location = New System.Drawing.Point(6, 131)
        Me.chkAccessOpslaan.Name = "chkAccessOpslaan"
        Me.chkAccessOpslaan.Size = New System.Drawing.Size(134, 17)
        Me.chkAccessOpslaan.TabIndex = 13
        Me.chkAccessOpslaan.Text = "Opslaan in configuratie"
        Me.chkAccessOpslaan.UseVisualStyleBackColor = True
        '
        'btnUseConfig
        '
        Me.btnUseConfig.Location = New System.Drawing.Point(132, 445)
        Me.btnUseConfig.Name = "btnUseConfig"
        Me.btnUseConfig.Size = New System.Drawing.Size(225, 37)
        Me.btnUseConfig.TabIndex = 5
        Me.btnUseConfig.Text = "Deze configuratie gebruiken"
        Me.btnUseConfig.UseVisualStyleBackColor = True
        '
        'frmStart
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.btnUseConfig)
        Me.Controls.Add(Me.grpAccess)
        Me.Controls.Add(Me.grpInstellingen)
        Me.Controls.Add(Me.MenuStrip1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MainMenuStrip = Me.MenuStrip1
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmStart"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Instellingen"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.grpInstellingen.ResumeLayout(False)
        Me.grpInstellingen.PerformLayout()
        CType(Me.pctSQLGeldig, System.ComponentModel.ISupportInitialize).EndInit()
        Me.grpAccess.ResumeLayout(False)
        Me.grpAccess.PerformLayout()
        CType(Me.pctAccessGeldig, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents BeheerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents OpenConfigToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ConfigOpslaanToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents txtSQLServer As System.Windows.Forms.TextBox
    Friend WithEvents lblSQLServer As System.Windows.Forms.Label
    Friend WithEvents grpInstellingen As System.Windows.Forms.GroupBox
    Friend WithEvents txtSQLDatabase As System.Windows.Forms.TextBox
    Friend WithEvents lblSQLDatabase As System.Windows.Forms.Label
    Friend WithEvents chkIntegratedSecurity As System.Windows.Forms.CheckBox
    Friend WithEvents lblSQLPaswoord As System.Windows.Forms.Label
    Friend WithEvents lblSQLGebruiker As System.Windows.Forms.Label
    Friend WithEvents txtSQLGebruiker As System.Windows.Forms.TextBox
    Friend WithEvents txtSQLPaswoord As System.Windows.Forms.TextBox
    Friend WithEvents lblSQLGeldig As System.Windows.Forms.Label
    Friend WithEvents pctSQLGeldig As System.Windows.Forms.PictureBox
    Friend WithEvents grpAccess As System.Windows.Forms.GroupBox
    Friend WithEvents chkSQLOpslaan As System.Windows.Forms.CheckBox
    Friend WithEvents chkAccessOpslaan As System.Windows.Forms.CheckBox
    Friend WithEvents txtAccessBestand As System.Windows.Forms.TextBox
    Friend WithEvents lblAccessBestand As System.Windows.Forms.Label
    Friend WithEvents btnAccessOpenen As System.Windows.Forms.Button
    Friend WithEvents pctAccessGeldig As System.Windows.Forms.PictureBox
    Friend WithEvents lblAccessGeldig As System.Windows.Forms.Label
    Friend WithEvents txtAccessTabel As System.Windows.Forms.TextBox
    Friend WithEvents lblAccessTabel As System.Windows.Forms.Label
    Friend WithEvents lblAccessKolom As System.Windows.Forms.Label
    Friend WithEvents txtAccessKolom As System.Windows.Forms.TextBox
    Friend WithEvents btnSQLTestConnectie As System.Windows.Forms.Button
    Friend WithEvents btnUseConfig As System.Windows.Forms.Button
End Class
