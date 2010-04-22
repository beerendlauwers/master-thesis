Imports Microsoft.VisualBasic
Imports System.IO
Imports System.Xml
Imports System.Xml.Xsl
Imports System.Xml.XPath
Imports System.Web.HttpContext

Public Class Lokalisatie

    Private _taalID As Integer
    Private _keys As NameValueCollection

    Private Shared _parseLocalisationLock As New Object
    Private Shared FLocalisation As List(Of Lokalisatie)

    Public Property Keys() As NameValueCollection
        Get
            Return _keys
        End Get
        Set(ByVal value As NameValueCollection)
            _keys = value
        End Set
    End Property

    Public Property TaalID() As Integer
        Get
            Return _taalID
        End Get
        Set(ByVal value As Integer)
            _taalID = value
        End Set
    End Property

    Public Shared ReadOnly Property Talen() As List(Of Lokalisatie)
        Get
            If FLocalisation Is Nothing Then
                ParseLocalisatieStrings()
            End If

            Return FLocalisation
        End Get
    End Property

    Public Shared Function GetTekstCount() As Integer
        Dim aantalteksten As Integer = 0
        For Each t As Lokalisatie In Talen
            aantalteksten = aantalteksten + t.Keys.Count
        Next
        Return aantalteksten
    End Function

    Public Function LeesContent() As String
        Dim html As String = String.Empty

        For i As Integer = 0 To Me.Keys.Count - 1
            html = String.Concat(html, "(", i + 1, ") ", Me.Keys.Keys(i), ": ", Me.Keys.Item(i), "<br/>")
        Next i

        Return html
    End Function

    Public Shared Function Taal(ByVal id As Integer) As Lokalisatie
        For Each t As Lokalisatie In Talen
            If t.TaalID = id Then
                Return t
            End If
        Next t

        Return Nothing
    End Function

    Public Shared Function GetString(ByVal id As String) As String
        If Not Talen.Count = 0 Then
            Dim taalID As Integer = Talen.Item(0).TaalID
            If Current.Session("taal") IsNot Nothing Then
                taalID = Current.Session("taal")
                If taalID = 0 Or taalID = 5 Then
                Else
                    taalID = 10
                End If
            End If

            For Each lijst As Lokalisatie In Talen
                If lijst.TaalID = taalID Then
                    Dim key As String = lijst.Keys.Item(id)
                    If key IsNot Nothing Then
                        Return HttpUtility.HtmlDecode(key)
                    End If
                End If
            Next lijst

            ParseLocalisatieStrings()

            For Each lijst As Lokalisatie In Talen
                If lijst.TaalID = taalID Then
                    Dim key As String = lijst.Keys.Item(id)
                    If key IsNot Nothing Then
                        Return HttpUtility.HtmlDecode(key)
                    Else
                        Return String.Empty
                    End If
                End If
            Next lijst
        End If
        Return String.Empty
    End Function

    Public Shared Function ParseLocalisatieStrings() As String

        SyncLock _parseLocalisationLock

            Try
                FLocalisation = New List(Of Lokalisatie)

                Dim locatie As String = HttpContext.Current.Server.MapPath("~/App_Data/localisatie.xml")

                'Document laden
                Dim xml As New XmlDocument()
                xml.Load(locatie)

                'root node ophalen
                Dim root As XmlNode = xml.DocumentElement

                'Alle strings uitlezen
                For Each child As XmlNode In root.ChildNodes
                    If child.NodeType = XmlNodeType.Comment Then Continue For

                    Dim taal As New Lokalisatie
                    taal.TaalID = Integer.Parse(child.Attributes.GetNamedItem("id").Value)
                    taal.Keys = New NameValueCollection

                    For Each tekst As XmlNode In child.ChildNodes
                        If child.NodeType = XmlNodeType.Comment Then Continue For
                        Dim id As String = tekst.Attributes.GetNamedItem("id").Value
                        Dim text As String = tekst.Attributes.GetNamedItem("text").Value
                        taal.Keys.Add(id, text)
                    Next tekst

                    FLocalisation.Add(taal)
                Next child

            Catch ex As Exception
                ErrorLogger.WriteError(New ErrorLogger(ex.Message))
                Return ex.Message
            End Try

        End SyncLock

        Return "OK"
    End Function
End Class
