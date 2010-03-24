
Partial Class App_Presentation_VideoUploaden
    Inherits System.Web.UI.Page

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        Dim adapter As New ManualTableAdapters.tblVideoTableAdapter
        Dim naam As String
        Dim pad As String
        Dim code As String
        Dim fileextension As String
        Dim lengte As Integer
        If FileUpload1.HasFile Then
            lengte = FileUpload1.FileContent.Length

            If lengte < 52428801 Then
                fileextension = System.IO.Path.GetExtension(FileUpload1.FileName)
                naam = FileUpload1.FileName
                pad = "C:\Referencemanual\video\" + FileUpload1.FileName
                If fileextension = ".mov" Then
                    code = "<ASPNetVideo:QuickTime ID=""QuickTime1""" + " runat=""server""" + " AutoPlay=""False""" + " VideoURL=""~/video/" + naam + """ ></ASPNetVideo:QuickTime>"
                    adapter.Insert(naam, pad, code)
                    FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                    lblRes.Text = "Uw filmpje is geüpload."
                ElseIf fileextension = ".avi" Then
                    code = "<ASPNetVideo:WindowsMedia ID=""WindowsMedia1""" + "runat=""server""" + " AutoPlay=""False""" + " VideoURL=""~/video/" + naam + "></ASPNetVideo:WindowsMedia>"
                    adapter.Insert(naam, pad, code)
                    FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                    lblRes.Text = "Uw filmpje is geüpload."
                ElseIf fileextension = ".wmv" Then
                    code = "<ASPNetVideo:WindowsMedia ID=""WindowsMedia1""" + "runat=""server""" + " AutoPlay=""False""" + " VideoURL=""~/video/" + naam + "></ASPNetVideo:WindowsMedia>"
                    adapter.Insert(naam, pad, code)
                    FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                    lblRes.Text = "Uw filmpje is geüpload."
                ElseIf fileextension = ".swf" Then
                    code = "<object height=""480""" + " width=""640""" + "><param name=""movie""" + " value=""../video/" + naam + """/><embed height=""480""" + " src=""../video/" + naam + """ width=""640""" + "></embed></object>"
                    adapter.Insert(naam, pad, code)
                    FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                    lblRes.Text = "Uw filmpje is geüpload."
                ElseIf fileextension = ".flv" Then
                    code = "<ASPNetFlashVideo:FlashVideo ID=""FlashVideo1""" + " runat=""server""" + " Autoplay=""false""" + " VideoURL=""~/video/" + naam + " ></ASPNetFlashVideo:FlashVideo>"
                    adapter.Insert(naam, pad, code)
                    FileUpload1.SaveAs("C:\Referencemanual\video\" + FileUpload1.FileName)
                    lblRes.Text = "Uw filmpje is geüpload."
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
            lblRes.Text = "U hebt geen bestand geselecteerd."
        End If


    End Sub

  
End Class
