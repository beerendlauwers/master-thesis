Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class CategorieDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllCategories() As Autos.tblCategorieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblCategorie")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblCategorieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblCategorieDataTable)

    End Function

    Public Function GetCategorieByID(ByVal categorieID As Integer) As Autos.tblCategorieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblCategorie WHERE categorieID = @categorieID")
        myCommand.Parameters.Add("@categorieID", SqlDbType.Int).Value = categorieID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblCategorieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblCategorieDataTable)

    End Function

End Class
