Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class ControleActieDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllActiesByControleID(ByRef controleID As Integer) As Onderhoud.tblControleActieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblControleActie WHERE controleID = @controleID")
        myCommand.Parameters.Add("@controleID", SqlDbType.Int).Value = controleID
        myCommand.Connection = _myConnection

        Dim dt As New Onderhoud.tblControleActieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblControleActieDataTable)

    End Function

    Public Function GetControleActieByControleIDAndActieID(ByVal controleID As Integer, ByVal actieID As Integer) As Onderhoud.tblControleActieRow

        Dim myCommand As New SqlCommand("SELECT * FROM tblControleActie WHERE controleID = @controleID AND actieID = @actieID")
        myCommand.Parameters.Add("@controleID", SqlDbType.Int).Value = controleID
        myCommand.Parameters.Add("@actieID", SqlDbType.Int).Value = actieID
        myCommand.Connection = _myConnection

        Dim dt As New Onderhoud.tblControleActieDataTable
        dt = CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblControleActieDataTable)

        If dt.Rows.Count = 0 Then
            Return Nothing
        Else
            Return dt.Rows(0)
        End If

    End Function

End Class
