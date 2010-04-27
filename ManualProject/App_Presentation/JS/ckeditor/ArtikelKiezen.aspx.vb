Imports Manual

Partial Class App_Presentation_JS_ckeditor_ArtikelKiezen
    Inherits System.Web.UI.Page

    Private _categoriedal As CategorieDAL = DatabaseLink.GetInstance.GetCategorieFuncties
    Private _artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            LaadDropdowns()
        End If

    End Sub

    Private Sub LaadDropdowns()

        Util.LeesVersies(ddlVersie)
        Util.LeesTalen(ddlTaal)
        Util.LeesBedrijven(ddlBedrijf)
        LaadCategorien()

    End Sub

    Private Sub LaadCategorien()

        If ddlVersie.Items.Count > 0 And ddlTaal.Items.Count > 0 And ddlTaal.Items.Count > 0 Then
            Dim dt As tblCategorieDataTable = _categoriedal.GetAllCategorieBy(ddlTaal.SelectedValue, ddlBedrijf.SelectedValue, ddlVersie.SelectedValue)
            If dt.Rows.Count > 1 Then

                Dim t As Tree = Tree.GetTree(ddlTaal.SelectedValue, ddlVersie.SelectedValue, ddlBedrijf.SelectedValue)
                ddlCategorien.Items.Clear()
                t.VulCategorieDropdown(ddlCategorien, t.RootNode, -1)

                lblGeenCategorien.Visible = False
                lblGeenArtikels.Visible = False
                ddlArtikels.Visible = True
                ddlCategorien.Visible = True
                btnArtikelSelecteren.Visible = True

                LaadArtikels()
            Else
                lblGeenCategorien.Visible = True
                lblGeenArtikels.Visible = False
                ddlArtikels.Visible = False
                ddlCategorien.Visible = False
                btnArtikelSelecteren.Visible = False
            End If
        End If

    End Sub

    Private Sub LaadArtikels()
        If Util.Valideer(ddlCategorien) Then
            Dim dt As tblArtikelDataTable = _artikeldal.GetArtikelsByParent(ddlCategorien.SelectedValue)

            If dt.Rows.Count > 0 Then
                ddlArtikels.Items.Clear()
                For Each rij As tblArtikelRow In dt
                    ddlArtikels.Items.Add(New ListItem(rij.Titel, rij.ArtikelID))
                Next
                lblGeenArtikels.Visible = False
                ddlArtikels.Visible = True
                btnArtikelSelecteren.Visible = True
            Else
                lblGeenArtikels.Visible = True
                ddlArtikels.Visible = False
                btnArtikelSelecteren.Visible = False
            End If
        End If
    End Sub

    Protected Sub ddlCategorien_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCategorien.SelectedIndexChanged
        LaadArtikels()
    End Sub

    Protected Sub btnFilteren_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilteren.Click
        LaadCategorien()
    End Sub

End Class
