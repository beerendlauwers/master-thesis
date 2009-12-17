
Partial Class App_Presentation_Webpaginas_Beheer_Factuurbeheer
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim factuurbll As New FactuurBLL

        If Not IsPostBack Then
            Me.repOverzicht.DataSource = MaakOverzichtsDataTable(factuurbll.GetAllFacturenInWacht())
            Me.repOverzicht.DataBind()
        End If


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
            overzichtdatatable.Columns.Add("rijKleur", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("autoNaam", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("autoKleur", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Begindatum", Type.GetType("System.DateTime"))
            overzichtdatatable.Columns.Add("Einddatum", Type.GetType("System.DateTime"))
            overzichtdatatable.Columns.Add("totaalKost", Type.GetType("System.String"))

            'Data overzetten
            Dim autobll As New AutoBLL

            For i As Integer = 0 To datatable.Rows.Count - 1
                overzichtrow = overzichtdatatable.NewRow()

                If (i Mod 2) Then
                    overzichtrow("rijKleur") = "D4E0E8"
                Else
                    overzichtrow("rijKleur") = "ACC3D2"
                End If


                Dim row As Autos.tblAutoRow = autobll.GetAutoByAutoID(datatable.Rows(i).Item("autoID")).Rows(0)

                ' Algemene informatie
                overzichtrow("autoNaam") = autobll.GetAutoNaamByAutoID(row.autoID)
                overzichtrow("autoKleur") = row.autoKleur
                overzichtrow("Begindatum") = Format(Date.Parse(datatable.Rows(i).Item("reservatieBegindat")), "dd/MM/yyyy")
                overzichtrow("Einddatum") = Format(Date.Parse(datatable.Rows(i).Item("reservatieEinddat")), "dd/MM/yyyy")
                overzichtrow("reservatieID") = datatable.Rows(i).Item("reservatieID")

                Dim factuurbll As New FactuurBLL
                Dim lijnen As Reservaties.tblFactuurlijnDataTable = factuurbll.GetAllFactuurLijnenByReservatieID(datatable.Rows(i).Item("reservatieID"))

                Dim totaalkost As Double = 0
                For Each lijn As Reservaties.tblFactuurlijnRow In lijnen
                    totaalkost = totaalkost + lijn.factuurlijnKost
                Next lijn

                overzichtrow("totaalKost") = totaalkost

                'Auto toevoegen
                overzichtdatatable.Rows.Add(overzichtrow)
            Next


            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function


    Protected Sub repOverzicht_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles repOverzicht.ItemCommand

        Response.Redirect(String.Concat("FactuurDetails.aspx?reservatieID=", e.CommandArgument))

    End Sub
End Class
