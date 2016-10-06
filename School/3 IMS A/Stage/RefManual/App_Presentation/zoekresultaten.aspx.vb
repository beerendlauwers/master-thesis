
Partial Class App_Presentation_zoekresultaten
    Inherits System.Web.UI.Page
    Dim artikeldal As New ArtikelDAL
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            GenereerGelokaliseerdeTekst()

            If Not IsPostBack Then
                ' Dim zoekterm As String = Page.Request.Form("ctl00$txtZoek")
                Dim zoekterm As String = Page.Request.QueryString("term")
                If zoekterm IsNot Nothing Then
                    zoekterm = zoekterm.Trim

                End If
            End If

            If Page.Request.QueryString("term") IsNot Nothing Then
                Dim zoekterm As String = Page.Request.QueryString("term")
                If zoekterm IsNot Nothing Then
                    zoekterm = zoekterm.Trim
                    If Not zoekterm = "%%" Then

                        JavaScript.ShadowBoxLaderSluiten(Me)
                    End If
                End If
            End If

            If Util.LeesPaginaNummer(Me, grdResultaten) Then
                grdResultaten.DataBind()
                JavaScript.ShadowBoxLaderSluiten(Me)
            End If

            If grdResultaten.Rows.Count > 0 Then lblSort.Visible = True

            If Page.Request.QueryString("term") IsNot Nothing Then
                Page.Title = String.Concat("Zoekresultaten voor de term '", Page.Request.QueryString("term"), "'")
            End If

            JavaScript.ShadowBoxLaderTonenBijElkePostback(Me)
        Catch ex As Exception
            Dim err As New ErrorLogger(ex.Message)
            ErrorLogger.WriteError(err)
        End Try
        
    End Sub

    Protected Sub grdResultaten_DataBinding(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdResultaten.DataBinding
        Try
            GenereerGelokaliseerdeTekst()
        Catch ex As Exception
            Dim err As New ErrorLogger(ex.Message)
            ErrorLogger.WriteError(err)
        End Try
    End Sub

    Protected Sub grdResultaten_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdResultaten.DataBound
        Try
            Util.LaadPaginering(grdResultaten)
        Catch ex As Exception
            Dim err As New ErrorLogger(ex.Message)
            ErrorLogger.WriteError(err)
        End Try
    End Sub

    Protected Sub grdResultaten_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdResultaten.RowCommand
        If e.CommandName = "Select" Then
            Dim row As GridViewRow = grdResultaten.Rows(e.CommandArgument)
            Dim tag As String = row.Cells(1).Text
            Dim qst As String = "~/App_Presentation/page.aspx?tag=" + tag
            Response.Redirect(qst, False)
        End If

        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub

    Protected Sub grdResultaten_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdResultaten.RowDataBound
        Dim titel As String = e.Row.Cells(0).Text
        If titel = "" And e.Row.Cells.Count > 2 Then
            e.Row.Cells(1).Visible = False
        Else
            Server.HtmlEncode(titel)
            e.Row.Cells(0).Text = Server.HtmlDecode(titel)
        End If

        If e.Row.Cells.Count > 2 Then
            If e.Row.Cells(1).Text = "Tag" Or e.Row.Cells(1).Text = "" Then
            Else
                Dim zoekterm As String = Page.Request.QueryString("term")
                Dim artikelTag As String = e.Row.Cells(1).Text

                e.Row.Cells(2).Text = artikeldal.getArtikelTekst(zoekterm, artikelTag)
                Dim tekst As String = e.Row.Cells(2).Text
                Dim tekster As String = Regex.Replace(tekst, "<!--[^.]*", "")
                Dim teksta As String = Regex.Replace(tekster, "<[^>]*>", "")
                Dim tekst1 As String = Regex.Replace(teksta, "<[^>]*", "")
                Dim tekst2 As String = Regex.Replace(tekst1, "<\[^>]*>", "")
                Dim tekstb As String = Regex.Replace(tekst2, "<\[^>]*", "")
                Dim tekstaa As String = Regex.Replace(tekstb, "[^>]*>", "")
                Dim tekst3 As String = Regex.Replace(tekstaa, "[</]", "")
                Dim tekst4 As String = Regex.Replace(tekst3, "[>]", "")
                If tekst4.Length >= 150 Then
                    e.Row.Cells(2).Text = tekst4 + "..."
                Else
                    e.Row.Cells(2).Text = "..." + tekst4 + "..."
                End If
            End If
            e.Row.Cells(1).Visible = False
           
        End If

    End Sub

    Private Sub GenereerGelokaliseerdeTekst()
        Master.CheckVoorTaalWijziging()
        lblZoekResultatenTitel.Text = Lokalisatie.GetString("ZOEKRESULTATEN")
        Page.Title = Lokalisatie.GetString("ZOEKRESULTATEN")
        headerArtikels.InnerHtml = Lokalisatie.GetString("ZOEKEN_GEVONDENARTIKELS")
        lblSort.Text = Lokalisatie.GetString("ZOEKEN_UITLEGKOLOMMEN")
        grdResultaten.EmptyDataText = Lokalisatie.GetString("GEENDATAGEVONDEN")
        For Each d As DataControlField In grdResultaten.Columns
            If d.SortExpression = "titel" Then d.HeaderText = Lokalisatie.GetString("ZOEKEN_TITEL")
            If d.SortExpression = "tag" Then d.HeaderText = Lokalisatie.GetString("ZOEKEN_TAG")
            If d.SortExpression = "Tekst" Then d.HeaderText = Lokalisatie.GetString("ZOEKEN_TEKST")
        Next
    End Sub
End Class
