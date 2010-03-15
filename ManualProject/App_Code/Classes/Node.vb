Imports Microsoft.VisualBasic

Public Enum ContentType
    Categorie = 0
    Artikel = 1
End Enum

Public Class Node
    Private _ID As Integer
    Private _type As ContentType
    Private _titel As String
    Private _children As List(Of Node)

    Public Sub New(ByVal id As Integer, ByVal type As ContentType, ByVal titel As String)
        _ID = id
        _type = type
        _titel = titel
        _children = New List(Of Node)
    End Sub

    Public Sub New(ByRef artikel As Artikel)
        _ID = artikel.ID
        _type = ContentType.Artikel
        _titel = artikel.Titel
        _children = New List(Of Node)
    End Sub

    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property

    Public Property Type() As ContentType
        Get
            Return _type
        End Get
        Set(ByVal value As ContentType)
            _type = value
        End Set
    End Property

    Public Property Titel() As String
        Get
            Return _titel
        End Get
        Set(ByVal value As String)
            _titel = value
        End Set
    End Property

    ''' <summary>
    ''' Haal de kinderen op van deze node.
    ''' </summary>
    Public Function GetChildren() As List(Of Node)
        Return _children
    End Function

    ''' <summary>
    ''' Voeg een kind aan deze node toe.
    ''' </summary>
    Public Sub AddChild(ByRef node As Node)
        _children.Add(node)
    End Sub

    ''' <summary>
    ''' Geeft het aantal kinderen van deze nodes terug.
    ''' </summary>
    Public Function GetChildCount() As Integer
        Return _children.Count
    End Function

    ''' <summary>
    ''' Doorzoek recursief de kinderen van deze node, de kinderen van de kinderen, etc.
    ''' </summary>
    Public Function GetChildBy(ByVal id As Integer, ByVal type As ContentType) As Node

        For Each n As Node In _children
            'Huidige kinderen doorzoeken
            If n._ID = id And n._type = type Then
                Return n
            End If

            'Kinderen van dit kind doorzoeken
            Dim child As Node = n.GetChildBy(id, type)
            If child IsNot Nothing Then
                Return child
            End If
        Next n

        Return Nothing
    End Function

End Class
