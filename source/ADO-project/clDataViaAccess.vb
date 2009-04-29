Imports System.Data.OleDb
Public Class clDataViaAccess

    Private mDatasetAccess As DataSet = New DataSet
    Private mDT_Access As DataTable = New DataTable
    Private mDV_Access As DataView = New DataView
    Private mConnectionString As String
    Private strsql As String

    Public Sub New()
        'mConnectionString = "Data Source=BEERDUDE-46D334\SQLEXPRESS;Initial Catalog=SPORTIMS2A5;Integrated Security=True"
        'mConnectionString = "Data Source=PC_VAN_FRANK;Initial Catalog=SPORTIMS2A5;Integrated Security=True"
        'mConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Users\frank\Documents\ADOdbEmailadressen.mdb"
        mConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\School\Progge 2\ADOPROJECT\database\ADOdbEmailadressen.mdb"
    End Sub

    Public Property p_datatAccess() As DataTable
        Get
            Return mDT_Access
        End Get
        Set(ByVal value As DataTable)
            mDT_Access = value
        End Set
    End Property

    Public Function f_fill() As Boolean
        Dim myconaccess = New OleDbConnection(mConnectionString)
        'Enkel email van tblEmailAdressen = efficiëntie, is nice
        strsql = "SELECT Email FROM tblEmailAdressen"
        Try
            myconaccess.Open()

        Catch ex As OleDbException
            MessageBox.Show("Er is een fout gebeurd tijdens het verbinden met de database.")
            myconaccess.Dispose()
            Return False
        End Try

        Dim myadap As OleDbDataAdapter = New OleDbDataAdapter(strsql, mConnectionString)
        myadap.Fill(mDatasetAccess, "tblEmailAdressen")
        myconaccess.Close()


        mDT_Access = mDatasetAccess.Tables("tblEmailAdressen")
        mDV_Access = mDT_Access.DefaultView
        mDV_Access.Sort = "Email"


        myconaccess.Dispose()
        myadap.Dispose()
        Return True


    End Function

End Class
