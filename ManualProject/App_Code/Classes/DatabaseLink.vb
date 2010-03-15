Imports Microsoft.VisualBasic
Imports ManualTableAdapters

''' <summary>
''' Een Singleton Class die een link geeft naar alle databasefuncties.
''' </summary>
Public Class DatabaseLink
    Private Shared FInstance As DatabaseLink = Nothing

    Private _tblArtikelDAL As ArtikelDAL
    Private _tblCategorieDAL As CategorieDAL
    Private _tblTaalDAL As TaalDAL
    Private _tblVersieDAL As VersieDAL
    Private _tblBedrijfDAL As BedrijfDAL

    Private Sub New()
        _tblArtikelDAL = New ArtikelDAL
        _tblCategorieDAL = New CategorieDAL
        _tblTaalDAL = New TaalDAL
        _tblVersieDAL = New VersieDAL
        _tblBedrijfDAL = New BedrijfDAL

    End Sub

    ''' <summary>
    ''' Haalt de links op naar alle databasefuncties.
    ''' </summary>
    Public Shared ReadOnly Property GetInstance() As DatabaseLink
        Get
            If (FInstance Is Nothing) Then
                FInstance = New DatabaseLink()
            End If

            Return FInstance
        End Get
    End Property

    ''' <summary>
    ''' Haal de databasefuncties op voor de tabel 'Categorie'.
    ''' </summary>
    Public Function GetCategorieFuncties() As CategorieDAL
        Return _tblCategorieDAL
    End Function

    ''' <summary>
    ''' Haal de databasefuncties op voor de tabel 'Taal'.
    ''' </summary>
    Public Function GetTaalFuncties() As TaalDAL
        Return _tblTaalDAL
    End Function

    ''' <summary>
    ''' Haal de databasefuncties op voor de tabel 'Versie'.
    ''' </summary>
    Public Function GetVersieFuncties() As VersieDAL
        Return _tblVersieDAL
    End Function

    ''' <summary>
    ''' Haal de databasefuncties op voor de tabel 'Bedrijf'.
    ''' </summary>
    Public Function GetBedrijfFuncties() As BedrijfDAL
        Return _tblBedrijfDAL
    End Function

    ''' <summary>
    ''' Haal de databasefuncties op voor de tabel 'Artikel'.
    ''' </summary>
    Public Function GetArtikelFuncties() As ArtikelDAL
        Return _tblArtikelDAL
    End Function
End Class
