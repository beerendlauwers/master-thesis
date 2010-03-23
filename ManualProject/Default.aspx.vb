Imports Manual
Imports System.Security.Cryptography

Partial Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        MsgBox("Date.Today.ToString")

        If Page.Request.Form("Paswoord") Is Nothing Then
            Me.lblInfo.Text = "Ongeldig paswoord."
            Return
        End If

        If TryCast(Page.Request.Form("Paswoord"), String) Is Nothing Then
            Me.lblInfo.Text = "Ongeldig paswoord."
            Return
        End If

        'Paswoord vergelijken
        Dim md5Hasher As New MD5CryptoServiceProvider
        Dim encoder As New UTF8Encoding

        Dim dt1 As Date = Date.Today
        Dim dt2 As Date = DateAdd(DateInterval.Minute, 1, dt1)
        Dim huidigeTijd1 As String = String.Concat(dt1.Minute, ":", dt1.Hour, " ", dt1.Day, "/", dt1.Month, "/", dt1.Year)
        Dim huidigeTijd2 As String = String.Concat(dt2.Minute, ":", dt2.Hour, " ", dt2.Day, "/", dt2.Month, "/", dt2.Year)

        Dim cleartext As String = "!AppligenS_J_W_X_W_J_SnegilppA!"

        Dim paswoord As String = String.Concat(cleartext, huidigeTijd1)
        Dim lokaalPaswoord1 As Byte() = md5Hasher.ComputeHash(encoder.GetBytes(paswoord))

        paswoord = String.Concat(cleartext, huidigeTijd2)
        Dim lokaalPaswoord2 As Byte() = md5Hasher.ComputeHash(encoder.GetBytes(paswoord))

        Dim remoteHash As Byte() = encoder.GetBytes(Page.Request.Form("Paswoord"))

        If Not lokaalPaswoord1 Is remoteHash Then
            If Not lokaalPaswoord2 Is remoteHash Then
                Me.lblInfo.Text = "Ongeldig paswoord."
                Return
            End If
        End If


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
