Imports Manual

Partial Class App_Presentation_Beheer
    Inherits System.Web.UI.Page

#Region "Paginavariabelen"
    Private artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties
    Private categoriedal As CategorieDAL = DatabaseLink.GetInstance.GetCategorieFuncties
    Private versiedal As VersieDAL = DatabaseLink.GetInstance.GetVersieFuncties
    Private taaldal As TaalDAL = DatabaseLink.GetInstance.GetTaalFuncties
    Private bedrijfdal As BedrijfDAL = DatabaseLink.GetInstance.GetBedrijfFuncties
    Private moduledal As ModuleDAL = DatabaseLink.GetInstance.GetModuleFuncties

    Private adapterCat As New ManualTableAdapters.tblCategorieTableAdapter
    Private adapterVersie As New ManualTableAdapters.tblVersieTableAdapter
    Private adapterBedrijf As New ManualTableAdapters.tblBedrijfTableAdapter
    Private adapterTaal As New ManualTableAdapters.tblTaalTableAdapter
    Private adapterArtikel As New ManualTableAdapters.tblArtikelTableAdapter
#End Region

#Region "Code voor Categoriebeheer"

#Region "Code: Categorie Toevoegen"

    Protected Sub btnCatAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatAdd.Click
        Try
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
                If categoriedal.checkCategorie(c.Categorie, c.Bedrijf, c.Versie, c.FK_Taal).Count = 0 Then

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
                        If Session("query") IsNot Nothing Then
                            If Request.QueryString("Add") IsNot Nothing Then
                                Response.Redirect("ArtikelToevoegen.aspx" + Session("query") + "&categorieID=" + categorieID.ToString)
                            ElseIf Request.QueryString("Edit") IsNot Nothing Then
                                Response.Redirect("ArtikelBewerken.aspx" + Session("query") + "&categorieID=" + categorieID.ToString)
                            End If
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
        Catch ex As Exception
            Util.OnverwachteFout(btnCatAdd, ex.Message)
        End Try
    End Sub

    Protected Sub ddlAddCatBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatBedrijf.SelectedIndexChanged
        Try
            Toevoegen_LaadParentCategorie()
        Catch ex As Exception
            Util.OnverwachteFout(ddlAddCatBedrijf, ex.Message)
        End Try
    End Sub

    Protected Sub ddlAddCatTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatTaal.SelectedIndexChanged
        Try
            Toevoegen_LaadParentCategorie()
        Catch ex As Exception
            Util.OnverwachteFout(ddlAddCatTaal, ex.Message)
        End Try
    End Sub

    Protected Sub ddlAddCatVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddCatVersie.SelectedIndexChanged
        Try
            Toevoegen_LaadParentCategorie()
        Catch ex As Exception
            Util.OnverwachteFout(ddlAddCatVersie, ex.Message)
        End Try
    End Sub

    Protected Sub ddlAddParentcat_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            Toevoegen_LaadCategorieHoogte()
        Catch ex As Exception
            Util.OnverwachteFout(ddlAddParentcat, ex.Message)
        End Try
    End Sub

    Private Sub Toevoegen_LaadParentCategorie()
        If ddlAddCatBedrijf.Items.Count > 0 And ddlAddCatTaal.Items.Count > 0 And ddlAddCatVersie.Items.Count > 0 Then
            Dim t As Tree = Tree.GetTree(ddlAddCatTaal.SelectedValue, ddlAddCatVersie.SelectedValue, ddlAddCatBedrijf.SelectedValue)
            Util.LeesCategorien(ddlAddParentcat, t, True, True)
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

    Private Function Wijzigen_CheckCategorieRecursief(ByVal catnaam As String, ByVal bedrijf As Integer, ByVal versie As Integer, ByVal taal As Integer, ByVal parentCategorieID As Integer) As Boolean

        'Check of deze categorie een dubbele naam heeft
        Dim checkdt As tblCategorieDataTable = categoriedal.checkCategorieByID(catnaam, bedrijf, versie, taal, parentCategorieID)
        If (checkdt.Count > 0) Then
            Return False
        Else

            Dim dt As tblCategorieDataTable = categoriedal.getCategorieByParent(parentCategorieID)
            If dt.Count > 0 Then

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
            If artikeldt.Count > 0 Then

                'Elk artikel van deze parentcategorie checken
                For Each artikel As tblArtikelRow In artikeldt

                    Dim checkartikeldt As tblArtikelDataTable = artikeldal.checkArtikelByTitel(artikel.Titel, bedrijf, versie, taal)
                    If checkartikeldt.Count > 0 Then
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
        If dt.Count > 0 Then

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
        If artikeldt.Count > 0 Then

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
        Try
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

                            End If
                            Util.SetOK("Categorie gewijzigd.", lblResEdit, imgResEdit)
                        End If
                    Else
                        Util.SetError("Wijzigen mislukt.", lblResEdit, imgResEdit)
                    End If
                Else
                    Util.SetError("Een andere categorie in deze combinate van taal, versie en bedrijf heeft reeds dezelfde naam.", lblResEdit, imgResEdit)
                End If

                LaadAlleCategorien()
                Wijzigen_LaadKeuzeCategorie()
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblResEdit, imgResEdit)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnCatEdit, ex.Message)
        End Try
    End Sub

    Protected Sub btnEditCatVerfijnen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditCatVerfijnen.Click
        Try
            Wijzigen_LaadKeuzeCategorie()
        Catch ex As Exception
            Util.OnverwachteFout(btnEditCatVerfijnen, ex.Message)
        End Try
    End Sub

    Protected Sub ddlEditCatBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatBedrijf.SelectedIndexChanged
        Try
            Wijzigen_LaadParentCategorie()
        Catch ex As Exception
            Util.OnverwachteFout(ddlEditCatBedrijf, ex.Message)
        End Try
    End Sub

    Protected Sub ddlEditCatTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatTaal.SelectedIndexChanged
        Try
            Wijzigen_LaadParentCategorie()
        Catch ex As Exception
            Util.OnverwachteFout(ddlEditCatTaal, ex.Message)
        End Try
    End Sub

    Protected Sub ddlEditCatVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatVersie.SelectedIndexChanged
        Try
            Wijzigen_LaadParentCategorie()
        Catch ex As Exception
            Util.OnverwachteFout(ddlEditCatVersie, ex.Message)
        End Try
    End Sub

    Protected Sub ddlEditCategorie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Util.SetHidden(lblResEdit, imgResEdit)
        Try
            Wijzigen_LaadCategorieDetails()
        Catch ex As Exception
            Util.OnverwachteFout(ddlEditCategorie, ex.Message)
        End Try
    End Sub

    Protected Sub ddlEditCatParent_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Try
            Wijzigen_LaadCategorieHoogte()
        Catch ex As Exception
            Util.OnverwachteFout(ddlEditCatParent, ex.Message)
        End Try
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

                LaadTooltipsCategorieBewerken()
            End If

        End If

    End Sub

    Private Sub Wijzigen_LaadParentCategorie()
        If ddlEditCatBedrijf.Items.Count > 0 And ddlEditCatTaal.Items.Count > 0 And ddlEditCatVersie.Items.Count > 0 Then
            Dim t As Tree = Tree.GetTree(ddlEditCatTaal.SelectedValue, ddlEditCatVersie.SelectedValue, ddlEditCatBedrijf.SelectedValue)
            Util.LeesCategorien(ddlEditCatParent, t, True, True)

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

        Dim dr As tblCategorieRow = categoriedal.getCategorieByID(ddlEditCategorie.SelectedValue)
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

                Wijzigen_LaadParentCategorie()

                Try
                    ddlEditCatParent.SelectedValue = categorieRij.FK_parent
                Catch
                    Return
                End Try

            End If
        End If
    End Sub

#End Region

#Region "Code: Categorie Positioneren"

    Protected Sub btnCatPositieFilteren_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatPositieFilteren.Click
        Try
            Dim t As Tree = Tree.GetTree(ddlCatPositieTaal.SelectedValue, ddlCatPositieVersie.SelectedValue, ddlCatPositieBedrijf.SelectedValue)
            Util.LeesCategorien(ddlCatPositieCategorie, t, True, True)
            LaadReorderlist()
        Catch ex As Exception
            Util.OnverwachteFout(btnCatPositieFilteren, ex.Message)
        End Try
    End Sub

    Private Sub LaadReorderlist()
        ReOrderCategorie.DataBind()
    End Sub

    Protected Sub PostioneerCategorieInCode(ByVal sender As Object, ByVal e As AjaxControlToolkit.ReorderListItemReorderEventArgs)
        Try
            Dim listitem As AjaxControlToolkit.ReorderListItem = e.Item
            If listitem IsNot Nothing Then

                Dim tbl As Table = listitem.Controls.Item(0)
                If tbl IsNot Nothing Then

                    Dim tr As TableRow = tbl.Controls.Item(0)
                    If tr IsNot Nothing Then

                        Dim td As TableCell = tr.Controls.Item(1)
                        If td IsNot Nothing Then

                            Dim hiddenfield As HiddenField = Nothing
                            For Each ctl As Control In td.Controls
                                If ctl.GetType.ToString.Contains("HiddenField") Then
                                    hiddenfield = ctl
                                End If
                            Next ctl

                            If hiddenfield IsNot Nothing Then
                                Dim categorieID As Integer = hiddenfield.Value

                                Dim t As Tree = Tree.GetTree(ddlCatPositieTaal.SelectedValue, ddlCatPositieVersie.SelectedValue, ddlCatPositieBedrijf.SelectedValue)
                                Dim categorie As Node = t.DoorzoekTreeVoorNode(categorieID, Global.ContentType.Categorie)
                                Dim parent As Node = t.VindParentVanNode(categorie)

                                Dim nieuwegegevens As tblCategorieDataTable = categoriedal.getCategorieByParent(parent.ID)

                                For kindindex As Integer = 0 To parent.GetChildCount - 1
                                    Dim kind As Node = parent.GetChildren(kindindex)

                                    If kind.Type = Global.ContentType.Artikel Then Continue For

                                    For rijindex As Integer = 0 To nieuwegegevens.Count - 1
                                        Dim rij As tblCategorieRow = nieuwegegevens.Rows(rijindex)

                                        If kind.ID = rij.CategorieID Then
                                            kind.Hoogte = rij.Hoogte
                                            Exit For
                                        End If

                                    Next rijindex

                                Next kindindex

                            End If
                        End If
                    End If
                End If

            End If

        Catch ex As Exception
            Util.OnverwachteFout(btnCatPositieFilteren, ex.Message)
        End Try
    End Sub

    Protected Sub ddlCatPositieCategorie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCatPositieCategorie.SelectedIndexChanged
        Try
            LaadReorderlist()
        Catch ex As Exception
            Util.OnverwachteFout(btnCatPositieFilteren, ex.Message)
        End Try
    End Sub

#End Region

#Region "Code: Categorie Verwijderen"

    Private Sub CategorieRecursiefVerwijderen(ByRef parent As Node, ByRef t As Tree)

        'Zo diep mogelijk gaan
        If parent.GetChildCount > 0 Then
            For Each kind As Node In parent.GetChildren

                If kind.Type = Global.ContentType.Categorie Then
                    CategorieRecursiefVerwijderen(kind, t)
                End If

                If kind.Type = Global.ContentType.Artikel Then
                    If artikeldal.StdAdapter.Delete(kind.ID) Then
                        Dim previousparent As Node = t.VindParentVanNode(kind)
                        previousparent.RemoveChild(kind)
                    End If
                End If

            Next kind
        End If

        If categoriedal.StdAdapter.Delete(parent.ID) Then
            Dim previousparent As Node = t.VindParentVanNode(parent)
            previousparent.RemoveChild(parent)
        End If


    End Sub

    Protected Sub btnCatDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatDelete.Click
        Try
            If Util.Valideer(ddlCatVerwijder) Then
                Dim categorieID As Integer = ddlCatVerwijder.SelectedValue

                If ckbAllesCategorie.Checked Then
                    Dim t As Tree = Tree.GetTree(ddlCatDelTaalkeuze.SelectedValue, ddlCatDelVersiekeuze.SelectedValue, ddlCatDelBedrijfkeuze.SelectedValue)
                    Dim parent As Node = t.DoorzoekTreeVoorNode(categorieID, Global.ContentType.Categorie)
                    CategorieRecursiefVerwijderen(parent, t)
                Else
                    'Nakijken of er nog artikels of categorieën onder deze categorie staan
                    If (artikeldal.GetArtikelsByParent(categorieID).Count = 0) And (categoriedal.getCategorieByParent(categorieID).Count = 0) Then
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
                End If

                LaadAlleCategorien()
                Verwijderen_LaadParentCategorie()
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblResDelete, imgResDelete)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnCatDelFilteren, ex.Message)
        End Try
    End Sub

    Protected Sub btnCatDelFilteren_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatDelFilteren.Click
        Try
            Verwijderen_LaadParentCategorie()
        Catch ex As Exception
            Util.OnverwachteFout(btnCatDelFilteren, ex.Message)
        End Try
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

    Protected Sub ddlCatVerwijder_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCatVerwijder.SelectedIndexChanged
        Util.SetHidden(lblResDelete, imgResDelete)
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
        Wijzigen_LaadKeuzeCategorie()

        'Categorie Positioneren
        t = Tree.GetTree(ddlCatPositieTaal.SelectedValue, ddlCatPositieVersie.SelectedValue, ddlCatPositieBedrijf.SelectedValue)
        Util.LeesCategorien(ddlCatPositieCategorie, t, True, True)
        LaadReorderlist()

        'Categorie Verwijderen - Te verwijderen categorie
        t = Tree.GetTree(ddlCatDelTaalkeuze.SelectedValue, ddlCatDelVersiekeuze.SelectedValue, ddlCatDelBedrijfkeuze.SelectedValue)
        Util.LeesCategorien(ddlCatVerwijder, t)
        Verwijderen_LaadParentCategorie()

    End Sub

#End Region

#Region "Code voor Taalbeheer"

    Protected Sub btnAddTaal_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTaal.Click
        Try
            If Not txtAddTaal.Text = String.Empty And Not txtTaalAfkorting.Text = String.Empty Then
                Dim taaltext As String = txtAddTaal.Text
                Dim taaltag As String = txtTaalAfkorting.Text

                If (taaldal.checkTaal(taaltext, taaltag).Count = 0) Then
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
                        Dim resultaat As String = Tree.BouwTreesVoorTaal(bedrijven, versies, nieuwetaal)

                        If resultaat = "OK" Then
                            Util.SetOK("Taal toegevoegd.", lblAddTaalRes, imgAddTaalRes)
                            Me.txtAddTaal.Text = String.Empty
                            Me.txtTaalAfkorting.Text = String.Empty
                        Else
                            Util.SetWarn("Taal toegevoegd met waarschuwing: kon de taal niet in het geheugen toevoegen. Gelieve de boomstructuren te herbouwen.", lblAddTaalRes, imgAddTaalRes)
                        End If
                    End If

                    LaadTaalDropdowns()
                    LaadTreeGegevens()
                Else
                    Util.SetError("Deze taal is reeds toegvoegd.", lblAddTaalRes, imgAddTaalRes)
                End If
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblAddTaalRes, imgAddTaalRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnAddTaal, ex.Message)
        End Try
    End Sub

    Protected Sub btnEditTaal_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditTaal.Click
        Try
            If Not txtEditAfkorting.Text = String.Empty And Not txtEditTaal.Text = String.Empty And ddlBewerkTaal.SelectedItem IsNot Nothing Then
                Dim taaltag As String = txtEditAfkorting.Text
                Dim taalID As String = ddlBewerkTaal.SelectedValue
                Dim taaltext As String = txtEditTaal.Text
                Dim oudetaaltag As String = Session("oudataaltag")
                If (taaldal.checkTaalByID(taaltext, taaltag, taalID).Count = 0) Then
                    If (adapterTaal.Update(taaltext, taaltag, taalID) > 0) Then
                        If artikeldal.updateArtikelTagMetTaalTag(taaltag, oudetaaltag) = 0 Then
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
                        LaadTreeGegevens()
                    Else
                        Util.SetError("Een andere taal heeft deze naam al.", lblEditTaalRes, imgEditTaalRes)
                    End If
                End If
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblEditTaalRes, imgEditTaalRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnEditTaal, ex.Message)
        End Try
    End Sub

    Protected Sub btnTaalDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTaalDelete.Click
        Try
            If ddlTaalDelete.SelectedItem IsNot Nothing Then
                Dim taalID As Integer = ddlTaalDelete.SelectedValue

                If (artikeldal.getArtikelsByTaal(taalID).Count = 0 And categoriedal.GetCategorieByTaal(taalID).Count = 0) Then
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
                        LaadTreeGegevens()
                    End If
                Else
                    Util.SetError("Er bestaan nog artikels of categorieën onder deze taal.", lblDeleteTaalRes, imgDeleteTaalRes)
                End If
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblDeleteTaalRes, imgDeleteTaalRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnTaalDelete, ex.Message)
        End Try
    End Sub

    Protected Sub ddlBewerkTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Util.SetHidden(lblEditTaalRes, imgEditTaalRes)
        LeesTaal(Taal.GetTaal(ddlBewerkTaal.SelectedValue))
        Session("oudataaltag") = txtEditAfkorting.Text
    End Sub

    Private Sub LaadTaalDropdowns()
        Util.LeesTalen(ddlBewerkTaal)
        If ddlBewerkTaal.Items.Count > 0 Then LeesTaal(Taal.GetTaal(ddlBewerkTaal.SelectedValue))
        Util.LeesTalen(ddlTaalDelete)

        Util.LeesTalen(ddlAddCatTaal)
        Util.LeesTalen(ddlEditCatTaal)
        Util.LeesTalen(ddlCatDelTaalkeuze)
        Util.LeesTalen(ddlEditCatTaalkeuze)
        Util.LeesTalen(ddlCatPositieTaal)
    End Sub

    Private Sub LeesTaal(ByRef t As Taal)
        If t IsNot Nothing Then
            Me.txtEditTaal.Text = t.TaalNaam
            Me.txtEditAfkorting.Text = t.TaalTag
        End If
    End Sub

    Protected Sub ddlTaalDelete_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTaalDelete.SelectedIndexChanged
        Util.SetHidden(lblDeleteTaalRes, imgDeleteTaalRes)
    End Sub

#End Region

#Region "Code voor Versiebeheer"

    Protected Sub btnAddVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddVersie.Click
        Try
            If Not txtAddVersie.Text = String.Empty Then

                Dim versietext As String = txtAddVersie.Text

                If (versiedal.CheckVersie(versietext).Count = 0) Then
                    Dim versieID As Integer = versiedal.insertVersie(versietext)

                    If versieID = -1 Then
                        Util.SetError("Toevoegen mislukt.", lblAddVersieRes, imgAddVersieRes)
                    Else

                        'Geheugen updaten
                        Versie.AddVersie(New Versie(versieID, versietext))
                        Dim bedrijfdt As tblBedrijfDataTable = DatabaseLink.GetInstance.GetBedrijfFuncties.GetAllBedrijf
                        Dim versierij As tblVersieRow = DatabaseLink.GetInstance.GetVersieFuncties.GetVersieByID(versieID)
                        Dim taaldt As tblTaalDataTable = DatabaseLink.GetInstance.GetTaalFuncties.GetAllTaal()
                        Dim resultaat As String = Tree.BouwTreesVoorVersie(bedrijfdt, versierij, taaldt)
                        If resultaat = "OK" Then
                            Util.SetOK("Versie toegevoegd.", lblAddVersieRes, imgAddVersieRes)
                            Me.txtAddVersie.Text = String.Empty
                        Else
                            Util.SetWarn("Versie toegevoegd met waarschuwing: kon de versie niet in het geheugen toevoegen. Gelieve de boomstructuren te herbouwen.", lblAddTaalRes, imgAddTaalRes)
                        End If

                    End If

                    LaadVersieDropdowns()
                    LaadTreeGegevens()
                Else
                    Util.SetWarn("Deze versie bestaat reeds.", lblAddVersieRes, imgAddVersieRes)
                End If
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblAddVersieRes, imgAddVersieRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnAddVersie, ex.Message)
        End Try
    End Sub

    Protected Sub btnEditVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditVersie.Click
        Try
            If Not txtEditVersie.Text = String.Empty And ddlBewerkVersie.SelectedItem IsNot Nothing Then
                Dim versietext As String = txtEditVersie.Text
                Dim versieID As Integer = ddlBewerkVersie.SelectedValue
                Dim oudeversie As String = ddlBewerkVersie.SelectedItem.Text
                If (versiedal.CheckVersieByID(versietext, versieID).Count = 0) Then
                    If adapterVersie.Update(versietext, versieID) > 0 Then
                        If artikeldal.updateArtikelTagMetVersie(versietext, oudeversie) = 0 Then
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
                            LaadTreeGegevens()
                        End If
                    End If
                Else
                    Util.SetError("Een andere versie heeft dit versienummer al.", lblEditVersieRes, imgEditVersieRes)
                End If
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblEditVersieRes, imgEditVersieRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnEditVersie, ex.Message)
        End Try
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

                'Nieuwe tag opbouwen
                Dim v As Versie = Versie.GetVersie(versieID)
                If v Is Nothing Then Return False

                Dim ta As Taal = Taal.GetTaal(tree.Taal.ID)
                If ta Is Nothing Then Return False

                Dim b As Bedrijf = Bedrijf.GetBedrijf(tree.Bedrijf.ID)
                If b Is Nothing Then Return False

                Dim modulesplit() As String = a.Tag.Split("_")
                Dim moduletag As String = modulesplit(3)
                If moduletag Is Nothing Then Return False

                Dim artikeltag As String = modulesplit(4)
                If artikeltag Is Nothing Then Return False

                a.Tag = String.Concat(v.VersieNaam, "_", ta.TaalNaam, "_", b.Naam, "_", moduletag, "_", artikeltag)

                'De categorie updaten (we willen de nieuwe categorie gebruiken)
                a.Categorie = categorieID

                resultaat = adapterArtikel.Insert(a.Titel, a.Categorie, a.Taal, a.Bedrijf, versieID, a.Tekst, a.Tag, a.IsFinal)

                If resultaat = False Then 'kon een artikel niet kopiëren
                    Return False
                End If

            End If

        Next kind

        Return True

    End Function

    Protected Sub btnVersieKopieren_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVersieKopieren.Click
        Try
            If Not txtNaamNieuweVersieKopie.Text = String.Empty And ddlVersiekopieren.SelectedItem IsNot Nothing Then
                Dim versietext As String = txtNaamNieuweVersieKopie.Text
                Dim versieID As Integer = ddlVersiekopieren.SelectedValue

                If (versiedal.CheckVersieByID(versietext, versieID).Count = 0) Then

                    Dim nieuweVersieID As Integer = versiedal.insertVersie(versietext)
                    If nieuweVersieID = -1 Then
                        Util.SetError("Kopiëren mislukt: Kon niet met de database verbinden.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
                    Else
                        Dim bedrijven As tblBedrijfDataTable = bedrijfdal.GetAllBedrijf()
                        Dim talen As tblTaalDataTable = taaldal.GetAllTaal()

                        'Versie in geheugen toevoegen
                        Dim nieuweversie As New Versie(nieuweVersieID, versietext)
                        Versie.AddVersie(nieuweversie)

                        'Alle categorieën van deze versie recursief kopiëren
                        For Each t As tblTaalRow In talen
                            For Each b As tblBedrijfRow In bedrijven
                                Dim oudeversietree As Tree = Tree.GetTree(t.TaalID, versieID, b.BedrijfID)

                                If oudeversietree Is Nothing Then
                                    Util.SetError("Kopiëren mislukt. Kon de boomstructuur van de oude versie niet vinden.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)

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
                                    Util.SetError("Kopiëren mislukt. Kon niet alle categorieën of artikels kopiëren.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
                                    Return
                                End If

                            Next b
                        Next t

                        Dim v As tblVersieRow = versiedal.GetVersieByID(nieuweVersieID)
                        Dim gelukt As String = Tree.BouwTreesVoorVersie(bedrijven, v, talen)

                        If Not gelukt = "OK" Then
                            Util.SetWarn("Kopiëren gelukt met waarschuwing: kon de versiestructuur niet updaten. Herbouw de versiestructuur als u klaar bent met uw wijzigingen.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
                        Else
                            Util.SetOK("Versie gekopieerd.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
                        End If

                    End If
                Else
                    Util.SetError("Een andere versie heeft deze naam al.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
                End If

                LaadVersieDropdowns()
                LaadTreeGegevens()
                Me.txtNaamNieuweVersieKopie.Text = String.Empty
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblVersieKopierenFeedback, imgVersieKopierenFeedback)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnVersieKopieren, ex.Message)
        End Try
    End Sub

    Protected Sub btnDeleteVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteVersie.Click
        Try
            If ddlDeletVersie.SelectedItem IsNot Nothing Then
                Dim versieID As Integer = ddlDeletVersie.SelectedValue
                If ckbAllesOnderVersie.Checked Then
                    If versiedal.DeleteArtikelsVoorVersie(versieID) = -1 Then
                        Util.SetError("Artikels onder deze zijn niet verwijderd.", lblDeleteVersieRes, imgDeleteVersieRes)
                    Else
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
                    End If
                Else
                    If (artikeldal.getArtikelsByVersie(versieID).Count = 0 And categoriedal.GetCategorieByVersie(versieID).Count = 0) Then
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
                End If

            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblDeleteVersieRes, imgDeleteVersieRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnDeleteVersie, ex.Message)
        End Try
    End Sub

    Protected Sub ddlBewerkVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Util.SetHidden(lblEditVersieRes, imgEditVersieRes)
        Try
            LeesVersie(Versie.GetVersie(ddlBewerkVersie.SelectedValue))
        Catch ex As Exception
            Util.OnverwachteFout(ddlBewerkVersie, ex.Message)
        End Try
    End Sub

    Protected Sub ddlVersiekopieren_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlVersiekopieren.SelectedIndexChanged
        Util.SetHidden(lblVersieKopierenFeedback, imgVersieKopierenFeedback)
        Try
            LeesTeKopierenVersie(Versie.GetVersie(ddlVersiekopieren.SelectedValue))
        Catch ex As Exception
            Util.OnverwachteFout(ddlVersiekopieren, ex.Message)
        End Try
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
        Util.LeesVersies(ddlCatPositieVersie)
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
                If tree IsNot Nothing Then
                    aantal = tree.RootNode.GetRecursiveCategorieCount(aantal)
                End If
            Next b
        Next t

        Return aantal

    End Function

    Private Function BerekenArtikelsVoorVersie(ByVal versie As Versie) As Integer
        Dim aantal As Integer = 0

        For Each t As Taal In Taal.GetTalen
            For Each b As Bedrijf In Bedrijf.GetBedrijven
                Dim tree As Tree = tree.GetTree(t.ID, versie.ID, b.ID)
                If tree IsNot Nothing Then
                    aantal = tree.RootNode.GetRecursiveArtikelCount(aantal)
                End If
            Next b
        Next t

        Return aantal

    End Function

    Protected Sub ddlDeletVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlDeletVersie.SelectedIndexChanged
        Util.SetHidden(lblDeleteVersieRes, imgDeleteVersieRes)
    End Sub


#End Region

#Region "Code voor Bedrijfbeheer"

    Protected Sub btnAddBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddBedrijf.Click
        Try
            If Not txtAddTag.Text = String.Empty And Not txtAddbedrijf.Text = String.Empty Then

                Dim bedrijfTag As String = txtAddTag.Text
                Dim bedrijfnaam As String = txtAddbedrijf.Text
                If (bedrijfdal.getBedrijfByNaamOrTag(bedrijfnaam, bedrijfTag).Count = 0) Then

                    Dim bedrijfID As Integer = bedrijfdal.insertBedrijf(bedrijfnaam, bedrijfTag)

                    If bedrijfID = -1 Then
                        Util.SetError("Toevoegen mislukt.", lblAddBedrijfRes, imgAddBedrijfRes)
                    Else

                        'Geheugen updaten
                        Bedrijf.AddBedrijf(New Bedrijf(bedrijfID, bedrijfnaam, bedrijfTag))

                        Dim bedrijfrij As tblBedrijfRow = DatabaseLink.GetInstance.GetBedrijfFuncties.GetBedrijfByID(bedrijfID)
                        Dim versiedt As tblVersieDataTable = DatabaseLink.GetInstance.GetVersieFuncties.GetAllVersie
                        Dim taaldt As tblTaalDataTable = DatabaseLink.GetInstance.GetTaalFuncties.GetAllTaal()
                        Dim resultaat As String = Tree.BouwTreesVoorBedrijf(bedrijfrij, versiedt, taaldt)

                        If resultaat = "OK" Then
                            Util.SetOK("Bedrijf toegevoegd.", lblAddBedrijfRes, imgAddBedrijfRes)
                            Me.txtAddTag.Text = String.Empty
                            Me.txtAddbedrijf.Text = String.Empty
                        Else
                            Util.SetWarn("Bedrijf toegevoegd met waarschuwing: kon het bedrijf niet in het geheugen toevoegen. Gelieve de boomstructuren te herbouwen.", lblAddTaalRes, imgAddTaalRes)
                        End If
                    End If

                    LaadBedrijfDropdowns()
                    LaadTreeGegevens()
                Else
                    Util.SetError("Dit bedrijf bestaat al, of een ander bedrijf heeft reeds dezelfde tag.", lblAddBedrijfRes, imgAddBedrijfRes)
                End If
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblAddBedrijfRes, imgAddBedrijfRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnAddBedrijf, ex.Message)
        End Try
    End Sub

    Protected Sub btnEditBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditBedrijf.Click
        Try
            If Not txtEditTag.Text = String.Empty And Not txtEditBedrijf.Text = String.Empty And ddlBewerkBedrijf.SelectedItem IsNot Nothing Then
                Dim bedrijfID As Integer = ddlBewerkBedrijf.SelectedValue
                Dim bedrijfTag As String = txtEditTag.Text
                Dim bedrijfnaam As String = txtEditBedrijf.Text
                Dim oudbedrijf As String = ddlBewerkBedrijf.SelectedItem.Text
                If (bedrijfdal.getBedrijfByNaamTagID(bedrijfnaam, bedrijfTag, bedrijfID).Count = 0) Then
                    If (adapterBedrijf.Update(bedrijfnaam, bedrijfTag, bedrijfID) > 0) Then
                        If artikeldal.updateArtikelTagMetBedrijf(bedrijfnaam, oudbedrijf) = 0 Then
                            Util.SetError("Wijzigen mislukt: kijk na of stored procedure 'onUpdateBedrijf' wel bestaat.", lblEditbedrijfRes, imgEditBedrijfRes)
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
                        Util.SetError("Wijzigen mislukt.", lblEditbedrijfRes, imgEditBedrijfRes)
                    End If
                Else
                    Util.SetError("Een ander bedrijf heeft reeds deze bedrijfsnaam of tag.", lblEditbedrijfRes, imgEditBedrijfRes)
                End If

                LaadBedrijfDropdowns()
                LaadTreeGegevens()
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblEditbedrijfRes, imgEditBedrijfRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnEditBedrijf, ex.Message)
        End Try
    End Sub

    Protected Sub btnDeleteBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteBedrijf.Click
        Try
            If ddlDeleteBedrijf.SelectedItem IsNot Nothing Then
                Dim bedrijfID As Integer = ddlDeleteBedrijf.SelectedValue
                If ckbAlleBedrijf.Checked Then
                    If bedrijfdal.DeleteArtikelsOnderbedrijf(bedrijfID) = -1 Then
                        Util.SetError("Artikels onder Bedrijf zijn niet verwijderd.", lblDeleteBedrijfRes, imgDeleteBedrijfRes)
                    Else
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
                            LaadTreeGegevens()
                        End If
                    End If

                Else
                    If (artikeldal.getArtikelsByBedrijf(bedrijfID).Count = 0 And categoriedal.GetCategorieByBedrijf(bedrijfID).Count = 0) Then
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
                            LaadTreeGegevens()
                        End If
                    Else
                        Util.SetError("Er staan nog artikels of categorieën onder dit bedrijf.", lblDeleteBedrijfRes, imgDeleteBedrijfRes)
                    End If

                End If
            Else
                Util.SetError("Gelieve alle velden correct in te vullen.", lblDeleteBedrijfRes, imgDeleteBedrijfRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnDeleteBedrijf, ex.Message)
        End Try
    End Sub

    Protected Sub ddlBewerkBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Util.SetHidden(lblEditbedrijfRes, imgEditBedrijfRes)
        Try
            LeesBedrijf(Bedrijf.GetBedrijf(Integer.Parse(ddlBewerkBedrijf.SelectedValue)))
        Catch ex As Exception
            Util.OnverwachteFout(ddlBewerkBedrijf, ex.Message)
        End Try
    End Sub

    Protected Sub ddlDeleteBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlDeleteBedrijf.SelectedIndexChanged
        Util.SetHidden(lblDeleteBedrijfRes, imgDeleteBedrijfRes)
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
        Util.LeesBedrijven(ddlCatPositieBedrijf)
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
        Try
            If ddlTreesWeergeven.SelectedItem.Text = "-- Boomstructuur --" Then Return

            Dim t As Tree = Tree.GetTree(ddlTreesWeergeven.SelectedItem.Text)
            Session("LeesTreeTitel") = t.Naam
            Session("LeesTree") = t.LeesTree(String.Empty, t.RootNode, -1)
            JavaScript.VoegJavascriptToeAanEndRequest(btnTreeWeergeven, "genericPopup('TreeWeergeven.aspx',800,800, 1);")
        Catch ex As Exception
            Util.OnverwachteFout(btnTreeWeergeven, ex.Message)
        End Try
    End Sub

    Protected Sub btnOk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnOk.Click
        mpeTreesHerbouwen.Hide()
        Try
            Dim resultaat As String = Tree.BouwTrees()
            If resultaat = "OK" Then
                LaadTreeGegevens()
                Util.SetOK("Trees herbouwd.", lblHerbouwTreesRes, imgHerbouwTreesRes)
            Else
                JavaScript.ShadowBoxOpenen(btnOk, String.Concat("<strong>Er is een fout gebeurd tijdens het herbouwen van de boomstructuren:</strong><br/>", resultaat))
                Util.SetError("Er is een fout opgetreden tijdens het herbouwen van de boomstructuren.", lblHerbouwTreesRes, imgHerbouwTreesRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnOk, ex.Message)
        End Try
        'JavaScript.ShadowBoxLaderSluiten(Me)

    End Sub

    Protected Sub btnHerlaadTooltips_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnHerlaadTooltips.Click
        Try
            Dim resultaat As String = XML.ParseTooltips()
            If resultaat = "OK" Then
                LaadTooltipInfo()
                Util.SetOK("Tooltips herladen.", lblHerlaadTooltipsRes, imgHerlaadTooltipsRes)
            Else
                JavaScript.ShadowBoxOpenen(btnHerlaadTooltips, String.Concat("<strong>Er is een fout gebeurd tijdens het herladen van de tooltips:</strong><br/>", resultaat))
                Util.SetError("Er is een fout opgetreden tijdens het herladen van de tooltips.", lblHerlaadTooltipsRes, imgHerlaadTooltipsRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnHerlaadTooltips, ex.Message)
        End Try
    End Sub

    Protected Sub btnTaalWeergeven_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTaalWeergeven.Click
        Try
            If ddlTaalWeergeven.SelectedItem.Text = "-- Talen --" Then Return
            Session("LeesTaal") = Lokalisatie.Taal(ddlTaalWeergeven.SelectedValue).LeesContent
            JavaScript.VoegJavascriptToeAanEndRequest(btnTaalWeergeven, "genericPopup('TaalWeergeven.aspx',800,800, 1);")
        Catch ex As Exception
            Util.OnverwachteFout(btnTaalWeergeven, ex.Message)
        End Try
    End Sub

    Protected Sub btnLokalisatieHerladen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLokalisatieHerladen.Click
        Try
            Dim resultaat As String = Lokalisatie.ParseLocalisatieStrings()
            If resultaat = "OK" Then
                LaadLokalisatieInfo()
                Util.SetOK("Taallokalisaties herladen.", lblLokalisatieHerladenRes, imgLokalisatieHerladenRes)
            Else
                JavaScript.ShadowBoxOpenen(btnLokalisatieHerladen, String.Concat("<strong>Er is een fout gebeurd tijdens het herladen van de taallokalisaties:</strong><br/>", resultaat))
                Util.SetError("Er is een fout opgetreden tijdens het herladen van de taallokalisaties.", lblLokalisatieHerladenRes, imgLokalisatieHerladenRes)
            End If
        Catch ex As Exception
            Util.OnverwachteFout(btnLokalisatieHerladen, ex.Message)
        End Try
    End Sub

    Protected Sub updPreviewLinkUpdaten_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles updPreviewLinkUpdaten.Load
        Try
            If IsPostBack Then
                JavaScript.VoegJavascriptToeAanEndRequest(Me, "Shadowbox.setup();")
                linkVideoPreview.HRef = lblVideoPreviewLink.Value
            End If
        Catch ex As Exception
            Util.OnverwachteFout(Me, ex.Message)
        End Try
    End Sub

#End Region

#Region "Code voor Modulebeheer"

    Protected Sub btnModuleToevoegen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnModuleToevoegen.Click
        If Page.IsValid And Util.Valideer(txtModuleToevoegenNaam) Then
            Try
                Dim naam As String = txtModuleToevoegenNaam.Text.Trim

                If moduledal.checkModuleByNaam(naam).Count = 0 Then
                    If moduledal.StdAdapter.Insert(naam) Then
                        Util.SetOK("Module toegevoegd.", lblModuleToevoegenRes, imgModuleToevoegenRes)
                    Else
                        Util.SetError("Toevoegen mislukt.", lblModuleToevoegenRes, imgModuleToevoegenRes)
                    End If
                Else
                    Util.SetError("Een andere module heeft reeds deze naam.", lblModuleToevoegenRes, imgModuleToevoegenRes)
                End If

                LaadModuleDropdowns()
            Catch ex As Exception
                Util.OnverwachteFout(btnModuleToevoegen, ex.Message)
            End Try
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblModuleToevoegenRes, imgModuleToevoegenRes)
        End If
    End Sub

    Protected Sub ddlModuleWijzigenKeuze_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlModuleWijzigenKeuze.SelectedIndexChanged
        Util.SetHidden(lblModuleWijzigenRes, imgModuleWijzigenRes)
        If Util.Valideer(ddlModuleWijzigenKeuze) Then
            Try
                ModuleInladen()
            Catch ex As Exception
                Util.OnverwachteFout(ddlModuleWijzigenKeuze, ex.Message)
            End Try
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblModuleWijzigenRes, imgModuleWijzigenRes)
        End If
    End Sub

    Protected Sub btnModuleWijzigen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnModuleWijzigen.Click
        If Page.IsValid And Util.Valideer(txtModuleWijzigenNaam, ddlModuleWijzigenKeuze) Then
            Try
                Dim oudemodule As String = ddlModuleWijzigenKeuze.SelectedItem.Text
                Dim naam As String = txtModuleWijzigenNaam.Text.Trim
                Dim moduleID As Integer = ddlModuleWijzigenKeuze.SelectedValue

                If moduledal.checkModuleByNaamEnID(naam, moduleID).Count = 0 Then
                    If moduledal.StdAdapter.Update(naam, moduleID) Then
                        If artikeldal.updateArtikelTagMetModule(naam, oudemodule) > 0 Then
                            Util.SetOK("Module gewijzigd.", lblModuleWijzigenRes, imgModuleWijzigenRes)
                        Else
                            Util.SetError("Wijzigen mislukt.", lblModuleWijzigenRes, imgModuleWijzigenRes)
                        End If
                    End If
                Else
                    Util.SetError("Een andere module heeft reeds deze naam.", lblModuleWijzigenRes, imgModuleWijzigenRes)
                End If

                LaadModuleDropdowns()
                ModuleInladen()
            Catch ex As Exception
                Util.OnverwachteFout(btnModuleWijzigen, ex.Message)
            End Try
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblModuleWijzigenRes, imgModuleWijzigenRes)
        End If
    End Sub

    Protected Sub btnModuleVerwijderen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnModuleVerwijderen.Click
        If Util.Valideer(ddlModuleVerwijderenKeuze) Then
            Try
                Dim moduleID As Integer = ddlModuleVerwijderenKeuze.SelectedValue
                If moduledal.checkArtikelsByModule(moduleID).Count = 0 Then
                    If moduledal.StdAdapter.Delete(moduleID) Then
                        Util.SetOK("Module verwijderd.", lblModuleVerwijderenRes, imgModuleVerwijderenRes)
                    Else
                        Util.SetError("Verwijderen mislukt.", lblModuleVerwijderenRes, imgModuleVerwijderenRes)
                    End If
                Else
                    Util.SetError("Er zijn nog Artikels die deze Module gebruiken.", lblModuleVerwijderenRes, imgModuleVerwijderenRes)
                End If
                LaadModuleDropdowns()
            Catch ex As Exception
                Util.OnverwachteFout(btnModuleVerwijderen, ex.Message)
            End Try
        Else
            Util.SetError("Gelieve alle velden correct in te vullen.", lblModuleVerwijderenRes, imgModuleVerwijderenRes)
        End If
    End Sub

    Private Sub ModuleInladen()
        Dim rij As tblModuleRow = moduledal.GetModuleByID(ddlModuleWijzigenKeuze.SelectedValue)
        If rij IsNot Nothing Then
            txtModuleWijzigenNaam.Text = rij._module
        Else
            Util.SetError("Kon de opgevraagde module niet laden.", lblModuleWijzigenRes, imgModuleWijzigenRes)
        End If
    End Sub

    Private Sub LaadModuleDropdowns()
        ddlModuleWijzigenKeuze.Items.Clear()
        ddlModuleVerwijderenKeuze.Items.Clear()
        For Each rij As tblModuleRow In moduledal.StdAdapter.GetData
            Dim listitem As New ListItem(rij._module, rij.moduleID)
            ddlModuleWijzigenKeuze.Items.Add(listitem)
            ddlModuleVerwijderenKeuze.Items.Add(listitem)
        Next rij
    End Sub
    Protected Sub ddlModuleVerwijderenKeuze_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlModuleVerwijderenKeuze.SelectedIndexChanged
        Util.SetHidden(lblModuleVerwijderenRes, imgModuleVerwijderenRes)
    End Sub

#End Region

#Region "Page Load Methods"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Page.Title = "Beheerpagina"

            Util.CheckOfBeheerder(Page.Request.Url.AbsolutePath)

            LaadTooltips()

            If IsPostBack Then
                JavaScript.VoegJavascriptToeAanEndRequest(Me, "Shadowbox.setup();")
            End If

            If Not IsPostBack Then

                LaadJavascript()

                'Dropdowns laden
                LaadBedrijfDropdowns()
                LaadVersieDropdowns()
                LaadTaalDropdowns()
                LaadModuleDropdowns()
                LaadAlleCategorien()

                LaadTreeGegevens()
                LaadTooltipInfo()
                LaadLokalisatieInfo()
            End If

            If Page.Request.QueryString("index") IsNot Nothing Then
                TabBeheer.ActiveTabIndex = Integer.Parse(Page.Request.QueryString("index"))
            End If
            Dim querystring As String
            If Page.Request.QueryString("versie") IsNot Nothing And Page.Request.QueryString("bedrijf") IsNot Nothing And Page.Request.QueryString("taal") IsNot Nothing Then
                ddlAddCatTaal.SelectedValue = Integer.Parse(Page.Request.QueryString("taal"))
                ddlAddCatVersie.SelectedValue = Integer.Parse(Page.Request.QueryString("versie"))
                ddlAddCatBedrijf.SelectedValue = Integer.Parse(Page.Request.QueryString("bedrijf"))
                Toevoegen_LaadParentCategorie()
                querystring = "?taal=" + Page.Request.QueryString("taal") + "&versie=" + Page.Request.QueryString("versie") + "&bedrijf=" + Page.Request.QueryString("bedrijf")
                If Page.Request.QueryString("module") IsNot Nothing Then
                    querystring = querystring + "&module=" + Page.Request.QueryString("module")
                    If Page.Request.QueryString("tag") IsNot Nothing Then
                        querystring = querystring + "&Artikeltag=" + Page.Request.QueryString("tag")
                        If Page.Request.QueryString("titel") IsNot Nothing Then
                            querystring = querystring + "&titel=" + Page.Request.QueryString("titel")
                        End If
                    End If
                End If
                Session("query") = querystring
            End If
        Catch ex As Exception
            Util.OnverwachteFout(Me, ex.Message)
        End Try
    End Sub

    Private Sub LaadTooltipsCategorieBewerken()
        'Nieuwe lijst van tooltips definiëren
        Dim lijst As New List(Of Tooltip)

        lijst.Add(New Tooltip("tipEditCategorie"))
        lijst.Add(New Tooltip("tipCatbewerknaam"))
        lijst.Add(New Tooltip("tipEditCatHoogte"))
        lijst.Add(New Tooltip("tipEditCatTaal"))
        lijst.Add(New Tooltip("tipEditCatVersie"))
        lijst.Add(New Tooltip("tipEditCatBedrijf"))
        lijst.Add(New Tooltip("tipEditCatParent"))

        Util.TooltipsToevoegen(Me, lijst)
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

        lijst.Add(New Tooltip("tipCatPositieVersie"))
        lijst.Add(New Tooltip("tipCatPositieTaal"))
        lijst.Add(New Tooltip("tipCatPositieBedrijf"))
        lijst.Add(New Tooltip("tipCatPositieCategorie"))

        lijst.Add(New Tooltip("tipCatDelTaalkeuze"))
        lijst.Add(New Tooltip("lbltipCatDelVersiekeuze"))
        lijst.Add(New Tooltip("tipCatDelBedrijfkeuze"))
        lijst.Add(New Tooltip("tipCatVerwijder"))

        'Modulebeheer
        lijst.Add(New Tooltip("tipModuleToevoegenNaam"))
        lijst.Add(New Tooltip("tipModuleWijzigenKeuze"))
        lijst.Add(New Tooltip("tipModuleWijzigenNaam"))
        lijst.Add(New Tooltip("tipModuleVerwijderenKeuze"))

        'Videobeheer
        lijst.Add(New Tooltip("tipVideoBeheren"))
        lijst.Add(New Tooltip("tipVideoPreviewKiezen"))
        lijst.Add(New Tooltip("tipVideoPreview"))

        'Trees
        lijst.Add(New Tooltip("tipTreesAantal"))
        lijst.Add(New Tooltip("tipTreesAantalCats"))
        lijst.Add(New Tooltip("tipTreesAantalArts"))
        lijst.Add(New Tooltip("tipTreesWeergeven"))
        lijst.Add(New Tooltip("tipTreesHerbouwen"))

        'Tooltips
        lijst.Add(New Tooltip("tipAantalTooltips"))
        lijst.Add(New Tooltip("tipHerlaadTooltips"))

        'Lokalisatie
        lijst.Add(New Tooltip("tipAantalTalen"))
        lijst.Add(New Tooltip("tipAantalTeksten"))
        lijst.Add(New Tooltip("tipTaalWeergeven"))
        lijst.Add(New Tooltip("tipLokalisatieHerladen"))

        Util.TooltipsToevoegen(Me, lijst)

    End Sub

    Private Sub LaadJavascript()


        'Bedrijfbeheer

        JavaScript.ZetButtonOpDisabledOnClick(btnAddBedrijf, "Toevoegen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnEditBedrijf, "Wijzigen...")
        JavaScript.VoerJavaScriptUitOn(ddlBewerkBedrijf, JavaScript.DisableCode(txtEditBedrijf) & JavaScript.DisableCode(txtEditTag) & JavaScript.DisableCode(btnEditBedrijf), "onchange")
        JavaScript.ZetButtonOpDisabledOnClick(btnDeleteBedrijf, "Verwijderen...", True)

        'Taalbeheer

        JavaScript.ZetButtonOpDisabledOnClick(btnAddTaal, "Toevoegen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnEditTaal, "Wijzigen...")
        JavaScript.VoerJavaScriptUitOn(ddlBewerkTaal, JavaScript.DisableCode(txtEditTaal) & JavaScript.DisableCode(txtEditAfkorting) & JavaScript.DisableCode(btnEditTaal), "onchange")
        JavaScript.ZetButtonOpDisabledOnClick(btnTaalDelete, "Verwijderen...", True)

        'Versiebeheer

        JavaScript.ZetButtonOpDisabledOnClick(btnAddVersie, "Toevoegen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnEditVersie, "Wijzigen...")
        JavaScript.VoerJavaScriptUitOn(ddlBewerkVersie, JavaScript.DisableCode(txtEditVersie) & JavaScript.DisableCode(btnEditVersie), "onchange")
        JavaScript.ZetButtonOpDisabledOnClick(btnVersieKopieren, "Kopiëren...")
        JavaScript.VoerJavaScriptUitOn(ddlVersiekopieren, JavaScript.DisableCode(btnVersieKopieren) & JavaScript.DisableCode(txtNaamNieuweVersieKopie), "onchange")
        JavaScript.ZetButtonOpDisabledOnClick(btnDeleteVersie, "Verwijderen...", True)

        'Categoriebeheer

        'Toevoegen
        JavaScript.ZetButtonOpDisabledOnClick(btnCatAdd, "Toevoegen...")
        Dim altijdDisabled As String = String.Concat(JavaScript.DisableCode(btnCatAdd), JavaScript.DisableCode(txtAddCatnaam), JavaScript.DisableCode(txtAddhoogte), JavaScript.DisableCode(ddlAddParentcat))

        JavaScript.ZetDropdownOpDisabledOnChange(ddlAddCatBedrijf, ddlAddParentcat, "Laden...")
        JavaScript.VoerJavaScriptUitOn(ddlAddCatBedrijf, altijdDisabled & JavaScript.DisableCode(ddlAddCatTaal) & JavaScript.DisableCode(ddlAddCatVersie), "onchange")
        JavaScript.ZetDropdownOpDisabledOnChange(ddlAddCatTaal, ddlAddParentcat, "Laden...")
        JavaScript.VoerJavaScriptUitOn(ddlAddCatTaal, altijdDisabled & JavaScript.DisableCode(ddlAddCatBedrijf) & JavaScript.DisableCode(ddlAddCatVersie), "onchange")
        JavaScript.ZetDropdownOpDisabledOnChange(ddlAddCatVersie, ddlAddParentcat, "Laden...")
        JavaScript.VoerJavaScriptUitOn(ddlAddCatVersie, altijdDisabled & JavaScript.DisableCode(ddlAddCatTaal) & JavaScript.DisableCode(ddlAddCatBedrijf), "onchange")

        JavaScript.VoerJavaScriptUitOn(ddlAddParentcat, JavaScript.DisableCode(btnCatAdd) & JavaScript.DisableCode(txtAddCatnaam) & JavaScript.DisableCode(txtAddhoogte) & JavaScript.DisableCode(ddlAddCatTaal) & JavaScript.DisableCode(ddlAddCatBedrijf) & JavaScript.DisableCode(ddlAddCatVersie), "onchange")

        'Wijzigen
        JavaScript.ZetButtonOpDisabledOnClick(btnCatEdit, "Wijzigen...")
        altijdDisabled = String.Concat(JavaScript.DisableCode(txtEditCathoogte), JavaScript.DisableCode(txtCatbewerknaam), JavaScript.DisableCode(btnEditCatVerfijnen), JavaScript.DisableCode(ddlEditCatBedrijfkeuze), JavaScript.DisableCode(ddlEditCatTaalkeuze), JavaScript.DisableCode(ddlEditCatVersiekeuze), JavaScript.DisableCode(btnCatEdit))
        Dim ddlDisabled As String = String.Concat(JavaScript.DisableCode(ddlEditCatBedrijf), JavaScript.DisableCode(ddlEditCatParent), JavaScript.DisableCode(ddlEditCatTaal), JavaScript.DisableCode(ddlEditCatVersie))

        JavaScript.VoerJavaScriptUitOn(btnEditCatVerfijnen, JavaScript.DisableCode(ddlEditCategorie) & ddlDisabled & JavaScript.DisableCode(btnCatEdit) & altijdDisabled, "onclick")
        JavaScript.ZetButtonOpDisabledOnClick(btnEditCatVerfijnen, "Filteren...", True)

        JavaScript.VoerJavaScriptUitOn(ddlEditCategorie, JavaScript.DisableCode(txtEditCathoogte) & JavaScript.DisableCode(txtCatbewerknaam) & JavaScript.DisableCode(ddlEditCatBedrijfkeuze) & JavaScript.DisableCode(ddlEditCatTaalkeuze) & JavaScript.DisableCode(ddlEditCatVersiekeuze) & JavaScript.DisableCode(btnCatEdit) & ddlDisabled & JavaScript.DisableCode(btnEditCatVerfijnen), "onchange")

        JavaScript.ZetDropdownOpDisabledOnChange(ddlEditCatBedrijf, ddlEditCatParent, "Laden...")
        JavaScript.VoerJavaScriptUitOn(ddlEditCatBedrijf, JavaScript.DisableCode(btnCatEdit) & altijdDisabled & JavaScript.DisableCode(ddlEditCatParent) & JavaScript.DisableCode(ddlEditCatTaal) & JavaScript.DisableCode(ddlEditCatVersie) & JavaScript.DisableCode(ddlEditCategorie), "onchange")
        JavaScript.ZetDropdownOpDisabledOnChange(ddlEditCatTaal, ddlEditCatParent, "Laden...")
        JavaScript.VoerJavaScriptUitOn(ddlEditCatTaal, JavaScript.DisableCode(btnCatEdit) & altijdDisabled & JavaScript.DisableCode(ddlEditCatParent) & JavaScript.DisableCode(ddlEditCatVersie) & JavaScript.DisableCode(ddlEditCatBedrijf) & JavaScript.DisableCode(ddlEditCategorie), "onchange")
        JavaScript.ZetDropdownOpDisabledOnChange(ddlEditCatVersie, ddlEditCatParent, "Laden...")
        JavaScript.VoerJavaScriptUitOn(ddlEditCatVersie, JavaScript.DisableCode(btnCatEdit) & altijdDisabled & JavaScript.DisableCode(ddlEditCatBedrijf) & JavaScript.DisableCode(ddlEditCatParent) & JavaScript.DisableCode(ddlEditCatTaal) & JavaScript.DisableCode(ddlEditCategorie), "onchange")

        JavaScript.VoerJavaScriptUitOn(ddlEditCatParent, altijdDisabled & JavaScript.DisableCode(ddlEditCatBedrijf) & JavaScript.DisableCode(ddlEditCatVersie) & JavaScript.DisableCode(ddlEditCatTaal) & JavaScript.DisableCode(ddlEditCategorie), "onchange")

        'Verwijderen
        JavaScript.ZetButtonOpDisabledOnClick(btnCatDelete, "Verwijderen...", True)
        JavaScript.VoerJavaScriptUitOn(btnCatDelFilteren, JavaScript.DisableCode(ddlCatDelBedrijfkeuze) & JavaScript.DisableCode(ddlCatDelTaalkeuze) & JavaScript.DisableCode(ddlCatDelVersiekeuze) & JavaScript.DisableCode(ddlCatVerwijder) & JavaScript.DisableCode(btnCatDelete), "onclick")
        JavaScript.ZetButtonOpDisabledOnClick(btnCatDelFilteren, "Filteren...", True)

        'Modulebeheer
        JavaScript.ZetButtonOpDisabledOnClick(btnModuleToevoegen, "Toevoegen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnModuleWijzigen, "Wijzigen...")
        JavaScript.ZetButtonOpDisabledOnClick(btnModuleVerwijderen, "Verwijderen...", True)
        JavaScript.VoerJavaScriptUitOn(ddlModuleWijzigenKeuze, JavaScript.DisableCode(btnModuleWijzigen) & JavaScript.DisableCode(txtModuleWijzigenNaam), "onchange")

        'Applicatie-onderhoud
        'Trees
        JavaScript.ZetButtonOpDisabledOnClick(btnTreeWeergeven, "Bezig met opbouwen...", True)

        'Tooltips
        JavaScript.ZetButtonOpDisabledOnClick(btnHerlaadTooltips, "Herladen...", True)

        'Lokalisatie
        JavaScript.ZetButtonOpDisabledOnClick(btnTaalWeergeven, "Bezig met laden...", True)
        JavaScript.ZetButtonOpDisabledOnClick(btnLokalisatieHerladen, "Herladen...", True)

    End Sub

    Private Sub LaadTreeGegevens()

        lblTreesAantal.Text = Tree.GetTrees.Count

        ddlTreesWeergeven.Items.Clear()
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

    Private Sub LaadLokalisatieInfo()
        lblAantalStrings.Text = Lokalisatie.GetTekstCount
        lblAantalTalen.Text = Lokalisatie.Talen.Count

        ddlTaalWeergeven.Items.Add(New ListItem("-- Talen --", -1000))
        For Each lokalisatie As Lokalisatie In lokalisatie.Talen
            Dim t As Taal = Taal.GetTaal(lokalisatie.TaalID)
            If t IsNot Nothing Then
                ddlTaalWeergeven.Items.Add(New ListItem(t.TaalNaam, lokalisatie.TaalID))
            End If
        Next lokalisatie
    End Sub

#End Region

End Class
