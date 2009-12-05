Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class MerkDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllMerk() As Autos.tblMerkDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblMerk")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblMerkDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblMerkDataTable)
    End Function

    Public Function GetMerkByCategorie(ByVal categorieID As Integer) As Autos.tblMerkDataTable

        Dim myCommand As New SqlCommand("SELECT ME.* FROM tblMerk ME, tblModel MO, tblAuto A WHERE ME.merkID = MO.merkID AND MO.modelID = A.modelID AND A.categorieID = @categorieID")
        myCommand.Parameters.Add("@categorieID", SqlDbType.Int).Value = categorieID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblMerkDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblMerkDataTable)
    End Function

    Public Function GetMerkByMerkID(ByVal merkID As Integer) As Autos.tblMerkDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblMerk WHERE merkID = @merkID")
        myCommand.Parameters.Add("@merkID", SqlDbType.Int).Value = merkID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblMerkDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblMerkDataTable)
    End Function

    Public Function GetMerkByModelID(ByVal modelID As Integer) As Autos.tblMerkDataTable

        Dim myCommand As New SqlCommand("SELECT ME.* FROM tblMerk ME, tblModel MO WHERE ME.merkID = MO.modelID AND MO.modelID = @modelID;")
        myCommand.Parameters.Add("@modelID", SqlDbType.Int).Value = modelID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblMerkDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblMerkDataTable)
    End Function

End Class
