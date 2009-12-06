Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class StatusDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllStatus() As Autos.tblAutostatusDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoStatus")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutostatusDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutostatusDataTable)

    End Function

    Public Function GetStatusByStatusNaam(ByVal naam As String) As Autos.tblAutostatusDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoStatus WHERE autostatusNaam = @naam")
        myCommand.Parameters.Add("@naam", SqlDbType.NChar).Value = naam
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutostatusDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutostatusDataTable)

    End Function
End Class
