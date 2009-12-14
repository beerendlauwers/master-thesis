Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager

Public Class KlantDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetUserProfielByUserID(ByVal userID As Guid) As Klanten.tblUserProfielDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblUserProfiel WHERE userID = @userID")
        myCommand.Parameters.Add("@userID", SqlDbType.UniqueIdentifier).Value = userID
        myCommand.Connection = _myConnection

        Dim dt As New Klanten.tblUserProfielDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Klanten.tblUserProfielDataTable)
    End Function

    Public Function GetUserProfielByNaamEnVoornaam(ByVal naam As String, ByVal voornaam As String) As Klanten.tblUserProfielDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblUserProfiel WHERE userNaam = @naam AND userVoornaam = @voornaam")
        myCommand.Parameters.Add("@naam", SqlDbType.NChar).Value = naam
        myCommand.Parameters.Add("@voornaam", SqlDbType.NChar).Value = voornaam
        myCommand.Connection = _myConnection

        Dim dt As New Klanten.tblUserProfielDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Klanten.tblUserProfielDataTable)
    End Function

    Public Function GetUserProfielByRijbewijs(ByVal rijbewijs As String) As Klanten.tblUserProfielDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblUserProfiel WHERE userRijbewijsnr = @rijbewijs")
        myCommand.Parameters.Add("@rijbewijs", SqlDbType.NChar).Value = rijbewijs
        myCommand.Connection = _myConnection

        Dim dt As New Klanten.tblUserProfielDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Klanten.tblUserProfielDataTable)
    End Function

    Public Function GetUserProfielByIdentiteitskaartNr(ByVal identiteitskaartnr As String) As Klanten.tblUserProfielDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblUserProfiel WHERE userIdentiteitskaartnr = @identiteitskaartnr")
        myCommand.Parameters.Add("@identiteitskaartnr", SqlDbType.NChar).Value = identiteitskaartnr
        myCommand.Connection = _myConnection

        Dim dt As New Klanten.tblUserProfielDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Klanten.tblUserProfielDataTable)
    End Function

    Public Function UpdateUserByID(ByVal dr As Klanten.tblUserProfielRow) As Boolean

        Dim myCommand As New SqlCommand("UPDATE tblUserProfiel SET userVoornaam=@userVoornaam, userNaam=@userNaam, userGeboortedatum=@userGeboortedatum, userIdentiteitskaartnr=@userIdentiteitskaartnr, userRijbewijsnr=@userRijbewijsnr, userTelefoon=@userTelefoon, userBedrijfNaam=@userBedrijfnaam, userBedrijfVestigingslocatie=@userBedrijfVestigingslocatie, userBTWnummer=@userBTWnummer WHERE userID=@userID")
        myCommand.Parameters.Add("@userID", SqlDbType.UniqueIdentifier).Value = dr.userID
        myCommand.Parameters.Add("@uservoornaam", SqlDbType.NVarChar).Value = dr.userVoornaam
        myCommand.Parameters.Add("@userNaam", SqlDbType.NVarChar).Value = dr.userNaam
        myCommand.Parameters.Add("@userGeboortedatum", SqlDbType.DateTime).Value = dr.userGeboortedatum
        myCommand.Parameters.Add("@userIdentiteitskaartnr", SqlDbType.NVarChar).Value = dr.userIdentiteitskaartnr
        myCommand.Parameters.Add("@userRijbewijsnr", SqlDbType.NVarChar).Value = dr.userRijbewijsnr
        myCommand.Parameters.Add("@userTelefoon", SqlDbType.NVarChar).Value = dr.userTelefoon
        myCommand.Parameters.Add("@userBedrijfnaam", SqlDbType.NVarChar).Value = dr.userBedrijfnaam
        myCommand.Parameters.Add("@userBedrijfVestigingslocatie", SqlDbType.NVarChar).Value = dr.userBedrijfVestigingslocatie
        myCommand.Parameters.Add("@userBTWnummer", SqlDbType.NVarChar).Value = dr.userBTWnummer
        myCommand.Connection = _myConnection
        Try
            _myConnection.Open()
            Return myCommand.ExecuteNonQuery()

        Catch ex As Exception
            Throw ex
            Return 0
        Finally
            _myConnection.Close()
        End Try
    End Function

End Class
