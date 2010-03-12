Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class CategorieDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblCategorieAdapter As New tblCategorieTableAdapter
    Private _myConnection As New SqlConnection(conn)

    Public Function StdAdapter() As tblCategorieTableAdapter
        Return _tblCategorieAdapter
    End Function

    ''' <summary>
    ''' Haal alle categorieën op op basis van taal, bedrijf en versie, alsook de root node.
    ''' Is geordend van laag naar hoog.
    ''' </summary>
    Public Function GetAllCategorieBy(ByVal taal As Integer, ByVal bedrijf As Integer, ByVal versie As Integer) As tblCategorieDataTable
        Dim dt As New tblCategorieDataTable

        Dim c As New SqlCommand("Manual_GetAllCategorieBy")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@taal", SqlDbType.Int).Value = taal
        c.Parameters.Add("@bedrijf", SqlDbType.Int).Value = bedrijf
        c.Parameters.Add("@versie", SqlDbType.Int).Value = versie
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
