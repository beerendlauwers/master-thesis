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
        CType(Me.dgrDoetSport, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'dgrDoetSport
        '
        Me.dgrDoetSport.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.dgrDoetSport.Location = New System.Drawing.Point(21, 12)
        Me.dgrDoetSport.Name = "dgrDoetSport"
        Me.dgrDoetSport.Size = New System.Drawing.Size(457, 234)
        Me.dgrDoetSport.TabIndex = 0
        '
        'frmDeelnameOverzicht
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(490, 310)
        Me.Controls.Add(Me.dgrDoetSport)
        Me.Name = "frmDeelnameOverzicht"
        Me.Text = "frmDeelnameOverzicht"
        CType(Me.dgrDoetSport, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents dgrDoetSport As System.Windows.Forms.DataGridView
End Class
