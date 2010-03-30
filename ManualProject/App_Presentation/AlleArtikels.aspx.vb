
Partial Class App_Presentation_AlleArtikels
    Inherits System.Web.UI.Page
    Private versiedal As New VersieDAL
    Private bedrijfdal As New BedrijfDAL
    Private taaldal As New TaalDAL
    Dim artikeldal As New ArtikelDAL

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
        If Not IsPostBack Then
            lblFinaal.Text = "1"
            CheckBox1.Checked = True
        End If

        If Session("login") = 1 Then

            divLoggedIn.Visible = True
        Else
            divLoggedIn.Visible = False
            lblLogin.Visible = True
            lblLogin.Text = "U bent niet ingelogd."
            ImageButton1.Visible = True
        End If
    End Sub

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click
        If CheckBox1.Checked = True Then
            lblFinaal.Text = "1"
        Else
            lblFinaal.Text = "0"
        End If
    End Sub


    Protected Sub GridView1_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GridView1.RowCommand
        
        If e.CommandName = "Select" Then
            Dim row As GridViewRow = GridView1.Rows(e.CommandArgument)
            Dim tag As String = row.Cells(1).Text
            Dim qst As String = "~/App_Presentation/page.aspx?tag=" + tag
            Response.Redirect(qst)
        End If
    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        If e.Row.Cells.Count > 4 Then
            e.Row.Cells(1).Visible = False
        End If
    End Sub

    Protected Sub ImageButton1_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton1.Click
        Response.Redirect("Aanmeldpagina.aspx")
    End Sub
End Class
