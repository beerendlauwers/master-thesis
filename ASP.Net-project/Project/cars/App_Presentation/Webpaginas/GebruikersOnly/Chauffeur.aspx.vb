
Partial Class App_Presentation_Chauffeur
    Inherits System.Web.UI.Page

    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            UpdateChauffeurDropdowns()

        End If

    End Sub


    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsert.Click
        Dim dt As New Klanten.tblChauffeurDataTable
        Dim c As Klanten.tblChauffeurRow = dt.NewRow

        Dim check As Boolean = True

        lblNaamError.Text = String.Empty
        lblVoornaamError.Text = String.Empty
        lblRijbewijsError.Text = String.Empty

        If txtNaam.Text = String.Empty Then
            lblNaamError.Text = "Dit veld is verplicht."
            check = False
        End If
        If txtVoornaam.Text = String.Empty Then
            lblVoornaamError.Text = "Dit veld is verplicht."
            check = False
        End If
        If txtRijbewijs.Text = String.Empty Then
            lblRijbewijsError.Text = "Dit veld is verplicht."
            check = False
        End If

        If check = True Then
            c.chauffeurNaam = txtNaam.Text
            c.chauffeurVoornaam = txtVoornaam.Text
            c.chauffeurRijbewijs = txtRijbewijs.Text
            c.userID = New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())
            Dim chauffeurbll As New ChauffeurBLL
            chauffeurbll.AddChauffeur(c)

            UpdateChauffeurDropdowns()

            ClearTextBoxes()

            imgInsertResultaat.Visible = True
            imgInsertResultaat.ImageUrl = "~\App_Presentation\Images\tick.gif"
            lblInsertResultaat.Visible = True
            lblInsertResultaat.Text = "Chauffeur toegevoegd."

        Else
            imgInsertResultaat.Visible = False
            lblInsertResultaat.Visible = False
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
        Else
            txtNaamup.Text = String.Empty
            txtVoornaamup.Text = String.Empty
            txtRijbewijsup.Text = String.Empty
        End If

    End Sub

    Protected Sub btnWijzig_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnWijzig.Click
        Dim cbll As New ChauffeurBLL
        Dim strID As String
        strID = Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString()
        Dim UserID As New Guid(strID)
        Dim dt As New Klanten.tblChauffeurDataTable
        Dim dr As Klanten.tblChauffeurRow = dt.NewRow

        Dim check As Boolean = True

        lblNaamupError.Text = String.Empty
        lblVoornaamupError.Text = String.Empty
        lblRijbweijsupError.Text = String.Empty

        If txtNaamup.Text = String.Empty Then
            lblNaamupError.Text = "Dit veld is verplicht."
            check = False
        End If

        If txtVoornaamup.Text = String.Empty Then
            lblVoornaamupError.Text = "Dit veld is verplicht."
            check = False
        End If

        If txtRijbewijsup.Text = String.Empty Then
            lblRijbweijsupError.Text = "Dit veld is verplicht."
            check = False
        End If

        If check = True Then
            dr.chauffeurNaam = txtNaamup.Text
            dr.chauffeurVoornaam = txtVoornaamup.Text
            dr.chauffeurRijbewijs = txtRijbewijsup.Text
            dr.chauffeurID = ddlChauffeurWijzig.SelectedValue

            cbll.UpdateChauffeur(dr)

            UpdateChauffeurDropdowns()

            ClearTextBoxes()

            ddlChauffeurWijzig.SelectedValue = "Kies chauffeur"

            imgWijzigResultaat.Visible = True
            imgWijzigResultaat.ImageUrl = "~\App_Presentation\Images\tick.gif"
            lblWijzigResultaat.Visible = True
            lblWijzigResultaat.Text = "Chauffeur gewijzigd."

        Else
            imgWijzigResultaat.Visible = False
            lblWijzigResultaat.Visible = False
        End If

    End Sub

    Protected Sub btnVerwijder_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVerwijder.Click
        Dim cbll As New ChauffeurBLL
        Dim chauffeurid As New Integer
        chauffeurid = ddlChauffeurdelete.SelectedValue

        If (cbll.DeleteChauffeurByID(chauffeurid)) Then

            UpdateChauffeurDropdowns()

            ClearTextBoxes()

            imgVerwijderResultaat.Visible = True
            imgVerwijderResultaat.ImageUrl = "~\App_Presentation\Images\tick.gif"
            lblVerwijderResultaat.Visible = True
            lblVerwijderResultaat.Text = "Chauffeur verwijderd."

        Else
            imgVerwijderResultaat.Visible = False
            lblVerwijderResultaat.Visible = False
        End If

    End Sub

    Private Sub UpdateChauffeurDropdowns()

        ddlChauffeurWijzig.Items.Clear()
        ddlChauffeurdelete.Items.Clear()

        Dim chauffeurbll As New ChauffeurBLL

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
        Next
    End Sub

    Private Sub ClearTextBoxes()
        txtNaamup.Text = String.Empty
        txtVoornaamup.Text = String.Empty
        txtRijbewijsup.Text = String.Empty

        txtNaam.Text = String.Empty
        txtVoornaam.Text = String.Empty
        txtRijbewijs.Text = String.Empty

        imgVerwijderResultaat.Visible = False
        lblVerwijderResultaat.Visible = False
        imgWijzigResultaat.Visible = False
        lblWijzigResultaat.Visible = False
        imgInsertResultaat.Visible = False
        lblInsertResultaat.Visible = False
    End Sub

End Class
