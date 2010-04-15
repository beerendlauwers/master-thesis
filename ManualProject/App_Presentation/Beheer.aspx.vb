Imports Manual

Partial Class App_Presentation_Beheer
    Inherits System.Web.UI.Page

#Region "Paginavariabelen"
    Private artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties
    Private categoriedal As CategorieDAL = DatabaseLink.GetInstance.GetCategorieFuncties
    Private versiedal As VersieDAL = DatabaseLink.GetInstance.GetVersieFuncties
    Private taaldal As TaalDAL = DatabaseLink.GetInstance.GetTaalFuncties
    Private bedrijfdal As BedrijfDAL = DatabaseLink.GetInstance.GetBedrijfFuncties

    Private adapterCat As New ManualTableAdapters.tblCategorieTableAdapter
    Private adapterVersie As New ManualTableAdapters.tblVersieTableAdapter
    Private adapterBedrijf As New ManualTableAdapters.tblBedrijfTableAdapter
    Private adapterTaal As New ManualTableAdapters.tblTaalTableAdapter
    Private adapterArtikel As New ManualTableAdapters.tblArtikelTableAdapter
#End Region

#Region "Code voor Categoriebeheer"

#Region "Code: Categorie Toevoegen"

    Protected Sub btnCatAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatAdd.Click
        Dim val() As WebControl = {txtAddhoogte, txtAddCatnaam, ddlAddCatBedrijf, ddlAddCatTaal, ddlAddCatVersie, ddlAddParentcat}
        If Util.Valideer(val) Then

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
            If categoriedal.checkCategorie(c.Categorie, c.Bedrijf, c.Versie, c.FK_Taal) Is Nothing Then

                'Alles ok, categorie inserten
                Dim categorieID As Integer = categoriedal.insertCategorie(c)

                If Not categorieID = -1 Then

                    'Toevoegen in geheugen
                    Dim tree As Tree = tree.GetTree(c.FK_Taal, c.Versie, c.Bedrijf)

                    'Parent opzoeken
                    Dim parent As Node = tree.DoorzoekTreeVoorNode(c.FK_Parent, Global.ContentType.Categorie)

                    If parent Is Nothing Then
                        Util.SetWarn("Categorie toegevoegd met waarschuwing: kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met uw wijzigingen.", lblResAdd, imgResAdd)
                        txtAddCatnaam.Text = String.Empty
                        txtAddhoogte.Text = String.Empty
                    Else
                        Dim kind As New Node(categorieID, Global.ContentType.Categorie, c.Categorie, c.Hoogte)

                        parent.AddChild(kind)

                        Util.SetOK("Categorie toegevoegd.", lblResAdd, imgResAdd)
                        txtAddCatnaam.Text = String.Empty
                        txtAddhoogte.Text = String.Empty
                    End If
                Else
                    Util.SetError("Toevoegen mislukt.", lblResAdd, imgResAdd)
                End If

            Else
                Util.SetError("Deze categorie bestaat reeds voor deze versie of dit bedrijf.", lblResAdd, imgResAdd)
            End If

            LaadAlleCategorien()
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblResAdd, imgResAdd)
        End If
    End Sub

    Protected Sub ddlAddCatBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatBedrijf.SelectedIndexChanged
        Toevoegen_LaadParentCategorie()
    End Sub

    Protected Sub ddlAddCatTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatTaal.SelectedIndexChanged
        Toevoegen_LaadParentCategorie()
    End Sub

    Protected Sub ddlAddCatVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatVersie.SelectedIndexChanged
        Toevoegen_LaadParentCategorie()
    End Sub

    Protected Sub ddlAddParentcat_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Toevoegen_LaadCategorieHoogte()
    End Sub

    Private Sub Toevoegen_LaadParentCategorie()
        If ddlAddCatBedrijf.Items.Count > 0 And ddlAddCatTaal.Items.Count > 0 And ddlAddCatVersie.Items.Count > 0 Then
            Dim t As Tree = Tree.GetTree(ddlAddCatTaal.SelectedValue, ddlAddCatVersie.SelectedValue, ddlAddCatBedrijf.SelectedValue)
            Util.LeesCategorien(ddlAddParentcat, t, True, True)
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

    Private Function Wijzigen_CheckCategorieRecursief(ByVal catnaam As String, ByVal bedrijf As Integer, ByVal versie As Integer, ByVal taal As Integer, ByVal parentCategorieID As Integer) As Boolean

        'Check of deze categorie een dubbele naam heeft
        If (categoriedal.checkCategorieByID(catnaam, bedrijf, versie, taal, parentCategorieID) IsNot Nothing) Then
            Return False
        Else

            Dim dt As tblCategorieDataTable = categoriedal.getCategorieByParent(parentCategorieID)
            If dt IsNot Nothing Then

                Dim resultaat As Boolean
                'Check voor elke subcategorie van deze parentcategorie of ze een dubbele naam heeft
                For Each categorie As tblCategorieRow In dt
                    resultaat = Wijzigen_CheckCategorieRecursief(categorie.Categorie, bedrijf, versie, taal, categorie.CategorieID)

                    If resultaat = False Then 'een subcategorie heeft een dubbele naam
                        Return False
                    End If

                Next categorie

            End If

            'Artikels checken onder parentcategorie
            Dim artikeldt As tblArtikelDataTable = artikeldal.GetArtikelsByParent(parentCategorieID)
            If artikeldt IsNot Nothing Then

                'Elk artikel van deze parentcategorie checken
                For Each artikel As tblArtikelRow In artikeldt

                    If artikeldal.checkArtikelByTitel(artikel.Titel, bedrijf, versie, taal) IsNot Nothing Then
                        Return False 'Dit artikel heeft een dubbele titel
                    End If

                Next artikel
            End If

        End If

        Return True

    End Function

    Private Function Wijzigen_UpdateCategorieRecursief(ByRef parent As Categorie) As Boolean

        'Deze categorie updaten
        If Not (categoriedal.updateCategorie(parent)) Then
            Return False
        End If

        'De kinderen updaten
        Dim dt As tblCategorieDataTable = categoriedal.getCategorieByParent(parent.CategorieID)
        If dt IsNot Nothing Then

            Dim resultaat As Boolean
            'Elke subcategorie van deze parentcategorie updaten
            For Each categorie As tblCategorieRow In dt
                Dim subcategorie As New Categorie(categorie.CategorieID, categorie.Categorie, categorie.Hoogte, categorie.Diepte, parent.CategorieID, parent.FK_Taal, parent.Versie, parent.Bedrijf)
                resultaat = Wijzigen_UpdateCategorieRecursief(subcategorie)

                If resultaat = False Then 'kon een subcategorie niet updaten
                    Return False
                End If

            Next categorie

        End If

        'Artikels updaten onder parentcategorie
        Dim artikeldt As tblArtikelDataTable = artikeldal.GetArtikelsByParent(parent.CategorieID)
        If artikeldt IsNot Nothing Then

            Dim resultaat As Boolean
            'Elk artikel van deze parentcategorie updaten
            For Each artikel As tblArtikelRow In artikeldt

                Dim a As New Artikel(artikel)
                a.Bedrijf = parent.Bedrijf
                a.Versie = parent.Versie
                a.Taal = parent.FK_Taal
                resultaat = artikeldal.updateArtikel(a)

                If resultaat = False Then 'kon een artikel niet updaten
                    Return False
                End If

            Next artikel
        End If

        Return True

    End Function

    Protected Sub btnCatEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatEdit.Click
        Dim val() As WebControl = {txtCatbewerknaam, txtEditCathoogte, ddlEditCategorie, ddlEditCatParent, ddlEditCatTaal, ddlEditCatBedrijf, ddlEditCatVersie}
        If Util.Valideer(val) Then
            'Alle gegevens inlezen
            Dim nieuwecategorie As New Categorie

            nieuwecategorie.CategorieID = ddlEditCategorie.SelectedValue
            nieuwecategorie.Categorie = txtCatbewerknaam.Text
            nieuwecategorie.FK_Parent = ddlEditCatParent.SelectedValue

            Dim origineleCategorie As tblCategorieRow = categoriedal.getCategorieByID(nieuwecategorie.CategorieID)

            Dim parentCategorierij As tblCategorieRow = categoriedal.getCategorieByID(nieuwecategorie.FK_Parent)
            nieuwecategorie.Diepte = parentCategorierij.Diepte + 1

            nieuwecategorie.FK_Taal = ddlEditCatTaal.SelectedValue
            nieuwecategorie.Hoogte = txtEditCathoogte.Text
            nieuwecategorie.Bedrijf = ddlEditCatBedrijf.SelectedValue
            nieuwecategorie.Versie = ddlEditCatVersie.SelectedValue

            'Nagaan of de gewenste categorienaam reeds in gebruik is door een andere categorie, 
            'en ook voor alle namen van de subcategorieën
            If Wijzigen_CheckCategorieRecursief(nieuwecategorie.Categorie, nieuwecategorie.Bedrijf, nieuwecategorie.Versie, nieuwecategorie.FK_Taal, nieuwecategorie.CategorieID) = True Then

                'Alles ok, categorie en categoriëën daaronder updaten
                If (Wijzigen_UpdateCategorieRecursief(nieuwecategorie)) Then

                    'Geheugen updaten
                    Dim oudetree As Tree = Tree.GetTree(origineleCategorie.FK_taal, origineleCategorie.FK_versie, origineleCategorie.FK_bedrijf)
                    Dim categorienode As Node = oudetree.DoorzoekTreeVoorNode(nieuwecategorie.CategorieID, Global.ContentType.Categorie)

                    If categorienode Is Nothing Then
                        Util.SetWarn("Categorie gewijzigd met waarschuwing: kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met uw wijzigingen.", lblResEdit, imgResEdit)
                    Else
                        categorienode.Titel = nieuwecategorie.Categorie
                        categorienode.Hoogte = nieuwecategorie.Hoogte

                        'Nakijken of de categorie onder een andere tree is verplaatst, we gaan de tree ophalen van de gewenste parent categorie
                        Dim nieuwetree As Tree = Tree.GetTree(nieuwecategorie.FK_Taal, nieuwecategorie.Versie, nieuwecategorie.Bedrijf)

                        If oudetree IsNot nieuwetree Then 'Verschillende tree

                            Dim oudeparent As Node = oudetree.VindParentVanNode(categorienode)
                            Dim nieuweparent As Node = nieuwetree.DoorzoekTreeVoorNode(nieuwecategorie.FK_Parent, Global.ContentType.Categorie)

                            'De parents zijn verschillend, dus de categorie is onder een nieuwe categorie verplaatst
                            nieuweparent.AddChild(categorienode)
                            oudeparent.RemoveChild(categorienode)

                        Else 'Dezelfde tree

                            'Nakijken of de categorie onder een andere categorie is verplaatst
                            Dim oudeparent As Node = oudetree.VindParentVanNode(categorienode)
                            Dim nieuweparent As Node = oudetree.DoorzoekTreeVoorNode(nieuwecategorie.FK_Parent, Global.ContentType.Categorie)

                            If Not oudeparent Is nieuweparent Then
                                'De parents zijn verschillend, dus de categorie is onder een nieuwe categorie verplaatst
                                nieuweparent.AddChild(categorienode)
                                oudeparent.RemoveChild(categorienode)
                            End If

                            Util.SetOK("Categorie gewijzigd.", lblResEdit, imgResEdit)
                        End If
                    End If
                Else
                    Util.SetError("Wijzigen mislukt.", lblResEdit, imgResEdit)
                End If
            Else
                Util.SetError("Een andere categorie in deze combinate van taal, versie en bedrijf heeft reeds dezelfde naam.", lblResEdit, imgResEdit)
            End If

            LaadAlleCategorien()
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblResEdit, imgResEdit)
        End If
    End Sub

    Protected Sub btnEditCatVerfijnen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditCatVerfijnen.Click
        Wijzigen_LaadKeuzeCategorie()
    End Sub

    Protected Sub ddlEditCatBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatBedrijf.SelectedIndexChanged
        Wijzigen_LaadParentCategorie()
    End Sub

    Protected Sub ddlEditCatTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatTaal.SelectedIndexChanged
        Wijzigen_LaadParentCategorie()
    End Sub

    Protected Sub ddlEditCatVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatVersie.SelectedIndexChanged
        Wijzigen_LaadParentCategorie()
    End Sub

    Protected Sub ddlEditCategorie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Wijzigen_LaadParentCategorie()
        Wijzigen_LaadCategorieDetails()
    End Sub

    Protected Sub ddlEditCatParent_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Wijzigen_LaadCategorieHoogte()
    End Sub

    Private Sub Wijzigen_LaadKeuzeCategorie()
        'Relevante categorieën ophalen
        If ddlEditCatBedrijfkeuze.Items.Count > 0 And ddlEditCatTaalkeuze.Items.Count > 0 And ddlEditCatVersiekeuze.Items.Count > 0 Then
            Dim t As Tree = Tree.GetTree(ddlEditCatTaalkeuze.SelectedValue, ddlEditCatVersiekeuze.SelectedValue, ddlEditCatBedrijfkeuze.SelectedValue)
            Util.LeesCategorien(ddlEditCategorie, t)

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

    Private Sub Wijzigen_LaadParentCategorie()
        If ddlEditCatBedrijf.Items.Count > 0 And ddlEditCatTaal.Items.Count > 0 And ddlEditCatVersie.Items.Count > 0 Then
            Dim t As Tree = Tree.GetTree(ddlEditCatTaal.SelectedValue, ddlEditCatVersie.SelectedValue, ddlEditCatBedrijf.SelectedValue)
            Util.LeesCategorien(ddlEditCatParent, t)

            'Eigen categorie eruit halen
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

        Dim dr As Manual.tblCategorieRow = categoriedal.getCategorieByID(ddlEditCategorie.SelectedValue)
        Dim parenthoogte As Integer = dr.Hoogte
        Dim hoogte As Integer
        If parenthoogte = Nothing Then
            hoogte = 0
        Else
            hoogte = parenthoogte
        End If

        txtEditCathoogte.Text = hoogte

    End Sub

    Private Sub Wijzigen_LaadCategorieDetails()

        If ddlEditCatBedrijf.Items.Count > 0 And ddlEditCatTaal.Items.Count > 0 And ddlEditCatVersie.Items.Count > 0 Then
            If Util.Valideer(ddlEditCategorie) Then

                'CategorieID ophalen van gewenste categorie
                Dim categorieID As Integer = ddlEditCategorie.SelectedValue

                'Categoriegegevens ophalen
                Dim categorieRij As tblCategorieRow = categoriedal.getCategorieByID(categorieID)

                'Categoriegegevens inlezen
                txtCatbewerknaam.Text = categorieRij.Categorie
                ddlEditCatTaal.SelectedValue = categorieRij.FK_taal
                ddlEditCatBedrijf.SelectedValue = categorieRij.FK_bedrijf
                ddlEditCatVersie.SelectedValue = categorieRij.FK_versie
                Dim hoogte As Integer = categorieRij.Hoogte
                txtEditCathoogte.Text = hoogte

                Try
                    ddlEditCatParent.SelectedValue = categorieRij.FK_parent
                Catch
                    Return
                End Try

            End If
        End If
    End Sub

#End Region

#Region "Code: Categorie Verwijderen"

    Protected Sub btnCatDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatDelete.Click
        If Util.Valideer(ddlCatVerwijder) Then
            Dim categorieID As Integer = ddlCatVerwijder.SelectedValue

            'Nakijken of er nog artikels of categorieën onder deze categorie staan
            If (artikeldal.GetArtikelsByParent(categorieID) Is Nothing) And (categoriedal.getCategorieByParent(categorieID) Is Nothing) Then

                'Alles ok, categorie verwijderen
                If Not adapterCat.Delete(categorieID) = 0 Then

                    'Geheugen updaten
                    Dim tree As Tree = tree.GetTree(ddlCatDelTaalkeuze.SelectedValue, ddlCatDelVersiekeuze.SelectedValue, ddlCatDelBedrijfkeuze.SelectedValue)
                    Dim node As Node = tree.DoorzoekTreeVoorNode(categorieID, Global.ContentType.Categorie)

                    If node Is Nothing Then
                        Util.SetWarn("Categorie verwijderd met waarschuwing: kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met uw wijzigingen.", lblResDelete, imgResDelete)
                    Else
                        Dim parent As Node = tree.VindParentVanNode(node)

                        If parent Is Nothing Then
                            Util.SetWarn("Categorie verwijderd met waarschuwing: kon de boomstructuur niet updaten. Herbouw de boomstructuur als u klaar bent met uw wijzigingen.", lblResDelete, imgResDelete)
                        Else
                            parent.RemoveChild(node)
                            Util.SetOK("Categorie verwijderd.", lblResDelete, imgResDelete)
                        End If
                    End If

                Else
                    Util.SetError("Verwijderen mislukt.", lblResDelete, imgResDelete)
                End If

            Else
                Util.SetError("Er staan nog artikels of andere categorieën onder deze categorie.", lblResDelete, imgResDelete)
            End If

            LaadAlleCategorien()
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblResDelete, imgResDelete)
        End If
    End Sub

    Protected Sub btnCatDelFilteren_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatDelFilteren.Click
        Verwijderen_LaadParentCategorie()
    End Sub

    Protected Sub ddlCatDelBedrijfkeuze_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCatDelBedrijfkeuze.DataBound
        Verwijderen_LaadParentCategorie()
    End Sub

    Protected Sub ddlCatDelTaalkeuze_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCatDelTaalkeuze.DataBound
        Verwijderen_LaadParentCategorie()
    End Sub

    Protected Sub ddlCatDelVersiekeuze_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCatDelVersiekeuze.DataBound
        Verwijderen_LaadParentCategorie()
    End Sub

    Private Sub Verwijderen_LaadParentCategorie()
        If ddlCatDelBedrijfkeuze.Items.Count > 0 And ddlCatDelTaalkeuze.Items.Count > 0 And ddlCatDelVersiekeuze.Items.Count > 0 Then
            Dim t As Tree = Tree.GetTree(ddlCatDelTaalkeuze.SelectedValue, ddlCatDelVersiekeuze.SelectedValue, ddlCatDelBedrijfkeuze.SelectedValue)
            Util.LeesCategorien(ddlCatVerwijder, t)

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

    Private Sub LaadAlleCategorien()
        'Categorie Toevoegen - Parentcategorie
        Dim t As Tree = Tree.GetTree(ddlAddCatTaal.SelectedValue, ddlAddCatVersie.SelectedValue, ddlAddCatBedrijf.SelectedValue)
        Util.LeesCategorien(ddlAddParentcat, t, True, True)
        Toevoegen_LaadParentCategorie()

        'Categorie Wijzigen - Parentcategorie
        t = Tree.GetTree(ddlEditCatTaal.SelectedValue, ddlEditCatVersie.SelectedValue, ddlEditCatBedrijf.SelectedValue)
        Util.LeesCategorien(ddlEditCatParent, t, True, True)

        'Categorie Wijzigen - Te wijzigen categorie
        t = Tree.GetTree(ddlEditCatTaalkeuze.SelectedValue, ddlEditCatVersiekeuze.SelectedValue, ddlEditCatBedrijfkeuze.SelectedValue)
        Util.LeesCategorien(ddlEditCategorie, t)

        'Categorie Verwijderen - Te verwijderen categorie
        t = Tree.GetTree(ddlCatDelTaalkeuze.SelectedValue, ddlCatDelVersiekeuze.SelectedValue, ddlCatDelBedrijfkeuze.SelectedValue)
        Util.LeesCategorien(ddlCatVerwijder, t)
    End Sub

#End Region

#Region "Code voor Taalbeheer"

    Protected Sub btnAddTaal_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTaal.Click

        If Not txtAddTaal.Text = String.Empty And Not txtTaalAfkorting.Text = String.Empty Then
            Dim taaltext As String = txtAddTaal.Text
            Dim taaltag As String = txtTaalAfkorting.Text

            If (taaldal.checkTaal(taaltext, taaltag) Is Nothing) Then
                Dim taalID As Integer = taaldal.insertTaal(taaltext, taaltag)
                If taalID = -1 Then
                    Util.SetError("Toevoegen mislukt.", lblAddTaalRes, imgAddTaalRes)
                Else
                    'Geheugen updaten
                    Taal.AddTaal(New Taal(taalID, taaltext, taaltag))

                    'Trees bouwen voor dit bedrijf
                    Dim bedrijven As tblBedrijfDataTable = bedrijfdal.GetAllBedrijf
                    Dim versies As tblVersieDataTable = versiedal.GetAllVersie
                    Dim nieuwetaal As tblTaalRow = taaldal.GetTaalByID(taalID)
                    Tree.BouwTreesVoorTaal(bedrijven, versies, nieuwetaal)

                    Util.SetOK("Taal toegevoegd.", lblAddTaalRes, imgAddTaalRes)
                End If

                LaadTaalDropdowns()
            Else
                Util.SetError("Deze taal is reeds toegvoegd.", lblAddTaalRes, imgAddTaalRes)
            End If
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblAddTaalRes, imgAddTaalRes)
        End If
    End Sub

    Protected Sub btnEditTaal_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditTaal.Click

        If Not txtEditAfkorting.Text = String.Empty And Not txtEditTaal.Text = String.Empty And ddlBewerkTaal.SelectedItem IsNot Nothing Then
            Dim taaltag As String = txtEditAfkorting.Text
            Dim taalID As String = ddlBewerkTaal.SelectedValue
            Dim taaltext As String = txtEditTaal.Text

            If (taaldal.checkTaalByID(taaltext, taaltag, taalID) Is Nothing) Then
                If (adapterTaal.Update(taaltext, taaltag, taalID) = 0) Then
                    Util.SetError("Wijzigen mislukt.", lblEditTaalRes, imgEditTaalRes)
                Else

                    'Geheugen updaten
                    Dim t As Taal = Taal.GetTaal(taalID)

                    If t Is Nothing Then
                        Util.SetWarn("Wijzigen gelukt met waarschuwing: kon de taalstructuur niet updaten. Herbouw de taalstructuur als u klaar bent met uw wijzigingen.", lblEditTaalRes, imgEditTaalRes)
                    Else
                        t.TaalNaam = taaltext
                        t.TaalTag = taaltag

                        Util.SetOK("Taal gewijzigd.", lblEditTaalRes, imgEditTaalRes)
                    End If

                End If

                LaadTaalDropdowns()
            Else
                Util.SetError("Een andere taal heeft deze naam al.", lblEditTaalRes, imgEditTaalRes)
            End If
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblEditTaalRes, imgEditTaalRes)
        End If
    End Sub

    Protected Sub btnTaalDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTaalDelete.Click
        If ddlTaalDelete.SelectedItem IsNot Nothing Then
            Dim taalID As Integer = ddlTaalDelete.SelectedValue

            If (artikeldal.getArtikelsByTaal(taalID) Is Nothing And categoriedal.GetCategorieByTaal(taalID) Is Nothing) Then
                If (adapterTaal.Delete(taalID) = 0) Then
                    Util.SetError("Verwijderen mislukt.", lblDeleteTaalRes, imgDeleteTaalRes)
                Else

                    'Geheugen updaten
                    Dim t As Taal = Taal.GetTaal(taalID)

                    If t Is Nothing Then
                        Util.SetWarn("Verwijderen gelukt met waarschuwing: kon de taalstructuur niet updaten. Herbouw de taalstructuur als u klaar bent met uw wijzigingen.", lblDeleteTaalRes, imgDeleteTaalRes)
                    Else
                        Taal.RemoveTaal(t)
                        Util.SetOK("Taal verwijderd.", lblDeleteTaalRes, imgDeleteTaalRes)
                    End If

                    LaadTaalDropdowns()
                End If
            Else
                Util.SetError("Er bestaan nog artikels of categorieën onder deze taal.", lblDeleteTaalRes, imgDeleteTaalRes)
            End If
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblDeleteTaalRes, imgDeleteTaalRes)
        End If
    End Sub

    Protected Sub ddlBewerkTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        LeesTaal(Taal.GetTaal(ddlBewerkTaal.SelectedValue))
    End Sub

    Private Sub LaadTaalDropdowns()
        Util.LeesTalen(ddlBewerkTaal)
        If ddlBewerkTaal.Items.Count > 0 Then LeesTaal(Taal.GetTaal(ddlBewerkTaal.SelectedValue))
        Util.LeesTalen(ddlTaalDelete)

        Util.LeesTalen(ddlAddCatTaal)
        Util.LeesTalen(ddlEditCatTaal)
        Util.LeesTalen(ddlCatDelTaalkeuze)
        Util.LeesTalen(ddlEditCatTaalkeuze)
    End Sub

    Private Sub LeesTaal(ByRef t As Taal)
        If t IsNot Nothing Then
            Me.txtEditTaal.Text = t.TaalNaam
            Me.txtEditAfkorting.Text = t.TaalTag
        End If
    End Sub

#End Region

#Region "Code voor Versiebeheer"

    Protected Sub btnAddVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddVersie.Click
        If Not txtAddVersie.Text = String.Empty Then

            Dim versietext As String = txtAddVersie.Text

            If (versiedal.CheckVersie(versietext) Is Nothing) Then
                Dim versieID As Integer = versiedal.insertVersie(versietext)

                If versieID = -1 Then
                    Util.SetError("Toevoegen mislukt.", lblAddVersieRes, imgAddVersieRes)
                Else

                    'Geheugen updaten
                    Versie.AddVersie(New Versie(versieID, versietext))

                    Util.SetOK("Versie toegevoegd.", lblAddVersieRes, imgAddVersieRes)
                End If

                LaadVersieDropdowns()
            Else
                Util.SetWarn("Deze versie bestaat reeds.", lblAddVersieRes, imgAddVersieRes)
            End If
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblAddVersieRes, imgAddVersieRes)
        End If
    End Sub

    Protected Sub btnEditVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditVersie.Click
        If Not txtEditVersie.Text = String.Empty And ddlBewerkVersie.SelectedItem IsNot Nothing Then
            Dim versietext As String = txtEditVersie.Text
            Dim versieID As Integer = ddlBewerkVersie.SelectedValue

            If (versiedal.CheckVersieByID(versietext, versieID) Is Nothing) Then
                If adapterVersie.Update(versietext, versieID) = 0 Then
                    Util.SetError("Wijzigen mislukt.", lblEditVersieRes, imgEditVersieRes)
                Else
                    'Geheugen updaten
                    Dim v As Versie = Versie.GetVersie(versieID)

                    If v Is Nothing Then
                        Util.SetWarn("Wijzigen gelukt met waarschuwing: kon de versiestructuur niet updaten. Herbouw de versiestructuur als u klaar bent met uw wijzigingen.", lblEditVersieRes, imgEditVersieRes)
                    Else
                        v.VersieNaam = versietext
                        Util.SetOK("Versie gewijzigd.", lblEditVersieRes, imgEditVersieRes)
                    End If

                    LaadVersieDropdowns()
                End If
            Else
                Util.SetError("Een andere versie heeft dit versienummer al.", lblEditVersieRes, imgEditVersieRes)
            End If
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblEditVersieRes, imgEditVersieRes)
        End If
    End Sub

    Private Function Kopieren_KopieerCategorieRecursief(ByRef parent As Node, ByRef tree As Tree, ByVal versieID As Integer, ByVal categorieID As Integer) As Boolean

        'Parentgegevens ophalen
        Dim parentrij As tblCategorieRow = categoriedal.getCategorieByID(parent.ID)

        'Parent kopiëren
        Dim cat As New Categorie

        'Titel, diepte en hoogte overkopiëren
        cat.Categorie = parentrij.Categorie
        cat.Diepte = parentrij.Diepte
        cat.Hoogte = parentrij.Hoogte

        'VersieID is de nieuwe versie
        cat.Versie = versieID

        'Bedrijf en taal blijven hetzelfde
        cat.Bedrijf = tree.Bedrijf.ID
        cat.FK_Taal = tree.Taal.ID

        cat.FK_Parent = categorieID

        If Not parentrij.Categorie = "root_node" Then

            categorieID = categoriedal.insertCategorie(cat)
            If categorieID = -1 Then
                Return False 'we konden deze categorie niet kopiëren
            End If

        End If

        'Kinderen kopiëren
        Dim resultaat As Boolean
        For Each kind As Node In parent.GetChildren

            If kind.Type = Global.ContentType.Categorie Then
                resultaat = Kopieren_KopieerCategorieRecursief(kind, tree, versieID, categorieID)

                If resultaat = False Then 'kon een subcategorie niet kopiëren
                    Return False
                End If
            Else
                Dim a As New Artikel(artikeldal.GetArtikelByID(kind.ID))
                resultaat = adapterArtikel.Insert(a.Titel, a.Categorie, a.Taal, a.Bedrijf, a.Versie, a.Tekst, a.Tag, a.IsFinal)

                If resultaat = False Then 'kon een artikel niet kopiëren
                    Return False
                End If

            End If

        Next kind

        Return True

    End Function

    Protected Sub btnVersieKopieren_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVersieKopieren.Click
        If Not txtNaamNieuweVersieKopie.Text = String.Empty And ddlVersiekopieren.SelectedItem IsNot Nothing Then
            Dim versietext As String = txtNaamNieuweVersieKopie.Text
            Dim versieID As Integer = ddlVersiekopieren.SelectedValue

            If (versiedal.CheckVersieByID(versietext, versieID) Is Nothing) Then

                Dim nieuweVersieID As Integer = versiedal.insertVersie(versietext)
                If nieuweVersieID = -1 Then
                    Util.SetError("Kopiëren mislukt.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
                Else
                    Dim bedrijven As tblBedrijfDataTable = bedrijfdal.GetAllBedrijf()
                    Dim talen As tblTaalDataTable = taaldal.GetAllTaal()

                    'Alle categorieën van deze versie recursief kopiëren
                    For Each t As tblTaalRow In talen
                        For Each b As tblBedrijfRow In bedrijven
                            Dim oudeversietree As Tree = Tree.GetTree(t.TaalID, versieID, b.BedrijfID)

                            If oudeversietree Is Nothing Then
                                Util.SetError("Kopiëren mislukt.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)

                                Dim fout As String = "De opgevraagde tree (zie parameters) bestaat niet in het geheugen."
                                fout = String.Concat(fout, " Refereer naar de documentatie om dit probleem op te lossen.")
                                Dim err As New ErrorLogger(fout, "BEHEER_0001")
                                err.Args.Add("Taal = " & t.TaalID.ToString)
                                err.Args.Add("Versie = " & versieID.ToString)
                                err.Args.Add("Bedrijf = " & b.BedrijfID.ToString)
                                ErrorLogger.WriteError(err)

                                Return
                            End If

                            If Not Kopieren_KopieerCategorieRecursief(oudeversietree.RootNode, oudeversietree, nieuweVersieID, oudeversietree.RootNode.ID) Then
                                Util.SetError("Kopiëren mislukt.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
                                Return
                            End If

                        Next b
                    Next t

                    'Geheugen updaten

                    Dim versie As tblVersieRow = versiedal.GetVersieByID(nieuweVersieID)

                    Dim gelukt As Boolean = Tree.BouwTreesVoorVersie(bedrijven, versie, talen)

                    If Not gelukt Then
                        Util.SetWarn("Kopiëren gelukt met waarschuwing: kon de versiestructuur niet updaten. Herbouw de versiestructuur als u klaar bent met uw wijzigingen.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
                    Else
                        Util.SetOK("Versie gekopieerd.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
                    End If

                End If
            Else
                Util.SetError("Een andere versie heeft deze naam al.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
            End If

            LaadVersieDropdowns()
            Me.txtNaamNieuweVersieKopie.Text = String.Empty
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
        End If
    End Sub

    Protected Sub btnDeleteVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteVersie.Click
        If ddlDeletVersie.SelectedItem IsNot Nothing Then
            Dim versieID As Integer = ddlDeletVersie.SelectedValue

            If (artikeldal.getArtikelsByVersie(versieID) Is Nothing And categoriedal.GetCategorieByVersie(versieID) Is Nothing) Then
                If (adapterVersie.Delete(versieID) = 0) Then
                    Util.SetError("Verwijderen mislukt.", lblDeleteVersieRes, imgDeleteVersieRes)
                Else

                    'Geheugen updaten
                    Dim v As Versie = Versie.GetVersie(versieID)

                    If v Is Nothing Then
                        Util.SetWarn("Verwijderen gelukt met waarschuwing: kon de versiestructuur niet updaten. Herbouw de versiestructuur als u klaar bent met uw wijzigingen.", lblDeleteVersieRes, imgDeleteVersieRes)
                    Else
                        Versie.RemoveVersie(v)
                        Util.SetOK("Versie verwijderd.", lblDeleteVersieRes, imgDeleteVersieRes)
                    End If

                    LaadVersieDropdowns()
                End If
            Else
                Util.SetError("Deze versie heeft nog artikels of categorieën onder zich.", lblDeleteVersieRes, imgDeleteVersieRes)
            End If
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblDeleteVersieRes, imgDeleteVersieRes)
        End If
    End Sub

    Protected Sub ddlBewerkVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        LeesVersie(Versie.GetVersie(ddlBewerkVersie.SelectedValue))
    End Sub

    Protected Sub ddlVersiekopieren_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlVersiekopieren.SelectedIndexChanged
        LeesTeKopierenVersie(Versie.GetVersie(ddlVersiekopieren.SelectedValue))
    End Sub

    Private Sub LaadVersieDropdowns()
        Util.LeesVersies(ddlBewerkVersie)
        If ddlBewerkVersie.Items.Count > 0 Then
            LeesVersie(Versie.GetVersie(ddlBewerkVersie.SelectedValue))
        End If

        Util.LeesVersies(ddlDeletVersie)
        Util.LeesVersies(ddlVersiekopieren)
        If ddlVersiekopieren.Items.Count > 0 Then
            LeesTeKopierenVersie(Versie.GetVersie(ddlVersiekopieren.SelectedValue))
        End If

        Util.LeesVersies(ddlCatDelVersiekeuze)
        Util.LeesVersies(ddlAddCatVersie)
        Util.LeesVersies(ddlEditCatVersie)
        Util.LeesVersies(ddlEditCatVersiekeuze)
    End Sub

    Private Sub LeesVersie(ByRef v As Versie)
        If v IsNot Nothing Then
            Me.txtEditVersie.Text = v.VersieNaam
        End If
    End Sub

    Private Sub LeesTeKopierenVersie(ByRef v As Versie)
        If v IsNot Nothing Then
            lblKopieVersieAantalArt.Text = BerekenArtikelsVoorVersie(v)
            lblKopieVersieAantalCat.Text = BerekenCategorienVoorVersie(v)
        End If
    End Sub

    Private Function BerekenCategorienVoorVersie(ByVal versie As Versie) As Integer
        Dim aantal As Integer = 0

        For Each t As Taal In Taal.GetTalen
            For Each b As Bedrijf In Bedrijf.GetBedrijven
                Dim tree As Tree = tree.GetTree(t.ID, versie.ID, b.ID)
                aantal = tree.RootNode.GetRecursiveCategorieCount(aantal)
            Next b
        Next t

        Return aantal

    End Function

    Private Function BerekenArtikelsVoorVersie(ByVal versie As Versie) As Integer

        Dim aantal As Integer = 0

        For Each t As Taal In Taal.GetTalen
            For Each b As Bedrijf In Bedrijf.GetBedrijven
                Dim tree As Tree = tree.GetTree(t.ID, versie.ID, b.ID)
                aantal = tree.RootNode.GetRecursiveArtikelCount(aantal)
            Next b
        Next t

        Return aantal

    End Function

#End Region

#Region "Code voor Bedrijfbeheer"

    Protected Sub btnAddBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddBedrijf.Click
        If Not txtAddTag.Text = String.Empty And Not txtAddbedrijf.Text = String.Empty Then

            Dim bedrijfTag As String = txtAddTag.Text
            Dim bedrijfnaam As String = txtAddbedrijf.Text
            If (bedrijfdal.getBedrijfByNaamOrTag(bedrijfnaam, bedrijfTag) Is Nothing) Then

                Dim bedrijfID As Integer = bedrijfdal.insertBedrijf(bedrijfnaam, bedrijfTag)

                If bedrijfID = -1 Then
                    Util.SetError("Toevoegen mislukt.", lblAddBedrijfRes, imgAddBedrijfRes)
                Else

                    'Geheugen updaten
                    Bedrijf.AddBedrijf(New Bedrijf(bedrijfID, bedrijfnaam, bedrijfTag))
                    Util.SetOK("Bedrijf toegevoegd.", lblAddBedrijfRes, imgAddBedrijfRes)
                End If

                LaadBedrijfDropdowns()
            Else
                Util.SetError("Dit bedrijf bestaat al, of een ander bedrijf heeft reeds dezelfde tag.", lblAddBedrijfRes, imgAddBedrijfRes)
            End If
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblAddBedrijfRes, imgAddBedrijfRes)
        End If
    End Sub

    Protected Sub btnEditBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditBedrijf.Click
        If Not txtEditTag.Text = String.Empty And Not txtEditBedrijf.Text And ddlBewerkBedrijf.SelectedItem IsNot Nothing Then
            Dim bedrijfID As Integer = ddlBewerkBedrijf.SelectedValue
            Dim bedrijfTag As String = txtEditTag.Text
            Dim bedrijfnaam As String = txtEditBedrijf.Text

            If (bedrijfdal.getBedrijfByNaamTagID(bedrijfnaam, bedrijfTag, bedrijfID) Is Nothing) Then
                If (adapterBedrijf.Update(bedrijfnaam, bedrijfTag, bedrijfID) = 0) Then
                    Util.SetError("Wijzigen mislukt.", lblEditbedrijfRes, imgEditBedrijfRes)
                Else

                    'Geheugen updaten
                    Dim b As Bedrijf = Bedrijf.GetBedrijf(bedrijfID)

                    If b Is Nothing Then
                        Util.SetWarn("Wijzigen gelukt met waarschuwing: kon de bedrijfstructuur niet updaten. Herbouw de bedrijfstructuur als u klaar bent met uw wijzigingen.", lblEditbedrijfRes, imgEditBedrijfRes)
                    Else
                        b.Naam = bedrijfnaam
                        b.Tag = bedrijfTag
                        Util.SetOK("Bedrijf gewijzigd.", lblEditbedrijfRes, imgEditBedrijfRes)
                    End If
                End If
            Else
                Util.SetError("Een ander bedrijf heeft reeds deze bedrijfsnaam of tag.", lblEditbedrijfRes, imgEditBedrijfRes)
            End If

            LaadBedrijfDropdowns()
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblEditbedrijfRes, imgEditBedrijfRes)
        End If
    End Sub

    Protected Sub btnDeleteBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteBedrijf.Click
        If ddlDeleteBedrijf.SelectedItem IsNot Nothing Then
            Dim bedrijfID As Integer = ddlDeleteBedrijf.SelectedValue

            If (artikeldal.getArtikelsByBedrijf(bedrijfID) Is Nothing And categoriedal.GetCategorieByBedrijf(bedrijfID) Is Nothing) Then
                If (adapterBedrijf.Delete(bedrijfID) = 0) Then
                    Util.SetError("Verwijderen mislukt.", lblDeleteBedrijfRes, imgDeleteBedrijfRes)
                Else

                    'Geheugen updaten
                    Dim b As Bedrijf = Bedrijf.GetBedrijf(bedrijfID)
                    If b Is Nothing Then
                        Util.SetWarn("Verwijderen gelukt met waarschuwing: kon de bedrijfstructuur niet updaten. Herbouw de bedrijfstructuur als u klaar bent met uw wijzigingen.", lblDeleteBedrijfRes, imgDeleteBedrijfRes)
                    Else
                        Bedrijf.RemoveBedrijf(b)
                        Util.SetOK("Bedrijf verwijderd.", lblDeleteBedrijfRes, imgDeleteBedrijfRes)
                    End If

                    LaadBedrijfDropdowns()
                End If
            Else
                Util.SetError("Er staan nog artikels of categorieën onder dit bedrijf.", lblDeleteBedrijfRes, imgDeleteBedrijfRes)
            End If
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblDeleteBedrijfRes, imgDeleteBedrijfRes)
        End If
    End Sub

    Protected Sub ddlBewerkBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        LeesBedrijf(Bedrijf.GetBedrijf(Integer.Parse(ddlBewerkBedrijf.SelectedValue)))
    End Sub

    Private Sub LaadBedrijfDropdowns()
        Util.LeesBedrijven(ddlBewerkBedrijf)
        If ddlBewerkBedrijf.Items.Count > 0 Then
            LeesBedrijf(Bedrijf.GetBedrijf(Integer.Parse(ddlBewerkBedrijf.SelectedValue)))
        End If
        Util.LeesBedrijven(ddlDeleteBedrijf)

        Util.LeesBedrijven(ddlAddCatBedrijf)
        Util.LeesBedrijven(ddlEditCatBedrijf)
        Util.LeesBedrijven(ddlEditCatBedrijfkeuze)
        Util.LeesBedrijven(ddlCatDelBedrijfkeuze)
    End Sub

    Private Sub LeesBedrijf(ByRef b As Bedrijf)
        If b IsNot Nothing Then
            txtEditTag.Text = b.Tag
            txtEditBedrijf.Text = b.Naam
        End If
    End Sub

#End Region

#Region "Code Voor Applicatie-Onderhoud"

    Protected Sub btnTreeWeergeven_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTreeWeergeven.Click
        If ddlTreesWeergeven.SelectedItem.Text = "-- Boomstructuur --" Then Return

        Dim t As Tree = Tree.GetTree(ddlTreesWeergeven.SelectedItem.Text)
        Session("LeesTreeTitel") = t.Naam
        Session("LeesTree") = t.LeesTree(String.Empty, t.RootNode, -1)
        JavaScript.VoegJavascriptToeAanEndRequest(Me, "genericPopup('TreeWeergeven.aspx',800,800, 1);")
    End Sub

    Protected Sub btnOk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOk.Click
        Versie.BouwVersieLijst()
        Taal.BouwTaalLijst()
        Bedrijf.BouwBedrijfLijst()
        Tree.BouwTrees()
    End Sub

    Protected Sub btnHerlaadTooltips_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnHerlaadTooltips.Click
        XML.ParseTooltips()
        LaadTooltipInfo()
    End Sub

#End Region

#Region "Page Load Methods"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.Title = "Beheerpagina"

        Util.CheckOfBeheerder(Page.Request.Url.AbsolutePath)

        LaadJavascript()
        LaadTooltips()

        If Not IsPostBack Then
            'Dropdowns laden
            LaadBedrijfDropdowns()
            LaadVersieDropdowns()
            LaadTaalDropdowns()
            LaadAlleCategorien()

            LaadTreeGegevens()
            LaadTooltipInfo()
        End If

    End Sub

    Private Sub LaadTooltips()

        'Nieuwe lijst van tooltips definiëren
        Dim lijst As New List(Of Tooltip)

        'Alle tooltips voor onze pagina toevoegen

        'Bedrijfbeheer
        lijst.Add(New Tooltip("tipAddBedrijf"))
        lijst.Add(New Tooltip("tipAddTag"))
        lijst.Add(New Tooltip("tipEditBedrijf"))
        lijst.Add(New Tooltip("tipEditTag"))
        lijst.Add(New Tooltip("tipBewerkBedrijf"))
        lijst.Add(New Tooltip("tipDeleteBedrijf"))

        'Taalbeheer
        lijst.Add(New Tooltip("tipAddTaal"))
        lijst.Add(New Tooltip("tipTaalAfkorting"))
        lijst.Add(New Tooltip("tipEditTaal"))
        lijst.Add(New Tooltip("tipEditAfkorting"))
        lijst.Add(New Tooltip("tipBewerkTaal"))
        lijst.Add(New Tooltip("tipTaalDelete"))

        'Versiebeheer
        lijst.Add(New Tooltip("tipAddVersie"))
        lijst.Add(New Tooltip("tipEditVersie"))
        lijst.Add(New Tooltip("tipVersieKopieren"))
        lijst.Add(New Tooltip("tipNaamVersieKopie"))
        lijst.Add(New Tooltip("tipAantalCategorien"))
        lijst.Add(New Tooltip("tipAantalArtikels"))
        lijst.Add(New Tooltip("tipBewerkVersie"))
        lijst.Add(New Tooltip("tipDeleteVersie"))

        'Categoriebeheer
        lijst.Add(New Tooltip("tipAddCatnaam"))
        lijst.Add(New Tooltip("tipAddhoogte"))
        lijst.Add(New Tooltip("tipAddCatTaal"))
        lijst.Add(New Tooltip("tipAddCatVersie"))
        lijst.Add(New Tooltip("tipAddCatBedrijf"))
        lijst.Add(New Tooltip("tipAddParentcat"))

        lijst.Add(New Tooltip("tipEditCatTaalkeuze"))
        lijst.Add(New Tooltip("tipEditCatVersiekeuze"))
        lijst.Add(New Tooltip("tipEditCatBedrijfkeuze"))

        lijst.Add(New Tooltip("tipEditCategorie"))
        lijst.Add(New Tooltip("tipCatbewerknaam"))
        lijst.Add(New Tooltip("tipEditCatHoogte"))
        lijst.Add(New Tooltip("tipEditCatTaal"))
        lijst.Add(New Tooltip("tipEditCatVersie"))
        lijst.Add(New Tooltip("tipEditCatBedrijf"))
        lijst.Add(New Tooltip("tipEditCatParent"))

        lijst.Add(New Tooltip("tipCatDelTaalkeuze"))
        lijst.Add(New Tooltip("lbltipCatDelVersiekeuze"))
        lijst.Add(New Tooltip("tipCatDelBedrijfkeuze"))
        lijst.Add(New Tooltip("tipCatVerwijder"))

        lijst.Add(New Tooltip("tipTreesAantal"))
        lijst.Add(New Tooltip("tipTreesAantalCats"))
        lijst.Add(New Tooltip("tipTreesAantalArts"))
        lijst.Add(New Tooltip("tipTreesWeergeven"))
        lijst.Add(New Tooltip("tipTreesHerbouwen"))
        lijst.Add(New Tooltip("tipAantalTooltips"))
        lijst.Add(New Tooltip("tipHerlaadTooltips"))

        Util.TooltipsToevoegen(Me, lijst)

    End Sub

    Private Sub LaadJavascript()

        'Bedrijfbeheer

        JavaScript.ZetButtonOpDisabledOnClick(btnAddBedrijf, "Toevoegen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnEditBedrijf, "Wijzigen...")
        JavaScript.VoerJavaScriptUitOn(ddlBewerkBedrijf, JavaScript.DisableCode(txtEditBedrijf) & JavaScript.DisableCode(txtEditTag) & JavaScript.DisableCode(btnEditBedrijf), "onchange")
        JavaScript.ZetButtonOpDisabledOnClick(btnDeleteBedrijf, "Verwijderen...", True, True)

        'Taalbeheer

        JavaScript.ZetButtonOpDisabledOnClick(btnAddTaal, "Toevoegen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnEditTaal, "Wijzigen...")
        JavaScript.VoerJavaScriptUitOn(ddlBewerkTaal, JavaScript.DisableCode(txtEditTaal) & JavaScript.DisableCode(txtEditAfkorting) & JavaScript.DisableCode(btnEditTaal), "onchange")
        JavaScript.ZetButtonOpDisabledOnClick(btnTaalDelete, "Verwijderen...", True, True)

        'Versiebeheer

        JavaScript.ZetButtonOpDisabledOnClick(btnAddVersie, "Toevoegen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnEditVersie, "Wijzigen...")
        JavaScript.VoerJavaScriptUitOn(ddlBewerkVersie, JavaScript.DisableCode(txtEditVersie) & JavaScript.DisableCode(btnEditVersie), "onchange")
        JavaScript.ZetButtonOpDisabledOnClick(btnVersieKopieren, "Kopiëren...")
        JavaScript.ZetButtonOpDisabledOnClick(btnDeleteVersie, "Verwijderen...", True, True)

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
        JavaScript.VoerJavaScriptUitOn(ddlEditCatBedrijf, JavaScript.DisableCode(btnCatEdit), "onchange")
        JavaScript.ZetDropdownOpDisabledOnChange(ddlEditCatTaal, ddlEditCatParent, "Laden...")
        JavaScript.VoerJavaScriptUitOn(ddlEditCatTaal, JavaScript.DisableCode(btnCatEdit), "onchange")
        JavaScript.ZetDropdownOpDisabledOnChange(ddlEditCatVersie, ddlEditCatParent, "Laden...")
        JavaScript.VoerJavaScriptUitOn(ddlEditCatVersie, JavaScript.DisableCode(btnCatEdit), "onchange")

        'Verwijderen
        JavaScript.ZetButtonOpDisabledOnClick(btnCatDelete, "Verwijderen...", True, True)
        JavaScript.ZetButtonOpDisabledOnClick(btnCatDelFilteren, "Filteren...", True, True)

        'Applicatie-onderhoud
        JavaScript.ZetButtonOpDisabledOnClick(btnTreeWeergeven, "Bezig met opbouwen...", True, True)

        JavaScript.ZetButtonOpDisabledOnClick(btnHerlaadTooltips, "Herladen...", True, True)

    End Sub

    Private Sub LaadTreeGegevens()

        lblTreesAantal.Text = Tree.GetTrees.Count

        ddlTreesWeergeven.Items.Add(New ListItem("-- Boomstructuur --", -1000))

        Dim aantalCats As Integer = 0
        Dim aantalArts As Integer = 0
        For Each t As Tree In Tree.GetTrees
            aantalCats = t.RootNode.GetRecursiveCategorieCount(aantalCats)
            aantalArts = t.RootNode.GetRecursiveArtikelCount(aantalArts)
            ddlTreesWeergeven.Items.Add(New ListItem(t.Naam))
        Next t

        lblTreesAantalCats.Text = aantalCats
        lblTreesAantalArts.Text = aantalArts

    End Sub

    Private Sub LaadTooltipInfo()
        lblAantalTooltips.Text = XML.GetTipCount
    End Sub

#End Region


End Class
