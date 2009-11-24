Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class KlantDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("ConnectToDatabase").ConnectionString()
    Private myConnection As New SqlConnection(conn)

    Public Function getKlantID(ByVal autoKenteken As String) As Integer
        myConnection.Open()

        Dim myCommand As New SqlCommand("SELECT KlantID FROM tblKlant WHERE KlantBedrijfLocatie=@KlantBedrijfLocatie")
        myCommand.Parameters.Add("@KlantBedrijfLocatie", SqlDbType.NChar)
        myCommand.Parameters("@KlantBedrijfLocatie").Value = autoKenteken
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
