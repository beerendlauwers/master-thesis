Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Microsoft.VisualBasic


Public Class ChauffeurDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions


    Public Function GetChauffeurByChauffeurID(ByVal chauffeurId As Integer) As Klanten.tblChauffeurDataTable
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblChauffeur WHERE chauffeurID = @chauffeurID")
            myCommand.Parameters.Add("@chauffeurID", SqlDbType.Int).Value = chauffeurId
            myCommand.Connection = _myConnection

            Dim dt As New Klanten.tblChauffeurDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Klanten.tblChauffeurDataTable)

        Catch ex As Exception
            Throw ex
        Finally
            _myConnection.Close()
        End Try
    End Function

    Public Function GetChauffeursByUserID(ByVal userID As Guid) As Klanten.tblChauffeurDataTable
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblChauffeur WHERE userID = @UserID")
            myCommand.Parameters.Add("@userID", SqlDbType.UniqueIdentifier).Value = userID
            myCommand.Connection = _myConnection

            Dim dt As New Klanten.tblChauffeurDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Klanten.tblChauffeurDataTable)

        Catch ex As Exception
            Throw ex
        Finally
            _myConnection.Close()
        End Try
    End Function

    Public Function UpdateChauffeur(ByVal dr As Klanten.tblChauffeurRow) As Klanten.tblChauffeurDataTable
        Try
            Dim myCommand As New SqlCommand("UPDATE tblChauffeur SET chauffeurNaam=@chauffeurNaam, chauffeurVoornaam=@chauffeurVoornaam, chauffeurRijbewijs=@chauffeurRijbewijs WHERE chauffeurID=@chauffeurID")

            myCommand.Parameters.Add("@chauffeurID", SqlDbType.Int).Value = dr.chauffeurID
            myCommand.Parameters.Add("@chauffeurNaam", SqlDbType.NVarChar).Value = dr.chauffeurNaam
            myCommand.Parameters.Add("@chauffeurVoornaam", SqlDbType.NVarChar).Value = dr.chauffeurVoornaam
            myCommand.Parameters.Add("@chauffeurRijbewijs", SqlDbType.NVarChar).Value = dr.chauffeurRijbewijs
            myCommand.Connection = _myConnection

            Dim dt As New Klanten.tblChauffeurDataTable
            Return CType(_f.ReadDataTable(myCommand, dt), Klanten.tblChauffeurDataTable)

        Catch ex As Exception
            Throw ex
        Finally
            _myConnection.Close()
        End Try
    End Function
End Class

