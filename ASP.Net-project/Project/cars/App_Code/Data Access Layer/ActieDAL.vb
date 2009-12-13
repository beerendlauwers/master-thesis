Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Microsoft.VisualBasic

Public Class ActieDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetActieByActieID(ByVal actieID As Integer) As Onderhoud.tblActieRow
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblActie WHERE actieID = @actieID")
            myCommand.Parameters.Add("@actieID", SqlDbType.Int).Value = actieID
            myCommand.Connection = _myConnection

            Dim dt As New Onderhoud.tblActieDataTable
            dt = CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblActieDataTable)

            If (dt.Rows.Count = 0) Then
                Return Nothing
            Else
                Return dt.Rows(0)
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllActiesByControleID(ByVal controleID As Integer) As Onderhoud.tblActieDataTable

        Dim myCommand As New SqlCommand("SELECT A.* FROM tblActie A, tblControleActie C WHERE A.actieID = C.actieID AND C.controleID = @controleID")
        myCommand.Parameters.Add("@controleID", SqlDbType.Int).Value = controleID
        myCommand.Connection = _myConnection

        Dim dt As New Onderhoud.tblActieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblActieDataTable)

    End Function

    Public Function GetAllStandaardActies() As Onderhoud.tblActieDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblActie WHERE actieIsStandaard = 1 ORDER BY actieOmschrijving")
        myCommand.Connection = _myConnection

        Dim dt As New Onderhoud.tblActieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblActieDataTable)
    End Function

    Public Function InsertActie(ByRef a As Onderhoud.tblActieRow) As Integer
        Dim myCommand As New SqlCommand("cars_InsertActie")
        myCommand.CommandType = CommandType.StoredProcedure

        myCommand.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.Output
        myCommand.Parameters.Add("@actieIsStandaard", SqlDbType.Int).Value = a.actieIsStandaard
        myCommand.Parameters.Add("@actieOmschrijving", SqlDbType.VarChar).Value = a.actieOmschrijving
        myCommand.Parameters.Add("@actieKost", SqlDbType.Float).Value = a.actieKost
        myCommand.Connection = _myConnection

        myCommand.Connection.Open()
        myCommand.ExecuteNonQuery()
        myCommand.Connection.Close()

        Return myCommand.Parameters(0).Value
    End Function
End Class

