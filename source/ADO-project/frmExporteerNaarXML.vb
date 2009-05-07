Imports System.Xml
Imports System.IO

Public Class frmExporteerNaarXML

    Private Sub btnBestandslocatie_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBestandslocatie.Click
        'We hebben op de "Selecteer..." knop gedrukt om een bestandsnaam te kiezen.
        Try
            Dim xmlopslaan As New SaveFileDialog
            With xmlopslaan
                .DefaultExt = "cfg"
                .FileName = "deelnameoverzicht_xml"
                .Filter = "XML-bestanden (*.xml)|*.xml|Alle bestanden (*.*)|*.*"
                .FilterIndex = 1
                .OverwritePrompt = True
                .Title = "XML-Bestand selecteren"
            End With

            'Als alles goed is, plakken we deze bestandslocatie in de tekstbox
            If xmlopslaan.ShowDialog = DialogResult.OK Then
                Me.txtBestandsLocatie.Text = xmlopslaan.FileName
            End If
        Catch ex As Exception
            Throw ex
        End Try

    End Sub

    Private Sub btnDataExporteren_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDataExporteren.Click
        'We hebben gedrukt op "Data Exporteren"

        'We halen de meest recente deelnamedata op van de SQL-server.
        Dim blngeslaagd = frmHoofdMenu.mySQLConnection.f_HaalDeelnameDataOp()


        If (blngeslaagd And Not Me.txtBestandsLocatie.Text = String.Empty) Then
            'Als alles goed is, dan kopiëren we de deelnametabel over naar xmltabel
            Dim xmltabel As DataTable = frmHoofdMenu.mySQLConnection.p_dataset.Tables("tblDeelname")
            Dim datarow As DataRow
            Dim i As Int16

            'We zullen nu proberen het XML-bestand te schrijven.
            Try
                Dim instellingen As New XmlWriterSettings
                'indenteer de XML-data
                instellingen.Indent = True
                'elk attribuut op een nieuwe lijn
                instellingen.NewLineOnAttributes = True

                'Een XMLWriter kan gemakkelijk XML schrijven.
                Dim xm As XmlWriter = XmlWriter.Create(Me.txtBestandsLocatie.Text, instellingen)

                xm.WriteStartDocument(True)

                'We zetten de creatiedatum in het bestand in commentaar
                xm.WriteComment("Gemaakt op " & DateTime.Now.ToString("hh:mm:ss"))

                'deelname is de root node.
                xm.WriteStartElement("deelname")

                'Voor elke student slaan we zijn naam, sport en niveau op.
                'Deze data halen we uit een DataRow die we uit xmltabel halen.
                For i = 0 To xmltabel.Rows.Count() - 1

                    'student is de child node die wij gebruiken.
                    xm.WriteStartElement("student")

                    datarow = xmltabel.Rows(i)
                    xm.WriteStartElement("naam")
                    xm.WriteValue(datarow.Item("StudentNaam"))
                    xm.WriteEndElement()

                    xm.WriteStartElement("sport")
                    xm.WriteValue(datarow.Item("SportNaam"))
                    xm.WriteEndElement()

                    xm.WriteStartElement("niveau")
                    xm.WriteValue(datarow.Item("Niveau"))
                    xm.WriteEndElement()

                    'we sluiten onze child node student.
                    xm.WriteEndElement()

                Next i

                'we sluiten onze root node deelname.
                xm.WriteEndDocument()

                'we sluiten het XML-bestand.
                xm.Close()

                'We passen de info rechtsonder in de form aan.
                Me.pctExported.Image = My.Resources.tick
                Me.lblExported.Text = "Data Geëxporteerd"
                Me.lblExported.ForeColor = Color.ForestGreen
                Me.btnDataExporteren.Enabled = False

            Catch ex As Exception

                MsgBox(ex.Message)
                Me.pctExported.Image = My.Resources.remove
                Me.lblExported.Text = "Niet Geëxporteerd"
                Me.lblExported.ForeColor = Color.Firebrick
                Me.btnDataExporteren.Enabled = True

            End Try

        Else
            MsgBox("Kon de data niet ophalen.")
        End If
    End Sub

    Private Sub txtBestandsLocatie_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtBestandsLocatie.TextChanged

        If (Me.txtBestandsLocatie.Text = String.Empty) Then
            Me.btnDataExporteren.Enabled = False
        Else
            Me.btnDataExporteren.Enabled = True
        End If

    End Sub

    Private Sub SluitenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SluitenToolStripMenuItem.Click
        'Toon het startscherm.
        Call frmHoofdMenu.ToonStartScherm()
    End Sub
End Class