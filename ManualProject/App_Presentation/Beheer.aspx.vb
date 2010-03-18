
Partial Class App_Presentation_Beheer
    Inherits System.Web.UI.Page
    Dim artikeldal As New ArtikelDAL
    Dim categoriedal As New CategorieDAL
    Dim adapterCat As New ManualTableAdapters.tblCategorieTableAdapter
    Dim adapterVersie As New ManualTableAdapters.tblVersieTableAdapter
    Dim adapterBedrijf As New ManualTableAdapters.tblBedrijfTableAdapter
    Dim adapterTaal As New ManualTableAdapters.tblTaalTableAdapter
    Dim versiedal As New VersieDAL
    Dim taaldal As New TaalDAL
    Dim bedrijfdal As New BedrijfDAL
    Dim categorie As New Categorie


    Protected Sub ddlAddParentcat_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim hoogte As Integer
        Dim catID As Integer

        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")
        Dim ddl As DropDownList = acc.FindControl("ddlAddParentCat")

        Dim updatepanel As UpdatePanel = Me.FindControl("updCategorie")


        catID = ddl.SelectedValue
        Dim dt As New Data.DataTable

        If (categoriedal.getHoogte(catID) Is Nothing) Then
            hoogte = 0
            CType(acc.FindControl("txtAddhoogte"), TextBox).Text = hoogte
        Else
            dt = categoriedal.getHoogte(catID)
            hoogte = dt.Rows(0)("Hoogte")
            CType(acc.FindControl("txtAddhoogte"), TextBox).Text = hoogte + 1
        End If
    End Sub

    Protected Sub btnCatAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatAdd.Click

        Dim hoogte As Integer
        Dim dt As New Data.DataTable
        Dim catID As Integer
        Dim parent As Integer
        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")
        Dim ddl As DropDownList = acc.FindControl("ddlAddParentCat")
        Dim textb As TextBox = acc.FindControl("txtAddHoogte")
        Dim updatepanel As UpdatePanel = Me.FindControl("updCategorie")
        Dim bool As New Boolean
        hoogte = Integer.Parse(textb.Text)
        catID = ddl.SelectedValue
        dt = categoriedal.getCategorieByID(catID)
        Dim dthoogte As New Data.DataTable
        dthoogte = categoriedal.getHoogte(catID)
        hoogte = dthoogte.Rows(0)("Hoogte")
        parent = CType(acc.FindControl("ddlAddParentCat"), DropDownList).SelectedValue
        If Integer.Parse(textb.Text) < hoogte + 1 Then
            categoriedal.updateHoogte(Integer.Parse(textb.Text), parent)
        End If
        'INSERT
        categorie.Bedrijf = ddlAddCatBedrijf.SelectedValue
        categorie.Versie = ddlAddCatVersie.SelectedValue
        categorie.Categorie = CType(acc.FindControl("txtAddCatNaam"), TextBox).Text
        categorie.Diepte = dt.Rows(0)("Diepte") + 1
        categorie.Hoogte = Integer.Parse(CType(acc.FindControl("txtAddHoogte"), TextBox).Text)
        categorie.FK_Parent = parent
        categorie.FK_Taal = CType(acc.FindControl("ddlAddCatTaal"), DropDownList).SelectedValue
        If (categoriedal.checkCategorie(categorie.Categorie, categorie.Bedrijf, categorie.Versie) Is Nothing) Then
            bool = adapterCat.Insert(categorie.Categorie, categorie.Diepte, categorie.Hoogte, categorie.FK_Parent, categorie.FK_Taal, categorie.Bedrijf, categorie.Versie)
            If bool = True Then
                lblResAdd.Text = "Gelukt"
            Else
                lblResAdd.Text = "Mislukt"
            End If
        Else
            lblResAdd.Text = "Deze categorie bestaat al voor deze versie of dit bedrijf."
        End If
        ddlCatVerwijder.DataBind()
        ddlEditCategorie.DataBind()
        ddlAddParentcat.DataBind()
        ddlEditCatParent.DataBind()

    End Sub

    Protected Sub btnCatEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatEdit.Click
        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")
        Dim updatepanel As UpdatePanel = Me.FindControl("updCategorie")
        categorie.CategorieID = CType(acc.FindControl("ddlEditCategorie"), DropDownList).SelectedValue
        categorie.Categorie = CType(acc.FindControl("txtCatBewerknaam"), TextBox).Text
        categorie.FK_Parent = CType(acc.FindControl("ddlEditCatParent"), DropDownList).SelectedValue
        Dim dt As New Data.DataTable
        dt = categoriedal.getCategorieByID(categorie.FK_Parent)
        categorie.Diepte = dt.Rows(0)("diepte") + 1
        categorie.FK_Taal = CType(acc.FindControl("ddlEditCatTaal"), DropDownList).SelectedValue
        categorie.Hoogte = CType(acc.FindControl("txtEditCatHoogte"), TextBox).Text
        categorie.Bedrijf = ddlEditCatBedrijf.SelectedValue
        categorie.Versie = ddlEditCatVersie.SelectedValue

        If (categoriedal.checkCategorieByID(categorie.Categorie, categorie.Bedrijf, categorie.Versie, categorie.CategorieID) Is Nothing) Then

            adapterCat.Update(categorie.Categorie, categorie.Diepte, categorie.Hoogte, categorie.FK_Parent, categorie.FK_Taal, categorie.Bedrijf, categorie.Versie, categorie.CategorieID)
        Else
            lblResEdit.Text = "Een ander categorie heeft reeds dezelfde versie of bedrijf."
        End If

        ddlCatVerwijder.DataBind()
        ddlEditCategorie.DataBind()
        ddlAddParentcat.DataBind()
        ddlEditCatParent.DataBind()
    End Sub

    Protected Sub ddlEditCategorie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")
        Dim updatepanel As UpdatePanel = Me.FindControl("updCategorie")
        Dim dt As New Data.DataTable
        Dim catID As Integer = CType(acc.FindControl("ddlEditCategorie"), DropDownList).SelectedValue
        dt = categoriedal.getCategorieByID(catID)
        CType(acc.FindControl("txtCatBewerknaam"), TextBox).Text = dt.Rows(0)("Categorie")
        CType(acc.FindControl("ddlEditCatTaal"), DropDownList).SelectedValue = dt.Rows(0)("FK_Taal")
        CType(acc.FindControl("ddlEditCatParent"), DropDownList).SelectedValue = dt.Rows(0)("FK_Parent")
        ddlEditCatBedrijf.SelectedValue = dt.Rows(0)("FK_Bedrijf")
        ddlEditCatVersie.SelectedValue = dt.Rows(0)("FK_Versie")
        Dim hoogte As Integer
        If (categoriedal.getHoogte(dt.Rows(0)("FK_Parent")) Is Nothing) Then
            hoogte = 0
        Else
            dt = categoriedal.getHoogte(dt.Rows(0)("FK_Parent"))
            hoogte = dt.Rows(0)("Hoogte")
        End If

        CType(acc.FindControl("txtEditCatHoogte"), TextBox).Text = hoogte
     

    End Sub

    Protected Sub ddlEditCatParent_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")
        Dim dt As New Data.DataTable
        Dim catID As Integer = CType(acc.FindControl("ddlEditCatParent"), DropDownList).SelectedValue
        'dt = categoriedal.getHoogte(catID)

        Dim hoogte As Integer
        If (categoriedal.getHoogte(catID) Is Nothing) Then
            hoogte = 0
        Else
            dt = categoriedal.getHoogte(catID)
            hoogte = dt.Rows(0)("Hoogte") + 1
        End If

        CType(acc.FindControl("txtEditCatHoogte"), TextBox).Text = hoogte
        
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCatDelete.Click
        Dim categorieID As Integer
        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")

        categorieID = CType(acc.FindControl("ddlCatVerwijder"), DropDownList).SelectedValue

        If (categoriedal.getArtikelsByParent(categorieID) Is Nothing) And (categoriedal.getCategorieByParent(categorieID) Is Nothing) Then
            If adapterCat.Delete(categorieID) = 0 Then
                lblResDelete.Text = "mislukt"
            Else
                lblResDelete.Text = "Verwijderen geslaagd!"
            End If
        Else
            lblResDelete.Text = "Er staan nog artikels of andere Categoriën onder deze Categorie."
        End If
        ddlCatVerwijder.DataBind()
        ddlEditCategorie.DataBind()
        ddlAddParentcat.DataBind()
        ddlEditCatParent.DataBind()
    End Sub

    
    Protected Sub btnAddVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddVersie.Click
        Dim acc As AjaxControlToolkit.Accordion = Me.updVersie.FindControl("Accordion3")
        Dim versie As String
        versie = CType(acc.FindControl("txtAddVersie"), TextBox).Text
        If (versiedal.CheckVersie(versie) Is Nothing) Then
            If adapterVersie.Insert(versie) = 0 Then
                lblAddVersieRes.Text = "mislukt."
            Else
                lblAddVersieRes.Text = "Toegvoegd."
            End If
        Else
            lblAddVersieRes.Text = "Deze versie Bestaat al."
        End If

        ddlBewerkVersie.DataBind()
        ddlDeletVersie.DataBind()
    End Sub

    Protected Sub btnEditVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditVersie.Click
        Dim acc As AjaxControlToolkit.Accordion = Me.updVersie.FindControl("Accordion3")
        Dim versie As String
        Dim versieID As Integer
        versie = CType(acc.FindControl("txtEditVersie"), TextBox).Text
        versieID = CType(acc.FindControl("ddlBewerkVersie"), DropDownList).SelectedValue
        If (versiedal.CheckVersieByID(versie, versieID) Is Nothing) Then
            If adapterVersie.Update(versie, versieID) = 0 Then
                lblEditVersieRes.Text = "mislukt"
            Else
                lblEditVersieRes.Text = "bewerkt"
            End If
        Else
            lblEditVersieRes.Text = "Een andere versie heeft deze naam al."
        End If

        ddlBewerkVersie.DataBind()
        ddlDeletVersie.DataBind()
    End Sub

    Protected Sub btnDeleteVersie_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteVersie.Click
        Dim acc As AjaxControlToolkit.Accordion = Me.updVersie.FindControl("Accordion3")
        Dim versieID As Integer
        If (artikeldal.getArtikelsByVersie(versieID) Is Nothing) Then
            If (adapterVersie.Delete(versieID) = 0) Then
                lblDeleteVersieRes.Text = "Mislukt"
            Else
                lblDeleteVersieRes.Text = "Gelukt"
            End If
        Else
            lblDeleteVersieRes.Text = "Deze versie heeft nog artikels onder zich."
        End If
        ddlBewerkVersie.DataBind()
        ddlDeletVersie.DataBind()
    End Sub

    Protected Sub btnAddTaal_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTaal.Click
        Dim acc As AjaxControlToolkit.Accordion = Me.updTaal.FindControl("Accordion2")
        Dim taal As String
        taal = CType(acc.FindControl("txtAddTaal"), TextBox).Text
        If (taaldal.checkTaal(taal) Is Nothing) Then
            If (adapterTaal.Insert(taal) = 0) Then
                lblAddTaalRes.Text = "mislukt"
            Else
                lblAddTaalRes.Text = "Gelukt"
            End If
        Else
            lblAddTaalRes.Text = "Deze taal is al toegvoegd."
        End If

        ddlBewerkTaal.DataBind()
        ddlTaalDelete.DataBind()
    End Sub

    Protected Sub btnEditTaal_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditTaal.Click
        Dim acc As AjaxControlToolkit.Accordion = Me.updTaal.FindControl("Accordion2")
        Dim taal As String
        Dim taalID As String
        taalID = CType(acc.FindControl("ddlBewerkTaal"), DropDownList).SelectedValue
        taal = CType(acc.FindControl("txtEditTaal"), TextBox).Text
        If (taaldal.checkTaalByID(taal, taalID) Is Nothing) Then
            If (adapterTaal.Update(taal, taalID) = 0) Then
                lblEditTaalRes.Text = "mislukt"
            Else
                lblEditTaalRes.Text = "Gelukt"
            End If
        Else
            lblEditTaalRes.Text = "Een andere taal heeft deze naam al."
        End If

        ddlBewerkTaal.DataBind()
        ddlTaalDelete.DataBind()
    End Sub

    Protected Sub btnTaalDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTaalDelete.Click
        Dim acc As AjaxControlToolkit.Accordion = Me.updTaal.FindControl("Accordion2")
        Dim taalID As Integer
        taalID = CType(acc.FindControl("ddlTaalDelete"), DropDownList).SelectedValue
        If (artikeldal.getArtikelsByTaal(taalID) Is Nothing) Then
            If (adapterTaal.Delete(taalID) = 0) Then
                lblDeleteTaalRes.Text = "mislukt"
            Else
                lblDeleteTaalRes.Text = "Gelukt"
            End If
        Else
            lblDeleteTaalRes.Text = "Er zijn nog Artikels met deze Taal."
        End If
        ddlBewerkTaal.DataBind()
        ddlTaalDelete.DataBind()
    End Sub


    Protected Sub btnAddBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddBedrijf.Click
        Dim acc As AjaxControlToolkit.Accordion = Me.updBedrijf.FindControl("Accordion1")
        Dim bedrijf As String
        Dim bedrijfTag As String

        bedrijfTag = CType(acc.FindControl("txtAddTag"), TextBox).Text
        bedrijf = CType(acc.FindControl("txtAddBedrijf"), TextBox).Text
        If (bedrijfdal.getBedrijfByNaamOrTag(bedrijf, bedrijfTag) Is Nothing) Then
            If (adapterBedrijf.Insert(bedrijf, bedrijfTag) = 0) Then
                lblAddBedrijfRes.Text = "mislukt"
            Else
                lblAddBedrijfRes.Text = "Gelukt"
            End If
        Else
            lblAddBedrijfRes.Text = "Dit bedrijf bestaat al, of een ander bedrijf heeft reeds dezelfde Tag."
        End If
        ddlBewerkBedrijf.DataBind()
        ddlDeleteBedrijf.DataBind()
    End Sub

    Protected Sub btnEditBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditBedrijf.Click
        Dim acc As AjaxControlToolkit.Accordion = Me.updBedrijf.FindControl("Accordion1")
        Dim bedrijf As String
        Dim bedrijfTag As String
        Dim bedrijfID As Integer
        bedrijfID = CType(acc.FindControl("ddlBewerkBedrijf"), DropDownList).SelectedValue
        bedrijfTag = CType(acc.FindControl("txtEditTag"), TextBox).Text
        bedrijf = CType(acc.FindControl("txtEditBedrijf"), TextBox).Text

        If (bedrijfdal.getBedrijfByNaamTagID(bedrijf, bedrijfTag, bedrijfID) Is Nothing) Then
            If (adapterBedrijf.Update(bedrijf, bedrijfTag, bedrijfID) = 0) Then
                lblEditbedrijfRes.Text = "mislukt"
            Else
                lblEditbedrijfRes.Text = "Gelukt"
            End If
        Else
            lblEditbedrijfRes.Text = "Een ander bedrijf heeft reeds deze Bedrijfsnaam of Tag."
        End If

        ddlBewerkBedrijf.DataBind()
        ddlDeleteBedrijf.DataBind()
    End Sub

    Protected Sub btnDeleteBedrijf_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteBedrijf.Click
        Dim acc As AjaxControlToolkit.Accordion = Me.updBedrijf.FindControl("Accordion1")
        Dim bedrijfID As Integer
        bedrijfID = CType(acc.FindControl("ddlDeleteBedrijf"), DropDownList).SelectedValue
        If (artikeldal.getArtikelsByBedrijf(bedrijfID) Is Nothing) Then
            If (adapterBedrijf.Delete(bedrijfID) = 0) Then
                lblDeleteBedrijfRes.Text = "mislukt"
            Else
                lblDeleteBedrijfRes.Text = "Gelukt"
            End If
        Else
            lblDeleteBedrijfRes.Text = "Er zijn nog Artikels voor dit Bedrijf."
        End If
        ddlBewerkBedrijf.DataBind()
        ddlDeleteBedrijf.DataBind()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim dt As Data.DataTable
        dt = categoriedal.getCategorieZonderRoot
        Dim dr As Data.DataRow = dt.NewRow
        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")
        Dim ddl0 As DropDownList = acc.FindControl("ddlEditCategorie")
        Dim ddl1 As DropDownList = acc.FindControl("ddlCatVerwijder")
        For Each dr In dt.Rows
            Dim listitem As New ListItem(dr("Categorie"), dr("CategorieID"))
            ddl0.Items.Add(listitem)
            ddl1.Items.Add(listitem)
        Next
    End Sub

    Protected Sub ddlBewerkVersie_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        txtEditVersie.Text = ddlBewerkVersie.SelectedItem.Text
    End Sub

    Protected Sub ddlBewerkTaal_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        txtEditTaal.Text = ddlBewerkTaal.SelectedItem.Text
    End Sub

    Protected Sub ddlBewerkBedrijf_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        txtEditBedrijf.Text = ddlBewerkBedrijf.SelectedItem.Text
        Dim dr As Manual.tblBedrijfRow
        dr = bedrijfdal.GetBedrijfByID(ddlBewerkBedrijf.SelectedValue)
        txtEditTag.Text = dr("Tag")
    End Sub

    Protected Sub ddlAddParentcat_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAddParentcat.DataBound
        Dim hoogte As Integer
        Dim catID As Integer

        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")
        Dim ddl As DropDownList = acc.FindControl("ddlAddParentCat")

        Dim updatepanel As UpdatePanel = Me.FindControl("updCategorie")


        catID = ddl.SelectedValue
        Dim dt As New Data.DataTable

        If (categoriedal.getHoogte(catID) Is Nothing) Then
            hoogte = 0
            CType(acc.FindControl("txtAddhoogte"), TextBox).Text = hoogte
        Else
            dt = categoriedal.getHoogte(catID)
            hoogte = dt.Rows(0)("Hoogte")
            CType(acc.FindControl("txtAddhoogte"), TextBox).Text = hoogte + 1
        End If
    End Sub

    Protected Sub ddlEditCatParent_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEditCatParent.DataBound
        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")
        Dim updatepanel As UpdatePanel = Me.FindControl("updCategorie")
        Dim dt As New Data.DataTable
        Dim catID As Integer = CType(acc.FindControl("ddlEditCategorie"), DropDownList).SelectedValue
        dt = categoriedal.getCategorieByID(catID)
        CType(acc.FindControl("txtCatBewerknaam"), TextBox).Text = dt.Rows(0)("Categorie")
        CType(acc.FindControl("ddlEditCatTaal"), DropDownList).SelectedValue = dt.Rows(0)("FK_Taal")
        CType(acc.FindControl("ddlEditCatParent"), DropDownList).SelectedValue = dt.Rows(0)("FK_Parent")
        ddlEditCatBedrijf.SelectedValue = dt.Rows(0)("FK_Bedrijf")
        ddlEditCatVersie.SelectedValue = dt.Rows(0)("FK_Versie")
        Dim hoogte As Integer
        If (categoriedal.getHoogte(dt.Rows(0)("FK_Parent")) Is Nothing) Then
            hoogte = 0
        Else
            dt = categoriedal.getHoogte(dt.Rows(0)("FK_Parent"))
            hoogte = dt.Rows(0)("Hoogte")
        End If

        CType(acc.FindControl("txtEditCatHoogte"), TextBox).Text = hoogte

    End Sub

    Protected Sub ddlBewerkBedrijf_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBewerkBedrijf.DataBound
        txtEditBedrijf.Text = ddlBewerkBedrijf.SelectedItem.Text
        Dim dr As Manual.tblBedrijfRow
        dr = bedrijfdal.GetBedrijfByID(ddlBewerkBedrijf.SelectedValue)
        txtEditTag.Text = dr("Tag")
    End Sub


    Protected Sub ddlBewerkTaal_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBewerkTaal.DataBound
        txtEditTaal.Text = ddlBewerkTaal.SelectedItem.Text
    End Sub


    Protected Sub ddlBewerkVersie_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBewerkVersie.DataBound
        txtEditVersie.Text = ddlBewerkVersie.SelectedItem.Text
    End Sub
End Class
