Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Presentation_Webpaginas_GebruikersOnly_ToonReservatie
    Inherits System.Web.UI.Page

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

            overzichtdatatable.Columns.Add("btnID", Type.GetType("System.String"))
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

                If (i Mod 2) Then
                    overzichtrow("rijKleur") = "D4E0E8"
                Else
                    overzichtrow("rijKleur") = "ACC3D2"
                End If


                overzichtrow("autoID") = row.autoID
                overzichtrow("autoNaam") = autobll.GetAutoNaamByAutoID(row.autoID)
                overzichtrow("autoKleur") = row.autoKleur
                overzichtrow("begindat") = Format(Date.Parse(datatable.Rows(i).Item("reservatieBegindat")), "dd/MM/yyyy")
                overzichtrow("einddat") = Format(Date.Parse(datatable.Rows(i).Item("reservatieEinddat")), "dd/MM/yyyy")
                overzichtrow("aantalDagen") = (overzichtrow("einddat") - overzichtrow("begindat")).TotalDays.ToString

                Dim huurprijs As Double
                huurprijs = (overzichtrow("einddat") - overzichtrow("begindat")).TotalDays * row.autoDagTarief

                'Dim waardes() As Double = GeefOptieKosten(row)
                'overzichtrow("aantalOpties") = waardes(0).ToString

                'huurprijs = huurprijs + waardes(1)
                overzichtrow("totaalKost") = String.Concat(huurprijs.ToString, " €")

                overzichtdatatable.Rows.Add(overzichtrow)
            Next

            Return overzichtdatatable
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Sub VulKleurDDL(ByRef a As Autos.tblAutoRow, ByRef r As Reservaties.tblReservatieRow)
        Dim autobll As New AutoBLL
        Dim merkbll As New MerkBLL

        Dim filterOpties(50) As String
        filterOpties(0) = a.categorieID
        'filterOpties(1) = a.autoKleur
        filterOpties(2) = merkbll.GetMerkByModelID(a.modelID).Rows(0).Item("merkID").ToString

        'Alle beschikbare auto's ophalen die aan deze filteropties voldoen
        Dim dt As Autos.tblAutoDataTable = autobll.GetBeschikbareAutosBy(r.reservatieBegindat, r.reservatieEinddat, filterOpties)

        Me.ddlKleur.Items.Clear()

        'Deze array gebruiken we om te checken dat er geen dubbels inzitten
        Dim dubbels(dt.Rows.Count) As String
        Dim i As Integer = 1

        Me.ddlKleur.Items.Add(New ListItem(a.autoKleur))
        dubbels(0) = a.autoKleur

        For Each auto As Autos.tblAutoRow In dt

            'Even nakijken of deze kleur al in de dropdown zit.
            Dim isDubbel As Boolean = False
            For Each waarde In dubbels
                If (auto.autoKleur = waarde) Then
                    isDubbel = True
                End If
            Next waarde

            If (Not isDubbel) Then
                Me.ddlKleur.Items.Add(New ListItem(auto.autoKleur))
                dubbels(i) = auto.autoKleur
                i = i + 1
            End If

        Next auto

    End Sub

    Private Sub VulOpties(ByRef a As Autos.tblAutoRow, ByRef r As Reservaties.tblReservatieRow)
        Dim autobll As New AutoBLL
        Dim optiebll As New OptieBLL
        Dim merkbll As New MerkBLL

        Dim filterOpties(50) As String
        filterOpties(0) = a.categorieID
        filterOpties(1) = Me.ddlKleur.Text
        filterOpties(2) = merkbll.GetMerkByModelID(a.modelID).Rows(0).Item("merkID").ToString

        Dim optiedt As Autos.tblOptieDataTable = optiebll.GetAllOptiesByAutoID(a.autoID)

        Dim beschikbareoptiedt As Autos.tblOptieDataTable = optiebll.GetBeschikbareOptiesBy(filterOpties)

        'Deze array duidt aan welke opties zijn geselecteerd
        Dim geselecteerdeOpties(optiedt.Rows.Count + beschikbareoptiedt.Rows.Count) As Boolean

        'Deze datatable gebruiken we om te checken dat er geen dubbels inzitten
        Dim optieAanboddt As New Autos.tblOptieDataTable
        Dim i As Integer = 0

        'Opties van de huidige auto ophalen
        For Each optie As Autos.tblOptieRow In optiedt
            optieAanboddt.ImportRow(optie)
            geselecteerdeOpties(i) = True
            i = i + 1
        Next

        'Alle andere beschikbare opties toevoegen
        For Each optie As Autos.tblOptieRow In beschikbareoptiedt

            'Even nakijken of we deze optie reeds hebben
            Dim isDubbel As Boolean = False
            For Each o As Autos.tblOptieRow In optieAanboddt
                If (optie.optieOmschrijving = o.optieOmschrijving) Then
                    isDubbel = True
                End If
            Next o

            If (Not isDubbel) Then
                optieAanboddt.ImportRow(optie)
                geselecteerdeOpties(i) = False
                i = i + 1
            End If

        Next optie

        'Even checken of er wel opties beschikbaar zijn
        If (optieAanboddt.Rows.Count = 0) Then
            Dim label As New Label
            label.Text = "Er zijn geen opties beschikbaar."
            Dim tr As New HtmlGenericControl("tr")
            Dim td As New HtmlGenericControl("td")
            td.Attributes.Add("colspan", "2")
            td.Controls.Add(label)
            tr.Controls.Add(td)
            Me.plcOpties.Controls.Add(tr)
            Return
        End If

        'Optielijst samenstellen
        Dim optiekosten As Double = 0
        i = 0

        For Each optie As Autos.tblOptieRow In optieAanboddt
            Dim tr As New HtmlGenericControl("tr")

            Dim tdlinks As New HtmlGenericControl("td")
            Dim optievink As New CheckBox
            optievink.Checked = geselecteerdeOpties(i)
            optievink.ID = String.Concat("chkOptie", i)
            optievink.Text = optie.optieOmschrijving

            Dim tdrechts As New HtmlGenericControl("td")
            Dim optiekost As New Label
            optiekost.Text = optie.optieKost.ToString
            optiekosten = optie.optieKost

            tdlinks.Controls.Add(optievink)
            tdrechts.Controls.Add(optiekost)
            tr.Controls.Add(tdlinks)
            tr.Controls.Add(tdrechts)
            Me.plcOpties.Controls.Add(tr)

            i = i + 1
        Next optie

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Request.QueryString("resData") IsNot Nothing) Then

            Try
                Dim strings() As String = Request.QueryString("resData").Split(",")
                ViewState("resID") = Convert.ToInt32(strings(0))
                ViewState("autoID") = Convert.ToInt32(strings(1))
                MaakOverzicht()
            Catch ex As Exception
                Me.updReservatieWijzigen.Visible = False
                Me.lblOngeldigID.Text = "Ongeldig ID."
                Return
            End Try

        Else

            If (ViewState("resID") = 0 Or ViewState("autoID") = 0) Then
                Me.updReservatieWijzigen.Visible = False
                Me.lblOngeldigID.Text = "Ongeldig ID."
                Return
            Else
                MaakOverzicht()
            End If


        End If

    End Sub

    Protected Sub btnBevestigen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBevestigen.Click
        Dim autobll As New AutoBLL
        Dim reservatiebll As New ReservatieBLL
        Dim merkbll As New MerkBLL



        Dim autoID, resID, categorieID, modelID As Integer
        resID = ViewState("resID")
        autoID = ViewState("autoID")
        categorieID = ViewState("categorieID")
        modelID = ViewState("modelID")

        Dim merkID = merkbll.GetMerkByModelID(modelID).Rows(0).Item("merkID")

        'Deze reservatie ophalen
        Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(resID).Rows(0)

        Dim bezoekendeklant As New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())

        'Even valideren of de querystring niet ongeldig is
        If (Not r.autoID = autoID Or _
            Not r.userID.ToString = bezoekendeklant.ToString) Then
            Me.updReservatieWijzigen.Visible = False
            Me.lblOngeldigID.Text = "Ongeldig ID."
            Return
        End If

        Dim filterOpties(50) As String
        filterOpties(0) = categorieID
        filterOpties(1) = Me.ddlKleur.SelectedValue
        filterOpties(2) = merkID



        'Extra opties ophalen
        For i As Integer = 20 To 39
            Dim controlnaam As String = String.Concat("ctl00$plcMain$PaneOpties_content$chkOptie", i - 20)
            If (TryCast(Me.FindControl(controlnaam), CheckBox) IsNot Nothing) Then

                Dim control As CheckBox = CType(Me.FindControl(controlnaam), CheckBox)
                If control.Checked Then filterOpties(i) = control.Text

            End If
        Next

        Dim begindat As Date = Date.Parse(Me.txtBegindatum.Text)
        Dim einddat As Date = Date.Parse(Me.txtEinddatum.Text)


        'Haal de gegevens van alle beschikbare auto's op volgens de filteropties
        Dim beschikbareautosdt As Autos.tblAutoDataTable = autobll.GetBeschikbareAutosBy(begindat, einddat, filterOpties)

        'Kijk na of de gewenste datum in onze huidige datum ligt. Zoja, dan is de huidige auto ook een geldige optie.
        Dim ligtTussenHuidigeReservatie = False
        If begindat >= r.reservatieBegindat Then
            If begindat <= r.reservatieEinddat Then
                If einddat >= r.reservatieBegindat Then
                    If einddat <= r.reservatieEinddat Then
                        ligtTussenHuidigeReservatie = True
                    End If
                End If
            End If
        End If

        If (ligtTussenHuidigeReservatie) Then
            'Haal deze auto op en voeg hem toe
            Dim dezeauto As Autos.tblAutoRow = autobll.GetAutoByAutoID(autoID).Rows(0)
            beschikbareautosdt.ImportRow(dezeauto)
        End If

        If (beschikbareautosdt.Rows.Count = 0) Then
            Me.lblOngeldigID.Text = "Er konden geen beschikbare auto's gevonden worden die aan uw voorwaarden voldeden."
        End If

        'Geef auto's weer in een repeater
        'Toon aan welke auto de huidige auto is

        'Laat de gebruiker een auto selecteren
        'Insert de nieuwe reservatie
        'Als dat lukt, verwijder de oude reservatie

        
    End Sub

    Private Sub MaakOverzicht()
        If (User.Identity.IsAuthenticated) Then
            Dim autoID, resID As Integer
            resID = ViewState("resID")
            autoID = ViewState("autoID")

            Dim reservatiebll As New ReservatieBLL

            'Deze reservatie ophalen
            Dim r As Reservaties.tblReservatieRow = reservatiebll.GetReservatieByReservatieID(resID).Rows(0)

            Dim bezoekendeklant As New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())

            'Even valideren of de querystring niet ongeldig is
            If (Not r.autoID = autoID Or _
                Not r.userID.ToString = bezoekendeklant.ToString) Then
                Me.updReservatieWijzigen.Visible = False
                Me.lblOngeldigID.Text = "Ongeldig ID."
                Return
            End If

            'Overzicht maken
            Dim autobll As New AutoBLL

            'De auto van deze reservatie ophalen
            Dim a As Autos.tblAutoRow = autobll.GetAutoByAutoID(r.autoID).Rows(0)

            'Enkele belangrijke elementen in Viewstate opslaan
            ViewState("categorieID") = a.categorieID
            ViewState("modelID") = a.modelID

            'Algemene kenmerken vullen
            Me.lblMerkModel.Text = autobll.GetAutoNaamByAutoID(r.autoID)
            Me.imgFoto.Attributes.Add("src", String.Concat("~\App_Presentation\AutoFoto.ashx?autoID=", r.autoID))

            'panePeriode vullen
            Me.lblPeriode.Text = String.Concat(Format(r.reservatieBegindat, "dd/MM/yyyy"), " - ", Format(r.reservatieEinddat, "dd/MM/yyyy"))

            If (Not IsPostBack) Then
                Me.txtBegindatum.Text = Format(r.reservatieBegindat, "dd/MM/yyyy")
                Me.txtEinddatum.Text = Format(r.reservatieEinddat, "dd/MM/yyyy")
            End If


            'paneKleur vullen
            VulKleurDDL(a, r)
            Me.lblKleur.Text = a.autoKleur

            'paneOpties vullen
            VulOpties(a, r)
        End If
    End Sub
End Class
