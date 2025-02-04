﻿Imports Microsoft.VisualBasic
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
        'Alle reservaties van deze auto ophalen
        Dim bllreservatie As New ReservatieBLL
        Dim allereservaties As Reservaties.tblReservatieDataTable = bllreservatie.GetAllbevestigdeReservaties()

        'Vul DDLKlant
        If Not IsPostBack Then
            VulKlantDropdown(allereservaties)
            Me.ddlKlant.SelectedIndex = 0
            autodropdownvullen()
            VulReservatieOverzicht()
            'maakreservetabel()
        End If

    End Sub

    Private Sub VulReservatieOverzicht()
        Dim reservatiebll As New ReservatieBLL
        Dim dt As Data.DataTable = MaakOverzichtsDataTable(reservatiebll.GetAllbevestigdeReservaties())
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

    Private Sub VulReservatieOverzichtbyUserID(ByVal userID As Guid)
        Dim reservatiebll As New ReservatieBLL
        Dim dt As Data.DataTable = MaakOverzichtsDataTable(reservatiebll.GetAllBevestigdeReservatiesByUserID(userID))
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

    Private Sub VulReservatieOverzichtbyAutoID(ByVal autoID As Integer)
        Dim reservatiebll As New ReservatieBLL
        Dim dt As Data.DataTable = MaakOverzichtsDataTable(reservatiebll.GetAllBevestigdeReservatiesByAutoID(autoID))
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

    Private Sub VulKlantDropdown(ByRef reservaties As Reservaties.tblReservatieDataTable)

        'DDLKlant opvullen
        Dim klantbll As New KlantBLL
        Dim dubbels(reservaties.Rows.Count) As String

        dubbels(0) = "Alle Reservaties"
        Me.ddlKlant.Items.Add(New ListItem(dubbels(0), -1))
        Dim i As Integer = 1

        For Each res As Reservaties.tblReservatieRow In reservaties
            'Klant ophalen
            Dim dt As Klanten.tblUserProfielDataTable = klantbll.GetUserProfielByUserID(res.userID)

            If dt.Rows.Count = 0 Then Continue For
            Dim p As Klanten.tblUserProfielRow = dt.Rows(0)

            'Even nakijken of deze klant al in de dropdown zit.
            Dim isDubbel As Boolean = False
            Dim naamvoornaam As String = String.Concat(p.userNaam, " ", p.userVoornaam)
            For Each naam In dubbels
                If (naamvoornaam = naam) Then
                    isDubbel = True
                End If
            Next naam

            If (Not isDubbel) Then
                Dim item As New ListItem(naamvoornaam, p.userID.ToString)
                Me.ddlKlant.Items.Add(item)
                dubbels(i) = naamvoornaam
                i = i + 1
            End If
        Next res
    End Sub
    Protected Sub ddlKlant_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlKlant.SelectedIndexChanged
        Dim reservatiebll As New ReservatieBLL
        'Filter op klant en opslaan
        If Not Me.ddlKlant.SelectedValue = "-1" Then
            Dim userId As New Guid
            userId = New Guid(ddlKlant.SelectedValue)
            VulReservatieOverzichtbyUserID(userId)
        Else

        End If

        reservatiebll = Nothing

        Me.updReservatieBeheer.Update()
    End Sub
    Private Sub autodropdownvullen()
        Dim autobll As New AutoBLL
        Dim dt As New Autos.tblAutoDataTable
        dt = autobll.GetAllAutos()
        ddlAuto.Items.Add(New ListItem(("Kies auto"), -1))
        For i As Integer = 0 To dt.Rows.Count - 1
            ddlAuto.Items.Add(New ListItem((dt.Rows(i)("autoKenteken")), (dt.Rows(i)("autoID"))))
        Next

    End Sub

    Protected Sub ddlAuto_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAuto.SelectedIndexChanged
        Dim reservatiebll As New ReservatieBLL
        'Filter op klant en opslaan
        If Not Me.ddlAuto.SelectedValue = "-1" Then
            Dim autoID As Integer = ddlAuto.SelectedValue
            VulReservatieOverzichtbyAutoID(autoID)
        Else

        End If

        reservatiebll = Nothing

        Me.updReservatieBeheer.Update()
    End Sub

    Protected Sub repOverzicht_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles repOverzicht.ItemCommand

        Dim splitstring() As String = e.CommandArgument.ToString.Split(",")

        Dim commando As String = splitstring(0)
        Dim resID As Integer = Convert.ToInt32(splitstring(1))
        Dim autoID As Integer = Convert.ToInt32(splitstring(2))

        If (commando = "Verwijderen") Then
            lblInfo.Text = String.Concat(resID, ",", autoID)
            btnReserve.Visible = True
            btnVerwijder.Visible = True

            'Dim reservatiebll As New ReservatieBLL
            'Dim nodigonderhoudbll As New OnderhoudBLL
            'Dim controlebll As New ControleBLL

            'Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(resID)
            'If r Is Nothing Then Return

            ''Eerst het nazicht van deze reservatie verwijderen in tblNodigOnderhoud
            'Dim o As Onderhoud.tblNodigOnderhoudRow = nodigonderhoudbll.GetNazichtByDatumAndAutoID(DateAdd(DateInterval.Day, 1, r.reservatieEinddat), r.autoID)
            'If o IsNot Nothing Then nodigonderhoudbll.VerwijderNodigOnderhoud(o.nodigOnderhoudID)

            ''Dan het eigenlijke nazicht
            'Dim co As Onderhoud.tblControleRow = controlebll.GetControleByReservatieID(r.reservatieID)
            'If co IsNot Nothing Then controlebll.DeleteControle(co.controleID)

            ''Dan de reservatie zelf
            'Dim resultaat As Integer = reservatiebll.DeleteReservatie(r)

            'If (resultaat = -5) Then
            '    Me.lblFeedback.Text = "U kan een reservatie niet meer verwijderen 2 dagen voor de beginperiode."
            '    Me.imgFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            '    Me.divFeedback.Visible = True
            'End If

            'reservatiebll = Nothing
            'nodigonderhoudbll = Nothing
            'controlebll = Nothing

        ElseIf (commando = "Wijzigen") Then
            Response.Redirect(String.Concat("../Beheer/ReservatieWijzigen.aspx?resData=", resID, ",", autoID))
        End If

        VulReservatieOverzicht()

    End Sub

    Protected Sub btnVerwijder_Click() Handles btnVerwijder.Click
        Dim splitstring() As String = lblInfo.ToString.Split(",")
        Dim bllauto As New AutoBLL
        Dim commando As String = splitstring(0)
        Dim resID As Integer = Convert.ToInt32(splitstring(1))
        Dim autoID As Integer = Convert.ToInt32(splitstring(2))
        Dim reservatiebll As New ReservatieBLL
        Dim nodigonderhoudbll As New OnderhoudBLL
        Dim controlebll As New ControleBLL

        Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(resID)
        If r Is Nothing Then Return

        Dim autonummer = r.autoID
        Dim dt As New Autos.tblAutoDataTable
        dt = bllauto.getReservAuto(autonummer)


        'Eerst het nazicht van deze reservatie verwijderen in tblNodigOnderhoud
        Dim o As Onderhoud.tblNodigOnderhoudRow = nodigonderhoudbll.GetNazichtByDatumAndAutoID(DateAdd(DateInterval.Day, 1, r.reservatieEinddat), r.autoID)
        If o IsNot Nothing Then nodigonderhoudbll.VerwijderNodigOnderhoud(o.nodigOnderhoudID)

        'Dan het eigenlijke nazicht
        Dim co As Onderhoud.tblControleRow = controlebll.GetControleByReservatieID(r.reservatieID)
        If co IsNot Nothing Then controlebll.DeleteControle(co.controleID)

        'Dan de reservatie zelf
        Dim resultaat As Integer = reservatiebll.DeleteReservatie(r)

        If (resultaat = -5) Then
            Me.lblFeedback.Text = "U kan een reservatie niet meer verwijderen 2 dagen voor de beginperiode."
            Me.imgFeedback.ImageUrl = "~\App_Presentation\Images\remove.png"
            Me.divFeedback.Visible = True
        End If

        reservatiebll = Nothing
        nodigonderhoudbll = Nothing
        controlebll = Nothing
    End Sub


    Protected Sub btnReserve_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReserve.Click

        lblInfo.Visible = True
        Dim dt As New Data.DataTable
        dt = maakreservetabel()
        repReserve.DataSource = dt
        repReserve.DataBind()

    End Sub

    Public Function maakreservetabel() As Data.DataTable

        Try
            Dim bllauto As New AutoBLL
            Dim splitstring() As String = lblInfo.Text.Split(",")
            Dim resID As Integer = Convert.ToInt32(splitstring(0))
            Dim autoID As Integer = Convert.ToInt32(splitstring(1))
            Dim rowreserveerde As Autos.tblAutoRow = bllauto.GetAutoByAutoID(autoID).Rows(0)

            Dim waardereservatieauto() As Double = GeefOptieKosten(rowreserveerde)
            Dim dagtariefreserveerde As Integer = rowreserveerde.autoDagTarief
            Dim overzichtdatatable As New Data.DataTable


            Dim overzichtcolumn As New Data.DataColumn
            Dim overzichtrow As Data.DataRow
            Dim datatable As Autos.tblAutoDataTable = bllauto.getReservAuto(autoID)

            'Kolommen van originele tabel overkopiëren
            Dim columnnaam As String = String.Empty
            Dim columntype As System.Type
            For i As Integer = 0 To datatable.Columns.Count - 1
                columnnaam = datatable.Columns(i).ColumnName
                columntype = datatable.Columns(i).DataType
                overzichtdatatable.Columns.Add(columnnaam, columntype)
            Next

            overzichtdatatable.Columns.Add("rijKleur", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("resData", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("autoNaam", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("autoKleur2", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("autoKenteken2", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("autoDagtarief2", Type.GetType("System.String"))


            For i As Integer = 0 To datatable.Rows.Count - 1
                overzichtrow = overzichtdatatable.NewRow()
                Dim row As Autos.tblAutoRow = datatable.Rows(i)
                Dim waarde = GeefOptieKosten(row)
                If (i Mod 2) Then
                    overzichtrow("rijKleur") = "D4E0E8"
                Else
                    overzichtrow("rijKleur") = "ACC3D2"
                End If
                If row.autoDagTarief + waarde(1) > (waardereservatieauto(1) + dagtariefreserveerde) - 50 And row.autoDagTarief + waarde(1) < (waardereservatieauto(1) + dagtariefreserveerde) + 50 Then
                    overzichtrow("autoNaam") = bllauto.GetAutoNaamByAutoID(row.autoID)
                    overzichtrow("autoKleur2") = row.autoKleur
                    'overzichtrow("autoKenteken2") = row.autoKenteken
                    overzichtrow("autoDagtarief2") = row.autoDagTarief
                    overzichtdatatable.Rows.Add(overzichtrow)
                End If
            Next

            
            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
