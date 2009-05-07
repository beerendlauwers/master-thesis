Imports System.Data.OleDb

Public Class clDataViaExcel

    Private mDatasetExcel As DataSet = New DataSet
    Private mConnectionString As String
    Private mSQLString As String
    Private blnDataOpgehaald As Boolean = False

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

    Public Property p_mDatasetExcel() As DataSet
        Get
            Return mDatasetExcel
        End Get
        Set(ByVal value As DataSet)
            mDatasetExcel = value
        End Set
    End Property

    Public Function f_fill() As Boolean
        'Alles van Excel binnenhalen

        Try
            'Connectie
            Dim ExcelConnection As New System.Data.OleDb.OleDbConnection(mConnectionString)

            ExcelConnection.Open()

            'Alles binnenhalen
            Dim ExcelAdapter As OleDbDataAdapter = New OleDbDataAdapter(mSQLString, ExcelConnection)

            'Als we reeds data hebben binnengehaald (wss reeds op de "Haal Data Op"
            'knop gedrukt), maken we de dataset leeg
            If (blnDataOpgehaald) Then
                mDatasetExcel.Clear()
            End If

            'De rijen in de tabel "DataTable" steken
            ExcelAdapter.TableMappings.Add("Table", "DataTable")
            ExcelAdapter.Fill(mDatasetExcel)

            ExcelConnection.Close()

            'De data is opgehaald.
            blnDataOpgehaald = True
        Catch ex As Exception
            MsgBox(ex.Message)
            Return False
        End Try

        Return True
    End Function

    Public Function f_connectietest() As Boolean
        'Snelle connectietest met Excel.

        Try
            'Connectie
            Dim ExcelConnection As New System.Data.OleDb.OleDbConnection(mConnectionString)

            ExcelConnection.Open()

            '1 rij binnenhalen als test
            Dim ExcelAdapter As OleDbDataAdapter = New OleDbDataAdapter(mSQLString, ExcelConnection)

            'Deze rij in de tabel "TestTable" steken
            ExcelAdapter.TableMappings.Add("Table", "TestTable")
            ExcelAdapter.Fill(mDatasetExcel)

            ExcelConnection.Close()

        Catch ex As Exception
            Return False
        End Try

        Return True
    End Function
End Class
