Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class ArtikelDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblCategorieAdapter As New tblCategorieTableAdapter
    Private _myConnection As New SqlConnection(conn)

    Public Function getArtikelsByTitel(ByVal titel As String) As Manual.tblArtikelDataTable
        Dim dt As Manual.tblArtikelDataTable

        Dim c As New SqlCommand("")
        c.CommandType = CommandType.Text
        c.Connection = _myConnection
        c.Parameters.Add("@titel", SqlDbType.VarChar).Value = titel
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch

        End Try

        Return dt
    End Function
End Class
