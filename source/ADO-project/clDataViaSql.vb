Imports System.Data.SqlClient
Public Class clDataViaSql
    Private myds As DataSet = New DataSet
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
        m_constring = "Data Source=PC_VAN_FRANK;Initial Catalog=SPORTIMS2A5;Integrated Security=True"
    End Sub

    Public Function funConsql() As Boolean
        Dim objcon As New SqlConnection(m_constring)
        Dim value As DataRelationCollection
        value = myds.Relations
        MessageBox.Show(value.Count)

        Try
            objcon.Open()
        Catch ex As SqlException
            MessageBox.Show("foute connectie")
            objcon.Dispose()

            Return False
        End Try

        Dim sqlqstr As String = "STORED_PROCEDRURE_datainlezen"
        Dim myadap As New SqlDataAdapter(sqlqstr, objcon)
        myadap.Fill(myds, "studentsport")    'selemp is vrij te kiezen slaagt op employees
        mydtStud = myds.Tables("tblStudent")
        mydtSport = myds.Tables("tblSport")
        mydtDoetSport = myds.Tables("tblDoetSport")
        mydtNiveau = myds.Tables("tblNiveau")
        mydataviewStud = mydtStud.DefaultView
        mydataviewSport = mydtSport.DefaultView
        mydataviewNiveau = mydtNiveau.DefaultView
        mydataviewDoetSport = mydtDoetSport.DefaultView

        'mydataviewStud.Sort = "StudentNaam"
        'mydataviewSport.Sort = "SportNaam"
        'mydataviewNiveau.Sort = "Niveau"
        'mydataviewDoetSport.Sort = "DoetSportID"

        myadap.Dispose()
        objcon.Close()
        objcon.Dispose()

        Return True

    End Function
    Public Function studentdetails(ByVal i_id As Int16) As DataRowView
        Dim dataview As DataView
        Dim anyrow As DataRowView
        dataview = New DataView
        With dataview
            .Table = myds.Tables("tblStudent")
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
