Imports Microsoft.VisualBasic

Public Class JavaScript
    Private Shared FInstance As JavaScript = Nothing

    ''' <summary>
    ''' Haalt Javascript-functies op.
    ''' </summary>
    ''' <returns>Geeft de huidige Javascript-instance terug.</returns>
    Public Shared ReadOnly Property GetInstance() As JavaScript
        Get
            If (FInstance Is Nothing) Then
                FInstance = New JavaScript()
            End If

            Return FInstance
        End Get
    End Property

    ''' <summary>
    ''' Voeg JavaScript toe aan het 'onload' statement van de body tag. 
    ''' </summary>
    ''' <param name="body">De 'body'-HTML-tag waaraan de JavaScript dient toegevoegd te worden.</param>
    ''' <param name="js">De toe te voegen JavaScript.</param>
    ''' <remarks>Vergeet niet een ';' te plaatsen na je script.</remarks>
    Public Shared Sub VoegJavascriptToeAanBody(ByRef body As HtmlGenericControl, ByRef js As String)
        body.Attributes.Add("onload", String.Concat(body.Attributes.Item("onload"), js))
    End Sub

    ''' <summary>
    ''' Voeg JavaScript toe aan het AJAX-Request.
    ''' </summary>
    ''' <param name="pagina">De pagina waaraan de JavaScript dient toegevoegd te worden.</param>
    ''' <param name="js">De toe te voegen JavaScript.</param>
    ''' <remarks>Vergeet niet een ';' te plaatsen na je script.</remarks>
    Public Shared Sub VoegJavascriptToeAanEndRequest(ByRef pagina As System.Web.UI.Page, ByRef js As String)
        ScriptManager.RegisterClientScriptBlock(pagina, pagina.GetType, "EndRequest", js, True)
    End Sub

    Public Shared Sub VoegJavascriptToeAanEndRequest(ByRef ctl As WebControl, ByRef js As String)
        ScriptManager.RegisterClientScriptBlock(ctl, ctl.GetType, "EndRequest", js, True)
    End Sub

    Public Shared Sub VoegJavaScriptToeAanBeginRequest(ByRef pagina As System.Web.UI.Page, ByRef script As String)
        Dim js As String = "var prm = Sys.WebForms.PageRequestManager.getInstance();"
        js = String.Concat(js, "prm.add_initializeRequest(InitializeRequest);")
        js = String.Concat(js, "function InitializeRequest(sender, args) { ", script, " } ")
        VoegJavascriptToeAanBody(pagina.Master.FindControl("MasterBody"), js)
    End Sub

    ''' <summary>
    ''' Zet een dropdown op disabled als een dropdown een postback doet.
    ''' </summary>
    ''' <param name="disabledDdl">De te disablen DropDownList.</param>
    ''' <param name="laadTekst">De tekst die moet worden weergegeven tijdens de postback.</param>
    ''' <param name="veranderendeDdl">De DropDownList die de verandering teweegbrengt.</param>
    Public Shared Sub ZetDropdownOpDisabledOnChange(ByRef veranderendeDdl As System.Web.UI.WebControls.DropDownList, Optional ByRef disabledDdl As System.Web.UI.WebControls.DropDownList = Nothing, Optional ByVal laadTekst As String = "")

        If disabledDdl Is Nothing Then
            disabledDdl = veranderendeDdl
        End If

        Dim js As String = String.Empty

        js = String.Concat(js, "var ddl = document.getElementById('", disabledDdl.ClientID, "'); ddl.disabled = true; ")

        If Not laadTekst = "" Then
            js = String.Concat(js, "ddl.options[0].text = '", laadTekst, "'; ")
        End If

        js = String.Concat(js, veranderendeDdl.Page.ClientScript.GetPostBackEventReference(veranderendeDdl, "").ToString, ";")

        VoerJavaScriptUitOn(veranderendeDdl, js, "onchange")
    End Sub

    Public Shared Function GetPostBackReferenceVoorControl(ByRef ctl As WebControl) As String
        Return ctl.Page.ClientScript.GetPostBackEventReference(ctl, "").ToString
    End Function

    ''' <summary>
    ''' Zet een button op disabled als erop gedrukt wordt.
    ''' </summary>
    ''' <param name="btn">De te disablen Button.</param>
    ''' <param name="geenValidatie">Boolean om te checken voor validatie of niet.</param>
    ''' <param name="laadTekst">De tekst die moet worden weergegeven op de Button tijdens de postback.</param>
    ''' <remarks>Indien de button deel uitmaakt van een validationGroup, wordt enkel deze groep gevalideerd.</remarks>
    Public Shared Sub ZetButtonOpDisabledOnClick(ByRef btn As System.Web.UI.WebControls.Button, ByVal laadTekst As String, Optional ByVal geenValidatie As Boolean = False)
        Dim js As String = String.Empty

        Dim validateString As String = String.Empty

        Dim validationGroup = btn.ValidationGroup

        If Not validationGroup = "" Then
            validateString = String.Concat("Page_ClientValidate('", validationGroup, "')")
        Else
            validateString = "Page_ClientValidate()"
        End If

        If geenValidatie Then
            js = String.Concat(js, "if( true )")
        Else
            js = String.Concat(js, "if( ", validateString, " == true )")
        End If

        js = String.Concat(js, "{ this.disabled=true; ")

        'laadTekst wijzigen als ze anders is dan de originele tekst
        If Not laadTekst = btn.Text Then
            js = String.Concat(js, "this.value = '", laadTekst, "';")
        End If

        'Als het een postback is dan voegen we nog een postbackreference toe
        js = String.Concat(js, btn.Page.ClientScript.GetPostBackEventReference(btn, "").ToString, ";")

        js = String.Concat(js, " } return false;")

        VoerJavaScriptUitOn(btn, js, "OnClick")
    End Sub

    ''' <summary>
    ''' Voert JavaScript uit op een bepaald event van de gegeven control.
    ''' </summary>
    ''' <param name="control">De control waaraan de JavaScript wordt toegevoegd.</param>
    ''' <param name="js">De JavaScript-code.</param>
    ''' <param name="onEvent">Het event waaraan de JavaScript wordt toegevoegd.</param>
    ''' <remarks>Vergeet niet een ';' te plaatsen na je script.</remarks>
    Public Shared Sub VoerJavaScriptUitOn(ByRef control As System.Web.UI.WebControls.WebControl, ByVal js As String, ByVal onEvent As String)
        control.Attributes.Item(onEvent) = String.Concat(control.Attributes.Item(onEvent), js)
    End Sub

    ''' <summary>
    ''' Geeft JavasScript-code terug om een control te disablen.
    ''' </summary>
    ''' <param name="control">De te disablen control.</param>
    ''' <returns>JavaScript-code om de control te disablen.</returns>
    Public Shared Function DisableCode(ByRef control As Object) As String
        Return String.Concat("document.getElementById('", control.ClientID, "').disabled = true; ")
    End Function

    ''' <summary>
    ''' Geeft JavaScript-code terug om een control te verstoppen.
    ''' </summary>
    ''' <param name="control">De te verstoppen control.</param>
    ''' <returns>JavaScript-Code om de control te verstoppen.</returns>
    Public Shared Function HideCode(ByRef control As Object) As String
        Return String.Concat("document.getElementById('", control.ClientID, "').style.display = 'none'; ")
    End Function

    ''' <summary>
    ''' Geeft JavaScript-code terug om een control weer te geven.
    ''' </summary>
    ''' <param name="control">De te weer te geven control.</param>
    ''' <param name="display">De waarde die aan style.display wordt gegeven.</param>
    ''' <returns>JavaScript-Code om de control weer te geven.</returns>
    Public Shared Function ShowCode(ByRef control As Object, Optional ByVal display As String = "inline") As String
        Return String.Concat("document.getElementById('", control.ClientID, "').style.display = '", display, "'; ")
    End Function

    Public Shared Sub ShadowBoxLaderTonenBijElkePostback(ByRef pagina As System.Web.UI.Page)
        JavaScript.VoegJavaScriptToeAanBeginRequest(pagina, "ShadowBoxLaderTonen();")
    End Sub

    Public Shared Sub ShadowBoxLaderSluiten(ByRef pagina As System.Web.UI.Page)
        JavaScript.VoegJavascriptToeAanEndRequest(pagina, "ShadowBoxLaderSluiten();")
    End Sub

    Public Shared Sub ShadowBoxOpenen(ByRef page As Page, ByVal js As String)
        js = Regex.Replace(js, "[']", "\'")
        JavaScript.VoegJavascriptToeAanEndRequest(page, String.Concat("ShadowBoxTonen('", js, "');"))
    End Sub

    Public Shared Sub ShadowBoxOpenen(ByRef ctl As WebControl, ByVal js As String)
        js = Regex.Replace(js, "[']", "\'")
        JavaScript.VoegJavascriptToeAanEndRequest(ctl, String.Concat("ShadowBoxTonen('", js, "');"))
    End Sub

End Class
