Imports Manual
Imports System.Data

Partial Class App_Presentation_Module
    Inherits System.Web.UI.Page
    Private moduledal As ModuleDAL = DatabaseLink.GetInstance.GetModuleFuncties
    Private artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties

    Protected Sub grdvmodule_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles grdvmodule.DataBound
        Util.LaadPaginering(grdvmodule)
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
        GenereerGelokaliseerdeTekst()

        UpdateModules()

            UpdateModuleOverzicht()
            Util.LeesPaginaNummer(Me, grdvmodule)

        grdvmodule.DataBind()

        JavaScript.ShadowBoxLaderTonenBijElkePostback(Me)
    End Sub

    Private Sub GenereerGelokaliseerdeTekst()
        Master.CheckVoorTaalWijziging()

        lblCkb.Text = Lokalisatie.GetString("MODULECHECKBOX")
        Page.Title = Lokalisatie.GetString("MODPAGINATITEL")
        lblTitel.Text = Lokalisatie.GetString("MODULETITEL")
        grdvmodule.EmptyDataText = Lokalisatie.GetString("GEENDATAGEVONDEN")
        Page.Title = Lokalisatie.GetString("MODPAGINATITEL")
        For Each d As DataControlField In grdvmodule.Columns
            If d.SortExpression = "titel" Then d.HeaderText = Lokalisatie.GetString("ZOEKEN_TITEL")
        Next
    End Sub

    Private Sub ModulesInlezen(ByRef dt As DataTable)
        ddlModule.Items.Clear()
        ddlModule.DataSource = dt
        ddlModule.DataBind()
    End Sub

    Private Sub UpdateModuleOverzicht()

        If Session("versie") IsNot Nothing And Session("bedrijf") IsNot Nothing And Session("taal") IsNot Nothing Then
            Dim moduletekst As String = ddlModule.SelectedValue
            Dim versieID As Integer = Integer.Parse(Session("versie"))
            Dim anderBedrijfID As Integer = Integer.Parse(Session("bedrijf"))
            Dim taalID As Integer = Integer.Parse(Session("taal"))


            Dim dt As tblArtikelDataTable

            'Appligen
            Dim appligen As Bedrijf = Bedrijf.GetBedrijf(XML.Doorsteek.DefaultBedrijf)
            Dim appligendt As tblArtikelDataTable = artikeldal.GetArtikelsByModule(moduletekst, taalID, versieID, appligen.ID)

            Dim anderbedrijf As Bedrijf = Bedrijf.GetBedrijf(anderBedrijfID)
            Dim anderbedrijfdt As New tblArtikelDataTable
            If anderbedrijf IsNot Nothing Then
                anderbedrijfdt = artikeldal.GetArtikelsByModule(moduletekst, taalID, versieID, anderbedrijf.ID)
            End If

            dt = appligendt.Copy()
            dt.Merge(anderbedrijfdt)

            grdvmodule.DataSource = dt
            grdvmodule.DataBind()
        End If
    End Sub

    Private Sub UpdateModules()
        If Session("versie") IsNot Nothing And Session("bedrijf") IsNot Nothing And Session("taal") IsNot Nothing Then

            'De modulegegevens ophalen.
            Dim dt As DataTable

            Dim versieID As Integer = Integer.Parse(Session("versie"))
            Dim anderBedrijfID As Integer = Integer.Parse(Session("bedrijf"))
            Dim taalID As Integer = Integer.Parse(Session("taal"))

            If ckbModules.Checked Then 'enkel modules waar artikels onder zitten

                'We moeten twee datatables ophalen: die van AAAFinancials en die van het bedrijf.
                Dim appligen As Bedrijf = Bedrijf.GetBedrijf(XML.Doorsteek.DefaultBedrijf)
                Dim anderBedrijf As Bedrijf = Bedrijf.GetBedrijf(anderBedrijfID)

                If anderBedrijf Is Nothing Then 'er is geen ander bedrijf.

                    dt = moduledal.GetModulesMetArtikels(taalID, versieID, appligen.ID)

                Else
                    Dim appligendt As DataTable = moduledal.GetModulesMetArtikels(taalID, versieID, appligen.ID)
                    Dim anderbedrijfdt As DataTable = moduledal.GetModulesMetArtikels(taalID, versieID, anderBedrijf.ID)

                    'Alles overkopiëren naar de hoofddatatable
                    dt = appligendt.Copy()
                    dt.Merge(anderbedrijfdt)
                End If

            Else 'alle modules
                dt = moduledal.GetAllModules()
            End If


            'Nakijken of er modulegegevens zijn.

            If dt.Rows.Count = 0 Then 'geen modules voor deze taal

                ModulesWeergeven(False)
                lblDropdown.Text = Lokalisatie.GetString("MODULENOARTIKELS")

            Else 'er zijn modules voor deze taal
                ModulesWeergeven(True)

                If IsPostBack Then

                    'We moeten de dropdownlist herladen indien er een postback gebeurt van zowat elke control.
                    Dim postbackControl As String = Page.Request.Params.Get("__EVENTTARGET")

                    If postbackControl IsNot Nothing Then

                        'Enkel deze controls zorgen niet voor een postback.
                        If Not postbackControl.Contains("lnbPaginaNummer_") And Not postbackControl.Contains("ddlModule") Then
                            ModulesInlezen(dt)
                        End If

                    End If

                Else

                    ModulesInlezen(dt)

                End If

                UpdateModuleOverzicht()
            End If
        End If
    End Sub

    Protected Sub ckbModules_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ckbModules.CheckedChanged
        UpdateModules()
        grdvmodule.DataBind()
    End Sub

    Private Sub ModulesWeergeven(ByVal waarde As Boolean)
        lblDropdown.Visible = Not waarde
        ddlModule.Visible = waarde
        ckbModules.Visible = waarde
        lblCkb.Visible = waarde
        grdvmodule.Visible = waarde
    End Sub

    Protected Sub ddlModule_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlModule.SelectedIndexChanged
        UpdateModuleOverzicht()
    End Sub
End Class
