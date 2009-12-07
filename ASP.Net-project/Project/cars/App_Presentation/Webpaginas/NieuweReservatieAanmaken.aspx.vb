Imports System.Data
Imports Subgurim.Controles

Partial Class App_Presentation_NieuweReservatieAanmaken
    Inherits System.Web.UI.Page


    Private Sub BezetGMAP()

        Dim filiaalnr As Int32 = 0
        Dim autorow As Int32 = 0
        Dim blnadd As Boolean = False

        Dim Adres As String

        Dim BLLFiliaal As New FiliaalBLL
        Dim DTFiliaal As New Autos.tblFiliaalDataTable

        'gmap variabelen
        Dim GeoCode As GeoCode
        Dim MapKey As String = ConfigurationManager.AppSettings("googlemaps.subgurim.net")

        Dim marker As GMarker
        Dim markopts As GMarkerOptions

        Dim window As GInfoWindow
        Dim winopts As GInfoWindowOptions


        DTFiliaal = BLLFiliaal.GetAllFilialen


        Dim row As Autos.tblFiliaalRow

        ' geneste lus: filialen aflopen
        For Each row In DTFiliaal
            Adres = row.filiaalLocatie

            ' geocoding
            GeoCode = GMap.geoCodeRequest(Adres, MapKey)

            'marker plaatsen
            markopts = New GMarkerOptions
            markopts.title = Adres

            marker = New GMarker(New GLatLng(GeoCode.Placemark.coordinates.lat, GeoCode.Placemark.coordinates.lng), markopts)
            'GMap1.setCenter(marker.point)
            Dim beschikbareautos As DataTable = GeefBeschikbareAutosOpFiliaal(row.filiaalID)

            Dim htmlstring As String = "<html><body><h4>" + row.filiaalNaam + "</h4><hr /><br /><table style='width:100%'>"
            ' auto's vergelijken met filID en htmlstring opvullen





            For autorow = 0 To beschikbareautos.Rows.Count - 1

                If Not beschikbareautos(autorow).Item("Naam") = String.Empty Then
                    htmlstring = htmlstring + "<tr><td>" + beschikbareautos(autorow).Item("Naam") + "</td><td><a href='http://www.google.be'>Reserveren</a></td></tr>"
                    blnadd = True
                End If

            Next

            If blnadd = True Then 'indien row niet leeg

                htmlstring = htmlstring + "</table><br /></body></html>"

                'infowindow plaatsen (met htmlstring)
                window = New GInfoWindow(marker, htmlstring, True)
                winopts = New GInfoWindowOptions(Adres, htmlstring)
                window.options = winopts

                ' markers/windows toekennen
                With Gmap1
                    .addGMarker(marker)
                    .addInfoWindow(window)
                End With
            End If

            blnadd = False

        Next




    End Sub

    Private Function MaakOverzichtsTabel(ByRef datatable As Autos.tblAutoDataTable) As DataTable
        Try

            'Als er niks instaat, gaan we geen moeite doen.
            If (datatable.Rows.Count = 0) Then
                Dim dt As New DataTable
                Return dt
            End If

            'Alles overkopiëren en basisgegevens ophalen
            Dim basistabel As DataTable = PrepareerBasisTabel(datatable)

            'MsgBox(basistabel.Rows.Item(0).ToString)

            'Alles ordenen op automerk en -model
            Dim dv As Data.DataView = basistabel.DefaultView
            dv.Sort = "autoMerkModel ASC"

            'En terug opslaan in een ongesorteerde datatable
            Dim unsorteddt As Data.DataTable = dv.ToTable

            'Nu gaan we de gesorteerde datatable opmaken. Hij ziet er zo uit:
            ' Naam              | Aantal
            ' BMW 6 Series        3
            ' Audi TT Coupe       2
            ' Audi S5             1
            Dim sorteddt As DataTable = SorteerEnGroepeerTabel(unsorteddt)

            'Terug ordenen op aantal en naam
            Dim sorteerdv As Data.DataView = sorteddt.DefaultView
            sorteerdv.Sort = "Aantal DESC, Naam DESC"

            'En terugsturen.
            Return sorteerdv.ToTable

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Private Function PrepareerBasisTabel(ByRef dt As Autos.tblAutoDataTable) As DataTable
        Dim overzichtdatatable As New DataTable
        Dim overzichtcolumn As New DataColumn
        Dim overzichtrow As DataRow

        'Kolommen van originele tabel overkopiëren
        Dim columnnaam As String = String.Empty
        Dim columntype As System.Type
        For i As Integer = 0 To dt.Columns.Count - 1
            columnnaam = dt.Columns(i).ColumnName
            columntype = dt.Columns(i).DataType
            overzichtdatatable.Columns.Add(columnnaam, columntype)
        Next

        'Eigen kolommen toevoegen
        overzichtdatatable.Columns.Add("autoMerkModel", Type.GetType("System.String"))
        overzichtdatatable.Columns.Add("begindat", Type.GetType("System.DateTime"))
        overzichtdatatable.Columns.Add("einddat", Type.GetType("System.DateTime"))

        'Data overzetten
        Dim autobll As New AutoBLL
        Dim dtrow As Data.DataRow

        For i As Integer = 0 To dt.Rows.Count - 1
            dtrow = dt.Rows(i)
            overzichtrow = overzichtdatatable.NewRow()

            overzichtrow("modelID") = dtrow.Item("modelID")
            overzichtrow("autoID") = dtrow.Item("autoID")
            overzichtrow("autoMerkModel") = autobll.GetAutoNaamByAutoID(dtrow.Item("autoID"))
            overzichtrow("begindat") = Date.Parse(Me.txtBegindatum.Text)
            overzichtrow("einddat") = Date.Parse(Me.txtEinddatum.Text)
            overzichtrow("filiaalID") = dtrow.Item("filiaalID")

            overzichtdatatable.Rows.Add(overzichtrow)
        Next

        Return overzichtdatatable
    End Function

    Private Function SorteerEnGroepeerTabel(ByRef unsorteddt As DataTable) As DataTable
        Dim unsortedrow As Data.DataRow

        Dim sorteddt As New Data.DataTable
        sorteddt.Columns.Add("modelID", Type.GetType("System.Int32"))
        sorteddt.Columns.Add("autoID", Type.GetType("System.Int32"))
        sorteddt.Columns.Add("Naam", Type.GetType("System.String"))
        sorteddt.Columns.Add("Aantal", Type.GetType("System.Int32"))
        sorteddt.Columns.Add("begindat", Type.GetType("System.DateTime"))
        sorteddt.Columns.Add("einddat", Type.GetType("System.DateTime"))

        Dim sortedrow As Data.DataRow = sorteddt.NewRow
        sortedrow.Item("Aantal") = 0

        'Deze variabele gebruiken we om modelnaam in bij te houden.
        'Op die manier kunnen we reeksen auto's differentiëren.
        Dim vorigModel As String = unsorteddt.Rows(0).Item("autoMerkModel")
        Dim huidigModel As String = String.Empty

        Dim vorigerij As DataRow = unsorteddt.NewRow
        vorigerij = unsortedrow

        'Voor elke rij in de niet-gesorteerde tabel, gaan we hierdoor gaan
        For rownr As Integer = 0 To unsorteddt.Rows.Count - 1

            'Niet-gesorteerde rij ophalen
            unsortedrow = unsorteddt.Rows(rownr)
            huidigModel = unsortedrow.Item("autoMerkModel")

            If (vorigModel = huidigModel) Then
                sortedrow.Item("Aantal") = sortedrow.Item("Aantal") + 1
            Else

                'Rij toevoegen
                sorteddt = RijToevoegen(sorteddt, sortedrow, vorigerij, vorigModel)

                'Nieuwe gesorteerde rij klaarzetten
                sortedrow = sorteddt.NewRow
                sortedrow.Item("Aantal") = 0

                'Nieuwe model selecteren
                vorigModel = huidigModel

                'Dit model bestaat reeds 1 keer!
                sortedrow.Item("Aantal") = 1
            End If

            'Gegevens van huidige ongesorteerde rij in vorigerij steken
            vorigerij = unsortedrow

            'Als dit de laatste rij van de ongesorteerde tabel is, slaan we hem op.
            If (rownr + 1 > unsorteddt.Rows.Count - 1) Then
                sorteddt = RijToevoegen(sorteddt, sortedrow, vorigerij, vorigModel)
            End If

        Next

        Return sorteddt
    End Function

    Private Function RijToevoegen(ByRef dt As DataTable, ByRef srow As DataRow, ByRef vrow As DataRow, ByVal merk As String) As DataTable

        If (srow.Item("Aantal") > 0) Then
            srow.Item("modelID") = vrow.Item("modelID")
            srow.Item("autoID") = vrow.Item("autoID")
            srow.Item("begindat") = vrow.Item("begindat")
            srow.Item("einddat") = vrow.Item("einddat")

            srow.Item("Naam") = merk

            dt.Rows.Add(srow)
        End If

        Return dt
    End Function

    Private Sub ChangeOverView()

        Try
            Dim FiliaalCookie As HttpCookie
            FiliaalCookie = Request.Cookies("filcookie")

            Dim filiaal As String = String.Empty
            If FiliaalCookie IsNot Nothing Then
                filiaal = FiliaalCookie.Value
            End If

            Dim dt As DataTable = GeefBeschikbareAutosOpFiliaal(filiaal)

            If (dt.Rows.Count > 0) Then
                lblGeenAutos.Visible = False
                repOverzicht.DataSource = dt
                BezetGMAP()
            Else
                'BezetGMAP()
                repOverzicht.DataSource = Nothing
                lblGeenAutos.Text = "Er zijn geen auto's die aan uw zoekvoorwaarden voldoen."
                lblGeenAutos.Visible = True
            End If
        Catch ex As Exception
            Throw ex
        End Try



        repOverzicht.DataBind()

    End Sub

    Private Function GeefBeschikbareAutosOpFiliaal(ByVal filiaal As String) As DataTable

        Dim dt As New Data.DataTable

        'Haal argumenten uit form
        Dim categorie As String = Me.ddlCategorie.SelectedValue

        Dim begindatum As Date = Me.txtBegindatum.Text
        Dim einddatum As Date = Me.txtEinddatum.Text
        Dim kleur As String = Me.ddlKleur.SelectedItem.Text
        Dim merk As String = Me.ddlMerk.SelectedValue
        Dim prijsmin As String = Me.txtPrijsMin.Text
        Dim prijsmax As String = Me.txtPrijsMax.Text


        'ff valideren
        Dim geenfouteninpagina As Boolean = True
        lblCategorieVerkeerd.Text = String.Empty
        lblDatumVerkeerd.Text = String.Empty

        If (categorie = String.Empty) Then
            lblDatumVerkeerd.ForeColor = Drawing.Color.Red
            lblCategorieVerkeerd.Text = "U dient een geldige categorie op te geven."
            geenfouteninpagina = False
        End If

        If (begindatum > einddatum) Then
            lblDatumVerkeerd.ForeColor = Drawing.Color.Red
            lblDatumVerkeerd.Text = "De begindatum kan niet later vallen dan de einddatum."
            geenfouteninpagina = False
        End If

        If (begindatum = einddatum) Then
            lblDatumVerkeerd.ForeColor = Drawing.Color.Red
            lblDatumVerkeerd.Text = "De minimale reservatietermijn is 1 dag."
            geenfouteninpagina = False
        End If

        If (geenfouteninpagina) Then
            Try
                'Zet array met filteropties in elkaar
                Dim filterOpties(50) As String
                filterOpties(0) = categorie
                filterOpties(1) = kleur
                filterOpties(2) = merk
                filterOpties(3) = filiaal
                'brandstoftype = filterOpties(4)
                filterOpties(5) = prijsmin
                filterOpties(6) = prijsmax

                'Extra opties ophalen
                For i As Integer = 20 To 39
                    Dim controlnaam As String = String.Concat("ctl00$plcMain$chkOptie", i - 20)
                    If (TryCast(Me.FindControl(controlnaam), CheckBox) IsNot Nothing) Then

                        Dim control As CheckBox = CType(Me.FindControl(controlnaam), CheckBox)
                        If control.Checked Then filterOpties(i) = control.Text

                    End If
                Next

                'Haal datatable op met argumenten
                Dim autobll As New AutoBLL
                Dim datatable As Autos.tblAutoDataTable = autobll.GetBeschikbareAutosBy(begindatum, einddatum, filterOpties)

                'Verwerk datatable tot overzichtsdatatable
                dt = MaakOverzichtsTabel(datatable)



            Catch ex As Exception
                Throw ex
            End Try
        End If

        Return dt

    End Function

    Protected Sub btnToonOverzicht_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnToonOverzicht.Click
        ChangeOverView()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        MaakExtraOptieOverzicht()

        If (Not IsPostBack) Then
            If Request.QueryString("categorie") IsNot Nothing Then
                Try
                    Dim cat As Integer = CType(Request.QueryString("categorie"), Integer)
                    If cat = 1 Or cat = 2 Or cat = 3 Then
                        Me.ccdCategorie.SelectedValue = cat
                    End If
                Catch ex As Exception
                    Throw New Exception("Ongeldige categorie.")
                    Return
                End Try

            End If

            'Me.calBegindatum.SelectedDate = Now
            'Me.calEinddatum.SelectedDate = DateAdd(DateInterval.Day, 2, Now)

        End If

        'GMAP Instellingen
        With GMap1

            ' layout
            .Height = 400
            .Width = 700
            .setCenter(New GLatLng(51, 4), 7)
            .GZoom = 7
            .addGMapUI(New GMapUI())
            .enableHookMouseWheelToZoom = True

        End With

        'key inlezen vanuit web.conf <AppSettings/>
        Dim MapKey As String = ConfigurationManager.AppSettings("googlemaps.subgurim.net")


        'instellen begindatum

        txtBegindatum.Text = DateTime.Now.Date

    End Sub

    Private Sub MaakExtraOptieOverzicht()

        Dim table As New HtmlGenericControl("table")
        Dim i As Integer = 0
        Dim checkboxaantal As Integer = 0

        Dim optiebll As New OptieBLL
        Dim dt As New Autos.tblOptieDataTable
        Dim tr As New HtmlGenericControl("tr")
        dt = optiebll.GetAllOpties()
        For Each rij As Autos.tblOptieRow In dt

            If (i > 1) Then
                table.Controls.Add(tr)
                i = 0
                tr = New HtmlGenericControl("tr")
            End If

            Dim checkbox As New CheckBox
            checkbox.Text = rij.optieOmschrijving
            checkbox.ID = String.Concat("chkOptie", checkboxaantal.ToString)

            Dim td As New HtmlGenericControl("td")

            td.Controls.Add(checkbox)
            tr.Controls.Add(td)

            i = i + 1
            checkboxaantal = checkboxaantal + 1
        Next

        table.Controls.Add(tr)
        Me.plcExtraOpties.Controls.Add(table)
    End Sub


End Class
