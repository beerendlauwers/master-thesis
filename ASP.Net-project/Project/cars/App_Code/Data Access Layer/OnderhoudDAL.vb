Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Microsoft.VisualBasic

Public Class OnderhoudDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllNodigOnderhoudByAutoID(ByVal autoID As Integer) As Onderhoud.tblNodigOnderhoudDataTable
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblNodigOnderhoud WHERE autoID = @autoID")
            myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
            myCommand.Connection = _myConnection

            Dim dt As New Onderhoud.tblNodigOnderhoudDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblNodigOnderhoudDataTable)

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllNodigOnderhoudVoorVandaag() As Onderhoud.tblNodigOnderhoudDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblNodigOnderhoud WHERE @now BETWEEN nodigOnderhoudBegindat AND nodigOnderhoudEinddat")
        myCommand.Parameters.Add("@now", SqlDbType.DateTime).Value = Format(Now, "dd/MM/yyyy")
        myCommand.Connection = _myConnection

        Dim dt As New Onderhoud.tblNodigOnderhoudDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblNodigOnderhoudDataTable)

    End Function

    Public Function GetAllToekomstigNodigOnderhoudByAutoID(ByVal autoID As Integer) As Onderhoud.tblNodigOnderhoudDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblNodigOnderhoud WHERE autoID = @autoID AND nodigOnderhoudEinddat >= @now")
        myCommand.Parameters.Add("@now", SqlDbType.DateTime).Value = Format(Now, "dd/MM/yyyy")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Onderhoud.tblNodigOnderhoudDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblNodigOnderhoudDataTable)

    End Function

    Public Function GetNazichtByDatumAndAutoID(ByVal datum As Date, ByVal autoID As Integer) As Onderhoud.tblNodigOnderhoudRow
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblNodigOnderhoud WHERE autoID = @autoID AND nodigOnderhoudBegindat = @datum")
            myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
            myCommand.Parameters.Add("@datum", SqlDbType.DateTime).Value = datum
            myCommand.Connection = _myConnection

            Dim dt As New Onderhoud.tblNodigOnderhoudDataTable
            dt = CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblNodigOnderhoudDataTable)

            If (dt.Rows.Count = 0) Then
                Return Nothing
            Else
                Return dt.Rows(0)
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetControleByReservatieID(ByVal reservatieID As Integer) As Onderhoud.tblControleRow
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblControle WHERE reservatieID = @reservatieID")
            myCommand.Parameters.Add("@reservatieID", SqlDbType.Int).Value = reservatieID
            myCommand.Connection = _myConnection

            Dim dt As New Onderhoud.tblControleDataTable
            dt = CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblControleDataTable)

            If (dt.Rows.Count = 0) Then
                Return Nothing
            Else
                Return dt.Rows(0)
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class

