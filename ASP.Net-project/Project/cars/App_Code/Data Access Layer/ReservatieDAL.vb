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

    Public Function GetReservatieByReservatieID(ByVal reservatieID As Integer) As Reservaties.tblReservatieDataTable
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE reservatieID = @reservatieID")
            myCommand.Parameters.Add("@reservatieID", SqlDbType.Int).Value = reservatieID
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

    Public Function GetSpecificReservatieByDatumAndAutoID(ByRef r As Reservatie) As Reservaties.tblReservatieRow
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE autoID=@autoID AND reservatieBegindat = @begindat AND reservatieEinddat = @einddat")
            myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = r.AutoID
            myCommand.Parameters.Add("@begindat", SqlDbType.DateTime).Value = r.Begindatum
            myCommand.Parameters.Add("@einddat", SqlDbType.DateTime).Value = r.Einddatum
            myCommand.Connection = _myConnection

            Dim dt As New Reservaties.tblReservatieDataTable
            dt = CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

            If (dt.Rows.Count = 0) Then
                Return Nothing
            Else
                Return dt.Rows(0)
            End If

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

