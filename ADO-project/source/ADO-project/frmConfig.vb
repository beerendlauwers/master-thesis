Imports System.IO
Imports System.Text.RegularExpressions

Public Class frmConfig
    'Dialoogvensters. Ze staan hier zodat ze onze geselecteerde folder onthouden
    Private fdlg_OpenConfig As OpenFileDialog = New OpenFileDialog()
    Private fdlg_Access As OpenFileDialog = New OpenFileDialog()

    Private Sub frmStart_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'We nemen aan dat SQL standaard Integrated Security gebruikt
        Me.chkIntegratedSecurity.Checked = True

        'We proberen de lokale config.cfg te laden.
        Dim Data As String
        Dim objReader As StreamReader
        Try
            objReader = New StreamReader("config.cfg")
            Data = objReader.ReadToEnd()
            objReader.Close()
            InsertConfig(Data)
        Catch Ex As Exception
        End Try
    End Sub

    Private Sub chkIntegratedSecurity_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkIntegratedSecurity.CheckedChanged
        'Als we "Integrated Security" aan- of uitklikken, moeten we deze controls aanpassen
        Me.txtSQLGebruiker.Text = String.Empty
        Me.txtSQLGebruiker.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.lblSQLGebruiker.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.txtSQLPaswoord.Text = String.Empty
        Me.txtSQLPaswoord.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.lblSQLPaswoord.Enabled = Not Me.chkIntegratedSecurity.Checked
    End Sub

    Private Sub CheckSQLconnectie()
        'Tekst van form binnenhalen
        Dim server As String = Me.txtSQLServer.Text
        Dim database As String = Me.txtSQLDatabase.Text
        Dim gebruiker As String = Me.txtSQLGebruiker.Text
        Dim paswoord As String = Me.txtSQLPaswoord.Text
        Dim integratedsecurity As Boolean = Me.chkIntegratedSecurity.Checked

        If database = String.Empty Or server = String.Empty Or _
        (integratedsecurity = False And (gebruiker = String.Empty Or database = String.Empty)) Then
            Me.lblSQLGeldig.Text = "Ongeldig"
            Me.lblSQLGeldig.ForeColor = Color.Firebrick
            Me.picSQLGeldig.Image = ADO_project.My.Resources.remove
        Else
            'Als alles op het form geldig is, kunnen we een connectietest uitvoeren
            Dim blnGeslaagd As Boolean = False

            Dim connectietest As clDataViaSql = New clDataViaSql

            'SQL-connectietest. Deze test probeert een tabel aan te maken en ze dan te verwijderen.
            blnGeslaagd = connectietest.f_TestSQL(server, database, gebruiker, paswoord, integratedsecurity)

            'Indien we slagen, passen we de "geldig" tekst en image aan.
            If (blnGeslaagd) Then
                Me.lblSQLGeldig.Text = "Geldig"
                Me.lblSQLGeldig.ForeColor = Color.ForestGreen
                Me.picSQLGeldig.Image = ADO_project.My.Resources.tick
                Me.chkSQLOpslaan.Checked = True
            Else
                Me.lblSQLGeldig.Text = "Ongeldig"
                Me.lblSQLGeldig.ForeColor = Color.Firebrick
                Me.picSQLGeldig.Image = ADO_project.My.Resources.remove
            End If

            'Schoonmaken
            connectietest = Nothing
        End If
    End Sub

    Private Sub CheckAccessConnectie()
        'Tekst van form binnenhalen
        Dim database As String = Me.txtAccessBestand.Text
        Dim tabel As String = Me.txtAccessTabel.Text
        Dim kolom As String = Me.txtAccessKolom.Text

        If (database = String.Empty Or tabel = String.Empty Or kolom = String.Empty) Then
            Me.lblAccessGeldig.Text = "Ongeldig"
            Me.lblAccessGeldig.ForeColor = Color.Firebrick
            Me.picAccessGeldig.Image = ADO_project.My.Resources.remove
        Else
            'Als alles op het form geldig is, kunnen we een connectietest uitvoeren
            Dim blnGeslaagd As Boolean = False

            Dim connectietest As clDataViaAccess = New clDataViaAccess

            'Access-connectietest. Deze test haalt 1 rij uit de database.
            blnGeslaagd = connectietest.f_TestAccess(database, tabel, kolom)

            'Indien we slagen, passen we de "geldig" tekst en image aan.
            If (blnGeslaagd) Then
                Me.lblAccessGeldig.Text = "Geldig"
                Me.lblAccessGeldig.ForeColor = Color.ForestGreen
                Me.picAccessGeldig.Image = ADO_project.My.Resources.tick
                Me.chkAccessOpslaan.Checked = True
            Else
                Me.lblAccessGeldig.Text = "Ongeldig"
                Me.lblAccessGeldig.ForeColor = Color.Firebrick
                Me.picAccessGeldig.Image = ADO_project.My.Resources.remove
            End If

            'Schoonmaken
            connectietest = Nothing
        End If

    End Sub

    Private Sub btnAccessOpenen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAccessOpenen.Click
        'We willen een Access bestand openen
        fdlg_Access.Title = "Open MS Access Database"
        fdlg_Access.InitialDirectory = Application.StartupPath
        fdlg_Access.Filter = "MS Access DataBase (.mdb)|*.mdb"
        fdlg_Access.FilterIndex = 0
        fdlg_Access.RestoreDirectory = True

        'Als alles in orde is, plaatsen we de bestandslocatie in de tekstbox
        If fdlg_Access.ShowDialog() = DialogResult.OK Then
            Me.txtAccessBestand.Text = fdlg_Access.FileName
        End If
    End Sub

    Private Sub txtAccessBestand_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtAccessBestand.TextChanged
        CheckAccessConnectie()
    End Sub

    Private Sub txtAccessTabel_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtAccessTabel.TextChanged
        CheckAccessConnectie()
    End Sub

    Private Sub txtAccessKolom_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtAccessKolom.TextChanged
        CheckAccessConnectie()
    End Sub


    Private Function GetConfig() As String
        'Deze functie creërt een configuratiestring die we opslaan in een tekstbestand.

        'Tekst van form binnenhalen
        Dim Data As String = String.Empty
        Dim sqlserver As String = String.Empty
        Dim sqldatabase As String = String.Empty
        Dim sqlgebruiker As String = String.Empty
        'Dim sqlpaswoord As String = String.Empty
        Dim sqlintegratedsecurity As String = String.Empty
        Dim accessdatabase As String = String.Empty
        Dim accesstabel As String = String.Empty
        Dim accesskolom As String = String.Empty

        'Nakijken of de gebruiker SQL-instellingen wil opslaan
        If (Me.chkSQLOpslaan.Checked) Then
            sqlserver = Me.txtSQLServer.Text
            sqldatabase = Me.txtSQLDatabase.Text
            sqlgebruiker = Me.txtSQLGebruiker.Text
            'sqlpaswoord  = Me.txtSQLPaswoord.Text
            sqlintegratedsecurity = Me.chkIntegratedSecurity.Checked.ToString
        End If

        'Nakijken of de gebruiker Access-instellingen wil opslaan
        If (Me.chkAccessOpslaan.Checked) Then
            accessdatabase = Me.txtAccessBestand.Text
            accesstabel = Me.txtAccessTabel.Text
            accesskolom = Me.txtAccessKolom.Text
        End If

        'Als de tekstwaardes leeg zijn, zetten we een "0" in de plaats.
        'Op deze manier kunnen we lege waardes herkennen als we de config
        'terug laden.
        If sqlserver = String.Empty Then
            sqlserver = "0"
        End If
        If sqldatabase = String.Empty Then
            sqldatabase = "0"
        End If
        If sqlgebruiker = String.Empty Then
            sqlgebruiker = "0"
        End If
        'If sqlpaswoord = String.Empty Then
        'sqlpaswoord = "0"
        'End If
        If sqlintegratedsecurity = String.Empty Then
            sqlintegratedsecurity = "False"
        End If

        If accessdatabase = String.Empty Then
            accessdatabase = "0"
        End If
        If accesstabel = String.Empty Then
            accesstabel = "0"
        End If
        If accesskolom = String.Empty Then
            accesskolom = "0"
        End If

        'De configuratiestring maken.
        Data = String.Concat(sqlserver, ";", sqldatabase, ";", sqlgebruiker, ";", sqlintegratedsecurity, ";", accessdatabase, ";", accesstabel, ";", accesskolom)

        Return Data
    End Function

    Private Sub InsertConfig(ByVal Data As String)
        'We hebben een .cfg-bestand binnengekregen, we gaan deze uiteenbreken
        'met de split-functie. De split-functie kan m.b.h.v een delimiter
        'een string omzetten in een array van strings. Voorbeeld:
        'string_enkel = "test1;test2;test3"
        'string_array(3) = split(string_enkel, ";")
        'Dit resulteert in:
        'string_array(0) --> "test1"
        'string_array(1) --> "test2"
        'string_array(2) --> "test3"

        'Split-functie uitvoeren op de string die we hebben meegekregen.
        Dim ConfigArray() As String = Split(Data, ";")
        Try
            'Een .cfg-bestand van ons is opgemaakt uit waardes en de string "0"
            'als een bepaalde waarde niet is opgeslagen.
            'Dus als de stringarray op deze plaats niet "0" is,
            'is het een echte waarde die we kunnen inbrengen in de form.
            If (Not ConfigArray(0) = "0") Then
                Me.txtSQLServer.Text = ConfigArray(0)
            End If
            If (Not ConfigArray(1) = "0") Then
                Me.txtSQLDatabase.Text = ConfigArray(1)
            End If
            If (Not ConfigArray(2) = "0") Then
                Me.txtSQLGebruiker.Text = ConfigArray(2)
            End If
            If (Not ConfigArray(3) = "False") Then
                Me.chkIntegratedSecurity.Checked = CBool(ConfigArray(3))
            End If
            If (Not ConfigArray(4) = "0") Then
                Me.txtAccessBestand.Text = ConfigArray(4)
            End If
            If (Not ConfigArray(5) = "0") Then
                Me.txtAccessTabel.Text = ConfigArray(5)
            End If
            If (Not ConfigArray(6) = "0") Then
                Me.txtAccessKolom.Text = ConfigArray(6)
            End If
        Catch ex As Exception
            MessageBox.Show(String.Concat("Er is een fout gebeurd tijdens het laden van de configuratie. Details:", vbCrLf, ex.Message), "Fout", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

    End Sub

    Private Sub OverviewToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenConfigToolStripMenuItem.Click
        'We willen een .cfg-bestand openen.
        fdlg_OpenConfig.Title = "Open Configuratiebestand"
        fdlg_OpenConfig.InitialDirectory = Application.StartupPath
        fdlg_OpenConfig.Filter = "Configuratiebestanden (.cfg)|*.cfg|Alle bestanden (*.*)|*.*"
        fdlg_OpenConfig.FilterIndex = 0
        fdlg_OpenConfig.RestoreDirectory = True

        'Als alles goed is, lezen we het cfg-bestand en proberen we het
        'te inserteren in de form met InsertConfig()
        If fdlg_OpenConfig.ShowDialog() = DialogResult.OK Then

            Dim Pad As String = fdlg_OpenConfig.FileName
            Dim Data As String
            Dim objReader As StreamReader

            Try
                objReader = New StreamReader(Pad)
                Data = objReader.ReadToEnd()
                objReader.Close()
            Catch Ex As Exception
                Throw Ex
            End Try

            InsertConfig(Data)
        End If
    End Sub

    Private Sub ConfigOpslaanToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ConfigOpslaanToolStripMenuItem.Click
        'Configuratiestring maken
        Dim data As String = GetConfig()

        'We willen de configuratie ergens opslaan.
        Dim configopslaandialoog As New SaveFileDialog
        With configopslaandialoog
            .DefaultExt = "cfg"
            .FileName = "sqlconfig"
            .Filter = "Configuratiebestanden (*.cfg)|*.cfg|Alle bestanden (*.*)|*.*"
            .FilterIndex = 1
            .OverwritePrompt = True
            .Title = "Configuratie Opslaan"
        End With

        'Als alles goed is, schrijven we een tekstbestand naar die locatie.
        If configopslaandialoog.ShowDialog = DialogResult.OK Then

            Try
                Dim bestandspad As String
                bestandspad = System.IO.Path.Combine(My.Computer.FileSystem.SpecialDirectories.MyDocuments, configopslaandialoog.FileName)
                My.Computer.FileSystem.WriteAllText(bestandspad, data, False)
            Catch ex As Exception
                Throw ex
            End Try

        End If

        'Schoonmaken
        configopslaandialoog.Dispose()
        configopslaandialoog = Nothing
    End Sub

    Private Sub btnSQLTestConnectie_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSQLTestConnectie.Click
        CheckSQLconnectie()
    End Sub

    Private Sub btnUseConfig_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUseConfig.Click
        'We hebben op "Deze Configuratie Gebruiken" geklikt, dus we gaan
        'alle dataclasses initialiseren en alles klaarzetten voor gebruik

        'De connectie- en SQL-strings.
        Dim SQLConnectiestring As String = String.Empty
        Dim AccessConnectieString As String = String.Empty
        Dim AccessSQLString As String = String.Empty

        'Tekst van form binnenhalen.
        Dim sqlserver As String = Me.txtSQLServer.Text
        Dim sqldatabase As String = Me.txtSQLDatabase.Text
        Dim sqlgebruiker As String = Me.txtSQLGebruiker.Text
        Dim sqlpaswoord As String = Me.txtSQLPaswoord.Text
        Dim sqlintegratedsecurity As Boolean = Me.chkIntegratedSecurity.Checked
        Dim accessdatabase As String = Me.txtAccessBestand.Text
        Dim accesstabel As String = Me.txtAccessTabel.Text
        Dim accesskolom As String = Me.txtAccessKolom.Text

        'Even nakijken of alle waardes wel goed zijn
        If sqlserver = String.Empty Or sqldatabase = String.Empty Or accessdatabase = String.Empty Or accessdatabase = String.Empty Or accesskolom = String.Empty _
        Or (sqlintegratedsecurity = False And (sqlgebruiker = String.Empty Or sqlpaswoord = String.Empty)) Then
            MessageBox.Show("Een of meerdere vereiste tekstvakken zijn niet ingevuld.")
            Exit Sub
        End If

        If (Me.lblAccessGeldig.Text = "Ongeldig" Or Me.lblSQLGeldig.Text = "Ongeldig") Then
            MessageBox.Show("Gelieve na te kijken of beide connecties geldig zijn.")
            Exit Sub
        End If

        If (frmHoofdMenu.BlnSQLConnectieGelukt) Then
            frmHoofdMenu.mySQLConnection.p_dataset.Clear()
        End If

        If (frmHoofdMenu.BlnAccessConnectieGelukt) Then
            frmHoofdMenu.myAccessConnection.p_dataset.Clear()
        End If

        Call StuurLabelsNaarfrmHoofdmenu()

        'De SQL-connectiestring opmaken
        SQLConnectiestring = String.Concat("Data Source=", sqlserver, ";Initial Catalog=", sqldatabase)
        If (sqlintegratedsecurity) Then
            SQLConnectiestring = String.Concat(SQLConnectiestring, ";Integrated Security=True")
        Else
            SQLConnectiestring = String.Concat(SQLConnectiestring, ";Persist Security Info=True;User ID=", sqlgebruiker, ";Password=", sqlpaswoord)
        End If

        'SQL-connectiestring doorsturen naar de SQL-dataclass
        frmHoofdMenu.mySQLConnection.p_mConnectionString = SQLConnectiestring
        'Data binnenhalen van de SQL-database
        frmHoofdMenu.BlnSQLConnectieGelukt = frmHoofdMenu.mySQLConnection.f_VerbindMetDatabase()

        'De Access-connectiestring opmaken
        AccessConnectieString = String.Concat("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=", accessdatabase)
        'De Access-SQL-string opmaken
        AccessSQLString = String.Concat("SELECT ", accesskolom, " FROM ", accesstabel)
        'Access-connectiestring doorsturen naar de SQL-dataclass
        frmHoofdMenu.myAccessConnection.p_mConnectionString = AccessConnectieString
        'Access-SQL-string doorsturen naar de SQL-dataclass
        frmHoofdMenu.myAccessConnection.p_mSQLString = AccessSQLString
        'Data binnenhalen van de Access-database
        frmHoofdMenu.BlnAccessConnectieGelukt = frmHoofdMenu.myAccessConnection.f_fill()

        'De configuratiestring maken en deze opslaan in config.cfg,
        'wat wordt opgeslagen op de plaats van onze exe.
        Dim data As String = GetConfig()
        My.Computer.FileSystem.WriteAllText("config.cfg", data, False)

        If (frmHoofdMenu.BlnAccessConnectieGelukt And frmHoofdMenu.BlnSQLConnectieGelukt) Then

            'Toon het startscherm.
            Call frmHoofdMenu.ToonStartScherm()
        End If
    End Sub

    Private Sub LegenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LegenToolStripMenuItem.Click
        'Alles op de form leegmaken.
        Me.txtSQLServer.Text = String.Empty
        Me.txtSQLDatabase.Text = String.Empty
        Me.txtSQLGebruiker.Text = String.Empty
        Me.txtSQLPaswoord.Text = String.Empty
        Me.chkIntegratedSecurity.Checked = False
        Me.txtAccessBestand.Text = String.Empty
        Me.txtAccessTabel.Text = String.Empty
        Me.txtAccessKolom.Text = String.Empty
        Me.chkAccessOpslaan.Checked = False
        Me.chkSQLOpslaan.Checked = False

    End Sub

    Private Sub NieuweDatabaseAanleggenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NieuweDatabaseAanleggenToolStripMenuItem.Click
        Dim sqlserver As String = Me.txtSQLServer.Text
        frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmNieuweDatabase()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        CType(frmHoofdMenu.HuidigForm, frmNieuweDatabase).txtSQLServer.Text = sqlserver
        frmHoofdMenu.HuidigForm.Show()
    End Sub

    Private Sub StuurLabelsNaarfrmHoofdmenu()
        'Alle labels doorsturen naar de structure in frmhoofdmenu.
        frmHoofdMenu.mLabels.SQLServer = Me.txtSQLServer.Text
        frmHoofdMenu.mLabels.SQLDataBase = Me.txtSQLDatabase.Text
        If (Me.chkIntegratedSecurity.Checked) Then
            frmHoofdMenu.mLabels.SQLGebruiker = "Integrated Security"
        Else
            frmHoofdMenu.mLabels.SQLGebruiker = Me.txtSQLGebruiker.Text
        End If

        Dim filter As String = "[\]\w[ ]*\b.mdb\b$"
        Dim match As Match = Regex.Match(Me.txtAccessBestand.Text, filter)
        If (match.Success) Then
            frmHoofdMenu.mLabels.AccessDataBase = match.ToString
        Else
            frmHoofdMenu.mLabels.AccessDataBase = Me.txtAccessBestand.Text
        End If
        frmHoofdMenu.mLabels.AccessTabel = Me.txtAccessTabel.Text
        frmHoofdMenu.mLabels.AccessKolom = Me.txtAccessKolom.Text
    End Sub
End Class