Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters



Public Class VideoDal
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _videoAdapter As New tblVideoTableAdapter

    Public Function getVideoByID(ByVal videoID As Integer) As tblVideoDataTable
        Dim dt As New tblVideoDataTable

        Dim c As New SqlCommand("Manual_getVideoByID")
        c.Parameters.Add("@videoID", SqlDbType.Int).Value = videoID
        c.CommandType = CommandType.StoredProcedure

        c.Connection = _myConnection

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception
            Throw ex
        Finally
            c.Connection.Close()
        End Try

        If dt.Rows.Count = 0 Then
            Return Nothing
        Else
            Return dt
        End If
    End Function

    Public Function getVideoByNaam(ByVal videoNaam As String) As tblVideoDataTable
        Dim dt As New tblVideoDataTable

        Dim c As New SqlCommand("Manual_getVideoByNaam")
        c.Parameters.Add("@videoNaam", SqlDbType.VarChar).Value = videoNaam
        c.CommandType = CommandType.StoredProcedure

        c.Connection = _myConnection

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then
                dt.Load(r)
            Else
                Return Nothing
            End If

        Catch ex As Exception
            Throw ex
        Finally
            c.Connection.Close()
        End Try

        If dt.Rows.Count = 0 Then
            Return Nothing
        Else
            Return dt
        End If
    End Function

End Class
