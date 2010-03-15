
Partial Class App_Presentation_verwijderenTekst
    Inherits System.Web.UI.Page
    Private artikel As New ArtikelDAL
    
    Protected Sub btnZoek_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZoek.Click
        Dim str As String
        Dim dt As New Data.DataTable
        Dim dr As Data.DataRow = dt.NewRow
        Dim titel As String = txtSearch.Text
        Dim tekst As String = txtSearchText.Text
        If titel.Length > 0 Then
            str = "%" + txtSearch.Text + "%"
            dt = artikel.GetArtikelsByTitel(str)
            Dim tf As New TemplateField
            'GridView1.DataSource = dt
            'GridView1.Columns.Add(tf)
            'GridView1.DataBind()
            For Each dr In dt.Rows

                If zoektext(str, dt.Rows(0)("tekst")) = True Then
                    Exit For
                Else

                End If
            Next
            ListBox1.Items.Clear()
            For Each dr In dt.Rows
                ListBox1.Items.Add(dr("titel"))
            Next
        Else
            str = """" + txtSearchText.Text + """"
            'lblWut.Text = str
            dt = artikel.GetArtikelsByTekst(str)
            Dim tf As New TemplateField
            'GridView1.DataSource = dt
            'GridView1.Columns.Add(tf)
            'GridView1.DataBind()
            ListBox1.Items.Clear()
            For Each dr In dt.Rows
                Dim item As New ListItem(dr("titel"), dr("artikelID"))
                ListBox1.Items.Add(item)
            Next
        End If

    End Sub

    Public Function zoektext(ByVal text As String, ByVal str As String) As Boolean
        Dim stri As String = str
        Dim txt As String = text
        Dim reeks(50) As String
        Dim teller As Integer
        Dim test As String = " "
        reeks(0) = test
        For t As Integer = 0 To stri.Length()
            reeks = text.Split(" ")
            teller = teller + 1
        Next
        Dim teller1 As Integer = reeks.Length - 1
        For t As Integer = 0 To teller1 - 1
            test = test + reeks(t)
        Next
        'lblWut.Text = test
        'Dim re1 As String = ".*?" 'Non-greedy match on filler
        'Dim re2 As String = reeks(0)   'Word 1
        'Dim re3 As String = "( )" 'White Space 1
        'Dim re4 As String = reeks(1)    'Word 2
        'Dim re5 As String = "( )" 'White Space 2
        'Dim re6 As String = reeks(2)   'Word 3
        'Dim re7 As String = "( )" 'White Space 3
        'Dim re8 As String = reeks(3)  'Word 4
        'Dim re9 As String = "(!)" 'Any Single Character 1

        'Dim r As Regex = New Regex(re1 + re2 + re3 + re4 + re5 + re6 + re7 + re8 + re9, RegexOptions.IgnoreCase Or RegexOptions.Singleline)
        'Dim m As Match = r.Match(txt)
        'If (m.Success) Then
        '    lblWut.Text = str
        '    Return True
        'Else
        '    Return False
        'End If
        Return True
    End Function

    Protected Sub btnVerwijder_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVerwijder.Click
        Dim artikelID As Integer = ListBox1.SelectedValue
        lblWut.Text = artikelID.ToString()

    End Sub
End Class
