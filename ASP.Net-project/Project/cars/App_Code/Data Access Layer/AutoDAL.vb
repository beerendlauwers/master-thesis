Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class AutoDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("ConnectToDatabase").ConnectionString()
    Private myConnection As New SqlConnection(conn)

    Public Function GetAutosBy(ByVal filterOpties() As String) As Auto_s.tblAutoDataTable

        'filterOpties expanden
        Dim categorie, kleur, automerk, automodel, brandstoftype, bouwjaar As String
        categorie = filterOpties(0)
        kleur = filterOpties(1)
        automerk = filterOpties(2)
        automodel = filterOpties(3)
        brandstoftype = filterOpties(4)
        bouwjaar = filterOpties(5)

        'query opbouwen
        Dim myCommand As New SqlCommand
        Dim filtercount = 0
        Dim querytext = "SELECT * FROM tblAuto A"

        If (Not automerk = String.Empty) Then
            querytext = String.Concat(querytext, ", tblModel M")
        End If

        If (Not categorie = String.Empty Or Not kleur = String.Empty Or Not automerk = String.Empty _
            Or Not automodel = String.Empty Or Not brandstoftype = String.Empty _
            Or Not bouwjaar = String.Empty) Then
            querytext = String.Concat(querytext, " WHERE ")
        End If

        If (Not categorie = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "categorieID = @categorie")
            myCommand.Parameters.Add("@categorie", SqlDbType.Int)
            myCommand.Parameters("@categorie").Value = categorie
            filtercount = filtercount + 1
        End If

        If (Not automerk = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "M.merkID = @automerk AND A.modelID = M.modelID")
            myCommand.Parameters.Add("@automerk", SqlDbType.Int)
            myCommand.Parameters("@automerk").Value = automerk
            filtercount = filtercount + 1
        End If

        If (Not kleur = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "autoKleur = @autoKleur")
            myCommand.Parameters.Add("@autoKleur", SqlDbType.NChar)
            myCommand.Parameters("@autoKleur").Value = kleur
            filtercount = filtercount + 1
        End If

        If (Not automodel = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "A.modelID = @automodel")
            myCommand.Parameters.Add("@automodel", SqlDbType.Int)
            myCommand.Parameters("@automodel").Value = automodel
            filtercount = filtercount + 1
        End If

        If (Not brandstoftype = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "brandstofID = @brandstoftype")
            myCommand.Parameters.Add("@brandstoftype", SqlDbType.Int)
            myCommand.Parameters("@brandstoftype").Value = brandstoftype
            filtercount = filtercount + 1
        End If

        If (Not bouwjaar = String.Empty) Then
            If (filtercount > 0) Then querytext = String.Concat(querytext, " AND ")

            querytext = String.Concat(querytext, "autoBouwjaar = @bouwjaar")
            myCommand.Parameters.Add("@bouwjaar", SqlDbType.Int)
            myCommand.Parameters("@bouwjaar").Value = bouwjaar
            filtercount = filtercount + 1
        End If

        myCommand.CommandText = querytext
        myCommand.Connection = myConnection

        Dim myReader As SqlDataReader
        myConnection.Open()
        myReader = myCommand.ExecuteReader

        Dim dt As New Auto_s.tblAutoDataTable

        If (myReader.HasRows) Then
            dt.Load(myReader)
        End If

        myConnection.Close() 'close database connectie

        Return dt
    End Function

    Public Function GetKleurenByCategorieID(ByVal categorieID As Integer) As String()
        myConnection.Open()

        Dim myCommand As New SqlCommand("SELECT DISTINCT autoKleur FROM tblAuto WHERE categorieID = @categorieID")
        myCommand.Parameters.Add("@categorieID", SqlDbType.Int)
        myCommand.Parameters("@categorieID").Value = categorieID
        myCommand.Connection = myConnection

        Dim myReader As SqlDataReader
        myReader = myCommand.ExecuteReader

        Dim kleuren(128) As String
        Dim i As Integer = 0
        For i = 0 To 127
            kleuren(i) = String.Empty
        Next
        If (myReader.HasRows) Then
            i = 0
            While myReader.Read
                kleuren(i) = myReader.Item(0).ToString
                i = i + 1
            End While
        End If

        myConnection.Close() 'close database connectie

        Return kleuren
    End Function

    Public Function getAutoID(ByVal autoKenteken As String) As Integer
        myConnection.Open()

        Dim myCommand As New SqlCommand("SELECT autoID FROM tblAuto WHERE autoKenteken=@autoKenteken")
        myCommand.Parameters.Add("@autoKenteken", SqlDbType.NChar)
        myCommand.Parameters("@autoKenteken").Value = autoKenteken
        myCommand.Connection = myConnection

        Try
            Dim myReader As SqlDataReader
            myReader = myCommand.ExecuteReader

            If (myReader.HasRows) Then
                myReader.Read()
                Return CType(myReader.Item("autoID"), Integer)
            Else
                Return -1
            End If
        Catch ex As Exception
            Throw ex
        Finally
            myConnection.Close()
        End Try

    End Function

    Public Function InsertFoto(ByVal autoID As Integer, ByVal naam As String, ByVal type As String, ByVal foto As Byte()) As Boolean
        Dim myCommand As New SqlCommand("INSERT INTO tblAutoFoto(AutoID, autoFoto, autoFotoContentType, autoFotoNaam) VALUES( @autoID, @foto, @contentType, @naam)")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Parameters.Add("@naam", SqlDbType.NChar).Value = naam
        myCommand.Parameters.Add("@contentType", SqlDbType.NChar).Value = type
        myCommand.Parameters.Add("@foto", SqlDbType.Binary).Value = foto
        myCommand.Connection = myConnection

        Try
            myConnection.Open()
            myCommand.ExecuteNonQuery()
            Return True
        Catch ex As Exception
            Throw ex
            Return False
        Finally
            myConnection.Close()
        End Try

    End Function

End Class
