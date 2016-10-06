Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters



Public Class VideoDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _videoAdapter As New tblVideoTableAdapter

    Public Function StdAdapter() As tblVideoTableAdapter
        Return _videoAdapter
    End Function

    Public Function getVideoByID(ByVal videoID As Integer) As tblVideoRow
        Dim dt As New tblVideoDataTable

        Dim c As New SqlCommand("Manual_getVideoByID")
        c.Parameters.Add("@videoID", SqlDbType.Int).Value = videoID
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then
                dt.Load(r)
                Return dt.Rows(0)
            Else
                Return Nothing
            End If

        Catch ex As Exception
            Throw ex
        Finally
            c.Connection.Close()
        End Try

        Return Nothing
    End Function

    Public Function getVideoByNaam(ByVal videoNaam As String) As tblVideoRow
        Dim dt As New tblVideoDataTable

        Dim c As New SqlCommand("Manual_getVideoByNaam")
        c.Parameters.Add("@videoNaam", SqlDbType.VarChar).Value = videoNaam
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then
                dt.Load(r)
                Return dt.Rows(0)
            Else
                Return Nothing
            End If

        Catch ex As Exception
            Throw ex
        Finally
            c.Connection.Close()
        End Try

        Return Nothing
    End Function

End Class
