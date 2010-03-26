Imports Manual

Partial Class App_Presentation_Beheer
    Inherits System.Web.UI.Page

    Dim artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties
    Dim categoriedal As CategorieDAL = DatabaseLink.GetInstance.GetCategorieFuncties
    Dim versiedal As VersieDAL = DatabaseLink.GetInstance.GetVersieFuncties
    Dim taaldal As TaalDAL = DatabaseLink.GetInstance.GetTaalFuncties
    Dim bedrijfdal As BedrijfDAL = DatabaseLink.GetInstance.GetBedrijfFuncties

    Dim adapterCat As New ManualTableAdapters.tblCategorieTableAdapter
    Dim adapterVersie As New ManualTableAdapters.tblVersieTableAdapter
    Dim adapterBedrijf As New ManualTableAdapters.tblBedrijfTableAdapter
    Dim adapterTaal As New ManualTableAdapters.tblTaalTableAdapter


#Region "Code voor Categoriebeheer"

#Region "Code: Categorie Toevoegen"

    Protected Sub btnCatAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatAdd.Click

        'Gewenste hoogte opslaan
        Dim hoogte As Integer = Integer.Parse(txtAddhoogte.Text)

        'CategorieID ophalen van parent categorie
        Dim parentCategorieID As Integer = ddlAddParentcat.SelectedValue

        'Parent categorie ophalen uit database
        Dim parentCategorierij As tblCategorieRow = categoriedal.getCategorieByID(parentCategorieID)

        'Hoogte van parent categorie opslaan
        Dim parentHoogte As Integer = parentCategorierij.Hoogte

        'Hoogte van de parent updaten als deze groter (+1) is dan de gewenste hoogte 
        If hoogte < parentHoogte + 1 Then
            categoriedal.updateHoogte(hoogte, parentCategorieID)
        End If

        'Alle gegevens inlezen
        Dim c As New Categorie
        c.Bedrijf = ddlAddCatBedrijf.SelectedValue
        c.Versie = ddlAddCatVersie.SelectedValue
        c.Categorie = txtAddCatnaam.Text
        c.Diepte = parentCategorierij.Diepte + 1
        c.Hoogte = hoogte
        c.FK_Parent = parentCategorieID
        c.FK_Taal = ddlAddCatTaal.SelectedValue

        'Nagaan of er reeds een categorie met dezelfde naam bestaat in deze versie en bedrijf.
        If categoriedal.checkCategorie(c.Categorie, c.Bedrijf, c.Versie) Is Nothing Then

            'Alles ok, categorie inserten
            Dim categorieID As Integer = categoriedal.insertCategorie(c)

            If Not categorieID = -1 Then

                'Toevoegen in geheugen
                Dim tree As Tree = tree.GetTree(c.FK_Taal, c.Versie, c.Bedrijf)

                'Parent opzoeken
                Dim parent As Node = tree.DoorzoekTreeVoorNode(c.FK_Parent, Global.ContentType.Categorie)

                If parent Is Nothing Then
                    lblResAdd.Text = "Categorie toegevoegd met waarschuwing: kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met uw wijzigingen."
                    txtAddCatnaam.Text = String.Empty
                    txtAddhoogte.Text = String.Empty
                Else
                    Dim kind As New Node(categorieID, Global.ContentType.Categorie, c.Categorie, c.Hoogte)

                    parent.AddChild(kind)

                    lblResAdd.Text = "Categorie toegevoegd."
                    txtAddCatnaam.Text = String.Empty
                    txtAddhoogte.Text = String.Empty
                End If
            Else
                lblResAdd.Text = "Toevoegen mislukt."
            End If

        Else
            lblResAdd.Text = "Deze categorie bestaat reeds voor deze versie of dit bedrijf."
        End If

        Toevoegen_LaadCategorien()
        Wijzigen_LaadCategorien()
        Wijzigen_LaadCategorienParent()
        Verwijderen_LaadCategorien()

    End Sub

    Protected Sub ddlAddCatBedrijf_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatBedrijf.DataBound
        Toevoegen_LaadCategorien()
    End Sub

    Protected Sub ddlAddCatTaal_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatTaal.DataBound
        Toevoegen_LaadCategorien()
    End Sub

    Protected Sub ddlAddCatVersie_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatVersie.DataBound
        Toevoegen_LaadCategorien()
    End Sub

    Protected Sub ddlAddCatBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatBedrijf.SelectedIndexChanged
        Toevoegen_LaadCategorien()
    End Sub

    Protected Sub ddlAddCatTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatTaal.SelectedIndexChanged
        Toevoegen_LaadCategorien()
    End Sub

    Protected Sub ddlAddCatVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatVersie.SelectedIndexChanged
        Toevoegen_LaadCategorien()
    End Sub

    Protected Sub ddlAddParentcat_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Toevoegen_LaadCategorieHoogte()
    End Sub

    Private Sub Toevoegen_LaadCategorien()

        If ddlAddCatBedrijf.Items.Count > 0 And ddlAddCatTaal.Items.Count > 0 And ddlAddCatVersie.Items.Count > 0 Then

            'Relevante categorieën ophalen
            ddlAddParentcat.DataSource = categoriedal.GetAllCategorieBy(ddlAddCatTaal.SelectedValue, ddlAddCatBedrijf.SelectedValue, ddlAddCatVersie.SelectedValue)
            ddlAddParentcat.DataBind()

            'Hoogte van parentcategorie ophalen
            Toevoegen_LaadCategorieHoogte()

        End If

    End Sub

    Private Sub Toevoegen_LaadCategorieHoogte()

        'CategorieID ophalen van gewenste categorie
        Dim categorieID As Integer = ddlAddParentcat.SelectedValue
        Dim bedrijfID As Integer = ddlAddCatBedrijf.SelectedValue
        Dim taalID As Integer = ddlAddCatTaal.SelectedValue
        Dim versieID As Integer = ddlAddCatVersie.SelectedValue

        'Hoogte van parent categorie ophalen
        Dim parentHoogte As Integer = categoriedal.getHoogte(categorieID, bedrijfID, versieID, taalID)

        If (parentHoogte = Nothing) Then
            txtAddhoogte.Text = 0
        Else
            txtAddhoogte.Text = parentHoogte + 1
        End If

    End Sub

#End Region

#Region "Code: Categorie Wijzigen"


    Protected Sub btnCatEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatEdit.Click

        'Alles gegevens inlezen
        Dim c As New Categorie

        c.CategorieID = ddlEditCategorie.SelectedValue
        c.Categorie = txtCatbewerknaam.Text
        c.FK_Parent = ddlEditCatParent.SelectedValue

        Dim parentCategorierij As tblCategorieRow = categoriedal.getCategorieByID(c.FK_Parent)
        c.Diepte = parentCategorierij.Diepte + 1

        c.FK_Taal = ddlEditCatTaal.SelectedValue
        c.Hoogte = txtEditCathoogte.Text
        c.Bedrijf = ddlEditCatBedrijf.SelectedValue
        c.Versie = ddlEditCatVersie.SelectedValue

        'Nagaan of de gewenste categorienaam reeds in gebruik is door een andere categorie.
        If (categoriedal.checkCategorieByID(c.Categorie, c.Bedrijf, c.Versie, c.CategorieID) Is Nothing) Then

            'Alles ok, categorie updaten
            If (categoriedal.updateCategorie(c)) Then

                'Geheugen updaten
                Dim tree As Tree = tree.GetTree(c.FK_Taal, c.Versie, c.Bedrijf)
                Dim node As Node = tree.DoorzoekTreeVoorNode(c.CategorieID, Global.ContentType.Categorie)

                If node Is Nothing Then
                    lblResEdit.Text = "Categorie gewijzigd met waarschuwing: kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met uw wijzigingen."
                Else
                    node.Titel = c.Categorie
                    node.Hoogte = c.Hoogte

                    'Nakijken of de categorie onder een andere categorie is verplaatst
                    Dim oudeparent As Node = tree.VindParentVanNode(node)
                    Dim nieuweparent As Node = tree.DoorzoekTreeVoorNode(c.FK_Parent, Global.ContentType.Categorie)

                    If Not oudeparent Is nieuweparent Then
                        'De parents zijn verschillend, dus de categorie is onder een nieuwe categorie verplaatst
                        nieuweparent.AddChild(node)
                        oudeparent.RemoveChild(node)
                    End If

                    lblResEdit.Text = "Categorie gewijzigd."
                End If
            Else
                lblResEdit.Text = "Wijziging mislukt."
            End If
        Else
            lblResEdit.Text = "Een andere categorie in deze combinate van versie en bedrijf heeft reeds dezelfde naam."
        End If

        Toevoegen_LaadCategorien()
        Wijzigen_LaadCategorien()
        Wijzigen_LaadCategorienParent()
        Verwijderen_LaadCategorien()

    End Sub

    Protected Sub btnEditCatVerfijnen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditCatVerfijnen.Click
        Wijzigen_LaadCategorien()
    End Sub

    Protected Sub ddlEditCatBedrijf_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatBedrijf.DataBound
        Wijzigen_LaadCategorienParent()
    End Sub

    Protected Sub ddlEditCatTaal_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatTaal.DataBound
        Wijzigen_LaadCategorienParent()
    End Sub

    Protected Sub ddlEditCatVersie_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatVersie.DataBound
        Wijzigen_LaadCategorienParent()
    End Sub

    Protected Sub ddlEditCatBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatBedrijf.SelectedIndexChanged
        Wijzigen_LaadCategorienParent()
    End Sub

    Protected Sub ddlEditCatTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatTaal.SelectedIndexChanged
        Wijzigen_LaadCategorienParent()
    End Sub

    Protected Sub ddlEditCatVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatVersie.SelectedIndexChanged
        Wijzigen_LaadCategorienParent()
    End Sub

    Protected Sub ddlEditCategorie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Wijzigen_LaadCategorieDetails()
    End Sub

    Protected Sub ddlEditCatParent_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Wijzigen_LaadCategorieHoogte()
    End Sub

    Protected Sub ddlEditCatParent_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatParent.DataBound
        Wijzigen_LaadCategorieHoogte()
    End Sub

    Protected Sub ddlEditCatBedrijfkeuze_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatBedrijfkeuze.DataBound
        Wijzigen_LaadCategorien()
    End Sub

    Protected Sub ddlEditCatTaalkeuze_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatTaalkeuze.DataBound
        Wijzigen_LaadCategorien()
    End Sub

    Protected Sub ddlEditCatVersiekeuze_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatVersiekeuze.DataBound
        Wijzigen_LaadCategorien()
    End Sub

    Private Sub Wijzigen_LaadCategorien()

        If ddlEditCatBedrijfkeuze.Items.Count > 0 And ddlEditCatTaalkeuze.Items.Count > 0 And ddlEditCatVersiekeuze.Items.Count > 0 Then

            'Relevante categorieën ophalen
            ddlEditCategorie.DataSource = categoriedal.GetAllCategorieBy(ddlEditCatTaalkeuze.SelectedValue, ddlEditCatBedrijfkeuze.SelectedValue, ddlEditCatVersiekeuze.SelectedValue)
            ddlEditCategorie.DataBind()

            'root_node eruit halen
            ddlEditCategorie.Items.Remove(New ListItem("root_node", "0"))

            If ddlEditCategorie.Items.Count = 0 Then
                ddlEditCategorieGeenCats.Visible = True

                divEditCategorie.Visible = False
                trCatBewerkNaam.Visible = False
                trBewerkCatHoogte.Visible = False
                trBewerkCatTaal.Visible = False
                trBewerkCatVersie.Visible = False
                trBewerkCatBedrijf.Visible = False
                trBewerkParentCat.Visible = False
                trCatEditButton.Visible = False
            Else
                Wijzigen_LaadCategorieDetails()
                ddlEditCategorieGeenCats.Visible = False

                divEditCategorie.Visible = True
                trCatBewerkNaam.Visible = True
                trBewerkCatHoogte.Visible = True
                trBewerkCatTaal.Visible = True
                trBewerkCatVersie.Visible = True
                trBewerkCatBedrijf.Visible = True
                trBewerkParentCat.Visible = True
                trCatEditButton.Visible = True
            End If

        End If

    End Sub

    Private Sub Wijzigen_LaadCategorienParent()

        If ddlEditCatBedrijf.Items.Count > 0 And ddlEditCatTaal.Items.Count > 0 And ddlEditCatVersie.Items.Count > 0 Then

            'Relevante categorieën ophalen
            ddlEditCatParent.DataSource = categoriedal.GetAllCategorieBy(ddlEditCatTaal.SelectedValue, ddlEditCatBedrijf.SelectedValue, ddlEditCatVersie.SelectedValue)
            ddlEditCatParent.DataBind()

            'eigen categorie eruit halen
            ddlEditCatParent.Items.Remove(ddlEditCategorie.SelectedItem)

            'Hoogte van parentcategorie ophalen
            Wijzigen_LaadCategorieHoogte()

        End If

    End Sub

    Private Sub Wijzigen_LaadCategorieHoogte()

        'CategorieID ophalen van gewenste categorie
        Dim categorieID As Integer = ddlAddParentcat.SelectedValue
        Dim bedrijfID As Integer = ddlAddCatBedrijf.SelectedValue
        Dim taalID As Integer = ddlAddCatTaal.SelectedValue
        Dim versieID As Integer = ddlAddCatVersie.SelectedValue

        'Hoogte van parent categorie ophalen
        Dim parentHoogte As Integer = categoriedal.getHoogte(categorieID, bedrijfID, versieID, taalID)

        Dim hoogte As Integer
        If parentHoogte = Nothing Then
            hoogte = 0
        Else
            hoogte = parentHoogte
        End If

        txtEditCathoogte.Text = hoogte

    End Sub

    Private Sub Wijzigen_LaadCategorieDetails()

        If ddlEditCatBedrijf.Items.Count > 0 And ddlEditCatTaal.Items.Count > 0 And ddlEditCatVersie.Items.Count > 0 Then

            'CategorieID ophalen van gewenste categorie
            Dim categorieID As Integer = ddlEditCategorie.SelectedValue

            'Categoriegegevens ophalen
            Dim categorieRij As tblCategorieRow = categoriedal.getCategorieByID(categorieID)

            'Categoriegegevens inlezen
            txtCatbewerknaam.Text = categorieRij.Categorie
            ddlEditCatTaal.SelectedValue = categorieRij.FK_taal
            ddlEditCatBedrijf.SelectedValue = categorieRij.FK_bedrijf
            ddlEditCatVersie.SelectedValue = categorieRij.FK_versie

            Wijzigen_LaadCategorienParent()

            ddlEditCatParent.SelectedValue = categorieRij.FK_parent

            Dim bedrijfID As Integer = ddlAddCatBedrijf.SelectedValue
            Dim taalID As Integer = ddlAddCatTaal.SelectedValue
            Dim versieID As Integer = ddlAddCatVersie.SelectedValue

            'Hoogte van parent categorie ophalen
            Dim parentHoogte As Integer = categoriedal.getHoogte(categorieID, bedrijfID, versieID, taalID)

            Dim hoogte As Integer
            If parentHoogte = Nothing Then
                hoogte = 0
            Else
                hoogte = parentHoogte
            End If

            txtEditCathoogte.Text = hoogte

        End If
    End Sub

#End Region

#Region "Code: Categorie Verwijderen"

    Protected Sub btnCatDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatDelete.Click

        Dim categorieID As Integer = ddlCatVerwijder.SelectedValue

        'Nakijken of er nog artikels of categorieën onder deze categorie staan
        If (categoriedal.getArtikelsByParent(categorieID) Is Nothing) And (categoriedal.getCategorieByParent(categorieID) Is Nothing) Then

            'Alles ok, categorie verwijderen
            If Not adapterCat.Delete(categorieID) = 0 Then

                'Geheugen updaten
                Dim tree As Tree = tree.GetTree(ddlCatDelTaalkeuze.SelectedValue, ddlCatDelVersiekeuze.SelectedValue, ddlCatDelBedrijfkeuze.SelectedValue)
                Dim node As Node = tree.DoorzoekTreeVoorNode(categorieID, Global.ContentType.Categorie)

                If node Is Nothing Then
                    lblResEdit.Text = "Categorie verwijderd met waarschuwing: kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met uw wijzigingen."
                Else
                    Dim parent As Node = tree.VindParentVanNode(node)

                    If parent Is Nothing Then
                        lblResEdit.Text = "Categorie verwijderd met waarschuwing: kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met uw wijzigingen."
                    Else
                        parent.RemoveChild(node)
                        lblResDelete.Text = "Verwijderen geslaagd."
                    End If
                End If

            Else
                lblResDelete.Text = "Verwijderen mislukt."
            End If

        Else
            lblResDelete.Text = "Er staan nog artikels of andere categorieën onder deze categorie."
        End If

        Toevoegen_LaadCategorien()
        Wijzigen_LaadCategorien()
        Wijzigen_LaadCategorienParent()
        Verwijderen_LaadCategorien()
    End Sub

    Protected Sub btnCatDelFilteren_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatDelFilteren.Click
        Verwijderen_LaadCategorien()
    End Sub

    Protected Sub ddlCatDelBedrijfkeuze_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCatDelBedrijfkeuze.DataBound
        Verwijderen_LaadCategorien()
    End Sub

    Protected Sub ddlCatDelTaalkeuze_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCatDelTaalkeuze.DataBound
        Verwijderen_LaadCategorien()
    End Sub

    Protected Sub ddlCatDelVersiekeuze_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCatDelVersiekeuze.DataBound
        Verwijderen_LaadCategorien()
    End Sub

    Private Sub Verwijderen_LaadCategorien()

        If ddlCatDelBedrijfkeuze.Items.Count > 0 And ddlCatDelTaalkeuze.Items.Count > 0 And ddlCatDelVersiekeuze.Items.Count > 0 Then

            'Relevante categorieën ophalen
            ddlCatVerwijder.DataSource = categoriedal.GetAllCategorieBy(ddlCatDelTaalkeuze.SelectedValue, ddlCatDelBedrijfkeuze.SelectedValue, ddlCatDelVersiekeuze.SelectedValue)
            ddlCatVerwijder.DataBind()

            'root_node verwijderen
            ddlCatVerwijder.Items.Remove(New ListItem("root_node", "0"))

            If ddlCatVerwijder.Items.Count = 0 Then
                ddlCatVerwijder.Visible = False
                lblCatVerwijderGeenCats.Visible = True
                btnCatDelete.Visible = False
            Else
                ddlCatVerwijder.Visible = True
                lblCatVerwijderGeenCats.Visible = False
                btnCatDelete.Visible = True
            End If

        End If
    End Sub

#End Region

#End Region

#Region "Code voor Taalbeheer"

    Protected Sub btnAddTaal_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTaal.Click

        Dim taaltext As String = txtAddTaal.Text
        Dim taaltag As String = txtTaalAfkorting.Text

        If (taaldal.checkTaal(taaltext) Is Nothing) Then
            Dim taalID As Integer = taaldal.insertTaal(taaltext, taaltag)
            If taalID = -1 Then
                lblAddTaalRes.Text = "Toevoegen mislukt."
            Else
                'Geheugen updaten
                Taal.AddTaal(New Taal(taalID, taaltext, taaltag))

                lblAddTaalRes.Text = "Toevoegen gelukt."
            End If
        Else
            lblAddTaalRes.Text = "Deze taal is reeds toegvoegd."
        End If

        ddlBewerkTaal.DataBind()
        ddlTaalDelete.DataBind()
    End Sub

    Protected Sub btnEditTaal_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditTaal.Click

        Dim taaltag As String = txtEditAfkorting.Text
        Dim taalID As String = ddlBewerkTaal.SelectedValue
        Dim taaltext As String = txtEditTaal.Text
        If (taaldal.checkTaalByID(taaltext, taalID) Is Nothing) Then
            If (adapterTaal.Update(taaltext, taaltag, taalID) = 0) Then
                lblEditTaalRes.Text = "Wijzigen mislukt."
            Else

                'Geheugen updaten
                Dim taal As Taal = taal.GetTaal(taalID)

                If taal Is Nothing Then
                    lblEditTaalRes.Text = "Wijzigen gelukt met waarschuwing: kon de taalstructuur niet updaten. Herbouw de taalstructuur als u klaar bent met uw wijzigingen."
                Else
                    taal.TaalNaam = taaltext
                    taal.TaalTag = taaltag

                    lblEditTaalRes.Text = "Wijzigen gelukt."
                End If

            End If
        Else
            lblEditTaalRes.Text = "Een andere taal heeft deze naam al."
        End If

        ddlBewerkTaal.DataBind()
        ddlTaalDelete.DataBind()
    End Sub

    Protected Sub btnTaalDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTaalDelete.Click

        Dim taalID As Integer = ddlTaalDelete.SelectedValue
        If (artikeldal.getArtikelsByTaal(taalID) Is Nothing) Then
            If (adapterTaal.Delete(taalID) = 0) Then
                lblDeleteTaalRes.Text = "Verwijderen mislukt."
            Else

                'Geheugen updaten
                Dim t As Taal = Taal.GetTaal(taalID)

                If t Is Nothing Then
                    lblDeleteTaalRes.Text = "Verwijderen gelukt met waarschuwing: kon de taalstructuur niet updaten. Herbouw de taalstructuur als u klaar bent met uw wijzigingen."
                Else
                    Taal.RemoveTaal(t)
                    lblDeleteTaalRes.Text = "Verwijderen gelukt."
                End If

               
            End If
        Else
            lblDeleteTaalRes.Text = "Er bestaan nog artikels onder deze taal."
        End If
        ddlBewerkTaal.DataBind()
        ddlTaalDelete.DataBind()
    End Sub

    Protected Sub ddlBewerkTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        txtEditTaal.Text = ddlBewerkTaal.SelectedItem.Text
        Dim taal As String = ddlBewerkTaal.SelectedItem.Text
        Dim taalid As Integer = ddlBewerkTaal.SelectedValue
        Dim dr As Manual.tblTaalRow
        dr = taaldal.GetTaalByID(taalid)
        txtEditAfkorting.Text = dr.TaalTag
    End Sub

    Protected Sub ddlBewerkTaal_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBewerkTaal.DataBound
        txtEditTaal.Text = ddlBewerkTaal.SelectedItem.Text
        Dim dr As Manual.tblTaalRow
        dr = taaldal.GetTaalByID(ddlBewerkTaal.SelectedValue)
        txtEditAfkorting.Text = dr.TaalTag
    End Sub

#End Region

#Region "Code voor Versiebeheer"

    Protected Sub btnAddVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddVersie.Click
        Dim versietext As String = txtAddVersie.Text


        If (versiedal.CheckVersie(versietext) Is Nothing) Then
            Dim versieID As Integer = versiedal.insertVersie(versietext)

            If versieID = -1 Then
                lblAddVersieRes.Text = "Toevoegen mislukt."
            Else

                'Geheugen updaten
                Versie.AddVersie(New Versie(versieID, versietext))

                lblAddVersieRes.Text = "Toevoegen gelukt."
            End If
        Else
            lblAddVersieRes.Text = "Deze versie bestaat reeds."
        End If

        ddlBewerkVersie.DataBind()
        ddlDeletVersie.DataBind()
    End Sub

    Protected Sub btnEditVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditVersie.Click

        Dim versietext As String = txtEditVersie.Text
        Dim versieID As Integer = ddlBewerkVersie.SelectedValue
        If (versiedal.CheckVersieByID(versietext, versieID) Is Nothing) Then
            If adapterVersie.Update(versietext, versieID) = 0 Then
                lblEditVersieRes.Text = "Wijzigen mislukt."
            Else
                'Geheugen updaten
                Dim v As Versie = Versie.GetVersie(versieID)

                If v Is Nothing Then
                    lblEditVersieRes.Text = "Wijzigen gelukt met waarschuwing: kon de versiestructuur niet updaten. Herbouw de versiestructuur als u klaar bent met uw wijzigingen."
                Else
                    v.VersieNaam = versietext
                    lblEditVersieRes.Text = "Wijzigen gelukt."
                End If

            End If
        Else
            lblEditVersieRes.Text = "Een andere versie heeft deze naam al."
        End If

        ddlBewerkVersie.DataBind()
        ddlDeletVersie.DataBind()
    End Sub

    Protected Sub btnDeleteVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteVersie.Click

        Dim versieID As Integer = ddlDeletVersie.SelectedValue
        If (artikeldal.getArtikelsByVersie(versieID) Is Nothing) Then
            If (adapterVersie.Delete(versieID) = 0) Then
                lblDeleteVersieRes.Text = "Verwijderen mislukt."
            Else

                'Geheugen updaten
                Dim v As Versie = Versie.GetVersie(versieID)

                If v Is Nothing Then
                    lblDeleteVersieRes.Text = "Wijzigen gelukt met waarschuwing: kon de versiestructuur niet updaten. Herbouw de versiestructuur als u klaar bent met uw wijzigingen."
                Else
                    Versie.RemoveVersie(v)
                    lblDeleteVersieRes.Text = "Verwijderen gelukt."
                End If

            End If
        Else
            lblDeleteVersieRes.Text = "Deze versie heeft nog artikels onder zich."
        End If
        ddlBewerkVersie.DataBind()
        ddlDeletVersie.DataBind()
    End Sub

    Protected Sub ddlBewerkVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        txtEditVersie.Text = ddlBewerkVersie.SelectedItem.Text
    End Sub

    Protected Sub ddlBewerkVersie_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBewerkVersie.DataBound
        txtEditVersie.Text = ddlBewerkVersie.SelectedItem.Text
    End Sub

#End Region

#Region "Code voor Bedrijfbeheer"

    Protected Sub btnAddBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddBedrijf.Click
        Dim bedrijfTag As String = txtAddTag.Text
        Dim bedrijfnaam As String = txtAddbedrijf.Text
        If (bedrijfdal.getBedrijfByNaamOrTag(bedrijfnaam, bedrijfTag) Is Nothing) Then

            Dim bedrijfID As Integer = bedrijfdal.insertBedrijf(bedrijfnaam, bedrijfTag)

            If bedrijfID = -1 Then
                lblAddBedrijfRes.Text = "Toevoegen mislukt."
            Else

                'Geheugen updaten
                Bedrijf.AddBedrijf(New Bedrijf(bedrijfID, bedrijfnaam, bedrijfTag))
                lblAddBedrijfRes.Text = "Toevoegen gelukt."
            End If
        Else
            lblAddBedrijfRes.Text = "Dit bedrijf bestaat al, of een ander bedrijf heeft reeds dezelfde tag."
        End If
        ddlBewerkBedrijf.DataBind()
        ddlDeleteBedrijf.DataBind()
    End Sub

    Protected Sub btnEditBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditBedrijf.Click

        Dim bedrijfID As Integer = ddlBewerkBedrijf.SelectedValue
        Dim bedrijfTag As String = txtEditTag.Text
        Dim bedrijfnaam As String = txtEditBedrijf.Text

        If (bedrijfdal.getBedrijfByNaamTagID(bedrijfnaam, bedrijfTag, bedrijfID) Is Nothing) Then
            If (adapterBedrijf.Update(bedrijfnaam, bedrijfTag, bedrijfID) = 0) Then
                lblEditbedrijfRes.Text = "Wijzigen mislukt."
            Else

                'Geheugen updaten
                Dim b As Bedrijf = Bedrijf.GetBedrijf(bedrijfID)

                If b Is Nothing Then
                    lblEditbedrijfRes.Text = "Wijzigen gelukt met waarschuwing: kon de bedrijfstructuur niet updaten. Herbouw de bedrijfstructuur als u klaar bent met uw wijzigingen."
                Else
                    b.Naam = bedrijfnaam
                    b.Tag = bedrijfTag
                    lblEditbedrijfRes.Text = "Wijzigen gelukt."
                End If
            End If
        Else
            lblEditbedrijfRes.Text = "Een ander bedrijf heeft reeds deze bedrijfsnaam of tag."
        End If

        ddlBewerkBedrijf.DataBind()
        ddlDeleteBedrijf.DataBind()
    End Sub

    Protected Sub btnDeleteBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteBedrijf.Click

        Dim bedrijfID As Integer = ddlDeleteBedrijf.SelectedValue
        If (artikeldal.getArtikelsByBedrijf(bedrijfID) Is Nothing) Then
            If (adapterBedrijf.Delete(bedrijfID) = 0) Then
                lblDeleteBedrijfRes.Text = "Verwijderen mislukt."
            Else

                'Geheugen updaten
                Dim b As Bedrijf = Bedrijf.GetBedrijf(bedrijfID)
                If b Is Nothing Then
                    lblDeleteBedrijfRes.Text = "Verwijderen gelukt met waarschuwing: kon de bedrijfstructuur niet updaten. Herbouw de bedrijfstructuur als u klaar bent met uw wijzigingen."
                Else
                    Bedrijf.RemoveBedrijf(b)
                    lblDeleteBedrijfRes.Text = "Verwijderen gelukt."
                End If

            End If
        Else
            lblDeleteBedrijfRes.Text = "Er staan nog artikels onder dit bedrijf."
        End If
            ddlBewerkBedrijf.DataBind()
            ddlDeleteBedrijf.DataBind()
    End Sub

    Protected Sub ddlBewerkBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        txtEditBedrijf.Text = ddlBewerkBedrijf.SelectedItem.Text
        Dim dr As Manual.tblBedrijfRow
        dr = bedrijfdal.GetBedrijfByID(ddlBewerkBedrijf.SelectedValue)
        txtEditTag.Text = dr("Tag")
    End Sub

    Protected Sub ddlBewerkBedrijf_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBewerkBedrijf.DataBound
        txtEditBedrijf.Text = ddlBewerkBedrijf.SelectedItem.Text
        Dim dr As Manual.tblBedrijfRow
        dr = bedrijfdal.GetBedrijfByID(ddlBewerkBedrijf.SelectedValue)
        txtEditTag.Text = dr("Tag")
    End Sub

#End Region

#Region "Page Load Methods"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.Title = "Beheerpagina"

        LaadJavascript()
        LaadTooltips()

    End Sub

    Private Sub LaadTooltips()

        'Nieuwe lijst van tooltips definiëren
        Dim lijst As New List(Of Tooltip)

        'Alle tooltips voor onze pagina toevoegen

        'Bedrijfbeheer
        lijst.Add(New Tooltip("tipAddBedrijf", "De bedrijfsnaam van het bedrijf."))
        lijst.Add(New Tooltip("tipAddTag", "De <b>unieke</b> tag van het bedrijf. Mag enkel letters, nummers en een underscore ( _ ) bevatten."))
        lijst.Add(New Tooltip("tipEditBedrijf", "De bedrijfsnaam van het bedrijf."))
        lijst.Add(New Tooltip("tipEditTag", "De <b>unieke</b> tag van het bedrijf. Mag enkel letters, nummers en een underscore ( _ ) bevatten."))
        lijst.Add(New Tooltip("tipBewerkBedrijf", "Het bedrijf dat u wilt wijzigen."))
        lijst.Add(New Tooltip("tipDeleteBedrijf", "Het bedrijf dat u wilt verwijderen."))

        'Taalbeheer
        lijst.Add(New Tooltip("tipAddTaal", "De naam van de taal."))
        lijst.Add(New Tooltip("tipTaalAfkorting", "De afkorting van de taal. Deze wordt gebruikt bij de taalkeuze voor gebruikers."))
        lijst.Add(New Tooltip("tipEditTaal", "De naam van de taal."))
        lijst.Add(New Tooltip("tipEditAfkorting", "De afkorting van de taal. Deze wordt gebruikt bij de taalkeuze voor gebruikers."))
        lijst.Add(New Tooltip("tipBewerkTaal", "De taal die u wilt wijzigen."))
        lijst.Add(New Tooltip("tipTaalDelete", "De taal die u wilt verwijderen."))

        'Versiebeheer
        lijst.Add(New Tooltip("tipAddVersie", "Het versienummer van de versie. Mag enkel nummers en stoptekens ( . ) bevatten."))
        lijst.Add(New Tooltip("tipEditVersie", "Het versienummer van de versie. Mag enkel nummers en stoptekens ( . ) bevatten."))
        lijst.Add(New Tooltip("tipBewerkVersie", "De versie die u wilt wijzigen."))
        lijst.Add(New Tooltip("tipDeleteVersie", "De versie die u wilt verwijderen."))

        'Categoriebeheer
        lijst.Add(New Tooltip("tipAddCatnaam", "De naam van de categorie."))
        lijst.Add(New Tooltip("tipAddhoogte", "De hoogte van de categorie. Mag enkel positieve gehele nummers bevatten."))
        lijst.Add(New Tooltip("tipAddCatTaal", "De taal van de categorie."))
        lijst.Add(New Tooltip("tipAddCatVersie", "De versie waarin de categorie gebruikt wordt."))
        lijst.Add(New Tooltip("tipAddCatBedrijf", "Het bedrijf waarin de categorie gebruikt wordt."))
        lijst.Add(New Tooltip("tipAddParentcat", "De hoofdcategorie waar deze categorie onder staat. De categorie 'root_node' is het begin van de structuur."))

        lijst.Add(New Tooltip("tipEditCatTaalkeuze", "Selecteer een optie en klik op de filterknop om het categorieaanbod te filteren op taal."))
        lijst.Add(New Tooltip("tipEditCatVersiekeuze", "Selecteer een optie en klik op de filterknop om het categorieaanbod te filteren op versie."))
        lijst.Add(New Tooltip("tipEditCatBedrijfkeuze", "Selecteer een optie en klik op de filterknop om het categorieaanbod te filteren op bedrijf."))

        lijst.Add(New Tooltip("tipEditCategorie", "De categorie die u wilt wijzigen."))
        lijst.Add(New Tooltip("tipCatbewerknaam", "De naam van de categorie."))
        lijst.Add(New Tooltip("tipEditCatHoogte", "De hoogte van de categorie. Mag enkel positieve gehele nummers bevatten."))
        lijst.Add(New Tooltip("tipEditCatTaal", "De taal van de categorie."))
        lijst.Add(New Tooltip("tipEditCatVersie", "De versie waarin de categorie gebruikt wordt."))
        lijst.Add(New Tooltip("tipEditCatBedrijf", "Het bedrijf waarin de categorie gebruikt wordt."))
        lijst.Add(New Tooltip("tipEditCatParent", "De hoofdcategorie waar deze categorie onder staat. De categorie 'root_node' is het begin van de structuur."))

        lijst.Add(New Tooltip("tipCatDelTaalkeuze", "Selecteer een optie en klik op de filterknop om het categorieaanbod te filteren op taal."))
        lijst.Add(New Tooltip("lbltipCatDelVersiekeuze", "Selecteer een optie en klik op de filterknop om het categorieaanbod te filteren op versie."))
        lijst.Add(New Tooltip("tipCatDelBedrijfkeuze", "Selecteer een optie en klik op de filterknop om het categorieaanbod te filteren op bedrijf."))
        lijst.Add(New Tooltip("tipCatVerwijder", "De categorie die u wilt verwijderen."))
 
        'Tooltips op de pagina zetten via scriptmanager als het een postback is, anders gewoon in de onload functie van de body.
        If Page.IsPostBack Then
            Tooltip.VoegTipToeAanEndRequest(Me, lijst)
        Else
            Dim body As HtmlGenericControl = Master.FindControl("MasterBody")
            Tooltip.VoegTipToeAanBody(body, lijst)
        End If

    End Sub

    Private Sub LaadJavascript()

        'Bedrijfbeheer

        JavaScript.ZetButtonOpDisabledOnClick(btnAddBedrijf, "Toevoegen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnEditBedrijf, "Wijzigen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnDeleteBedrijf, "Verwijderen...")

        'Taalbeheer

        JavaScript.ZetButtonOpDisabledOnClick(btnAddTaal, "Toevoegen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnEditTaal, "Wijzigen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnTaalDelete, "Verwijderen...")

        'Versiebeheer

        JavaScript.ZetButtonOpDisabledOnClick(btnAddVersie, "Toevoegen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnEditVersie, "Wijzigen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnDeleteVersie, "Verwijderen...")

        'Categoriebeheer

        'Toevoegen
        JavaScript.ZetButtonOpDisabledOnClick(btnCatAdd, "Toevoegen...", True)

        JavaScript.ZetDropdownOpDisabledOnChange(ddlAddCatBedrijf, ddlAddParentcat, "Laden...")
        JavaScript.ZetDropdownOpDisabledOnChange(ddlAddCatTaal, ddlAddParentcat, "Laden...")
        JavaScript.ZetDropdownOpDisabledOnChange(ddlAddCatVersie, ddlAddParentcat, "Laden...")

        'Wijzigen
        JavaScript.ZetButtonOpDisabledOnClick(btnCatEdit, "Wijzigen...", True)

        JavaScript.ZetButtonOpDisabledOnClick(btnEditCatVerfijnen, "Filteren...", True, True)
        JavaScript.VoerJavaScriptUitOn(btnEditCatVerfijnen, JavaScript.DisableCode(ddlEditCategorie), "onclick")

        JavaScript.ZetDropdownOpDisabledOnChange(ddlEditCatBedrijf, ddlEditCatParent, "Laden...")
        JavaScript.ZetDropdownOpDisabledOnChange(ddlEditCatTaal, ddlEditCatParent, "Laden...")
        JavaScript.ZetDropdownOpDisabledOnChange(ddlEditCatVersie, ddlEditCatParent, "Laden...")

        'Verwijderen
        JavaScript.ZetButtonOpDisabledOnClick(btnCatDelete, "Verwijderen...", True, True)
        JavaScript.ZetButtonOpDisabledOnClick(btnCatDelFilteren, "Filteren...", True, True)
    End Sub

#End Region

End Class
