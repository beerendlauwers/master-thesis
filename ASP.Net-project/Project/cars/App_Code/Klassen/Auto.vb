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
    Private _foto As Byte()

#End Region

#Region "Auto aanmaken met databankdata"
    ''' <summary>
    ''' Een Auto aanmaken met gegevens uit de databank. Foreign keys worden automatisch opgezocht en geconverteerd.
    ''' </summary>
    ''' <param name="id">ID in de databank</param>
    ''' <param name="categorieID">categorieID van de databank</param>
    ''' <param name="modelID">modelID van de databank</param>
    ''' <param name="kleur">Kleur van de auto</param>
    ''' <param name="bouwjaar">Bouwjaar van de auto</param>
    ''' <param name="brandstofID">brandstofID van de databank</param>
    ''' <param name="kenteken">Kenteken van de auto</param>
    ''' <param name="dagtarief">Dagtarief van de auto</param>
    ''' <param name="statusID">statusID van de databank</param>
    ''' <param name="filiaalID">filiaalID van de databank</param>
    ''' <param name="parkeerplaats">Parkeerplaats van de auto</param>
    ''' <param name="foto">Foto van de auto</param>
    Public Sub New(ByVal id As Integer, ByVal categorieID As Integer, ByVal modelID As Integer, ByVal kleur As String, _
             ByVal bouwjaar As Integer, ByVal brandstofID As Integer, ByVal kenteken As String, _
             ByVal dagtarief As Double, ByVal statusID As Integer, ByVal filiaalID As Integer, ByVal parkeerplaats As String, _
             ByVal foto As Byte())

        Dim brandstofbll As New BrandstofBLL
        Dim autobll As New AutoBLL
        Dim categoriebll As New CategorieBLL
        Dim modelbll As New ModelBLL
        Dim statusbll As New AutoStatusBLL
        Dim filiaalbll As New FiliaalBLL

        _ID = id
        _categorie = categoriebll.GetCategorieByID(categorieID)
        _model = modelbll.GetModelNaamByModelID(modelID)
        _kleur = kleur
        _bouwjaar = bouwjaar
        _brandstoftype = brandstofbll.GetBrandstofTypeByID(brandstofID)
        _kenteken = kenteken
        _dagtarief = dagtarief
        _status = statusbll.GetAutostatusNaamByAutostatusID(statusID)
        _filiaal = filiaalbll.GetFiliaalNaamByFiliaalID(filiaalID)
        _parkeerplaats = parkeerplaats
        _foto = foto

    End Sub
#End Region

    Public Sub New()
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

    Public Property Foto() As Byte()
        Get
            Return (_foto)
        End Get
        Set(ByVal value As Byte())
            _foto = value
        End Set
    End Property

#End Region

End Class
