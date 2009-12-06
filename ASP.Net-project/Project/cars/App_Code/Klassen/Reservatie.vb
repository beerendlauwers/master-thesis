Imports Microsoft.VisualBasic

<Serializable()> _
Public Class Reservatie

#Region "Private Variabelen"
    'Reservatiegegevens
    Private _ID As Integer
    Private _userID As Guid
    Private _autoID As Integer
    Private _gereserveerdDoorMedewerker As Guid
    Private _uitgechecktDoorMedewerker As Guid
    Private _ingechecktDoorMedewerker As Guid
    Private _begindatum As Date
    Private _einddatum As Date
    Private _isBevestigd As Boolean
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

    Public Property UserID() As Guid
        Get
            Return (_userID)
        End Get
        Set(ByVal value As Guid)
            _userID = value
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

    Public Property GereserveerdDoorMedewerker() As Guid
        Get
            Return (_gereserveerdDoorMedewerker)
        End Get
        Set(ByVal value As Guid)
            _gereserveerdDoorMedewerker = value
        End Set
    End Property

    Public Property UitgechecktDoorMedewerker() As Guid
        Get
            Return (_uitgechecktDoorMedewerker)
        End Get
        Set(ByVal value As Guid)
            _uitgechecktDoorMedewerker = value
        End Set
    End Property

    Public Property IngechecktDoorMedewerker() As Guid
        Get
            Return (_ingechecktDoorMedewerker)
        End Get
        Set(ByVal value As Guid)
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

    Public Property IsBevestigd() As Boolean
        Get
            Return (_isBevestigd)
        End Get
        Set(ByVal value As Boolean)
            _isBevestigd = value
        End Set
    End Property
#End Region

End Class
