
Partial Class App_Presentation_VideoUploaden
    Inherits System.Web.UI.Page

    Private adapter As New ManualTableAdapters.tblVideoTableAdapter



    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        Dim adapter As New ManualTableAdapters.tblVideoTableAdapter
        Dim naam As String
        Dim pad As String
        Dim code As String
        Dim fileextension As String
        Dim lengte As Integer
        If FileUpload1.HasFile Then
            lengte = FileUpload1.FileContent.Length
            'If videodal.getVideoByNaam(FileUpload1.FileName) Is Nothing Then
            If lengte < 52428801 Then
                fileextension = System.IO.Path.GetExtension(FileUpload1.FileName)
                naam = FileUpload1.FileName
                pad = "C:\Referencemanual\video\" + FileUpload1.FileName
                If fileextension = ".mov" Then
                    code = "<ASPNetVideo:QuickTime ID=""QuickTime1""" + " runat=""server""" + " AutoPlay=""False""" + " VideoURL=""~/video/" + naam + """ ></ASPNetVideo:QuickTime>"
                    adapter.Insert(naam, pad, code)
                    FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                    lblRes.Text = naam + ", is geüpload."
                    btnVoorbeeld.Style.Add("display", "inline")
                    tipVoorbeeld.Style.Add("display", "inline")
                ElseIf fileextension = ".avi" Then
                    code = "<ASPNetVideo:WindowsMedia ID=""WindowsMedia1""" + "runat=""server""" + " AutoPlay=""False""" + " VideoURL=""~/video/" + naam + "></ASPNetVideo:WindowsMedia>"
                    adapter.Insert(naam, pad, code)
                    FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                    lblRes.Text = naam + ", is geüpload."
                    btnVoorbeeld.Style.Add("display", "inline")
                    tipVoorbeeld.Style.Add("display", "inline")
                ElseIf fileextension = ".wmv" Then
                    code = "<ASPNetVideo:WindowsMedia ID=""WindowsMedia1""" + "runat=""server""" + " AutoPlay=""False""" + " VideoURL=""~/video/" + naam + "></ASPNetVideo:WindowsMedia>"
                    adapter.Insert(naam, pad, code)
                    FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                    lblRes.Text = naam + ", is geüpload."
                    btnVoorbeeld.Style.Add("display", "inline")
                    tipVoorbeeld.Style.Add("display", "inline")
                ElseIf fileextension = ".swf" Then
                    code = "<object height=""480""" + " width=""640""" + "><param name=""movie""" + " value=""../video/" + naam + """/><embed height=""480""" + " src=""../video/" + naam + """ width=""640""" + "></embed></object>"
                    adapter.Insert(naam, pad, code)
                    FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                    lblRes.Text = naam + ", is geüpload."
                    btnVoorbeeld.Style.Add("display", "inline")
                    tipVoorbeeld.Style.Add("display", "inline")
                ElseIf fileextension = ".flv" Then
                    code = "<ASPNetFlashVideo:FlashVideo ID=""FlashVideo1""" + " runat=""server""" + " Autoplay=""false""" + " VideoURL=""~/video/" + naam + " ></ASPNetFlashVideo:FlashVideo>"
                    adapter.Insert(naam, pad, code)
                    FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                    lblRes.Text = naam + ", is geüpload."
                    btnVoorbeeld.Style.Add("display", "inline")
                    tipVoorbeeld.Style.Add("display", "inline")
                Else
                    lblRes.ForeColor = Drawing.Color.Red
                    lblRes.Text = " Enkel mov, wmv, swf en flv bestanden worden ondersteund."
                End If
            Else
                lblRes.ForeColor = Drawing.Color.Red
                lblRes.Text = "Het bestand dat u koos is te groot om te uploaden, kies een bestand kleiner dan 50mb."
            End If
        Else
            lblRes.ForeColor = Drawing.Color.Red
            lblRes.Text = "Er is al een bestand geüpload met deze naam."
        End If
        'Else
        lblRes.ForeColor = Drawing.Color.Red
        lblRes.Text = "U hebt geen bestand geselecteerd."
        'End If
        LaadTooltips()
        vulListbox()
    End Sub

  
    Protected Sub btnVoorbeeld_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoorbeeld.Click
        Dim naam() As String
        naam = lblRes.Text.Split(",")
        Response.Redirect("~/App_Presentation/videoAfspelen.aspx?naam=" + naam(0))
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            vulListbox()
        End If
        If Session("login") = 1 Then
            divLoggedIn.Visible = True
        Else
            divLoggedIn.Visible = False
            Session("vorigePagina") = Page.Request.Url.AbsolutePath
            Response.Redirect("Aanmeldpagina.aspx")
        End If
        LaadTooltips()
    End Sub

    Protected Sub imgbtnView_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgbtnView.Click
        Dim naam As String = ddlVideo.SelectedItem.Text
        Response.Redirect("~/App_Presentation/VideoAfspelen.aspx?naam=" + naam)
    End Sub

    Private Sub LaadTooltips()

        'Nieuwe lijst van tooltips definiëren
        Dim lijst As New List(Of Tooltip)

        lijst.Add(New Tooltip("tipOpslaan", "Klik hier om het geselecteerde bestand op te slaan."))
        lijst.Add(New Tooltip("tipVoorbeeld", "Klik hier om een voorbeeld van uw opgeslagen filmpje te zien."))
        lijst.Add(New Tooltip("tipAfspelen", "Selecteer een video uit deze lijst en klik vervolgens op het TV-icoontje om het af te spelen."))

        'Tooltips op de pagina zetten via scriptmanager als het een postback is, anders gewoon in de onload functie van de body.
        If Page.IsPostBack Then
            Tooltip.VoegTipToeAanEndRequest(Me, lijst)
        Else
            Dim body As HtmlGenericControl = Master.FindControl("MasterBody")
            Tooltip.VoegTipToeAanBody(body, lijst)
        End If

    End Sub

    Protected Sub imgBtnRemove_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgBtnRemove.Click
        If ddlVideo.SelectedItem Is Nothing Then
        Else
            Dim id As Integer = ddlVideo.SelectedValue
            adapter.Delete(ddlVideo.SelectedValue)
            vulListbox()
        End If
    End Sub

    Public Sub vulListbox()
        ddlVideo.Items.Clear()
        Dim dt As Manual.tblVideoDataTable
        dt = adapter.GetData()
        For i As Integer = 0 To dt.Rows.Count - 1
            ddlVideo.Items.Add(New ListItem(dt.Rows(i)("videoNaam"), dt.Rows(i)("videoID")))
        Next
    End Sub
End Class
