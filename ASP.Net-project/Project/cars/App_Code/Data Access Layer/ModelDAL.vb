Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class ModelDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllModel() As Autos.tblModelDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblModel")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblModelDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblModelDataTable)

    End Function

    Public Function GetModelByMerkID(ByVal merkID As Integer) As Autos.tblModelDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblModel WHERE merkID = @merkID")
        myCommand.Parameters.Add("@merkID", SqlDbType.Int).Value = merkID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblModelDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblModelDataTable)

    End Function

    Public Function GetModelNaamByModelID(ByVal modelID As Integer) As String

        Dim myCommand As New SqlCommand("SELECT modelNaam FROM tblModel WHERE modelID = @modelID")
        myCommand.Parameters.Add("@modelID", SqlDbType.Int).Value = modelID
        myCommand.Connection = _myConnection

        Return CType(_f.ReadSingleItem(myCommand, "modelNaam"), String)

    End Function

End Class
