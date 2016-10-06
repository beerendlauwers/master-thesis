﻿Partial Class App_Presentation_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GenereerGelokaliseerdeTekst()
    End Sub

    Private Sub GenereerGelokaliseerdeTekst()
        Master.CheckVoorTaalWijziging()
        Page.Title = Lokalisatie.GetString("STARTPAGINATITEL")
        lblWelkom.Text = Lokalisatie.GetString("WELKOMTEKST")
    End Sub


End Class
