Imports Microsoft.VisualBasic

Public Class Klant

#Region "Private Variabelen"
    'Klantengegevens
    Private _ID As Integer
    Private _gebruikersnaam As String
    Private _gebruikerspaswoord As String
    Private _naam As String
    Private _voornaam As String
    Private _geboortedatum As Date
    Private _identiteitskaartnummer As String
    Private _rijbewijsnummer As String
    Private _telefoon As String
    Private _email As String
    Private _commentaar As String
    Private _btwnummer As String
    Private _bedrijfLocatie As String

    'Klanteninformatie
    Private _isProblematisch As Boolean
    Private _heeftRechtOpKorting As Boolean
    Private _kortingwaarde As Double
    Private _aantalDagenGehuurd As Integer
    Private _aantalDagenGereserveerd As Integer
    Private _aantalKilometerGereden As Double
#End Region
    Sub New()

    End Sub
    Sub New(ByVal id As Integer, ByVal gnaam As String, ByVal gpass As String, ByVal naam As String, _
             ByVal vnaam As String, ByVal gebdat As Date, ByVal idkaartnr As String, _
             ByVal rijbewijsnr As String, ByVal telefoon As String, ByVal email As String)
        _ID = id
        _gebruikersnaam = gnaam
        _gebruikerspaswoord = gpass
        _naam = naam
        _voornaam = vnaam
        _geboortedatum = gebdat
        _identiteitskaartnummer = idkaartnr
        _rijbewijsnummer = rijbewijsnr
        _telefoon = telefoon
        _email = email
    End Sub

#Region "Getters & Setters"

    Public Property ID() As Integer
        Get
            Return (_ID)
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property

    Public Property Gebruikersnaam() As String
        Get
            Return (_gebruikersnaam)
        End Get
        Set(ByVal value As String)
            _gebruikersnaam = value
        End Set
    End Property

    Public Property Gebruikerspaswoord() As String
        Get
            Return (_gebruikerspaswoord)
        End Get
        Set(ByVal value As String)
            _gebruikerspaswoord = value
        End Set
    End Property

    Public Property Naam() As String
        Get
            Return (_naam)
        End Get
        Set(ByVal value As String)
            _naam = value
        End Set
    End Property

    Public Property Voornaam() As String
        Get
            Return (_voornaam)
        End Get
        Set(ByVal value As String)
            _voornaam = value
        End Set
    End Property

    Public Property Geboortedatum() As Date
        Get
            Return (_geboortedatum)
        End Get
        Set(ByVal value As Date)
            _geboortedatum = value
        End Set
    End Property

    Public Property Identiteitskaartnummer() As String
        Get
            Return (_identiteitskaartnummer)
        End Get
        Set(ByVal value As String)
            _identiteitskaartnummer = value
        End Set
    End Property

    Public Property Rijbewijsnummer() As String
        Get
            Return (_rijbewijsnummer)
        End Get
        Set(ByVal value As String)
            _rijbewijsnummer = value
        End Set
    End Property

    Public Property Telefoon() As String
        Get
            Return (_telefoon)
        End Get
        Set(ByVal value As String)
            _telefoon = value
        End Set
    End Property

    Public Property Email() As String
        Get
            Return (_email)
        End Get
        Set(ByVal value As String)
            _email = value
        End Set
    End Property

    Public Property Commentaar() As String
        Get
            Return (_commentaar)
        End Get
        Set(ByVal value As String)
            _commentaar = value
        End Set
    End Property

    Public Property BTWnummer() As String
        Get
            Return (_btwnummer)
        End Get
        Set(ByVal value As String)
            _btwnummer = value
        End Set
    End Property

    Public Property BedrijfLocatie() As String
        Get
            Return _bedrijfLocatie
        End Get
        Set(ByVal value As String)
            _bedrijfLocatie = value
        End Set
    End Property


    Public Property IsProblematisch() As Boolean
        Get
            Return (_isProblematisch)
        End Get
        Set(ByVal value As Boolean)
            _isProblematisch = value
        End Set
    End Property

    Public Property HeeftRechtOpKorting() As Boolean
        Get
            Return (_heeftRechtOpKorting)
        End Get
        Set(ByVal value As Boolean)
            _heeftRechtOpKorting = value
        End Set
    End Property

    Public Property KortingWaarde() As Double
        Get
            Return (_kortingwaarde)
        End Get
        Set(ByVal value As Double)
            _kortingwaarde = value
        End Set
    End Property

    Public Property AantalDagenGehuurd() As Integer
        Get
            Return (_aantalDagenGehuurd)
        End Get
        Set(ByVal value As Integer)
            _aantalDagenGehuurd = value
        End Set
    End Property

    Public Property AantalDagenGereserveerd() As Integer
        Get
            Return (_aantalDagenGereserveerd)
        End Get
        Set(ByVal value As Integer)
            _aantalDagenGereserveerd = value
        End Set
    End Property

    Public Property AantalKilometerGereden() As Double
        Get
            Return (_aantalKilometerGereden)
        End Get
        Set(ByVal value As Double)
            _aantalKilometerGereden = value
        End Set
    End Property

#End Region

End Class
