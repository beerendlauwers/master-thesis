Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Presentation_Webpaginas_Beheer_AutoSchema
    Inherits System.Web.UI.Page

    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private myConnection As New SqlConnection(conn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Request.QueryString("autoID") IsNot Nothing Then
            Try
                Dim autoID As Integer = Convert.ToInt32(Request.QueryString("autoID"))

                ViewState("autoID") = autoID

                Dim autobll As New AutoBLL
                Dim a As Autos.tblAutoRow = autobll.GetAutoByAutoID(autoID).Rows(0)

                Me.lblAuto.Text = String.Concat(autobll.GetAutoNaamByAutoID(autoID), " (", a.autoKenteken, ")")

                If (Not IsPostBack) Then

                    Dim reservatiebll As New ReservatieBLL

                    'Alle reservaties van deze auto ophalen
                    Dim allereservaties As Reservaties.tblReservatieDataTable = reservatiebll.GetAllBevestigdeReservatiesByAutoID(autoID)

                    'Vul DDLKlant
                    VulKlantDropdown(allereservaties)
                    Me.ddlKlant.SelectedIndex = 0

                    'Filter op klant en opslaan
                    If Not Me.ddlKlant.SelectedValue = -1 Then
                        Session("autoReservaties") = reservatiebll.GetAllBevestigdeReservatiesByAutoIDAndUserID(autoID, New Guid(Me.ddlKlant.SelectedValue))
                    Else
                        Session("autoReservaties") = allereservaties
                    End If


                    reservatiebll = Nothing

                    'Nodig onderhoud  opslaan
                    Dim onderhoudbll As New OnderhoudBLL
                    Session("autoOnderhoud") = onderhoudbll.GetAllNodigOnderhoudByAutoID(autoID)
                    onderhoudbll = Nothing

                End If
            Catch
                Return
            End Try
        End If

    End Sub

    Protected Sub calAutoSchema_DayRender(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DayRenderEventArgs) Handles calAutoSchema.DayRender

        Try

            Dim reservaties As Reservaties.tblReservatieDataTable = CType(Session("autoReservaties"), Reservaties.tblReservatieDataTable)
            Dim onderhoud As Onderhoud.tblNodigOnderhoudDataTable = CType(Session("autoOnderhoud"), Onderhoud.tblNodigOnderhoudDataTable)

            If reservaties IsNot Nothing Then
                For Each res As Reservaties.tblReservatieRow In reservaties
                    If (e.Day.Date >= res.reservatieBegindat And e.Day.Date <= res.reservatieEinddat) Then
                        e.Cell.BackColor = Drawing.ColorTranslator.FromHtml("#A87B5D")
                        e.Cell.Text = String.Empty

                        Dim lbl As New Label()
                        lbl.Text = String.Concat(e.Day.DayNumberText, "<br/>Gereserveerd", vbCrLf)

                        Dim link As New HyperLink()
                        link.Text = "Aanpassen"
                        Dim resData As String = String.Concat(res.reservatieID, ",", res.autoID)
                        link.NavigateUrl = String.Concat("ReservatieWijzigen.aspx?resData=", resData)

                        e.Cell.Controls.Add(lbl)
                        e.Cell.Controls.Add(link)
                    End If
                Next res
            End If

            If onderhoud IsNot Nothing Then
                For Each o As Onderhoud.tblNodigOnderhoudRow In onderhoud
                    If (e.Day.Date >= o.nodigOnderhoudBegindat And e.Day.Date <= o.nodigOnderhoudEinddat) Then
                        e.Cell.BackColor = Drawing.ColorTranslator.FromHtml("#ACC3D2")
                        e.Cell.Text = String.Empty

                        Dim lbl As New Label
                        If o.nodigOnderhoudOmschrijving.Contains("Nazicht voor de reservatie die eindigt op") Then
                            lbl.Text = String.Concat(e.Day.DayNumberText, "<br/>Nazicht")
                        Else
                            lbl.Text = String.Concat(e.Day.DayNumberText, "<br/>Gepland Onderhoud")
                        End If

                        e.Cell.Controls.Add(lbl)

                        'Dim link As New HyperLink()
                        'link.Text = "Test"
                        'Dim resData As String = String.Concat(res.reservatieID, ",", res.autoID)
                        'link.NavigateUrl = String.Concat("ReservatieWijzigen.aspx?resData=", resData)

                        'e.Cell.Controls.Add(link)
                    End If
                Next o
            End If


        Catch
        End Try

    End Sub

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
            Session("autoReservaties") = reservatiebll.GetAllBevestigdeReservatiesByAutoIDAndUserID(ViewState("autoID"), New Guid(Me.ddlKlant.SelectedValue))
        Else
            Session("autoReservaties") = reservatiebll.GetAllBevestigdeReservatiesByAutoID(ViewState("autoID"))
        End If

        reservatiebll = Nothing

        Me.updKalenderOverzicht.Update()
    End Sub
End Class
