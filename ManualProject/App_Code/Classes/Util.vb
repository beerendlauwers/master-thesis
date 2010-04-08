Imports Microsoft.VisualBasic

''' <summary>
''' Een klasse met verschillende functies die in verschillende pagina's worden gebruikt
''' </summary>
Public Class Util

    ''' <summary>
    ''' Wijzigt de gegeven controls naar een "mislukt" design.
    ''' </summary>
    ''' <param name="tekst">De tekst die het feedbacklabel zal weergeven.</param>
    ''' <param name="lbl">Het feedbacklabel.</param>
    ''' <param name="img">De imagecontrol.</param>
    Public Shared Sub SetError(ByVal tekst As String, ByRef lbl As Label, ByRef img As Image)
        lbl.Text = tekst
        lbl.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E3401E")
        img.ImageUrl = "~\App_Presentation\CSS\images\remove.png"
    End Sub

    ''' <summary>
    ''' Wijzigt de gegeven controls naar een "geslaagd" design.
    ''' </summary>
    ''' <param name="tekst">De tekst die het feedbacklabel zal weergeven.</param>
    ''' <param name="lbl">Het feedbacklabel.</param>
    ''' <param name="img">De imagecontrol.</param>
    Public Shared Sub SetOK(ByVal tekst As String, ByRef lbl As Label, ByRef img As Image)
        lbl.Text = tekst
        lbl.ForeColor = System.Drawing.ColorTranslator.FromHtml("#86CC7C")
        img.ImageUrl = "~\App_Presentation\CSS\images\tick.gif"
    End Sub

    ''' <summary>
    ''' Wijzigt de gegeven controls naar een "gelukt met fouten" design.
    ''' </summary>
    ''' <param name="tekst">De tekst die het feedbacklabel zal weergeven.</param>
    ''' <param name="lbl">Het feedbacklabel.</param>
    ''' <param name="img">De imagecontrol.</param>
    Public Shared Sub SetWarn(ByVal tekst As String, ByRef lbl As Label, ByRef img As Image)
        lbl.Text = tekst
        lbl.ForeColor = System.Drawing.ColorTranslator.FromHtml("#EAB600")
        img.ImageUrl = "~\App_Presentation\CSS\images\warning.png"
    End Sub

End Class
