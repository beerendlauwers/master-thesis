Imports Microsoft.VisualBasic

Public Class Auto

#Region "Private Variabelen"

    Private _ID As Integer
    Private _categorie As String
    Private _model As String
    Private _kleur As String
    Private _bouwjaar As Integer
    Private _brandstoftype As String
    Private _kenteken As String
    Private _dagtarief As Double
    Private _kmTotOnderhoud As Double
    Private _status As String
    Private _filiaal As String
    Private _parkeerplaats As String

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

    Public Property Categorie() As String
        Get
            Return (_categorie)
        End Get
        Set(ByVal value As String)
            _categorie = value
        End Set
    End Property

    Public Property Model() As String
        Get
            Return (_model)
        End Get
        Set(ByVal value As String)
            _model = value
        End Set
    End Property

    Public Property Kleur() As String
        Get
            Return (_kleur)
        End Get
        Set(ByVal value As String)
            _kleur = value
        End Set
    End Property

    Public Property Bouwjaar() As Integer
        Get
            Return (_bouwjaar)
        End Get
        Set(ByVal value As Integer)
            _bouwjaar = value
        End Set
    End Property

    Public Property Brandstoftype() As String
        Get
            Return (_brandstoftype)
        End Get
        Set(ByVal value As String)
            _brandstoftype = value
        End Set
    End Property

    Public Property Kenteken() As String
        Get
            Return (_kenteken)
        End Get
        Set(ByVal value As String)
            _kenteken = value
        End Set
    End Property

    Public Property Dagtarief() As Double
        Get
            Return (_dagtarief)
        End Get
        Set(ByVal value As Double)
            _dagtarief = value
        End Set
    End Property

    Public Property KmTotOnderhoud() As Double
        Get
            Return (_kmTotOnderhoud)
        End Get
        Set(ByVal value As Double)
            _kmTotOnderhoud = value
        End Set
    End Property

    Public Property Status() As String
        Get
            Return (_status)
        End Get
        Set(ByVal value As String)
            _status = value
        End Set
    End Property

    Public Property Filiaal() As String
        Get
            Return (_filiaal)
        End Get
        Set(ByVal value As String)
            _filiaal = value
        End Set
    End Property

    Public Property Parkeerplaats() As String
        Get
            Return (_parkeerplaats)
        End Get
        Set(ByVal value As String)
            _parkeerplaats = value
        End Set
    End Property

#End Region

End Class
