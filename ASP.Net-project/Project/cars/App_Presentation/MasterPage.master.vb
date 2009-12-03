Imports System

Partial Class App_Presentation_MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Header foto


        'Mijn Reservaties link
        If (Roles.IsUserInRole(Page.User.Identity.Name, "Gebruiker") Or _
            Roles.IsUserInRole(Page.User.Identity.Name, "Developer")) Then
            Dim id As New Guid(Membership.GetUser(Page.User.Identity.Name).ProviderUserKey.ToString())

            Dim link As String = String.Concat("~/App_Presentation/Webpaginas/GebruikersOnly/ToonReservatie.aspx?userID=", id.ToString)
            CType(Me.lgvMijnReservaties.FindControl("lnkMijnReservaties"), HyperLink).NavigateUrl = link
        End If

        'Registratielink
        If Not Page.User.Identity.IsAuthenticated Then
            Dim link As String = "~/App_Presentation/Webpaginas/NieuweGebruikerAanmaken.aspx"
            CType(Me.lgvRegistreren.FindControl("lnkRegistraties"), HyperLink).NavigateUrl = link
        End If

        'Applicatiebeheerlink
        If (Roles.IsUserInRole(Page.User.Identity.Name, "Medewerker") Or _
            Roles.IsUserInRole(Page.User.Identity.Name, "Developer") Or _
            Roles.IsUserInRole(Page.User.Identity.Name, "Bedrijfsverantwoordelijke")) Then

            Dim link As String = "~/App_Presentation/Webpaginas/Beheer/"
            CType(Me.lgvBeheer.FindControl("lnkBeheer"), HyperLink).NavigateUrl = link
        End If
    End Sub

    Protected Sub ddoFiliaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddoFiliaal.SelectedIndexChanged

        Dim FiliaalCookie As HttpCookie = New HttpCookie("filcookie")

        FiliaalCookie.Value = ddoFiliaal.SelectedValue
        FiliaalCookie.Expires = DateTime.Now.AddDays(100)
        Response.Cookies.Add(FiliaalCookie) ' cookie bewaren



    End Sub
End Class

