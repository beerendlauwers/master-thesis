
Partial Class App_Presentation_Webpaginas_nieuwe_gebruiker
    Inherits System.Web.UI.Page

    Protected Sub CreateUserWizard1_CreatedUser(ByVal sender As Object, ByVal e As System.EventArgs) Handles CreateUserWizard1.CreatedUser
        ' create an empty profile

        Dim p As ProfileCommon = ProfileCommon.Create(CreateUserWizard1.UserName, True)

        ' fill profile with values from CreateUserStep


        p.voornaam = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtVoornaam"), TextBox).Text
        p.naam = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtNaam"), TextBox).Text
        p.geboortedatum = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtgeboorte"), TextBox).Text
        p.identiteitsnummer = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtIdentiteitsNr"), TextBox).Text
        p.rijbewijsnummer = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtRijbewijsNr"), TextBox).Text
        p.telefoon = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtTelefoon"), TextBox).Text
        p.BTWnummer = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtBTW"), TextBox).Text

        ' save profile

    End Sub


End Class
