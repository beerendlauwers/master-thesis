
Partial Class App_Presentation_ArtikelBewerken
    Inherits System.Web.UI.Page
    Private artikeldal As New ArtikelDAL

    Protected Sub btnZoek_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoek.Click
        Dim str As String
        Dim dt As New Data.DataTable
        Dim dr As Data.DataRow = dt.NewRow
        str = "%" + txtSearch.Text + "%"
        dt = artikeldal.GetArtikelsByTitel(str)
        For Each dr In dt.Rows
            Dim item As New ListItem(dr("titel"), dr("artikelID"))
            lsbArtikels.Items.Add(item)
        Next
       
    End Sub

    Protected Sub btnBewerken_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBewerken.Click
        Dim str As String
        Dim dt As New Data.DataTable
        Dim dr As Data.DataRow = dt.NewRow
        str = lsbArtikels.SelectedItem.Text

        dt = artikeldal.GetArtikelsByTitel(str)
        txtTag.Visible = True
        txtTitel.Visible = True
        ddlBedrijf.Visible = True
        ddlCategorie.Visible = True
        ddlTaal.Visible = True
        ddlVersie.Visible = True
        Editor1.Visible = True
        ckbFinal.Visible = True

        lblBedrijf.Visible = True
        lblCategorie.Visible = True
        lblIs_final.Visible = True
        lblTaal.Visible = True
        lblTag.Visible = True
        lblTitel.Visible = True
        lblVersie.Visible = True

        ddlCategorie.SelectedValue = dt.Rows(0)("FK_categorie")
        txtTitel.Text = dt.Rows(0)("titel")
        txtTag.Text = dt.Rows(0)("tag")
        Editor1.Content = dt.Rows(0)("tekst")
        ddlBedrijf.SelectedValue = dt.Rows(0)("FK_Bedrijf")
        ddlTaal.SelectedValue = dt.Rows(0)("FK_Taal")
        ddlVersie.SelectedValue = dt.Rows(0)("FK_Versie")
        If dt.Rows(0)("Is_final") = 1 Then
            ckbFinal.Checked = True
        Else
            ckbFinal.Checked = False
        End If

    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        Dim artikel As New Artikel

        artikel.Bedrijf = ddlBedrijf.SelectedValue
        artikel.ID = lsbArtikels.SelectedValue
        artikel.Categorie = ddlCategorie.SelectedValue
        artikel.Tag = txtTag.Text
        artikel.Tekst = Editor1.Content
        artikel.Titel = txtTitel.Text
        artikel.Versie = ddlVersie.SelectedValue
        If ckbFinal.Checked = True Then
            artikel.IsFinal = 1
        Else
            artikel.IsFinal = 0
        End If
        If artikeldal.updateArtikel(artikel) = True Then
            lblVar.Text = "update geslaagd"
            lblVar.Visible = True
        Else
            lblVar.Text = "update mislukt"
            lblVar.Visible = True
        End If
    End Sub
End Class
