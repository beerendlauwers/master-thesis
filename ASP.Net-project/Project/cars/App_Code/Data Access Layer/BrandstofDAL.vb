Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class BrandstofDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllBrandstof() As Autos.tblBrandstofDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblBrandstof")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblBrandstofDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblBrandstofDataTable)

    End Function

    Public Function GetBrandstofTypeByID(ByVal autoID As Integer) As Autos.tblBrandstofDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE autoID=@autoID")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblBrandstofDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblBrandstofDataTable)

    End Function

End Class
