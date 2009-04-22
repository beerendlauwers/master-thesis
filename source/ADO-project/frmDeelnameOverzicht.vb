Public Class frmDeelnameOverzicht

    Private Sub frmDeelnameOverzicht_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim blngeslaagd = frmHoofdMenu.myConnection.f_HaalDeelnameDataOp()
        If (blngeslaagd) Then
            dgrDoetSport.DataSource = frmHoofdMenu.myConnection.p_dataset.Tables("tblDeelname")
        Else
            MsgBox("Kon de data niet ophalen.")
        End If
        'dgrDoetSport.DataBindings.Add("niveaubucht", frmHoofdMenu.myConnection.p_dataset, "tblNiveau.Niveau_DoetSport.NiveauID")
        'dgrDoetSport.DataMember = "tblDeelname"
    End Sub

    'Private Sub dgrDoetSport_CellFormatting(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellFormattingEventArgs) Handles dgrDoetSport.CellFormatting
    '   If (e.ColumnIndex = dgrDoetSport.Columns("NiveauID").Index) Then
    '        e.FormattingApplied = True
    'Dim row As DataGridViewRow = dgrDoetSport.Rows(e.RowIndex)
    '        e.Value = 
    '        e.Value = String.Format("{0} : {1}", row.Cells("NiveauID").Value, row.Cells("NiveauID").Value)
    '    End If
    'End Sub
End Class