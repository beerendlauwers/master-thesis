Imports Microsoft.VisualBasic

''' <summary>
''' Klasse die gebaseerd is op de JavaScript Prototip van Nick Stakenburg. Bevat enkele methods om gemakkelijk tooltips toe te voegen aan een pagina.
''' </summary>
Public Class Tooltip
    Private _naam As String
    Private _tekst As String
    Private _opties As List(Of String)

    Public Property Naam() As String
        Get
            Return _naam
        End Get
        Set(ByVal value As String)
            _naam = value
        End Set
    End Property

    Public Property Tekst() As String
        Get
            Return _tekst
        End Get
        Set(ByVal value As String)
            _tekst = value
        End Set
    End Property

    ''' <summary>
    ''' Maak een nieuwe Tooltip aan.
    ''' </summary>
    ''' <param name="naam">Het ID van de html-tag (div, span, etc) waarop de tooltip moet komen. Dit is tevens het ID van de XML-tag in 'tooltips.xml'.</param>
    ''' <param name="standaardOpties">Een boolean die bepaalt of je de standaardlayout van een tooltip wilt gebruiken. Default is true.</param>
    Public Sub New(ByVal naam As String, Optional ByVal standaardOpties As Boolean = True)
        _naam = naam
        _tekst = XML.GetTip(naam)
        _opties = New List(Of String)

        If standaardOpties Then
            VoegStandaardOptiesToe()
        End If
    End Sub

    ''' <summary>
    ''' Voeg een optie toe aan de Tooltip.
    ''' </summary>
    Public Sub VoegOptieToe(ByVal optie As String)
        _opties.Add(optie)
    End Sub

    ''' <summary>
    ''' Verwijder een optie van de Tooltip.
    ''' </summary>
    Public Sub VerwijderOptie(ByVal optie As String)
        _opties.Remove(optie)
    End Sub

    ''' <summary>
    ''' Voeg de standaardopties toe aan de Tooltip.
    ''' </summary>
    Public Sub VoegStandaardOptiesToe()
        VoegOptieToe(String.Concat("target: $('", _naam, "')"))
        VoegOptieToe("hook: { target: 'rightMiddle', tip: 'leftMiddle' }")
        VoegOptieToe("offset: { x: 10, y: 0 }")
    End Sub

    ''' <summary>
    ''' Voeg een enkele tip toe aan het AJAX-Request.
    ''' </summary>
    Public Shared Sub VoegTipToeAanEndRequest(ByRef pagina As System.Web.UI.Page, ByRef tip As Tooltip)
        Try
            Dim control As Control = pagina.FindControl(tip.Naam)
            If control IsNot Nothing Then
                If control.Visible = True Then
                    ScriptManager.RegisterClientScriptBlock(pagina, pagina.GetType, String.Concat("EndRequest", tip.Naam), tip.ToString, True)
                End If
            Else
                Dim e As New ErrorLogger("Kon tooltip """ & tip.Naam & """ niet op pagina """ & pagina.Request.Url.AbsolutePath & """ vinden.","TOOLTIP_0001")
                ErrorLogger.WriteError(e)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(pagina, ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' Voeg een lijst van tips toe aan het AJAX-Request.
    ''' </summary>
    Public Shared Sub VoegTipToeAanEndRequest(ByRef pagina As System.Web.UI.Page, ByRef tips As List(Of Tooltip))
        For Each tip As Tooltip In tips
            ScriptManager.RegisterClientScriptBlock(pagina, pagina.GetType, String.Concat("EndRequest", tip.Naam), tip.ToString, True)
        Next tip
    End Sub

    ''' <summary>
    ''' Voeg een enkele tip toe aan het 'onload' statement van de body tag. 
    ''' </summary>
    Public Shared Sub VoegTipToeAanBody(ByRef body As HtmlGenericControl, ByRef tip As Tooltip)
        body.Attributes.Add("onload", String.Concat(body.Attributes.Item("onload"), tip.ToString))
    End Sub

    ''' <summary>
    ''' Voeg een lijst van tips toe aan het 'onload' statement van de body tag. 
    ''' </summary>
    Public Shared Sub VoegTipToeAanBody(ByRef body As HtmlGenericControl, ByRef tips As List(Of Tooltip))
        For Each tip As Tooltip In tips
            body.Attributes.Add("onload", String.Concat(body.Attributes.Item("onload"), tip.ToString))
        Next tip
    End Sub

    ''' <summary>
    ''' Geef een string van JavaScript-code terug om een nieuwe Prototip aan te maken.
    ''' </summary>
    Public Overrides Function ToString() As String
        Dim str As String = String.Empty

        'naam en titel erin steken
        str = String.Concat(str, "new Tip('", _naam, "', """, _tekst, """, {")

        For Each optie As String In _opties
            str = String.Concat(str, " ", optie, " ,")
        Next optie

        If _opties.Count > 0 Then
            str = str.Substring(0, str.Length - 1)
        End If

        str = String.Concat(str, "} ); ")

        Return str
    End Function
End Class
