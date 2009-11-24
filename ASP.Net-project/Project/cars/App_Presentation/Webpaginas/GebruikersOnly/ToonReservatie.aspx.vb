Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Presentation_Webpaginas_GebruikersOnly_ToonReservatie
    Inherits System.Web.UI.Page
    Private conn As String = ConfigurationManager.ConnectionStrings("ConnectToDatabase").ConnectionString()
    Private myConnection As New SqlConnection(conn)

    Private Function MaakOverzichtsDataTable(ByRef datatable As Data.DataTable) As Data.DataTable
        Try
            Dim overzichtdatatable As New Data.DataTable
            Dim overzichtcolumn As New Data.DataColumn
            Dim overzichtrow As Data.DataRow

            'Kolommen van originele tabel overkopiëren
            Dim columnnaam As String = String.Empty
            Dim columntype As System.Type
            For i As Integer = 0 To datatable.Columns.Count - 1
                columnnaam = datatable.Columns(i).ColumnName
                columntype = datatable.Columns(i).DataType
                overzichtdatatable.Columns.Add(columnnaam, columntype)
            Next

            'Eigen kolommen toevoegen
            overzichtdatatable.Columns.Add("autoNaam", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("begindat", Type.GetType("System.DateTime"))
            overzichtdatatable.Columns.Add("einddat", Type.GetType("System.DateTime"))

            'Data overzetten
            Dim autobll As New AutoBLL
            For i As Integer = 0 To datatable.Rows.Count - 1
                overzichtrow = overzichtdatatable.NewRow()

                overzichtrow("autoNaam") = autobll.GetAutoNaamByAutoID(datatable.Rows(i).Item("autoID"))
                overzichtrow("begindat") = Date.Parse(datatable.Rows(i).Item("reservatieBegindat"))
                overzichtrow("einddat") = Date.Parse(datatable.Rows(i).Item("reservatieEinddat"))

                overzichtdatatable.Rows.Add(overzichtrow)
            Next

            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("userID") IsNot Nothing Then

            Try
                Convert.ToInt32(Request.QueryString("userID"))
            Catch ex As Exception
                Me.lgvReservatie.Visible = False
                lblGeenReservaties.Text = "Ongeldig ID."
                Return
            End Try

            If (Not Roles.IsUserInRole(Page.User.Identity.Name, "Gebruiker") And _
                Not Roles.IsUserInRole(Page.User.Identity.Name, "Developer")) Then
                Me.lgvReservatie.Visible = False
                lblGeenReservaties.Text = "Gelieve in te loggen."
                Return
            Else
                Dim klantbll As New KlantBLL
                Dim bezoekendeklant As Integer = klantbll.GetKlantIDByKlantNaam(Page.User.Identity.Name)
                klantbll = Nothing

                If (Not bezoekendeklant = Convert.ToInt32(Request.QueryString("userID"))) Then
                    Me.lgvReservatie.Visible = False
                    lblGeenReservaties.Text = "U mag de reservaties van een andere klant niet beheren."
                    Return
                End If
            End If

            myConnection.Open()

            Dim myCommand As New SqlCommand("SELECT * FROM tblReservatie WHERE klantID = @userID")
            myCommand.Parameters.Add("@userID", SqlDbType.Int)
            myCommand.Parameters("@userID").Value = Convert.ToInt32(Request.QueryString("userID"))
            myCommand.Connection = myConnection

            Dim myReader As SqlDataReader
            myReader = myCommand.ExecuteReader

            Dim temptable As New DataTable
            temptable.Load(myReader)

            myConnection.Close()

            'Verwerk datatable tot overzichtsdatatable
            Dim dt As Data.DataTable = MaakOverzichtsDataTable(temptable)

            If (dt.Rows.Count > 0) Then
                lblGeenReservaties.Visible = False
                Me.lgvReservatie.Visible = True
                CType(Me.lgvReservatie.FindControl("repOverzicht"), Repeater).DataSource = dt
            Else
                lblGeenReservaties.Text = "Er zijn geen reservaties die aan uw zoekvoorwaarden voldoen."
                lblGeenReservaties.Visible = True
                Me.lgvReservatie.Visible = False
            End If

            CType(Me.lgvReservatie.FindControl("repOverzicht"), Repeater).DataBind()
        Else
            Me.lgvReservatie.Visible = False
            lblGeenReservaties.Text = "Ongeldig ID."
        End If
    End Sub
End Class
