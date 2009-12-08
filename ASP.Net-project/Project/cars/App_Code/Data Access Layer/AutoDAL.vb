Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class AutoDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllAutos() As Autos.tblAutoDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblAuto")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutoDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutoDataTable)
    End Function

    Public Function GetAutosByCategorieID(ByVal categorieID As Integer) As Autos.tblAutoDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAuto WHERE categorieID = @categorieID")
        myCommand.Parameters.Add("@categorieID", SqlDbType.Int).Value = categorieID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutoDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutoDataTable)

    End Function

    Public Function GetAutoByAutoID(ByVal autoID As Integer) As Autos.tblAutoDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAuto WHERE autoID = @autoID")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutoDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutoDataTable)

    End Function

    Public Function GetAutosByKenteken(ByVal autoKenteken As String) As Autos.tblAutoDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAuto WHERE autoKenteken = @autoKenteken")
        myCommand.Parameters.Add("@autoKenteken", SqlDbType.NChar).Value = autoKenteken
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutoDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutoDataTable)

    End Function

    Public Function GetAutosBy(ByVal filterOpties() As String) As Autos.tblAutoDataTable

        'filterOpties expanden
        Dim categorie, kleur, automerk, filiaal, brandstoftype, prijsmin, prijsmax As String
        categorie = filterOpties(0)
        kleur = filterOpties(1)
        automerk = filterOpties(2)
        filiaal = filterOpties(3)
        brandstoftype = filterOpties(4)

        If (Not filterOpties(5) = String.Empty And Not filterOpties(6) = String.Empty) Then
            prijsmin = filterOpties(5).Replace(",", ".")
            prijsmax = filterOpties(6).Replace(",", ".")
        End If

        'query opbouwen
        Dim myCommand As New SqlCommand
        Dim filtercount As Integer = 0
        Dim querytext As String = "SELECT * FROM tblAuto A"

        If (Not automerk = String.Empty) Then
            querytext = String.Concat(querytext, ", tblModel M")
        End If

        querytext = String.Concat(querytext, " WHERE ")

        If (Not categorie = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "categorieID = @categorie")
            myCommand.Parameters.Add("@categorie", SqlDbType.Int).Value = categorie
            filtercount = filtercount + 1
        End If

        If (Not automerk = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "M.merkID = @automerk AND A.modelID = M.modelID")
            myCommand.Parameters.Add("@automerk", SqlDbType.Int).Value = automerk
            filtercount = filtercount + 1
        End If

        If (Not kleur = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "autoKleur = @autoKleur")
            myCommand.Parameters.Add("@autoKleur", SqlDbType.NChar).Value = kleur
            filtercount = filtercount + 1
        End If

        If (Not filiaal = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "A.filiaalID = @filiaal")
            myCommand.Parameters.Add("@filiaal", SqlDbType.Int).Value = filiaal
            filtercount = filtercount + 1
        End If

        If (Not brandstoftype = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "brandstofID = @brandstoftype")
            myCommand.Parameters.Add("@brandstoftype", SqlDbType.Int).Value = brandstoftype
            filtercount = filtercount + 1
        End If

        If (Not prijsmin = String.Empty And Not prijsmax = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "autoDagTarief BETWEEN @prijsMin AND @prijsMax")
            myCommand.Parameters.Add("@prijsMin", SqlDbType.Float).Value = prijsmin
            myCommand.Parameters.Add("@prijsMax", SqlDbType.Float).Value = prijsmax
            filtercount = filtercount + 1
        End If

        myCommand.CommandText = querytext
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutoDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutoDataTable)

    End Function

    Public Function GetAutoNaamByAutoID(ByVal id As Integer) As String

        Dim myCommand As New SqlCommand("SELECT merkNaam + ' ' + modelNaam AS naam FROM tblAuto A, tblModel MO, tblMerk ME WHERE autoID = @autoID AND A.modelID = MO.modelID AND MO.merkID = ME.merkID")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = id
        myCommand.Connection = _myConnection

        Return CType(_f.ReadSingleItem(myCommand, "naam"), String)

    End Function

    Public Function GetKleurenByCategorieID(ByVal categorieID As Integer) As String()

        Dim myCommand As New SqlCommand("SELECT DISTINCT autoKleur FROM tblAuto WHERE categorieID = @categorieID")
        myCommand.Parameters.Add("@categorieID", SqlDbType.Int).Value = categorieID
        myCommand.Connection = _myConnection

        Dim myReader As SqlDataReader

        myCommand.Connection.Open()

        myReader = myCommand.ExecuteReader

        Dim kleuren(128) As String
        Dim i As Integer = 0
        For i = 0 To 127
            kleuren(i) = String.Empty
        Next
        If (myReader.HasRows) Then
            i = 0
            While myReader.Read
                kleuren(i) = myReader.Item(0).ToString
                i = i + 1
            End While
        End If

        myCommand.Connection.Close()

        Return kleuren
    End Function

    Public Function getAutoIDByKenteken(ByVal autoKenteken As String) As Integer

        Dim myCommand As New SqlCommand("SELECT autoID FROM tblAuto WHERE autoKenteken=@autoKenteken")
        myCommand.Parameters.Add("@autoKenteken", SqlDbType.NChar).Value = autoKenteken
        myCommand.Connection = _myConnection

        Return CType(_f.ReadSingleItem(myCommand, "autoID"), String)

    End Function

    'Public Function getAutoGrid() As Autos.tblAutoDataTable
    '    Dim myCommand As New SqlCommand("select a.autokenteken, a.autobouwjaar, a.autodagtarief,a.autokleur, f.filiaalnaam, p.parkeerplaatsKolom parkingKolom, p.parkeerplaatsRij parkingRij,st.autostatusnaam, m.merknaam, ml.modelnaam from tblAuto a, tblfiliaal f, tblParkeerplaats p, tblAutostatus st, tblMerk m, tblModel ml where a.filiaalID = f.filiaalID And p.parkeerplaatsID = a.parkeerplaatsID AND st.autostatusID=a.statusID AND a.modelID = ml.modelID AND m.merkID=ml.merkID;")
    '    myCommand.Connection = _myConnection

    '    Dim dt As New Autos.tblAutoDataTable
    '    Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutoDataTable)
    'End Function

    Public Function getAutoGrid() As Data.DataTable
        Dim dt As New Data.DataTable

        Dim myCommand As New SqlCommand("SELECT tblAuto.autoID, tblAuto.categorieID, tblAuto.modelID, tblAuto.autoKleur, tblAuto.autoBouwjaar, tblAuto.brandstofID, tblAuto.autoKenteken, tblAuto.autoDagTarief, tblAuto.autoKMTotOlieVerversing, tblAuto.statusID, tblAuto.filiaalID, tblAuto.parkeerPlaatsID, tblAutostatus.autostatusID, tblAutostatus.autostatusNaam, tblFiliaal.filiaalID AS Expr1, tblFiliaal.filiaalNaam, tblMerk.merkID, tblMerk.merkNaam, tblModel.modelID AS Expr2, tblModel.merkID AS Expr3, tblModel.modelNaam FROM tblAuto INNER JOIN tblAutostatus ON tblAuto.statusID = tblAutostatus.autostatusID INNER JOIN tblFiliaal ON tblAuto.filiaalID = tblFiliaal.filiaalID INNER JOIN tblModel ON tblAuto.modelID = tblModel.modelID INNER JOIN tblMerk ON tblModel.merkID = tblMerk.merkID")
        myCommand.Connection = _myConnection

        Return CType(_f.ReadDataTable(myCommand, dt), Data.DataTable)
    End Function

    Public Function GetDistinctBouwJaar() As Data.DataTable
        Dim myCommand As New SqlCommand("SELECT DISTINCT autoBouwjaar FROM tblAuto")

        myCommand.Connection = _myConnection

        Dim dt As New Data.DataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Data.DataTable)

    End Function

    Public Function GetDistinctAutoKleur() As Data.DataTable
        Dim myCommand As New SqlCommand("SELECT DISTINCT autoKleur FROM tblAuto")

        myCommand.Connection = _myConnection

        Dim dt As New Data.DataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Data.DataTable)

    End Function

End Class
