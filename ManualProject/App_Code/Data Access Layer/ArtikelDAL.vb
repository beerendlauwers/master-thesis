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

    ''' <summary>
    ''' Haal alle artikels op die onder een bepaalde categorie staan.
    ''' </summary>
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

    Public Function GetArtikelByTag(ByVal tag As String) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_GetArtikelByTag")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@tag", SqlDbType.VarChar).Value = tag
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

    Public Function GetArtikelsByTitel(ByVal titel As String) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_getArtikelsByTitel")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@titel", SqlDbType.VarChar).Value = titel
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

    Public Function GetArtikelsByTekst(ByVal tekst As String) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_getArtikelByTekst")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@tekst", SqlDbType.VarChar).Value = tekst
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

    Public Function verwijderArtikel(ByVal artikelID As Integer) As Boolean

        Dim c As New SqlCommand("Manual_deleteArtikelbyID")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@artikelID", SqlDbType.Int).Value = artikelID
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
        Catch ex As Exception
            Throw ex
        Finally
            c.Connection.Close()
        End Try
    End Function

    Public Function updateArtikel(ByVal artikel As Artikel) As Boolean
        Dim bool As Boolean
        Dim c As New SqlCommand("Manual_updateArtikel")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@artikelID", SqlDbType.Int).Value = artikel.ID
        c.Parameters.Add("@Titel", SqlDbType.VarChar).Value = artikel.Titel
        c.Parameters.Add("@FK_Categorie", SqlDbType.Int).Value = artikel.Categorie
        c.Parameters.Add("@FK_Taal", SqlDbType.Int).Value = artikel.taal
        c.Parameters.Add("@FK_Bedrijf", SqlDbType.Int).Value = artikel.Bedrijf
        c.Parameters.Add("@FK_Versie", SqlDbType.Int).Value = artikel.Versie
        c.Parameters.Add("@Tekst", SqlDbType.NVarChar).Value = artikel.Tekst
        c.Parameters.Add("@tag", SqlDbType.VarChar).Value = artikel.Tag
        c.Parameters.Add("@Is_final", SqlDbType.Int).Value = artikel.IsFinal

        Try
            c.Connection.Open()

            bool = c.ExecuteNonQuery()


        Catch ex As Exception
            Throw ex

        End Try
        Return Bool

    End Function

End Class
