Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class AutoStatusDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllAutoStatus() As Autos.tblAutostatusDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoStatus")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutostatusDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutostatusDataTable)

    End Function

    Public Function GetAutoStatusByID(ByVal autoStatusID As Integer) As Autos.tblAutostatusDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoStatus WHERE autoStatusID=@autoStatusID")
        myCommand.Parameters.Add("@autoStatusID", SqlDbType.Int).Value = autoStatusID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutostatusDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutostatusDataTable)

    End Function

    Public Function GetAutoStatusToewijsbaarBijMaken() As Autos.tblAutostatusDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoStatus WHERE autoStatusToewijsbaarBijMaken = 1")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutostatusDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutostatusDataTable)

    End Function

End Class
