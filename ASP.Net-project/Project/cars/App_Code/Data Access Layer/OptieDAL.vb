Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class OptieDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllOptie() As Autos.tblOptieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblOptie")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblOptieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblOptieDataTable)

    End Function

    Public Function GetAllOptiesByAutoID(ByVal autoID As Integer) As Autos.tblOptieDataTable

        Dim myCommand As New SqlCommand("SELECT O.* FROM tblOptie O, tblAutoOptie AO, tblAuto A WHERE A.autoID = @autoID And A.autoID = AO.autoID AND AO.optieID = O.optieID;")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblOptieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblOptieDataTable)

    End Function

    Public Function GetBeschikbareOptiesBy(ByRef filterOpties() As String) As Autos.tblOptieDataTable

        'filterOpties expanden
        Dim categorie, kleur, automerk, automodel, brandstoftype As String
        categorie = filterOpties(0)
        kleur = filterOpties(1)
        automerk = filterOpties(2)
        automodel = filterOpties(3)
        brandstoftype = filterOpties(4)

        Dim myCommand As New SqlCommand
        Dim querytext As String = "SELECT O.* FROM tblOptie O, tblAutoOptie AO, tblAuto A"
        Dim filtercount As Integer = 1

        If (Not automerk = String.Empty) Then
            querytext = String.Concat(querytext, ", tblModel M")
        End If

        querytext = String.Concat(querytext, " WHERE A.statusID = 1 AND A.autoID = AO.autoID AND AO.optieID = O.optieID")

        If (Not categorie = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "A.categorieID = @categorie")
            myCommand.Parameters.Add("@categorie", SqlDbType.Int).Value = categorie
            filtercount = filtercount + 1
        End If

        If (Not kleur = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "A.autoKleur = @autoKleur")
            myCommand.Parameters.Add("@autoKleur", SqlDbType.NChar).Value = kleur
            filtercount = filtercount + 1
        End If

        If (Not automerk = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "M.merkID = @automerk AND A.modelID = M.modelID")
            myCommand.Parameters.Add("@automerk", SqlDbType.Int).Value = automerk
            filtercount = filtercount + 1
        End If

        myCommand.CommandText = querytext
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblOptieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblOptieDataTable)

    End Function

    Public Function GetOptieByNaam(ByVal naam As String) As Autos.tblOptieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblOptie WHERE optieOmschrijving LIKE @naam ")
        myCommand.Parameters.Add("@naam", SqlDbType.Text).Value = naam
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblOptieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblOptieDataTable)

    End Function
End Class
