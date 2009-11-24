
Partial Class App_Presentation_Chauffeur
    Inherits System.Web.UI.Page

    

    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsert.Click

        Dim klantdal As New KlantDAL
        Dim c As New Chauffeur
        Dim chauffeurbll As New ChauffeurBLL
        Dim chauffeurbedrijf As String
        c.ChauffeurNaam = txtcNaam.Text
        c.ChauffeurVoornaam = txtcVoornaam.Text
        chauffeurbedrijf = txtBedrijf.Text
        c.ChauffeurBedrijfID = KlantDAL.getKlantID(chauffeurbedrijf)

        ChauffeurBLL.AddChauffeur(c)

    End Sub
End Class
