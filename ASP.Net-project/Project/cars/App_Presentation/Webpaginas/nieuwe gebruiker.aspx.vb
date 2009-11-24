
Partial Class App_Presentation_Webpaginas_nieuwe_gebruiker
    Inherits System.Web.UI.Page

    Protected Sub CreateUserWizard1_CreatedUser(ByVal sender As Object, ByVal e As System.EventArgs) Handles CreateUserWizard1.CreatedUser
        ' create an empty profile
        Dim k As New Klant
        Dim bllKlant As New KlantBLL
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
        'say what nigger?

        k.Naam = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtNaam"), TextBox).Text
        k.Voornaam = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtVoornaam"), TextBox).Text
        k.Geboortedatum = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtGeboorte"), TextBox).Text
        k.Identiteitskaartnummer = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtIdentiteitsNr"), TextBox).Text
        k.Rijbewijsnummer = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtRijbewijsNr"), TextBox).Text
        k.Telefoon = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtTelefoon"), TextBox).Text
        k.BTWnummer = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtBTW"), TextBox).Text
        k.BedrijfLocatie = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtBedrijf"), TextBox).Text
        k.Email = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("Email"), TextBox).Text
        k.Gebruikersnaam = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("UserName"), TextBox).Text
        k.Gebruikerspaswoord = CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("Password"), TextBox).Text
        k.Gebruikerspaswoord = FormsAuthentication.HashPasswordForStoringInConfigFile(k.Gebruikerspaswoord, "MD5")

        bllKlant.AddKlant(k)


    End Sub

    Protected Sub rdbBedrijf_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdbBedrijf.CheckedChanged
        CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtBedrijf"), TextBox).Visible = True
        CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("lblBedrijf"), Label).Visible = True
        lnbChauffeur.Visible = True
    End Sub

    Protected Sub lnbChauffeur_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnbChauffeur.Click

        Response.Redirect("../Webpaginas/chauffeur.aspx")

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("txtBedrijf"), TextBox).Visible = False
        CType(CreateUserWizard1.CreateUserStep.ContentTemplateContainer.FindControl("lblBedrijf"), Label).Visible = False
        lnbChauffeur.Visible = False
    End Sub
End Class
