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
        Me.grpMenus = New System.Windows.Forms.GroupBox
        Me.lblDeelnameBeheer = New System.Windows.Forms.Label
        Me.btnDeelnameBeheer = New System.Windows.Forms.Button
        Me.lblSportBeheer = New System.Windows.Forms.Label
        Me.btnSportBeheer = New System.Windows.Forms.Button
        Me.lblStudentenBeheer = New System.Windows.Forms.Label
        Me.btlnStudentenBeheer = New System.Windows.Forms.Button
        Me.grpProcessen = New System.Windows.Forms.GroupBox
        Me.lblImporteerUitExcel = New System.Windows.Forms.Label
        Me.btnImporteerUitExcel = New System.Windows.Forms.Button
        Me.lblExporteerNaarXML = New System.Windows.Forms.Label
        Me.BtnExporteerNaarXML = New System.Windows.Forms.Button
        Me.lblExporteerNaarOracle2 = New System.Windows.Forms.Label
        Me.lblExporteerNaarOracle1 = New System.Windows.Forms.Label
        Me.btnExporteerNaarOracle = New System.Windows.Forms.Button
        Me.lblVergelijkMetAccess2 = New System.Windows.Forms.Label
        Me.lblVergelijkMetAccess1 = New System.Windows.Forms.Label
        Me.btnVergelijkMetAccess = New System.Windows.Forms.Button
        Me.grpConfig = New System.Windows.Forms.GroupBox
        Me.lblKolomAccessTekst = New System.Windows.Forms.Label
        Me.lblTabelAccessTekst = New System.Windows.Forms.Label
        Me.lblDatabaseAccessTekst = New System.Windows.Forms.Label
        Me.lblSQLGebruikerTekst = New System.Windows.Forms.Label
        Me.lblSQLDatabaseTekst = New System.Windows.Forms.Label
        Me.lblSQLServerTekst = New System.Windows.Forms.Label
        Me.btnConfigWijzigen = New System.Windows.Forms.Button
        Me.lblKolomAccess = New System.Windows.Forms.Label
        Me.lblTabelAccess = New System.Windows.Forms.Label
        Me.lblDatabaseAccess = New System.Windows.Forms.Label
        Me.lblSQLGebruiker = New System.Windows.Forms.Label
        Me.lblSQLDatabase = New System.Windows.Forms.Label
        Me.lblSQLServer = New System.Windows.Forms.Label
        Me.btnVerbindMetMySQL = New System.Windows.Forms.Button
        Me.lblVerbindMetMySQL = New System.Windows.Forms.Label
        Me.grpMenus.SuspendLayout()
        Me.grpProcessen.SuspendLayout()
        Me.grpConfig.SuspendLayout()
        Me.SuspendLayout()
        '
        'grpMenus
        '
        Me.grpMenus.Controls.Add(Me.lblDeelnameBeheer)
        Me.grpMenus.Controls.Add(Me.btnDeelnameBeheer)
        Me.grpMenus.Controls.Add(Me.lblSportBeheer)
        Me.grpMenus.Controls.Add(Me.btnSportBeheer)
        Me.grpMenus.Controls.Add(Me.lblStudentenBeheer)
        Me.grpMenus.Controls.Add(Me.btlnStudentenBeheer)
        Me.grpMenus.Location = New System.Drawing.Point(17, 35)
        Me.grpMenus.Name = "grpMenus"
        Me.grpMenus.Size = New System.Drawing.Size(482, 129)
        Me.grpMenus.TabIndex = 0
        Me.grpMenus.TabStop = False
        Me.grpMenus.Text = "Beheer"
        '
        'lblDeelnameBeheer
        '
        Me.lblDeelnameBeheer.AutoSize = True
        Me.lblDeelnameBeheer.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblDeelnameBeheer.Location = New System.Drawing.Point(151, 94)
        Me.lblDeelnameBeheer.Name = "lblDeelnameBeheer"
        Me.lblDeelnameBeheer.Size = New System.Drawing.Size(274, 15)
        Me.lblDeelnameBeheer.TabIndex = 5
        Me.lblDeelnameBeheer.Text = "Verwijder of voeg deelnames toe aan het syteem."
        '
        'btnDeelnameBeheer
        '
        Me.btnDeelnameBeheer.Location = New System.Drawing.Point(20, 91)
        Me.btnDeelnameBeheer.Name = "btnDeelnameBeheer"
        Me.btnDeelnameBeheer.Size = New System.Drawing.Size(125, 23)
        Me.btnDeelnameBeheer.TabIndex = 4
        Me.btnDeelnameBeheer.Text = "Deelnamebeheer"
        Me.btnDeelnameBeheer.UseVisualStyleBackColor = True
        '
        'lblSportBeheer
        '
        Me.lblSportBeheer.AutoSize = True
        Me.lblSportBeheer.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblSportBeheer.Location = New System.Drawing.Point(151, 62)
        Me.lblSportBeheer.Name = "lblSportBeheer"
        Me.lblSportBeheer.Size = New System.Drawing.Size(318, 15)
        Me.lblSportBeheer.TabIndex = 3
        Me.lblSportBeheer.Text = "Wijzig, verwijder of voeg sporttakken toe aan het systeem."
        '
        'btnSportBeheer
        '
        Me.btnSportBeheer.Location = New System.Drawing.Point(20, 59)
        Me.btnSportBeheer.Name = "btnSportBeheer"
        Me.btnSportBeheer.Size = New System.Drawing.Size(125, 23)
        Me.btnSportBeheer.TabIndex = 2
        Me.btnSportBeheer.Text = "Sporttakkenbeheer"
        Me.btnSportBeheer.UseVisualStyleBackColor = True
        '
        'lblStudentenBeheer
        '
        Me.lblStudentenBeheer.AutoSize = True
        Me.lblStudentenBeheer.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblStudentenBeheer.Location = New System.Drawing.Point(151, 28)
        Me.lblStudentenBeheer.Name = "lblStudentenBeheer"
        Me.lblStudentenBeheer.Size = New System.Drawing.Size(309, 15)
        Me.lblStudentenBeheer.TabIndex = 1
        Me.lblStudentenBeheer.Text = "Wijzig, verwijder of voeg studenten toe aan het systeem."
        '
        'btlnStudentenBeheer
        '
        Me.btlnStudentenBeheer.Location = New System.Drawing.Point(20, 25)
        Me.btlnStudentenBeheer.Name = "btlnStudentenBeheer"
        Me.btlnStudentenBeheer.Size = New System.Drawing.Size(125, 23)
        Me.btlnStudentenBeheer.TabIndex = 0
        Me.btlnStudentenBeheer.Text = "Studentenbeheer"
        Me.btlnStudentenBeheer.UseVisualStyleBackColor = True
        '
        'grpProcessen
        '
        Me.grpProcessen.Controls.Add(Me.lblVerbindMetMySQL)
        Me.grpProcessen.Controls.Add(Me.btnVerbindMetMySQL)
        Me.grpProcessen.Controls.Add(Me.lblImporteerUitExcel)
        Me.grpProcessen.Controls.Add(Me.btnImporteerUitExcel)
        Me.grpProcessen.Controls.Add(Me.lblExporteerNaarXML)
        Me.grpProcessen.Controls.Add(Me.BtnExporteerNaarXML)
        Me.grpProcessen.Controls.Add(Me.lblExporteerNaarOracle2)
        Me.grpProcessen.Controls.Add(Me.lblExporteerNaarOracle1)
        Me.grpProcessen.Controls.Add(Me.btnExporteerNaarOracle)
        Me.grpProcessen.Controls.Add(Me.lblVergelijkMetAccess2)
        Me.grpProcessen.Controls.Add(Me.lblVergelijkMetAccess1)
        Me.grpProcessen.Controls.Add(Me.btnVergelijkMetAccess)
        Me.grpProcessen.Location = New System.Drawing.Point(17, 170)
        Me.grpProcessen.Name = "grpProcessen"
        Me.grpProcessen.Size = New System.Drawing.Size(482, 190)
        Me.grpProcessen.TabIndex = 1
        Me.grpProcessen.TabStop = False
        Me.grpProcessen.Text = "Processen"
        '
        'lblImporteerUitExcel
        '
        Me.lblImporteerUitExcel.AutoSize = True
        Me.lblImporteerUitExcel.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblImporteerUitExcel.Location = New System.Drawing.Point(151, 132)
        Me.lblImporteerUitExcel.Name = "lblImporteerUitExcel"
        Me.lblImporteerUitExcel.Size = New System.Drawing.Size(265, 15)
        Me.lblImporteerUitExcel.TabIndex = 9
        Me.lblImporteerUitExcel.Text = "Importeer studentendata uit een Excel-bestand."
        '
        'btnImporteerUitExcel
        '
        Me.btnImporteerUitExcel.Location = New System.Drawing.Point(20, 129)
        Me.btnImporteerUitExcel.Name = "btnImporteerUitExcel"
        Me.btnImporteerUitExcel.Size = New System.Drawing.Size(125, 23)
        Me.btnImporteerUitExcel.TabIndex = 8
        Me.btnImporteerUitExcel.Text = "Importeer Uit Excel"
        Me.btnImporteerUitExcel.UseVisualStyleBackColor = True
        '
        'lblExporteerNaarXML
        '
        Me.lblExporteerNaarXML.AutoSize = True
        Me.lblExporteerNaarXML.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblExporteerNaarXML.Location = New System.Drawing.Point(151, 98)
        Me.lblExporteerNaarXML.Name = "lblExporteerNaarXML"
        Me.lblExporteerNaarXML.Size = New System.Drawing.Size(247, 15)
        Me.lblExporteerNaarXML.TabIndex = 7
        Me.lblExporteerNaarXML.Text = "Exporteer het deelnameoverzicht naar XML."
        '
        'BtnExporteerNaarXML
        '
        Me.BtnExporteerNaarXML.Location = New System.Drawing.Point(20, 95)
        Me.BtnExporteerNaarXML.Name = "BtnExporteerNaarXML"
        Me.BtnExporteerNaarXML.Size = New System.Drawing.Size(125, 23)
        Me.BtnExporteerNaarXML.TabIndex = 6
        Me.BtnExporteerNaarXML.Text = "Exporteer Naar XML"
        Me.BtnExporteerNaarXML.UseVisualStyleBackColor = True
        '
        'lblExporteerNaarOracle2
        '
        Me.lblExporteerNaarOracle2.AutoSize = True
        Me.lblExporteerNaarOracle2.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblExporteerNaarOracle2.Location = New System.Drawing.Point(151, 70)
        Me.lblExporteerNaarOracle2.Name = "lblExporteerNaarOracle2"
        Me.lblExporteerNaarOracle2.Size = New System.Drawing.Size(134, 15)
        Me.lblExporteerNaarOracle2.TabIndex = 5
        Me.lblExporteerNaarOracle2.Text = "Oracle-database staan."
        '
        'lblExporteerNaarOracle1
        '
        Me.lblExporteerNaarOracle1.AutoSize = True
        Me.lblExporteerNaarOracle1.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblExporteerNaarOracle1.Location = New System.Drawing.Point(151, 55)
        Me.lblExporteerNaarOracle1.Name = "lblExporteerNaarOracle1"
        Me.lblExporteerNaarOracle1.Size = New System.Drawing.Size(296, 15)
        Me.lblExporteerNaarOracle1.TabIndex = 4
        Me.lblExporteerNaarOracle1.Text = "Exporteer sportnamen naar Oracle die nog niet in de "
        '
        'btnExporteerNaarOracle
        '
        Me.btnExporteerNaarOracle.Location = New System.Drawing.Point(20, 60)
        Me.btnExporteerNaarOracle.Name = "btnExporteerNaarOracle"
        Me.btnExporteerNaarOracle.Size = New System.Drawing.Size(125, 23)
        Me.btnExporteerNaarOracle.TabIndex = 3
        Me.btnExporteerNaarOracle.Text = "Exporteer Naar Oracle"
        Me.btnExporteerNaarOracle.UseVisualStyleBackColor = True
        '
        'lblVergelijkMetAccess2
        '
        Me.lblVergelijkMetAccess2.AutoSize = True
        Me.lblVergelijkMetAccess2.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblVergelijkMetAccess2.Location = New System.Drawing.Point(151, 34)
        Me.lblVergelijkMetAccess2.Name = "lblVergelijkMetAccess2"
        Me.lblVergelijkMetAccess2.Size = New System.Drawing.Size(106, 15)
        Me.lblVergelijkMetAccess2.TabIndex = 2
        Me.lblVergelijkMetAccess2.Text = "de SQL-database."
        '
        'lblVergelijkMetAccess1
        '
        Me.lblVergelijkMetAccess1.AutoSize = True
        Me.lblVergelijkMetAccess1.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblVergelijkMetAccess1.Location = New System.Drawing.Point(151, 19)
        Me.lblVergelijkMetAccess1.Name = "lblVergelijkMetAccess1"
        Me.lblVergelijkMetAccess1.Size = New System.Drawing.Size(284, 15)
        Me.lblVergelijkMetAccess1.TabIndex = 1
        Me.lblVergelijkMetAccess1.Text = "Vergelijk de E-mailadressen in Access met die van "
        '
        'btnVergelijkMetAccess
        '
        Me.btnVergelijkMetAccess.Location = New System.Drawing.Point(20, 23)
        Me.btnVergelijkMetAccess.Name = "btnVergelijkMetAccess"
        Me.btnVergelijkMetAccess.Size = New System.Drawing.Size(125, 23)
        Me.btnVergelijkMetAccess.TabIndex = 0
        Me.btnVergelijkMetAccess.Text = "Vergelijk Met Access"
        Me.btnVergelijkMetAccess.UseVisualStyleBackColor = True
        '
        'grpConfig
        '
        Me.grpConfig.Controls.Add(Me.lblKolomAccessTekst)
        Me.grpConfig.Controls.Add(Me.lblTabelAccessTekst)
        Me.grpConfig.Controls.Add(Me.lblDatabaseAccessTekst)
        Me.grpConfig.Controls.Add(Me.lblSQLGebruikerTekst)
        Me.grpConfig.Controls.Add(Me.lblSQLDatabaseTekst)
        Me.grpConfig.Controls.Add(Me.lblSQLServerTekst)
        Me.grpConfig.Controls.Add(Me.btnConfigWijzigen)
        Me.grpConfig.Controls.Add(Me.lblKolomAccess)
        Me.grpConfig.Controls.Add(Me.lblTabelAccess)
        Me.grpConfig.Controls.Add(Me.lblDatabaseAccess)
        Me.grpConfig.Controls.Add(Me.lblSQLGebruiker)
        Me.grpConfig.Controls.Add(Me.lblSQLDatabase)
        Me.grpConfig.Controls.Add(Me.lblSQLServer)
        Me.grpConfig.Location = New System.Drawing.Point(17, 366)
        Me.grpConfig.Name = "grpConfig"
        Me.grpConfig.Size = New System.Drawing.Size(482, 148)
        Me.grpConfig.TabIndex = 2
        Me.grpConfig.TabStop = False
        Me.grpConfig.Text = "Instellingen"
        '
        'lblKolomAccessTekst
        '
        Me.lblKolomAccessTekst.AutoSize = True
        Me.lblKolomAccessTekst.Location = New System.Drawing.Point(114, 109)
        Me.lblKolomAccessTekst.Name = "lblKolomAccessTekst"
        Me.lblKolomAccessTekst.Size = New System.Drawing.Size(71, 13)
        Me.lblKolomAccessTekst.TabIndex = 12
        Me.lblKolomAccessTekst.Text = "AccessKolom"
        '
        'lblTabelAccessTekst
        '
        Me.lblTabelAccessTekst.AutoSize = True
        Me.lblTabelAccessTekst.Location = New System.Drawing.Point(114, 94)
        Me.lblTabelAccessTekst.Name = "lblTabelAccessTekst"
        Me.lblTabelAccessTekst.Size = New System.Drawing.Size(69, 13)
        Me.lblTabelAccessTekst.TabIndex = 11
        Me.lblTabelAccessTekst.Text = "AccessTabel"
        '
        'lblDatabaseAccessTekst
        '
        Me.lblDatabaseAccessTekst.AutoSize = True
        Me.lblDatabaseAccessTekst.Location = New System.Drawing.Point(114, 79)
        Me.lblDatabaseAccessTekst.Name = "lblDatabaseAccessTekst"
        Me.lblDatabaseAccessTekst.Size = New System.Drawing.Size(88, 13)
        Me.lblDatabaseAccessTekst.TabIndex = 10
        Me.lblDatabaseAccessTekst.Text = "AccessDatabase"
        '
        'lblSQLGebruikerTekst
        '
        Me.lblSQLGebruikerTekst.AutoSize = True
        Me.lblSQLGebruikerTekst.Location = New System.Drawing.Point(114, 53)
        Me.lblSQLGebruikerTekst.Name = "lblSQLGebruikerTekst"
        Me.lblSQLGebruikerTekst.Size = New System.Drawing.Size(74, 13)
        Me.lblSQLGebruikerTekst.TabIndex = 9
        Me.lblSQLGebruikerTekst.Text = "SQLGebruiker"
        '
        'lblSQLDatabaseTekst
        '
        Me.lblSQLDatabaseTekst.AutoSize = True
        Me.lblSQLDatabaseTekst.Location = New System.Drawing.Point(114, 36)
        Me.lblSQLDatabaseTekst.Name = "lblSQLDatabaseTekst"
        Me.lblSQLDatabaseTekst.Size = New System.Drawing.Size(74, 13)
        Me.lblSQLDatabaseTekst.TabIndex = 8
        Me.lblSQLDatabaseTekst.Text = "SQLDatabase"
        '
        'lblSQLServerTekst
        '
        Me.lblSQLServerTekst.AutoSize = True
        Me.lblSQLServerTekst.Location = New System.Drawing.Point(114, 19)
        Me.lblSQLServerTekst.Name = "lblSQLServerTekst"
        Me.lblSQLServerTekst.Size = New System.Drawing.Size(59, 13)
        Me.lblSQLServerTekst.TabIndex = 7
        Me.lblSQLServerTekst.Text = "SQLServer"
        '
        'btnConfigWijzigen
        '
        Me.btnConfigWijzigen.Location = New System.Drawing.Point(360, 120)
        Me.btnConfigWijzigen.Name = "btnConfigWijzigen"
        Me.btnConfigWijzigen.Size = New System.Drawing.Size(116, 22)
        Me.btnConfigWijzigen.TabIndex = 6
        Me.btnConfigWijzigen.Text = "Wijzig Configuratie"
        Me.btnConfigWijzigen.UseVisualStyleBackColor = True
        '
        'lblKolomAccess
        '
        Me.lblKolomAccess.AutoSize = True
        Me.lblKolomAccess.Location = New System.Drawing.Point(17, 109)
        Me.lblKolomAccess.Name = "lblKolomAccess"
        Me.lblKolomAccess.Size = New System.Drawing.Size(77, 13)
        Me.lblKolomAccess.TabIndex = 5
        Me.lblKolomAccess.Text = "Access-Kolom:"
        '
        'lblTabelAccess
        '
        Me.lblTabelAccess.AutoSize = True
        Me.lblTabelAccess.Location = New System.Drawing.Point(17, 94)
        Me.lblTabelAccess.Name = "lblTabelAccess"
        Me.lblTabelAccess.Size = New System.Drawing.Size(75, 13)
        Me.lblTabelAccess.TabIndex = 4
        Me.lblTabelAccess.Text = "Access-Tabel:"
        '
        'lblDatabaseAccess
        '
        Me.lblDatabaseAccess.AutoSize = True
        Me.lblDatabaseAccess.Location = New System.Drawing.Point(17, 79)
        Me.lblDatabaseAccess.Name = "lblDatabaseAccess"
        Me.lblDatabaseAccess.Size = New System.Drawing.Size(94, 13)
        Me.lblDatabaseAccess.TabIndex = 3
        Me.lblDatabaseAccess.Text = "Access-Database:"
        '
        'lblSQLGebruiker
        '
        Me.lblSQLGebruiker.AutoSize = True
        Me.lblSQLGebruiker.Location = New System.Drawing.Point(17, 53)
        Me.lblSQLGebruiker.Name = "lblSQLGebruiker"
        Me.lblSQLGebruiker.Size = New System.Drawing.Size(80, 13)
        Me.lblSQLGebruiker.TabIndex = 2
        Me.lblSQLGebruiker.Text = "SQL-Gebruiker:"
        '
        'lblSQLDatabase
        '
        Me.lblSQLDatabase.AutoSize = True
        Me.lblSQLDatabase.Location = New System.Drawing.Point(17, 36)
        Me.lblSQLDatabase.Name = "lblSQLDatabase"
        Me.lblSQLDatabase.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lblSQLDatabase.Size = New System.Drawing.Size(80, 13)
        Me.lblSQLDatabase.TabIndex = 1
        Me.lblSQLDatabase.Text = "SQL-Database:"
        '
        'lblSQLServer
        '
        Me.lblSQLServer.AutoSize = True
        Me.lblSQLServer.Location = New System.Drawing.Point(17, 19)
        Me.lblSQLServer.Name = "lblSQLServer"
        Me.lblSQLServer.Size = New System.Drawing.Size(65, 13)
        Me.lblSQLServer.TabIndex = 0
        Me.lblSQLServer.Text = "SQL-Server:"
        '
        'btnVerbindMetMySQL
        '
        Me.btnVerbindMetMySQL.Location = New System.Drawing.Point(20, 161)
        Me.btnVerbindMetMySQL.Name = "btnVerbindMetMySQL"
        Me.btnVerbindMetMySQL.Size = New System.Drawing.Size(125, 23)
        Me.btnVerbindMetMySQL.TabIndex = 10
        Me.btnVerbindMetMySQL.Text = "Verbind Met MySQL"
        Me.btnVerbindMetMySQL.UseVisualStyleBackColor = True
        '
        'lblVerbindMetMySQL
        '
        Me.lblVerbindMetMySQL.AutoSize = True
        Me.lblVerbindMetMySQL.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblVerbindMetMySQL.Location = New System.Drawing.Point(151, 164)
        Me.lblVerbindMetMySQL.Name = "lblVerbindMetMySQL"
        Me.lblVerbindMetMySQL.Size = New System.Drawing.Size(200, 15)
        Me.lblVerbindMetMySQL.TabIndex = 11
        Me.lblVerbindMetMySQL.Text = "Verbind met een MySQL-Database."
        '
        'frmStart
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.grpConfig)
        Me.Controls.Add(Me.grpProcessen)
        Me.Controls.Add(Me.grpMenus)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmStart"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Overzicht"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.grpMenus.ResumeLayout(False)
        Me.grpMenus.PerformLayout()
        Me.grpProcessen.ResumeLayout(False)
        Me.grpProcessen.PerformLayout()
        Me.grpConfig.ResumeLayout(False)
        Me.grpConfig.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents grpMenus As System.Windows.Forms.GroupBox
    Friend WithEvents btlnStudentenBeheer As System.Windows.Forms.Button
    Friend WithEvents lblStudentenBeheer As System.Windows.Forms.Label
    Friend WithEvents btnSportBeheer As System.Windows.Forms.Button
    Friend WithEvents lblSportBeheer As System.Windows.Forms.Label
    Friend WithEvents btnDeelnameBeheer As System.Windows.Forms.Button
    Friend WithEvents lblDeelnameBeheer As System.Windows.Forms.Label
    Friend WithEvents grpProcessen As System.Windows.Forms.GroupBox
    Friend WithEvents btnVergelijkMetAccess As System.Windows.Forms.Button
    Friend WithEvents lblVergelijkMetAccess1 As System.Windows.Forms.Label
    Friend WithEvents lblVergelijkMetAccess2 As System.Windows.Forms.Label
    Friend WithEvents btnExporteerNaarOracle As System.Windows.Forms.Button
    Friend WithEvents lblExporteerNaarOracle2 As System.Windows.Forms.Label
    Friend WithEvents lblExporteerNaarOracle1 As System.Windows.Forms.Label
    Friend WithEvents BtnExporteerNaarXML As System.Windows.Forms.Button
    Friend WithEvents lblExporteerNaarXML As System.Windows.Forms.Label
    Friend WithEvents btnImporteerUitExcel As System.Windows.Forms.Button
    Friend WithEvents lblImporteerUitExcel As System.Windows.Forms.Label
    Friend WithEvents grpConfig As System.Windows.Forms.GroupBox
    Friend WithEvents lblSQLGebruiker As System.Windows.Forms.Label
    Friend WithEvents lblSQLDatabase As System.Windows.Forms.Label
    Friend WithEvents lblSQLServer As System.Windows.Forms.Label
    Friend WithEvents lblDatabaseAccess As System.Windows.Forms.Label
    Friend WithEvents lblKolomAccess As System.Windows.Forms.Label
    Friend WithEvents lblTabelAccess As System.Windows.Forms.Label
    Friend WithEvents btnConfigWijzigen As System.Windows.Forms.Button
    Friend WithEvents lblKolomAccessTekst As System.Windows.Forms.Label
    Friend WithEvents lblTabelAccessTekst As System.Windows.Forms.Label
    Friend WithEvents lblDatabaseAccessTekst As System.Windows.Forms.Label
    Friend WithEvents lblSQLGebruikerTekst As System.Windows.Forms.Label
    Friend WithEvents lblSQLDatabaseTekst As System.Windows.Forms.Label
    Friend WithEvents lblSQLServerTekst As System.Windows.Forms.Label
    Friend WithEvents btnVerbindMetMySQL As System.Windows.Forms.Button
    Friend WithEvents lblVerbindMetMySQL As System.Windows.Forms.Label
End Class
