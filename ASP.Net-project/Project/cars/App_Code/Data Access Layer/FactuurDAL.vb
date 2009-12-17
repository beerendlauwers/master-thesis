Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class FactuurDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetAllFacturenInWacht() As Reservaties.tblReservatieDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE factuurIsInWacht = 1")
        myCommand.Connection = _myConnection

        Dim dt As New Reservaties.tblReservatieDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblReservatieDataTable)

    End Function


    Public Function GetAllFactuurLijnenByReservatieID(ByVal reservatieID As Integer) As Reservaties.tblFactuurlijnDataTable

        Dim myCommand As New SqlCommand("SELECT * FROM tblFactuurLijn WHERE reservatieID = @reservatieID")
        myCommand.Parameters.Add("@reservatieID", SqlDbType.Int).Value = reservatieID
        myCommand.Connection = _myConnection

        Dim dt As New Reservaties.tblFactuurlijnDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Reservaties.tblFactuurlijnDataTable)

    End Function

End Class
