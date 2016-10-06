Imports Microsoft.VisualBasic
Imports System.Web.HttpContext

''' <summary>
''' Een klasse met verschillende functies die in verschillende pagina's worden gebruikt
''' </summary>
Public Class Util

    ''' <summary>
    ''' Wijzigt de gegeven controls naar een "mislukt" design.
    ''' </summary>
    ''' <param name="tekst">De tekst die het feedbacklabel zal weergeven.</param>
    ''' <param name="lbl">Het feedbacklabel.</param>
    ''' <param name="img">De imagecontrol.</param>
    Public Shared Sub SetError(ByVal tekst As String, ByRef lbl As Label, ByRef img As Image)
        lbl.Text = tekst
        lbl.ForeColor = System.Drawing.ColorTranslator.FromHtml("#E3401E")
        img.ImageUrl = "~\App_Presentation\CSS\images\remove.png"
        lbl.Style.Add("display", "")
        img.Style.Add("display", "")
    End Sub

    ''' <summary>
    ''' Wijzigt de gegeven controls naar een "geslaagd" design.
    ''' </summary>
    ''' <param name="tekst">De tekst die het feedbacklabel zal weergeven.</param>
    ''' <param name="lbl">Het feedbacklabel.</param>
    ''' <param name="img">De imagecontrol.</param>
    Public Shared Sub SetOK(ByVal tekst As String, ByRef lbl As Label, ByRef img As Image)
        lbl.Text = tekst
        lbl.ForeColor = System.Drawing.ColorTranslator.FromHtml("#86CC7C")
        img.ImageUrl = "~\App_Presentation\CSS\images\tick.gif"
        lbl.Style.Add("display", "")
        img.Style.Add("display", "")
    End Sub

    ''' <summary>
    ''' Wijzigt de gegeven controls naar een "gelukt met fouten" design.
    ''' </summary>
    ''' <param name="tekst">De tekst die het feedbacklabel zal weergeven.</param>
    ''' <param name="lbl">Het feedbacklabel.</param>
    ''' <param name="img">De imagecontrol.</param>
    Public Shared Sub SetWarn(ByVal tekst As String, ByRef lbl As Label, ByRef img As Image)
        lbl.Text = tekst
        lbl.ForeColor = System.Drawing.ColorTranslator.FromHtml("#EAB600")
        img.ImageUrl = "~\App_Presentation\CSS\images\warning.png"
        lbl.Style.Add("display", "")
        img.Style.Add("display", "")
    End Sub

    Public Shared Sub SetHidden(ByRef lbl As Label, ByRef img As Image)
        lbl.Style.Add("display", "none")
        img.Style.Add("display", "none")
    End Sub

    ''' <summary>
    ''' Leest een of meerdere waardes uit een DropDownList.
    ''' </summary>
    ''' <param name="ddl">De DropDownList waaruit de waardes dienen te komen.</param>
    ''' <returns>Alle waardes indien SelectedValue = -1000, anders enkel de waarde van de geselecteerdeo optie</returns>
    Public Shared Function DropdownUitlezen(ByRef ddl As DropDownList) As String
        Dim returnstring As String = String.Empty
        If ddl.SelectedValue = -1000 Then 'alles
            For index As Integer = 1 To ddl.Items.Count - 1
                returnstring = String.Concat(returnstring, ",", ddl.Items(index).Value.ToString)
            Next
            returnstring = returnstring.Remove(0, 1) 'Eerste komma verwijderen
        Else
            returnstring = ddl.SelectedItem.Value.ToString
        End If

        Return returnstring
    End Function

    Public Shared Sub CheckOfBeheerder(ByVal pagina As String)
        If HttpContext.Current.Session("login") IsNot Nothing Then
            If HttpContext.Current.Session("login") = 0 Then
                HttpContext.Current.Session("vorigePagina") = pagina
            End If
        Else
            HttpContext.Current.Response.Redirect("Aanmeldpagina.aspx", False)
        End If
    End Sub

    Public Shared Sub TooltipsToevoegen(ByRef pagina As System.Web.UI.Page, ByRef tips As List(Of Tooltip))
        'Tooltips op de pagina zetten via scriptmanager als het een postback is, anders gewoon in de onload functie van de body.

        If pagina.IsPostBack Then
            Tooltip.VoegTipToeAanEndRequest(pagina, tips)
        Else
            Dim body As HtmlGenericControl = pagina.Master.FindControl("MasterBody")
            Tooltip.VoegTipToeAanBody(body, tips)
        End If
    End Sub

    Public Shared Sub LeesBedrijven(ByRef ddl As DropDownList, Optional ByVal ddlLeegmaken As Boolean = True, Optional ByVal tekstWaardes As Boolean = False)
        If ddlLeegmaken Then
            ddl.Items.Clear()
        End If
        For Each b As Bedrijf In Bedrijf.GetBedrijven
            If tekstWaardes Then
                ddl.Items.Add(New ListItem(b.Naam, b.Naam))
            Else
                ddl.Items.Add(New ListItem(b.Naam, b.ID))
            End If
        Next
    End Sub

    Public Shared Sub LeesVersies(ByRef ddl As DropDownList, Optional ByVal ddlLeegmaken As Boolean = True, Optional ByVal tekstWaardes As Boolean = False)
        If ddlLeegmaken Then
            ddl.Items.Clear()
        End If
        For Each v As Versie In Versie.GetVersies
            If tekstWaardes Then
                ddl.Items.Add(New ListItem(v.VersieNaam, v.VersieNaam))
            Else
                ddl.Items.Add(New ListItem(v.VersieNaam, v.ID))
            End If
        Next
    End Sub

    Public Shared Sub LeesTalen(ByRef ddl As DropDownList, Optional ByVal ddlLeegmaken As Boolean = True, Optional ByVal tekstWaardes As Boolean = False)
        If ddlLeegmaken Then
            ddl.Items.Clear()
        End If
        For Each taal As Taal In taal.GetTalen
            If tekstWaardes Then
                ddl.Items.Add(New ListItem(taal.TaalNaam, taal.TaalNaam))
            Else
                ddl.Items.Add(New ListItem(taal.TaalNaam, taal.ID))
            End If
        Next
    End Sub

    Public Shared Sub LeesCategorien(ByRef ddl As DropDownList, ByRef t As Tree, Optional ByVal ddlLeegmaken As Boolean = True, Optional ByVal metRootNode As Boolean = False)
        If ddlLeegmaken Then
            ddl.Items.Clear()
        End If

        If metRootNode Then
            ddl.Items.Add(New ListItem("root_node", "0"))
        End If

        t.VulCategorieDropdown(ddl, t.RootNode, -1)
    End Sub

    Public Shared Sub LaadPaginering(ByRef grid As GridView)
        Dim r As GridViewRow = grid.BottomPagerRow

        For index As Integer = 0 To grid.PageCount - 1
            Dim ctl As WebControl = Nothing

            If index = grid.PageIndex Then
                Dim label As New Label
                label.Text = index + 1
                label.CssClass = "gridview_bignumber"
                label.ID = String.Concat("lblPaginaNummer_" + label.Text)
                ctl = label
            Else
                Dim linkbutton As New LinkButton()
                linkbutton.Text = index + 1
                linkbutton.ID = String.Concat("lnbPaginaNummer_" + linkbutton.Text)
                ctl = linkbutton
            End If

            r.Cells(0).Controls.Add(ctl)
        Next index
    End Sub

    Public Shared Function LeesPaginaNummer(ByRef page As Page, ByRef grid As GridView) As Boolean
        Dim control As String = page.Request.Params.Get("__EVENTTARGET")

        If control IsNot Nothing And Not control = String.Empty Then
            grid.DataBind()
            If TryCast(page.FindControl(control), LinkButton) IsNot Nothing Then
                Dim ctl As LinkButton = page.FindControl(control)
                grid.PageIndex = Integer.Parse(ctl.Text) - 1
                Return True
            End If
        End If

        Return False
    End Function

    Public Shared Sub OnverwachteFout(ByRef ctl As WebControl, ByVal message As String)
        ErrorLogger.WriteError(New ErrorLogger(message))
        JavaScript.ShadowBoxOpenen(ctl, String.Concat("<strong>Er is een onverwachte fout gebeurd: </strong><br/>", message))
    End Sub

    Public Shared Sub OnverwachteFout(ByRef page As Page, ByVal message As String)
        ErrorLogger.WriteError(New ErrorLogger(message))
        JavaScript.ShadowBoxOpenen(page, String.Concat("<strong>Er is een onverwachte fout gebeurd: </strong><br/>", message))
    End Sub

    Public Shared Sub SetPostback(ByVal bool As Boolean)
        Current.Session("bezigMetPostBack") = bool
    End Sub

    Public Shared Function CheckPostback() As Boolean
        If Current.Session("bezigMetPostBack") IsNot Nothing Then
            If Current.Session("bezigMetPostBack") = True Then
                Return False
            End If
        End If

        Return True
    End Function

    ''' <summary>
    ''' Gaat na of de opgegeven WebControls een waarde bevatten.
    ''' </summary>
    ''' <param name="w1">Eerste WebControl.</param>
    ''' <param name="w2">Tweede WebControl.</param>
    ''' <param name="w3">Derde WebControl.</param>
    ''' <param name="w4">Vierde WebControl.</param>
    ''' <returns>True indien alles een waarde bevat, anders False.</returns>
    ''' <remarks>Valideert enkel Textboxes, Dropdownlists en Listboxes.</remarks>
    Public Shared Function Valideer(ByRef w1 As WebControl, ByRef w2 As WebControl, ByRef w3 As WebControl, ByRef w4 As WebControl) As Boolean
        If IsGeldig(w1) And IsGeldig(w2) And IsGeldig(w3) And IsGeldig(w4) Then
            Return True
        Else
            Return False
        End If
    End Function

    ''' <summary>
    ''' Gaat na of de opgegeven WebControls een waarde bevatten.
    ''' </summary>
    ''' <param name="w1">Eerste WebControl.</param>
    ''' <param name="w2">Tweede WebControl.</param>
    ''' <param name="w3">Derde WebControl.</param>
    ''' <returns>True indien alles een waarde bevat, anders False.</returns>
    ''' <remarks>Valideert enkel Textboxes, Dropdownlists en Listboxes.</remarks>
    Public Shared Function Valideer(ByRef w1 As WebControl, ByRef w2 As WebControl, ByRef w3 As WebControl) As Boolean
        If IsGeldig(w1) And IsGeldig(w2) And IsGeldig(w3) Then
            Return True
        Else
            Return False
        End If
    End Function

    ''' <summary>
    ''' Gaat na of de opgegeven WebControls een waarde bevatten.
    ''' </summary>
    ''' <param name="w1">Eerste WebControl.</param>
    ''' <param name="w2">Tweede WebControl.</param>
    ''' <returns>True indien alles een waarde bevat, anders False.</returns>
    ''' <remarks>Valideert enkel Textboxes, Dropdownlists en Listboxes.</remarks>
    Public Shared Function Valideer(ByRef w1 As WebControl, ByRef w2 As WebControl) As Boolean
        If IsGeldig(w1) And IsGeldig(w2) Then
            Return True
        Else
            Return False
        End If
    End Function

    ''' <summary>
    ''' Gaat na of de opgegeven WebControl een waarde bevat.
    ''' </summary>
    ''' <param name="w">De te valideren WebControl.</param>
    ''' <returns>True indien alles een waarde bevat, anders False.</returns>
    ''' <remarks>Valideert enkel Textboxes, Dropdownlists en Listboxes.</remarks>
    Public Shared Function Valideer(ByRef w As WebControl) As Boolean
        Return IsGeldig(w)
    End Function

    ''' <summary>
    ''' Gaat na of de opgegeven WebControls een waarde bevatten.
    ''' </summary>
    ''' <param name="lijst">Array van WebControls.</param>
    ''' <returns>True indien alles een waarde bevat, anders False.</returns>
    ''' <remarks>Valideert enkel Textboxes, Dropdownlists en Listboxes.</remarks>
    Public Shared Function Valideer(ByRef lijst() As WebControl) As Boolean
        For Each ctl As WebControl In lijst
            If Not IsGeldig(ctl) Then Return False
        Next ctl
        Return True
    End Function

    Private Shared Function IsGeldig(ByRef w As WebControl) As Boolean
        If w Is Nothing Then Return False

        If TryCast(w, TextBox) IsNot Nothing Then
            Dim txt As TextBox = w
            If txt.Text = String.Empty Then
                Return False
            End If
        ElseIf TryCast(w, DropDownList) IsNot Nothing Then
            Dim ddl As DropDownList = w
            If ddl.SelectedItem Is Nothing Then
                Return False
            End If
        ElseIf TryCast(w, ListBox) IsNot Nothing Then
            Dim lst As ListBox = w
            If lst.SelectedItem Is Nothing Then
                Return False
            End If
        End If

        Return True
    End Function




End Class
