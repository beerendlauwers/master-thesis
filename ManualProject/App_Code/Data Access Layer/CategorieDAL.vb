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
    Private categorie As Categorie

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

    Public Function getHoogte(ByVal categorieID As Integer) As Data.DataTable
        Dim dt As New Data.DataTable



        Dim c As New SqlCommand("Manual_getHoogte")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@categorieID", SqlDbType.Int).Value = categorieID

        c.Connection = _myConnection

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

    Public Function updateHoogte(ByVal hoogte As Integer, ByVal FK_Parent As Integer) As Boolean
        Dim bool As Boolean
        Dim c As New SqlCommand("Manual_updateHoogte")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@FK_parent", SqlDbType.Int).Value = FK_Parent
        c.Parameters.Add("@Hoogte", SqlDbType.Int).Value = hoogte
        Try
            c.Connection.Open()

            bool = c.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        End Try
        Return bool
    End Function

    Public Function getCategorieByID(ByVal categorieID As Integer) As Data.DataTable

        Dim dt As New Data.DataTable



        Dim c As New SqlCommand("Manual_getCategorieByID")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@categorieID", SqlDbType.Int).Value = categorieID

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
        Return dt

    End Function

    Public Function getArtikelsByParent(ByVal parent As Integer) As Data.DataTable

        Dim dt As New Data.DataTable



        Dim c As New SqlCommand("[Manual_GetArtikelsByParent]")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@categorieID", SqlDbType.Int).Value = parent

        c.Connection = _myConnection

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


    Public Function getCategorieByParent(ByVal parent As Integer) As Data.DataTable

        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("Manual_getCategorieByParent")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@FK_Parent", SqlDbType.Int).Value = parent

        c.Connection = _myConnection

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

    Public Function getCategorieZonderRoot() As Data.DataTable

        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("Manual_getCategorieZonderRoot")
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
        Return dt
    End Function

End Class
