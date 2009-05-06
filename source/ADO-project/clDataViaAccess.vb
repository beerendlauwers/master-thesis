Imports System.Data.OleDb
Public Class clDataViaAccess

    Private mDatasetAccess As DataSet = New DataSet
    Private mDT_Access As DataTable = New DataTable
    Private mDV_Access As DataView = New DataView
    Private mConnectionString As String
    Private mSQLString As String

    Public Sub New()
        'mConnectionString = "Data Source=BEERDUDE-46D334\SQLEXPRESS;Initial Catalog=SPORTIMS2A5;Integrated Security=True"
        'mConnectionString = "Data Source=PC_VAN_FRANK;Initial Catalog=SPORTIMS2A5;Integrated Security=True"
        'mConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Users\frank\Documents\ADOdbEmailadressen.mdb"
        'mConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\School\Progge 2\ADOPROJECT\database\ADOdbEmailadressen.mdb"
    End Sub

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
        Dim AccessConnection = New OleDbConnection(mConnectionString)
        Try
            AccessConnection.Open()

        Catch ex As OleDbException
            MessageBox.Show("Er is een fout gebeurd tijdens het verbinden met de database.")
            AccessConnection.Dispose()
            Return False
        End Try

        Dim myadap As OleDbDataAdapter = New OleDbDataAdapter(mSQLString, mConnectionString)
        myadap.Fill(mDatasetAccess, "tblEmailAdressen")
        AccessConnection.Close()


        mDT_Access = mDatasetAccess.Tables("tblEmailAdressen")
        mDV_Access = mDT_Access.DefaultView
        mDV_Access.Sort = "Email"


        AccessConnection.Dispose()
        myadap.Dispose()
        Return True


    End Function

    Public Function f_TestAccess(ByVal AccessBestand As String, ByVal AccessTabel As String, ByVal AccessKolom As String) As Boolean
        Dim connectiestring As String = String.Concat("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=", AccessBestand)
        Dim Accessconnection = New OleDbConnection(connectiestring)
        Dim AccessTestString As String = String.Concat("SELECT TOP 1 ", AccessKolom, " FROM ", AccessTabel)

        Try
            Accessconnection.Open()
        Catch ex As OleDbException
            MessageBox.Show("Er is een fout gebeurd tijdens het verbinden met de Access-database.")
            Accessconnection.Dispose()
            Return False
        End Try

        Try
            Dim AccessAdapter As OleDbDataAdapter = New OleDbDataAdapter(AccessTestString, connectiestring)
            Dim testset As DataSet = New DataSet
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
