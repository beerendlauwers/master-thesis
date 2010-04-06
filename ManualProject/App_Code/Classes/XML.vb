Imports Microsoft.VisualBasic
Imports System.IO
Imports System.Xml
Imports System.Xml.Xsl
Imports System.Xml.XPath
Public Class XML
    Private _xml As String
    Private _xsl As String

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
