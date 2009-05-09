<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmExporteerNaarXML
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
        Me.grpSelecteerBestand = New System.Windows.Forms.GroupBox
        Me.btnBestandOpenen = New System.Windows.Forms.Button
        Me.picExported = New System.Windows.Forms.PictureBox
        Me.btnDataExporteren = New System.Windows.Forms.Button
        Me.lblExported = New System.Windows.Forms.Label
        Me.txtBestandsLocatie = New System.Windows.Forms.TextBox
        Me.lblBestandsLocatie = New System.Windows.Forms.Label
        Me.mnuExporteerNaarXML = New System.Windows.Forms.MenuStrip
        Me.SluitenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.grpSelecteerBestand.SuspendLayout()
        CType(Me.picExported, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.mnuExporteerNaarXML.SuspendLayout()
        Me.SuspendLayout()
        '
        'grpSelecteerBestand
        '
        Me.grpSelecteerBestand.Controls.Add(Me.btnBestandOpenen)
        Me.grpSelecteerBestand.Controls.Add(Me.picExported)
        Me.grpSelecteerBestand.Controls.Add(Me.btnDataExporteren)
        Me.grpSelecteerBestand.Controls.Add(Me.lblExported)
        Me.grpSelecteerBestand.Controls.Add(Me.txtBestandsLocatie)
        Me.grpSelecteerBestand.Controls.Add(Me.lblBestandsLocatie)
        Me.grpSelecteerBestand.Location = New System.Drawing.Point(17, 51)
        Me.grpSelecteerBestand.Name = "grpSelecteerBestand"
        Me.grpSelecteerBestand.Size = New System.Drawing.Size(482, 129)
        Me.grpSelecteerBestand.TabIndex = 2
        Me.grpSelecteerBestand.TabStop = False
        Me.grpSelecteerBestand.Text = "Selecteer Bestandslocatie"
        '
        'btnBestandOpenen
        '
        Me.btnBestandOpenen.Enabled = False
        Me.btnBestandOpenen.Location = New System.Drawing.Point(357, 83)
        Me.btnBestandOpenen.Name = "btnBestandOpenen"
        Me.btnBestandOpenen.Size = New System.Drawing.Size(119, 23)
        Me.btnBestandOpenen.TabIndex = 14
        Me.btnBestandOpenen.Text = "Bestand Openen"
        Me.btnBestandOpenen.UseVisualStyleBackColor = True
        '
        'picExported
        '
        Me.picExported.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.picExported.Location = New System.Drawing.Point(140, 24)
        Me.picExported.Name = "picExported"
        Me.picExported.Size = New System.Drawing.Size(17, 14)
        Me.picExported.TabIndex = 13
        Me.picExported.TabStop = False
        '
        'btnDataExporteren
        '
        Me.btnDataExporteren.Location = New System.Drawing.Point(9, 19)
        Me.btnDataExporteren.Name = "btnDataExporteren"
        Me.btnDataExporteren.Size = New System.Drawing.Size(126, 23)
        Me.btnDataExporteren.TabIndex = 3
        Me.btnDataExporteren.Text = "Data Exporteren"
        Me.btnDataExporteren.UseVisualStyleBackColor = True
        '
        'lblExported
        '
        Me.lblExported.AutoSize = True
        Me.lblExported.ForeColor = System.Drawing.Color.Firebrick
        Me.lblExported.Location = New System.Drawing.Point(163, 24)
        Me.lblExported.Name = "lblExported"
        Me.lblExported.Size = New System.Drawing.Size(93, 13)
        Me.lblExported.TabIndex = 12
        Me.lblExported.Text = "Niet Geëxporteerd"
        '
        'txtBestandsLocatie
        '
        Me.txtBestandsLocatie.Enabled = False
        Me.txtBestandsLocatie.Location = New System.Drawing.Point(89, 57)
        Me.txtBestandsLocatie.Name = "txtBestandsLocatie"
        Me.txtBestandsLocatie.Size = New System.Drawing.Size(387, 20)
        Me.txtBestandsLocatie.TabIndex = 1
        '
        'lblBestandsLocatie
        '
        Me.lblBestandsLocatie.AutoSize = True
        Me.lblBestandsLocatie.Location = New System.Drawing.Point(6, 60)
        Me.lblBestandsLocatie.Name = "lblBestandsLocatie"
        Me.lblBestandsLocatie.Size = New System.Drawing.Size(85, 13)
        Me.lblBestandsLocatie.TabIndex = 0
        Me.lblBestandsLocatie.Text = "Bestandslocatie:"
        '
        'mnuExporteerNaarXML
        '
        Me.mnuExporteerNaarXML.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SluitenToolStripMenuItem})
        Me.mnuExporteerNaarXML.Location = New System.Drawing.Point(0, 0)
        Me.mnuExporteerNaarXML.Name = "mnuExporteerNaarXML"
        Me.mnuExporteerNaarXML.Size = New System.Drawing.Size(514, 24)
        Me.mnuExporteerNaarXML.TabIndex = 3
        Me.mnuExporteerNaarXML.Text = "Exporteer Naar XML"
        '
        'SluitenToolStripMenuItem
        '
        Me.SluitenToolStripMenuItem.Name = "SluitenToolStripMenuItem"
        Me.SluitenToolStripMenuItem.Size = New System.Drawing.Size(51, 20)
        Me.SluitenToolStripMenuItem.Text = "Sluiten"
        '
        'frmExporteerNaarXML
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.grpSelecteerBestand)
        Me.Controls.Add(Me.mnuExporteerNaarXML)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MainMenuStrip = Me.mnuExporteerNaarXML
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmExporteerNaarXML"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Exporteer Naar XML"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.grpSelecteerBestand.ResumeLayout(False)
        Me.grpSelecteerBestand.PerformLayout()
        CType(Me.picExported, System.ComponentModel.ISupportInitialize).EndInit()
        Me.mnuExporteerNaarXML.ResumeLayout(False)
        Me.mnuExporteerNaarXML.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents grpSelecteerBestand As System.Windows.Forms.GroupBox
    Friend WithEvents lblBestandsLocatie As System.Windows.Forms.Label
    Friend WithEvents btnDataExporteren As System.Windows.Forms.Button
    Friend WithEvents picExported As System.Windows.Forms.PictureBox
    Friend WithEvents lblExported As System.Windows.Forms.Label
    Friend WithEvents mnuExporteerNaarXML As System.Windows.Forms.MenuStrip
    Friend WithEvents SluitenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents txtBestandsLocatie As System.Windows.Forms.TextBox
    Friend WithEvents btnBestandOpenen As System.Windows.Forms.Button
End Class
