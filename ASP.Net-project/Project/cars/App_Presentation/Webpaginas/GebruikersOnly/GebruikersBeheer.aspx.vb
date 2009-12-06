
Partial Class App_Presentation_Webpaginas_GebruikersBeheer
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lblUserName.Text = User.Identity.Name
        If Not IsPostBack Then
            Dim gebruikerbll As New KlantBLL
            Dim gebruiker As New Klant
            Dim username As String
            username = Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString
            Dim gid As New Guid(username)
            gebruikerbll.GetUserProfielByUserID(gid)

            Dim dt As Klanten.tblUserProfielDataTable = gebruikerbll.GetUserProfielByUserID(gid)
            Dim r As Klanten.tblUserProfielRow = dt.Rows(0)

            If r.userIsBedrijf = 1 Then
                txtBedrijfnaam.Visible = True
                txtBTW.Visible = True
                txtVestigingslocatie.Visible = True
                Label6.Visible = True
                Label7.Visible = True
                Label8.Visible = True
                btnChauffeurs.Visible = True
            End If

            'lblUserName.Text

            txtNaam.Text = r.userNaam
            txtVoornaam.Text = r.userVoornaam
            txtGeboorte.Text = Format(r.userGeboortedatum, "dd/MM/yyy")
            txtIdentiteitsNr.Text = r.userIdentiteitskaartnr
            txtRijbewijsNr.Text = r.userRijbewijsnr
            txtTelefoon.Text = r.userTelefoon

            txtBedrijfnaam.Text = r.userBedrijfnaam
            txtVestigingslocatie.Text = r.userBedrijfVestigingslocatie
            txtBTW.Text = r.userBTWnummer
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

    Protected Sub btnWeergave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnWeergave.Click
        txtNaam.Enabled = True
        txtVoornaam.Enabled = True
        txtGeboorte.Enabled = True
        txtIdentiteitsNr.Enabled = True
        txtRijbewijsNr.Enabled = True
        txtTelefoon.Enabled = True
        txtBedrijfnaam.Enabled = True
        txtVestigingslocatie.Enabled = True
        txtBTW.Enabled=True
    End Sub

End Class
