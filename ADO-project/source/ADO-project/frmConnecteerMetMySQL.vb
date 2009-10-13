Imports System.Text.RegularExpressions

Public Class frmConnecteerMetMySQL
    Private mTekst(5) As String

    Private Sub SluitenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SluitenToolStripMenuItem.Click
        frmHoofdMenu.ToonStartScherm()
    End Sub

    Private Sub txtMySQLServer_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtMySQLServer.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub txtMySQLDatabase_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtMySQLDatabase.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub txtMySQLGebruiker_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtMySQLGebruiker.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub txtMySQLPaswoord_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtMySQLPaswoord.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub txtMySQLTabel_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtMySQLTabel.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub txtMySQLKolom_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtMySQLKolom.TextChanged
        Call UpdateTekst()
        Call TestDatabaseConnection()
    End Sub

    Private Sub txtDataInvoer_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtDataInvoer.TextChanged
        Dim tekst(0) As String
        tekst(0) = Me.txtDataInvoer.Text
        CheckVoorSpecialeKarakters(tekst)
    End Sub

    Private Sub btnDataToevoegen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDataToevoegen.Click
        If (Not Me.txtDataInvoer.Text = String.Empty) Then
            Me.lstTestData.Items.Add(Me.txtDataInvoer.Text)
            Call CheckDataInvoegenButton()
        End If
    End Sub

    Private Sub btnDataInvoegen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDataInvoegen.Click
        Dim connectionstring As String
        connectionstring = String.Concat("Server=", Me.txtMySQLServer.Text, ";Uid=", Me.txtMySQLGebruiker.Text, ";Pwd=", Me.txtMySQLPaswoord.Text, ";Database=", Me.txtMySQLDatabase.Text)

        'De insert queries opstellen.
        Dim insertlist(Me.lstTestData.Items.Count()) As String

        Dim i As Int16
        For i = 0 To Me.lstTestData.Items.Count() - 1
            insertlist(i) = String.Concat("INSERT INTO ", Me.txtMySQLTabel.Text, "(", Me.txtMySQLKolom.Text, ") VALUES ('", Me.lstTestData.Items(i), "')")
        Next i

        Dim tabel As DataTable = frmHoofdMenu.mySQLConnection.f_VulInEnHaalOp(insertlist, connectionstring, mTekst)
        If (tabel.Rows.Count() > 0) Then
            Me.btnDataInvoegen.Enabled = False
            Me.dtgDataMySQL.DataSource = tabel.DefaultView
            Me.picOphaalGeldig.Image = My.Resources.tick
            Me.lblOphaalGeldig.Text = "Data Opgehaald"
            Me.lblOphaalGeldig.ForeColor = Color.ForestGreen
        Else
            Me.btnDataInvoegen.Enabled = True
            Me.picOphaalGeldig.Image = My.Resources.remove
            Me.lblOphaalGeldig.Text = "Data Niet Opgehaald"
            Me.lblOphaalGeldig.ForeColor = Color.Firebrick
        End If
    End Sub

    Private Sub TestDatabaseConnection()

        Dim connectionstring As String
        If (CheckVoorSpecialeKarakters(mTekst)) Then
            connectionstring = String.Concat("Server=", Me.txtMySQLServer.Text, ";Uid=", Me.txtMySQLGebruiker.Text, ";Pwd=", Me.txtMySQLPaswoord.Text, ";Database=", Me.txtMySQLDatabase.Text, ";Connect Timeout=1")
            Dim geslaagd As Boolean = frmHoofdMenu.mySQLConnection.f_VerbindingMetMysql(connectionstring, mTekst)

            If (geslaagd) Then
                Me.lblConnectieGeldig.Text = "Geldig"
                Me.lblConnectieGeldig.ForeColor = Color.ForestGreen
                Me.picConnectieGeldig.Image = My.Resources.tick
                Call CheckDataInvoegenButton()
            Else
                Me.lblConnectieGeldig.Text = "Ongeldig"
                Me.lblConnectieGeldig.ForeColor = Color.Firebrick
                Me.picConnectieGeldig.Image = My.Resources.remove
            End If
        Else
        Me.lblConnectieGeldig.Text = "Ongeldig"
        Me.lblConnectieGeldig.ForeColor = Color.Firebrick
        Me.picConnectieGeldig.Image = My.Resources.remove
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
        mTekst(0) = Me.txtMySQLServer.Text
        mTekst(1) = Me.txtMySQLDatabase.Text
        mTekst(2) = Me.txtMySQLGebruiker.Text
        mTekst(3) = Me.txtMySQLPaswoord.Text
        mTekst(4) = Me.txtMySQLTabel.Text
        mTekst(5) = Me.txtMySQLKolom.Text
    End Sub

    Private Sub CheckDataInvoegenButton()
        If (Me.lstTestData.Items.Count > 0) Then
            Me.btnDataInvoegen.Enabled = True
        Else
            Me.btnDataInvoegen.Enabled = False
        End If
    End Sub
End Class