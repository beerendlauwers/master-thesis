
Partial Class App_Presentation_Module
    Inherits System.Web.UI.Page

    Protected Sub grdvmodule_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdvmodule.DataBound
        Util.LaadPaginering(grdvmodule)
        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub

    Protected Sub grdvmodule_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdvmodule.RowCommand
        JavaScript.ShadowBoxLaderSluiten(Me)
    End Sub

    Protected Sub grdvmodule_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdvmodule.RowDataBound
        Dim titel As String = e.Row.Cells(0).Text
        e.Row.Cells(0).Text = Server.HtmlDecode(titel)
        If e.Row.Cells.Count > 1 Then
            e.Row.Cells(1).Visible = False
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        paslokalisatietoe()
        Dim dt As Data.DataTable
        Dim moduledal As New ModuleDAL
        If Session("versie") IsNot Nothing And Session("bedrijf") IsNot Nothing And Session("taal") IsNot Nothing Then
            Dim versie As Integer = Integer.Parse(Session("versie"))
            Dim bedrijf As Integer = Integer.Parse(Session("bedrijf"))
            Dim taal As Integer = Integer.Parse(Session("taal"))
            dt = moduledal.GetModulesMetArtikels(taal, versie, bedrijf)
            If dt.Rows.Count = 0 Then
                verstoppen()
            Else
                zichtbaar_maken()
                Dim control1 As String = Page.Request.Params.Get("__EVENTTARGET")
                Dim arg As String = Page.Request.Params.Get("__EVENTARGUMENT")

                If control1 IsNot Nothing And arg IsNot Nothing Then
                    If Not control1.Contains("lnbPaginaNummer_") And Not control1.Contains("ddlModule") Then
                        ddlModule.Items.Clear()
                        If ckbModules.Checked Then
                            For i As Integer = 0 To dt.Rows.Count - 1
                                Dim li As New ListItem(dt.Rows(i)(0), dt.Rows(i)(0))
                                ddlModule.Items.Add(li)
                            Next
                        Else
                            grdvmodule.EmptyDataText = Lokalisatie.GetString("GEENDATAGEVONDEN")
                            ddlModule.Attributes.Add("DataSourceID", "objdModule")
                            ddlModule.DataTextField = "Module"
                            ddlModule.DataValueField = "Module"
                            ddlModule.DataBind()
                        End If
                    End If
                End If
            End If

            If Not IsPostBack Then
                If ckbModules.Checked Then
                    If dt IsNot Nothing Then
                        For i As Integer = 0 To dt.Rows.Count - 1
                            Dim li As New ListItem(dt.Rows(i)(0), dt.Rows(i)(0))
                            ddlModule.Items.Add(li)
                        Next
                    End If
                Else
                    ddlModule.Attributes.Add("DataSourceID", "objdModule")
                    ddlModule.DataTextField = "Module"
                    ddlModule.DataValueField = "Module"
                End If
            End If
        End If
        grdvmodule.DataBind()
        Dim control As String = Page.Request.Params.Get("__EVENTTARGET")

        Util.LeesPaginaNummer(Me, grdvmodule)
        GenereerGelokaliseerdeTekst()
        JavaScript.ShadowBoxLaderTonenBijElkePostback(Me)
    End Sub

    Private Sub GenereerGelokaliseerdeTekst()
        Master.CheckVoorTaalWijziging()
        grdvmodule.EmptyDataText = Lokalisatie.GetString("GEENDATAGEVONDEN")
        Page.Title = Lokalisatie.GetString("MODPAGINATITEL")
        For Each d As DataControlField In grdvmodule.Columns
            If d.SortExpression = "titel" Then d.HeaderText = Lokalisatie.GetString("ZOEKEN_TITEL")
        Next
    End Sub

    Protected Sub ckbModules_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ckbModules.CheckedChanged
        If ckbModules.Checked Then
            ddlModule.Items.Clear()
            Dim dt As Data.DataTable
            Dim moduledal As New ModuleDAL
            Dim versie As Integer = Integer.Parse(Session("versie"))
            Dim bedrijf As Integer = Integer.Parse(Session("bedrijf"))
            Dim taal As Integer = Integer.Parse(Session("taal"))
            dt = moduledal.GetModulesMetArtikels(taal, versie, bedrijf)
            If dt.Rows.Count = 0 Then
                verstoppen()
            Else
                zichtbaar_maken()
                For i As Integer = 0 To dt.Rows.Count - 1
                    Dim li As New ListItem(dt.Rows(i)(0), dt.Rows(i)(0))
                    ddlModule.Items.Add(li)
                Next
                ddlModule.Attributes.Remove("DataSourceID")
                grdvmodule.DataBind()
            End If

        Else
            ddlModule.Items.Clear()
            ddlModule.DataTextField = "Module"
            ddlModule.DataValueField = "Module"
            ddlModule.DataSourceID = "objdModule"
            ddlModule.DataBind()
            grdvmodule.DataBind()
        End If
    End Sub

    Public Sub verstoppen()
        lblDropdown.Visible = True
        lblDropdown.Text = Lokalisatie.GetString("MODULENOARTIKELS")
        ddlModule.Visible = False
        ckbModules.Visible = False
        lblCkb.Visible = False
        grdvmodule.Visible = False
    End Sub
    Public Sub zichtbaar_maken()
        lblDropdown.Visible = False
        ddlModule.Visible = True
        ckbModules.Visible = True
        lblCkb.Visible = True
        grdvmodule.Visible = True
    End Sub
    Public Sub paslokalisatietoe()
        Master.CheckVoorTaalWijziging()
        lblCkb.Text = Lokalisatie.GetString("MODULECHECKBOX")
        Page.Title = Lokalisatie.GetString("MODPAGINATITEL")
        lblTitel.Text = Lokalisatie.GetString("MODULETITEL")
    End Sub
End Class
