Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class CategorieDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblCategorieAdapter As New tblCategorieTableAdapter

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

    Public Function getHoogte(ByVal categorieID As Integer, ByVal bedrijfID As Integer, ByVal versieID As Integer, ByVal taalID As Integer) As Integer
        Dim dt As New tblCategorieDataTable

        Dim c As New SqlCommand("Manual_getHoogte")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@categorieID", SqlDbType.Int).Value = categorieID
        c.Parameters.Add("@bedrijfID", SqlDbType.Int).Value = bedrijfID
        c.Parameters.Add("@versieID", SqlDbType.Int).Value = versieID
        c.Parameters.Add("@taalID", SqlDbType.Int).Value = taalID
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then
                dt.Load(r)
                Dim rij As tblCategorieRow = dt.Rows(0)
                Return rij.Hoogte
            Else
                Return Nothing
            End If

        Catch ex As Exception
            Throw ex
            Return Nothing
        Finally
            c.Connection.Close()
        End Try

    End Function

    Public Function updateHoogte(ByVal hoogte As Integer, ByVal FK_Parent As Integer) As Boolean
        Dim bool As Boolean
        Dim c As New SqlCommand("Manual_updateHoogte")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
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

    Public Function getCategorieByID(ByVal categorieID As Integer) As tblCategorieRow

        Dim dt As New tblCategorieDataTable

        Dim c As New SqlCommand("Manual_getCategorieByID")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@categorieID", SqlDbType.Int).Value = categorieID
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

    End Function

    Public Function getArtikelsByParent(ByVal parent As Integer) As tblArtikelDataTable

        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("[Manual_GetArtikelsByParent]")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@categorieID", SqlDbType.Int).Value = parent
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


    Public Function getCategorieByParent(ByVal parent As Integer) As tblCategorieDataTable

        Dim dt As New tblCategorieDataTable

        Dim c As New SqlCommand("Manual_getCategorieByParent")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@FK_Parent", SqlDbType.Int).Value = parent
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

    Public Function checkCategorie(ByVal catnaam As String, ByVal bedrijf As Integer, ByVal versie As Integer) As Data.DataTable

        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("Check_Categorie")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@catnaam", SqlDbType.VarChar).Value = catnaam
        c.Parameters.Add("@bedrijf", SqlDbType.Int).Value = bedrijf
        c.Parameters.Add("@versie", SqlDbType.Int).Value = versie
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

    Public Function getCategorieZonderRoot() As Data.DataTable

        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("Manual_getCategorieZonderRoot")
        c.CommandType = CommandType.StoredProcedure

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
        Return dt
    End Function


    Public Function checkCategorieByID(ByVal catnaam As String, ByVal bedrijf As Integer, ByVal versie As Integer, ByVal Id As Integer) As Data.DataTable

        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("Check_CategorieByID")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@catnaam", SqlDbType.VarChar).Value = catnaam
        c.Parameters.Add("@bedrijf", SqlDbType.Int).Value = bedrijf
        c.Parameters.Add("@versie", SqlDbType.Int).Value = versie
        c.Parameters.Add("@ID", SqlDbType.Int).Value = Id
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

    Public Function insertCategorie(ByRef cat As Categorie) As Integer

        Dim c As New SqlCommand("Manual_InsertCategorie", New SqlConnection(conn))
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@catnaam", SqlDbType.VarChar).Value = cat.Categorie
        c.Parameters.Add("@diepte", SqlDbType.Int).Value = cat.Diepte
        c.Parameters.Add("@hoogte", SqlDbType.Int).Value = cat.Hoogte
        c.Parameters.Add("@FK_parent", SqlDbType.Int).Value = cat.FK_Parent
        c.Parameters.Add("@FK_taal", SqlDbType.Int).Value = cat.FK_Taal
        c.Parameters.Add("@FK_bedrijf", SqlDbType.Int).Value = cat.Bedrijf
        c.Parameters.Add("@FK_versie", SqlDbType.Int).Value = cat.Versie

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then
                r.Read()
                Return Integer.Parse(r(0))
            Else
                Return -1
            End If
        Catch ex As Exception
            Throw ex
        Finally
            c.Connection.Close()
        End Try

    End Function

    Public Function updateCategorie(ByRef c As Categorie) As Boolean
        Return StdAdapter.Update(c.Categorie, c.Diepte, c.Hoogte, c.FK_Parent, c.FK_Taal, c.Bedrijf, c.Versie, c.CategorieID)
    End Function

End Class
