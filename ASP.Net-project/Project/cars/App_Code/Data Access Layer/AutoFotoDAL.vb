Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class AutoFotoDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllAutoFoto() As Autos.tblAutofotoDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoFoto")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutofotoDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutofotoDataTable)

    End Function

    Public Function GetAutoFotoByAutoID(ByVal autoID As Integer) As Autos.tblAutofotoDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoFoto WHERE autoID=@autoID")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutofotoDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutofotoDataTable)

    End Function

    Public Function GetReservatieAutoFotoByAutoID(ByVal autoID As Integer) As Autos.tblAutofotoDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoFoto WHERE autoID = @autoID AND autoFotoVoorReservatie = 1")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutofotoDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutofotoDataTable)

    End Function

End Class
