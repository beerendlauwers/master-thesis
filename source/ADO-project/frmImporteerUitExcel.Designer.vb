<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmImporteerUitExcel
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
        Me.txtExcelSheet = New System.Windows.Forms.TextBox
        Me.lblExcelSheet = New System.Windows.Forms.Label
        Me.pctGeldigFormaat = New System.Windows.Forms.PictureBox
        Me.lblGeldigFormaat = New System.Windows.Forms.Label
        Me.btnExcelBestandOpene = New System.Windows.Forms.Button
        Me.txtExcelBestand = New System.Windows.Forms.TextBox
        Me.lblExcelBestand = New System.Windows.Forms.Label
        Me.btnHaalDataOp = New System.Windows.Forms.Button
        Me.dtgExcelData = New System.Windows.Forms.DataGridView
        Me.lblSuccess = New System.Windows.Forms.Label
        Me.btnDataOpslaan = New System.Windows.Forms.Button
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.SluitenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.pctSuccess = New System.Windows.Forms.PictureBox
        Me.grpSelecteerBestand.SuspendLayout()
        CType(Me.pctGeldigFormaat, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dtgExcelData, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.MenuStrip1.SuspendLayout()
        CType(Me.pctSuccess, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'grpSelecteerBestand
        '
        Me.grpSelecteerBestand.Controls.Add(Me.txtExcelSheet)
        Me.grpSelecteerBestand.Controls.Add(Me.lblExcelSheet)
        Me.grpSelecteerBestand.Controls.Add(Me.pctGeldigFormaat)
        Me.grpSelecteerBestand.Controls.Add(Me.lblGeldigFormaat)
        Me.grpSelecteerBestand.Controls.Add(Me.btnExcelBestandOpene)
        Me.grpSelecteerBestand.Controls.Add(Me.txtExcelBestand)
        Me.grpSelecteerBestand.Controls.Add(Me.lblExcelBestand)
        Me.grpSelecteerBestand.Location = New System.Drawing.Point(17, 51)
        Me.grpSelecteerBestand.Name = "grpSelecteerBestand"
        Me.grpSelecteerBestand.Size = New System.Drawing.Size(482, 129)
        Me.grpSelecteerBestand.TabIndex = 1
        Me.grpSelecteerBestand.TabStop = False
        Me.grpSelecteerBestand.Text = "Selecteer Bestand"
        '
        'txtExcelSheet
        '
        Me.txtExcelSheet.Location = New System.Drawing.Point(89, 57)
        Me.txtExcelSheet.Name = "txtExcelSheet"
        Me.txtExcelSheet.Size = New System.Drawing.Size(179, 20)
        Me.txtExcelSheet.TabIndex = 15
        '
        'lblExcelSheet
        '
        Me.lblExcelSheet.AutoSize = True
        Me.lblExcelSheet.Location = New System.Drawing.Point(6, 60)
        Me.lblExcelSheet.Name = "lblExcelSheet"
        Me.lblExcelSheet.Size = New System.Drawing.Size(64, 13)
        Me.lblExcelSheet.TabIndex = 14
        Me.lblExcelSheet.Text = "Sheetnaam:"
        '
        'pctGeldigFormaat
        '
        Me.pctGeldigFormaat.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.pctGeldigFormaat.Location = New System.Drawing.Point(363, 104)
        Me.pctGeldigFormaat.Name = "pctGeldigFormaat"
        Me.pctGeldigFormaat.Size = New System.Drawing.Size(17, 14)
        Me.pctGeldigFormaat.TabIndex = 13
        Me.pctGeldigFormaat.TabStop = False
        '
        'lblGeldigFormaat
        '
        Me.lblGeldigFormaat.AutoSize = True
        Me.lblGeldigFormaat.ForeColor = System.Drawing.Color.Firebrick
        Me.lblGeldigFormaat.Location = New System.Drawing.Point(386, 104)
        Me.lblGeldigFormaat.Name = "lblGeldigFormaat"
        Me.lblGeldigFormaat.Size = New System.Drawing.Size(90, 13)
        Me.lblGeldigFormaat.TabIndex = 12
        Me.lblGeldigFormaat.Text = "Ongeldig Formaat"
        '
        'btnExcelBestandOpene
        '
        Me.btnExcelBestandOpene.Location = New System.Drawing.Point(401, 50)
        Me.btnExcelBestandOpene.Name = "btnExcelBestandOpene"
        Me.btnExcelBestandOpene.Size = New System.Drawing.Size(75, 23)
        Me.btnExcelBestandOpene.TabIndex = 2
        Me.btnExcelBestandOpene.Text = "Openen..."
        Me.btnExcelBestandOpene.UseVisualStyleBackColor = True
        '
        'txtExcelBestand
        '
        Me.txtExcelBestand.Location = New System.Drawing.Point(89, 24)
        Me.txtExcelBestand.Name = "txtExcelBestand"
        Me.txtExcelBestand.Size = New System.Drawing.Size(387, 20)
        Me.txtExcelBestand.TabIndex = 1
        '
        'lblExcelBestand
        '
        Me.lblExcelBestand.AutoSize = True
        Me.lblExcelBestand.Location = New System.Drawing.Point(6, 27)
        Me.lblExcelBestand.Name = "lblExcelBestand"
        Me.lblExcelBestand.Size = New System.Drawing.Size(77, 13)
        Me.lblExcelBestand.TabIndex = 0
        Me.lblExcelBestand.Text = "Excel-bestand:"
        '
        'btnHaalDataOp
        '
        Me.btnHaalDataOp.Enabled = False
        Me.btnHaalDataOp.Location = New System.Drawing.Point(123, 191)
        Me.btnHaalDataOp.Name = "btnHaalDataOp"
        Me.btnHaalDataOp.Size = New System.Drawing.Size(250, 23)
        Me.btnHaalDataOp.TabIndex = 2
        Me.btnHaalDataOp.Text = "Haal Data Op"
        Me.btnHaalDataOp.UseVisualStyleBackColor = True
        '
        'dtgExcelData
        '
        Me.dtgExcelData.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dtgExcelData.Location = New System.Drawing.Point(12, 234)
        Me.dtgExcelData.Name = "dtgExcelData"
        Me.dtgExcelData.Size = New System.Drawing.Size(482, 192)
        Me.dtgExcelData.TabIndex = 3
        '
        'lblSuccess
        '
        Me.lblSuccess.AutoSize = True
        Me.lblSuccess.ForeColor = System.Drawing.Color.Firebrick
        Me.lblSuccess.Location = New System.Drawing.Point(383, 431)
        Me.lblSuccess.Name = "lblSuccess"
        Me.lblSuccess.Size = New System.Drawing.Size(110, 13)
        Me.lblSuccess.TabIndex = 14
        Me.lblSuccess.Text = "Data Niet Opgehaald."
        '
        'btnDataOpslaan
        '
        Me.btnDataOpslaan.Enabled = False
        Me.btnDataOpslaan.Location = New System.Drawing.Point(123, 466)
        Me.btnDataOpslaan.Name = "btnDataOpslaan"
        Me.btnDataOpslaan.Size = New System.Drawing.Size(250, 23)
        Me.btnDataOpslaan.TabIndex = 16
        Me.btnDataOpslaan.Text = "Sla Data Op"
        Me.btnDataOpslaan.UseVisualStyleBackColor = True
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SluitenToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(514, 24)
        Me.MenuStrip1.TabIndex = 17
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'SluitenToolStripMenuItem
        '
        Me.SluitenToolStripMenuItem.Name = "SluitenToolStripMenuItem"
        Me.SluitenToolStripMenuItem.Size = New System.Drawing.Size(51, 20)
        Me.SluitenToolStripMenuItem.Text = "Sluiten"
        '
        'pctSuccess
        '
        Me.pctSuccess.Image = Global.ADO_project.My.Resources.Resources.remove
        Me.pctSuccess.Location = New System.Drawing.Point(360, 431)
        Me.pctSuccess.Name = "pctSuccess"
        Me.pctSuccess.Size = New System.Drawing.Size(17, 14)
        Me.pctSuccess.TabIndex = 15
        Me.pctSuccess.TabStop = False
        '
        'frmImporteerUitExcel
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(514, 527)
        Me.ControlBox = False
        Me.Controls.Add(Me.btnDataOpslaan)
        Me.Controls.Add(Me.pctSuccess)
        Me.Controls.Add(Me.lblSuccess)
        Me.Controls.Add(Me.dtgExcelData)
        Me.Controls.Add(Me.btnHaalDataOp)
        Me.Controls.Add(Me.grpSelecteerBestand)
        Me.Controls.Add(Me.MenuStrip1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MainMenuStrip = Me.MenuStrip1
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmImporteerUitExcel"
        Me.ShowIcon = False
        Me.Text = "Importeer Uit Excel"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.grpSelecteerBestand.ResumeLayout(False)
        Me.grpSelecteerBestand.PerformLayout()
        CType(Me.pctGeldigFormaat, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.dtgExcelData, System.ComponentModel.ISupportInitialize).EndInit()
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        CType(Me.pctSuccess, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents grpSelecteerBestand As System.Windows.Forms.GroupBox
    Friend WithEvents lblExcelBestand As System.Windows.Forms.Label
    Friend WithEvents txtExcelBestand As System.Windows.Forms.TextBox
    Friend WithEvents btnExcelBestandOpene As System.Windows.Forms.Button
    Friend WithEvents pctGeldigFormaat As System.Windows.Forms.PictureBox
    Friend WithEvents lblGeldigFormaat As System.Windows.Forms.Label
    Friend WithEvents btnHaalDataOp As System.Windows.Forms.Button
    Friend WithEvents txtExcelSheet As System.Windows.Forms.TextBox
    Friend WithEvents lblExcelSheet As System.Windows.Forms.Label
    Friend WithEvents dtgExcelData As System.Windows.Forms.DataGridView
    Friend WithEvents pctSuccess As System.Windows.Forms.PictureBox
    Friend WithEvents lblSuccess As System.Windows.Forms.Label
    Friend WithEvents btnDataOpslaan As System.Windows.Forms.Button
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents SluitenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
End Class
