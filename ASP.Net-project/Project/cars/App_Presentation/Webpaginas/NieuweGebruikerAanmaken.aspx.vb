
Partial Class App_Presentation_Webpaginas_nieuwe_gebruiker
    Inherits System.Web.UI.Page

    Public Sub MaakBedrijfZichtbaar()
        Dim isZichtbaar As Boolean = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("chkIsBedrijf"), CheckBox).Checked
        CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("lblBTW"), Label).Visible = isZichtbaar
        CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtBTW"), TextBox).Visible = isZichtbaar
        CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("lblLocatie"), Label).Visible = isZichtbaar
        CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtLocatie"), TextBox).Visible = isZichtbaar
        CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("lblBedrijfnaam"), Label).Visible = isZichtbaar
        CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtBedrijfnaam"), TextBox).Visible = isZichtbaar
    End Sub

    Protected Sub CreateUserWizard1_CreatedUser(ByVal sender As Object, ByVal e As System.EventArgs) Handles wizard.CreatedUser

        Dim klantbll As New KlantBLL
        Dim dt As New Klanten.tblUserProfielDataTable
        Dim p As Klanten.tblUserProfielRow = dt.NewRow

        'UserID
        p.userID = New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())

        ' Standaardinformatie
        p.userVoornaam = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtVoornaam"), TextBox).Text
        p.userNaam = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtNaam"), TextBox).Text
        p.userGeboortedatum = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtgeboorte"), TextBox).Text
        p.userIdentiteitskaartnr = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtIdentiteitsNr"), TextBox).Text
        p.userRijbewijsnr = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtRijbewijsNr"), TextBox).Text
        p.userTelefoon = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtTelefoon"), TextBox).Text

        ' Bedrijfsinformatie
        Dim isBedrijf As Boolean = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("chkIsBedrijf"), CheckBox).Checked
        If (isBedrijf) Then
            Roles.AddUserToRole(wizard.UserName, "GebruikerBedrijf")
            p.userIsBedrijf = 1
            p.userBTWnummer = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtBTW"), TextBox).Text
            p.userBedrijfVestigingslocatie = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtLocatie"), TextBox).Text
            p.userBedrijfnaam = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtBedrijfnaam"), TextBox).Text
        End If

        ' Extra beheerdersinformatie
        p.userAantalDagenGehuurd = 0
        p.userAantalDagenGereserveerd = 0
        p.userAantalKilometerGereden = 0
        p.userCommentaar = String.Empty
        p.userIsProblematisch = 0
        p.userHeeftRechtOpKorting = 0
        p.userKortingWaarde = 0

        ' Profiel opslaan
        klantbll.InsertUserProfiel(p)
        klantbll = Nothing

        ' Nieuwe user rol "Gebruiker" geven
        Roles.AddUserToRole(wizard.UserName, "Gebruiker")
    End Sub
End Class
