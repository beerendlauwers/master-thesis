Imports Manual

Partial Class App_Presentation_VideoAfspelen
    Inherits System.Web.UI.Page


    Protected Sub btnPlay_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnPlay.Click

        Dim videoID As Integer = ddlVideo.SelectedValue
        'VideoLaden(videodal.getVideoByID(videoID))
        
    End Sub

    ''' <summary>
    ''' Als er een video werd meegestuurd in de querystring wordt deze geladen en afgespeeld.
    ''' </summary>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Alles resetten
        film.InnerHtml = String.Empty
        'WindowsMedia1.Enabled = False
        'QuickTime2.Enabled = False
        'FlashVideo1.Enabled = False
        'lblHelp.Text = String.Empty

        'Checken voor een meegegeven ID
        If Page.Request.QueryString("id") IsNot Nothing Then
            If IsNumeric(Page.Request.QueryString("id")) = True Then
                Dim id As Integer = Page.Request.QueryString("id")
                LaadVideo(id)
                JavaScript.VoegJavascriptToeAanBody(Master.FindControl("MasterBody"), "VeranderEditorScherm(200);")
            End If
        ElseIf Page.Request.QueryString("tag") IsNot Nothing Then
            Dim tag As String = Page.Request.QueryString("naam")
            LaadVideo(tag)
            JavaScript.VoegJavascriptToeAanBody(Master.FindControl("MasterBody"), "VeranderEditorScherm(200);")
        End If

    End Sub

    Private Sub LaadVideo(ByVal id As Integer)
        ' VideoLaden(videodal.getVideoByID(id))
    End Sub

    Private Sub LaadVideo(ByVal naam As String)
        ' VideoLaden(videodal.getVideoByNaam(naam))
    End Sub

    Private Sub VideoLaden(ByRef video As tblVideoRow)

        'Browserversie ophalen voor later
        Dim browserversie As String = Request.Browser.Browser()

        'Type bepalen
        Dim videoNaam() As String = video.videoNaam.Split(".")
        Dim type As String = videoNaam(videoNaam.GetLength(0) - 1)

        If type = "mov" Then

            'QuickTime2.VideoURL = String.Concat("~/video/", video.videoNaam)
            'QuickTime2.Enabled = True
            'QuickTime2.AutoPlay = True
            'QuickTime2.Style.Add("vertical-align", "top")

            If browserversie = "IE" Then
                lblHelp.Text = "Als de video niet afspeelt kunt U best Firefox gebruiken om deze video te bekijken."
            End If

        ElseIf type = "swf" Then
            film.InnerHtml = video.VideoCode
        ElseIf type = "avi" Or type = "wmv" Then
            'WindowsMedia1.VideoURL = String.Concat("~/video/", video.videoNaam)
            'WindowsMedia1.Enabled = True
            'WindowsMedia1.AutoPlay = True
            'WindowsMedia1.Style.Add("vertical-align", "top")

            If browserversie = "Firefox" Or browserversie = "AppleMAC-Safari" Then
                lblHelp.Text = "Als de video niet afspeelt kunt U best Internet Explorer gebruiken om deze video te bekijken."
            End If

        ElseIf type = "flv" Then
            'FlashVideo1.Enabled = True
            'FlashVideo1.AutoPlay = True
            'FlashVideo1.VideoURL = String.Concat("~/video/", video.videoNaam)
            'FlashVideo1.Style.Add("vertical-align", "top")

        End If

    End Sub

End Class
