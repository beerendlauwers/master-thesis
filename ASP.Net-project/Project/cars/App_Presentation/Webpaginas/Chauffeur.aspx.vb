
Partial Class App_Presentation_Chauffeur
    Inherits System.Web.UI.Page

    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsert.Click

        Dim dt As New Klanten.tblChauffeurDataTable
        Dim c As Klanten.tblChauffeurRow = dt.NewRow

        c.chauffeurNaam = txtNaam.Text
        c.chauffeurVoornaam = txtVoornaam.Text
        c.chauffeurRijbewijs = txtRijbewijs.Text
        c.userID = New Guid(Membership.GetUser(Me.ddlBedrijf.SelectedItem.Text).ProviderUserKey.ToString())

        Dim chauffeurbll As New ChauffeurBLL
        chauffeurbll.AddChauffeur(c)
        chauffeurbll = Nothing

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        For Each naam In Roles.GetUsersInRole("GebruikerBedrijf")
            Me.ddlBedrijf.Items.Add(naam)
        Next

    End Sub
End Class
