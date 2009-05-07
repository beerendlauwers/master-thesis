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
        Me.grpMenus.SuspendLayout()
        Me.grpProcessen.SuspendLayout()
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
        Me.grpMenus.Location = New System.Drawing.Point(17, 51)
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
        Me.grpProcessen.Location = New System.Drawing.Point(17, 186)
        Me.grpProcessen.Name = "grpProcessen"
        Me.grpProcessen.Size = New System.Drawing.Size(482, 172)
        Me.grpProcessen.TabIndex = 1
        Me.grpProcessen.TabStop = False
        Me.grpProcessen.Text = "Processen"
        '
        'lblImporteerUitExcel
        '
        Me.lblImporteerUitExcel.AutoSize = True
        Me.lblImporteerUitExcel.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblImporteerUitExcel.Location = New System.Drawing.Point(151, 136)
        Me.lblImporteerUitExcel.Name = "lblImporteerUitExcel"
        Me.lblImporteerUitExcel.Size = New System.Drawing.Size(265, 15)
        Me.lblImporteerUitExcel.TabIndex = 9
        Me.lblImporteerUitExcel.Text = "Importeer studentendata uit een Excel-bestand."
        '
        'btnImporteerUitExcel
        '
        Me.btnImporteerUitExcel.Location = New System.Drawing.Point(20, 133)
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
        Me.lblExporteerNaarXML.Location = New System.Drawing.Point(151, 102)
        Me.lblExporteerNaarXML.Name = "lblExporteerNaarXML"
        Me.lblExporteerNaarXML.Size = New System.Drawing.Size(247, 15)
        Me.lblExporteerNaarXML.TabIndex = 7
        Me.lblExporteerNaarXML.Text = "Exporteer het deelnameoverzicht naar XML."
        '
        'BtnExporteerNaarXML
        '
        Me.BtnExporteerNaarXML.Location = New System.Drawing.Point(20, 99)
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
        Me.lblExporteerNaarOracle2.Location = New System.Drawing.Point(151, 72)
        Me.lblExporteerNaarOracle2.Name = "lblExporteerNaarOracle2"
        Me.lblExporteerNaarOracle2.Size = New System.Drawing.Size(134, 15)
        Me.lblExporteerNaarOracle2.TabIndex = 5
        Me.lblExporteerNaarOracle2.Text = "Oracle-database staan."
        '
        'lblExporteerNaarOracle1
        '
        Me.lblExporteerNaarOracle1.AutoSize = True
        Me.lblExporteerNaarOracle1.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.0!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblExporteerNaarOracle1.Location = New System.Drawing.Point(151, 57)
        Me.lblExporteerNaarOracle1.Name = "lblExporteerNaarOracle1"
        Me.lblExporteerNaarOracle1.Size = New System.Drawing.Size(296, 15)
        Me.lblExporteerNaarOracle1.TabIndex = 4
        Me.lblExporteerNaarOracle1.Text = "Exporteer sportnamen naar Oracle die nog niet in de "
        '
        'btnExporteerNaarOracle
        '
        Me.btnExporteerNaarOracle.Location = New System.Drawing.Point(20, 62)
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
        'frmStart
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
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
End Class
