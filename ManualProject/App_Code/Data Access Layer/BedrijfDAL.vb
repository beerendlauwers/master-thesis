Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class BedrijfDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblBedrijfAdapter As New tblBedrijfTableAdapter
    Private _myConnection As New SqlConnection(conn)

    Public Function StdAdapter() As tblBedrijfTableAdapter
        Return _tblBedrijfAdapter
    End Function

    Public Function GetAllBedrijf() As tblBedrijfDataTable
        Dim dt As New tblBedrijfDataTable

        Dim c As New SqlCommand("Manual_GetAllBedrijf")
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
