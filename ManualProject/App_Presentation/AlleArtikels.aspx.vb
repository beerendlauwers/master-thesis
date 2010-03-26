
Partial Class App_Presentation_AlleArtikels
    Inherits System.Web.UI.Page
    Private versiedal As New VersieDAL
    Private bedrijfdal As New BedrijfDAL
    Private taaldal As New TaalDAL

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim dttaal As Manual.tblTaalDataTable
        Dim dtbedrijf As Manual.tblBedrijfDataTable
        Dim dtversie As Manual.tblVersieDataTable
        dttaal = taaldal.GetAllTaal
        dtbedrijf = bedrijfdal.GetAllBedrijf
        dtversie = versiedal.GetAllVersie
        If Not IsPostBack Then
            Dim listitem0 As New ListItem(("Alle Bedrijven"), ("%%"))
            ddlBedrijf.Items.Add(listitem0)
            For i As Integer = 0 To dtbedrijf.Rows.Count - 1
                Dim listitems As New ListItem(dtbedrijf.Rows(i)("naam"), dtbedrijf.Rows(i)("naam"))
                ddlBedrijf.Items.Add(listitems)
            Next

            Dim listitem1 As New ListItem(("Alle Versies"), ("%%"))
            ddlVersie.Items.Add(listitem1)
            For i As Integer = 0 To dtversie.Rows.Count - 1
                Dim listitems As New ListItem(dtversie.Rows(i)("Versie"), dtversie.Rows(i)("versie"))
                ddlVersie.Items.Add(listitems)
            Next

            Dim listitem2 As New ListItem(("Alle Talen"), ("%%"))
            ddlTaal.Items.Add(listitem2)
            For i As Integer = 0 To dttaal.Rows.Count - 1
                Dim listitems As New ListItem(dttaal.Rows(i)("taal"), dttaal.Rows(i)("taal"))
                ddlTaal.Items.Add(listitems)
            Next
        End If
    End Sub

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click

    End Sub
End Class
