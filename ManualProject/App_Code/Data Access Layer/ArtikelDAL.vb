Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class ArtikelDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblArtikelAdapter As New tblArtikelTableAdapter
    Private _myConnection As New SqlConnection(conn)

    Public Function GetArtikelsByParent(ByVal categorieID As Integer) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_GetArtikelsByParent")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@categorieID", SqlDbType.VarChar).Value = categorieID

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

    Public Function GetArtikelsByTitel(ByVal titel As String) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

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
