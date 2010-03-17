Imports Manual

Partial Class App_Presentation_invoerenTest
    Inherits System.Web.UI.Page

    Private artikel As Manual.tblArtikelRow
    Private adap As New ManualTableAdapters.tblArtikelTableAdapter
    Private bedrijfIsKlaar As Boolean = False
    Private versieIsKlaar As Boolean = False
    Private taalIsKlaar As Boolean = False

    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegtoe.Click
        Dim titel As String
        Dim tekst As String
        Dim tag As String
        Dim FK_categorie As Integer
        Dim FK_taal As Integer
        Dim FK_versie As Integer
        Dim finaal As Integer
        Dim FK_Bedrijf As Integer
        Dim res As Boolean
        tekst = Editor1.Content
        tag = txtTag.Text
        titel = txtTitel.Text
        FK_versie = ddlVersie.SelectedValue
        FK_Bedrijf = ddlBedrijf.SelectedValue
        FK_categorie = ddlCategorie.SelectedValue
        FK_taal = ddlTaal.SelectedValue
        If ckbFinaal.Checked = True Then
            finaal = 1
        Else
            finaal = 0
        End If


        res = adap.Insert(titel, FK_categorie, FK_taal, FK_Bedrijf, FK_versie, tekst, tag, finaal)
        If res = True Then

            'Nu gaan we de boomstructuur in het geheugen updaten.

            'We halen de tree op waar dit artikel in werd opgeslagen
            Dim tree As Tree = tree.GetTree(FK_taal, FK_versie, FK_Bedrijf)

            'We proberen het artikel toe te voegen.
            Dim boodschap As String = tree.VoegArtikelToeAanCategorie(tag, FK_categorie)

            'Boodschap nakijken voor een foutboodschap
            If boodschap = "OK" Then
                lblresultaat.Text = "Toevoegen Geslaagd."
            Else
                lblresultaat.Text = String.Concat("Toevoegen Geslaagd met waarschuwing: ", boodschap)
            End If

        Else
            lblresultaat.Text = "Toevoegen Mislukt: Kon niet verbinden met de database."
        End If

        Me.btnVoegtoe.Visible = False

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



    Private Sub LaadCategorien()
        Me.ddlCategorie.DataSource = DatabaseLink.GetInstance.GetCategorieFuncties.GetAllCategorieBy(Me.ddlTaal.SelectedValue, Me.ddlBedrijf.SelectedValue, Me.ddlVersie.SelectedValue)
        Me.ddlCategorie.DataBind()
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
End Class
