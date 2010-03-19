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

    Public Function GetArtikelByID(ByVal ID As Integer) As tblArtikelRow
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_GetArtikelByID")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@id", SqlDbType.Int).Value = ID
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

        If (dt.Rows.Count = 0) Then
            Return Nothing
        Else
            Return dt.Rows(0)
        End If
    End Function

    Public Function GetArtikelByTag(ByVal tag As String) As tblArtikelRow
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

        If (dt.Rows.Count = 0) Then
            Return Nothing
        Else
            Return dt.Rows(0)
        End If
    End Function

    Public Function GetArtikelsByTitel(ByVal titel As String, ByVal versie As Integer, ByVal bedrijf As Integer, ByVal taal As Integer) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_GetArtikelsByTitel_Versie_Bedrijf_Taal")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@titel", SqlDbType.VarChar).Value = titel
        c.Parameters.Add("@versie", SqlDbType.Int).Value = versie
        c.Parameters.Add("@bedrijf", SqlDbType.Int).Value = bedrijf
        c.Parameters.Add("@taal", SqlDbType.Int).Value = taal
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

    Public Function GetArtikelsByTekst(ByVal tekst As String, ByVal versie As Integer, ByVal bedrijf As Integer, ByVal taal As Integer) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_getArtikelByTekst_Versie_Bedrijf_Taal")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@tekst", SqlDbType.NVarChar).Value = tekst
        c.Parameters.Add("@versie", SqlDbType.Int).Value = versie
        c.Parameters.Add("@bedrijf", SqlDbType.Int).Value = bedrijf
        c.Parameters.Add("@taal", SqlDbType.Int).Value = taal
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

    Public Function GetArtikelGegevensByTitel(ByVal titel As String) As DataTable
        Dim dt As New DataTable

        Dim c As New SqlCommand("Manual_GetArtikelGegevensByTitel")
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

    Public Function GetArtikelGegevensByTekst(ByVal tekst As String) As DataTable
        Dim dt As New DataTable

        Dim c As New SqlCommand("Manual_GetArtikelGegevensByTekst")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = _myConnection
        c.Parameters.Add("@tekst", SqlDbType.NVarChar).Value = tekst
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
            Return False
        Finally
            c.Connection.Close()
        End Try

        Return True
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

    Public Function getArtikelsByVersie(ByVal versieID As Integer) As Data.DataTable
        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("Manual_getArtikelsByVersie")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@VersieID", SqlDbType.Int).Value = versieID

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


    Public Function getArtikelsByTaal(ByVal TaalID As Integer) As Data.DataTable
        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("Manual_getArtikelsByTaal")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@TaalID", SqlDbType.Int).Value = TaalID

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

    Public Function getArtikelsByBedrijf(ByVal bedrijfID As Integer) As Data.DataTable
        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("[Manual_getArtikelsByBedrijf]")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@BedrijfID", SqlDbType.Int).Value = bedrijfID

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

    Public Function getArtikelsForSearch(ByVal bedrijfID As Integer, ByVal versieID As Integer, ByVal taalID As Integer, ByVal tag As String) As Data.DataTable
        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("Manual_theUltimateGet")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@BedrijfID", SqlDbType.Int).Value = bedrijfID
        c.Parameters.Add("@versieID", SqlDbType.Int).Value = versieID
        c.Parameters.Add("@TaalID", SqlDbType.Int).Value = taalID
        c.Parameters.Add("@tekst", SqlDbType.VarChar).Value = tag
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
