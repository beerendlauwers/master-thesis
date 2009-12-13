Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Presentation_Webpaginas_GebruikersOnly_ToonReservatie
    Inherits System.Web.UI.Page
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
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

            overzichtdatatable.Columns.Add("resData", Type.GetType("System.String"))

            overzichtdatatable.Columns.Add("autoVerwijderen", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("autoWijzigen", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("rijKleur", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("autoNaam", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("autoKleur", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("begindat", Type.GetType("System.DateTime"))
            overzichtdatatable.Columns.Add("einddat", Type.GetType("System.DateTime"))
            overzichtdatatable.Columns.Add("aantalDagen", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("totaalKost", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("aantalOpties", Type.GetType("System.String"))

            'Data overzetten
            Dim autobll As New AutoBLL

            For i As Integer = 0 To datatable.Rows.Count - 1
                overzichtrow = overzichtdatatable.NewRow()

                Dim row As Autos.tblAutoRow = autobll.GetAutoByAutoID(datatable.Rows(i).Item("autoID")).Rows(0)

                'Rijkleur
                If (i Mod 2) Then
                    overzichtrow("rijKleur") = "D4E0E8"
                Else
                    overzichtrow("rijKleur") = "ACC3D2"
                End If

                'Algemene informatie
                overzichtrow("resData") = String.Concat(datatable.Rows(i).Item("reservatieID"), ",", row.autoID)

                ' "Auto verwijderen"-knop
                overzichtrow("autoVerwijderen") = String.Concat("Verwijderen, ", overzichtrow("resData"))

                ' "Auto wijzigen"-knop
                overzichtrow("autoWijzigen") = String.Concat("Wijzigen, ", overzichtrow("resData"))

                ' Algemene informatie
                overzichtrow("autoNaam") = autobll.GetAutoNaamByAutoID(row.autoID)
                overzichtrow("autoKleur") = row.autoKleur
                overzichtrow("begindat") = Format(Date.Parse(datatable.Rows(i).Item("reservatieBegindat")), "dd/MM/yyyy")
                overzichtrow("einddat") = Format(Date.Parse(datatable.Rows(i).Item("reservatieEinddat")), "dd/MM/yyyy")
                overzichtrow("aantalDagen") = (overzichtrow("einddat") - overzichtrow("begindat")).TotalDays.ToString

                'Huurprijs
                Dim huurprijs As Double
                huurprijs = (overzichtrow("einddat") - overzichtrow("begindat")).TotalDays * row.autoDagTarief

                Dim waardes() As Double = GeefOptieKosten(row)
                overzichtrow("aantalOpties") = waardes(0).ToString

                huurprijs = huurprijs + waardes(1)
                overzichtrow("totaalKost") = String.Concat(huurprijs.ToString, " €")

                'Auto toevoegen
                overzichtdatatable.Rows.Add(overzichtrow)
            Next

            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (User.Identity.IsAuthenticated) Then
            Dim bezoekendeklant As New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())

            If (Not IsPostBack) Then

                VulReservatieOverzicht(bezoekendeklant)

            End If

        Else
            Me.pnlOverzicht.Visible = False
            lblGeenReservaties.Text = "Gelieve in te loggen."
            Return
        End If

    End Sub

    Private Sub VulReservatieOverzicht(ByRef bezoekendeklant As Guid)
        Dim reservatiebll As New ReservatieBLL
        Dim dt As Data.DataTable = MaakOverzichtsDataTable(reservatiebll.GetAllBevestigdeReservatiesByUserID(bezoekendeklant))
        reservatiebll = Nothing

        If (dt.Rows.Count > 0) Then
            lblGeenReservaties.Visible = False
            Me.pnlOverzicht.Visible = True
            Me.repOverzicht.DataSource = dt
        Else
            lblGeenReservaties.Text = "Er zijn geen reservaties die aan uw zoekvoorwaarden voldoen."
            lblGeenReservaties.Visible = True
            Me.pnlOverzicht.Visible = False

        End If

        Me.repOverzicht.DataBind()
    End Sub

    Private Function GeefOptieKosten(ByRef a As Autos.tblAutoRow) As Double()
        Dim optiebll As New OptieBLL
        Dim dt As Autos.tblOptieDataTable = optiebll.GetAllOptiesByAutoID(a.autoID)

        If (dt.Rows.Count = 0) Then
            Dim dummy() As Double = {0, 0}
            Return dummy
        End If

        Dim optiekosten As Double = 0
        For Each optie As Autos.tblOptieRow In dt
            optiekosten = optiekosten + optie.optieKost
        Next

        optiebll = Nothing

        Dim waardes(1) As Double
        waardes(0) = dt.Rows.Count
        waardes(1) = optiekosten

        Return waardes
    End Function

    Private Function OngebruikteFunctie() As Double

        Dim rowview As Data.DataRowView
        Dim row As Data.DataRow = rowview.Row

        Dim optiebll As New OptieBLL
        Dim dt As Autos.tblOptieDataTable = optiebll.GetAllOptiesByAutoID(row.Item("autoID"))

        If (dt.Rows.Count = 0) Then Return 0

        Dim table As New HtmlGenericControl("table")

        Dim optiekosten As Double = 0
        For Each optie As Autos.tblOptieRow In dt
            Dim tr As New HtmlGenericControl("tr")

            Dim tdlinks As New HtmlGenericControl("td")
            Dim optienaam As New Label
            optienaam.Text = optie.optieOmschrijving

            Dim tdrechts As New HtmlGenericControl("td")
            Dim optiekost As New Label
            optiekost.Text = optie.optieKost.ToString
            optiekosten = optie.optieKost

            tdlinks.Controls.Add(optienaam)
            tdrechts.Controls.Add(optiekost)
            tr.Controls.Add(tdlinks)
            tr.Controls.Add(tdrechts)
            table.Controls.Add(tr)
        Next optie

        Return optiekosten
    End Function

    Protected Sub repOverzicht_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles repOverzicht.ItemCommand
        Dim splitstring() As String = e.CommandArgument.ToString.Split(",")

        Dim commando As String = splitstring(0)
        Dim resID As Integer = Convert.ToInt32(splitstring(1))
        Dim autoID As Integer = Convert.ToInt32(splitstring(2))

        If (commando = "Verwijderen") Then
            Dim reservatiebll As New ReservatieBLL
            Dim nodigonderhoudbll As New OnderhoudBLL
            Dim controlebll As New ControleBLL

            Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(resID)
            If r Is Nothing Then Return

            'Eerst het nazicht van deze reservatie verwijderen in tblNodigOnderhoud
            Dim o As Onderhoud.tblNodigOnderhoudRow = nodigonderhoudbll.GetNazichtByDatumAndAutoID(DateAdd(DateInterval.Day, 1, r.reservatieEinddat), r.autoID)
            If o IsNot Nothing Then nodigonderhoudbll.VerwijderNodigOnderhoud(o.nodigOnderhoudID)

            'Dan het eigenlijke nazicht
            Dim co As Onderhoud.tblControleRow = controlebll.GetControleByReservatieID(r.reservatieID)
            If co IsNot Nothing Then controlebll.DeleteControle(co.controleID)

            'Dan de reservatie zelf
            reservatiebll.DeleteReservatie(resID)

            reservatiebll = Nothing
            nodigonderhoudbll = Nothing
            controlebll = Nothing

        ElseIf (commando = "Wijzigen") Then
            Response.Redirect(String.Concat("ReservatieWijzigen.aspx?resData=", resID, ",", autoID))
        End If

        Dim bezoekendeklant As New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())
        VulReservatieOverzicht(bezoekendeklant)

    End Sub
End Class
