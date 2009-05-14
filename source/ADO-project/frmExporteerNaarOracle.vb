Imports System.Text.RegularExpressions

Public Class frmExporteerNaarOracle
    Private myOracleConnection As clDataViaOracle = New clDataViaOracle
    Private mTekst(4) As String

    Private Sub frmExporteerNaarOracle_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'De SQL Listbox vullen.
        Dim i As Int16
        For i = 0 To frmHoofdMenu.mySQLConnection.p_dataset.Tables("tblSport").Rows.Count() - 1
            Me.lstSQLData.Items.Add(frmHoofdMenu.mySQLConnection.p_dataset.Tables("tblSport").Rows(i).Item("SportNaam").ToString)
        Next i
    End Sub

    Private Sub SluitenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SluitenToolStripMenuItem.Click
        frmHoofdMenu.ToonStartScherm()
    End Sub

    Private Sub txtOracleServer_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtOracleServer.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub txtOracleGebruiker_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtOracleGebruiker.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub txtOraclePaswoord_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtOraclePaswoord.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub txtOracleTabel_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtOracleTabel.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub txtOracleKolom_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtOracleKolom.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub btnTestConnectie_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnHaalDataOp.Click
        If (Not Me.txtOracleServer.Text = String.Empty) Then

            Dim blngeslaagd As Boolean
            blngeslaagd = myOracleConnection.f_HaalOracleDataOp()

            If (blngeslaagd) Then
                Dim temptabel As DataTable = myOracleConnection.p_dataset.Tables("OracleTable")

                'De Oracle Listbox vullen.
                Dim i As Int16
                Me.lstOracleData.Items.Clear()
                For i = 0 To temptabel.Rows.Count() - 1
                    Me.lstOracleData.Items.Add(temptabel.Rows(i).Item(0).ToString)
                Next i

                'De Verschil Listbox vullen.
                Me.lstVerschil.Items.Clear()
                Me.lstVerschil.Items.AddRange(Me.lstSQLData.Items)

                Dim x As Int16
                Dim y As Int16

                'Een offset is nodig omdat we iets uit de verschilllistbox verwijderen.
                Dim offset As Int16 = 0
                'Vergelijken
                For x = 0 To (lstSQLData.Items.Count - 1)
                    For y = 0 To (lstOracleData.Items.Count - 1)
                        'Als dit waar is, zit de sport in beide listboxes.
                        'Dus we gaan hem 'verwijderen' uit onze Verschillijst.
                        If (String.Compare(lstSQLData.Items(x), lstOracleData.Items(y), False) = 0) Then
                            Me.lstVerschil.Items.RemoveAt(x - offset)
                            offset = offset + 1
                        End If
                    Next y
                Next x

                If (Me.lstVerschil.Items.Count > 0) Then
                    Me.btnImporteerOracle.Enabled = True
                Else
                    Me.btnImporteerOracle.Enabled = False
                End If

            End If
        End If
    End Sub

    Private Sub btnImporteerOracle_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImporteerOracle.Click

        'De insert queries opstellen.
        Dim insertlist(Me.lstVerschil.Items.Count()) As String

        Dim i As Int16
        For i = 0 To Me.lstVerschil.Items.Count() - 1
            insertlist(i) = String.Concat("INSERT INTO ", Me.txtOracleTabel.Text, " (", Me.txtOracleKolom.Text, ") VALUES ('", Me.lstVerschil.Items(i), "')")
        Next i

        Dim geslaagd As Boolean = myOracleConnection.f_VulOracleMetNieuweSporten(insertlist)
        If (geslaagd) Then
            Me.btnImporteerOracle.Enabled = False
            Me.picDataOpgehaald.Image = My.Resources.tick
            Me.lblDataOpgehaald.Text = "Data Geïmporteerd"
            Me.lblDataOpgehaald.ForeColor = Color.ForestGreen
        Else
            Me.btnImporteerOracle.Enabled = True
            Me.picDataOpgehaald.Image = My.Resources.remove
            Me.lblDataOpgehaald.Text = "Data Niet Geïmporteerd"
            Me.lblDataOpgehaald.ForeColor = Color.Firebrick
        End If
    End Sub

    Private Sub TestDatabaseConnection()

        Dim connectionstring As String
        Dim sqlstring As String

        connectionstring = String.Concat("Provider=OraOLEDB.Oracle;Data Source=", Me.txtOracleServer.Text, ";User Id=", Me.txtOracleGebruiker.Text, ";Password=", Me.txtOraclePaswoord.Text)
        myOracleConnection.p_mConnectionString = connectionstring

        sqlstring = String.Concat("SELECT ", Me.txtOracleKolom.Text, " FROM ", Me.txtOracleTabel.Text, ";")
        myOracleConnection.p_mSQLString = sqlstring

        If (CheckVoorSpecialeKarakters(mTekst)) Then
            Dim blngeslaagd As String = myOracleConnection.f_TestOracleConnectie(Me.txtOracleTabel.Text, Me.txtOracleKolom.Text)
            If (blngeslaagd) Then
                Me.btnHaalDataOp.Enabled = True
            Else
                Me.btnHaalDataOp.Enabled = False
            End If
        Else
            Me.btnHaalDataOp.Enabled = False
        End If
    End Sub

    Private Function CheckVoorSpecialeKarakters(ByVal tekst() As String) As Boolean
        Dim tekens As String = String.Concat("[", ControlChars.Quote, "']")
        Dim i As Int16
        For i = 0 To tekst.Length() - 1
            If (tekst(i).Length > 0) Then

                Dim gevonden As Match = Regex.Match(tekst(i), tekens)
                If (gevonden.Success) Then
                    Return False
                End If
            Else
                Return False
            End If
        Next
        Return True

    End Function

    Private Sub UpdateTekst()
        mTekst(0) = Me.txtOracleServer.Text
        mTekst(1) = Me.txtOracleGebruiker.Text
        mTekst(2) = Me.txtOraclePaswoord.Text
        mTekst(3) = Me.txtOracleTabel.Text
        mTekst(4) = Me.txtOracleKolom.Text
    End Sub
End Class