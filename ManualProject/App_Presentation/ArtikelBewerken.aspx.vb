Imports Manual

Partial Class App_Presentation_ArtikelBewerken
    Inherits System.Web.UI.Page

    Private artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Page.Title = "Artikel Bewerken"

        If Page.Request.QueryString("id") IsNot Nothing Then
            If IsNumeric(Page.Request.QueryString("id")) = True Then

                Dim id As Integer = Page.Request.QueryString("id")
                LaadArtikel(id)
            End If
        End If

    End Sub

    Protected Sub btnZoek_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoek.Click
        Dim titel As String

        Dim zoekterm As String = "%" + Me.txtZoekTitel.Text.Trim + "%"

        Dim upd As UpdatePanel = Me.FindControl("updToevoegen")
        Dim grdvLijst As GridView = updZoeken.FindControl("grdvLijst")
        Dim dt As tblArtikelDataTable = ArtikelDAL.GetArtikelsByTitel(zoekterm)

        If dt IsNot Nothing Then
            For Each row As tblArtikelRow In dt
                Dim item As New ListItem(row.Titel, row.ArtikelID)
                'lsbArtikels.Items.Add(item)
            Next row
        End If
        'btnBewerken.Visible = True
        'lsbArtikels.Visible = True
        titel = txtZoekTitel.Text
        If titel.Length > 0 Then
            titel = "%" + Me.txtZoekTitel.Text + "%"
            grdvLijst.DataSource = artikeldal.GetArtikelGegevensByTitel(titel)
            grdvLijst.DataBind()
            grdvLijst.Visible = True


        End If
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        Dim artikel As New Artikel

        artikel.Bedrijf = ddlBedrijf.SelectedValue
        'artikel.ID = lsbArtikels.SelectedValue
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

            'Boomstructuur in het geheugen updaten.

            'We halen de tree op waar dit artikel in werd opgeslagen
            Dim tree As Tree = tree.GetTree(artikel.Taal, artikel.Versie, artikel.Bedrijf)

            'We zoeken het artikel op en updaten het.
            Dim node As Node = tree.DoorzoekTreeVoorNode(artikel.ID, Global.ContentType.Artikel)

            If node Is Nothing Then
                lblVar.Text = "Update mislukt: Kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met wijzigingen te maken."
                lblVar.Visible = True
                Return
            Else
                node.Titel = artikel.Titel
            End If

            lblVar.Text = "Update geslaagd."
            lblVar.Visible = True
        Else
            lblVar.Text = "Update mislukt: Kon niet met de database verbinden."
            lblVar.Visible = True
        End If
    End Sub

    Protected Sub grdvLijst_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdvLijst.RowCommand
        If e.CommandName = "Select" Then
            Dim upd As UpdatePanel = Me.FindControl("updToevoegen")
            Dim grdvLijst As GridView = updZoeken.FindControl("grdvLijst")
            Dim row As GridViewRow = grdvLijst.Rows(e.CommandArgument)


            Dim artikeltag As String = row.Cells(1).Text
            LaadArtikel(artikeltag)
        End If
    End Sub

    Private Sub LaadArtikel(ByVal id As Integer)
        Dim artikel As New Artikel(artikeldal.GetArtikelByID(id))
        ArtikelInladen(artikel)
    End Sub

    Private Sub LaadArtikel(ByVal tag As String)
        Dim artikel As New Artikel(artikeldal.GetArtikelByTag(tag))
        ArtikelInladen(artikel)
    End Sub

    Private Sub ArtikelInladen(ByVal artikel As Artikel)
        txtTag.Visible = True
        txtTitel.Visible = True
        ddlBedrijf.Visible = True
        ddlCategorie.Visible = True
        ddlTaal.Visible = True
        ddlVersie.Visible = True
        Editor1.Visible = True
        ckbFinal.Visible = True
        btnUpdate.Visible = True


        lblBedrijf.Visible = True
        lblCategorie.Visible = True
        lblIs_final.Visible = True
        lblTaal.Visible = True
        lblTag.Visible = True
        lblTitel.Visible = True
        lblVersie.Visible = True

        ddlCategorie.SelectedValue = artikel.Categorie
        txtTitel.Text = artikel.Titel
        txtTag.Text = artikel.Tag
        Editor1.Content = artikel.Tekst
        ddlBedrijf.SelectedValue = artikel.Bedrijf
        ddlTaal.SelectedValue = artikel.Taal
        ddlVersie.SelectedValue = artikel.Versie

        If artikel.IsFinal = 1 Then
            ckbFinal.Checked = True
        Else
            ckbFinal.Checked = False
        End If

        updBewerken.Update()

        lblVar.Text = String.Empty
    End Sub


End Class
