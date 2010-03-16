
Partial Class App_Presentation_Beheer
    Inherits System.Web.UI.Page

    Dim categoriedal As New CategorieDAL
    Dim adapter As new ManualTableAdapters.tblCategorieTableAdapter
    Dim categorie As New Categorie
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")
        Dim ddl0 As DropDownList = acc.FindControl("ddlEditCategorie")
        Dim ddl1 As DropDownList = acc.FindControl("ddlCatVerwijder")
        ddl0.Items.Remove("root_node")
        ddl1.Items.Remove("root_node")
    End Sub




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
        categorie.Categorie = CType(acc.FindControl("txtAddCatNaam"), TextBox).Text
        categorie.Diepte = dt.Rows(0)("Diepte") + 1
        categorie.Hoogte = Integer.Parse(CType(acc.FindControl("txtAddHoogte"), TextBox).Text)
        categorie.FK_Parent = parent
        categorie.FK_Taal = CType(acc.FindControl("ddlAddCatTaal"), DropDownList).SelectedValue
        bool = adapter.Insert(categorie.Categorie, categorie.Diepte, categorie.Hoogte, categorie.FK_Parent, categorie.FK_Taal)


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



        adapter.Update(categorie.Categorie, categorie.Diepte, categorie.Hoogte, categorie.FK_Parent, categorie.FK_Taal, categorie.CategorieID)

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

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        Dim categorieID As Integer
        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")

        categorieID = CType(acc.FindControl("ddlCatVerwijder"), DropDownList).SelectedValue

        If adapter.Delete(categorieID) = 0 Then
            lblResDelete.Text = "mislukt"
        Else
            lblResDelete.Text = "Verwijderen geslaagd!"
        End If

    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        Dim acc As AjaxControlToolkit.Accordion = Me.updCategorie.FindControl("Accordion4")
        Dim ddl0 As DropDownList = acc.FindControl("ddlEditCategorie")
        Dim ddl1 As DropDownList = acc.FindControl("ddlCatVerwijder")
        ddl0.Items.Remove("root_node")
        ddl1.Items.Remove("root_node")
    End Sub
End Class
