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

    <WebMethod()> _
    Public Function GeefMerken(ByVal knownCategoryValues As String, ByVal category As String) As CascadingDropDownNameValue()
        ' Adapter om de merken op te halen klaarmaken.
        Dim merkAdapter As Auto_sTableAdapters.tblMerkTableAdapter = New Auto_sTableAdapters.tblMerkTableAdapter()
        ' Adapter gebruiken om een lijst van merken te verkrijgen.
        Dim merken As Auto_s.tblMerkDataTable = merkAdapter.GetData()

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

        ' Adapter om de modellen op te halen klaarmaken.
        Dim modelAdapter As Auto_sTableAdapters.tblModelTableAdapter = New Auto_sTableAdapters.tblModelTableAdapter()
        ' Adapter gebruiken om een lijst van modellen te verkrijgen op basis van merkID.
        Dim modellen As Auto_s.tblModelDataTable = modelAdapter.GetAllModelByMerk(merkID)


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

End Class
