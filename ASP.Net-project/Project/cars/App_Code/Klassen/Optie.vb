Imports Microsoft.VisualBasic

Public Class Optie
    Private _omschrijving As String
    Private _prijs As Integer
    Public Sub New()

    End Sub

    Public Property Omschrijving() As String
        Get
            Return _omschrijving
        End Get
        Set(ByVal value As String)
            _omschrijving = value
        End Set
    End Property



    Public Property Prijs() As Integer
        Get
            Return _prijs
        End Get
        Set(ByVal value As Integer)
            _prijs = value
        End Set
    End Property


End Class
