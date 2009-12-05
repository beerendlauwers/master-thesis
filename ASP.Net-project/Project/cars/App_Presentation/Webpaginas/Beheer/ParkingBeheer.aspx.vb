
Partial Class App_Presentation_Webpaginas_FiliaalBeheer
    Inherits System.Web.UI.Page
    Protected PostBackString As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Deze string wordt gebruikt in de ASPX-pagina om wat JavaScript code te genereren.
        PostBackString = Page.ClientScript.GetPostBackEventReference(Me, "VeranderKleur")

        'Parkinglayout updaten
        If (Not Me.txtKolommen.Text = String.Empty And Not Me.txtRijen.Text = String.Empty) Then
            MaakParkingLayoutOverzicht()
        End If

        'Doorheen alle postback-keys gaan en kijken of er een button tussenzit
        'die in onze PlaceHolder zit. Indien ja, dan veranderen we de kleur.
        For i As Integer = 1 To Page.Request.Form.Keys.Count - 1
            Dim str As String = Page.Request.Form.Keys(i)

            If str.Contains("ctl00$plcMain$btn_") Then
                Dim control As String = str.Substring(str.IndexOf("ctl00$plcMain$"))
                Dim button As Button = Page.FindControl(control)
                VeranderKleur(button)
                Return
            End If
        Next

    End Sub

    Private Sub MaakParkingLayoutOverzicht()
        Dim kolommen() As String = MaakKolommenAan()

        Dim aantalkolommen As Integer
        Dim aantalrijen As Integer

        If IsPostBack Then
            aantalkolommen = Convert.ToInt32(Me.txtKolommen.Text)
            aantalrijen = Convert.ToInt32(Me.txtRijen.Text)
        Else
            Return
        End If

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

                tablerow.Controls.Add(MaakVakje(i, j))
                j = j + 1
            End While

            table.Controls.Add(tablerow)
            i = i + 1
            j = 0
        End While

        plcParkingLayout.Controls.Add(table)

    End Sub

    Private Function MaakVakje(ByVal i As Integer, ByVal j As Integer) As HtmlGenericControl
        Dim tabledata As New HtmlGenericControl("td")
        Dim button As New Button()

        With button
            .ID = String.Concat("btn_", i, "_", j)
            .OnClientClick = "VeranderKleur"
            .Attributes.Add("class", "art-vakje-ParkingBeheer")
            .BackColor = Drawing.Color.White
            .Height = 20
            .Width = 20
        End With

        tabledata.Controls.Add(button)
        tabledata.Attributes.Add("align", "center")

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

    Protected Sub btnMaakLayout_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnMaakLayout.Click
    End Sub

    Private Sub VeranderKleur(ByRef button As Button)
        If button.BackColor = Drawing.Color.White Then
            button.BackColor = Drawing.Color.Gray
        ElseIf button.BackColor = Drawing.Color.Gray Then
            button.BackColor = Drawing.Color.Black
        Else
            button.BackColor = Drawing.Color.White
        End If
    End Sub

    Protected Sub btnLayoutOpslaan_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLayoutOpslaan.Click
        Dim aantalkolommen As Integer = Convert.ToInt32(Me.txtKolommen.Text)
        Dim aantalrijen As Integer = Convert.ToInt32(Me.txtRijen.Text)

        Dim i As Integer = 0
        Dim j As Integer = 0
        While i < aantalrijen
            While j < aantalkolommen

                Dim buttonnaam As String = String.Concat("btn_", i, "_", j)
                If (TryCast(plcParkingLayout.FindControl(buttonnaam), Button) IsNot Nothing) Then
                    Dim button As Button = CType(plcParkingLayout.FindControl(buttonnaam), Button)
                    InsertInDatabase(button, i, j)
                End If

                j = j + 1
            End While

            i = i + 1
            j = 0
        End While

        Dim filiaalbll As New FiliaalBLL
        Dim f As Autos.tblFiliaalRow = filiaalbll.GetFiliaalByFiliaalID(Me.txtFiliaal.Text).Rows(0)

        f.parkingAantalKolommen = aantalkolommen
        f.parkingAantalRijen = aantalrijen

        filiaalbll.UpdateFiliaal(f)
    End Sub

    Private Sub InsertInDatabase(ByRef button As Button, ByVal rij As Integer, ByVal kolom As Integer)
        Dim dt As New Autos.tblParkeerPlaatsDataTable
        Dim p As Autos.tblParkeerPlaatsRow = dt.NewRow

        p.filiaalID = Me.txtFiliaal.Text
        p.parkeerPlaatsKolom = kolom
        p.parkeerPlaatsRij = rij

        Dim type As Integer
        If (button.BackColor = Drawing.Color.White) Then
            type = 256 'beschikbare ruimte
        ElseIf (button.BackColor = Drawing.Color.Gray) Then
            type = 512 'autoweg (van bedrijf)
        Else
            type = 1024 'geen bedrijfsruimte
        End If

        p.parkeerPlaatsType = type

        Dim parkeerbll As New ParkeerBLL
        parkeerbll.InsertParkeerPlaats(p)
        parkeerbll = Nothing
    End Sub
End Class
