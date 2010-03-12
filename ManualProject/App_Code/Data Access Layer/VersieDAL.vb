Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class VersieDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblVersieAdapter As New tblVersieTableAdapter
    Private _myConnection As New SqlConnection(conn)

    Public Function StdAdapter() As tblVersieTableAdapter
        Return _tblVersieAdapter
    End Function

    Public Function GetAllVersie() As tblVersieDataTable
        Dim dt As New tblVersieDataTable

        Dim c As New SqlCommand("Manual_GetAllVersie")
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
