Imports Manual

Partial Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Page.Request.Form("Paswoord") Is Nothing Then
            Me.lblInfo.Text = "Ongeldig paswoord."
            Return
        End If

        If TryCast(Page.Request.Form("Paswoord"), String) Is Nothing Then
            Me.lblInfo.Text = "Ongeldig paswoord."
            Return
        End If

        'Paswoord vergelijken

        If Page.Request.Form("Bedrijftag") Is Nothing Then
            Me.lblInfo.Text = "Ongeldige bedrijfstag."
            Return
        End If

        If TryCast(Page.Request.Form("Bedrijftag"), String) Is Nothing Then
            Me.lblInfo.Text = "Ongeldige bedrijfstag."
            Return
        End If

        'Tag vergelijken
        Dim tag As String = Page.Request.Form("Tag")

        Dim dt As tblbedrijfdatatable = DatabaseLink.GetInstance.GetBedrijfFuncties.GetAllBedrijf


        Dim tagGevonden As Boolean = False
        Dim bedrijf As Integer
        For Each row As tblBedrijfRow In dt
            If row.Tag = tag Then
                tagGevonden = True
                bedrijf = row.BedrijfID
                Exit For
            End If

        Next row

        If (Not tagGevonden) Then
            Me.lblInfo.Text = "De opgegeven tag werd niet gevonden."
            Return
        End If

        Dim taal As String = "Nederlands"
        If Page.Request.Form("Taal") IsNot Nothing Then
            If TryCast(Page.Request.Form("Taal"), String) IsNot Nothing Then
                taal = Page.Request.Form("Taal")
            End If
        End If

        'Alles is ok, we gaan alles in de sessievariabele schrijven

        Session("isIngelogd") = True
        Session("bedrijf") = bedrijf
        Session("taal") = taal

        'Als we ook een paginatag meekregen, gaan we die onderzoeken

        If Page.Request.Form("Paginatag") Is Nothing Then
            Return
        End If

        If TryCast(Page.Request.Form("Paginatag"), String) Is Nothing Then
            Return
        End If

        Dim paginatag As String = Page.Request.Form("Paginatag")
        paginatag = paginatag.Trim

        Response.Redirect(String.Concat("page.aspx?tag=", paginatag))


    End Sub
End Class
