
Partial Class App_Presentation_Webpaginas_Beheer_Laatkomersrapport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim reservatiebll As New ReservatieBLL

        Dim dt As Reservaties.tblReservatieDataTable = reservatiebll.GetAllLateReservaties()

        Me.repLaatkomersrapport.DataSource = MaakOverzichtsDataTable(dt)
        Me.repLaatkomersrapport.DataBind()

    End Sub


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

            overzichtdatatable.Columns.Add("Kenteken", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("MerkModel", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Klant", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Medewerker", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Begindatum", Type.GetType("System.DateTime"))
            overzichtdatatable.Columns.Add("Einddatum", Type.GetType("System.DateTime"))

            'Data overzetten
            Dim autobll As New AutoBLL
            Dim klantbll As New KlantBLL

            For i As Integer = 0 To datatable.Rows.Count - 1
                overzichtrow = overzichtdatatable.NewRow()

                Dim row As Autos.tblAutoRow = autobll.GetAutoByAutoID(datatable.Rows(i).Item("autoID")).Rows(0)

                ' Algemene informatie
                overzichtrow("MerkModel") = autobll.GetAutoNaamByAutoID(row.autoID)
                overzichtrow("Kenteken") = row.autoKenteken
                overzichtrow("Begindatum") = Format(Date.Parse(datatable.Rows(i).Item("reservatieBegindat")), "dd/MM/yyyy")
                overzichtrow("Einddatum") = Format(Date.Parse(datatable.Rows(i).Item("reservatieEinddat")), "dd/MM/yyyy")

                Dim k As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(datatable.Rows(i).Item("userID")).Rows(0)
                overzichtrow("Klant") = String.Concat(k.userNaam, " ", k.userVoornaam)

                Dim m As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(datatable.Rows(i).Item("reservatieIngechecktDoorMedewerker")).Rows(0)
                overzichtrow("Medewerker") = String.Concat(m.userNaam, " ", m.userVoornaam)

                'Auto toevoegen
                overzichtdatatable.Rows.Add(overzichtrow)
            Next

            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
