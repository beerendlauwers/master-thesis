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

    Public Function GetOptieByNaam(ByVal naam As String) As Autos.tblOptieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblOptie WHERE optieOmschrijving LIKE @naam ")
        myCommand.Parameters.Add("@naam", SqlDbType.Text).Value = naam
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblOptieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblOptieDataTable)

    End Function
End Class
