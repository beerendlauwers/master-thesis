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

    Public Function GetBrandstofTypeByID(ByVal brandstofID As Integer) As Autos.tblBrandstofDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblBrandstof WHERE brandstofID = @brandstofID")
        myCommand.Parameters.Add("@brandstofID", SqlDbType.Int).Value = brandstofID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblBrandstofDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Autos.tblBrandstofDataTable)

    End Function

    Public Function GetBrandstofByBrandstofID(ByVal brandstofID As Integer) As Autos.tblBrandstofRow

        Dim myCommand As New SqlCommand("SELECT * FROM tblBrandstof WHERE brandstofID = @brandstofID")
        myCommand.Parameters.Add("@brandstofID", SqlDbType.Int).Value = brandstofID
        myCommand.Connection = _myConnection

        Dim dt As New Autos.tblBrandstofDataTable
        dt = CType(_f.ReadDataTable(myCommand, dt), Autos.tblBrandstofDataTable)

        If dt.Rows.Count = 0 Then
            Return Nothing
        Else
            Return dt.Rows(0)
        End If
    End Function

End Class
