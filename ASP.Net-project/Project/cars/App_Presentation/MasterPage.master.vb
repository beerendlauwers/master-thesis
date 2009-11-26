Imports System

Partial Class App_Presentation_MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Header foto


        'Mijn Reservaties link
        If (Roles.IsUserInRole(Page.User.Identity.Name, "Gebruiker") Or _
            Roles.IsUserInRole(Page.User.Identity.Name, "Developer")) Then
            Dim klantbll As New KlantBLL
            Dim id As Integer = klantbll.GetKlantIDByKlantNaam(Page.User.Identity.Name)
            klantbll = Nothing
            Dim link As String = String.Concat("~/App_Presentation/Webpaginas/GebruikersOnly/ToonReservatie.aspx?userID=", id.ToString)
            CType(Me.lgvMijnReservaties.FindControl("lnkMijnReservaties"), HyperLink).NavigateUrl = link
        End If

        'Registratielink
        If (Not Roles.IsUserInRole(Page.User.Identity.Name, "Gebruiker") And _
           Not Roles.IsUserInRole(Page.User.Identity.Name, "Developer") And _
           Not Roles.IsUserInRole(Page.User.Identity.Name, "Medewerker")) Then
            Dim link As String = "~/App_Presentation/Webpaginas//nieuwe%20gebruiker.aspx"
            CType(Me.lgvRegistreren.FindControl("lnkRegistraties"), HyperLink).NavigateUrl = link
        End If
    End Sub

End Class

