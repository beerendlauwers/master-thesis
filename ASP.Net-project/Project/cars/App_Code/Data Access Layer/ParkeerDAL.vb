Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class ParkeerDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetParkeerPlaatsenByFiliaalID(ByVal filiaalID As Integer) As Autos.tblParkeerPlaatsDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblParkeerPlaats WHERE filiaalID = @filiaalID")
        myCommand.Parameters.Add("@filiaalID", SqlDbType.Int).Value = filiaalID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblParkeerPlaatsDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblParkeerPlaatsDataTable)

    End Function

End Class
