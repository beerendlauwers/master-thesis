<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class BeheerStudent
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
        Me.cboStudentNaam = New System.Windows.Forms.ComboBox
        Me.lblStudNaam = New System.Windows.Forms.Label
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip
        Me.BeheerToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DetailToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.NewToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.SaveToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.DeleteToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.CancelToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EmailVergelijkenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.cboNaamData = New System.Windows.Forms.ComboBox
        Me.lblZoekenOp = New System.Windows.Forms.Label
        Me.txtNaam = New System.Windows.Forms.TextBox
        Me.txtPriveMail = New System.Windows.Forms.TextBox
        Me.txtFinRek = New System.Windows.Forms.TextBox
        Me.txtSchoolMail = New System.Windows.Forms.TextBox
        Me.txtGSM = New System.Windows.Forms.TextBox
        Me.txtVoornaam = New System.Windows.Forms.TextBox
        Me.lblNaam = New System.Windows.Forms.Label
        Me.lblSchoolMail = New System.Windows.Forms.Label
        Me.lblFinRek = New System.Windows.Forms.Label
        Me.lblGebDat = New System.Windows.Forms.Label
        Me.lblPriveMail = New System.Windows.Forms.Label
        Me.lblGSM = New System.Windows.Forms.Label
        Me.lblVoornaam = New System.Windows.Forms.Label
        Me.btnStudentMail = New System.Windows.Forms.Button
        Me.dtpGebDat = New System.Windows.Forms.DateTimePicker
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'cboStudentNaam
        '
        Me.cboStudentNaam.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboStudentNaam.FormattingEnabled = True
        Me.cboStudentNaam.Location = New System.Drawing.Point(215, 53)
        Me.cboStudentNaam.Name = "cboStudentNaam"
        Me.cboStudentNaam.Size = New System.Drawing.Size(180, 21)
        Me.cboStudentNaam.TabIndex = 0
        '
        'lblStudNaam
        '
        Me.lblStudNaam.AutoSize = True
        Me.lblStudNaam.Location = New System.Drawing.Point(99, 111)
        Me.lblStudNaam.Name = "lblStudNaam"
        Me.lblStudNaam.Size = New System.Drawing.Size(75, 13)
        Me.lblStudNaam.TabIndex = 1
        Me.lblStudNaam.Text = "Student Naam"
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BeheerToolStripMenuItem, Me.EmailVergelijkenToolStripMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(516, 24)
        Me.MenuStrip1.TabIndex = 2
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'BeheerToolStripMenuItem
        '
        Me.BeheerToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.DetailToolStripMenuItem, Me.NewToolStripMenuItem, Me.EditToolStripMenuItem, Me.SaveToolStripMenuItem, Me.DeleteToolStripMenuItem, Me.CancelToolStripMenuItem, Me.ExitToolStripMenuItem})
        Me.BeheerToolStripMenuItem.Name = "BeheerToolStripMenuItem"
        Me.BeheerToolStripMenuItem.Size = New System.Drawing.Size(55, 20)
        Me.BeheerToolStripMenuItem.Text = "Beheer"
        '
        'DetailToolStripMenuItem
        '
        Me.DetailToolStripMenuItem.Name = "DetailToolStripMenuItem"
        Me.DetailToolStripMenuItem.Size = New System.Drawing.Size(110, 22)
        Me.DetailToolStripMenuItem.Text = "Detail"
        '
        'NewToolStripMenuItem
        '
        Me.NewToolStripMenuItem.Name = "NewToolStripMenuItem"
        Me.NewToolStripMenuItem.Size = New System.Drawing.Size(110, 22)
        Me.NewToolStripMenuItem.Text = "New"
        '
        'EditToolStripMenuItem
        '
        Me.EditToolStripMenuItem.Name = "EditToolStripMenuItem"
        Me.EditToolStripMenuItem.Size = New System.Drawing.Size(110, 22)
        Me.EditToolStripMenuItem.Text = "Edit"
        '
        'SaveToolStripMenuItem
        '
        Me.SaveToolStripMenuItem.Name = "SaveToolStripMenuItem"
        Me.SaveToolStripMenuItem.Size = New System.Drawing.Size(110, 22)
        Me.SaveToolStripMenuItem.Text = "Save"
        '
        'DeleteToolStripMenuItem
        '
        Me.DeleteToolStripMenuItem.Name = "DeleteToolStripMenuItem"
        Me.DeleteToolStripMenuItem.Size = New System.Drawing.Size(110, 22)
        Me.DeleteToolStripMenuItem.Text = "Delete"
        '
        'CancelToolStripMenuItem
        '
        Me.CancelToolStripMenuItem.Name = "CancelToolStripMenuItem"
        Me.CancelToolStripMenuItem.Size = New System.Drawing.Size(110, 22)
        Me.CancelToolStripMenuItem.Text = "Cancel"
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(110, 22)
        Me.ExitToolStripMenuItem.Text = "Exit"
        '
        'EmailVergelijkenToolStripMenuItem
        '
        Me.EmailVergelijkenToolStripMenuItem.Name = "EmailVergelijkenToolStripMenuItem"
        Me.EmailVergelijkenToolStripMenuItem.Size = New System.Drawing.Size(108, 20)
        Me.EmailVergelijkenToolStripMenuItem.Text = "Email vergelijken"
        '
        'cboNaamData
        '
        Me.cboNaamData.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboNaamData.FormattingEnabled = True
        Me.cboNaamData.Location = New System.Drawing.Point(215, 111)
        Me.cboNaamData.Name = "cboNaamData"
        Me.cboNaamData.Size = New System.Drawing.Size(180, 21)
        Me.cboNaamData.TabIndex = 1
        '
        'lblZoekenOp
        '
        Me.lblZoekenOp.AutoSize = True
        Me.lblZoekenOp.Location = New System.Drawing.Point(102, 53)
        Me.lblZoekenOp.Name = "lblZoekenOp"
        Me.lblZoekenOp.Size = New System.Drawing.Size(62, 13)
        Me.lblZoekenOp.TabIndex = 4
        Me.lblZoekenOp.Text = "Zoeken op:"
        '
        'txtNaam
        '
        Me.txtNaam.Location = New System.Drawing.Point(215, 160)
        Me.txtNaam.Name = "txtNaam"
        Me.txtNaam.Size = New System.Drawing.Size(180, 20)
        Me.txtNaam.TabIndex = 2
        '
        'txtPriveMail
        '
        Me.txtPriveMail.Location = New System.Drawing.Point(215, 264)
        Me.txtPriveMail.Name = "txtPriveMail"
        Me.txtPriveMail.Size = New System.Drawing.Size(180, 20)
        Me.txtPriveMail.TabIndex = 6
        '
        'txtFinRek
        '
        Me.txtFinRek.Location = New System.Drawing.Point(215, 316)
        Me.txtFinRek.Name = "txtFinRek"
        Me.txtFinRek.Size = New System.Drawing.Size(180, 20)
        Me.txtFinRek.TabIndex = 8
        '
        'txtSchoolMail
        '
        Me.txtSchoolMail.Location = New System.Drawing.Point(215, 238)
        Me.txtSchoolMail.Name = "txtSchoolMail"
        Me.txtSchoolMail.Size = New System.Drawing.Size(180, 20)
        Me.txtSchoolMail.TabIndex = 5
        '
        'txtGSM
        '
        Me.txtGSM.Location = New System.Drawing.Point(215, 212)
        Me.txtGSM.Name = "txtGSM"
        Me.txtGSM.Size = New System.Drawing.Size(180, 20)
        Me.txtGSM.TabIndex = 4
        '
        'txtVoornaam
        '
        Me.txtVoornaam.Location = New System.Drawing.Point(215, 186)
        Me.txtVoornaam.Name = "txtVoornaam"
        Me.txtVoornaam.Size = New System.Drawing.Size(180, 20)
        Me.txtVoornaam.TabIndex = 3
        '
        'lblNaam
        '
        Me.lblNaam.AutoSize = True
        Me.lblNaam.Location = New System.Drawing.Point(105, 160)
        Me.lblNaam.Name = "lblNaam"
        Me.lblNaam.Size = New System.Drawing.Size(35, 13)
        Me.lblNaam.TabIndex = 12
        Me.lblNaam.Text = "Naam"
        '
        'lblSchoolMail
        '
        Me.lblSchoolMail.AutoSize = True
        Me.lblSchoolMail.Location = New System.Drawing.Point(105, 238)
        Me.lblSchoolMail.Name = "lblSchoolMail"
        Me.lblSchoolMail.Size = New System.Drawing.Size(61, 13)
        Me.lblSchoolMail.TabIndex = 14
        Me.lblSchoolMail.Text = "School-mail"
        '
        'lblFinRek
        '
        Me.lblFinRek.AutoSize = True
        Me.lblFinRek.Location = New System.Drawing.Point(105, 316)
        Me.lblFinRek.Name = "lblFinRek"
        Me.lblFinRek.Size = New System.Drawing.Size(99, 13)
        Me.lblFinRek.TabIndex = 16
        Me.lblFinRek.Text = "Financiële rekening"
        '
        'lblGebDat
        '
        Me.lblGebDat.AutoSize = True
        Me.lblGebDat.Location = New System.Drawing.Point(105, 290)
        Me.lblGebDat.Name = "lblGebDat"
        Me.lblGebDat.Size = New System.Drawing.Size(83, 13)
        Me.lblGebDat.TabIndex = 17
        Me.lblGebDat.Text = "Geboorte datum"
        '
        'lblPriveMail
        '
        Me.lblPriveMail.AutoSize = True
        Me.lblPriveMail.Location = New System.Drawing.Point(105, 264)
        Me.lblPriveMail.Name = "lblPriveMail"
        Me.lblPriveMail.Size = New System.Drawing.Size(52, 13)
        Me.lblPriveMail.TabIndex = 18
        Me.lblPriveMail.Text = "Privé-mail"
        '
        'lblGSM
        '
        Me.lblGSM.AutoSize = True
        Me.lblGSM.Location = New System.Drawing.Point(105, 212)
        Me.lblGSM.Name = "lblGSM"
        Me.lblGSM.Size = New System.Drawing.Size(73, 13)
        Me.lblGSM.TabIndex = 19
        Me.lblGSM.Text = "GSM-Nummer"
        '
        'lblVoornaam
        '
        Me.lblVoornaam.AutoSize = True
        Me.lblVoornaam.Location = New System.Drawing.Point(105, 186)
        Me.lblVoornaam.Name = "lblVoornaam"
        Me.lblVoornaam.Size = New System.Drawing.Size(55, 13)
        Me.lblVoornaam.TabIndex = 20
        Me.lblVoornaam.Text = "Voornaam"
        '
        'btnStudentMail
        '
        Me.btnStudentMail.Location = New System.Drawing.Point(215, 357)
        Me.btnStudentMail.Name = "btnStudentMail"
        Me.btnStudentMail.Size = New System.Drawing.Size(121, 23)
        Me.btnStudentMail.TabIndex = 9
        Me.btnStudentMail.Text = "Student E-mailen"
        Me.btnStudentMail.UseVisualStyleBackColor = True
        '
        'dtpGebDat
        '
        Me.dtpGebDat.Location = New System.Drawing.Point(215, 290)
        Me.dtpGebDat.Name = "dtpGebDat"
        Me.dtpGebDat.Size = New System.Drawing.Size(180, 20)
        Me.dtpGebDat.TabIndex = 21
        '
        'BeheerStudent
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(516, 417)
        Me.ControlBox = False
        Me.Controls.Add(Me.dtpGebDat)
        Me.Controls.Add(Me.btnStudentMail)
        Me.Controls.Add(Me.lblVoornaam)
        Me.Controls.Add(Me.lblGSM)
        Me.Controls.Add(Me.lblPriveMail)
        Me.Controls.Add(Me.lblGebDat)
        Me.Controls.Add(Me.lblFinRek)
        Me.Controls.Add(Me.lblSchoolMail)
        Me.Controls.Add(Me.lblNaam)
        Me.Controls.Add(Me.txtVoornaam)
        Me.Controls.Add(Me.txtGSM)
        Me.Controls.Add(Me.txtSchoolMail)
        Me.Controls.Add(Me.txtFinRek)
        Me.Controls.Add(Me.txtPriveMail)
        Me.Controls.Add(Me.txtNaam)
        Me.Controls.Add(Me.lblZoekenOp)
        Me.Controls.Add(Me.cboNaamData)
        Me.Controls.Add(Me.lblStudNaam)
        Me.Controls.Add(Me.cboStudentNaam)
        Me.Controls.Add(Me.MenuStrip1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.MainMenuStrip = Me.MenuStrip1
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "BeheerStudent"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Studentenbeheer"
        Me.WindowState = System.Windows.Forms.FormWindowState.Maximized
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents cboStudentNaam As System.Windows.Forms.ComboBox
    Friend WithEvents lblStudNaam As System.Windows.Forms.Label
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents BeheerToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DetailToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents EditToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents SaveToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CancelToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents NewToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents cboNaamData As System.Windows.Forms.ComboBox
    Friend WithEvents lblZoekenOp As System.Windows.Forms.Label
    Friend WithEvents txtNaam As System.Windows.Forms.TextBox
    Friend WithEvents txtPriveMail As System.Windows.Forms.TextBox
    Friend WithEvents txtFinRek As System.Windows.Forms.TextBox
    Friend WithEvents txtSchoolMail As System.Windows.Forms.TextBox
    Friend WithEvents txtGSM As System.Windows.Forms.TextBox
    Friend WithEvents txtVoornaam As System.Windows.Forms.TextBox
    Friend WithEvents lblNaam As System.Windows.Forms.Label
    Friend WithEvents lblSchoolMail As System.Windows.Forms.Label
    Friend WithEvents lblFinRek As System.Windows.Forms.Label
    Friend WithEvents lblGebDat As System.Windows.Forms.Label
    Friend WithEvents lblPriveMail As System.Windows.Forms.Label
    Friend WithEvents lblGSM As System.Windows.Forms.Label
    Friend WithEvents lblVoornaam As System.Windows.Forms.Label
    Friend WithEvents btnStudentMail As System.Windows.Forms.Button
    Friend WithEvents dtpGebDat As System.Windows.Forms.DateTimePicker
    Friend WithEvents EmailVergelijkenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
End Class
