Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class BedrijfDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblBedrijfAdapter As New tblBedrijfTableAdapter

    Public Function StdAdapter() As tblBedrijfTableAdapter
        Return _tblBedrijfAdapter
    End Function

    Public Function GetBedrijfByID(ByVal id As Integer) As tblBedrijfRow
        Dim dt As New tblBedrijfDataTable

        Dim c As New SqlCommand("Manual_GetBedrijfByID")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@id", SqlDbType.Int).Value = id
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("id = " & id.ToString)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        If dt.Rows.Count = 0 Then
            Return Nothing
        Else
            Return dt.Rows(0)
        End If
    End Function

    Public Function GetAllBedrijf() As tblBedrijfDataTable
        Dim dt As New tblBedrijfDataTable

        Dim c As New SqlCommand("Manual_GetAllBedrijf")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
            Return dt
        Catch ex As Exception

            Dim e As New ErrorLogger(ex.Message)
            ErrorLogger.WriteError(e)

        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function getBedrijfByNaamOrTag(ByVal naam As String, ByVal tag As String) As Data.DataTable


        Dim dt As New tblBedrijfDataTable

        Dim c As New SqlCommand("Check_getBedrijfByNaam_Tag")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@naam", SqlDbType.VarChar).Value = naam
        c.Parameters.Add("@tag", SqlDbType.VarChar).Value = tag
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

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("naam = " & naam)
            e.Args.Add("tag = " & tag)
            ErrorLogger.WriteError(e)
            Return Nothing
        Finally
            c.Connection.Close()
        End Try

    End Function

    Public Function getBedrijfByNaamTagID(ByVal naam As String, ByVal tag As String, ByVal ID As Integer) As Data.DataTable


        Dim dt As New tblBedrijfDataTable

        Dim c As New SqlCommand("Check_getBedrijfByNaam_Tag_ID")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@naam", SqlDbType.VarChar).Value = naam
        c.Parameters.Add("@tag", SqlDbType.VarChar).Value = tag
        c.Parameters.Add("@ID", SqlDbType.Int).Value = ID
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

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("naam = " & naam)
            e.Args.Add("tag = " & tag)
            e.Args.Add("ID = " & ID.ToString)
            ErrorLogger.WriteError(e)
            Return Nothing
        Finally
            c.Connection.Close()
        End Try

        Return Nothing
    End Function

    Public Function insertBedrijf(ByVal naam As String, ByVal tag As String) As Integer

        Dim c As New SqlCommand("Manual_InsertBedrijf", New SqlConnection(conn))
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@naam", SqlDbType.VarChar).Value = naam
        c.Parameters.Add("@tag", SqlDbType.VarChar).Value = tag

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

            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("naam = " & naam)
            e.Args.Add("tag = " & tag)
            ErrorLogger.WriteError(e)
            Return Nothing
        Finally
            c.Connection.Close()
        End Try

    End Function

End Class
