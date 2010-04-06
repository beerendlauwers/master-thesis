Imports Manual
Imports System.Security.Cryptography

Partial Class _Default
    Inherits System.Web.UI.Page

    Dim dummyPass As String = String.Empty
    Dim dummyTag As String = "ANDERBEDRIJF"
    Dim dummyTaal As String = "FR"
    Dim dummyVersie As String = "3.1"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Page.Title = "Gebruikersvalidatie"

        VoerTestWaardesIn()

        If PaswoordValideren() Then

            Dim versie As Integer = VersieValideren()

            '-1000 betekent dat het geen geldige versie is
            If versie = -1000 Then
                Return
            End If

            Dim bedrijf As Integer = TagOpzoeken()

            Dim taal As Integer = TaalOpzoeken()

            'Alles is ok, we gaan alles in de sessievariabele schrijven
            Session("isIngelogd") = True
            Session("versie") = versie
            Session("bedrijf") = bedrijf
            Session("taal") = taal

            'Als we ook een paginatag meekregen, gaan we die onderzoeken
            PaginaTagBekijken()

        End If

    End Sub

    Private Sub VoerTestWaardesIn()

        'Juiste paswoord doorsturen
        Dim md5Hasher As New MD5CryptoServiceProvider
        Dim encoder As New UTF8Encoding

        Dim dt1 As Date = DateAndTime.Now
        Dim huidigeTijd1 As String = String.Concat(dt1.Minute, ":", dt1.Hour, " ", dt1.Day, "/", dt1.Month, "/", dt1.Year)

        Dim cleartext As String = "!AppligenS_J_W_X_W_J_SnegilppA!"

        Dim paswoord As String = String.Concat(cleartext, huidigeTijd1)
        Dim lokaalPaswoord1 As Byte() = md5Hasher.ComputeHash(encoder.GetBytes(paswoord))

        For Each b As Byte In lokaalPaswoord1
            dummyPass += b.ToString("x2")
        Next
    End Sub

    Private Function PaswoordValideren() As Boolean

        'If Page.Request.Form("Paswoord") Is Nothing Then
        If dummyPass Is Nothing Then
            Me.lblInfo.Text = "Ongeldig paswoord."
            Return False
        End If

        'If TryCast(Page.Request.Form("Paswoord"), String) Is Nothing Then
        If dummyPass Is Nothing Then
            Me.lblInfo.Text = "Ongeldig paswoord."
            Return False
        End If

        'Paswoord vergelijken
        Dim md5Hasher As New MD5CryptoServiceProvider
        Dim encoder As New UTF8Encoding
        Dim enc As New ASCIIEncoding

        Dim dt1 As Date = DateAndTime.Now
        Dim dt2 As Date = DateAdd(DateInterval.Minute, 1, dt1)
        Dim huidigeTijd1 As String = String.Concat(dt1.Minute, ":", dt1.Hour, " ", dt1.Day, "/", dt1.Month, "/", dt1.Year)
        Dim huidigeTijd2 As String = String.Concat(dt2.Minute, ":", dt2.Hour, " ", dt2.Day, "/", dt2.Month, "/", dt2.Year)

        Dim cleartext As String = "!AppligenS_J_W_X_W_J_SnegilppA!"

        Dim paswoord As String = String.Concat(cleartext, huidigeTijd1)
        Dim lokaalPaswoord1 As Byte() = md5Hasher.ComputeHash(encoder.GetBytes(paswoord))

        paswoord = String.Concat(cleartext, huidigeTijd2)
        Dim lokaalPaswoord2 As Byte() = md5Hasher.ComputeHash(encoder.GetBytes(paswoord))

        Dim lokaalpass1String As String = String.Empty
        For Each b As Byte In lokaalPaswoord1
            lokaalpass1String += b.ToString("x2")
        Next

        Dim lokaalpass2String As String = String.Empty
        For Each b As Byte In lokaalPaswoord2
            lokaalpass2String += b.ToString("x2")
        Next

        'Dim remoteHash As Byte() = encoder.GetBytes(Page.Request.Form("Paswoord"))
        Dim remoteHashString As String = dummyPass

        If Not lokaalpass1String = remoteHashString Then
            If Not lokaalpass2String = remoteHashString Then
                Me.lblInfo.Text = "Ongeldig paswoord."
                Return False
            End If
        End If

        Return True

    End Function

    Private Function VersieValideren() As Integer

        'If Page.Request.Form("Versie") Is Nothing Then
        If dummyVersie Is Nothing Then
            Me.lblInfo.Text = "Ongeldige versie."
            Return -1000
        End If

        'If TryCast(Page.Request.Form("Versie"), String) Is Nothing Then
        If dummyVersie Is Nothing Then
            Me.lblInfo.Text = "Ongeldige versie."
            Return -1000
        End If

        Dim versie As String = dummyVersie

        Dim dt As tblVersieDataTable = DatabaseLink.GetInstance.GetVersieFuncties.GetAllVersie
        For Each row As tblVersieRow In dt

            If row.Versie = versie Then
                Return row.VersieID
            End If

        Next row

        Return -1000


    End Function

    Private Function TagOpzoeken() As Integer

        'Tag opzoeken
        'Dim tag As String = Page.Request.Form("Tag")
        Dim tag As String = dummyTag

        Dim dt As tblBedrijfDataTable = DatabaseLink.GetInstance.GetBedrijfFuncties.GetAllBedrijf

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
            Return -1000
        Else
            Return bedrijf
        End If

    End Function

    Private Function TaalOpzoeken() As Integer

        Dim taal As String = dummyTaal

        If Page.Request.Form("Taal") IsNot Nothing Then
            If TryCast(Page.Request.Form("Taal"), String) IsNot Nothing Then
                taal = Page.Request.Form("Taal")
            End If
        End If

        Dim dt As tblTaalDataTable = DatabaseLink.GetInstance.GetTaalFuncties.GetAllTaal

        Dim taalGevonden As Boolean = False
        Dim taalID As Integer
        Dim nederlands As Integer
        For Each row As tblTaalRow In dt

            If row.Taal = "Nederlands" Then
                nederlands = row.TaalID
            End If

            If row.TaalTag = taal Then
                taalGevonden = True
                taalID = row.TaalID
                Exit For
            End If
        Next row

        If Not taalGevonden Then
            Return nederlands
        Else
            Return taalID
        End If

    End Function

    Private Sub PaginaTagBekijken()

        If Page.Request.Form("Paginatag") Is Nothing Then

            'Het kan zijn dat we werden teruggestuurd naar hier om te valideren.
            'Als we succesvol waren, kunnen we worden teruggestuurd.
            If Session("vorigePagina") IsNot Nothing Then

                'Oneindige loops zijn slecht, mkay
                If Not Session("vorigePagina") = Page.Request.Url.AbsolutePath Then
                    Response.Redirect(Session("vorigePagina"))
                End If

            End If

            Response.Redirect("~/App_presentation/")
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
