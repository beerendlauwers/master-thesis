Imports Manual
Imports System.Security.Cryptography

Partial Class _Default
    Inherits System.Web.UI.Page

    Dim dummyPass As String = String.Empty
    Dim dummyTag As String = "AAAFinancials"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            Page.Title = "Gebruikersvalidatie"

            If XML.Doorsteek.IsApplicatieLive = False Then
                VoerTestWaardesIn()
            End If

            If PaswoordValideren() Then

                Dim versie As Integer = VersieValideren()

                Dim bedrijf As Integer = BedrijfOpzoeken()

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

        Dim cleartext As String = XML.Doorsteek.Paswoord

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
        ElseIf dummyPass IsNot String.Empty Then
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
        ElseIf XML.Doorsteek.DefaultVersie IsNot String.Empty Then
            versie = XML.Doorsteek.DefaultVersie
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

    Private Function BedrijfOpzoeken() As Integer

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
        ElseIf XML.Doorsteek.DefaultTaal IsNot String.Empty Then
            taal = XML.Doorsteek.DefaultTaal
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

        'Juiste artikel ophalen op basis van tag, versie, taal en bedrijf
        Dim artikeldal As ArtikelDAL = DatabaseLink.GetInstance.GetArtikelFuncties

        'Bedrijven in geheugen al inladen
        Bedrijf.BouwBedrijfLijst()

        'Standaardbedrijf ophalen, alsook extra bedrijf
        Dim standaardbedrijf As Bedrijf = Bedrijf.GetBedrijf(XML.Doorsteek.DefaultBedrijf)

        Dim anderbedrijfID As Integer = Session("bedrijf")
        Dim anderbedrijf As Bedrijf = Bedrijf.GetBedrijf(anderbedrijfID)

        Dim versieID As Integer = Session("versie")
        Dim taalID As Integer = Session("taal")

        'Standaardbedrijf ophalen
        If standaardbedrijf Is Nothing Then
            Util.OnverwachteFout(Me, "Het bedrijf dat altijd zichtbaar is, werd niet gevonden in het geheugen! Kijk na of u de naam van het bedrijf juist heeft ingevuld in doorsteeklogin.xml.")
            Return
        End If

        Dim standaardrow As tblArtikelRow = artikeldal.getArtikelBySimpleTagTaalVersieBedrijf(standaardbedrijf.ID, versieID, taalID, paginatag)
        If standaardrow IsNot Nothing Then
            Response.Redirect(String.Concat("~/App_Presentation/page.aspx?tag=", standaardrow.Tag), False)
            Return
        End If

        If anderbedrijf IsNot Nothing Then
            Dim extrabedrijfrow As tblArtikelRow = artikeldal.getArtikelBySimpleTagTaalVersieBedrijf(anderbedrijf.ID, versieID, taalID, paginatag)

            If extrabedrijfrow IsNot Nothing Then
                Response.Redirect(String.Concat("~/App_Presentation/page.aspx?tag=", extrabedrijfrow.Tag), False)
                Return
            End If
        End If

    End Sub

End Class
