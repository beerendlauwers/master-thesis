Imports Microsoft.VisualBasic

Public Class Reservatie

#Region "Private Variabelen"
    'Reservatiegegevens
    Private _ID As Integer
    Private _klantID As Integer
    Private _autoID As Integer
    Private _gereserveerdDoorMedewerker As Integer
    Private _uitgechecktDoorMedewerker As Integer
    Private _ingechecktDoorMedewerker As Integer
    Private _begindatum As Date
    Private _einddatum As Date
#End Region

#Region "Getters & Setters"
    Public Property ID() As Integer
        Get
            Return (_ID)
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property

    Public Property KlantID() As Integer
        Get
            Return (_klantID)
        End Get
        Set(ByVal value As Integer)
            _klantID = value
        End Set
    End Property

    Public Property AutoID() As Integer
        Get
            Return (_autoID)
        End Get
        Set(ByVal value As Integer)
            _autoID = value
        End Set
    End Property

    Public Property GereserveerdDoorMedewerker() As Integer
        Get
            Return (_gereserveerdDoorMedewerker)
        End Get
        Set(ByVal value As Integer)
            _gereserveerdDoorMedewerker = value
        End Set
    End Property

    Public Property UitgechecktDoorMedewerker() As Integer
        Get
            Return (_uitgechecktDoorMedewerker)
        End Get
        Set(ByVal value As Integer)
            _uitgechecktDoorMedewerker = value
        End Set
    End Property

    Public Property IngechecktDoorMedewerker() As Integer
        Get
            Return (_ingechecktDoorMedewerker)
        End Get
        Set(ByVal value As Integer)
            _ingechecktDoorMedewerker = value
        End Set
    End Property

    Public Property Begindatum() As Date
        Get
            Return (_begindatum)
        End Get
        Set(ByVal value As Date)
            _begindatum = value
        End Set
    End Property

    Public Property Einddatum() As Date
        Get
            Return (_einddatum)
        End Get
        Set(ByVal value As Date)
            _einddatum = value
        End Set
    End Property
#End Region

End Class
