
Partial Class App_Presentation_Webpaginas_Beheer_FactuurDetails
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Request.QueryString("reservatieID") IsNot Nothing Then
            Try
                If Not IsPostBack Then

                    Dim reservatieID As Integer = Convert.ToInt32(Request.QueryString("reservatieID"))
                    ViewState("reservatieID") = reservatieID

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

                End If
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
            overzichtdatatable.Columns.Add("rijKleur", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("IsHersteld", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Omschrijving", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("Kost", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("IsDoorverrekend", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("beschadigingID", Type.GetType("System.String"))
            overzichtdatatable.Columns.Add("IsZichtbaar", Type.GetType("System.String"))

            'Data overzetten
            Dim autobll As New AutoBLL
            Dim reservatiebll As New ReservatieBLL
            Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(ViewState("reservatieID"))
            Dim a As Autos.tblAutoRow = autobll.GetAutoByAutoID(r.autoID).Rows(0)

            Dim i As Integer = 0

            For Each besch As Onderhoud.tblAutoBeschadigingRow In datatable
                overzichtrow = overzichtdatatable.NewRow

                If besch.beschadigingIsDoorverrekend Then Continue For

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
                    overzichtrow("IsZichtbaar") = "inline"
                Else
                    overzichtrow("IsHersteld") = "Nee"
                    overzichtrow("Kost") = "Niet hersteld"
                    overzichtrow("IsZichtbaar") = "none"
                End If

                If besch.beschadigingIsDoorverrekend Then
                    overzichtrow("IsDoorverrekend") = "Ja"
                    overzichtrow("IsZichtbaar") = "none"
                Else
                    overzichtrow("IsDoorverrekend") = "Nee"
                End If

                overzichtrow("beschadigingID") = besch.autoBeschadigingID

                overzichtdatatable.Rows.Add(overzichtrow)
                i = i + 1

            Next besch

            If i = 0 Then
                Me.btnAfsluiten.Enabled = True
                Me.lblAfsluitenNietMogelijk.Visible = False
                Me.divOpenstaandeBesch.Visible = False
            Else
                Me.btnAfsluiten.Enabled = False
                Me.lblAfsluitenNietMogelijk.Visible = True
                Me.divOpenstaandeBesch.Visible = True
            End If

            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function


    Protected Sub repBeschadigingen_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles repBeschadigingen.ItemCommand

        Dim factuurbll As New FactuurBLL
        Dim dt As New Reservaties.tblFactuurlijnDataTable
        Dim f As Reservaties.tblFactuurlijnRow = dt.NewRow

        Dim beschadigingbll As New BeschadigingBLL
        Dim b As Onderhoud.tblAutoBeschadigingRow = beschadigingbll.GetBeschadigingByBeschadigingID(e.CommandArgument)

        Dim controlebll As New ControleBLL
        Dim c As Onderhoud.tblControleRow = controlebll.GetControleByControleID(b.controleID)

        f.factuurlijnKost = b.beschadigingKost
        f.factuurlijnTekst = String.Concat("Beschadiging: ", b.beschadigingOmschrijving)
        f.factuurlijnCode = 8
        f.reservatieID = c.reservatieID
        factuurbll.InsertFactuurLijn(f)

        b.beschadigingIsDoorverrekend = 1
        beschadigingbll.UpdateBeschadiging(b)

        Dim reservatieID As Integer = Convert.ToInt32(Request.QueryString("reservatieID"))
        ViewState("reservatieID") = reservatieID

        Me.repOverzicht.DataSource = MaakFactuurLijnen(factuurbll.GetAllFactuurLijnenByReservatieID(reservatieID))
        Me.repOverzicht.DataBind()

        Dim co As Onderhoud.tblControleRow = controlebll.GetControleByReservatieID(reservatieID)

        Dim reservatiebll As New ReservatieBLL
        Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(reservatieID)

        Me.repBeschadigingen.DataSource = MaakBeschadigingsOverzicht(beschadigingbll.GetAllBeschadigingByControleIDAndUserID(c.controleID, r.userID))
        Me.repBeschadigingen.DataBind()

    End Sub

    Protected Sub btnAfsluiten_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAfsluiten.Click

        Dim reservatiebll As New ReservatieBLL
        Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(ViewState("reservatieID"))

        r.factuurIsInWacht = 0

        If reservatiebll.UpdateReservatie(r) Then
            Me.lblFeedback.Text = "Factuur afgesloten."
            Me.imgFeedback.ImageURL = "~\App_Presentation\Images\tick.gif"
            Me.divFeedback.Visible = True
            Me.btnAfsluiten.Visible = False
        Else
            Me.lblFeedback.Text = "Er is een fout gebeurd tijdens het afsluiten van de factuur. Gelieve het opnieuw te proberen."
            Me.imgFeedback.ImageURL = "~\App_Presentation\Images\remove.png"
            Me.divFeedback.Visible = True
        End If

    End Sub
End Class
