Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class ParkeerDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function UpdateParkeerPlaatsTypeByID(ByVal parkeerplaatsID As Integer, ByVal type As Integer) As Boolean
        Dim myCommand As New SqlCommand("UPDATE tblParkeerPlaats SET parkeerPlaatsType = @type WHERE parkeerPlaatsID = @parkeerplaatsID")
        myCommand.Parameters.Add("@parkeerplaatsID", SqlDbType.Int).Value = parkeerplaatsID
        myCommand.Parameters.Add("@type", SqlDbType.Int).Value = type
        myCommand.Connection = _myConnection

        Return _f.ExecuteNonQuery(myCommand)
    End Function

    Public Function GetParkeerPlaatsenByFiliaalID(ByVal filiaalID As Integer) As Autos.tblParkeerPlaatsDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblParkeerPlaats WHERE filiaalID = @filiaalID")
        myCommand.Parameters.Add("@filiaalID", SqlDbType.Int).Value = filiaalID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblParkeerPlaatsDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblParkeerPlaatsDataTable)

    End Function

    Public Function GetParkeerPlaatsKolommenByFiliaalID(ByVal filiaalID As Integer) As DataTable
        Dim myCommand As New SqlCommand("SELECT DISTINCT parkeerPlaatsKolom FROM tblParkeerPlaats WHERE filiaalID = @filiaalID")
        myCommand.Parameters.Add("@filiaalID", SqlDbType.Int).Value = filiaalID
        myCommand.Connection = _myConnection

        Dim dt As New DataTable
        Return CType(_f.ReadDataTable(myCommand, dt), DataTable)

    End Function

    Public Function GetParkeerPlaatsByRijKolomFiliaalID(ByVal filiaalID As Integer, ByVal rij As Integer, ByVal kolom As Integer) As Autos.tblParkeerPlaatsRow
        Dim myCommand As New SqlCommand("SELECT * FROM tblParkeerPlaats WHERE filiaalID = @filiaalID AND parkeerPlaatsRij = @rij AND parkeerPlaatsKolom = @kolom")
        myCommand.Parameters.Add("@filiaalID", SqlDbType.Int).Value = filiaalID
        myCommand.Parameters.Add("@rij", SqlDbType.Int).Value = rij
        myCommand.Parameters.Add("@kolom", SqlDbType.Int).Value = kolom
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblParkeerPlaatsDataTable
        dt = CType(_f.ReadDataTable(myCommand, dt), Autos.tblParkeerPlaatsDataTable)

        If (dt.Rows.Count = 0) Then
            Return Nothing
        Else
            Return dt.Rows(0)
        End If

    End Function

End Class
