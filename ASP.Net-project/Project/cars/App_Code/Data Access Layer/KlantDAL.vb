Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager

Public Class KlantDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetUserProfielByUserID(ByVal userID As Guid) As Klanten.tblUserProfielDataTable
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblUserProfiel WHERE userID = @userID")
            myCommand.Parameters.Add("@userID", SqlDbType.UniqueIdentifier).Value = userID
            myCommand.Connection = _myConnection

            Dim dt As New Klanten.tblUserProfielDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Klanten.tblUserProfielDataTable)

        Catch ex As Exception
            Throw ex
        Finally
            _myConnection.Close()
        End Try
    End Function

End Class
