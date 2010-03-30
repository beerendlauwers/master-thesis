
Partial Class App_Presentation_VideoUploaden
    Inherits System.Web.UI.Page
    Private videodal As New VideoDal
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
            If videodal.getVideoByNaam(FileUpload1.FileName) Is Nothing Then
                If lengte < 52428801 Then
                    fileextension = System.IO.Path.GetExtension(FileUpload1.FileName)
                    naam = FileUpload1.FileName
                    pad = "C:\Referencemanual\video\" + FileUpload1.FileName
                    If fileextension = ".mov" Then
                        code = "<ASPNetVideo:QuickTime ID=""QuickTime1""" + " runat=""server""" + " AutoPlay=""False""" + " VideoURL=""~/video/" + naam + """ ></ASPNetVideo:QuickTime>"
                        adapter.Insert(naam, pad, code)
                        FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                        lblRes.Text = naam + ", is geüpload."
                        btnVoorbeeld.Visible = True
                    ElseIf fileextension = ".avi" Then
                        code = "<ASPNetVideo:WindowsMedia ID=""WindowsMedia1""" + "runat=""server""" + " AutoPlay=""False""" + " VideoURL=""~/video/" + naam + "></ASPNetVideo:WindowsMedia>"
                        adapter.Insert(naam, pad, code)
                        FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                        lblRes.Text = naam + ", is geüpload."
                        btnVoorbeeld.Visible = True
                    ElseIf fileextension = ".wmv" Then
                        code = "<ASPNetVideo:WindowsMedia ID=""WindowsMedia1""" + "runat=""server""" + " AutoPlay=""False""" + " VideoURL=""~/video/" + naam + "></ASPNetVideo:WindowsMedia>"
                        adapter.Insert(naam, pad, code)
                        FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                        lblRes.Text = naam + ", is geüpload."
                        btnVoorbeeld.Visible = True
                    ElseIf fileextension = ".swf" Then
                        code = "<object height=""480""" + " width=""640""" + "><param name=""movie""" + " value=""../video/" + naam + """/><embed height=""480""" + " src=""../video/" + naam + """ width=""640""" + "></embed></object>"
                        adapter.Insert(naam, pad, code)
                        FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                        lblRes.Text = naam + ", is geüpload."
                        btnVoorbeeld.Visible = True
                    ElseIf fileextension = ".flv" Then
                        code = "<ASPNetFlashVideo:FlashVideo ID=""FlashVideo1""" + " runat=""server""" + " Autoplay=""false""" + " VideoURL=""~/video/" + naam + " ></ASPNetFlashVideo:FlashVideo>"
                        adapter.Insert(naam, pad, code)
                        FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                        lblRes.Text = naam + ", is geüpload."
                        btnVoorbeeld.Visible = True
                    Else
                        lblRes.ForeColor = Drawing.Color.Red
                        lblRes.Text = " Enkel mov, wmv, swf en flv bestanden worden ondersteund."
                    End If


                Else
                    lblRes.ForeColor = Drawing.Color.Red
                    lblRes.Text = "Het bestand dat u koos is te groot om te uploaden, kies een bestand kleiner dan 50mb."
                End If
            Else
                lblRes.Text = "Er is al een bestand geüpload met deze naam."
            End If
        Else
            lblRes.ForeColor = Drawing.Color.Red
            lblRes.Text = "U hebt geen bestand geselecteerd."
        End If


    End Sub

  
    Protected Sub btnVoorbeeld_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoorbeeld.Click
        Dim naam() As String
        naam = lblRes.Text.Split(",")

        Response.Redirect("~/App_Presentation/videoAfspelen.aspx?naam=" + naam(0))
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim dt As Manual.tblVideoDataTable
        dt = adapter.GetData()
        If Not IsPostBack Then
            For i As Integer = 0 To dt.Rows.Count - 1
                Dim listitem As New ListItem(dt.Rows(i)("videoNaam"), dt.Rows(i)("videoID"))
                lstVideo.items.add(listitem)
            Next
        End If
        lstVideo.selectedIndex = 0

        If Session("login") = 1 Then

            divLoggedIn.Visible = True
        Else
            divLoggedIn.Visible = False
            lblLogin.Visible = True
            lblLogin.Text = "U bent niet ingelogd."
            ImageButton1.Visible = True
        End If

    End Sub

    Protected Sub imgbtnView_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgbtnView.Click
        If lstVideo.selecteditem Is Nothing Then

        Else
            Dim naam As String = lstVideo.selecteditem.text
            Response.Redirect("~/App_Presentation/VideoAfspelen.aspx?naam=" + naam)
        End If
    End Sub

    Protected Sub ImageButton1_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton1.Click
        Response.Redirect("Aanmeldpagina.aspx")
    End Sub
End Class
