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
        Me.pctExported = New System.Windows.Forms.PictureBox
        Me.btnDataExporteren = New System.Windows.Forms.Button
        Me.lblExported = New System.Windows.Forms.Label
        Me.btnBestandslocatie = New System.Windows.Forms.Button
        Me.txtBestandsLocatie = New System.Windows.Forms.TextBox
        Me.lblBestandsLocatie = New System.Windows.Forms.Label
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.SluitenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.grpSelecteerBestand.SuspendLayout()
        CType(Me.pctExported, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'grpSelecteerBestand
        '
        Me.grpSelecteerBestand.Controls.Add(Me.pctExported)
        Me.grpSelecteerBestand.Controls.Add(Me.btnDataExporteren)
        Me.grpSelecteerBestand.Controls.Add(Me.lblExported)
        Me.grpSelecteerBestand.Controls.Add(Me.btnBestandslocatie)
        Me.grpSelecteerBestand.Controls.Add(Me.txtBestandsLocatie)
        Me.grpSelecteerBestand.Controls.Add(Me.lblBestandsLocatie)
        Me.grpSelecteerBestand.Location = New System.Drawing.Point(17, 51)
        Me.grpSelecteerBestand.Name = "grpSelecteerBestand"
        Me.grpSelecteerBestand.Size = New System.Drawing.Size(482, 129)
        Me.grpSelecteerBestand.TabIndex = 2
        Me.grpSelecteerBestand.TabStop = False
        Me.grpSelecteerBestand.Text = "Selecteer Bestandslocatie"
        '
        'pctExported
        '
        Me.pctExported.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.pctExported.Location = New System.Drawing.Point(360, 105)
        Me.pctExported.Name = "pctExported"
        Me.pctExported.Size = New System.Drawing.Size(17, 14)
        Me.pctExported.TabIndex = 13
        Me.pctExported.TabStop = False
        '
        'btnDataExporteren
        '
        Me.btnDataExporteren.Location = New System.Drawing.Point(168, 100)
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
        Me.lblExported.Location = New System.Drawing.Point(383, 105)
        Me.lblExported.Name = "lblExported"
        Me.lblExported.Size = New System.Drawing.Size(93, 13)
        Me.lblExported.TabIndex = 12
        Me.lblExported.Text = "Niet Geëxporteerd"
        '
        'btnBestandslocatie
        '
        Me.btnBestandslocatie.Location = New System.Drawing.Point(401, 50)
        Me.btnBestandslocatie.Name = "btnBestandslocatie"
        Me.btnBestandslocatie.Size = New System.Drawing.Size(75, 23)
        Me.btnBestandslocatie.TabIndex = 2
        Me.btnBestandslocatie.Text = "Selecteer..."
        Me.btnBestandslocatie.UseVisualStyleBackColor = True
        '
        'txtBestandsLocatie
        '
        Me.txtBestandsLocatie.Location = New System.Drawing.Point(89, 24)
        Me.txtBestandsLocatie.Name = "txtBestandsLocatie"
        Me.txtBestandsLocatie.Size = New System.Drawing.Size(387, 20)
        Me.txtBestandsLocatie.TabIndex = 1
        '
        'lblBestandsLocatie
        '
        Me.lblBestandsLocatie.AutoSize = True
        Me.lblBestandsLocatie.Location = New System.Drawing.Point(6, 27)
        Me.lblBestandsLocatie.Name = "lblBestandsLocatie"
        Me.lblBestandsLocatie.Size = New System.Drawing.Size(85, 13)
        Me.lblBestandsLocatie.TabIndex = 0
        Me.lblBestandsLocatie.Text = "Bestandslocatie:"
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SluitenToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(514, 24)
        Me.MenuStrip1.TabIndex = 3
        Me.MenuStrip1.Text = "MenuStrip1"
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
        Me.Controls.Add(Me.MenuStrip1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MainMenuStrip = Me.MenuStrip1
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmExporteerNaarXML"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Exporteer Naar XML"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.grpSelecteerBestand.ResumeLayout(False)
        Me.grpSelecteerBestand.PerformLayout()
        CType(Me.pctExported, System.ComponentModel.ISupportInitialize).EndInit()
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents grpSelecteerBestand As System.Windows.Forms.GroupBox
    Friend WithEvents btnBestandslocatie As System.Windows.Forms.Button
    Friend WithEvents txtBestandsLocatie As System.Windows.Forms.TextBox
    Friend WithEvents lblBestandsLocatie As System.Windows.Forms.Label
    Friend WithEvents btnDataExporteren As System.Windows.Forms.Button
    Friend WithEvents pctExported As System.Windows.Forms.PictureBox
    Friend WithEvents lblExported As System.Windows.Forms.Label
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents SluitenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
End Class
