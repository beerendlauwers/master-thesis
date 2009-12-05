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
        Dim categorie, kleur, automerk, automodel, brandstoftype, bouwjaar As String
        categorie = filterOpties(0)
        kleur = filterOpties(1)
        automerk = filterOpties(2)
        automodel = filterOpties(3)
        brandstoftype = filterOpties(4)
        bouwjaar = filterOpties(5)

        'query opbouwen
        Dim myCommand As New SqlCommand
        Dim filtercount As Integer = 0
        Dim querytext As String = "SELECT * FROM tblAuto A"

        If (Not automerk = String.Empty) Then
            querytext = String.Concat(querytext, ", tblModel M")
        End If

        If (Not categorie = String.Empty Or Not kleur = String.Empty Or Not automerk = String.Empty _
            Or Not automodel = String.Empty Or Not brandstoftype = String.Empty _
            Or Not bouwjaar = String.Empty) Then
            querytext = String.Concat(querytext, " WHERE ")
        End If

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

        If (Not automodel = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "A.modelID = @automodel")
            myCommand.Parameters.Add("@automodel", SqlDbType.Int).Value = automodel
            filtercount = filtercount + 1
        End If

        If (Not brandstoftype = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "brandstofID = @brandstoftype")
            myCommand.Parameters.Add("@brandstoftype", SqlDbType.Int).Value = brandstoftype
            filtercount = filtercount + 1
        End If

        If (Not bouwjaar = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "autoBouwjaar = @bouwjaar")
            myCommand.Parameters.Add("@bouwjaar", SqlDbType.Int).Value = bouwjaar
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

End Class
