Imports System.IO
Imports System.Text.RegularExpressions

Public Class frmNieuweDatabase
    'Dialoogvensters. Ze staan hier zodat ze onze geselecteerde folder onthouden
    Private fdlg_OpenConfig As OpenFileDialog = New OpenFileDialog()
    Private fdlg_Access As OpenFileDialog = New OpenFileDialog()
    Private fdlg_ZoekBestand As OpenFileDialog = New OpenFileDialog()

    Private Sub frmNieuweDatabase_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'We nemen aan dat SQL standaard Integrated Security gebruikt
        Me.chkIntegratedSecurity.Checked = True

        If (My.Resources.stored_procedures.Length() > 0 And My.Resources.startdata.Length() > 0) Then
            Me.txtStoredProcedures.Text = "Standaardconfiguratie"
            Me.txtStartData.Text = "Standaardconfiguratie"
            Me.txtStartData.Enabled = False
            Me.txtStoredProcedures.Enabled = False
            Me.lblDataGevonden.Text = "Data Gevonden."
            Me.lblDataGevonden.ForeColor = Color.ForestGreen
            Me.picDataGevonden.Image = My.Resources.tick
        Else
            Me.lblDataGevonden.Text = "Data Niet Gevonden."
            Me.lblDataGevonden.ForeColor = Color.Firebrick
            Me.picDataGevonden.Image = My.Resources.remove
        End If

    End Sub

    Private Sub NieuweDatabaseAanleggenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NieuweDatabaseAanleggenToolStripMenuItem.Click
        frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmConfig()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub

    Private Sub chkIntegratedSecurity_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkIntegratedSecurity.CheckedChanged
        'Als we "Integrated Security" aan- of uitklikken, moeten we deze controls aanpassen
        Me.txtSQLGebruiker.Text = String.Empty
        Me.txtSQLGebruiker.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.lblSQLGebruiker.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.txtSQLPaswoord.Text = String.Empty
        Me.txtSQLPaswoord.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.lblSQLPaswoord.Enabled = Not Me.chkIntegratedSecurity.Checked

        CheckDatabaseKlaar()
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
            

            'Schoonmaken
            connectietest = Nothing
        End If
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

        'Nakijken of de gebruiker SQL-instellingen wil opslaan
        If (Me.chkSQLOpslaan.Checked) Then
            sqlserver = Me.txtSQLServer.Text
            sqldatabase = Me.txtSQLDatabase.Text
            sqlgebruiker = Me.txtSQLGebruiker.Text
            'sqlpaswoord  = Me.txtSQLPaswoord.Text
            sqlintegratedsecurity = Me.chkIntegratedSecurity.Checked.ToString
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

        'De configuratiestring maken.
        Data = String.Concat(sqlserver, ";", sqldatabase, ";", sqlgebruiker, ";", sqlintegratedsecurity)

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

        Catch ex As Exception
            MessageBox.Show("Er is een fout gebeurd tijdens het laden van de configuratie.")
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

    Private Sub btnSQLTestConnectie_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        CheckSQLconnectie()
    End Sub

    Private Sub txtSQLDatabase_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSQLDatabase.TextChanged
        If (Not CheckVoorSpecialeKarakters(Me.txtSQLDatabase.Text) And Me.txtSQLDatabase.Text.Length() > 0) Then
            MessageBox.Show(String.Concat("U mag geen ", ControlChars.Quote, " of ' gebruiken."))
            If (Me.txtSQLDatabase.Text.Length > 0) Then
                Me.txtSQLDatabase.Text = Me.txtSQLDatabase.Text.Substring(0, Me.txtSQLDatabase.Text.Length() - 1)
                Me.txtSQLDatabase.SelectionStart = Me.txtSQLDatabase.Text.Length()
            Else
                Me.txtSQLDatabase.Text = String.Empty
            End If
        End If

        Dim blngeslaagd As Boolean = frmHoofdMenu.mySQLConnection.f_TestDatabase(Me.txtSQLServer.Text, Me.txtSQLDatabase.Text, Me.txtSQLGebruiker.Text, Me.txtSQLPaswoord.Text, Me.chkIntegratedSecurity.Checked)
        If (blngeslaagd) Then
            Me.btnDatabaseAanmaken.Enabled = False
            Me.btnDatabaseAanmaken.Text = "Database Aangemaakt"

            Me.lblSQLGeldig.Text = "Geldig"
            Me.lblSQLGeldig.ForeColor = Color.ForestGreen
            Me.picSQLGeldig.Image = ADO_project.My.Resources.tick
            Me.chkSQLOpslaan.Checked = True
        Else
            Me.btnDatabaseAanmaken.Enabled = True
            Me.btnDatabaseAanmaken.Text = "Database Aanmaken"

            Me.lblSQLGeldig.Text = "Ongeldig"
            Me.lblSQLGeldig.ForeColor = Color.Firebrick
            Me.picSQLGeldig.Image = ADO_project.My.Resources.remove
        End If

        CheckDatabaseKlaar()
    End Sub

    Private Sub txtSQLServer_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSQLServer.TextChanged
        If (Not CheckVoorSpecialeKarakters(Me.txtSQLServer.Text) And Me.txtSQLServer.Text.Length() > 0) Then
            MessageBox.Show(String.Concat("U mag geen ", ControlChars.Quote, " of ' gebruiken."))
            If (Me.txtSQLServer.Text.Length > 0) Then
                Me.txtSQLServer.Text = Me.txtSQLServer.Text.Substring(0, Me.txtSQLServer.Text.Length() - 1)
                Me.txtSQLServer.SelectionStart = Me.txtSQLServer.Text.Length()
            Else
                Me.txtSQLServer.Text = String.Empty
            End If
        End If

        If (Me.txtSQLServer.Text.Length() > 0) Then
            Me.txtSQLDatabase.Enabled = True
        Else
            Me.txtSQLDatabase.Enabled = False
        End If

        Call CheckDatabaseKlaar()
    End Sub

    Private Function CheckVoorSpecialeKarakters(ByVal tekst As String) As Boolean
        Dim tekens As String = String.Concat("[", ControlChars.Quote, "']")
        Dim gevonden As Match = Regex.Match(tekst, tekens)
        If (gevonden.Success) Then
            Return False
        Else
            Return True
        End If
    End Function

    Private Sub txtSQLGebruiker_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSQLGebruiker.TextChanged
        If (Not CheckVoorSpecialeKarakters(Me.txtSQLGebruiker.Text) And Me.txtSQLGebruiker.Text.Length() > 0) Then
            MessageBox.Show(String.Concat("U mag geen ", ControlChars.Quote, " of ' gebruiken."))
            If (Me.txtSQLGebruiker.Text.Length > 0) Then
                Me.txtSQLGebruiker.Text = Me.txtSQLGebruiker.Text.Substring(0, Me.txtSQLGebruiker.Text.Length() - 1)
                Me.txtSQLGebruiker.SelectionStart = Me.txtSQLGebruiker.Text.Length()
            Else
                Me.txtSQLGebruiker.Text = String.Empty
            End If
        End If

        Dim geldig As Boolean = frmHoofdMenu.mySQLConnection.f_TestDatabase(Me.txtSQLServer.Text, Me.txtSQLDatabase.Text, Me.txtSQLGebruiker.Text, Me.txtSQLPaswoord.Text, Me.chkIntegratedSecurity.Checked)
        Call SetGeldig(geldig, Me.lblSQLGeldig, Me.picSQLGeldig)
        If (geldig) Then
            CheckDatabaseKlaar()
        End If
    End Sub

    Private Sub txtSQLPaswoord_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSQLPaswoord.TextChanged
        If (Not CheckVoorSpecialeKarakters(Me.txtSQLPaswoord.Text) And Me.txtSQLPaswoord.Text.Length() > 0) Then
            MessageBox.Show(String.Concat("U mag geen ", ControlChars.Quote, " of ' gebruiken."))
            If (Me.txtSQLPaswoord.Text.Length > 0) Then
                Me.txtSQLPaswoord.Text = Me.txtSQLPaswoord.Text.Substring(0, Me.txtSQLPaswoord.Text.Length() - 1)
                Me.txtSQLPaswoord.SelectionStart = Me.txtSQLPaswoord.Text.Length()
            Else
                Me.txtSQLPaswoord.Text = String.Empty
            End If
        End If

        Dim geldig As Boolean = frmHoofdMenu.mySQLConnection.f_TestDatabase(Me.txtSQLServer.Text, Me.txtSQLDatabase.Text, Me.txtSQLGebruiker.Text, Me.txtSQLPaswoord.Text, Me.chkIntegratedSecurity.Checked)
        Call SetGeldig(geldig, Me.lblSQLGeldig, Me.picSQLGeldig)
        If (geldig) Then
            CheckDatabaseKlaar()
        End If
    End Sub

    Private Sub btnManeelStoredProcedures_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnManeelStoredProcedures.Click
        fdlg_ZoekBestand.Title = "Zoek Bestand"
        fdlg_ZoekBestand.InitialDirectory = Application.StartupPath
        fdlg_ZoekBestand.Filter = "SQL-Files (.sql)|*.sql|Tekstbestanden (.txt)|*.txt| Alle bestanden (*.*)|*.*"
        fdlg_ZoekBestand.FilterIndex = 0
        fdlg_ZoekBestand.RestoreDirectory = True

        If fdlg_ZoekBestand.ShowDialog() = DialogResult.OK Then
            Me.txtStoredProcedures.Text = fdlg_ZoekBestand.FileName
        End If
    End Sub

    Private Sub btnManueelStartData_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnManueelStartData.Click
        fdlg_ZoekBestand.Title = "Zoek Bestand"
        fdlg_ZoekBestand.InitialDirectory = Application.StartupPath
        fdlg_ZoekBestand.Filter = "SQL-Files (.sql)|*.sql|Tekstbestanden (.txt)|*.txt| Alle bestanden (*.*)|*.*"
        fdlg_ZoekBestand.FilterIndex = 0
        fdlg_ZoekBestand.RestoreDirectory = True

        If fdlg_ZoekBestand.ShowDialog() = DialogResult.OK Then
            Me.txtStartData.Text = fdlg_ZoekBestand.FileName
        End If
    End Sub

    Private Sub btnManueelExtraData_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnManueelExtraData.Click
        fdlg_ZoekBestand.Title = "Zoek Bestand"
        fdlg_ZoekBestand.InitialDirectory = Application.StartupPath
        fdlg_ZoekBestand.Filter = "SQL-Files (.sql)|*.sql|Tekstbestanden (.txt)|*.txt| Alle bestanden (*.*)|*.*"
        fdlg_ZoekBestand.FilterIndex = 0
        fdlg_ZoekBestand.RestoreDirectory = True

        If fdlg_ZoekBestand.ShowDialog() = DialogResult.OK Then
            Me.txtExtraData.Text = fdlg_ZoekBestand.FileName
        End If
    End Sub

    Private Sub btnPopuleerDatabase_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPopuleerDatabase.Click
        'We gaan de database vullen met de tabellen en de stored procedures.
        Dim storedprocedures As String = String.Empty
        Dim startdata As String = String.Empty
        Dim extradata As String = String.Empty

        If (Me.txtStoredProcedures.Text = "Standaardconfiguratie") Then
            storedprocedures = My.Resources.stored_procedures
        Else
            Dim objReader As StreamReader
            Try
                objReader = New StreamReader(Me.txtStoredProcedures.Text)
                storedprocedures = objReader.ReadToEnd()
                objReader.Close()
            Catch Ex As Exception
                MessageBox.Show("Er gebeurde een fout tijdens het lezen van de stored procedures. Details: " & Ex.Message)
                Exit Sub
            End Try
        End If

        If (Me.txtStartData.Text = "Standaardconfiguratie") Then
            startdata = My.Resources.startdata
        Else
            Dim objReader As StreamReader
            Try
                objReader = New StreamReader(Me.txtStartData.Text)
                startdata = objReader.ReadToEnd()
                objReader.Close()
            Catch Ex As Exception
                MessageBox.Show("Er gebeurde een fout tijdens het lezen van de startdata Details: " & Ex.Message)
                Exit Sub
            End Try
        End If

        If (Not Me.txtExtraData.Text = String.Empty) Then
            Dim objReader As StreamReader
            Try
                objReader = New StreamReader(Me.txtExtraData.Text)
                extradata = objReader.ReadToEnd()
                objReader.Close()
            Catch Ex As Exception
                MessageBox.Show("Er gebeurde een fout tijdens het lezen van de startdata Details: " & Ex.Message)
                Exit Sub
            End Try
        End If

        Dim geslaagd As Boolean = frmHoofdMenu.mySQLConnection.f_VulNieuweDatabase(Me.txtSQLServer.Text, Me.txtSQLDatabase.Text, Me.txtSQLGebruiker.Text, Me.txtSQLPaswoord.Text, Me.chkIntegratedSecurity.Checked, storedprocedures, startdata, extradata)
        If (geslaagd) Then
            Me.btnPopuleerDatabase.Enabled = False
            Me.lblDatabaseGepopuleerd.Text = "Database Gepopuleerd."
            Me.lblDatabaseGepopuleerd.ForeColor = Color.ForestGreen
            Me.picDatabaseGepopuleerd.Image = ADO_project.My.Resources.tick
        Else
            Me.btnPopuleerDatabase.Enabled = True
            Me.lblDatabaseGepopuleerd.Text = "Database Niet Gepopuleerd."
            Me.lblDatabaseGepopuleerd.ForeColor = Color.Firebrick
            Me.picDatabaseGepopuleerd.Image = ADO_project.My.Resources.remove
        End If
    End Sub

    Private Sub CheckDatabaseKlaar()
        If (Not Me.txtSQLServer.Text = String.Empty And Not Me.txtSQLDatabase.Text = String.Empty _
           And (Me.chkIntegratedSecurity.Checked Or (Not Me.txtSQLGebruiker.Text = String.Empty And Not Me.txtSQLGebruiker.Text = String.Empty) _
                And Not Me.txtStoredProcedures.Text = String.Empty And Not Me.txtStartData.Text = String.Empty)) Then
            If (frmHoofdMenu.mySQLConnection.f_TestDatabase(Me.txtSQLServer.Text, Me.txtSQLDatabase.Text, Me.txtSQLGebruiker.Text, Me.txtSQLPaswoord.Text, Me.chkIntegratedSecurity.Checked)) Then
                Me.btnPopuleerDatabase.Enabled = True
            Else
                Me.btnPopuleerDatabase.Enabled = False
            End If
        Else
            Me.btnPopuleerDatabase.Enabled = False
        End If
    End Sub

    Private Sub txtStoredProcedures_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtStoredProcedures.TextChanged
        CheckDatabaseKlaar()
    End Sub

    Private Sub txtStartData_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtStartData.TextChanged
        CheckDatabaseKlaar()
    End Sub

    Private Sub SetGeldig(ByVal Geldig As Boolean, ByVal LabelControl As Label, ByVal ImageControl As PictureBox)
        If (Geldig) Then
            ImageControl.Image = My.Resources.tick
            LabelControl.Text = "Geldig"
            LabelControl.ForeColor = Color.ForestGreen
        Else
            ImageControl.Image = My.Resources.remove
            LabelControl.Text = "Ongeldig"
            LabelControl.ForeColor = Color.Firebrick
        End If
    End Sub

    Private Sub btnDatabaseAanmaken_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDatabaseAanmaken.Click
        Dim blngeslaagd As Boolean = frmHoofdMenu.mySQLConnection.f_NieuweDatabase(Me.txtSQLServer.Text, Me.txtSQLDatabase.Text, Me.txtSQLGebruiker.Text, Me.txtSQLPaswoord.Text, Me.chkIntegratedSecurity.Checked)
        If (blngeslaagd) Then
            Me.btnDatabaseAanmaken.Enabled = False
            Me.btnDatabaseAanmaken.Text = "Database Aangemaakt"
        End If
        CheckDatabaseKlaar()
    End Sub
End Class