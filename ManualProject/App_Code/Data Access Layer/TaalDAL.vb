Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class TaalDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblTaalAdapter As New tblTaalTableAdapter

    Public Function StdAdapter() As tblTaalTableAdapter
        Return _tblTaalAdapter
    End Function

    Public Function GetTaalByID(ByVal id As Integer) As tblTaalRow
        Dim dt As New tblTaalDataTable

        Dim c As New SqlCommand("Manual_GetTaalByID")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@id", SqlDbType.Int).Value = id
        c.Connection = New SqlConnection(conn)

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
            Return dt.Rows(0)
        End If
    End Function

    Public Function GetAllTaal() As tblTaalDataTable
        Dim dt As New tblTaalDataTable

        Dim c As New SqlCommand("Manual_GetAllTaal")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
            Return dt
        Catch ex As Exception
            Throw ex
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function checkTaal(ByVal taal As String) As tblTaalDataTable
        Dim dt As New tblTaalDataTable

        Dim c As New SqlCommand("Check_Taal")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@taal", SqlDbType.VarChar).Value = taal
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then
                dt.Load(r)
                Return dt
            Else
                Return Nothing
            End If

        Catch ex As Exception
            Throw ex
        Finally
            c.Connection.Close()
        End Try

    End Function

    Public Function checkTaalByID(ByVal taal As String, ByVal ID As Integer) As tblTaalDataTable
        Dim dt As New tblTaalDataTable

        Dim c As New SqlCommand("Check_TaalByID")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@taal", SqlDbType.VarChar).Value = taal
        c.Parameters.Add("@ID", SqlDbType.Int).Value = ID
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then
                dt.Load(r)
                Return dt
            Else
                Return Nothing
            End If

        Catch ex As Exception
            Throw ex
        Finally
            c.Connection.Close()
        End Try

    End Function
End Class
