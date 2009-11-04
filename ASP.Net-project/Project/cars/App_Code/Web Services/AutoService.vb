Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports AjaxControlToolkit

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class AutoService
    Inherits System.Web.Services.WebService
    Private _autoBLL As New AutoBLL

    <WebMethod()> _
    Public Function GeefMerken(ByVal knownCategoryValues As String, ByVal category As String) As CascadingDropDownNameValue()

        ' BLL contacteren om een lijst van merken te verkrijgen.
        Dim merken As Auto_s.tblMerkDataTable = _autoBLL.GetAllMerken()

        'In deze lijst gaan we alle waardes steken die we gaan uitlezen.
        Dim dropdownwaardes As List(Of CascadingDropDownNameValue) = New List(Of CascadingDropDownNameValue)

        'Tijdelijke variabelen initialiseren
        Dim merknaam As String = String.Empty
        Dim merkID As Integer = 0
        Dim waarde As CascadingDropDownNameValue

        For Each dr As Auto_s.tblMerkRow In merken
            'Waardes lezen uit row
            merknaam = CType(dr.merkNaam, String)
            merkID = CType(dr.merkID, Integer)

            'Waardes opslaan in tijdelijke CascadingDropDownNameValue
            waarde = New CascadingDropDownNameValue(merknaam, merkID)
            'Deze waarde toevoegen aan de dropdown
            dropdownwaardes.Add(waarde)
        Next

        Return dropdownwaardes.ToArray()
    End Function

    <WebMethod()> _
    Public Function GeefModellenVoorMerk(ByVal knownCategoryValues As String, ByVal category As String) As CascadingDropDownNameValue()

        Dim keyvalues As StringDictionary = CascadingDropDown.ParseKnownCategoryValuesString(knownCategoryValues)
        Dim merkID As Integer

        'Als we geen Merk vinden of als het merk geen waarde heeft, returnen we niks.
        If (Not keyvalues.ContainsKey("Merk") Or Not Int32.TryParse(keyvalues("Merk"), merkID)) Then
            Return Nothing
        End If

        'In deze lijst gaan we alle waardes steken die we gaan uitlezen.
        Dim dropdownwaardes As List(Of CascadingDropDownNameValue) = New List(Of CascadingDropDownNameValue)

        ' BLL contacteren om een lijst van modellen te verkrijgen.
        Dim modellen As Auto_s.tblModelDataTable = _autoBLL.GetModelsByMerk(merkID)

        'Tijdelijke variabelen initialiseren
        Dim modelnaam As String = String.Empty
        Dim modelID As Integer = 0
        Dim waarde As CascadingDropDownNameValue

        For Each dr As Auto_s.tblModelRow In modellen
            'Waardes lezen uit row
            modelnaam = CType(dr.modelNaam, String)
            modelID = CType(dr.modelID, Integer)

            'Waardes opslaan in tijdelijke CascadingDropDownNameValue
            waarde = New CascadingDropDownNameValue(modelnaam, modelID)
            'Deze waarde toevoegen aan de dropdown
            dropdownwaardes.Add(waarde)
        Next

        Return dropdownwaardes.ToArray()
    End Function

    <WebMethod()> _
    Public Function GeefCategorien(ByVal knownCategoryValues As String, ByVal category As String) As CascadingDropDownNameValue()

        ' BLL contacteren om een lijst van categoriën te verkrijgen.
        Dim categorien As Auto_s.tblCategorieDataTable = _autoBLL.GetAllCategorien()

        'In deze lijst gaan we alle waardes steken die we gaan uitlezen.
        Dim dropdownwaardes As List(Of CascadingDropDownNameValue) = New List(Of CascadingDropDownNameValue)

        'Tijdelijke variabelen initialiseren
        Dim categorienaam As String = String.Empty
        Dim categorieID As Integer = 0
        Dim waarde As CascadingDropDownNameValue

        For Each dr As Auto_s.tblCategorieRow In categorien
            'Waardes lezen uit row
            categorienaam = CType(dr.categorieNaam, String)
            categorieID = CType(dr.categorieID, Integer)

            'Waardes opslaan in tijdelijke CascadingDropDownNameValue
            waarde = New CascadingDropDownNameValue(categorienaam, categorieID)
            'Deze waarde toevoegen aan de dropdown
            dropdownwaardes.Add(waarde)
        Next

        Return dropdownwaardes.ToArray()
    End Function

    <WebMethod()> _
Public Function GeefKleurPerCategorie(ByVal knownCategoryValues As String, ByVal category As String) As CascadingDropDownNameValue()

        Dim keyvalues As StringDictionary = CascadingDropDown.ParseKnownCategoryValuesString(knownCategoryValues)
        Dim categorieID As Integer

        'Als we geen Categorie vinden of als de categorie geen waarde heeft, returnen we niks.
        If (Not keyvalues.ContainsKey("Categorie") Or Not Int32.TryParse(keyvalues("Categorie"), categorieID)) Then
            Return Nothing
        End If

        'In deze lijst gaan we alle waardes steken die we gaan uitlezen.
        Dim dropdownwaardes As List(Of CascadingDropDownNameValue) = New List(Of CascadingDropDownNameValue)

        ' BLL contacteren om een lijst van kleuren te verkrijgen.
        Dim kleuren As String() = _autoBLL.GetKleurenByCategorie(categorieID)

        'Tijdelijke variabelen initialiseren
        Dim kleurnaam As String = String.Empty
        Dim kleurID As Integer = 0
        Dim waarde As CascadingDropDownNameValue
        Dim i As Integer = 0

        While (i < kleuren.Length() - 1)

            If kleuren(i) = String.Empty Then
                i = i + 1
                Continue While
            End If

            'Waardes invoeren
            kleurnaam = kleuren(i)
            kleurID = i
            i = i + 1

            'Waardes opslaan in tijdelijke CascadingDropDownNameValue
            waarde = New CascadingDropDownNameValue(kleurnaam, kleurID)
            'Deze waarde toevoegen aan de dropdown
            dropdownwaardes.Add(waarde)
        End While

        Return dropdownwaardes.ToArray()
    End Function

End Class
