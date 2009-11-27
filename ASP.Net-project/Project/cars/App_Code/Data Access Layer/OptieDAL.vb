Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class OptieDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllOptie() As Autos.tblOptieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblOptie")
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblOptieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblOptieDataTable)

    End Function

End Class
