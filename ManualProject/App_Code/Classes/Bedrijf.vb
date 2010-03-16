Imports Microsoft.VisualBasic
Imports Manual

Public Class Bedrijf
    Private _ID As Integer
    Private _naam As String
    Private _tag As String

    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property

    Public Property Naam() As String
        Get
            Return _naam
        End Get
        Set(ByVal value As String)
            _naam = value
        End Set
    End Property

    Public Property Tag() As String
        Get
            Return _tag
        End Get
        Set(ByVal value As String)
            _tag = value
        End Set
    End Property

    Public Sub New(ByVal id As Integer, ByVal naam As String, ByVal tag As String)
        _ID = id
        _naam = naam
        _tag = Tag
    End Sub

    Public Sub New(ByRef row As tblBedrijfRow)
        _ID = row.BedrijfID
        _naam = row.Naam
        _tag = row.Tag
    End Sub

End Class
