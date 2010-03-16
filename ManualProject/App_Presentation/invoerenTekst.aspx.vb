Imports Manual

Partial Class App_Presentation_invoerenTest
    Inherits System.Web.UI.Page

    Private artikel As Manual.tblArtikelRow
    Private adap As New ManualTableAdapters.tblArtikelTableAdapter

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
        FK_versie = Integer.Parse(txtVersie.Text)
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

            'Nu gaan we we de boomstructuur in het geheugen updaten.

            'We halen de tree op waar dit artikel in werd opgeslagen
            Dim tree As Tree = tree.GetTree(FK_taal, FK_versie, FK_Bedrijf)

            'We proberen het artikel toe te voegen.
            Dim boodschap As String = tree.VoegArtikelToeAanCategorie(tag, FK_categorie)

            'Boodschap nakijken voor een foutboodschap
            If boodschap = "OK" Then
                lblresultaat.Text = "Gelukt."
            Else
                lblresultaat.Text = String.Concat("Toevoegen mislukt: ", boodschap)
            End If

        Else
            lblresultaat.Text = "Toevoegen mislukt: Kon het artikel niet toevoegen."
        End If

    End Sub

End Class
