Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class ModuleDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()

    Public Function StdAdapter() As tblModuleTableAdapter
        Return New tblModuleTableAdapter
    End Function

    Public Function GetModuleByID(ByVal id As Integer) As tblModuleRow
        Dim dt As New tblModuleDataTable

        Dim c As New SqlCommand("Manual_GetModuleByID")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@id", SqlDbType.Int).Value = id
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("id = " & id)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        If dt.Count = 0 Then
            Return Nothing
        Else
            Return dt.Rows(0)
        End If
    End Function

    Public Function checkModuleByNaam(ByVal naam As String) As tblModuleDataTable
        Dim dt As New tblModuleDataTable

        Dim c As New SqlCommand("Check_Module")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@module", SqlDbType.VarChar).Value = naam
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("module = " & naam)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function checkModuleByNaamEnID(ByVal naam As String, ByVal id As Integer) As tblModuleDataTable
        Dim dt As New tblModuleDataTable

        Dim c As New SqlCommand("Check_ModuleByID")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)
        c.Parameters.Add("@module", SqlDbType.VarChar).Value = naam
        c.Parameters.Add("@id", SqlDbType.Int).Value = id
        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("module = " & naam)
            e.Args.Add("id = " & id)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function
    Public Function GetModulesMetArtikels(ByVal FK_taal As Integer, ByVal FK_Versie As Integer, ByVal FK_Bedrijf As Integer) As DataTable

        Dim c As New SqlCommand("Manual_getModulesMetArtikels")
        Dim dt As New DataTable
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@FK_taal", SqlDbType.VarChar).Value = FK_taal
        c.Parameters.Add("@FK_Versie", SqlDbType.VarChar).Value = FK_Versie
        c.Parameters.Add("@FK_Bedrijf", SqlDbType.VarChar).Value = FK_Bedrijf
        c.Connection = New SqlConnection(conn)
        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("FK_taal = " & FK_taal.ToString)
            e.Args.Add("FK_Versie = " & FK_Versie.ToString)
            e.Args.Add("FK_Bedrijf = " & FK_Bedrijf.ToString)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try
        Return dt
    End Function

    Public Function checkArtikelsByModule(ByVal moduleID As Integer) As tblArtikelDataTable
        Dim dt As New tblArtikelDataTable
        Dim c As New SqlCommand("Check_ArtikelsbyModule")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@ModuleID", SqlDbType.Int).Value = moduleID
        c.Connection = New SqlConnection(conn)
        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("moduleID = " & moduleID.ToString)
        Finally
            c.Connection.Close()
        End Try
        Return dt
    End Function

    Public Function GetAllModules() As tblModuleDataTable
        Dim dt As New tblModuleDataTable

        Dim c As New SqlCommand("Manual_getAllModules")
        c.Connection = New SqlConnection(conn)
        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)

        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            ErrorLogger.WriteError(e)
        Finally
            c.Connection.Close()
        End Try
        Return dt
    End Function

End Class
