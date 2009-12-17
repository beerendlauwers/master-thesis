
Partial Class App_Presentation_Webpaginas_nieuwe_gebruiker
    Inherits System.Web.UI.Page
    Protected PostBackString As String

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
        p.userID = New Guid(Membership.GetUser(wizard.UserName).ProviderUserKey.ToString())

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
        Else
            p.userIsBedrijf = 0
            p.userBTWnummer = "0"
            p.userBedrijfVestigingslocatie = "0"
            p.userBedrijfnaam = "0"
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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Deze string wordt gebruikt in de ASPX-pagina om wat JavaScript code te genereren.
        PostBackString = Page.ClientScript.GetPostBackEventReference(Me, "ContinuebuttonClick")

        'Doorheen alle postback-keys gaan en kijken of de continue-button tussenzit
        'die in onze PlaceHolder zit. Indien ja, dan veranderen we de kleur.
        For i As Integer = 1 To Page.Request.Form.Keys.Count - 1
            Dim str As String = Page.Request.Form.Keys(i)

            If str = "ctl00$plcMain$wizard$CompleteStepContainer$ContinueButton" Then
                Dim button As Button = Page.FindControl(str)
                ContinueButton_Click(sender, e)
                Return
            End If
        Next

        If (FormulierIsGeldig()) Then



            CType(Master.FindControl("loginView"), LoginView).Visible = False

            'Checken of deze anonieme persoon een reservatie wil doen
            Dim tempCookie As HttpCookie = Request.Cookies("reservatieCookie")
            If tempCookie IsNot Nothing Then
                CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("lblAnoniemeReservatie"), Label).Text = "Vooraleer u kan verdergaan met uw reservatie dient u een gebruiker aan te maken. Vul onderstaande velden in en klik daarna op ""Gebruiker Aanmaken"" om verder te gaan."
                CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("lblAnoniemeReservatie"), Label).Visible = True
            End If

            CType(wizard.CompleteStep.ContentTemplateContainer.FindControl("updDoorgaan"), UpdatePanel).Update()
        End If
    End Sub

    Protected Sub ContinueButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        'De persoon wil mogelijk nog een reservatie doen, stuur hem door!
        Dim tempCookie As HttpCookie = Request.Cookies("reservatieCookie")
        If tempCookie IsNot Nothing Then
            Dim autoID As String = tempCookie("autoID")
            Dim begindat As String = tempCookie("begindat")
            Dim einddat As String = tempCookie("einddat")
            tempCookie.Expires = DateTime.Now.AddDays(-14)
            Response.Cookies.Add(tempCookie)

            Dim userID As String = Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString()
            Response.Redirect(String.Concat("ReservatieBevestigen.aspx?autoID=", autoID, "&begindat=", begindat, "&einddat=", einddat, "&userID=", userID))
        End If

        Response.Redirect("~/App_Presentation/Webpaginas/Default.aspx")
    End Sub

    Private Function FormulierIsGeldig() As Boolean
        If CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtVoornaam"), TextBox).Text = String.Empty Then Return False
        If CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtNaam"), TextBox).Text = String.Empty Then Return False
        Dim gebdat As TextBox = CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtgeboorte"), TextBox)
        Try
            Dim test As Date = Date.Parse(gebdat.Text)
        Catch
            Return False
        End Try
        If CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtIdentiteitsNr"), TextBox).Text = String.Empty Then Return False
        If CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtRijbewijsNr"), TextBox).Text = String.Empty Then Return False
        If CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtTelefoon"), TextBox).Text = String.Empty Then Return False

        If CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("chkIsBedrijf"), CheckBox).Checked Then
            If CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtBedrijfnaam"), TextBox).Text = String.Empty Then
                Me.lblBedrijfsnaamFout.Visible = True
            Else
                Me.lblBedrijfsnaamFout.Visible = False
            End If

            If CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtLocatie"), TextBox).Text = String.Empty Then
                Me.lblLocatieFout.Visible = True
            Else
                Me.lblLocatieFout.Visible = False
            End If

            If CType(wizard.CreateUserStep.ContentTemplateContainer.FindControl("txtBTW"), TextBox).Text = String.Empty Then Return False

        End If

        Return True

    End Function
End Class
