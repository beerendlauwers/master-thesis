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
        Me.lblText1 = New System.Windows.Forms.Label
        Me.lblText2 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'lstEmail
        '
        Me.lstEmail.FormattingEnabled = True
        Me.lstEmail.Location = New System.Drawing.Point(28, 48)
        Me.lstEmail.Name = "lstEmail"
        Me.lstEmail.Size = New System.Drawing.Size(223, 186)
        Me.lstEmail.TabIndex = 0
        '
        'lblText1
        '
        Me.lblText1.AutoSize = True
        Me.lblText1.Location = New System.Drawing.Point(25, 9)
        Me.lblText1.Name = "lblText1"
        Me.lblText1.Size = New System.Drawing.Size(226, 13)
        Me.lblText1.TabIndex = 1
        Me.lblText1.Text = "De volgende E-mail adressen staan in Access,"
        '
        'lblText2
        '
        Me.lblText2.AutoSize = True
        Me.lblText2.Location = New System.Drawing.Point(74, 22)
        Me.lblText2.Name = "lblText2"
        Me.lblText2.Size = New System.Drawing.Size(128, 13)
        Me.lblText2.TabIndex = 2
        Me.lblText2.Text = "maar niet in MSSQL2005."
        '
        'frmListbox
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(284, 264)
        Me.Controls.Add(Me.lblText2)
        Me.Controls.Add(Me.lblText1)
        Me.Controls.Add(Me.lstEmail)
        Me.Name = "frmListbox"
        Me.Text = "Vergelijking E-mail adressen"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents lstEmail As System.Windows.Forms.ListBox
    Friend WithEvents lblText1 As System.Windows.Forms.Label
    Friend WithEvents lblText2 As System.Windows.Forms.Label
End Class
