Imports Microsoft.VisualBasic

Public Class Categorie
    Private _CategorieID As Integer
    Private _Categorie As String
    Private _Diepte As Integer
    Private _Hoogte As Integer
    Private _FK_Parent As Integer
    Private _FK_Taal As Integer
    Private _FK_Bedrijf As Integer
    Private _FK_Versie As Integer

    Private Shared FCategorieen As List(Of Categorie) = Nothing

    Public Property CategorieID() As Integer
        Get
            Return _CategorieID
        End Get
        Set(ByVal value As Integer)
            _CategorieID = value
        End Set
    End Property

    Public Property Categorie() As String
        Get
            Return _Categorie
        End Get
        Set(ByVal value As String)
            _Categorie = value
        End Set
    End Property

    Public Property Diepte() As String
        Get
            Return _Diepte
        End Get
        Set(ByVal value As String)
            _Diepte = value
        End Set
    End Property

    
    Public Property Hoogte() As Integer
        Get
            Return _Hoogte
        End Get
        Set(ByVal value As Integer)
            _Hoogte = value
        End Set
    End Property

    Public Property FK_Parent() As Integer
        Get
            Return _FK_Parent
        End Get
        Set(ByVal value As Integer)
            _FK_Parent = value
        End Set
    End Property

 
    Public Property FK_Taal() As Integer
        Get
            Return _FK_Taal
        End Get
        Set(ByVal value As Integer)
            _FK_Taal = value
        End Set
    End Property

    Public Property Versie() As String
        Get
            Return _FK_Versie
        End Get
        Set(ByVal value As String)
            _FK_Versie = value
        End Set
    End Property

    Public Property Bedrijf() As String
        Get
            Return _FK_Bedrijf
        End Get
        Set(ByVal value As String)
            _FK_Bedrijf = value
        End Set
    End Property

    Public Sub New()

    End Sub

    Public Sub New(ByVal CategorieID As Integer, ByVal Categorie As String, ByVal Hoogte As Integer, ByVal Diepte As Integer, ByVal FK_parent As Integer, ByVal FK_Taal As Integer, ByVal FK_Versie As Integer, ByVal FK_Bedrijf As Integer)
        _CategorieID = CategorieID
        _Categorie = Categorie
        _Hoogte = Hoogte
        _Diepte = Diepte
        _FK_Parent = FK_parent
        _FK_Taal = FK_Taal
        _FK_Versie = FK_Versie
        _FK_Bedrijf = FK_Bedrijf
    End Sub

    Public Sub New(ByRef c As Manual.tblCategorieRow)
        Try
            _CategorieID = c.CategorieID
            _Categorie = c.Categorie
            _Hoogte = c.Hoogte
            _Diepte = c.Diepte
            _FK_Parent = c.FK_parent
            _FK_Taal = c.FK_taal
            _FK_Versie = c.FK_versie
            _FK_Bedrijf = c.FK_bedrijf
        Catch ex As Exception
            Dim e As New ErrorLogger("Kon een categorie niet aanmaken omdat de gevraagde rij niet werd gevonden in de database.","CATEGORIE_0001")
            ErrorLogger.WriteError(e)
        End Try
    End Sub
End Class
