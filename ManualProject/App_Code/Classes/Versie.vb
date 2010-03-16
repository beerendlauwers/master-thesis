Imports Microsoft.VisualBasic
Imports Manual

Public Class Versie
    Private _ID As Integer
    Private _versie As String

    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property

    Public Property Versie() As String
        Get
            Return _versie
        End Get
        Set(ByVal value As String)
            _versie = value
        End Set
    End Property

    Public Sub New(ByVal id As Integer, ByVal versie As String)
        _ID = id
        _versie = versie
    End Sub

    Public Sub New(ByRef row As tblVersieRow)
        _ID = row.VersieID
        _versie = row.Versie
    End Sub
End Class
