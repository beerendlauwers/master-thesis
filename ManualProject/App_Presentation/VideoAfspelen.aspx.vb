
Partial Class App_Presentation_VideoAfspelen
    Inherits System.Web.UI.Page
    Private videodal As New VideoDal

    Protected Sub btnPlay_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnPlay.Click
        Dim div As HtmlGenericControl = film
        div.InnerHtml = ""
        WindowsMedia1.Enabled = False
        QuickTime2.Enabled = False
        FlashVideo1.Enabled = False
        lblHelp.Text = ""
        Dim videoID As Integer
        Dim dt As New Manual.tblVideoDataTable
        videoID = ddlVideo.SelectedValue
        dt = videodal.getVideoByID(videoID)
        

        Dim naam As String
        naam = dt.Rows(0)("videoNaam")
        Dim ext() As String = naam.Split(".")
        naam = dt.Rows(0)("videoNaam")
        If ext(ext.GetLength(0) - 1) = "mov" Then
            QuickTime2.VideoURL = "~/video/" + dt.Rows(0)("videoNaam")
            QuickTime2.Enabled = True
            QuickTime2.ShowControlPanel = True
            QuickTime2.Style.Add("vertical-align", "top")
            Dim browserversie = Request.Browser.Browser()
            lblHelp.Text = "Als u niets te zien krijgt moet u Quicktime nog installeren."
            If browserversie = "IE" Then
                lblHelp.Text = "U kunt best Firefox of Chrome gebruiken om deze video te bekijken."
            End If
        ElseIf ext(ext.GetLength(0) - 1) = "swf" Then
            Dim htmlcode As String = dt.Rows(0)("videoCode")

            div.InnerHtml = htmlcode
        ElseIf ext(ext.GetLength(0) - 1) = "avi" Or ext(ext.GetLength(0) - 1) = "wmv" Then
            WindowsMedia1.VideoURL = "~/video/" + dt.Rows(0)("videoNaam")
            WindowsMedia1.Enabled = True
            WindowsMedia1.Style.Add("vertical-align", "top")
            Dim browserversie = Request.Browser.Browser()
            If browserversie = "Firefox" Or browserversie = "AppleMAC-Safari" Then
                lblHelp.Text = "U kunt best Internet Explorer gebruiken om deze video te bekijken."
            End If
        ElseIf ext(ext.GetLength(0) - 1) = "flv" Then
            FlashVideo1.Enabled = True
            FlashVideo1.VideoURL = "~/video/" + dt.Rows(0)("videoNaam")
            FlashVideo1.Style.Add("vertical-align", "top")


        End If
        
    End Sub


    ''' <summary>
    ''' Als er een video werd meegestuurd in de querystring wordt deze geladen en afgespeeld.
    ''' </summary>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("login") = 1 Then
            divLoggedIn.Visible = True
        Else
            divLoggedIn.Visible = False
        End If
        If Request.QueryString.Count > 0 Then
            Dim naam As String = Request.QueryString("naam")
            Dim dt As Manual.tblVideoDataTable
            dt = videodal.getVideoByNaam(naam)
            naam = dt.Rows(0)("videoNaam")
            Dim ext() As String = naam.Split(".")
            If ext(ext.GetLength(0) - 1) = "mov" Then
                QuickTime2.VideoURL = "~/video/" + dt.Rows(0)("videoNaam")
                QuickTime2.Enabled = True
                QuickTime2.AutoPlay = True
                QuickTime2.Style.Add("vertical-align", "top")
                Dim browserversie = Request.Browser.Browser()

                If browserversie = "IE" Then
                    lblHelp.Text = "Als de video niet afspeelt kunt U best Firefox gebruiken om deze video te bekijken."
                End If
            ElseIf ext(ext.GetLength(0) - 1) = "swf" Then
                Dim htmlcode As String = dt.Rows(0)("videoCode")
                Dim div As HtmlGenericControl = film
                div.InnerHtml = htmlcode
            ElseIf ext(ext.GetLength(0) - 1) = "avi" Or ext(ext.GetLength(0) - 1) = "wmv" Then
                WindowsMedia1.VideoURL = "~/video/" + dt.Rows(0)("videoNaam")
                WindowsMedia1.Enabled = True
                WindowsMedia1.AutoPlay = True
                WindowsMedia1.Style.Add("vertical-align", "top")
                Dim browserversie = Request.Browser.Browser()
                If browserversie = "Firefox" Or browserversie = "AppleMAC-Safari" Then
                    lblHelp.Text = "Als de video niet afspeelt kunt U best Internet Explorer gebruiken om deze video te bekijken."
                End If
            ElseIf ext(ext.GetLength(0) - 1) = "flv" Then
                FlashVideo1.Enabled = True
                FlashVideo1.AutoPlay = True
                FlashVideo1.VideoURL = "~/video/" + dt.Rows(0)("videoNaam")
                FlashVideo1.Style.Add("vertical-align", "top")
            End If
        End If
    End Sub

    
End Class
