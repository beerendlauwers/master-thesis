
Partial Class App_Presentation_Webpaginas_GebruikersBeheer
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'DDLKlant opvullen
        If Not IsPostBack Then
            Dim klantbll As New KlantBLL
            Dim dt As Klanten.tblUserProfielDataTable
            dt = klantbll.getAllUserprofielen
            Dim dr As Klanten.tblUserProfielRow = dt.NewRow

            Me.ddlGebruiker.Items.Add(New ListItem(("Kies gebruikersnaam"), -1))

            For i As Integer = 0 To dt.Rows.Count - 1
                'Klant ophalen
                dr = dt.Rows(i)

                'Even nakijken of deze klant al in de dropdown zit.
                Dim naamvoornaam As String = String.Concat(dr.userNaam, " ", dr.userVoornaam)


                Dim item As New ListItem(naamvoornaam, dr.userID.ToString)
                Me.ddlGebruiker.Items.Add(item)
            Next


            btnChauffeurs.Enabled = False


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
        txtBTW.Enabled = True
    End Sub

    Private Function vulgegevensIn(ByVal userID As String)

        Dim gebruikerbll As New KlantBLL
        Dim gebruiker As New Klant
        Dim gid As New Guid(userID)
        gebruikerbll.GetUserProfielByUserID(gid)
        Dim dt As Klanten.tblUserProfielDataTable = gebruikerbll.GetUserProfielByUserID(gid)
        Dim r As Klanten.tblUserProfielRow = dt.Rows(0)

        If r.userIsBedrijf = 1 Then
            txtBedrijfnaam.Visible = True
            txtBTW.Visible = True
            txtVestigingslocatie.Visible = True
            lblBedrijfsnaam.Visible = True
            lblVestigingslocatie.Visible = True
            lblBTW.Visible = True
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
        lblUser.Text = r.userID.ToString


    End Function

    Protected Sub ddlGebruiker_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlGebruiker.SelectedIndexChanged
        vulgegevensIn(ddlGebruiker.SelectedValue)

        Dim DDLKlant As New KlantBLL
        Dim DTKlant As New Klanten.tblUserProfielDataTable
        Dim DTRow As Klanten.tblUserProfielRow

        DTKlant = DDLKlant.GetUserProfielByUserID(New Guid(ddlGebruiker.SelectedValue))
        DTRow = DTKlant.Rows(0)

        If Not DTRow.userIsBedrijf = 0 Then
            btnChauffeurs.Enabled = True
        Else
            btnChauffeurs.Enabled = False
        End If

    End Sub


    Protected Sub btnRol_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRol.Click
        Dim adapter As New KlantenTableAdapters.aspnet_UsersTableAdapter
        Dim userid As New Guid(lblUser.Text)

        Dim username = adapter.ScalarQueryusernamebyuserID(userid)

        Roles.AddUserToRole(username, ddlRole.SelectedValue)

        lblUser.Visible = True
        lblUser.Text = "role updated"
    End Sub
End Class
