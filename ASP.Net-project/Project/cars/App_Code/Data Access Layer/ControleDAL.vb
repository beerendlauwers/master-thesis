Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration.ConfigurationManager
Imports Microsoft.VisualBasic

Public Class ControleDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

    Public Function GetControleByReservatieID(ByVal reservatieID As Integer) As Onderhoud.tblControleRow
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblControle WHERE reservatieID = @reservatieID")
            myCommand.Parameters.Add("@reservatieID", SqlDbType.Int).Value = reservatieID
            myCommand.Connection = _myConnection

            Dim dt As New Onderhoud.tblControleDataTable
            dt = CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblControleDataTable)

            If (dt.Rows.Count = 0) Then
                Return Nothing
            Else
                Return dt.Rows(0)
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetControleByControleID(ByVal controleID As Integer) As Onderhoud.tblControleRow
        Try
            Dim myCommand As New SqlCommand("SELECT * FROM tblControle WHERE controleID = @controleID")
            myCommand.Parameters.Add("@controleID", SqlDbType.Int).Value = controleID
            myCommand.Connection = _myConnection

            Dim dt As New Onderhoud.tblControleDataTable
            dt = CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblControleDataTable)

            If (dt.Rows.Count = 0) Then
                Return Nothing
            Else
                Return dt.Rows(0)
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllOudeControlesByAutoID(ByVal autoID As Integer) As Onderhoud.tblControleDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblControle WHERE autoID = @autoID AND controleIsUitgevoerd = 1")
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = autoID
        myCommand.Parameters.Add("@now", SqlDbType.DateTime).Value = Format(Now, "dd/MM/yyyy")
        myCommand.Connection = _myConnection

        Dim dt As New Onderhoud.tblControleDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblControleDataTable)

    End Function

    Public Function GetAllOudeControles() As Onderhoud.tblControleDataTable
        Dim myCommand As New SqlCommand("SELECT * FROM tblControle WHERE @now >= controleEinddat AND controleIsUitgevoerd = 0")
        myCommand.Parameters.Add("@now", SqlDbType.DateTime).Value = Format(DateAdd(DateInterval.Day, -3, Now), "dd/MM/yyyy")
        myCommand.Connection = _myConnection

        Dim dt As New Onderhoud.tblControleDataTable
        Return CType(_f.ReadDataTable(myCommand, dt), Onderhoud.tblControleDataTable)

    End Function

    Public Function InsertNieuweControle(ByRef c As Onderhoud.tblControleRow) As Integer
        Dim myCommand As New SqlCommand("cars_InsertNieuweGeplandeControle")
        myCommand.CommandType = CommandType.StoredProcedure

        myCommand.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.Output
        myCommand.Parameters.Add("@medewerkerID", SqlDbType.UniqueIdentifier).Value = c.medewerkerID
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = c.autoID
        myCommand.Parameters.Add("@controleBegindat", SqlDbType.DateTime).Value = c.controleBegindat
        myCommand.Parameters.Add("@controleEinddat", SqlDbType.DateTime).Value = c.controleEinddat
        myCommand.Parameters.Add("@controleIsNazicht", SqlDbType.Bit).Value = c.controleIsNazicht
        myCommand.Parameters.Add("@controleIsUitgevoerd", SqlDbType.Int).Value = c.controleIsUitgevoerd
        myCommand.Parameters.Add("@controleKilometerstand", SqlDbType.Int).Value = c.controleKilometerstand
        myCommand.Parameters.Add("@controleBrandstofkost", SqlDbType.Int).Value = c.controleBrandstofkost

        myCommand.Connection = _myConnection

        myCommand.Connection.Open()
        myCommand.ExecuteNonQuery()
        myCommand.Connection.Close()

        Return myCommand.Parameters(0).Value

    End Function

    Public Function InsertNieuwNazicht(ByRef c As Onderhoud.tblControleRow) As Integer
        Dim myCommand As New SqlCommand("cars_InsertNieuweControle")
        myCommand.CommandType = CommandType.StoredProcedure

        myCommand.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.Output
        myCommand.Parameters.Add("@medewerkerID", SqlDbType.UniqueIdentifier).Value = c.medewerkerID
        myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = c.autoID
        myCommand.Parameters.Add("@reservatieID", SqlDbType.Int).Value = c.reservatieID
        myCommand.Parameters.Add("@controleBegindat", SqlDbType.DateTime).Value = c.controleBegindat
        myCommand.Parameters.Add("@controleEinddat", SqlDbType.DateTime).Value = c.controleEinddat
        myCommand.Parameters.Add("@controleIsNazicht", SqlDbType.Bit).Value = c.controleIsNazicht
        myCommand.Parameters.Add("@controleIsUitgevoerd", SqlDbType.Bit).Value = c.controleIsUitgevoerd
        myCommand.Parameters.Add("@controleKilometerstand", SqlDbType.Int).Value = c.controleKilometerstand
        myCommand.Parameters.Add("@controleBrandstofkost", SqlDbType.Int).Value = c.controleBrandstofkost

        myCommand.Connection = _myConnection

        myCommand.Connection.Open()
        myCommand.ExecuteNonQuery()
        myCommand.Connection.Close()

        Return myCommand.Parameters(0).Value

    End Function

End Class

