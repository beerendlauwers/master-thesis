Imports Manual

Partial Class App_Presentation_AlleArtikels
    Inherits System.Web.UI.Page
    Private versiedal As New VersieDAL
    Private bedrijfdal As New BedrijfDAL
    Private taaldal As New TaalDAL
    Dim artikeldal As New ArtikelDAL

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.Title = "Alle Artikels"

        Util.CheckOfBeheerder(Page.Request.Url.AbsolutePath)

        If Not IsPostBack Then
            ddlBedrijf.Items.Add(New ListItem(("Alle Bedrijven"), ("%%")))
            Util.LeesBedrijven(ddlBedrijf, False, True)

            ddlVersie.Items.Add(New ListItem(("Alle Versies"), ("%%")))
            Util.LeesVersies(ddlVersie, False, True)

            ddlTaal.Items.Add(New ListItem(("Alle Talen"), ("%%")))
            Util.LeesTalen(ddlTaal, False, True)

            lblFinaal.Text = "1"
            CheckBox1.Checked = True
        End If

        JavaScript.ShadowBoxLaderTonenBijElkePostback(Me)
        'JavaScript.ZetButtonOpDisabledOnClick(btnFilter, "Filteren...", True)
    End Sub

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click
        If CheckBox1.Checked = True Then
            lblFinaal.Text = "1"
        Else
            lblFinaal.Text = "0"
        End If
        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub

    Protected Sub grdArtikels_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdArtikels.RowCommand
        Dim str As String = e.CommandName
        If str = "Page" Or str = "Sort" Then
        Else
            Dim count As Integer = grdartikels.rows.count
            Dim row As GridViewRow = grdArtikels.Rows(e.CommandArgument)
            If e.CommandName = "Select" Then

                Dim tag As String = row.Cells(1).Text
                Dim qst As String = "~/App_Presentation/page.aspx?tag=" + tag
                Response.Redirect(qst)
            End If
            If e.CommandName = "Delete" Then
                Dim tag As String = row.Cells(1).Text
                Dim qst As String = "~/App_Presentation/ArtikelVerwijderen.aspx?tag=" + tag
                Response.Redirect(qst)
            End If
            If e.CommandName = "Edit" Then
                Dim tag As String = row.Cells(1).Text
                Dim qst As String = "~/App_Presentation/ArtikelBewerken.aspx?tag=" + tag
                Response.Redirect(qst)
            End If
        End If
        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub

    Protected Sub grdArtikels_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdArtikels.RowDataBound
        If e.Row.Cells.Count = 1 Then
            Return
        Else
            e.Row.Cells(1).Visible = False
            If e.Row.Cells(0).Text = "" Then Return
            Dim titel As String = e.Row.Cells(0).Text
            e.Row.Cells(0).Text = Server.HtmlDecode(titel)
        End If
    End Sub
End Class
