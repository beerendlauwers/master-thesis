Imports Manual
Imports System.Security.Cryptography

Partial Class _Default
    Inherits System.Web.UI.Page

    Dim dummyPass As String = String.Empty
    Dim dummyTag As String = "AAAFinancials"
    Dim dummyTaal As String = "NL"
    Dim dummyVersie As String = "010302"
    Dim dummyModule As String = "BAS"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Page.Title = "Gebruikersvalidatie"

            VoerTestWaardesIn()

            If PaswoordValideren() Then

                Dim versie As Integer = VersieValideren()

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
        Catch ex As Exception
            Dim err As New ErrorLogger(ex.Message)
            ErrorLogger.WriteError(err)
        End Try
    End Sub

    Private Sub VoerTestWaardesIn()

        'Juiste paswoord doorsturen
        Dim md5Hasher As New MD5CryptoServiceProvider
        Dim encoder As New UTF8Encoding

        Dim dt1 As Date = DateAndTime.Now
        Dim huidigeTijd1 As String = String.Concat(dt1.Day, "/", dt1.Month, "/", dt1.Year)

        Dim cleartext As String = "!AppligenS_J_W_X_W_J_SnegilppA!"

        Dim paswoord As String = String.Concat(cleartext, huidigeTijd1)
        Dim lokaalPaswoord1 As Byte() = md5Hasher.ComputeHash(encoder.GetBytes(paswoord))

        For Each b As Byte In lokaalPaswoord1
            dummyPass += b.ToString("x2")
        Next
    End Sub

    Private Function PaswoordValideren() As Boolean

        'De hashstring uitlezen die we hebben binnengekregen
        Dim remoteHashString As String = String.Empty

        If Page.Request.QueryString("Paswoord") IsNot Nothing Then
            remoteHashString = Page.Request.QueryString("Paswoord")
        ElseIf dummyPass IsNot Nothing Then
            remoteHashString = dummyPass
        Else
            Me.lblInfo.Text = "Ongeldig paswoord."
            Return False
        End If

        'Paswoord vergelijken
        Dim md5Hasher As New MD5CryptoServiceProvider
        Dim encoder As New UTF8Encoding

        Dim dt1 As Date = DateAndTime.Now
        Dim dt2 As Date = DateAdd(DateInterval.Hour, 1, dt1)
        Dim huidigeTijd1 As String = String.Concat(dt1.Day, "/", dt1.Month, "/", dt1.Year)
        Dim huidigeTijd2 As String = String.Concat(dt2.Day, "/", dt2.Month, "/", dt2.Year)

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

        If Not lokaalpass1String = remoteHashString Then
            If Not lokaalpass2String = remoteHashString Then
                Me.lblInfo.Text = "Ongeldig paswoord."
                Return False
            End If
        End If

        Return True

    End Function

    Private Function VersieValideren() As Integer

        Dim versie As String = String.Empty

        If Page.Request.QueryString("Versie") IsNot Nothing Then
            versie = Page.Request.QueryString("Versie")
        ElseIf dummyVersie IsNot Nothing Then
        versie = dummyVersie
        Else
        Me.lblInfo.Text = "Ongeldige versie."
        Return 0
        End If

        Dim dt As tblVersieDataTable = DatabaseLink.GetInstance.GetVersieFuncties.GetAllVersie
        For Each row As tblVersieRow In dt

            If row.Versie = versie Then
                Return row.VersieID
            End If

        Next row

        Return 0


    End Function

    Private Function TagOpzoeken() As Integer

        Dim tag As String = String.Empty

        If Page.Request.QueryString("Bedrijf") IsNot Nothing Then
            tag = Page.Request.QueryString("Bedrijf")
        ElseIf dummyTag IsNot Nothing Then
            tag = dummyTag
        Else
            Return -1000
        End If

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

        Dim taal As String = String.Empty

        If Page.Request.QueryString("Taal") IsNot Nothing Then
            taal = Page.Request.QueryString("Taal")
        ElseIf dummyTaal IsNot Nothing Then
            taal = dummyTaal
        Else
            Return 0
        End If

        Dim dt As tblTaalDataTable = DatabaseLink.GetInstance.GetTaalFuncties.GetAllTaal

        Dim taalGevonden As Boolean = False
        Dim taalID As Integer
        For Each row As tblTaalRow In dt

            If row.TaalTag = taal Then
                taalGevonden = True
                taalID = row.TaalID
                Return taalID
            End If
        Next row

        Return 0

    End Function

    Private Sub PaginaTagBekijken()

        If Page.Request.QueryString("Paginatag") Is Nothing Then

            'Het kan zijn dat we werden teruggestuurd naar hier om te valideren.
            'Als we succesvol waren, kunnen we worden teruggestuurd.
            If Session("vorigePagina") IsNot Nothing Then

                'Oneindige loops zijn slecht, mkay
                If Not Session("vorigePagina") = Page.Request.Url.AbsolutePath Then
                    Response.Redirect(Session("vorigePagina"), False)
                End If

            End If

            Response.Redirect("~/App_presentation/", False)
            Return
        End If

        If TryCast(Page.Request.QueryString("Paginatag"), String) Is Nothing Then
            Return
        End If

        Dim paginatag As String = Page.Request.QueryString("Paginatag")
        paginatag = paginatag.Trim

        Response.Redirect(String.Concat("page.aspx?tag=", paginatag), False)

    End Sub

End Class
