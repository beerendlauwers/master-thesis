Imports Microsoft.VisualBasic

Public Class Chauffeur
    Private _chauffeurID As Integer
    Private _chauffeurNaam As String
    Private _chauffeurVoornaam As String
    Private _chauffeurBedrijfID As Integer



    Public Property ChauffeurID() As Integer
        Get
            Return _chauffeurID
        End Get
        Set(ByVal value As Integer)
            _chauffeurID = value
        End Set
    End Property


    Public Property ChauffeurNaam() As String
        Get
            Return _chauffeurNaam
        End Get
        Set(ByVal value As String)
            _chauffeurNaam = value
        End Set
    End Property


    Public Property ChauffeurVoornaam() As String
        Get
            Return _chauffeurVoornaam
        End Get
        Set(ByVal value As String)
            _chauffeurVoornaam = value
        End Set
    End Property


    Public Property ChauffeurBedrijfID() As Integer
        Get
            Return _chauffeurBedrijfID
        End Get
        Set(ByVal value As Integer)
            _chauffeurBedrijfID = value
        End Set
    End Property


End Class
