Public Class frmListbox

    
    Private Sub frmListbox_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'Tijdelijke Datatables waaruit we de e-mails gaan halen, opvullen
        Dim tblSQL As DataTable = frmHoofdMenu.mySQLConnection.p_dataset.Tables("tblStudent")
        Dim tblAccess As DataTable = frmHoofdMenu.myAccessConnection.p_datatAccess

        'Twee arrays van Strings voor de emails
        Dim EmailsVanAccess(tblAccess.Rows.Count()) As String
        'EmailsVanSQL krijgt tweemaal zoveel ruimte
        'omdat we schoolmail EN privemail moeten vergelijken
        Dim EmailsVanSQL(tblSQL.Rows.Count() * 2) As String

        'Indices
        Dim i As Integer = 0
        Dim r As Integer = 0

        'Emails uit Access ophalen
        If (tblAccess.Rows.Count() > 0) Then
            'De - 1 zorgt ervoor dat ge niet uit de array gaat (we beginnen immers van 0)
            For i = 0 To (tblAccess.Rows.Count() - 1)
                EmailsVanAccess(i) = tblAccess.Rows(i).Item("Email").ToString()
            Next i
        End If

        'Emails uit SQL ophalen: zowel schoolmail als privemail
        If (tblSQL.Rows.Count() > 0) Then
            For i = 0 To (tblSQL.Rows.Count() - 1)
                EmailsVanSQL(r) = tblSQL.Rows(i).Item("StudentSchoolEmail").ToString()
                r = r + 1
                EmailsVanSQL(r) = tblSQL.Rows(i).Item("StudentPriveEmail").ToString()
                r = r + 1
            Next
        End If

        'De array van Strings die we in onze listbox zullen steken.
        'Standaard nemen we aan dat alle e-mails in Access niet in SQL steken.
        Dim EnkelInAccess(tblAccess.Rows.Count()) As String
        EnkelInAccess = EmailsVanAccess

        Dim x As Integer = 0
        Dim y As Integer = 0

        'Vergelijken
        For x = 0 To (EmailsVanAccess.Length() - 1)
            For y = 0 To (EmailsVanSQL.Length() - 1)
                'Als dit waar is, zit de e-mail in beide databases.
                'Dus we gaan hem 'verwijderen' uit onze EnkelInAccess lijst.
                'Hierna kunnen we naar de volgende e-mail uit Access gaan.
                If (String.Compare(EmailsVanAccess(x), EmailsVanSQL(y), True) = 0) Then
                    EnkelInAccess(x) = String.Empty
                    Exit For
                End If
            Next y
        Next x

        'In Listbox steken
        For i = 0 To (EnkelInAccess.Length() - 1)
            'Als er een e-mail in EnkelInAcces(i) zit, dan zetten we het in de listbox
            'String.Compare retourneert -1 als waarde1 kleiner is dan waarde2
            '(wat nooit gebeurt in ons geval)
            'Het retourneert 0 als waarde1 gelijk is aan waarde2
            '(wat gebeurt als de e-mail 'verwijderd' is)
            'Het retourneert 1 als waarde1 groter is dan waarde2
            '(wat gebeurt als de e-mail niet 'verwijderd' is)
            'Enkel bij een positieve waarde (groter dan 0) gaan we in de If
            If (String.Compare(EnkelInAccess(i), String.Empty)) Then
                lstEmail.Items.Add(EnkelInAccess(i))
            End If
        Next i

    End Sub
End Class