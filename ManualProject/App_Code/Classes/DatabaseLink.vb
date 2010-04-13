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
    Private _tblVideoDAL As VideoDAL

    Private Sub New()
        _tblArtikelDAL = New ArtikelDAL
        _tblCategorieDAL = New CategorieDAL
        _tblTaalDAL = New TaalDAL
        _tblVersieDAL = New VersieDAL
        _tblBedrijfDAL = New BedrijfDAL
        _tblVideoDAL = New VideoDAL
    End Sub

    ''' <summary>
    ''' Haalt de links op naar alle databasefuncties.
    ''' </summary>
    ''' <returns>De DatabaseLink singleton.</returns>
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
    ''' <returns>Een DAL-klasse voor de tabel 'Categorie'.</returns>
    Public Function GetCategorieFuncties() As CategorieDAL
        Return _tblCategorieDAL
    End Function

    ''' <summary>
    ''' Haal de databasefuncties op voor de tabel 'Taal'.
    ''' </summary>
    ''' <returns>Een DAL-klasse voor de tabel 'Taal'.</returns>
    Public Function GetTaalFuncties() As TaalDAL
        Return _tblTaalDAL
    End Function

    ''' <summary>
    ''' Haal de databasefuncties op voor de tabel 'Versie'.
    ''' </summary>
    ''' <returns>Een DAL-klasse voor de tabel 'Versie'.</returns>
    Public Function GetVersieFuncties() As VersieDAL
        Return _tblVersieDAL
    End Function

    ''' <summary>
    ''' Haal de databasefuncties op voor de tabel 'Bedrijf'.
    ''' </summary>
    ''' <returns>Een DAL-klasse voor de tabel 'Bedrijf'.</returns>
    Public Function GetBedrijfFuncties() As BedrijfDAL
        Return _tblBedrijfDAL
    End Function

    ''' <summary>
    ''' Haal de databasefuncties op voor de tabel 'Artikel'.
    ''' </summary>
    ''' <returns>Een DAL-klasse voor de tabel 'Artikel'.</returns>
    Public Function GetArtikelFuncties() As ArtikelDAL
        Return _tblArtikelDAL
    End Function

    ''' <summary>
    ''' Haal de databasefuncties op voor de tabel 'Video'.
    ''' </summary>
    ''' <returns>Een DAL-klasse voor de tabel 'Video'.</returns>
    Public Function GetVideoFuncties() As VideoDAL
        Return _tblVideoDAL
    End Function
End Class
