Imports System.Data.SqlClient
Public Class clDataViaSql
    Private mDataSet As DataSet = New DataSet
    Private mydtStud As DataTable = New DataTable
    Private mydtNiveau As DataTable = New DataTable
    Private mydtDoetSport As DataTable = New DataTable
    Private mydtSport As DataTable = New DataTable
    Private mydataviewStud As DataView = New DataView
    Private mydataviewSport As DataView = New DataView
    Private mydataviewNiveau As DataView = New DataView
    Private mydataviewDoetSport As DataView = New DataView
    Private m_constring As String

    Public Property p_datavStud() As DataView
        Get
            Return mydataviewStud
        End Get
        Set(ByVal value As DataView)
            mydataviewStud = value
        End Set
    End Property

    Public Property p_datavSport() As DataView
        Get
            Return mydataviewSport
        End Get
        Set(ByVal value As DataView)
            mydataviewSport = value
        End Set
    End Property

    Public Property p_datavDoetSport() As DataView
        Get
            Return mydataviewDoetSport
        End Get
        Set(ByVal value As DataView)
            mydataviewDoetSport = value
        End Set
    End Property

    Public Property p_datavNiveau() As DataView
        Get
            Return mydataviewNiveau
        End Get
        Set(ByVal value As DataView)
            mydataviewNiveau = value
        End Set
    End Property


    Public Sub New()
        m_constring = "Data Source=BEERDUDE-46D334\SQLEXPRESS;Initial Catalog=SPORTIMS2A5;Integrated Security=True"
    End Sub

    Public Function funConsql() As Boolean

        Dim SQLConnection As New SqlConnection(m_constring)
        'Dim value As DataRelationCollection
        'value = mDataSet.Relations
        'MessageBox.Show(value.Count)

        Try
            SQLConnection.Open()
        Catch ex As SqlException
            MessageBox.Show("foute connectie")
            SQLConnection.Dispose()

            Return False
        End Try

        Dim SQLString As String = "STORED_PROCEDURE_tblstudentinlezen"

        Dim AdaptSQLData As New SqlDataAdapter(SQLString, SQLConnection)

        AdaptSQLData.Fill(mDataSet, "tblStudent")    'selemp is vrij te kiezen slaagt op employees

        mydtStud = mDataSet.Tables("tblStudent")

        mydataviewStud = mydtStud.DefaultView
        'mydtSport = myds.Tables("tblSport")
        'mydtDoetSport = myds.Tables("tblDoetSport")
        'mydtNiveau = myds.Tables("tblNiveau")
        'mydataviewStud = mydtStud.DefaultView
        'mydataviewSport = mydtSport.DefaultView
        'mydataviewNiveau = mydtNiveau.DefaultView
        'mydataviewDoetSport = mydtDoetSport.DefaultView

        mydataviewStud.Sort = "StudentNaam"
        'mydataviewSport.Sort = "SportNaam"
        'mydataviewNiveau.Sort = "Niveau"
        'mydataviewDoetSport.Sort = "DoetSportID"

        AdaptSQLData.Dispose()
        SQLConnection.Close()
        SQLConnection.Dispose()

        Return True


    End Function
    Public Function studentdetails(ByVal i_id As Int16) As DataRowView
        Dim dataview As DataView
        Dim anyrow As DataRowView
        dataview = New DataView
        With dataview
            .Table = mDataSet.Tables("tblStudent")
            .AllowDelete = True
            .AllowEdit = True
            .AllowNew = True
            .RowFilter = "StudentID = " & i_id


        End With

        anyrow = dataview.Item(0)
        Return anyrow
        dataview.Dispose()


    End Function

End Class
