Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class TaalDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblTaalAdapter As New tblTaalTableAdapter
    Private _myConnection As New SqlConnection(conn)

    Public Function StdAdapter() As tblTaalTableAdapter
        Return _tblTaalAdapter
    End Function

    Public Function GetAllTaal() As tblTaalDataTable
        Dim dt As New tblTaalDataTable

        Dim c As New SqlCommand("Manual_GetAllTaal")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection

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
End Class
