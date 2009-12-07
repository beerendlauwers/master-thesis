
Partial Class App_Presentation_Webpaginas_Beheer_AutoBeheer
    Inherits System.Web.UI.Page
    Private bllauto As New AutoBLL
    Private bllmerk As New MerkBLL
    Private bllbrandstof As New BrandstofBLL


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            Dim dtJaar As Data.DataTable = bllauto.getdistinctBouwjaar
            Dim dtKleur As Data.DataTable = bllauto.getdistinctKleur
            Dim dtMerk As Autos.tblMerkDataTable = bllmerk.GetAllMerken
            Dim dtBrandstof As Autos.tblBrandstofDataTable = bllbrandstof.GetAllBrandstofTypes

            ddlBouwjaar.Items.Add(New ListItem(("Filter bouwjaar"), ("%%")))
            For i As Integer = 0 To dtJaar.Rows.Count - 1
                ddlBouwjaar.Items.Add(dtJaar.Rows(i)("AutoBouwjaar"))
            Next

            ddlKleur.Items.Add(New ListItem(("Filter kleur"), ("%%")))
            For i As Integer = 0 To dtKleur.Rows.Count - 1
                ddlKleur.Items.Add(dtKleur.Rows(i)("autoKleur"))
            Next

            ddlMerk.Items.Add(New ListItem(("Filter merk"), ("%%")))
            For i As Integer = 0 To dtMerk.Rows.Count - 1
                ddlMerk.Items.Add(dtMerk.Rows(i)("merkNaam"))
            Next

            ddlBrandstof.Items.Add(New ListItem(("filter Brandstof"), ("%%")))
            For i As Integer = 0 To dtBrandstof.Rows.Count - 1
                ddlBrandstof.Items.Add(dtBrandstof.Rows(i)("brandstofNaam"))
            Next


        End If
    End Sub


End Class
