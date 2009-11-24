Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class KlantDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("ConnectToDatabase").ConnectionString()
    Private myConnection As New SqlConnection(conn)

    Public Function getKlantID(ByVal bedrijfNaam As String) As Integer
        myConnection.Open()

        Dim myCommand As New SqlCommand("SELECT KlantID FROM tblKlant WHERE klantBedrijfNaam=@KlantBedrijfNaam")
        myCommand.Parameters.Add("@KlantBedrijfNaam", SqlDbType.NChar)
        myCommand.Parameters("@KlantBedrijfNaam").Value = bedrijfNaam
        myCommand.Connection = myConnection

        Dim myReader As SqlDataReader
        myReader = myCommand.ExecuteReader

        If (myReader.HasRows) Then
            myReader.Read()
            Return CType(myReader.Item("KlantID"), Integer)
        Else
            Return -1
        End If

    End Function

    Public Function getKlantIDByNaam(ByVal naam As String) As Integer
        myConnection.Open()

        Dim myCommand As New SqlCommand("SELECT KlantID FROM tblKlant WHERE klantGebruikersnaam=@naam")
        myCommand.Parameters.Add("@naam", SqlDbType.NChar)
        myCommand.Parameters("@naam").Value = naam
        myCommand.Connection = myConnection

        Dim myReader As SqlDataReader
        myReader = myCommand.ExecuteReader

        If (myReader.HasRows) Then
            myReader.Read()
            Return CType(myReader.Item("KlantID"), Integer)
        Else
            Return -1
        End If

    End Function

End Class
