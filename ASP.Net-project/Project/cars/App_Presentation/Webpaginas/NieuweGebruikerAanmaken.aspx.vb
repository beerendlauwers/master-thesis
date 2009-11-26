
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

        ' Leeg profiel aanmaken
        Dim p As ProfileCommon = ProfileCommon.Create(wizard.UserName, True)

        ' Standaardinformatie
        p.Voornaam = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtVoornaam"), TextBox).Text
        p.Naam = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtNaam"), TextBox).Text
        p.Geboortedatum = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtgeboorte"), TextBox).Text
        p.Identiteitskaartnummer = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtIdentiteitsNr"), TextBox).Text
        p.Rijbewijsnummer = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtRijbewijsNr"), TextBox).Text
        p.Telefoon = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtTelefoon"), TextBox).Text

        ' Bedrijfsinformatie
        Dim isBedrijf As Boolean = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("chkIsBedrijf"), CheckBox).Checked
        If (isBedrijf) Then
            p.IsBedrijf = 1
            p.BTWnummer = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtBTW"), TextBox).Text
            p.BedrijfVestigingslocatie = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtLocatie"), TextBox).Text
            p.Bedrijfnaam = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtBedrijfnaam"), TextBox).Text
        End If

        ' Extra beheerdersinformatie
        p.AantalDagenGehuurd = 0
        p.AantalDagenGereserveerd = 0
        p.AantalKilometerGereden = 0
        p.Commentaar = String.Empty
        p.IsProblematisch = 0
        p.HeeftRechtOpKorting = 0
        p.KortingWaarde = 0

        ' Profiel opslaan
        p.Save()

        ' Profiel rol "Gebruiker" geven
        Roles.AddUserToRole(wizard.UserName, "Gebruiker")
    End Sub
End Class
