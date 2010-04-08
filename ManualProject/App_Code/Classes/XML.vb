Imports Microsoft.VisualBasic
Imports System.IO
Imports System.Xml
Imports System.Xml.Xsl
Imports System.Xml.XPath
Imports System.Web.HttpContext

Public Structure XMLTooltip
    Public ID As String
    Public Text As String
End Structure

Public Class XML
    Private _xml As String
    Private _xsl As String
    Private Shared FTooltips As List(Of XMLTooltip)

    Private Shared Function GetTooltips() As List(Of XMLTooltip)

        'Als de lijst niet bestaat, maken we deze aan
        If (FTooltips Is Nothing) Then
            ParseTooltips()
        End If

        Return FTooltips
    End Function

    Private Shared Sub ParseTooltips()
        FTooltips = New List(Of XMLTooltip)

        Dim locatie As String = HttpContext.Current.Server.MapPath("~/App_Data/tooltips.xml")

        'Document laden
        Dim xml As New XmlDocument()
        xml.Load(locatie)

        'root node ophalen
        Dim root As XmlNode = xml.DocumentElement

        'Alle tooltips uitlezen
        For Each child As XmlNode In root.ChildNodes
            Dim tip As New XMLTooltip
            tip.ID = child.Attributes.GetNamedItem("id").Value
            tip.Text = child.Attributes.GetNamedItem("text").Value
            FTooltips.Add(tip)
        Next child

    End Sub

    Public Shared Function GetTip(ByVal ID As String) As String
        For Each tip As XMLTooltip In GetTooltips()
            If tip.ID = ID Then
                Return tip.Text
            End If
        Next tip

        'Hmm. We hebben de tip niet gevonden. We gaan de tooltiplijst opnieuw laden,
        'en als het dan niet lukt, dan geven we een lege string terug.
        ParseTooltips()

        For Each tip As XMLTooltip In GetTooltips()
            If tip.ID = ID Then
                Return tip.Text
            End If
        Next tip

        Return String.Empty
    End Function


    Public Property XMLBestand() As String
        Get
            Return _xml
        End Get
        Set(ByVal value As String)
            _xml = value
        End Set
    End Property

    Public Property XSLBestand() As String
        Get
            Return _xsl
        End Get
        Set(ByVal value As String)
            _xsl = value
        End Set
    End Property

    Public Sub New(ByVal xml As String, ByVal xsl As String)
        _xml = xml
        _xsl = xsl
    End Sub

    Public Shared Function GetBeheerLogin(ByVal xmlbestand As String) As String

        'XML-bestand laden
        Dim xml As New XmlDocument()
        xml.Load(xmlbestand)

        'Root node vinden
        Dim root As XmlNode = xml.DocumentElement

        Dim returnstring As String = root.SelectSingleNode("username").ChildNodes(0).Value
        returnstring = String.Concat(returnstring, ",", root.SelectSingleNode("password").ChildNodes(0).Value)

        Return returnstring
    End Function

    Private Shared Function XMLUitlezen(ByVal xmlbestand As String, ByVal xslbestand As String) As String

        'XML-bestand laden
        Dim xml As New XmlDocument()
        xml.Load(xmlbestand)

        'XSL-bestand laden
        Dim xsl As New XslTransform()
        xsl.Load(xslbestand)

        'Onze stringbuilder en -writer
        Dim htmlcode As New StringBuilder()
        Dim writer As New StringWriter(htmlcode)

        'XML tranformeren
        xsl.Transform(xml, Nothing, writer)

        'HTML-code teruggeven
        Return htmlcode.ToString

    End Function

    Public Shared Function LeesXMLFile(ByVal x As XML) As String
        Return XML.XMLUitlezen(x.XMLBestand, x.XSLBestand)
    End Function

    Public Shared Function LeesXMLFile(ByVal xmlbestand As String, ByVal xslbestand As String) As String
        Return XML.XMLUitlezen(xmlbestand, xslbestand)
    End Function

End Class
