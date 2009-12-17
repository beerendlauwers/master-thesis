
Partial Class App_Presentation_Webpaginas_Beheer_FactuurDetails
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Request.QueryString("reservatieID") IsNot Nothing Then
            Try
                Dim reservatieID As Integer = Convert.ToInt32(Request.QueryString("reservatieID"))

                Dim factuurbll As New FactuurBLL
                Me.repOverzicht.DataSource = MaakFactuurLijnen(factuurbll.GetAllFactuurLijnenByReservatieID(reservatieID))
                Me.repOverzicht.DataBind()

                Dim controlebll As New ControleBLL
                Dim c As Onderhoud.tblControleRow = controlebll.GetControleByReservatieID(reservatieID)

                Dim reservatiebll As New ReservatieBLL
                Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(reservatieID)

                Dim beschadigingbll As New BeschadigingBLL
                Me.repBeschadigingen.DataSource = MaakBeschadigingsOverzicht(beschadigingbll.GetAllBeschadigingByControleIDAndUserID(c.controleID, r.userID))
                Me.repBeschadigingen.DataBind()

            Catch ex As Exception

            End Try
        End If

        

    End Sub

    Private Function MaakFactuurLijnen(ByRef datatable As Reservaties.tblFactuurlijnDataTable) As Data.DataTable
        Try

            Dim overzichtdatatable As New Data.DataTable
            Dim overzichtcolumn As New Data.DataColumn
            Dim overzichtrow As Data.DataRow

            'Eigen kolommen toevoegen
            overzichtdatatable.Columns.Add("rijKleur", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Omschrijving", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Kost", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Code", Type.GetType("System.String"))

            'Data overzetten
            Dim autobll As New AutoBLL
            Dim reservatiebll As New ReservatieBLL
            Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(datatable.Rows(0).Item("reservatieID"))
            Dim a As Autos.tblAutoRow = autobll.GetAutoByAutoID(r.autoID).Rows(0)

            Me.lblKenteken.Text = a.autoKenteken
            Me.lblMerkModel.Text = autobll.GetAutoNaamByAutoID(a.autoID)
            Me.lblBegindatum.Text = Format(r.reservatieBegindat, "dd/MM/yyyy")
            Me.lblEinddatum.Text = Format(r.reservatieEinddat, "dd/MM/yyyy")

            Dim klantbll As New KlantBLL
            Dim p As Klanten.tblUserProfielRow = klantbll.GetUserProfielByUserID(r.userID).Rows(0)
            Me.lblKlant.Text = String.Concat(p.userNaam, " ", p.userVoornaam)

            Dim i As Integer = 0
            Dim totaal As Double = 0
            For Each lijn As Reservaties.tblFactuurlijnRow In datatable
                overzichtrow = overzichtdatatable.NewRow

                If (i Mod 2) Then
                    overzichtrow("rijKleur") = "D4E0E8"
                Else
                    overzichtrow("rijKleur") = "ACC3D2"
                End If

                ' Algemene informatie
                overzichtrow("Omschrijving") = lijn.factuurlijnTekst
                overzichtrow("Kost") = lijn.factuurlijnKost
                totaal = totaal + lijn.factuurlijnKost
                overzichtrow("Code") = lijn.factuurlijnCode

                overzichtdatatable.Rows.Add(overzichtrow)

                i = i + 1
            Next lijn

            overzichtrow = overzichtdatatable.NewRow

            If (i Mod 2) Then
                overzichtrow("rijKleur") = "D4E0E8"
            Else
                overzichtrow("rijKleur") = "ACC3D2"
            End If

            overzichtrow("Omschrijving") = "Totaal:"
            overzichtrow("Kost") = totaal
            overzichtrow("Code") = "&nbsp;"

            overzichtdatatable.Rows.Add(overzichtrow)

            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Function MaakBeschadigingsOverzicht(ByRef datatable As Onderhoud.tblAutoBeschadigingDataTable) As Data.DataTable
        Try

            Dim overzichtdatatable As New Data.DataTable
            Dim overzichtcolumn As New Data.DataColumn
            Dim overzichtrow As Data.DataRow

            'Eigen kolommen toevoegen
            overzichtdatatable.Columns.Add("IsHersteld", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Omschrijving", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Kost", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("IsDoorverrekend", Type.GetType("System.String"))

            'Data overzetten
            Dim autobll As New AutoBLL
            Dim reservatiebll As New ReservatieBLL
            Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(datatable.Rows(0).Item("reservatieID"))
            Dim a As Autos.tblAutoRow = autobll.GetAutoByAutoID(r.autoID).Rows(0)

            Dim i As Integer = 0
            For Each besch As Onderhoud.tblAutoBeschadigingRow In datatable
                overzichtrow = overzichtdatatable.NewRow

                If (i Mod 2) Then
                    overzichtrow("rijKleur") = "D4E0E8"
                Else
                    overzichtrow("rijKleur") = "ACC3D2"
                End If

                ' Algemene informatie
                overzichtrow("Omschrijving") = besch.beschadigingOmschrijving


                If besch.beschadigingIsHersteld Then
                    overzichtrow("IsHersteld") = "Ja"
                    overzichtrow("Kost") = besch.beschadigingKost
                Else
                    overzichtrow("IsHersteld") = "Nee"
                    overzichtrow("Kost") = "Niet hersteld"
                End If

                If besch.beschadigingIsDoorverrekend Then
                    overzichtrow("IsDoorverrekend") = "Ja"
                Else
                    overzichtrow("IsDoorverrekend") = "Nee"
                End If


                overzichtdatatable.Rows.Add(overzichtrow)

            Next besch

            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function


End Class
