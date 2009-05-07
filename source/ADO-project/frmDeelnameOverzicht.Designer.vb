<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmDeelnameOverzicht
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
        Me.dgrDoetSport = New System.Windows.Forms.DataGridView
        Me.lblFilter = New System.Windows.Forms.Label
        Me.cboFilter = New System.Windows.Forms.ComboBox
        CType(Me.dgrDoetSport, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'dgrDoetSport
        '
        Me.dgrDoetSport.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgrDoetSport.Location = New System.Drawing.Point(1, 58)
        Me.dgrDoetSport.Name = "dgrDoetSport"
        Me.dgrDoetSport.Size = New System.Drawing.Size(443, 226)
        Me.dgrDoetSport.TabIndex = 0
        '
        'lblFilter
        '
        Me.lblFilter.AutoSize = True
        Me.lblFilter.Location = New System.Drawing.Point(12, 22)
        Me.lblFilter.Name = "lblFilter"
        Me.lblFilter.Size = New System.Drawing.Size(47, 13)
        Me.lblFilter.TabIndex = 1
        Me.lblFilter.Text = "Student:"
        '
        'cboFilter
        '
        Me.cboFilter.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboFilter.FormattingEnabled = True
        Me.cboFilter.Location = New System.Drawing.Point(65, 19)
        Me.cboFilter.Name = "cboFilter"
        Me.cboFilter.Size = New System.Drawing.Size(121, 21)
        Me.cboFilter.TabIndex = 2
        '
        'frmDeelnameOverzicht
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.ClientSize = New System.Drawing.Size(446, 287)
        Me.Controls.Add(Me.cboFilter)
        Me.Controls.Add(Me.lblFilter)
        Me.Controls.Add(Me.dgrDoetSport)
        Me.Name = "frmDeelnameOverzicht"
        Me.Text = "Deelnameoverzicht"
        CType(Me.dgrDoetSport, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents dgrDoetSport As System.Windows.Forms.DataGridView
    Friend WithEvents lblFilter As System.Windows.Forms.Label
    Friend WithEvents cboFilter As System.Windows.Forms.ComboBox
End Class
