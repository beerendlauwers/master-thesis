Imports System.IO
Imports System.Text.RegularExpressions

Public Class frmNieuweDatabase

    'Bevat de structure DataBaseSettings.
#Region "Publieke Variabelen"
    Public Structure DataBaseSettings
        Public Server As String
        Public DataBase As String
        Public IntegratedSecurity As Boolean
        Public Gebruiker As String
        Public Paswoord As String
        Public StoredProcedures() As String
        Public ExtraData() As String
    End Structure
#End Region

    'Dialoogvensters en mDatabaseInstellingen
#Region "Private Variabelen"
    'Dialoogvensters. Ze staan hier zodat ze onze geselecteerde folder onthouden
    Private fdlg_OpenConfig As OpenFileDialog = New OpenFileDialog()
    Private fdlg_Access As OpenFileDialog = New OpenFileDialog()
    Private fdlg_ZoekBestand As OpenFileDialog = New OpenFileDialog()
    Private mDatabaseInstellingen As DataBaseSettings
#End Region

    'Initialiseren van structure
#Region "Sub New"
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()
        'We kunnen de grootte van een array in VB.Net niet specifiëren in een Structure. Best stom
        mDatabaseInstellingen.StoredProcedures = New String(99) {}
        mDatabaseInstellingen.ExtraData = New String(99) {}
    End Sub
#End Region

    'zoeken naar standaardconfiguratie
#Region "Form Load"
    Private Sub frmNieuweDatabase_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'We nemen aan dat SQL standaard Integrated Security gebruikt
        Me.chkIntegratedSecurity.Checked = True

        Me.btnDatabaseAanmaken.Enabled = False

        'We kijken na of we de standaardconfiguratie kunnen vinden.
        'Indien ja, dan laden we deze reeds in de listboxes.
        If (CheckStoredProcedures() And Not My.Resources.startdata = String.Empty) Then
            Me.lstStoredProcedures.Items.Add("Standaardconfiguratie")
            Me.lstData.Items.Add("Standaardconfiguratie")
            Me.lblDataGevonden.Text = "Standaarddata Gevonden."
            Me.lblDataGevonden.ForeColor = Color.ForestGreen
            Me.picDataGevonden.Image = My.Resources.tick
        Else
            Me.lblDataGevonden.Text = "Standaarddata Niet Gevonden."
            Me.lblDataGevonden.ForeColor = Color.Firebrick
            Me.picDataGevonden.Image = My.Resources.remove
        End If
    End Sub
#End Region

    'Openen |Opslaan | Legen | Terug naar config
#Region "Toolstripmenu Items"
    Private Sub OpenenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenenToolStripMenuItem1.Click
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

    Private Sub OpslaanToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpslaanToolStripMenuItem1.Click
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

    Private Sub LegenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LegenToolStripMenuItem2.Click
        'Alles op de form leegmaken.
        Me.txtSQLServer.Text = String.Empty
        Me.txtSQLDatabase.Text = String.Empty
        Me.txtSQLGebruiker.Text = String.Empty
        Me.txtSQLPaswoord.Text = String.Empty
        Me.chkIntegratedSecurity.Checked = False
        Me.chkSQLOpslaan.Checked = False
    End Sub

    Private Sub TerugNaarConfiguratieschermToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TerugNaarConfiguratieschermToolStripMenuItem.Click
        frmHoofdMenu.ClearOtherWindows()
        frmHoofdMenu.HuidigForm = New frmConfig()
        frmHoofdMenu.HuidigForm.MdiParent = frmHoofdMenu
        frmHoofdMenu.HuidigForm.Show()
    End Sub
#End Region

#Region "OnTextChanged Events"
    Private Sub txtSQLDatabase_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSQLDatabase.TextChanged

        'Kijk na of er geen ongeldige tekens in onze connectiestring zit.
        If (Not CheckVoorSpecialeKarakters(Me.txtSQLDatabase.Text) And Me.txtSQLDatabase.Text.Length() > 0) Then
            MessageBox.Show(String.Concat("U mag geen ", ControlChars.Quote, " of ' gebruiken."))
            If (Me.txtSQLDatabase.Text.Length > 0) Then
                Me.txtSQLDatabase.Text = Me.txtSQLDatabase.Text.Substring(0, Me.txtSQLDatabase.Text.Length() - 1)
                Me.txtSQLDatabase.SelectionStart = Me.txtSQLDatabase.Text.Length()
            Else
                Me.txtSQLDatabase.Text = String.Empty
            End If
        End If

        'Databasedata updaten.
        Call GetDatabaseData()

        'We proberen met de database te verbinden.
        Dim blngeslaagd As Boolean = frmHoofdMenu.mySQLConnection.f_TestDatabase(mDatabaseInstellingen)

        If (blngeslaagd) Then
            Me.btnDatabaseAanmaken.Enabled = False
            Me.btnDatabaseAanmaken.Text = "Database Aangemaakt"

            Me.lblSQLGeldig.Text = "Geldig"
            Me.lblSQLGeldig.ForeColor = Color.ForestGreen
            Me.picSQLGeldig.Image = ADO_project.My.Resources.tick
            Me.chkSQLOpslaan.Checked = True
        Else
            If (Me.txtSQLDatabase.Text = String.Empty Or Me.txtSQLServer.Text = String.Empty) Then
                Me.btnDatabaseAanmaken.Enabled = False
            Else
                Me.btnDatabaseAanmaken.Enabled = True
            End If
            Me.btnDatabaseAanmaken.Text = "Database Aanmaken"

            Me.lblSQLGeldig.Text = "Ongeldig"
            Me.lblSQLGeldig.ForeColor = Color.Firebrick
            Me.picSQLGeldig.Image = ADO_project.My.Resources.remove
        End If

        'Kijk na of alles klaar is. Indien ja, dan zullen we de "Populeer Database"-knop
        'beschikbaar maken.
        CheckDatabaseKlaar()
    End Sub

    Private Sub txtSQLServer_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSQLServer.TextChanged

        If (Me.txtSQLDatabase.Text = String.Empty Or Me.txtSQLServer.Text = String.Empty) Then
            Me.btnDatabaseAanmaken.Enabled = False
        Else
            Me.btnDatabaseAanmaken.Enabled = True
        End If

        'Kijk na of er geen ongeldige tekens in onze connectiestring zit.
        If (Not CheckVoorSpecialeKarakters(Me.txtSQLServer.Text) And Me.txtSQLServer.Text.Length() > 0) Then
            MessageBox.Show(String.Concat("U mag geen ", ControlChars.Quote, " of ' gebruiken."))
            If (Me.txtSQLServer.Text.Length > 0) Then
                Me.txtSQLServer.Text = Me.txtSQLServer.Text.Substring(0, Me.txtSQLServer.Text.Length() - 1)
                Me.txtSQLServer.SelectionStart = Me.txtSQLServer.Text.Length()
            Else
                Me.txtSQLServer.Text = String.Empty
            End If
        End If

        'Als de servertextbox leeg is, dan sluiten we de databasetextbox af.
        If (Me.txtSQLServer.Text.Length() > 0) Then
            Me.txtSQLDatabase.Enabled = True
        Else
            Me.txtSQLDatabase.Enabled = False
            Me.txtSQLDatabase.Text = String.Empty
        End If

        'Kijk na of alles klaar is. Indien ja, dan zullen we de "Populeer Database"-knop
        'beschikbaar maken.
        Call CheckDatabaseKlaar()
    End Sub

    Private Sub txtSQLGebruiker_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSQLGebruiker.TextChanged

        'Kijk na of er geen ongeldige tekens in onze connectiestring zit.
        If (Not CheckVoorSpecialeKarakters(Me.txtSQLGebruiker.Text) And Me.txtSQLGebruiker.Text.Length() > 0) Then
            MessageBox.Show(String.Concat("U mag geen ", ControlChars.Quote, " of ' gebruiken."))
            If (Me.txtSQLGebruiker.Text.Length > 0) Then
                Me.txtSQLGebruiker.Text = Me.txtSQLGebruiker.Text.Substring(0, Me.txtSQLGebruiker.Text.Length() - 1)
                Me.txtSQLGebruiker.SelectionStart = Me.txtSQLGebruiker.Text.Length()
            Else
                Me.txtSQLGebruiker.Text = String.Empty
            End If
        End If

        'Databasedata updaten.
        Call GetDatabaseData()

        'We testen de connectie.
        Dim geldig As Boolean = frmHoofdMenu.mySQLConnection.f_TestDatabase(mDatabaseInstellingen)
        Call SetGeldig(geldig, Me.lblSQLGeldig, Me.picSQLGeldig)
        If (geldig) Then
            'Kijk na of alles klaar is. Indien ja, dan zullen we de "Populeer Database"-knop
            'beschikbaar maken.
            CheckDatabaseKlaar()
        End If
    End Sub

    Private Sub txtSQLPaswoord_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSQLPaswoord.TextChanged

        'Kijk na of er geen ongeldige tekens in onze connectiestring zit.
        If (Not CheckVoorSpecialeKarakters(Me.txtSQLPaswoord.Text) And Me.txtSQLPaswoord.Text.Length() > 0) Then
            MessageBox.Show(String.Concat("U mag geen ", ControlChars.Quote, " of ' gebruiken."))
            If (Me.txtSQLPaswoord.Text.Length > 0) Then
                Me.txtSQLPaswoord.Text = Me.txtSQLPaswoord.Text.Substring(0, Me.txtSQLPaswoord.Text.Length() - 1)
                Me.txtSQLPaswoord.SelectionStart = Me.txtSQLPaswoord.Text.Length()
            Else
                Me.txtSQLPaswoord.Text = String.Empty
            End If
        End If

        'Databasedata updaten.
        Call GetDatabaseData()

        'We testen de connectie.
        Dim geldig As Boolean = frmHoofdMenu.mySQLConnection.f_TestDatabase(mDatabaseInstellingen)
        Call SetGeldig(geldig, Me.lblSQLGeldig, Me.picSQLGeldig)

        If (geldig) Then

            'Kijk na of alles klaar is. Indien ja, dan zullen we de "Populeer Database"-knop
            'beschikbaar maken.
            CheckDatabaseKlaar()
        End If
    End Sub

    Private Sub txtStoredProcedures_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
        'Kijk na of alles klaar is. Indien ja, dan zullen we de "Populeer Database"-knop
        'beschikbaar maken.
        CheckDatabaseKlaar()
    End Sub

    Private Sub txtStartData_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
        'Kijk na of alles klaar is. Indien ja, dan zullen we de "Populeer Database"-knop
        'beschikbaar maken.
        CheckDatabaseKlaar()
    End Sub
#End Region

#Region "OnCheckBoxChanged Event"
    Private Sub chkIntegratedSecurity_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkIntegratedSecurity.CheckedChanged
        'Als we "Integrated Security" aan- of uitklikken, moeten we deze controls aanpassen
        Me.txtSQLGebruiker.Text = String.Empty
        Me.txtSQLGebruiker.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.lblSQLGebruiker.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.txtSQLPaswoord.Text = String.Empty
        Me.txtSQLPaswoord.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.lblSQLPaswoord.Enabled = Not Me.chkIntegratedSecurity.Checked

        'Databasedata updaten.
        Call GetDatabaseData()

        'We proberen met de database te verbinden.
        Dim blngeslaagd As Boolean = frmHoofdMenu.mySQLConnection.f_TestDatabase(mDatabaseInstellingen)

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
        'Kijk na of alles klaar is. Indien ja, dan zullen we de "Populeer Database"-knop
        'beschikbaar maken.
        CheckDatabaseKlaar()
    End Sub
#End Region

#Region "Buttons"
    Private Sub btnSQLTestConnectie_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        'We testen de SQL-connectie.
        CheckSQLconnectie()
    End Sub

    Private Sub btnDatabaseAanmaken_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDatabaseAanmaken.Click

        'Databasedata updaten.
        Call GetDatabaseData()

        'Een nieuwe database proberen aan te maken.
        Dim blngeslaagd As Boolean = frmHoofdMenu.mySQLConnection.f_NieuweDatabase(mDatabaseInstellingen)

        If (blngeslaagd) Then
            Me.btnDatabaseAanmaken.Enabled = False

            'We laten onze progressbar doorheen vijf seconden gaan.
            'Dit doen we om de database te tijd te geven een nieuwe database
            'aan te maken.
            Dim i As Int16
            For i = 1 To 5
                System.Threading.Thread.Sleep(1000)
                Me.prgDatabaseAanmaken.Value = i
            Next i
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

        'Kijk na of alles klaar is. Indien ja, dan zullen we de "Populeer Database"-knop
        'beschikbaar maken.
        CheckDatabaseKlaar()
    End Sub

    Private Sub btnStoredProcedureToevoegen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStoredProcedureToevoegen.Click
        fdlg_ZoekBestand.Title = "Voeg Stored Procedure Toe"
        fdlg_ZoekBestand.InitialDirectory = Application.StartupPath
        fdlg_ZoekBestand.Filter = "SQL-Files (.sql)|*.sql|Tekstbestanden (.txt)|*.txt| Alle bestanden (*.*)|*.*"
        fdlg_ZoekBestand.FilterIndex = 0
        fdlg_ZoekBestand.RestoreDirectory = True

        'Als alles goed is, toevoegen aan onze lstStoredProcedures listbox
        If fdlg_ZoekBestand.ShowDialog() = DialogResult.OK Then
            Me.lstStoredProcedures.Items.Add(fdlg_ZoekBestand.FileName)
        End If
    End Sub

    Private Sub btnDataToevoegen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDataToevoegen.Click
        fdlg_ZoekBestand.Title = "Voeg Data Toe"
        fdlg_ZoekBestand.InitialDirectory = Application.StartupPath
        fdlg_ZoekBestand.Filter = "SQL-Files (.sql)|*.sql|Tekstbestanden (.txt)|*.txt| Alle bestanden (*.*)|*.*"
        fdlg_ZoekBestand.FilterIndex = 0
        fdlg_ZoekBestand.RestoreDirectory = True

        'Als alles goed is, toevoegen aan onze lstData listbox
        If fdlg_ZoekBestand.ShowDialog() = DialogResult.OK Then
            Me.lstData.Items.Add(fdlg_ZoekBestand.FileName)
        End If
    End Sub

    Private Sub btnStoredProcedureVerwijderen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStoredProcedureVerwijderen.Click
        'Kijken of we wel iets hebben geselecteerd
        If (Me.lstStoredProcedures.SelectedIndex > -1) Then
            If (Me.lstStoredProcedures.Text = "Standaardconfiguratie") Then
                If (MessageBox.Show("Bent u zeker dat u de standaardconfiguratie wilt verwijderen?", "Standaardconfiguratie verwijderen", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes) Then
                    Me.lstStoredProcedures.Items.RemoveAt(Me.lstStoredProcedures.SelectedIndex)
                End If
            Else
                Me.lstStoredProcedures.Items.RemoveAt(Me.lstStoredProcedures.SelectedIndex)
            End If
        End If
    End Sub

    Private Sub btnDataVerwijderen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDataVerwijderen.Click
        'Kijken of we wel iets hebben geselecteerd
        If (Me.lstData.SelectedIndex > -1) Then
            If (Me.lstData.Text = "Standaardconfiguratie") Then
                If (MessageBox.Show("Bent u zeker dat u de standaardconfiguratie wilt verwijderen?", "Standaardconfiguratie verwijderen", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes) Then
                    Me.lstData.Items.RemoveAt(Me.lstData.SelectedIndex)
                End If
            Else
                Me.lstData.Items.RemoveAt(Me.lstData.SelectedIndex)
            End If
        End If
    End Sub

    Private Sub btnPopuleerDatabase_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPopuleerDatabase.Click
        'We gaan de database vullen met de tabellen en de stored procedures.

        'Databasedata updaten.
        Call GetDatabaseData()

        'We proberen de database te vullen.
        Dim geslaagd As Boolean = frmHoofdMenu.mySQLConnection.f_VulNieuweDatabase(mDatabaseInstellingen)
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
#End Region

    'Inhoud: Sub Setgeldig
#Region "Formcontrole"
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
#End Region

    'Inhoud:
    'Function CheckVoorSpecialeKarakters
    'Sub CheckDatabaseKlaar
    'Function CheckStoredProcedures
#Region "Validatiefuncties"

    Private Function CheckVoorSpecialeKarakters(ByVal tekst As String) As Boolean
        Dim tekens As String = String.Concat("[", ControlChars.Quote, "']")
        Dim gevonden As Match = Regex.Match(tekst, tekens)
        If (gevonden.Success) Then
            Return False
        Else
            Return True
        End If
    End Function

    Private Sub CheckDatabaseKlaar()

        'Kijk na of alles wel geldig is.
        If (Not Me.txtSQLServer.Text = String.Empty And Not Me.txtSQLDatabase.Text = String.Empty _
           And (Me.chkIntegratedSecurity.Checked Or (Not Me.txtSQLGebruiker.Text = String.Empty And Not Me.txtSQLGebruiker.Text = String.Empty) _
                And Me.lstStoredProcedures.Items.Count > 0 And Me.lstStoredProcedures.Items.Count > 0)) Then

            'Databasedata updaten.
            Call GetDatabaseData()

            'Test de of de database bestaat.
            If (frmHoofdMenu.mySQLConnection.f_TestDatabase(mDatabaseInstellingen)) Then
                Me.btnPopuleerDatabase.Enabled = True
            Else
                Me.btnPopuleerDatabase.Enabled = False
            End If
        Else
            Me.btnPopuleerDatabase.Enabled = False
        End If
    End Sub

    Private Function CheckStoredProcedures() As Boolean
        If (Not My.Resources.STORED_PROCEDURE_datainlezen = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_nieuwedeelname = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_nieuwesport = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_nieuwestudent = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_nieuwniveau = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_tbldoetsportdatagrid = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_tbldoetsportinlezen = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_tblniveauinlezen = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_tblsportinlezen = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_tblstudentinlezen = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_updatesport = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_updatestudent = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_verwijdersport = String.Empty And _
            Not My.Resources.STORED_PROCEDURE_verwijderstudent = String.Empty) Then
            Return True
        Else
            Return False
        End If
    End Function

#End Region

#Region "Function voor Databasedetails op te halen"

    Private Sub GetDatabaseData()

        If (Not Me.txtSQLServer.Text = String.Empty) Then
            mDatabaseInstellingen.Server = Me.txtSQLServer.Text
        End If

        If (Not Me.txtSQLDatabase.Text = String.Empty) Then
            mDatabaseInstellingen.DataBase = Me.txtSQLDatabase.Text
        End If

        mDatabaseInstellingen.IntegratedSecurity = Me.chkIntegratedSecurity.Checked

        If (Not Me.txtSQLGebruiker.Text = String.Empty) Then
            mDatabaseInstellingen.Gebruiker = Me.txtSQLGebruiker.Text
        End If

        If (Not Me.txtSQLPaswoord.Text = String.Empty) Then
            mDatabaseInstellingen.Paswoord = Me.txtSQLPaswoord.Text
        End If

        If (Me.lstStoredProcedures.Items.Count > 0) Then
            Dim i As Int16
            Dim storedprocedure As String
            For i = 0 To lstStoredProcedures.Items.Count - 1
                storedprocedure = Me.lstStoredProcedures.Items.Item(i)
                If (storedprocedure = "Standaardconfiguratie") Then
                    mDatabaseInstellingen.StoredProcedures(i) = My.Resources.STORED_PROCEDURE_datainlezen
                    mDatabaseInstellingen.StoredProcedures(i + 1) = My.Resources.STORED_PROCEDURE_nieuwedeelname
                    mDatabaseInstellingen.StoredProcedures(i + 2) = My.Resources.STORED_PROCEDURE_nieuwesport
                    mDatabaseInstellingen.StoredProcedures(i + 3) = My.Resources.STORED_PROCEDURE_nieuwestudent
                    mDatabaseInstellingen.StoredProcedures(i + 4) = My.Resources.STORED_PROCEDURE_nieuwniveau
                    mDatabaseInstellingen.StoredProcedures(i + 5) = My.Resources.STORED_PROCEDURE_tbldoetsportdatagrid
                    mDatabaseInstellingen.StoredProcedures(i + 6) = My.Resources.STORED_PROCEDURE_tbldoetsportinlezen
                    mDatabaseInstellingen.StoredProcedures(i + 7) = My.Resources.STORED_PROCEDURE_tblniveauinlezen
                    mDatabaseInstellingen.StoredProcedures(i + 8) = My.Resources.STORED_PROCEDURE_tblsportinlezen
                    mDatabaseInstellingen.StoredProcedures(i + 9) = My.Resources.STORED_PROCEDURE_tblstudentinlezen
                    mDatabaseInstellingen.StoredProcedures(i + 10) = My.Resources.STORED_PROCEDURE_updatesport
                    mDatabaseInstellingen.StoredProcedures(i + 11) = My.Resources.STORED_PROCEDURE_updatestudent
                    mDatabaseInstellingen.StoredProcedures(i + 12) = My.Resources.STORED_PROCEDURE_verwijdersport
                    mDatabaseInstellingen.StoredProcedures(i + 13) = My.Resources.STORED_PROCEDURE_verwijderstudent
                    i = i + 13
                Else
                    Dim objReader As StreamReader
                    Try
                        objReader = New StreamReader(storedprocedure)
                        mDatabaseInstellingen.StoredProcedures(i) = objReader.ReadToEnd()
                        objReader.Close()
                    Catch Ex As Exception
                        MessageBox.Show("Er gebeurde een fout tijdens het lezen van de stored procedures. Details: " & Ex.Message)
                        Exit Sub
                    End Try
                End If
            Next i
        Else
            Dim i As Int16 = 0
            While (i < mDatabaseInstellingen.StoredProcedures.Length())
                mDatabaseInstellingen.StoredProcedures(i) = String.Empty
                i = i + 1
            End While
        End If

        If (Me.lstData.Items.Count > 0) Then
            Dim i As Int16
            Dim data As String
            For i = 0 To lstData.Items.Count - 1
                data = Me.lstData.Items.Item(i)
                If (data = "Standaardconfiguratie") Then
                    mDatabaseInstellingen.ExtraData(i) = My.Resources.startdata
                Else
                    Dim objReader As StreamReader
                    Try
                        objReader = New StreamReader(data)
                        mDatabaseInstellingen.ExtraData(i) = objReader.ReadToEnd()
                        objReader.Close()
                    Catch Ex As Exception
                        MessageBox.Show("Er gebeurde een fout tijdens het lezen van de data. Details: " & Ex.Message)
                        Exit Sub
                    End Try
                End If
            Next i
        Else
            Dim i As Int16 = 0
            While (i < mDatabaseInstellingen.ExtraData.Length())
                mDatabaseInstellingen.ExtraData(i) = String.Empty
                i = i + 1
            End While
        End If

    End Sub
#End Region

#Region "Function voor SQL-connectie"
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
#End Region

    'Inhoud:
    'Function GetConfig
    'Sub InsertConfig
#Region "Functions voor Config"
    Private Function GetConfig() As String
        'Deze functie creërt een configuratiestring die we opslaan in een tekstbestand.

        'Tekststrings klaarzetten
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

            If (String.Compare(ConfigArray(0), "0")) Then
                Me.txtSQLServer.Text = ConfigArray(0)
            End If
            If (String.Compare(ConfigArray(1), "0")) Then
                Me.txtSQLDatabase.Text = ConfigArray(1)
            End If
            If (String.Compare(ConfigArray(2), "0")) Then
                Me.txtSQLGebruiker.Text = ConfigArray(2)
            End If
            Me.chkIntegratedSecurity.Checked = CBool(ConfigArray(3))

        Catch ex As Exception
            MessageBox.Show("Er is een fout gebeurd tijdens het laden van de configuratie.")
        End Try
    End Sub
#End Region

End Class