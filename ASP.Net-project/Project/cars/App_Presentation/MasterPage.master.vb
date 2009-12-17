Imports System

Partial Class App_Presentation_MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CheckCronJobs()

        'Header foto
        If (Page.User.Identity.IsAuthenticated) Then
            If (Page.User.IsInRole("GebruikerBedrijf") Or Page.User.IsInRole("Developer")) Then 'wou ook een verschil laten zien als ge als developer inlogde
                CType(Me.lgvHeader.FindControl("divHeader"), HtmlGenericControl).Attributes.Add("class", "art-Header2-jpeg")
            Else
                CType(Me.lgvHeader.FindControl("divHeader"), HtmlGenericControl).Attributes.Add("class", "art-Header-jpeg")
            End If
        End If

        'Contact-knop
        Me.lnkContact.HRef = "~/App_Presentation/Webpaginas/Contact.aspx"

        'Home-knop
        Me.homeButton.HRef = "~/App_Presentation/Webpaginas/Default.aspx"
        Me.lnkHomeLink.HRef = "~/App_Presentation/Webpaginas/Default.aspx"

        'Auto Reserveren link
        Me.autoReserveren.HRef = "~/App_Presentation/Webpaginas/NieuweReservatieAanmaken.aspx"
        Me.autoReserverenPersonenwagens.HRef = "~/App_Presentation/Webpaginas/NieuweReservatieAanmaken.aspx"
        Me.autoReserverenPersonenwagens1.HRef = "~/App_Presentation/Webpaginas/NieuweReservatieAanmaken.aspx?categorie=1"
        Me.autoReserverenPersonenwagens2.HRef = "~/App_Presentation/Webpaginas/NieuweReservatieAanmaken.aspx?categorie=2"
        Me.autoReserverenPersonenwagens3.HRef = "~/App_Presentation/Webpaginas/NieuweReservatieAanmaken.aspx?categorie=3"

        'GebruikersBeheerlink
        If Page.User.Identity.IsAuthenticated Then
            Dim link As String = "~/App_Presentation/Webpaginas/GebruikersOnly/GebruikersBeheer.aspx"
            CType(Me.lgvMijnGegevens.FindControl("lnkBeheer"), HyperLink).NavigateUrl = link
            If (Roles.IsUserInRole(Page.User.Identity.Name, "GebruikerBedrijf") Or _
                Roles.IsUserInRole(Page.User.Identity.Name, "Medewerker") Or _
                Roles.IsUserInRole(Page.User.Identity.Name, "Developer") Or _
                Roles.IsUserInRole(Page.User.Identity.Name, "Bedrijfsverantwoordelijke")) Then
                CType(Me.lgvMijnGegevens.FindControl("lnkChauffeurs"), HyperLink).Visible = True
                Dim linkchauffeur As String = "~/App_Presentation/Webpaginas/GebruikersOnly/Chauffeur.aspx"
                CType(Me.lgvMijnGegevens.FindControl("lnkChauffeurs"), HyperLink).NavigateUrl = linkchauffeur
            End If
            link = String.Concat("~/App_Presentation/Webpaginas/GebruikersOnly/ReservatieBeheer.aspx")
            CType(Me.lgvMijnGegevens.FindControl("lnkMijnReservaties1"), HyperLink).NavigateUrl = link
        End If

        'Registratielink
        If Not Page.User.Identity.IsAuthenticated Then
            Dim link As String = "~/App_Presentation/Webpaginas/NieuweGebruikerAanmaken.aspx"
            Try
                CType(Me.lgvRegistreren.FindControl("lnkRegistraties"), HyperLink).NavigateUrl = link
            Catch
                'fuck off
            End Try

        End If

        'Applicatiebeheerlink
        If (Page.User.Identity.IsAuthenticated) Then
            Dim link As String = "~/App_Presentation/Webpaginas/Beheer/AutoBeheer.aspx"
            CType(Me.lgvBeheer.FindControl("lnkBeheer"), HyperLink).NavigateUrl = link
            If (Roles.IsUserInRole(Page.User.Identity.Name, "Medewerker") Or _
                Roles.IsUserInRole(Page.User.Identity.Name, "Developer") Or _
                Roles.IsUserInRole(Page.User.Identity.Name, "Bedrijfsverantwoordelijke")) Then

                Dim linkapplicatiebeheer As String = "~/App_Presentation/Webpaginas/Beheer/Applicatiebeheer.aspx"
                CType(Me.lgvBeheer.FindControl("lnkBeheer"), HyperLink).NavigateUrl = linkapplicatiebeheer

            Else
                CType(Me.lgvBeheer.FindControl("lnkBeheer"), HyperLink).Visible = False
            End If
        End If

        'Filiaal ddo
        Dim FiliaalCookie As HttpCookie
        FiliaalCookie = Request.Cookies("filcookie")

        'Filiaal ddl invullen

        Dim BLLFIliaal As New FiliaalBLL
        Dim DTFiliaal As New Autos.tblFiliaalDataTable

        ddlFiliaal.Items.Add(New ListItem(("Kies filiaal..."), ("%%")))
        For i As Integer = 0 To dtFiliaal.Rows.Count - 1
            ddlFiliaal.Items.Add(DTFiliaal.Rows(i)("filiaalLocatie"))
        Next


    End Sub

    Protected Sub ddlFiliaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlFiliaal.SelectedIndexChanged

        If (ddlFiliaal.SelectedValue = "Selecteer Filiaal...") Then 'Dummy filiaal!
            Return
        End If

        Dim FiliaalCookie As HttpCookie = New HttpCookie("filcookie")

        FiliaalCookie.Value = ddlFiliaal.SelectedValue
        FiliaalCookie.Expires = DateTime.Now.AddDays(100)
        Response.Cookies.Add(FiliaalCookie) ' cookie bewaren

        Dim BLLFiliaal As New FiliaalBLL
        Dim DTFiliaal As New Autos.tblFiliaalDataTable
        Dim DRFiliaal As Autos.tblFiliaalRow

        DTFiliaal = BLLFiliaal.GetFiliaalByFiliaalID(ddlFiliaal.SelectedValue)
        DRFiliaal = DTFiliaal.Rows(0)


        Response.Redirect("Contact.aspx?fil=" + DRFiliaal.filiaalLocatie)

    End Sub

    Private Sub CheckCronJobs()

        Dim huidigetijd As Date = Now

        'Check voor onbevestigde reservaties
        If (Application("CronJobs_VerwijderOnbevestigdeReservaties_Timer") Is Nothing) Then
            Application("CronJobs_VerwijderOnbevestigdeReservaties_Timer") = Now
            VerwijderOnbevestigdeReservaties()
        Else
            Dim timer As Date = Application("CronJobs_VerwijderOnbevestigdeReservaties_Timer")

            If (DateAdd(DateInterval.Minute, 3, timer) <= huidigetijd) Then
                VerwijderOnbevestigdeReservaties()
                Application("CronJobs_VerwijderOnbevestigdeReservaties_Timer") = Now
            End If
        End If

        'Check voor oude geplande onderhouden (= ouder dan 3 dagen) die nooit zijn uitgevoerd geweest
        If (Application("CronJobs_VerwijderOudeGeplandeOnderhouden_Timer") Is Nothing) Then
            Application("CronJobs_VerwijderOudeGeplandeOnderhouden_Timer") = Now
            VerwijderOudeGeplandeOnderhouden()
        Else
            Dim timer As Date = Application("CronJobs_VerwijderOudeGeplandeOnderhouden_Timer")

            If (DateAdd(DateInterval.Day, 1, timer) <= huidigetijd) Then
                VerwijderOudeGeplandeOnderhouden()
                Application("CronJobs_VerwijderOudeGeplandeOnderhouden_Timer") = Now
            End If
        End If


    End Sub

    Private Sub VerwijderOudeGeplandeOnderhouden()

        Dim controlebll As New ControleBLL
        Dim onderhoudbll As New OnderhoudBLL

        Dim dt As Onderhoud.tblControleDataTable = controlebll.GetAllOudeControles()

        For Each c As Onderhoud.tblControleRow In dt

            'Nodig onderhoud verwijderen in tblNodigOnderhoud
            Dim o As Onderhoud.tblNodigOnderhoudRow = onderhoudbll.GetNodigOnderhoudByControleID(c.controleID)
            If o IsNot Nothing Then onderhoudbll.VerwijderNodigOnderhoud(o.nodigOnderhoudID)

            'Eigenlijke controle verwijderen
            controlebll.DeleteControle(c.controleID)

        Next

        controlebll = Nothing
        onderhoudbll = Nothing
    End Sub

    Private Sub VerwijderOnbevestigdeReservaties()
        Dim huidigetijd As Date = Now

        Dim reservatiebll As New ReservatieBLL
        Dim controlebll As New ControleBLL
        Dim onderhoudbll As New OnderhoudBLL

        Dim dt As Reservaties.tblReservatieDataTable = reservatiebll.GetAllOnbevestigdeReservaties()

        For Each res As Reservaties.tblReservatieRow In dt
            If (DateAdd(DateInterval.Minute, 10, res.reservatieLaatstBekeken) <= huidigetijd) Then

                'Nodig onderhoud verwijderen in tblNodigOnderhoud
                Dim o As Onderhoud.tblNodigOnderhoudRow = onderhoudbll.GetNazichtByDatumAndAutoID(DateAdd(DateInterval.Day, 1, res.reservatieEinddat), res.autoID)
                If o IsNot Nothing Then onderhoudbll.VerwijderNodigOnderhoud(o.nodigOnderhoudID)

                'Eigenlijke controle verwijderen
                Dim c As Onderhoud.tblControleRow = controlebll.GetControleByReservatieID(res.reservatieID)
                If c IsNot Nothing Then controlebll.DeleteControle(c.controleID)

                'Eigenlijke reservatie verwijderen
                reservatiebll.DeleteReservatie(res)
            End If
        Next

        reservatiebll = Nothing
        controlebll = Nothing
        onderhoudbll = Nothing
    End Sub
End Class

