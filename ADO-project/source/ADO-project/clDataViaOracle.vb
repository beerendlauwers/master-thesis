Imports System.Data.OleDb

Public Class clDataViaOracle
    Private mDataSet As DataSet = New DataSet
    Private mConnectionString As String
    Private mSQLString As String
    Private mDataSetInitialized As Boolean = False

    Public Property p_dataset() As DataSet
        Get
            Return mDataSet
        End Get
        Set(ByVal value As DataSet)
            mDataSet = value
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

    Public Function f_HaalOracleDataOp() As Boolean

        Dim OracleConnection As New OleDbConnection(mConnectionString)

        Try
            OracleConnection.Open()
        Catch ex As OleDbException
            MessageBox.Show(String.Concat("Er is een fout gebeurd tijdens het verbinden met de database. Details:", vbCrLf, ex.Message), "Fout", MessageBoxButtons.OK, MessageBoxIcon.Error)
            OracleConnection.Dispose()
            Return False
        End Try

        Try

            Dim OracleAdapter As OleDbDataAdapter = New OleDbDataAdapter(mSQLString, OracleConnection)

            If (mDataSetInitialized) Then
                mDataSet.Clear()
            End If

            'De rijen in de tabel "OracleTable" steken
            OracleAdapter.TableMappings.Add("Table", "OracleTable")
            OracleAdapter.Fill(mDataSet)

            OracleConnection.Close()

            'De data is opgehaald.
            mDataSetInitialized = True

            OracleConnection.Dispose()
            OracleAdapter.Dispose()
        Catch ex As Exception
            MessageBox.Show(String.Concat("Er is een fout gebeurd tijdens het ophalen van de gegevens. Details: ", vbCrLf, ex.Message), "Fout", MessageBoxButtons.OK, MessageBoxIcon.Error)
            OracleConnection.Dispose()
            Return False
        End Try

        Return True
    End Function

    Public Function f_VulOracleMetNieuweSporten(ByVal insertlist() As String) As Boolean

        Dim OracleConnection As New OleDbConnection(mConnectionString)

        Try
            OracleConnection.Open()
        Catch ex As OleDbException
            MessageBox.Show(String.Concat("Er is een fout gebeurd tijdens het verbinden met de database. Details:", vbCrLf, ex.Message), "Fout", MessageBoxButtons.OK, MessageBoxIcon.Error)
            OracleConnection.Dispose()
            Return False
        End Try

        Try

            Dim OracleCmd As OleDbCommand = New OleDbCommand()
            OracleCmd.Connection = OracleConnection

            Dim i As Int16
            'De nieuwe sporten inserten
            While (i < insertlist.Length() And Not insertlist(i) = String.Empty)
                OracleCmd.CommandText = insertlist(i)
                OracleCmd.CommandType = CommandType.Text
                OracleCmd.ExecuteNonQuery()
                i = i + 1
            End While

            OracleConnection.Close()
            OracleConnection.Dispose()
            OracleCmd.Dispose()
        Catch ex As Exception
            MessageBox.Show(String.Concat("Er is een fout gebeurd tijdens het inserteren van de gegevens. Details: ", vbCrLf, ex.Message), "Fout", MessageBoxButtons.OK, MessageBoxIcon.Error)
            OracleConnection.Dispose()
            Return False
        End Try

        Return True
    End Function

    Public Function f_TestOracleConnectie(ByVal tabel As String, ByVal kolom As String) As Boolean

        Dim OracleConnection As New OleDbConnection(mConnectionString)

        Try
            OracleConnection.Open()

            ' We gaan 1 rij selecteren als een test
            Dim OracleAdapter As OleDbDataAdapter = New OleDbDataAdapter(String.Concat("SELECT ", kolom, " FROM ", tabel, " WHERE rownum<=1"), OracleConnection)

            Dim testset As DataSet = New DataSet
            'De rij in de tabel "TestTable" steken
            OracleAdapter.TableMappings.Add("Table", "TestTable")
            OracleAdapter.Fill(testset)

            OracleConnection.Close()
            OracleConnection.Dispose()
            OracleAdapter.Dispose()
            Return True
        Catch ex As Exception
            OracleConnection.Dispose()
            Return False
        End Try
    End Function
End Class
