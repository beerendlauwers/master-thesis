Imports Microsoft.VisualBasic

Public Enum ContentType
    Categorie = 0
    Artikel = 1
End Enum

Public Class Node
    Private _ID As Integer
    Private _type As ContentType
    Private _tekst As String
    Private _titel As String
    Private _children As List(Of Node)

    Public Sub New(ByVal id As Integer, ByVal type As ContentType, ByVal tekst As String, ByVal titel As String)
        _ID = id
        _type = type
        _tekst = tekst
        _titel = titel
        _children = New List(Of Node)
    End Sub

    Public Sub AddChild(ByRef node As Node)
        _children.Add(node)
    End Sub

    Public Function GetChildCount() As Integer
        Return _children.Count
    End Function

    Public Function GetChildBy(ByVal id As Integer, ByVal type As ContentType) As Node

        For Each n As Node In _children
            If n._ID = id And n._type = type Then
                Return n
            End If
        Next n

        Return Nothing
    End Function

End Class
