Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Manual
Imports ManualTableAdapters

Public Class VersieDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("Reference_manualConnectionString").ConnectionString()
    Private _tblVersieAdapter As New tblVersieTableAdapter

    Public Function StdAdapter() As tblVersieTableAdapter
        Return _tblVersieAdapter
    End Function

    Public Function GetVersieByID(ByVal id As Integer) As tblVersieRow
        Dim dt As New tblVersieDataTable

        Dim c As New SqlCommand("Manual_GetVersieByID")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@id", SqlDbType.Int).Value = id
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
            e.Args.Add("versieID = " & id.ToString)
            Return Nothing
        Finally
            c.Connection.Close()
        End Try


    End Function

    Public Function GetAllVersie() As tblVersieDataTable
        Dim dt As New tblVersieDataTable

        Dim c As New SqlCommand("Manual_GetAllVersie")
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
            Return Nothing
        Finally
            c.Connection.Close()
        End Try
    End Function

    Public Function CheckVersie(ByVal versie As String) As tblVersieDataTable
        Dim dt As New tblVersieDataTable

        Dim c As New SqlCommand("Check_Versie")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@versie", SqlDbType.VarChar).Value = versie
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
            e.Args.Add("versie = " & versie)
            Return Nothing
        Finally
            c.Connection.Close()
        End Try

    End Function

    Public Function CheckVersieByID(ByVal versie As String, ByVal ID As Integer) As tblVersieDataTable
        Dim dt As New tblVersieDataTable

        Dim c As New SqlCommand("Check_VersieByID")
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@versie", SqlDbType.VarChar).Value = versie
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
            e.Args.Add("versie = " & versie)
            e.Args.Add("versieID = " & ID.ToString)
            Return Nothing
        Finally
            c.Connection.Close()
        End Try

    End Function

    Public Function insertVersie(ByVal versie As String) As Integer

        Dim c As New SqlCommand("Manual_InsertVersie", New SqlConnection(conn))
        c.CommandType = CommandType.StoredProcedure
        c.Parameters.Add("@versie", SqlDbType.VarChar).Value = versie

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
            e.Args.Add("versie = " & versie)
            Return Nothing
        Finally
            c.Connection.Close()
        End Try

    End Function

End Class
