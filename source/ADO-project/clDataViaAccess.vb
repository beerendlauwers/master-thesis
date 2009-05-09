Imports System.Data.OleDb
Public Class clDataViaAccess

    Private mDatasetAccess As DataSet = New DataSet
    Private mDT_Access As DataTable = New DataTable
    Private mDV_Access As DataView = New DataView
    Private mConnectionString As String
    Private mSQLString As String

    Public Property p_datatAccess() As DataTable
        Get
            Return mDT_Access
        End Get
        Set(ByVal value As DataTable)
            mDT_Access = value
        End Set
    End Property

    Public Property p_mConnectionString() As String
        Get
            Return mConnectionString
        End Get
        Set(ByVal value As String)
            mConnectionString = value
        End Set
    End Property

    Public Property p_mSQLString() As String
        Get
            Return mSQLString
        End Get
        Set(ByVal value As String)
            mSQLString = value
        End Set
    End Property

    Public Function f_fill() As Boolean
        Dim AccessConnection As OleDbConnection = New OleDbConnection(mConnectionString)
        Try
            AccessConnection.Open()

        Catch ex As OleDbException
            MessageBox.Show("Er is een fout gebeurd tijdens het verbinden met de database.")
            AccessConnection.Dispose()
            Return False
        End Try

        Try

            Dim AccessAdapter As OleDbDataAdapter = New OleDbDataAdapter(mSQLString, mConnectionString)
            AccessAdapter.Fill(mDatasetAccess, "tblEmailAdressen")
            AccessConnection.Close()

            mDT_Access = mDatasetAccess.Tables("tblEmailAdressen")
            mDV_Access = mDT_Access.DefaultView
            mDV_Access.Sort = "Email"


            AccessConnection.Dispose()
            AccessAdapter.Dispose()
            Return True

        Catch ex As Exception
            MessageBox.Show("Er is een fout gebeurd tijdens het ophalen van de gegevens. Details: " & ex.Message)
            AccessConnection.Dispose()
            Return False
        End Try


    End Function

    Public Function f_TestAccess(ByVal AccessBestand As String, ByVal AccessTabel As String, ByVal AccessKolom As String) As Boolean
        'Deze functie test snel de connectie met een Access-database.

        'Connectiestring opstellen.
        Dim connectiestring As String = String.Concat("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=", AccessBestand)

        'OleDBconnection opstellen.
        Dim Accessconnection = New OleDbConnection(connectiestring)

        'We selecteren 1 row uit de gewenste tabel en kolom als test.
        Dim AccessTestString As String = String.Concat("SELECT TOP 1 ", AccessKolom, " FROM ", AccessTabel)

        Try
            Accessconnection.Open()

            Dim AccessAdapter As OleDbDataAdapter = New OleDbDataAdapter(AccessTestString, connectiestring)
            Dim testset As DataSet = New DataSet

            'We vullen een testdataset met deze ene row als test.
            AccessAdapter.Fill(testset, AccessTabel)

            Accessconnection.Close()
            AccessAdapter.Dispose()
        Catch ex As OleDbException
            Accessconnection.Dispose()
            Return False
        End Try

        Accessconnection.Dispose()
        Return True
    End Function
End Class
