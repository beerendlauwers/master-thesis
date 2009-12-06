
Partial Class App_Presentation_Chauffeur
    Inherits System.Web.UI.Page

    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsert.Click

        Dim dt As New Klanten.tblChauffeurDataTable
        Dim c As Klanten.tblChauffeurRow = dt.NewRow
        'Dim username As String
        c.chauffeurNaam = txtNaam.Text
        c.chauffeurVoornaam = txtVoornaam.Text
        c.chauffeurRijbewijs = txtRijbewijs.Text
        c.userID = New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())
        Dim chauffeurbll As New ChauffeurBLL
        chauffeurbll.AddChauffeur(c)



    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim gebruikerbll As New KlantBLL
        Dim chauffeurbll As New ChauffeurBLL
        Dim gebruiker As New Klant
        'Dim username As String
        'Dim chauffeur As String
        If Not IsPostBack Then


            Dim strID As String
            strID = Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString()
            Dim UserID As New Guid(strID)
            Dim dt As Klanten.tblChauffeurDataTable = chauffeurbll.GetChauffeurByUserID(UserID)
            Dim list As New ListItem
            ddlChauffeurWijzig.Items.Add(New ListItem("Kies chauffeur", "Kies chauffeur"))
            ddlChauffeurdelete.Items.Add(New ListItem("Kies chauffeur", "Kies chauffeur"))
            For i As Integer = 0 To dt.Rows.Count - 1
                ddlChauffeurWijzig.Items.Add(New ListItem((dt.Rows(i)("chauffeurNaam")), (dt.Rows(i)("chauffeurID"))))
                ddlChauffeurdelete.Items.Add(New ListItem((dt.Rows(i)("chauffeurNaam")), (dt.Rows(i)("chauffeurID"))))
                ' list = New ListItem((dt.Rows(i)("chauffeurNaam")), (dt.Rows(i)("chauffeurID")))
            Next

        End If

    End Sub

    Protected Sub ddlChauffeurWijzig_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlChauffeurWijzig.SelectedIndexChanged
        Dim chauffeurid As Integer
        If Not ddlChauffeurWijzig.SelectedValue = "Kies chauffeur" Then
            chauffeurid = ddlChauffeurWijzig.SelectedValue
            Dim bllChauffeur As New ChauffeurBLL
            Dim dt As Klanten.tblChauffeurDataTable
            dt = bllChauffeur.GetChauffeurByChauffeurID(chauffeurid)

            txtNaamup.Text = dt.Rows(0)("chauffeurNaam")
            txtVoornaamup.Text = dt.Rows(0)("chauffeurVoornaam")
            txtRijbewijsup.Text = dt.Rows(0)("chauffeurRijbewijs")
        End If

    End Sub

    Protected Sub btnWijzig_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnWijzig.Click
        Dim cbll As New ChauffeurBLL
        Dim strID As String
        strID = Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString()
        Dim UserID As New Guid(strID)
        Dim dt As New Klanten.tblChauffeurDataTable
        Dim dr As Klanten.tblChauffeurRow = dt.NewRow

        dr.chauffeurNaam = txtNaamup.Text
        dr.chauffeurVoornaam = txtVoornaamup.Text
        dr.chauffeurRijbewijs = txtRijbewijsup.Text
        dr.chauffeurID = ddlChauffeurWijzig.SelectedValue

        cbll.UpdateChauffeur(dr)
        DataBind()
        txtNaamup.Text = Nothing
        txtVoornaamup.Text = Nothing
        txtRijbewijsup.Text = Nothing
        ddlChauffeurWijzig.SelectedValue = "Kies chauffeur"
    End Sub

    Protected Sub btnVerwijder_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVerwijder.Click
        Dim cbll As New ChauffeurBLL
        Dim chauffeurid As New Integer
        chauffeurid = ddlChauffeurdelete.SelectedValue
        cbll.DeleteChauffeurByID(chauffeurid)
    End Sub
End Class
