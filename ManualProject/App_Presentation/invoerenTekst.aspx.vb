Imports Manual

Partial Class App_Presentation_invoerenTest
    Inherits System.Web.UI.Page

    Private artikel As Manual.tblArtikelRow
    Private adap As New ManualTableAdapters.tblArtikelTableAdapter
    Private bedrijfIsKlaar As Boolean = False
    Private versieIsKlaar As Boolean = False
    Private taalIsKlaar As Boolean = False

    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegtoe.Click

        Dim tekst As String = Editor1.Content
        Dim tag As String = txtTag.Text.Trim
        Dim titel As String = txtTitel.Text.Trim

        Dim FK_versie As Integer = ddlVersie.SelectedValue
        Dim FK_Bedrijf As Integer = ddlBedrijf.SelectedValue
        Dim FK_categorie As Integer = ddlCategorie.SelectedValue
        Dim FK_taal As Integer = ddlTaal.SelectedValue

        Dim finaal As Integer
        If ckbFinaal.Checked = True Then
            finaal = 1
        Else
            finaal = 0
        End If

        Dim insertGelukt As Boolean = adap.Insert(titel, FK_categorie, FK_taal, FK_Bedrijf, FK_versie, tekst, tag, finaal)
        If insertGelukt = True Then

            'Nu gaan we de boomstructuur in het geheugen updaten.

            'We halen de tree op waar dit artikel in werd opgeslagen
            Dim tree As Tree = tree.GetTree(FK_taal, FK_versie, FK_Bedrijf)

            'We proberen het artikel toe te voegen.
            Dim boodschap As String = tree.VoegArtikelToeAanCategorie(tag, FK_categorie)

            'Boodschap nakijken voor een foutboodschap
            If boodschap = "OK" Then
                lblresultaat.Text = "Toevoegen Geslaagd."
                lblresultaat.ForeColor = System.Drawing.ColorTranslator.FromHtml("#86CC7C")
                imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\tick.gif"
                Me.btnVoegtoe.Visible = False
            Else
                lblresultaat.Text = String.Concat("Toevoegen Geslaagd met waarschuwing: ", boodschap)
                lblresultaat.ForeColor = System.Drawing.ColorTranslator.FromHtml("#EAB600")
                imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\warning.gif"
                Me.btnVoegtoe.Visible = False
            End If

        Else
            lblresultaat.Text = "Toevoegen Mislukt: Kon niet verbinden met de database."
            lblresultaat.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E3401E")
            imgResultaat.ImageUrl = "~\App_Presentation\CSS\images\remove.gif"
        End If

        divFeedback.Visible = True

    End Sub

    Protected Sub ddlBedrijf_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBedrijf.DataBound
        bedrijfIsKlaar = True

        If bedrijfIsKlaar And versieIsKlaar And taalIsKlaar Then
            LaadCategorien()
        End If
    End Sub

    Protected Sub ddlTaal_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTaal.DataBound
        taalIsKlaar = True

        If bedrijfIsKlaar And versieIsKlaar And taalIsKlaar Then
            LaadCategorien()
        End If
    End Sub

    Protected Sub ddlVersie_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlVersie.DataBound
        versieIsKlaar = True

        If bedrijfIsKlaar And versieIsKlaar And taalIsKlaar Then
            LaadCategorien()
        End If
    End Sub

    Protected Sub ddlBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBedrijf.SelectedIndexChanged
        LaadCategorien()
    End Sub

    Protected Sub ddlTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTaal.SelectedIndexChanged
        LaadCategorien()
    End Sub

    Protected Sub ddlVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlVersie.SelectedIndexChanged
        LaadCategorien()
    End Sub

    Private Sub LaadCategorien()
        Me.ddlCategorie.DataSource = DatabaseLink.GetInstance.GetCategorieFuncties.GetAllCategorieBy(Me.ddlTaal.SelectedValue, Me.ddlBedrijf.SelectedValue, Me.ddlVersie.SelectedValue)
        Me.ddlCategorie.DataBind()
    End Sub
End Class
