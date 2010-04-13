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

    ''' <summary>
    ''' Leest een of meerdere waardes uit een DropDownList.
    ''' </summary>
    ''' <param name="ddl">De DropDownList waaruit de waardes dienen te komen.</param>
    ''' <returns>Alle waardes indien SelectedValue = -1000, anders enkel de waarde van de geselecteerdeo optie</returns>
    Public Shared Function LeesDropdown(ByRef ddl As DropDownList) As String
        Dim returnstring As String = String.Empty
        If ddl.SelectedValue = -1000 Then 'alles
            For index As Integer = 1 To ddl.Items.Count - 1
                returnstring = String.Concat(returnstring, ",", ddl.Items(index).Value.ToString)
            Next
            returnstring = returnstring.Remove(0, 1) 'Eerste komma verwijderen
        Else
            returnstring = ddl.SelectedItem.Value.ToString
        End If

        Return returnstring
    End Function

    Public Shared Sub CheckOfBeheerder(ByVal pagina As String)
        If HttpContext.Current.Session("login") IsNot Nothing Then
            If HttpContext.Current.Session("login") = 0 Then
                HttpContext.Current.Session("vorigePagina") = pagina
            End If
        Else
            HttpContext.Current.Response.Redirect("Aanmeldpagina.aspx")
        End If
    End Sub
End Class
