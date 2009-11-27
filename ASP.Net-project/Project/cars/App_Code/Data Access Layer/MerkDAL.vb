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

        Dim myCommand As New SqlCommand("SELECT * FROM tblMerk ME, tblModel MO, tblAuto A WHERE ME.merkID = MO.merkID AND MO.modelID = A.modelID AND A.categorieID = @categorieID")
        myCommand.Parameters.Add("@categorieID", SqlDbType.Int).Value = categorieID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblMerkDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblMerkDataTable)
    End Function

End Class
