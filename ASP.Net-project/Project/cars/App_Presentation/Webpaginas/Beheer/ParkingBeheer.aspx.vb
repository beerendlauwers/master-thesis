
Partial Class App_Presentation_Webpaginas_FiliaalBeheer
    Inherits System.Web.UI.Page
    Protected PostBackString As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Deze string wordt gebruikt in de ASPX-pagina om wat JavaScript code te genereren.
        PostBackString = Page.ClientScript.GetPostBackEventReference(Me, "VeranderKleur")

        If (Not IsPostBack) Then
            'We hebben een querystring meegekregen voor de nieuwe rijen.
            If (Request.QueryString("kol") IsNot Nothing And _
                Request.QueryString("rij") IsNot Nothing) Then
                Try
                    Me.txtKolommen.Text = Convert.ToInt32(Request.QueryString("kol"))
                    Me.txtRijen.Text = Convert.ToInt32(Request.QueryString("rij"))
                Catch
                End Try
            End If
        End If

        MaakOverzichtVanTekstvelden()

        'Doorheen alle postback-keys gaan en kijken of er een button tussenzit
        'die in onze PlaceHolder zit. Indien ja, dan veranderen we de kleur.
        For i As Integer = 1 To Page.Request.Form.Keys.Count - 1
            Dim str As String = Page.Request.Form.Keys(i)

            If str.Contains("ctl00$plcMain$btn_") Then
                Dim control As String = str.Substring(str.IndexOf("ctl00$plcMain$"))
                control = control.Remove(control.Length - 2)
                Dim button As ImageButton = Page.FindControl(control)
                VeranderKleur(button)
                Return
            End If
        Next

    End Sub

#Region "Parkinglayout generatiecode"

    Private Sub MaakParkingLayoutOverzicht(ByRef parkeermatrix(,) As Integer)

        Dim kolommen() As String = MaakKolommenAan()

        Dim aantalkolommen As Integer = parkeermatrix.GetUpperBound(0)
        Dim aantalrijen As Integer = parkeermatrix.GetUpperBound(1)

        Dim table As New HtmlGenericControl("table")

        'Vul de kolomheaders in van de tabel.
        table.Controls.Add(MaakKolomHeaders(kolommen, aantalkolommen))

        'Eigenlijke vakken invullen.
        Dim i As Integer = 0
        Dim j As Integer = 0

        While i < aantalrijen
            Dim tablerow As New HtmlGenericControl("tr")

            'Header van de rij toevoegen.
            tablerow.Controls.Add(MaakRijHeader(i))

            'Eigenlijke vakjes toevoegen.
            While j < aantalkolommen

                tablerow.Controls.Add(MaakVakje(i, j, parkeermatrix))
                j = j + 1
            End While

            table.Controls.Add(tablerow)
            i = i + 1
            j = 0
        End While

        plcParkingLayout.Controls.Add(table)

    End Sub

    Private Function MaakVakje(ByVal i As Integer, ByVal j As Integer, ByRef parkeermatrix(,) As Integer) As HtmlGenericControl
        Dim tabledata As New HtmlGenericControl("td")
        Dim button As New ImageButton()

        With button
            .ID = String.Concat("btn_", i, "_", j)
            .OnClientClick = "VeranderKleur"
            .Attributes.Add("class", "art-vakje-ParkingBeheer")
            .BackColor = Drawing.Color.Gray
            .Height = 16
            .Width = 16
        End With

        Dim waarde As Integer = parkeermatrix(j, i)
        If waarde = 0 Then
            button.ImageUrl = "~/App_Presentation/Images/parkeerplaats.png"
        ElseIf waarde = 1 Then
            button.ImageUrl = "~/App_Presentation/Images/rijweg.png"
        ElseIf waarde = 2 Then
            button.ImageUrl = "~/App_Presentation/Images/house.png"
        ElseIf waarde = 4 Then
            button.ImageUrl = "~/App_Presentation/Images/spacer.gif"
        Else
            button.ImageUrl = "~/App_Presentation/Images/spacer.gif"
        End If

        tabledata.Controls.Add(button)
        tabledata.Attributes.Add("align", "center")

        'Met deze hoop viewstate-variabelen kunnen we het meest recente overzicht opslaan.
        ViewState(button.ID) = waarde

        Return tabledata
    End Function

    Private Function MaakRijHeader(ByVal i As Integer) As HtmlGenericControl

        Dim rijheader As New HtmlGenericControl("th")
        Dim headerlabel As New Label()

        headerlabel.Text = i + 1
        rijheader.Controls.Add(headerlabel)
        rijheader.Attributes.Add("align", "center")

        Return rijheader
    End Function

    Private Function MaakKolomHeaders(ByVal kolommen() As String, ByVal aantalkolommen As Integer) As HtmlGenericControl

        Dim headerrow As New HtmlGenericControl("tr")

        'Ongebruikt vakje linksboven
        headerrow.Controls.Add(New HtmlGenericControl("th"))

        '<th> tag toevoegen voor elke kolom
        Dim i As Integer = 0
        While i < aantalkolommen

            Dim kolomheader As New HtmlGenericControl("th")
            Dim headerlabel As New Label()

            headerlabel.Text = kolommen(i)
            kolomheader.Controls.Add(headerlabel)
            kolomheader.Attributes.Add("align", "center")
            headerrow.Controls.Add(kolomheader)

            i = i + 1
        End While

        Return headerrow
    End Function

    Private Function MaakKolommenAan() As String()
        Dim beginkolommen() As String = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
        Dim totaalkolommen(675) As String

        Dim i As Integer = 0
        For Each letter In beginkolommen
            For Each tweedeletter In beginkolommen
                totaalkolommen(i) = String.Concat(letter, tweedeletter)
                i = i + 1
            Next
        Next

        Return totaalkolommen
    End Function

#End Region

#Region "Parkinglayout opslaan code"

    Protected Sub btnLayoutOpslaan_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLayoutOpslaan.Click

        MaakOverzichtVanTekstvelden()

        Dim aantalkolommen As Integer = Convert.ToInt32(Me.txtKolommen.Text)
        Dim aantalrijen As Integer = Convert.ToInt32(Me.txtRijen.Text)

        Dim i As Integer = 0
        Dim j As Integer = 0
        While i < aantalrijen
            While j < aantalkolommen

                Try
                    Dim buttonnaam As String = String.Concat("btn_", i, "_", j)
                    InsertInDatabase(ViewState(buttonnaam), i, j)
                Catch ex As Exception

                End Try


                j = j + 1
            End While

            i = i + 1
            j = 0
        End While

        Dim filiaalbll As New FiliaalBLL
        Dim f As Autos.tblFiliaalRow = filiaalbll.GetFiliaalByFiliaalID(Me.ddlFiliaal.SelectedValue).Rows(0)

        f.parkingAantalKolommen = aantalkolommen
        f.parkingAantalRijen = aantalrijen

        filiaalbll.UpdateFiliaal(f)
    End Sub

    Private Sub InsertInDatabase(ByRef type As Integer, ByVal rij As Integer, ByVal kolom As Integer)
        Dim dt As New Autos.tblParkeerPlaatsDataTable
        Dim p As Autos.tblParkeerPlaatsRow = dt.NewRow

        p.filiaalID = Me.ddlFiliaal.SelectedValue
        p.parkeerPlaatsKolom = kolom
        p.parkeerPlaatsRij = rij

        p.parkeerPlaatsType = type

        Dim parkeerbll As New ParkeerBLL

        Dim filiaalID As Integer = ViewState("filiaalID")
        Dim row As Autos.tblParkeerPlaatsRow = parkeerbll.GetParkeerPlaatsByRijKolomFiliaalID(filiaalID, rij, kolom)

        If (row Is Nothing) Then 'Deze rij bestaat nog niet.
            parkeerbll.InsertParkeerPlaats(p)
        Else 'Deze rij bestaat reeds! We moeten hem updaten.
            p.parkeerPlaatsID = row.parkeerPlaatsID
            parkeerbll.UpdateParkeerPlaats(p)
        End If

        parkeerbll = Nothing
    End Sub

#End Region

#Region "Parkinglayout Controlcode"

    Private Sub VeranderKleur(ByRef button As ImageButton)
        Dim waarde As Integer = -1

        If button.ImageUrl = "~/App_Presentation/Images/parkeerplaats.png" Then
            button.ImageUrl = "~/App_Presentation/Images/rijweg.png"
            waarde = 1
        ElseIf button.ImageUrl = "~/App_Presentation/Images/rijweg.png" Then
            button.ImageUrl = "~/App_Presentation/Images/house.png"
            waarde = 2
        ElseIf button.ImageUrl = "~/App_Presentation/Images/house.png" Then
            button.ImageUrl = "~/App_Presentation/Images/spacer.gif"
            waarde = 4
        Else
            button.ImageUrl = "~/App_Presentation/Images/parkeerplaats.png"
            waarde = 0
        End If

        ViewState(button.ID) = waarde
    End Sub

    Protected Sub btnMaakLayout_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMaakLayout.Click
        Dim filiaalId As Integer = Me.ddlFiliaal.SelectedValue
        Dim kolommen As Integer = Me.txtKolommen.Text
        Dim rijen As Integer = Me.txtRijen.Text
        Dim redirectstring As String
        redirectstring = String.Concat("ParkingBeheer.aspx?filiaalID=", filiaalId, "&kol=", kolommen, "&rij=", rijen)
        Response.Redirect(redirectstring)

    End Sub

    Protected Sub ddlFiliaal_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlFiliaal.DataBound

        'We hebben een querystring meegekregen.
        If (Request.QueryString("filiaalID") IsNot Nothing) Then
            Try
                Dim filiaalID As Integer = Request.QueryString("filiaalID")


                For i As Integer = 0 To ddlFiliaal.Items.Count - 1
                    If (Me.ddlFiliaal.Items(i).Value = filiaalID) Then
                        Me.ddlFiliaal.Items(i).Selected = True
                    Else
                        Me.ddlFiliaal.Items(i).Selected = False
                    End If
                Next

            Catch
                Return
            End Try
        End If

        MaakOverzichtVanDatabase()
    End Sub

    Protected Sub ddlFiliaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlFiliaal.SelectedIndexChanged
        Response.Redirect("ParkingBeheer.aspx?filiaalID=" + Me.ddlFiliaal.SelectedValue)
    End Sub

#End Region

#Region "Parkinglayout databasecommunicatiecode"

    Private Sub MaakOverzichtVanDatabase()
        Dim filiaalbll As New FiliaalBLL
        Dim f As Autos.tblFiliaalRow = filiaalbll.GetFiliaalByFiliaalID(Me.ddlFiliaal.SelectedValue).Rows(0)
        filiaalbll = Nothing

        ViewState("filiaalID") = f.filiaalID

        'We hebben een querystring meegekregen voor de nieuwe rijen.
        If (Request.QueryString("kol") IsNot Nothing And _
            Request.QueryString("rij") IsNot Nothing) Then
            Try
                Me.txtKolommen.Text = Convert.ToInt32(Request.QueryString("kol"))
                Me.txtRijen.Text = Convert.ToInt32(Request.QueryString("rij"))
            Catch
                Me.txtKolommen.Text = f.parkingAantalKolommen
                Me.txtRijen.Text = f.parkingAantalRijen
            End Try
        Else
            Me.txtKolommen.Text = f.parkingAantalKolommen
            Me.txtRijen.Text = f.parkingAantalRijen

        End If

        ViewState("aantalKolommenDB") = Me.txtKolommen.Text
        ViewState("aantalRijenDB") = Me.txtRijen.Text

        'Als we parameters via de querystring hebben gekregen, 
        If (Request.QueryString("kol") IsNot Nothing And _
             Request.QueryString("rij") IsNot Nothing) Then
            MaakOverzichtVanTekstvelden()
            Return
        End If

        If (f.parkingAantalKolommen = 0 And f.parkingAantalRijen = 0) Then
            Me.lblGeenData.Text = "Deze filiaal heeft nog geen parkeeroverzicht. Gebruik bovenstaande tekstvelden om een ruwe vorm van uw parking te benaderen. Hierna kan u op de icoontjes klikken om deze ruwe vorm verder aan te passen."
            Me.btnMaakLayout.Text = "Layout aanmaken"

        Else
            Me.lblGeenData.Text = "Gebruik bovenstaande tekstvelden om een ruwe vorm van uw parking te benaderen. Hierna kan u op de icoontjes klikken om deze ruwe vorm verder aan te passen."
            Me.btnMaakLayout.Text = "Layout aanpassen"

            'Haal alles van DB binnen
            Dim parkeermatrix(,) As Integer = HaalParkingOpVanFiliaal(f.filiaalID, Me.txtKolommen.Text, Me.txtRijen.Text)

            'Maak Overzicht
            MaakParkingLayoutOverzicht(parkeermatrix)

        End If
    End Sub

    Private Sub MaakOverzichtVanTekstvelden()

        'Deze functie werkt enkel als er reeds enkele ViewState-velden werden
        'ingevuld.
        If (ViewState("filiaalID") IsNot Nothing And ViewState("aantalKolommenDB") IsNot Nothing And ViewState("aantalRijenDB") IsNot Nothing) Then

            Dim filiaalID As Integer = ViewState("filiaalID")
            Dim aantalkolommen As Integer = Me.txtKolommen.Text
            ViewState("aantalKolommen") = aantalkolommen
            Dim aantalrijen As Integer = Me.txtRijen.Text
            ViewState("aantalRijen") = aantalrijen

            'We maken een parkeermatrix aan van het meest recente overzicht.
            Dim parkeermatrix(Me.txtKolommen.Text, Me.txtRijen.Text) As Integer

            For rij As Integer = 0 To Me.txtRijen.Text - 1
                For kolom As Integer = 0 To Me.txtKolommen.Text - 1
                    Dim viewstatestring As String = String.Concat("btn_", rij, "_", kolom)
                    Try
                        parkeermatrix(kolom, rij) = ViewState(viewstatestring)
                    Catch ex As Exception
                        parkeermatrix(kolom, rij) = 0
                    End Try
                Next
            Next

            'Maak Overzicht
            MaakParkingLayoutOverzicht(parkeermatrix)
        End If

    End Sub

    Private Function HaalParkingOpVanFiliaal(ByVal filiaalID As Integer, ByVal aantalKolommen As Integer, ByVal aantalRijen As Integer) As Integer(,)
        Dim parkeerbll As New ParkeerBLL
        Dim kolomdt As Data.DataTable = parkeerbll.GetParkeerPlaatsKolommenByFiliaalID(filiaalID)
        Dim parkeerdt As Autos.tblParkeerPlaatsDataTable = parkeerbll.GetParkeerPlaatsenByFiliaalID(filiaalID)
        Dim parkeermatrix(aantalKolommen, aantalRijen) As Integer

        'Opsplitsen in kolommen en rijen
        For kolom As Integer = 0 To aantalKolommen - 1
            Dim filteredview As Data.DataView = parkeerdt.DefaultView
            filteredview.RowFilter = String.Concat("parkeerPlaatsKolom = ", kolomdt.Rows(kolom).Item(0).ToString.Trim)

            Dim filtereddt As Data.DataTable = filteredview.ToTable

            For rij As Integer = 0 To aantalRijen - 1
                parkeermatrix(kolomdt.Rows(kolom).Item(0), rij) = filtereddt.Rows(rij).Item("parkeerPlaatsType")
            Next

        Next

        Return parkeermatrix

    End Function

#End Region

End Class
