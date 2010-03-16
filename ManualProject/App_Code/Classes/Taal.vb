Imports Microsoft.VisualBasic
Imports Manual

Public Class Taal
    Private _ID As Integer
    Private _taal As String

    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property

    Public Property Taal() As String
        Get
            Return _taal
        End Get
        Set(ByVal value As String)
            _taal = value
        End Set
    End Property

    Public Sub New(ByVal id As Integer, ByVal taal As String)
        _ID = id
        _taal = Taal
    End Sub

    Public Sub New(ByRef row As tblTaalRow)
        _ID = row.TaalID
        _taal = row.Taal
    End Sub

End Class
