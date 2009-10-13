Public Class frmImporteerUitExcel
    Private fdlg_OpenExcel As OpenFileDialog = New OpenFileDialog()
    Private blnGeslaagd As Boolean = False

    'Onze Excel-dataclass
    Private myExcelConnection As clDataViaExcel = New clDataViaExcel


    Private Sub btnExcelBestandOpene_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExcelBestandOpene.Click
        'We willen een Excel-bestand openen.
        fdlg_OpenExcel.Title = "Open Excel-bestand"
        fdlg_OpenExcel.InitialDirectory = Application.StartupPath
        fdlg_OpenExcel.Filter = "Excel-bestanden (.xls)|*.xls"
        fdlg_OpenExcel.FilterIndex = 0
        fdlg_OpenExcel.RestoreDirectory = True

        'Als alles goed is, steken we de bestandslocatie in de tekstbox
        If fdlg_OpenExcel.ShowDialog() = DialogResult.OK Then
            Me.txtExcelBestand.Text = fdlg_OpenExcel.FileName
        End If

    End Sub

    Private Sub txtExcelBestand_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtExcelBestand.TextChanged
        Call CheckConnectie()
    End Sub

    Private Sub txtExcelSheet_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtExcelSheet.TextChanged
        Call CheckConnectie()
    End Sub

    Private Sub CheckConnectie()
        'Deze Sub checkt snel de connectie met het Excel-bestand.

        'Tekst uit form ophalen
        Dim pad As String = Me.txtExcelBestand.Text
        Dim sheet As String = Me.txtExcelSheet.Text

        If (Not pad = String.Empty And Not sheet = String.Empty) Then
            'Als alles correct is in de form, gaan we een test uitvoeren
            Dim connectiegeslaagd As Boolean = False

            'We selecteren 1 rij uit het Excel-bestand.
            'OPGELET: De eerste rij in het Excel-bestand wordt overgeslagen
            'omdat Visual Basic denkt dat deze rij de kolomnamen bevat.
            myExcelConnection.p_mSQLString = String.Concat("SELECT TOP 1 * FROM [", sheet, "$]")

            'Connectiestring maken en doorsturen
            myExcelConnection.p_mConnectionString = String.Concat("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=", pad, ";Extended Properties=Excel 8.0")
            'Connectietest uitvoeren
            connectiegeslaagd = myExcelConnection.f_connectietest()

            If (connectiegeslaagd) Then

                'Als we slagen, gaan we eens testen of deze data in het juiste formaat is
                blnGeslaagd = GetExcelData("TestTable")

                If (blnGeslaagd) Then
                    'De data is in het juiste formaat!
                    Me.pctGeldigFormaat.Image = My.Resources.tick
                    Me.lblGeldigFormaat.Text = "Geldig Formaat"
                    Me.lblGeldigFormaat.ForeColor = Color.ForestGreen
                Else
                    Me.pctGeldigFormaat.Image = My.Resources.remove
                    Me.lblGeldigFormaat.Text = "Ongeldig Formaat"
                    Me.lblGeldigFormaat.ForeColor = Color.Firebrick
                End If
            Else
                Me.pctGeldigFormaat.Image = My.Resources.remove
                Me.lblGeldigFormaat.Text = "Ongeldig Formaat"
                Me.lblGeldigFormaat.ForeColor = Color.Firebrick
                blnGeslaagd = False
            End If
        End If

        Me.btnHaalDataOp.Enabled = blnGeslaagd

    End Sub

    Private Function GetExcelData(ByVal tabelstring As String) As Boolean
        'Deze functie kijkt na of de data in het juiste formaat is om bruikbaar
        'te zijn.

        Try
            'De tijdelijke tabel die we zullen gebruiken.
            Dim tabel As DataTable = myExcelConnection.p_mDatasetExcel.Tables(tabelstring)

            'Datastring is de pure, onopgesplitste waarde van uit de tabel.
            Dim datastring As String

            'DataArray bevat de opgesplitste waardes, maar zit nog vol met lege waardes.
            Dim DataArray(10) As String

            'Deze NaamVoornaamArray zal de naam en voornaam van 1 persoon ontleden.
            'Dit is nodig bij namen zoals "Van Den Borre".
            Dim NaamVoornaamArray(5) As String

            'NaamArray bevat alle namen van het Excel-bestand
            Dim NaamArray(tabel.Rows.Count()) As String
            'VoornaamArray bevat alle voornamen van het Excel-bestand
            Dim VoornaamArray(tabel.Rows.Count()) As String
            'EmailArray bevat alle emails van het Excel-bestand
            Dim EmailArray(tabel.Rows.Count()) As String
            'KlasArray bevat alle klassen van het Excel-bestand
            Dim KlasArray(tabel.Rows.Count()) As String

            'Indices
            'i wordt gebruikt voor de tabelrijen te lezen
            Dim i As Int16
            'r wordt gebruikt in de String arrays
            Dim r As Int16

            'Voor elke rij in de tabel gaan we hierdoor
            For i = 0 To tabel.Rows.Count() - 1
                r = 1

                'We halen de pure string binnen
                datastring = tabel.Rows(i).Item(0).ToString()
                'We splitsen de pure string up (zie frmConfig.vb voor info over Split)
                DataArray = datastring.Split(",")

                'Als de DataArray niet leeg is op de eerste plaats, dan gaan we verder
                If (Not DataArray(0) = String.Empty) Then

                    'We halen het e-mailadres op. Hierin zit ook de naam en voornaam.
                    EmailArray(i) = DataArray(0)

                    'We splitsen EmailArray(i) op in het naamgedeelte en het adresgedeelte
                    NaamVoornaamArray = EmailArray(i).Split("@")

                    'We splitsen het naamgedeelte in naamstukjes
                    NaamVoornaamArray = NaamVoornaamArray(0).Split(".")

                    'Het eerste naamstukje is de voornaam
                    VoornaamArray(i) = NaamVoornaamArray(0)


                    'Het tweede naamstukje is (een deel van) de achternaam
                    NaamArray(i) = NaamVoornaamArray(1)

                    'Als er nog meer naamstukjes zijn, plakken we die achter de achternaam
                    Dim y As Int16 = 2
                    While (y < NaamVoornaamArray.Length())
                        NaamArray(i) = String.Concat(NaamArray(i), " ", NaamVoornaamArray(y))
                        y = y + 1
                    End While

                Else
                    Return False
                End If

                'We slaan al die lege strings over
                While (DataArray(r) = String.Empty)
                    r = r + 1
                End While

                'Als de laatste string (klas) niet leeg is, slaan we ze op in KlasArray
                If (Not DataArray(r) = String.Empty) Then
                    KlasArray(i) = DataArray(r)
                End If
            Next i

            'Als de tabelstring die we hebben meegekregen bij het roepen van
            'de functie gelijk is aan "DataTable", dan hebben we te maken
            'met de echte data, en niet een snelle test.
            If (tabelstring = "DataTable") Then

                'tabel maken om in de datagridview te tonen
                Dim toontabel As DataTable = New DataTable

                'Kolommen toevoegen
                toontabel.Columns.Add("Naam")
                toontabel.Columns.Add("Voornaam")
                toontabel.Columns.Add("Email")
                toontabel.Columns.Add("Klas")

                Dim datarow As DataRow

                'We slaan alle data op in toontabel
                For i = 0 To tabel.Rows.Count() - 1
                    datarow = toontabel.NewRow()

                    datarow.Item("Naam") = NaamArray(i)
                    datarow.Item("Voornaam") = VoornaamArray(i)
                    datarow.Item("Email") = EmailArray(i)
                    datarow.Item("Klas") = KlasArray(i)

                    toontabel.Rows.Add(datarow)
                Next i

                'We binden de data aan de datagridview
                dtgExcelData.DataSource = toontabel
            End If

        Catch ex As Exception
            Return False
        End Try

        Return True

    End Function

    Private Sub HaalExcelDataOp()
        'Deze Sub haalt ALLE data op uit het Excel-bestand.

        Dim sheet As String = Me.txtExcelSheet.Text

        If (blnGeslaagd And Not sheet = String.Empty) Then
            'Als alles goed is, maken we een SQL-query om alles te selecteren.
            myExcelConnection.p_mSQLString = String.Concat("SELECT * FROM [", sheet, "$]")

            'We maken tevens de testtabel leeg om geheugen vrij te maken.
            myExcelConnection.p_mDatasetExcel.Tables("TestTable").Clear()

            'We halen de data binnen van Excel.
            myExcelConnection.f_fill()

            'We proberen de data om te vormen tot een bruikbare tabel.
            Dim succes As Boolean = GetExcelData("DataTable")

            If (succes) Then
                'Als we succesvol zijn, passen we de form aan.
                Me.pctSuccess.Image = My.Resources.tick
                Me.lblSuccess.Text = "Data Opgehaald."
                Me.lblSuccess.ForeColor = Color.ForestGreen
                Me.btnDataOpslaan.Enabled = True
            Else
                Me.pctSuccess.Image = My.Resources.remove
                Me.lblSuccess.Text = "Data Niet Opgehaald."
                Me.lblSuccess.ForeColor = Color.Firebrick
                Me.btnDataOpslaan.Enabled = False
                Me.btnDataOpslaan.Text = "Sla Data Op"
            End If
        Else
            MessageBox.Show("Kon de data niet ophalen.")
            Me.pctSuccess.Image = My.Resources.remove
            Me.lblSuccess.Text = "Data Niet Opgehaald."
            Me.lblSuccess.ForeColor = Color.Firebrick
            Me.btnDataOpslaan.Enabled = False
        End If

    End Sub

    Private Sub btnHaalDataOp_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnHaalDataOp.Click
        Call HaalExcelDataOp()
    End Sub

    Private Sub btnDataOpslaan_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDataOpslaan.Click
        'We hebben op de "Sla Data Op" knop gedrukt.

        'De tabel van de datagridview is de tabel die we zullen steken in onze tbhStudent
        Dim toontabel As DataTable = dtgExcelData.DataSource

        Dim datarow As DataRow
        Dim i As Int16

        For i = 0 To toontabel.Rows.Count() - 1
            'We maken een nieuwe datarow aan die we dan doorsturen naar de SQL-server
            datarow = frmHoofdMenu.mySQLConnection.p_dataset.Tables("tblStudent").NewRow()

            datarow.Item("StudentNaam") = toontabel.Rows(i).Item("Naam")
            datarow.Item("StudentVoornaam") = toontabel.Rows(i).Item("Voornaam")
            datarow.Item("StudentGSM") = "Onbekend"
            datarow.Item("StudentSchoolEmail") = toontabel.Rows(i).Item("Email")
            datarow.Item("StudentPriveEmail") = "Onbekend"
            datarow.Item("StudentGebDat") = CDate("01/01/1980")
            datarow.Item("StudentFinRek") = "Onbekend"

            frmHoofdMenu.mySQLConnection.f_NieuweStudent(datarow)
        Next i

        Me.btnDataOpslaan.Text = "Data Opgeslagen."
        Me.btnDataOpslaan.Enabled = False
    End Sub

    Private Sub SluitenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SluitenToolStripMenuItem.Click
        'Toon het startscherm.
        Call frmHoofdMenu.ToonStartScherm()
    End Sub

End Class