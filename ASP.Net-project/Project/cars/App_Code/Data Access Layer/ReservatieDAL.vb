Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class ReservatieDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllReservaties() As Reservaties.tblReservatieDataTable
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie")
            myCommand.Connection = _myConnection

            Dim dt As New Reservaties.tblReservatieDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllReservatiesByAutoID(ByVal autoID As Integer) As Reservaties.tblReservatieDataTable
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE autoID=@autoID")
            myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
            myCommand.Connection = _myConnection

            Dim dt As New Reservaties.tblReservatieDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllReservatiesByUserID(ByVal userID As Guid) As Reservaties.tblReservatieDataTable
        Try

            Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE userID = @userID")
            myCommand.Parameters.Add("@userID", SqlDbType.UniqueIdentifier).Value = userID
            myCommand.Connection = _myConnection

            Dim dt As New Reservaties.tblReservatieDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class

