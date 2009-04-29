Imports System.Data.OleDb
Public Class clDataViaAccess

    Private mDatasetAcces As DataSet = New DataSet
    Private mDT_Acces As DataTable = New DataTable
    Private mDV_access As DataView = New DataView
    Private dbConn As String
    Private strsql As String

    Public Sub New()
        'mConnectionString = "Data Source=BEERDUDE-46D334\SQLEXPRESS;Initial Catalog=SPORTIMS2A5;Integrated Security=True"
        'mConnectionString = "Data Source=PC_VAN_FRANK;Initial Catalog=SPORTIMS2A5;Integrated Security=True"
        dbconn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Users\frank\Documents\ADOdbEmailadressen.mdb"
    End Sub

    Public Function f_fill() As Boolean
        Dim myconaccess = New OleDbConnection(dbConn)
        strsql = "select Email from tblEmailAdressen"
        Try
            myconaccess.Open()

        Catch ex As OleDbException
            MessageBox.Show("con mislukt")
            myconaccess.Dispose()
            Return False
        End Try

        Dim myadap As OleDbDataAdapter = New OleDbDataAdapter(strsql, dbConn)
        myadap.Fill(mDatasetAcces, "email")
        mDT_Acces = mDatasetAcces.Tables("employees")
        mDV_access = mDT_Acces.DefaultView
        mDV_access.Sort = "Lastname"
        myconaccess.Close()
        myconaccess.Dispose()
        myadap.Dispose()
        Return True


    End Function

End Class
