
Partial Class App_Presentation_Webpaginas_GebruikersBeheer
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim gebruikerbll As New KlantBLL
            Dim gebruiker As New Klant
            Dim username As String
            username = Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString
            Dim gid As New Guid(username)
            gebruikerbll.GetUserProfielByUserID(gid)

            Dim dt As Klanten.tblUserProfielDataTable = gebruikerbll.GetUserProfielByUserID(gid)

            If dt.Rows(0)("UserIsBedrijf") = 1 Then
                txtBedrijfnaam.Visible = True
                txtBTW.Visible = True
                txtVestigingslocatie.Visible = True
                Label6.Visible = True
                Label7.Visible = True
                Label8.Visible = True
                btnChauffeurs.Visible = True
            End If

            txtNaam.Text = dt.Rows(0)("UserNaam").ToString
            txtVoornaam.Text = dt.Rows(0)("UserVoornaam").ToString
            txtGeboorte.Text = dt.Rows(0)("UserGeboorteDatum").ToString
            txtIdentiteitsNr.Text = dt.Rows(0)("UserIdentiteitskaartnr").ToString
            txtRijbewijsNr.Text = dt.Rows(0)("UserRijbewijsnr").ToString
            txtBedrijfnaam.Text = dt.Rows(0)("UserBedrijfnaam").ToString
            txtVestigingslocatie.Text = dt.Rows(0)("UserBedrijfVestigingslocatie").ToString
            txtBTW.Text = dt.Rows(0)("UserBTWnummer").ToString
            txtTelefoon.Text = dt.Rows(0)("UserTelefoon").ToString
        End If


    End Sub


    Protected Sub btnWijzig_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnWijzig.Click
        Dim klantbll As New KlantBLL
        Dim username As String
        username = Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString
        Dim gid As New Guid(username)
        Dim dt As New Klanten.tblUserProfielDataTable
        Dim dr As Klanten.tblUserProfielRow = dt.NewRow

        dr.userVoornaam = txtVoornaam.Text
        dr.userNaam = txtNaam.Text
        dr.userGeboortedatum = txtGeboorte.Text
        dr.userIdentiteitskaartnr = txtIdentiteitsNr.Text
        dr.userRijbewijsnr = txtRijbewijsNr.Text
        dr.userTelefoon = txtTelefoon.Text
        dr.userBedrijfnaam = txtBedrijfnaam.Text
        dr.userBedrijfVestigingslocatie = txtVestigingslocatie.Text
        dr.userBTWnummer = txtBTW.Text
        dr.userID = gid
        klantbll.UpdateUserProfiel(dr)

    End Sub


    Protected Sub btnChauffeurs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnChauffeurs.Click
        Response.Redirect("~/App_Presentation/Webpaginas/GebruikersOnly/Chauffeur.aspx")
    End Sub
End Class
