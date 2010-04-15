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

Public Structure XMLLocalisation
    Public taalID As Integer
    Public keys As NameValueCollection
End Structure

Public Class XML
    Private _xml As String
    Private _xsl As String
    Private Shared _parseLocalisationLock As New Object
    Private Shared _parseLock As New Object
    Private Shared FTooltips As List(Of XMLTooltip)
    Private Shared FLocalisation As List(Of XMLLocalisation)

    Public Shared Function GetTooltips() As List(Of XMLTooltip)

        'Als de lijst niet bestaat, maken we deze aan
        If (FTooltips Is Nothing) Then
            ParseTooltips()
        End If

        Return FTooltips
    End Function

    Public Shared Function GetTipCount() As Integer
        Return FTooltips.Count
    End Function

    Public Shared Sub ParseTooltips()

        SyncLock _parseLock

            FTooltips = New List(Of XMLTooltip)

            Dim locatie As String = HttpContext.Current.Server.MapPath("~/App_Data/tooltips.xml")

            'Document laden
            Dim xml As New XmlDocument()
            xml.Load(locatie)

            'root node ophalen
            Dim root As XmlNode = xml.DocumentElement

            'Alle tooltips uitlezen
            For Each child As XmlNode In root.ChildNodes
                If child.NodeType = XmlNodeType.Comment Then Continue For

                Dim tip As New XMLTooltip
                tip.ID = child.Attributes.GetNamedItem("id").Value
                tip.Text = child.Attributes.GetNamedItem("text").Value
                FTooltips.Add(tip)
            Next child

        End SyncLock
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

    Public Shared Sub GetTemplates(ByRef lst As ListBox)

        'Directory ophalen
        Dim di As New IO.DirectoryInfo(String.Concat(HttpContext.Current.Server.MapPath("~/"), "Templates"))

        'Alle templates ophalen
        Dim templatelijst As New List(Of IO.FileInfo)
        For Each file As IO.FileInfo In di.GetFiles
            templatelijst.Add(file)
        Next

        'Alle geldige XML-XSL combinaties opslaan
        Dim xmllijst As New List(Of XML)
        For Each template As IO.FileInfo In templatelijst
            If template.Extension = ".xml" Then
                For Each xsltemplate As IO.FileInfo In templatelijst
                    If xsltemplate.Name.Replace(".xsl", String.Empty) = template.Name.Replace(".xml", String.Empty) And xsltemplate.Extension = ".xsl" Then
                        lst.Items.Add(template.Name.Replace(".xml", String.Empty))
                    End If
                Next
            End If
        Next template

    End Sub

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

    Public Shared Function GetString(ByVal id As String) As String
        If FLocalisation Is Nothing Then ParseLocalisatieStrings()
        If FLocalisation.Count = 0 Then Return String.Empty

        Dim taalID As Integer = FLocalisation.Item(0).taalID
        If Current.Session("taal") IsNot Nothing Then
            taalID = Current.Session("taal")
        End If

        For Each lijst As XMLLocalisation In FLocalisation
            If lijst.taalID = taalID Then
                Dim key As String = lijst.keys.Item(id)
                If key IsNot Nothing Then
                    Return HttpUtility.HtmlDecode(key)
                End If
            End If
        Next lijst

        ParseLocalisatieStrings()

        For Each lijst As XMLLocalisation In FLocalisation
            If lijst.taalID = taalID Then
                Dim key As String = lijst.keys.Item(id)
                If key IsNot Nothing Then
                    Return HttpUtility.HtmlDecode(key)
                Else
                    Return String.Empty
                End If
            End If
        Next lijst

        Return String.Empty
    End Function

    Public Shared Function GetLocalisatieStrings() As List(Of XMLLocalisation)
        If FLocalisation Is Nothing Then ParseLocalisatieStrings()
        Return FLocalisation
    End Function

    Public Shared Sub ParseLocalisatieStrings()

        SyncLock _parseLocalisationLock

            FLocalisation = New List(Of XMLLocalisation)

            Dim locatie As String = HttpContext.Current.Server.MapPath("~/App_Data/localisatie.xml")

            'Document laden
            Dim xml As New XmlDocument()
            xml.Load(locatie)

            'root node ophalen
            Dim root As XmlNode = xml.DocumentElement

            'Alle strings uitlezen
            For Each child As XmlNode In root.ChildNodes
                If child.NodeType = XmlNodeType.Comment Then Continue For

                Dim taal As New XMLLocalisation
                taal.taalID = Integer.Parse(child.Attributes.GetNamedItem("id").Value)
                taal.keys = New NameValueCollection

                For Each tekst As XmlNode In child.ChildNodes
                    If child.NodeType = XmlNodeType.Comment Then Continue For
                    Dim id As String = tekst.Attributes.GetNamedItem("id").Value
                    Dim text As String = tekst.Attributes.GetNamedItem("text").Value
                    taal.keys.Add(id, text)
                Next tekst

                FLocalisation.Add(taal)
            Next child

        End SyncLock

    End Sub

End Class
