
Partial Class App_Presentation_OverzichtPerTaal
    Inherits System.Web.UI.Page
    Private taaldal As New TaalDAL

    Protected Sub btnVergelijk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVergelijk.Click
        Session("sortexpression") = Nothing

    End Sub
    ''' <summary>
    ''' gaat een string opbouwen dat dient als sqlcommando op basis van de selecties op de pagina, 
    ''' maw voor elke aangevinkte taal gaat hij de kolom in tblVglTaal opvragen
    ''' dit is de filtered functie dus gaan enkel de rijen opgehaald worden waar een nul instaat, voor de geselecteerde talen.
    ''' </summary>
    ''' <returns>string dat wordt gebruikt als sql-commando</returns>
    ''' <remarks></remarks>
    Public Function getsqlTextfiltered() As String
        Dim voorlabel As String = "x,x,"
        Dim sqltextselect As String = "SELECT dbo.getTitelMetTag(tag)Titel,Tag"
        Dim sqltextwhere As String = "WHERE ("
        Dim sqltext As String
        For Each row As GridViewRow In GridView1.Rows
            Dim cb As CheckBox = row.FindControl("chkTaal")
            If cb.Checked = True Then
                Dim tekst As String = Server.HtmlDecode(row.Cells(0).Text)
                sqltextselect = sqltextselect + "," + tekst
                sqltextwhere = sqltextwhere + tekst + "=0" + " OR "
                voorlabel = voorlabel + tekst + ","
            End If
        Next

        sqltextwhere = sqltextwhere.Remove(sqltextwhere.Length - 3)
        sqltextwhere = sqltextwhere + ") AND VersieID=" + ddlVersie.SelectedValue + " and bedrijfID=" + ddlBedrijf.SelectedValue + ""
        sqltext = sqltextselect + " FROM tblVglTaal " + sqltextwhere
        voorlabel = voorlabel.Remove(voorlabel.Length - 1)
        lblHiddenTalen.Text = voorlabel
        Return sqltext

    End Function
    ''' <summary>
    ''' gaat een string opbouwen dat dient als sqlcommando op basis van de selecties op de pagina, 
    ''' maw voor elke aangevinkte taal gaat hij de kolom in tblVglTaal opvragen
    ''' dit is de unfiltered functie dus gaan alle rijen opgehaald worden voor de geselecteerde talen.
    ''' </summary>
    ''' <returns>string die wordt gebruikt als sql-commando</returns>
    ''' <remarks></remarks>
    Public Function getsqlunfiltered() As String
        Dim voorlabel As String = "x,x,"
        Dim sqltextselect As String = "SELECT dbo.getTitelMetTag(tag) Titel,Tag"
        Dim sqltextwhere As String = "Where VersieID=" + ddlVersie.SelectedValue + " and bedrijfID=" + ddlBedrijf.SelectedValue + ""
        Dim sqltext As String
        For Each row As GridViewRow In GridView1.Rows
            Dim cb As CheckBox = row.FindControl("chkTaal")
            If cb.Checked = True Then
                Dim tekst As String = Server.HtmlDecode(row.Cells(0).Text)
                sqltextselect = sqltextselect + "," + tekst
                voorlabel = voorlabel + tekst + ","
            End If
        Next
        sqltext = sqltextselect + " FROM tblVglTaal"
        sqltext = sqltext + " " + sqltextwhere
        voorlabel = voorlabel.Remove(voorlabel.Length - 1)
        lblHiddenTalen.Text = voorlabel
        Return sqltext

    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.Title = "Overzicht Per Taal"
        Try

        
            Util.CheckOfBeheerder(Page.Request.Url.AbsolutePath)
            If Not IsPostBack Then
                For i As Integer = 0 To GridView1.Rows.Count - 1
                    Dim r As GridViewRow = GridView1.Rows(i)
                    Dim str As String = r.Cells(0).Text
                    If r.Cells(0).Text = "Nederlands" Or r.Cells(0).Text = "fran&#231;ais" Then
                        Dim cb As CheckBox = r.FindControl("chkTaal")
                        cb.Checked = True
                    End If
                Next
            End If
            If Not IsPostBack Then
                ddlBedrijf.DataBind()
                ddlVersie.DataBind()
            End If
            Dim sqltext As String
            If ckbOntbreek.Checked Then
                sqltext = getsqlTextfiltered()
            Else
                sqltext = getsqlunfiltered()
            End If
            Dim dt As Data.DataTable
            dt = taaldal.getVglTalen(sqltext)
            GridView3.DataSource = dt

            Dim control As String = Page.Request.Params.Get("__EVENTTARGET")

            If control IsNot Nothing And Not control = String.Empty Then
                GridView3.DataBind()
                If TryCast(Page.FindControl(control), LinkButton) IsNot Nothing Then
                    Dim ctl As LinkButton = Page.FindControl(control)
                    GridView3.PageIndex = Integer.Parse(ctl.Text) - 1
                End If
            End If

            GridView3.DataBind()
            JavaScript.ShadowBoxLaderTonenBijElkePostback(Me)
        Catch ex As Exception
            ErrorLogger.WriteError(New ErrorLogger(ex.Message))

        End Try
    End Sub

    Protected Sub GridView3_DataBinding(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView3.DataBinding
        Dim str(100) As String
        For i As Integer = 1 To Page.Request.Form.Count - 1
            str(i) = Page.Request.Form(i)
        Next
        For i As Integer = 0 To str.Length - 1
            Dim strsplit() As String = Split(str(i), "$")
            If strsplit.Length > 3 Then
                Dim strcheck() As String = Split(strsplit(4), "_")
                If strcheck(0) = "lbnPaginaNummering" Or strcheck(0) = "ctl00$ContentPlaceHolder1$GridView3$ctl16$lbnPaginaNummering" Then
                    sorteer()
                    Return
                End If
            End If
        Next
    End Sub
    Protected Sub GridView3_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles GridView3.DataBound
        Dim r As GridViewRow = GridView3.BottomPagerRow

        Dim i As Integer = GridView3.PageIndex
        If r IsNot Nothing Then
            Dim d As Integer = GridView3.Rows.Count
            If GridView3.PageCount > 0 Then
                For index As Integer = 0 To GridView3.PageCount - 1
                    Dim ctl As WebControl = Nothing

                    If index = GridView3.PageIndex Then
                        Dim label As New Label
                        label.Text = index + 1
                        label.CssClass = "gridview_bignumber"
                        label.ID = String.Concat("lblPaginaNummering_", label.Text)
                        ctl = label
                    Else
                        Dim linkbutton As New LinkButton()
                        linkbutton.Text = index + 1
                        linkbutton.ID = String.Concat("lbnPaginaNummering_", linkbutton.Text)
                        ctl = linkbutton
                    End If

                    r.Cells(0).Controls.Add(ctl)
                Next index
            End If
        End If

        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub

    Protected Sub GridView3_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles GridView3.PageIndexChanging
        Dim dt As Data.DataTable
        Dim sqltext As String
        If ckbOntbreek.Checked Then
            sqltext = getsqlTextfiltered()
        Else
            sqltext = getsqlunfiltered()
        End If
        dt = taaldal.getVglTalen(sqltext)
        GridView3.DataSource = dt
        GridView3.PageIndex = e.NewPageIndex
        GridView3.DataBind()
        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub

    Protected Sub GridView3_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GridView3.RowCommand
        Dim str As String = e.CommandName
        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub

    Protected Sub GridView3_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView3.RowDataBound
        Dim label As String = lblHiddenTalen.Text
        Dim talen() As String = label.Split(",")
        Dim versie As Integer = ddlVersie.SelectedValue
        Dim bedrijf As Integer = ddlBedrijf.SelectedValue
        GridView3.Visible = True
        'gaat voor elke cell in die row kijken of die cell waarde 1 of 0 is,
        'bij 0 gaat hij kruisje zetten en linken naar artikelToevoegen om dat ontbrekende artikel aan te kunnen maken
        'kruisjes doen niks.

        For i As Integer = 0 To e.Row.Cells.Count - 1
            If e.Row.Cells(i).Visible = True Then
                Dim img As New ImageButton
                If e.Row.Cells(i).Text = "1" Then
                    img.ImageUrl = "~/App_Presentation/CSS/images/tick.gif"
                    img.OnClientClick = "return false;"
                    img.Enabled = True
                    e.Row.Cells(i).Controls.Add(img)
                ElseIf e.Row.Cells(i).Text = "0" Then
                    Dim tag As String = e.Row.Cells(1).Text
                    Dim splittag() As String = tag.Split("_")
                    img.ImageUrl = "~/App_Presentation/CSS/images/remove.png"
                    img.PostBackUrl = "~/App_Presentation/ArtikelToevoegen.aspx?tag=" + splittag(1) + "&taal=" + HttpUtility.UrlEncode(talen(i)) + "&versie=" + versie.ToString + "&bedrijf=" + bedrijf.ToString + "&module=" + splittag(0)
                    e.Row.Cells(i).Controls.Add(img)
                End If
            End If
        Next

    End Sub

    Protected Sub GridView3_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs)

        Dim dt As Data.DataTable
        Dim sqltext As String
        If ckbOntbreek.Checked Then
            sqltext = getsqlTextfiltered()
        Else
            sqltext = getsqlunfiltered()
        End If
        dt = taaldal.getVglTalen(sqltext)
        Dim datv As New Data.DataView(dt)
        Dim richting As String = ConvertSortDirectionToSql(e.SortDirection).ToString
        datv.Sort() = e.SortExpression + richting
        GridView3.DataSource = datv
        Session("sortexpression") = e.SortExpression.ToString + "_" + richting
        GridView3.DataBind()
        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub
    ''' <summary>
    ''' hier worden de sorteer-richtingen geälterneerd, 
    ''' dus elke keer er op een kolomnaam geklikt wordt verwacht de gebruiker dat de sorteerrichting wijzigt
    ''' dit wordt gerealiseerd door sessions 
    ''' elke keer als er geklikt wordt verandert de session en daarmee de sorteerrichting die dan wordt gebruikt in de gridview3_sorting
    ''' </summary>
    ''' <param name="sortDirection"></param>
    ''' <returns>sorteer-richting</returns>
    ''' <remarks>het kan dus zijn dat als de admin de overzichts-pagina verlaat,
    '''  de session onthoude wordt en als hij terugkomt de sorteer-richting nog altijd onthouden is,
    '''  maar dit kan geen kwaad want een klik op de kolom-header wijzigt de richting weer naar wens
    ''' </remarks>
    Public Function ConvertSortDirectionToSql(ByVal sortDirection As SortDirection) As String
        Dim newsortdirection As String
        Dim str As String = Session("sort")
        If Session("sort") Is Nothing Then
            Session("sort") = "0"
            newsortdirection = " ASC"
        Else
            If Session("sort") = "0" Then
                newsortdirection = " DESC"
                Session("sort") = "1"
            Else
                newsortdirection = " ASC"
                Session("sort") = "0"
            End If
        End If
        Return newsortdirection
    End Function
    ''' <summary>
    ''' een apparte sorteerfunctie om de gridview te sorteren,
    ''' omdat de gridview zijn sorting verliest als de gebruiker bijvoorbeeld op een paginanummer klikt.
    ''' dan wordt deze sorteerfunctie aangeroepen om de data terug te sorteren zodat de gebruiker nog steeds de weergave krijgt die hij verwachtte
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub sorteer()
        Dim sortstring As String
        sortstring = Session("sortexpression")
        If sortstring IsNot Nothing Then
            If sortstring.Length > 4 Then
                Dim sort() As String = Split(sortstring, "_")
                Dim dt As Data.DataTable
                Dim sqltext As String
                If ckbOntbreek.Checked Then
                    sqltext = getsqlTextfiltered()
                Else
                    sqltext = getsqlunfiltered()
                End If
                dt = taaldal.getVglTalen(sqltext)
                Dim datv As New Data.DataView(dt)
                datv.Sort() = sort(0) + sort(1)
                GridView3.DataSource = datv
            End If
        End If
    End Sub
End Class


