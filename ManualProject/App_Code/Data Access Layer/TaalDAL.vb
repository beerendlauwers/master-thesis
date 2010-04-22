Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class TaalDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblTaalAdapter As New tblTaalTableAdapter

    Public Function StdAdapter() As tblTaalTableAdapter
        Return _tblTaalAdapter
    End Function

    Public Function GetTaalByID(ByVal id As Integer) As tblTaalRow
        Dim dt As New tblTaalDataTable

        Dim c As New SqlCommand("Manual_GetTaalByID")
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
            e.Args.Add("taalID = " & id)
        Finally
            c.Connection.Close()
        End Try

        If dt.Rows.Count = 0 Then
            Return Nothing
        Else
            Return dt.Rows(0)
        End If
    End Function

    Public Function GetAllTaal() As tblTaalDataTable
        Dim dt As New tblTaalDataTable

        Dim c As New SqlCommand("Manual_GetAllTaal")
        c.CommandType = CommandType.StoredProcedure
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function checkTaal(ByVal taal As String, ByVal taaltag As String) As tblTaalDataTable
        Dim dt As New tblTaalDataTable

        Dim c As New SqlCommand("Check_Taal")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@taal", SqlDbType.VarChar).Value = taal
        c.Parameters.Add("@taaltag", SqlDbType.VarChar).Value = taaltag
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("taal = " & taal)
            e.Args.Add("taaltag = " & taaltag)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function checkTaalByID(ByVal taal As String, ByVal taaltag As String, ByVal ID As Integer) As tblTaalDataTable
        Dim dt As New tblTaalDataTable

        Dim c As New SqlCommand("Check_TaalByID")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@taal", SqlDbType.VarChar).Value = taal
        c.Parameters.Add("@taaltag", SqlDbType.VarChar).Value = taaltag
        c.Parameters.Add("@ID", SqlDbType.Int).Value = ID
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("taal = " & taal)
            e.Args.Add("taaltag = " & taaltag)
            e.Args.Add("taalID = " & ID.ToString)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function insertTaal(ByVal taal As String, ByVal taaltag As String) As Integer

        Dim c As New SqlCommand("Manual_InsertTaal", New SqlConnection(conn))
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@taal", SqlDbType.VarChar).Value = taal
        c.Parameters.Add("@taaltag", SqlDbType.VarChar).Value = taaltag
        c.CommandTimeout = 300

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
            e.Args.Add("taal = " & taal)
            e.Args.Add("taaltag = " & taaltag)
            Return -1
        Finally
            c.Connection.Close()
        End Try

    End Function

    Public Function getVglTalen(ByVal text As String) As Data.DataTable
        Dim dt As New Data.DataTable
        Dim c As New SqlCommand(text)
        c.CommandType = CommandType.Text
        c.Connection = New SqlConnection(conn)
        Try
            Dim r As SqlDataReader
            c.Connection.Open()
            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("query = " & text)
        Finally
            c.Connection.Close()
        End Try

        Return dt
    End Function

    Public Function updateTagTalen(ByVal oudetag As String, ByVal nieuweTag As String) As Integer

        Dim c As New SqlCommand("Manual_UpdateTagTalen")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@OudeTag", SqlDbType.VarChar).Value = oudetag
        c.Parameters.Add("@NieuweTag", SqlDbType.VarChar).Value = nieuweTag
        c.Connection = New SqlConnection(conn)
        Dim i As Integer
        Try
            c.Connection.Open()
            i = c.ExecuteNonQuery
            Return i
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("Oude_tag = " & oudetag)
            e.Args.Add("Nieuwe_tag = " & nieuweTag)
            Return -1
        Finally
            c.Connection.Close()
        End Try

    End Function

    Public Function getTaalByNaam(ByVal taal As String) As tblTaalRow
        Dim dt As New tblTaalDataTable

        Dim c As New SqlCommand("Manual_getTaalByNaam")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@Taal", SqlDbType.VarChar).Value = taal
        c.Connection = New SqlConnection(conn)

        Try
            Dim r As SqlDataReader
            c.Connection.Open()

            r = c.ExecuteReader
            If (r.HasRows) Then dt.Load(r)
            If dt.Rows.Count = 0 Then
                Return Nothing
            Else
                Return dt.Rows(0)
            End If
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("taal = " & taal)
            Return Nothing
        Finally
            c.Connection.Close()
        End Try


    End Function
End Class
