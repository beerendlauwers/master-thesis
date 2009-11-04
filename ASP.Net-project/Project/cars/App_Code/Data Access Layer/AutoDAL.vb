Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class AutoDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("ConnectToDatabase").ConnectionString()
    Private myConnection As New SqlConnection(conn)

    'Public Function GetAutosBy(ByVal filterOpties() As String) As Auto_s.tblAutoDataTable
    'Filteropties expanden
    'Dim kleur, automerk, automodel, brandstoftype, bouwjaar As String




    '    myConnection.Open()

    'Dim myCommand As New SqlCommand("SELECT DISTINCT autoKleur FROM tblAuto WHERE categorieID = @categorieID")
    '    myCommand.Parameters.Add("@categorieID", SqlDbType.Int)
    'myCommand.Parameters("@categorieID").Value = categorieID
    '    myCommand.Connection = myConnection

    'Dim myReader As SqlDataReader
    '    myReader = myCommand.ExecuteReader

    'Dim kleuren(128) As String
    'Dim i As Integer = 0
    '    For i = 0 To 127
    '        kleuren(i) = String.Empty
    '    Next
    '    If (myReader.HasRows) Then
    '       i = 0
    '       While myReader.Read
    '            kleuren(i) = myReader.Item(0).ToString
    '            i = i + 1
    '        End While
    '    End If

    '    myConnection.Close() 'close database connectie

    '     Return kleuren
    'End Function

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

End Class
