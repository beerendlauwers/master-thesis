Imports Microsoft.VisualBasic

Public Class JavaScript
    Private Shared FInstance As JavaScript = Nothing

    ''' <summary>
    ''' Haalt Javascript-functies op.
    ''' </summary>
    Public Shared ReadOnly Property GetInstance() As JavaScript
        Get
            If (FInstance Is Nothing) Then
                FInstance = New JavaScript()
            End If

            Return FInstance
        End Get
    End Property

    ''' <summary>
    ''' Voeg javascript toe aan het 'onload' statement van de body tag. 
    ''' </summary>
    Public Shared Sub VoegJavascriptToeAanBody(ByRef body As HtmlGenericControl, ByRef js As String)
        body.Attributes.Add("onload", String.Concat(body.Attributes.Item("onload"), js))
    End Sub

    ''' <summary>
    ''' Voeg javascript toe aan het AJAX-Request.
    ''' </summary>
    Public Shared Sub VoegJavascriptToeAanEndRequest(ByRef pagina As System.Web.UI.Page, ByRef js As String)
        ScriptManager.RegisterClientScriptBlock(pagina, pagina.GetType, "EndRequest", js, True)
    End Sub

    ''' <summary>
    ''' Voer javascript uit als op een knop wordt gedrukt.
    ''' </summary>
    Public Shared Sub ZetButtonOpDisabledOnClick(ByRef btn As System.Web.UI.WebControls.Button, ByVal laadTekst As String, Optional ByVal isPostback As Boolean = True)
        Dim js As String = String.Empty

        js = String.Concat(js, "if( Page_ClientValidate() == true )")
        js = String.Concat(js, "{ this.disabled=true; ")

        'laadTekst wijzigen als ze anders is dan de originele tekst
        If Not laadTekst = btn.Text Then
            js = String.Concat(js, "this.value = '", laadTekst, "';")
        End If

        'Als het een postback is dan voegen we nog een postbackreference toe
        If isPostback Then
            js = String.Concat(js, btn.Page.ClientScript.GetPostBackEventReference(btn, "").ToString, ";")
        End If

        js = String.Concat(js, " }")

        btn.Attributes.Item("onclick") = js
    End Sub

End Class
