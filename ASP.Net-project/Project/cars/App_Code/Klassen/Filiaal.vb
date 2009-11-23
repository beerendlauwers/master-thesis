Imports Microsoft.VisualBasic

Public Class Filiaal
    Private _filiaalID As Integer
    Private _filiaalLocatie As String
    Private _filiaalNaam As String
    Private _filiaalAdres As String



    Public Property FiliaalID() As Integer
        Get
            Return _filiaalID
        End Get
        Set(ByVal value As Integer)
            _filiaalID = value
        End Set
    End Property



    Public Property FiliaalLocatie() As String
        Get
            Return _filiaalLocatie
        End Get
        Set(ByVal value As String)
            _filiaalLocatie = value
        End Set
    End Property



    Public Property FiliaalNaam() As String
        Get
            Return _filiaalNaam
        End Get
        Set(ByVal value As String)
            _filiaalNaam = value
        End Set
    End Property

   
    Public Property FiliaalAdres() As String
        Get
            Return _filiaalAdres
        End Get
        Set(ByVal value As String)
            _filiaalAdres = value
        End Set
    End Property

End Class
