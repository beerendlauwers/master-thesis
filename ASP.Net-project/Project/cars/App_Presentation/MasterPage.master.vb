Imports System

Partial Class App_Presentation_MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Header foto

        'Home-knop
        Me.homeButton.HRef = "~/App_Presentation/Webpaginas/Default.aspx"

        'Auto Reserveren link
        Me.autoReserveren.HRef = "~/App_Presentation/Webpaginas/NieuweReservatieAanmaken.aspx"
        Me.autoReserverenPersonenwagens.HRef = "~/App_Presentation/Webpaginas/NieuweReservatieAanmaken.aspx"
        Me.autoReserverenPersonenwagens1.HRef = "~/App_Presentation/Webpaginas/NieuweReservatieAanmaken.aspx?categorie=1"
        Me.autoReserverenPersonenwagens2.HRef = "~/App_Presentation/Webpaginas/NieuweReservatieAanmaken.aspx?categorie=2"
        Me.autoReserverenPersonenwagens3.HRef = "~/App_Presentation/Webpaginas/NieuweReservatieAanmaken.aspx?categorie=3"

        'Mijn Reservaties link
        If Page.User.Identity.IsAuthenticated Then
            Dim link As String = String.Concat("~/App_Presentation/Webpaginas/GebruikersOnly/ReservatieBeheer.aspx")
            Try
                CType(Me.lgvMijnReservaties.FindControl("lnkMijnReservaties"), HyperLink).NavigateUrl = link
                CType(Me.lgvMijnGegevens.FindControl("lnkMijnReservaties1"), HyperLink).NavigateUrl = link
            Catch ex As Exception
                Return
            End Try

        End If

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
        End If

        'Registratielink
        If Not Page.User.Identity.IsAuthenticated Then
            Dim link As String = "~/App_Presentation/Webpaginas/NieuweGebruikerAanmaken.aspx"
            CType(Me.lgvRegistreren.FindControl("lnkRegistraties"), HyperLink).NavigateUrl = link
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
        ddoFiliaal.SelectedValue = FiliaalCookie.Value

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
End Class

