
Partial Class App_Presentation_VideoAfspelen
    Inherits System.Web.UI.Page
    Private videodal As New VideoDal

    Protected Sub btnPlay_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnPlay.Click

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
            QuickTime2.Style.Add("vertical-align", "top")
            Dim browserversie = Request.Browser.Browser()
            
            If browserversie = "IE" Then
                lblHelp.Text = "U kunt best Firefox of Chrome gebruiken om deze video te bekijken."
            End If
        ElseIf ext(ext.GetLength(0) - 1) = "swf" Then
            Dim htmlcode As String = dt.Rows(0)("videoCode")
            Dim div As HtmlGenericControl = film
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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    
End Class
