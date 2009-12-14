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

    Public Function GetAllOnbevestigdeReservaties() As Reservaties.tblReservatieDataTable
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE reservatieIsBevestigd = 0")
            myCommand.Connection = _myConnection

            Dim dt As New Reservaties.tblReservatieDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetReservatieByReservatieID(ByVal reservatieID As Integer) As Reservaties.tblReservatieRow
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE reservatieID = @reservatieID")
            myCommand.Parameters.Add("@reservatieID", SqlDbType.Int).Value = reservatieID
            myCommand.Connection = _myConnection

            Dim dt As New Reservaties.tblReservatieDataTable
            dt = CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

            If dt.Rows.Count = 0 Then
                Return Nothing
            Else
                Return dt.Rows(0)
            End If

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

    Public Function GetMeestRecenteReservatieByAutoID(ByVal autoID As Integer) As Reservaties.tblReservatieRow
        Try
            Dim myCommand As New SqlCommand("SELECT TOP 1 * FROM tblReservatie WHERE autoID=@autoID")
            myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
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

    Public Function GetAllBevestigdeReservatiesByUserID(ByVal userID As Guid) As Reservaties.tblReservatieDataTable
        Try

            Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE userID = @userID AND reservatieIsBevestigd = 1")
            myCommand.Parameters.Add("@userID", SqlDbType.UniqueIdentifier).Value = userID
            myCommand.Connection = _myConnection

            Dim dt As New Reservaties.tblReservatieDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllBevestigdeReservatiesByAutoIDAndUserID(ByVal autoID As Integer, ByVal userID As Guid) As Reservaties.tblReservatieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE userID = @userID AND autoID = @autoID AND reservatieIsBevestigd = 1")
        myCommand.Parameters.Add("@userID", SqlDbType.UniqueIdentifier).Value = userID
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Reservaties.tblReservatieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

    End Function

    Public Function GetAllBevestigdeReservatiesByAutoID(ByVal autoID As Integer) As Reservaties.tblReservatieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE autoID = @autoID AND reservatieIsBevestigd = 1")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Reservaties.tblReservatieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

    End Function

    Public Function GetAllBeschikbareReservatiesInMaandByUserID(ByVal userID As Guid, ByVal maand As Date) As Reservaties.tblReservatieDataTable
        Try

            Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE userID = @userID and reservatieStatus = 0 AND reservatieBegindat BETWEEN @maandbegin AND @maandeinde AND reservatieEinddat >= @now")
            myCommand.Parameters.Add("@userID", SqlDbType.UniqueIdentifier).Value = userID
            myCommand.Parameters.Add("@maandbegin", SqlDbType.DateTime).Value = maand
            Dim maandeinde As Date = DateAdd(DateInterval.Day, -1, DateAdd(DateInterval.Month, 1, maand))
            myCommand.Parameters.Add("@maandeinde", SqlDbType.DateTime).Value = maandeinde
            myCommand.Parameters.Add("@now", SqlDbType.DateTime).Value = Now
            myCommand.Connection = _myConnection

            Dim dt As New Reservaties.tblReservatieDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllUitgecheckteReservatiesByAutoIDAndUserID(ByVal autoID As Integer, ByVal userID As Guid) As Reservaties.tblReservatieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE userID = @userID and reservatieStatus = 2 AND autoID = @autoID AND @now >= reservatieBegindat AND @now >= reservatieEinddat")
        myCommand.Parameters.Add("@userID", SqlDbType.UniqueIdentifier).Value = userID
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Parameters.Add("@now", SqlDbType.DateTime).Value = Now
        myCommand.Connection = _myConnection

        Dim dt As New Reservaties.tblReservatieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

    End Function

    Public Function GetAllUitgecheckteReservatiesByUserID(ByVal userID As Guid) As Reservaties.tblReservatieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE userID = @userID and reservatieStatus = 2 AND @now >= reservatieBegindat AND @now >= reservatieEinddat")
        myCommand.Parameters.Add("@userID", SqlDbType.UniqueIdentifier).Value = userID
        myCommand.Parameters.Add("@now", SqlDbType.DateTime).Value = Now
        myCommand.Connection = _myConnection

        Dim dt As New Reservaties.tblReservatieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

    End Function

End Class

