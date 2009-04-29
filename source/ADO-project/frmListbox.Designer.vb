<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmListbox
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
        Me.lstEmail = New System.Windows.Forms.ListBox
        Me.lblEmaildressen = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'lstEmail
        '
        Me.lstEmail.FormattingEnabled = True
        Me.lstEmail.Location = New System.Drawing.Point(31, 28)
        Me.lstEmail.Name = "lstEmail"
        Me.lstEmail.Size = New System.Drawing.Size(120, 95)
        Me.lstEmail.TabIndex = 0
        '
        'lblEmaildressen
        '
        Me.lblEmaildressen.AutoSize = True
        Me.lblEmaildressen.Location = New System.Drawing.Point(13, 12)
        Me.lblEmaildressen.Name = "lblEmaildressen"
        Me.lblEmaildressen.Size = New System.Drawing.Size(138, 13)
        Me.lblEmaildressen.TabIndex = 1
        Me.lblEmaildressen.Text = "Vergelijking E-mail adressen"
        '
        'frmListbox
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(284, 264)
        Me.Controls.Add(Me.lblEmaildressen)
        Me.Controls.Add(Me.lstEmail)
        Me.Name = "frmListbox"
        Me.Text = "frmListbox"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents lstEmail As System.Windows.Forms.ListBox
    Friend WithEvents lblEmaildressen As System.Windows.Forms.Label
End Class
