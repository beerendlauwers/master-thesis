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
            If (Roles.IsUserInRole(Page.User.Identity.Name, "Medewerker") Or _
                Roles.IsUserInRole(Page.User.Identity.Name, "Developer") Or _
                Roles.IsUserInRole(Page.User.Identity.Name, "Bedrijfsverantwoordelijke")) Then

                Dim link As String = "~/App_Presentation/Webpaginas/Beheer/"
                CType(Me.lgvBeheer.FindControl("lnkBeheer"), HyperLink).NavigateUrl = link
            Else
                CType(Me.lgvBeheer.FindControl("lnkBeheer"), HyperLink).Visible = False
            End If
        End If

        'Filiaal ddo
        Dim FiliaalCookie As HttpCookie
        FiliaalCookie = Request.Cookies("filcookie")


    End Sub

    Protected Sub ddoFiliaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddoFiliaal.SelectedIndexChanged

        If (ddoFiliaal.SelectedValue = "Selecteer Filiaal...") Then 'Dummy filiaal!
            Return
        End If

        Dim FiliaalCookie As HttpCookie = New HttpCookie("filcookie")

        FiliaalCookie.Value = ddoFiliaal.SelectedValue
        FiliaalCookie.Expires = DateTime.Now.AddDays(100)
        Response.Cookies.Add(FiliaalCookie) ' cookie bewaren

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


    End Sub

    Private Sub VerwijderOnbevestigdeReservaties()
        Dim huidigetijd As Date = Now

        Dim reservatiebll As New ReservatieBLL
        Dim dt As Reservaties.tblReservatieDataTable = reservatiebll.GetAllOnbevestigdeReservaties()

        For Each res As Reservaties.tblReservatieRow In dt
            If (DateAdd(DateInterval.Minute, 10, res.reservatieLaatstBekeken) <= huidigetijd) Then
                reservatiebll.DeleteReservatie(res.reservatieID)
            End If
        Next

        reservatiebll = Nothing
    End Sub
End Class

