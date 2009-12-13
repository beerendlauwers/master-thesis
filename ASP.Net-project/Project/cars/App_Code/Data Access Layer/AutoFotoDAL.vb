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

    Public Function InsertAutoFoto(ByRef f As Autos.tblAutofotoRow) As Integer

        Dim myCommand As New SqlCommand("INSERT INTO tblAutoFoto(autoID,autoFoto, autoFotoDatum, autoFotoVoorReservatie, autoFotoType) VALUES(@autoID, @autoFoto, @autoFotoDatum, @autoFotoVoorReservatie, @autoFotoType)")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = f.autoID
        myCommand.Parameters.Add("@autoFoto", SqlDbType.Image).Value = f.autoFoto
        myCommand.Parameters.Add("@autoFotoDatum", SqlDbType.DateTime).Value = f.autoFotoDatum
        myCommand.Parameters.Add("@autoFotoVoorReservatie", SqlDbType.Int).Value = f.autoFotoVoorReservatie
        myCommand.Parameters.Add("@autoFotoType", SqlDbType.NChar).Value = f.autoFotoType
        myCommand.Connection = _myConnection

        Return CType(_f.ExecuteScalar(myCommand), Integer)

    End Function

    Public Function InsertBeschadigingAutoFoto(ByRef f As Autos.tblAutofotoRow) As Boolean

        Dim myCommand As New SqlCommand("cars_InsertBeschadigingFoto")
        myCommand.CommandType = CommandType.StoredProcedure

        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = f.autoID
        myCommand.Parameters.Add("@beschadigingID", SqlDbType.Int).Value = f.beschadigingID
        myCommand.Parameters.Add("@autoFoto", SqlDbType.Image).Value = f.autoFoto
        myCommand.Parameters.Add("@autoFotoDatum", SqlDbType.DateTime).Value = f.autoFotoDatum
        myCommand.Parameters.Add("@autoFotoVoorReservatie", SqlDbType.Int).Value = f.autoFotoVoorReservatie
        myCommand.Parameters.Add("@autoFotoType", SqlDbType.NChar).Value = f.autoFotoType
        myCommand.Connection = _myConnection

        Return _f.ExecuteNonQuery(myCommand)
    End Function

    Public Function GetAutoFotoByAutoID(ByVal autoID As Integer) As Autos.tblAutofotoDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoFoto WHERE autoID=@autoID")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutofotoDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutofotoDataTable)

    End Function

    Public Function GetAutoFotoByBeschadigingID(ByVal beschadigingID As Integer) As Autos.tblAutofotoRow

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoFoto WHERE beschadigingID = @beschadigingID")
        myCommand.Parameters.Add("@beschadigingID", SqlDbType.Int).Value = beschadigingID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutofotoDataTable
        dt = CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutofotoDataTable)

        If dt.Rows.Count = 0 Then
            Return Nothing
        Else
            Return dt.Rows(0)
        End If
    End Function

    Public Function GetReservatieAutoFotoByAutoID(ByVal autoID As Integer) As Autos.tblAutofotoDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoFoto WHERE autoID = @autoID AND autoFotoVoorReservatie = 1")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblAutofotoDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblAutofotoDataTable)

    End Function

End Class
