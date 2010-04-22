Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class ArtikelDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()

    Public Function StdAdapter() As tblArtikelTableAdapter
        Return New tblArtikelTableAdapter
    End Function

    ''' <summary>
    ''' Haal alle artikels op die onder een bepaalde categorie staan.
    ''' </summary>
    Public Function GetArtikelsByParent(ByVal categorieID As Integer) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_GetArtikelsByParent")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@categorieID", SqlDbType.VarChar).Value = categorieID

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("categorieID = " & categorieID.ToString)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function GetArtikelByID(ByVal ID As Integer) As tblArtikelRow
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_GetArtikelByID")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@id", SqlDbType.Int).Value = ID
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("ID = " & ID.ToString)
            ErrorLogger.WriteError(e)

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
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@tag", SqlDbType.VarChar).Value = tag
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("tag = " & tag)
            ErrorLogger.WriteError(e)

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
        c.Connection = New SqlConnection(conn)
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

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("titel = " & titel)
            e.Args.Add("versie = " & versie.ToString)
            e.Args.Add("bedrijf = " & bedrijf.ToString)
            e.Args.Add("taal = " & taal.ToString)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function GetArtikelsByTitel(ByVal titel As String) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_getArtikelsByTitel")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@titel", SqlDbType.VarChar).Value = titel
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("titel = " & titel)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function GetArtikelsByTekst(ByVal tekst As String, ByVal versie As Integer, ByVal bedrijf As Integer, ByVal taal As Integer) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_getArtikelByTekst_Versie_Bedrijf_Taal")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
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

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("tekst = " & tekst)
            e.Args.Add("versie = " & versie.ToString)
            e.Args.Add("bedrijf = " & bedrijf.ToString)
            e.Args.Add("taal = " & taal.ToString)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function GetArtikelsByTekst(ByVal tekst As String) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable

        Dim c As New SqlCommand("Manual_getArtikelByTekst")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@tekst", SqlDbType.VarChar).Value = tekst
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("tekst = " & tekst)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function GetArtikelGegevensByTitel(ByVal titel As String, ByVal isfinal As String, ByVal versies As String, ByVal bedrijven As String, ByVal talen As String) As DataTable
        Dim dt As New DataTable

        Dim c As New SqlCommand("Manual_GetArtikelGegevensByTitel")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@titel", SqlDbType.VarChar).Value = titel
        c.Parameters.Add("@versies", SqlDbType.VarChar).Value = versies
        c.Parameters.Add("@bedrijven", SqlDbType.VarChar).Value = bedrijven
        c.Parameters.Add("@talen", SqlDbType.VarChar).Value = talen
        c.Parameters.Add("@isfinal", SqlDbType.VarChar).Value = isfinal
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("titel = " & titel)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function GetArtikelGegevensByTag(ByVal tag As String, ByVal isfinal As String, ByVal versies As String, ByVal bedrijven As String, ByVal talen As String) As DataTable
        Dim dt As New DataTable

        Dim c As New SqlCommand("Manual_GetArtikelGegevensByTag")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@tag", SqlDbType.VarChar).Value = tag
        c.Parameters.Add("@versies", SqlDbType.VarChar).Value = versies
        c.Parameters.Add("@bedrijven", SqlDbType.VarChar).Value = bedrijven
        c.Parameters.Add("@talen", SqlDbType.VarChar).Value = talen
        c.Parameters.Add("@isfinal", SqlDbType.VarChar).Value = isfinal
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("titel = " & tag)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function GetArtikelGegevensByTekst(ByVal tekst As String, ByVal isfinal As String, ByVal versies As String, ByVal bedrijven As String, ByVal talen As String) As DataTable
        Dim dt As New DataTable

        Dim c As New SqlCommand("Manual_GetArtikelGegevensByTekst")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@tekst", SqlDbType.NVarChar).Value = tekst
        c.Parameters.Add("@versies", SqlDbType.VarChar).Value = versies
        c.Parameters.Add("@bedrijven", SqlDbType.VarChar).Value = bedrijven
        c.Parameters.Add("@talen", SqlDbType.VarChar).Value = talen
        c.Parameters.Add("@isfinal", SqlDbType.VarChar).Value = isfinal
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("tekst = " & tekst)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function verwijderArtikel(ByVal artikelID As Integer) As Integer

        Dim c As New SqlCommand("Manual_deleteArtikelbyID")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@artikelID", SqlDbType.Int).Value = artikelID
        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("artikelID = " & artikelID.ToString)
            ErrorLogger.WriteError(e)
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
        c.Connection = New SqlConnection(conn)
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

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("artikel.ID = " & artikel.ID.ToString)
            e.Args.Add("artikel.Titel = " & artikel.Titel)
            e.Args.Add("artikel.Categorie = " & artikel.Categorie)
            e.Args.Add("artikel.taal = " & artikel.Taal.ToString)
            e.Args.Add("artikel.Bedrijf = " & artikel.Bedrijf.ToString)
            e.Args.Add("artikel.Versie = " & artikel.Versie.ToString)
            e.Args.Add("artikel.Tekst = " & artikel.Tekst)
            e.Args.Add("artikel.Tag = " & artikel.Tag)
            e.Args.Add("artikel.IsFinal = " & artikel.IsFinal.ToString)
            ErrorLogger.WriteError(e)

        End Try
        Return bool

    End Function

    Public Function getArtikelsByVersie(ByVal versieID As Integer) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable
        Dim c As New SqlCommand("Manual_getArtikelsByVersie")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@VersieID", SqlDbType.Int).Value = versieID
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("versieID = " & versieID.ToString)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function


    Public Function getArtikelsByTaal(ByVal TaalID As Integer) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable
        Dim c As New SqlCommand("Manual_getArtikelsByTaal")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@TaalID", SqlDbType.Int).Value = TaalID
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("TaalID = " & TaalID.ToString)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function getArtikelsByBedrijf(ByVal bedrijfID As Integer) As tblBedrijfDataTable
        Dim dt As New tblBedrijfDataTable
        Dim c As New SqlCommand("[Manual_getArtikelsByBedrijf]")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@BedrijfID", SqlDbType.Int).Value = bedrijfID
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("bedrijfID = " & bedrijfID.ToString)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function getArtikelsForSearch(ByVal bedrijfID As Integer, ByVal versieID As Integer, ByVal taalID As Integer, ByVal tag As String) As Data.DataTable
        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("Manual_theUltimateGet")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@BedrijfID", SqlDbType.Int).Value = bedrijfID
        c.Parameters.Add("@versieID", SqlDbType.Int).Value = versieID
        c.Parameters.Add("@TaalID", SqlDbType.Int).Value = taalID
        c.Parameters.Add("@tekst", SqlDbType.VarChar).Value = tag
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("tag = " & tag)
            e.Args.Add("versieID = " & versieID.ToString)
            e.Args.Add("taalID = " & taalID.ToString)
            e.Args.Add("bedrijfID = " & bedrijfID.ToString)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try
        Return dt
    End Function

    Public Function checkArtikelByTitel(ByVal titel As String, ByVal bedrijf As Integer, ByVal versie As Integer, ByVal taal As Integer) As tblArtikelDataTable

        Dim dt As New tblArtikelDataTable
        Dim c As New SqlCommand("Check_Artikel")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@titel", SqlDbType.VarChar).Value = titel
        c.Parameters.Add("@bedrijf", SqlDbType.Int).Value = bedrijf
        c.Parameters.Add("@versie", SqlDbType.Int).Value = versie
        c.Parameters.Add("@taal", SqlDbType.Int).Value = taal
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("titel = " & titel)
            e.Args.Add("versie = " & versie.ToString)
            e.Args.Add("bedrijf = " & bedrijf.ToString)
            e.Args.Add("taal = " & taal.ToString)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try
        Return dt
    End Function

    Public Function checkArtikelByTitelEnID(ByVal titel As String, ByVal bedrijf As Integer, ByVal versie As Integer, ByVal taal As Integer, ByVal id As Integer) As tblArtikelDataTable

        Dim dt As New tblArtikelDataTable
        Dim c As New SqlCommand("Check_ArtikelByID")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@titel", SqlDbType.VarChar).Value = titel
        c.Parameters.Add("@bedrijf", SqlDbType.Int).Value = bedrijf
        c.Parameters.Add("@versie", SqlDbType.Int).Value = versie
        c.Parameters.Add("@taal", SqlDbType.Int).Value = versie
        c.Parameters.Add("@ID", SqlDbType.Int).Value = id
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("titel = " & titel)
            e.Args.Add("versie = " & versie.ToString)
            e.Args.Add("bedrijf = " & bedrijf.ToString)
            e.Args.Add("taal = " & taal.ToString)
            e.Args.Add("id = " & id.ToString)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function checkArtikelByTag(ByVal tag As String, ByVal bedrijf As Integer, ByVal versie As Integer, ByVal taal As Integer, ByVal id As Integer) As tblArtikelDataTable

        Dim dt As New tblArtikelDataTable
        Dim c As New SqlCommand("Check_Artikel")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@tag", SqlDbType.VarChar).Value = tag
        c.Parameters.Add("@bedrijf", SqlDbType.Int).Value = bedrijf
        c.Parameters.Add("@versie", SqlDbType.Int).Value = versie
        c.Parameters.Add("@taal", SqlDbType.Int).Value = versie
        c.Parameters.Add("@id", SqlDbType.Int).Value = id
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("tag = " & tag)
            e.Args.Add("versie = " & versie.ToString)
            e.Args.Add("bedrijf = " & bedrijf.ToString)
            e.Args.Add("taal = " & taal.ToString)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function getArtikelsByTitelTaalVersieBedrijf(ByVal bedrijfID As Integer, ByVal versieID As Integer, ByVal taalID As Integer, ByVal titel As String) As Data.DataTable
        Dim dt As New Data.DataTable
        Dim c As New SqlCommand("Manual_GetArtikelsByTitel_Versie_Bedrijf_Taal")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@BedrijfID", SqlDbType.Int).Value = bedrijfID
        c.Parameters.Add("@versieID", SqlDbType.Int).Value = versieID
        c.Parameters.Add("@TaalID", SqlDbType.Int).Value = taalID
        c.Parameters.Add("@titel", SqlDbType.VarChar).Value = titel
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("Titel = " & titel)
            e.Args.Add("versie = " & versieID.ToString)
            e.Args.Add("bedrijf = " & bedrijfID.ToString)
            e.Args.Add("taal = " & taalID.ToString)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function
    Public Function updateTagAlleTalen(ByVal nieuweTag As String, ByVal oudetag As String) As Integer
        Dim x As Integer
        Dim c As New SqlCommand("Manual_GetArtikelsByTitel_Versie_Bedrijf_Taal")
        c.CommandType = CommandType.StoredProcedure

        c.Parameters.Add("@NieuweTag", SqlDbType.VarChar).Value = nieuweTag
        c.Parameters.Add("@OudeTag", SqlDbType.VarChar).Value = oudetag
        c.Connection = New SqlConnection(conn)
        Try
            c.Connection.Open()
            x = c.ExecuteNonQuery()
        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("Nieuwe tag = " & nieuweTag)
            e.Args.Add("Oude tag = " & oudetag)
            ErrorLogger.WriteError(e)
            Return -1
        End Try
        Return x
    End Function

    Public Function getTitelByTag(ByVal tag As String) As String
        Dim titel As String = String.Empty
        Dim c As New SqlCommand("Manual_getTitelByTag")
        Dim dt As New tblArtikelDataTable
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@Tag", SqlDbType.VarChar).Value = tag
        c.Connection = New SqlConnection(conn)
        Try
            c.Connection.Open()
            titel = Convert.ToString(c.ExecuteScalar)
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("tag = " & tag)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try

        Return titel
    End Function

    Public Function getArtikelTekst(ByVal Zoekterm As String, ByVal tag As String) As String
        Dim tekst As String = String.Empty
        Dim c As New SqlCommand("Manual_getArtikelTekst")
        Dim dt As New tblArtikelDataTable
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@tag", SqlDbType.VarChar).Value = tag
        c.Parameters.Add("@Zoekterm", SqlDbType.VarChar).Value = Zoekterm
        c.Connection = New SqlConnection(conn)
        Try
            c.Connection.Open()
            tekst = Convert.ToString(c.ExecuteScalar)
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("zoekterm = " & Zoekterm)
            e.Args.Add("tag = " & tag)
            ErrorLogger.WriteError(e)
            Return Nothing
        Finally
            c.Connection.Close()
        End Try

        Return tekst
    End Function
    Public Function getArtikelsByModule(ByVal modul As String) As tblModuleDataTable
        Dim dt As New tblModuleDataTable

        Dim c As New SqlCommand("Manual_getArtikelsByModule")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@module", SqlDbType.VarChar).Value = modul
        c.Connection = New SqlConnection(conn)
        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("module = " & modul)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function
End Class
