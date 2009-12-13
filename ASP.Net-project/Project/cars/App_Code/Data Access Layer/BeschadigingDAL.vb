Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class BeschadigingDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetBeschadigingByBeschadigingID(ByVal beschadigingID As Integer) As Onderhoud.tblAutoBeschadigingRow

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoBeschadiging WHERE autoBeschadigingID = @beschadigingID")
        myCommand.Parameters.Add("@beschadigingID", SqlDbType.Int).Value = beschadigingID
        myCommand.Connection = _myConnection

        Dim dt As New Onderhoud.tblAutoBeschadigingDataTable
        dt = CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblAutoBeschadigingDataTable)

        If dt.Rows.Count = 0 Then
            Return Nothing
        Else
            Return dt.Rows(0)
        End If

    End Function

    Public Function GetAllBeschadigingByAutoID(ByVal autoID As Integer) As Onderhoud.tblAutoBeschadigingDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblAutoBeschadiging WHERE autoID = @autoID")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Onderhoud.tblAutoBeschadigingDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblAutoBeschadigingDataTable)

    End Function

    Public Function InsertBeschadiging(ByRef b As Onderhoud.tblAutoBeschadigingRow) As Integer
        Dim myCommand As New SqlCommand("cars_InsertBeschadiging")
        myCommand.CommandType = CommandType.StoredProcedure

        myCommand.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.Output
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = b.autoID
        myCommand.Parameters.Add("@beschadigingAangerichtDoorKlant", SqlDbType.UniqueIdentifier).Value = b.beschadigingAangerichtDoorKlant
        myCommand.Parameters.Add("@beschadigingDatum", SqlDbType.DateTime).Value = b.beschadigingDatum
        myCommand.Parameters.Add("@beschadigingKost", SqlDbType.Float).Value = b.beschadigingKost
        myCommand.Parameters.Add("@beschadigingIsHersteld", SqlDbType.Int).Value = b.beschadigingIsHersteld
        myCommand.Parameters.Add("@beschadigingIsDoorverrekend", SqlDbType.Int).Value = b.beschadigingIsDoorverrekend
        myCommand.Parameters.Add("@beschadigingOmschrijving", SqlDbType.Text).Value = b.beschadigingOmschrijving
        myCommand.Parameters.Add("@controleID", SqlDbType.Int).Value = b.controleID
        myCommand.Connection = _myConnection

        myCommand.Connection.Open()
        myCommand.ExecuteNonQuery()
        myCommand.Connection.Close()

        Return myCommand.Parameters(0).Value

    End Function
End Class
