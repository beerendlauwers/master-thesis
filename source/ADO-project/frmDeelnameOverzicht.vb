Public Class frmDeelnameOverzicht

    Private Sub frmDeelnameOverzicht_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'We halen de recentste deelnamedata op van de SQL-server
        Dim blngeslaagd = frmHoofdMenu.mySQLConnection.f_HaalDeelnameDataOp()

        If (blngeslaagd) Then
            dgrDoetSport.DataSource = frmHoofdMenu.mySQLConnection.p_dataset.Tables("tblDeelname")
            f_VulNaamFilter(frmHoofdMenu.mySQLConnection.p_dataset.Tables("tblDeelname"), "StudentNaam", "StudentNaam")
        Else
            MsgBox("Kon de data niet ophalen.")
        End If

    End Sub

    Private Sub cboFilter_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboFilter.TextChanged
        'We passen de rowfilter op tblDeelname aan omdat we de filtercombobox hebben veranderd.
        frmHoofdMenu.mySQLConnection.p_dataset.Tables("tblDeelname").DefaultView.RowFilter = "StudentNaam='" + Me.cboFilter.Text + "'"
    End Sub

    Private Sub f_VulNaamFilter(ByVal tabel As DataTable, ByVal displaymember As String, ByVal valuemember As String)

        Dim checknaam As String
        Dim checknaam2 As String
        Dim geldigenamen(tabel.Rows.Count()) As String
        Dim i As Int16
        Dim r As Int16

        'String array opvullen met data uit DataTable
        For i = 0 To (tabel.Rows.Count() - 1)
            geldigenamen(i) = tabel.Rows(i).Item(displaymember).ToString()
        Next i

        'Die DataTable hebben we niet meer nodig.
        tabel.Dispose()

        'We zullen door middel van slim gebruik van for en while loops
        'zo snel mogelijk door de String array gaan.

        'STAP 1: We zoeken een geldige (= niet lege) naam op in de array.
        'Als de plaats waarop 'i' staat leeg is, kunnen we verder gaan.
        'Impliciet betekent dit dat alle plaatsen voor 'i' nooit meer
        'zullen gecheckt worden, zoals we later zullen zien.
        'Als we een geldige naam vinde, steken we hem in 'checknaam'.
        For i = 0 To (geldigenamen.Length() - 1)
            While i < geldigenamen.Length() - 1
                If (geldigenamen(i) = String.Empty) Then
                    i = i + 1
                Else
                    checknaam = geldigenamen(i)
                    Exit While
                End If
            End While

            'STAP 2: We hebben een geldige naam gevonden. Nu gaan we door de
            'rest van de array stappen met 'r'. 'r' begint als 'i'+1. Hierdoor
            'slaan we de strings voor 'i' over. In deze for loop wordt er gecheckt
            'voor dubbele namen.
            For r = i + 1 To (geldigenamen.Length() - 1)

                While r < geldigenamen.Length() - 1
                    'Als de plaats in de array al leeg is, gaan we naar de volgende plaats
                    If (geldigenamen(r) = String.Empty) Then
                        r = r + 1
                    Else
                        'Anders nemen we de naam uit de array en steken ze in 'checknaam2'
                        checknaam2 = geldigenamen(r)
                        'Dan vergelijken we beide namen
                        If (checknaam = checknaam2) Then
                            'Indien ze gelijk zijn, dan maken we deze plaats in de array leeg
                            geldigenamen(r) = String.Empty
                        End If
                        Exit While
                    End If
                End While

            Next r
        Next i

        'Onze Combobox vullen.
        For i = 0 To geldigenamen.Length() - 1
            If Not geldigenamen(i) = String.Empty Then
                Me.cboFilter.Items.Add(geldigenamen(i))
            End If
        Next i

        'Nog wat Combobox waardes
        Me.cboFilter.SelectedIndex = 0
        Me.cboFilter.DisplayMember = displaymember
        Me.cboFilter.ValueMember = valuemember
    End Sub
End Class