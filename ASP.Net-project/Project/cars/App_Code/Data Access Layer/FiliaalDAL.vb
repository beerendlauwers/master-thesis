Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class FiliaalDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllFiliaal() As Autos.tblFiliaalDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblFiliaal")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblFiliaalDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblFiliaalDataTable)

    End Function

    Public Function GetFiliaalByID(ByVal filiaalID As Integer) As Autos.tblFiliaalDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE filiaalID=@filiaalID")
        myCommand.Parameters.Add("@filiaalID", SqlDbType.Int).Value = filiaalID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblFiliaalDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblFiliaalDataTable)

    End Function

End Class
