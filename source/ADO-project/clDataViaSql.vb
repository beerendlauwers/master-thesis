Imports System.Data.SqlClient
Public Class clDataViaSql
    Private mDataSet As DataSet = New DataSet
    Private mDT_Student As DataTable = New DataTable
    Private mDT_Niveau As DataTable = New DataTable
    Private mDT_DoetSport As DataTable = New DataTable
    Private mDT_Sport As DataTable = New DataTable
    Private mDV_Student As DataView = New DataView
    Private mDV_Sport As DataView = New DataView
    Private mDV_Niveau As DataView = New DataView
    Private mDV_DoetSport As DataView = New DataView
    Private m_constring As String

    Public Property p_datavStud() As DataView
        Get
            Return mDV_Student
        End Get
        Set(ByVal value As DataView)
            mDV_Student = value
        End Set
    End Property

    Public Property p_datavSport() As DataView
        Get
            Return mDV_Sport
        End Get
        Set(ByVal value As DataView)
            mDV_Sport = value
        End Set
    End Property

    Public Property p_datavDoetSport() As DataView
        Get
            Return mDV_DoetSport
        End Get
        Set(ByVal value As DataView)
            mDV_DoetSport = value
        End Set
    End Property

    Public Property p_datavNiveau() As DataView
        Get
            Return mDV_Niveau
        End Get
        Set(ByVal value As DataView)
            mDV_Niveau = value
        End Set
    End Property


    Public Sub New()
        m_constring = "Data Source=BEERDUDE-46D334\SQLEXPRESS;Initial Catalog=SPORTIMS2A5;Integrated Security=True"
    End Sub

    Public Function funConsql() As Boolean

        Dim SQLConnection As New SqlConnection(m_constring)

        Try
            SQLConnection.Open()
        Catch ex As SqlException
            MessageBox.Show("Er is een fout gebeurd tijdens het verbinden met de database.")
            SQLConnection.Dispose()
            Return False
        End Try

        Dim SQLstudent As String = "STORED_PROCEDURE_tblstudentinlezen"
        Dim SQLsport As String = "STORED_PROCEDURE_tblsportinlezen"
        Dim SQLniveau As String = "STORED_PROCEDURE_tblniveauinlezen"
        Dim SQLdoetsport As String = "STORED_PROCEDURE_tbldoetsportinlezen"


        Dim studentAdapter As SqlDataAdapter = New SqlDataAdapter()
        Dim sportAdapter As SqlDataAdapter = New SqlDataAdapter()
        Dim niveauAdapter As SqlDataAdapter = New SqlDataAdapter()
        Dim doetsportAdapter As SqlDataAdapter = New SqlDataAdapter()

        studentAdapter.TableMappings.Add("Table", "tblStudent")
        sportAdapter.TableMappings.Add("Table", "tblSport")
        niveauAdapter.TableMappings.Add("Table", "tblNiveau")
        doetsportAdapter.TableMappings.Add("Table", "tblDoetSport")

        Dim studentCmd As SqlCommand = New SqlCommand(SQLstudent, SQLConnection)
        Dim sportCmd As SqlCommand = New SqlCommand(SQLsport, SQLConnection)
        Dim niveauCmd As SqlCommand = New SqlCommand(SQLniveau, SQLConnection)
        Dim doetsportCmd As SqlCommand = New SqlCommand(SQLdoetsport, SQLConnection)

        studentCmd.CommandType = CommandType.StoredProcedure
        sportCmd.CommandType = CommandType.StoredProcedure
        niveauCmd.CommandType = CommandType.StoredProcedure
        doetsportCmd.CommandType = CommandType.StoredProcedure

        studentAdapter.SelectCommand = studentCmd
        sportAdapter.SelectCommand = sportCmd
        niveauAdapter.SelectCommand = niveauCmd
        doetsportAdapter.SelectCommand = doetsportCmd

        studentAdapter.Fill(mDataSet, "tblStudent")
        sportAdapter.Fill(mDataSet, "tblSport")
        niveauAdapter.Fill(mDataSet, "tblNiveau")
        doetsportAdapter.Fill(mDataSet, "tblDoetSport")

        mDT_Student = mDataSet.Tables("tblStudent")
        mDT_Sport = mDataSet.Tables("tblSport")
        mDT_Niveau = mDataSet.Tables("tblNiveau")
        mDT_DoetSport = mDataSet.Tables("tblDoetSport")

        mDV_Student = mDT_Student.DefaultView
        mDV_Sport = mDT_Sport.DefaultView
        mDV_Niveau = mDT_Niveau.DefaultView
        mDV_DoetSport = mDT_DoetSport.DefaultView

        mDV_Student.Sort = "StudentNaam"
        mDV_Sport.Sort = "SportNaam"
        mDV_Niveau.Sort = "Niveau"
        mDV_DoetSport.Sort = "DoetSportID"

        studentAdapter.Dispose()
        sportAdapter.Dispose()
        niveauAdapter.Dispose()
        doetsportAdapter.Dispose()

        studentCmd.Dispose()
        sportCmd.Dispose()
        niveauCmd.Dispose()
        doetsportCmd.Dispose()

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
