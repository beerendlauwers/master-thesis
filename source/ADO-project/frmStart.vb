Imports System.IO

Public Class frmStart
    Private fdlg_OpenConfig As OpenFileDialog = New OpenFileDialog()
    Private fdlg_Access As OpenFileDialog = New OpenFileDialog()

    Private Sub frmStart_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.chkIntegratedSecurity.Checked = True
        frmHoofdMenu.StudentenToolStripMenuItem.Enabled = False
    End Sub

    Private Sub chkIntegratedSecurity_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkIntegratedSecurity.CheckedChanged
        Me.txtSQLGebruiker.Text = String.Empty
        Me.txtSQLGebruiker.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.lblSQLGebruiker.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.txtSQLPaswoord.Text = String.Empty
        Me.txtSQLPaswoord.Enabled = Not Me.chkIntegratedSecurity.Checked
        Me.lblSQLPaswoord.Enabled = Not Me.chkIntegratedSecurity.Checked
    End Sub

    Private Sub VensterSluitenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.Close()
    End Sub


    Private Sub CheckSQLconnectie()
        Dim server As String = Me.txtSQLServer.Text
        Dim database As String = Me.txtSQLDatabase.Text
        Dim gebruiker As String = Me.txtSQLGebruiker.Text
        Dim paswoord As String = Me.txtSQLPaswoord.Text
        Dim integratedsecurity As Boolean = Me.chkIntegratedSecurity.Checked

        If database = String.Empty Or server = String.Empty Or _
        (integratedsecurity = False And (gebruiker = String.Empty Or database = String.Empty)) Then
            Me.lblSQLGeldig.Text = "Ongeldig"
            Me.lblSQLGeldig.ForeColor = Color.Firebrick
            Me.pctSQLGeldig.Image = ADO_project.My.Resources.remove
        Else
            Dim blnGeslaagd As Boolean = False
            Dim connectietest As clDataViaSql = New clDataViaSql
            blnGeslaagd = connectietest.f_TestSQL(server, database, gebruiker, paswoord, integratedsecurity)
            If (blnGeslaagd) Then
                Me.lblSQLGeldig.Text = "Geldig"
                Me.lblSQLGeldig.ForeColor = Color.ForestGreen
                Me.pctSQLGeldig.Image = ADO_project.My.Resources.tick
            Else
                Me.lblSQLGeldig.Text = "Ongeldig"
                Me.lblSQLGeldig.ForeColor = Color.Firebrick
                Me.pctSQLGeldig.Image = ADO_project.My.Resources.remove
            End If
            connectietest = Nothing
        End If
    End Sub

    Private Sub CheckAccessConnectie()
        Dim database As String = Me.txtAccessBestand.Text
        Dim tabel As String = Me.txtAccessTabel.Text
        Dim kolom As String = Me.txtAccessKolom.Text

        If (database = String.Empty Or tabel = String.Empty Or kolom = String.Empty) Then
            Me.lblAccessGeldig.Text = "Ongeldig"
            Me.lblAccessGeldig.ForeColor = Color.Firebrick
            Me.pctAccessGeldig.Image = ADO_project.My.Resources.remove
        Else
            Dim blnGeslaagd As Boolean = False
            Dim connectietest As clDataViaAccess = New clDataViaAccess
            blnGeslaagd = connectietest.f_TestAccess(database, tabel, kolom)
            If (blnGeslaagd) Then
                Me.lblAccessGeldig.Text = "Geldig"
                Me.lblAccessGeldig.ForeColor = Color.ForestGreen
                Me.pctAccessGeldig.Image = ADO_project.My.Resources.tick
                Me.chkAccessOpslaan.Checked = True
            Else
                Me.lblAccessGeldig.Text = "Ongeldig"
                Me.lblAccessGeldig.ForeColor = Color.Firebrick
                Me.pctAccessGeldig.Image = ADO_project.My.Resources.remove
            End If
            connectietest = Nothing
        End If

    End Sub

    Private Sub btnAccessOpenen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAccessOpenen.Click
        fdlg_Access.Title = "Open MS Access Database"
        fdlg_Access.InitialDirectory = "c:\"
        fdlg_Access.Filter = "MS Access DataBase (.mdb)|*.mdb"
        fdlg_Access.FilterIndex = 0
        fdlg_Access.RestoreDirectory = True
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

    Private Sub InsertConfig(ByVal Data As String)
        Dim ConfigArray() As String = Split(Data, ";")
        Try
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
            MessageBox.Show("Er is een fout gebeurd tijdens het laden van de configuratie.")
        End Try

    End Sub

    Private Sub OverviewToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OpenConfigToolStripMenuItem.Click

        fdlg_OpenConfig.Title = "Open Configuratiebestand"
        fdlg_OpenConfig.InitialDirectory = "c:\"
        fdlg_OpenConfig.Filter = "Configuratiebestanden (.cfg)|*.cfg|Alle bestanden (*.*)|*.*"
        fdlg_OpenConfig.FilterIndex = 0
        fdlg_OpenConfig.RestoreDirectory = True
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
        Dim Data As String = String.Empty
        Dim sqlserver As String = String.Empty
        Dim sqldatabase As String = String.Empty
        Dim sqlgebruiker As String = String.Empty
        'Dim sqlpaswoord As String = String.Empty
        Dim sqlintegratedsecurity As String = String.Empty
        Dim accessdatabase As String = String.Empty
        Dim accesstabel As String = String.Empty
        Dim accesskolom As String = String.Empty
        If (Me.chkSQLOpslaan.Checked) Then
            sqlserver = Me.txtSQLServer.Text
            sqldatabase = Me.txtSQLDatabase.Text
            sqlgebruiker = Me.txtSQLGebruiker.Text
            'sqlpaswoord  = Me.txtSQLPaswoord.Text
            sqlintegratedsecurity = Me.chkIntegratedSecurity.Checked.ToString
        End If
        If (Me.chkAccessOpslaan.Checked) Then
            accessdatabase = Me.txtAccessBestand.Text
            accesstabel = Me.txtAccessTabel.Text
            accesskolom = Me.txtAccessKolom.Text
        End If

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

        Data = String.Concat(sqlserver, ";", sqldatabase, ";", sqlgebruiker, ";", sqlintegratedsecurity, ";", accessdatabase, ";", accesstabel, ";", accesskolom)

        Dim configopslaan As New SaveFileDialog
        With configopslaan
            .DefaultExt = "cfg"
            .FileName = "sqlconfig"
            .Filter = "Configuratiebestanden (*.cfg)|*.cfg|Alle bestanden (*.*)|*.*"
            .FilterIndex = 1
            .OverwritePrompt = True
            .Title = "Configuratie Opslaan"
        End With

        If configopslaan.ShowDialog = DialogResult.OK Then
            Try
                Dim bestandspad As String
                bestandspad = System.IO.Path.Combine(My.Computer.FileSystem.SpecialDirectories.MyDocuments, configopslaan.FileName)
                My.Computer.FileSystem.WriteAllText(bestandspad, Data, False)
            Catch ex As Exception
                Throw ex
            End Try
        End If

        configopslaan.Dispose()
        configopslaan = Nothing
    End Sub

    Private Sub btnSQLTestConnectie_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSQLTestConnectie.Click
        CheckSQLconnectie()
    End Sub

    Private Sub btnUseConfig_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUseConfig.Click
        Dim SQLConnectiestring As String = String.Empty
        Dim AccessConnectieString As String = String.Empty
        Dim AccessSQLString As String = String.Empty
        Dim sqlserver As String = Me.txtSQLServer.Text
        Dim sqldatabase As String = Me.txtSQLDatabase.Text
        Dim sqlgebruiker As String = Me.txtSQLGebruiker.Text
        Dim sqlpaswoord As String = Me.txtSQLPaswoord.Text
        Dim sqlintegratedsecurity As Boolean = Me.chkIntegratedSecurity.Checked
        Dim accessdatabase As String = Me.txtAccessBestand.Text
        Dim accesstabel As String = Me.txtAccessTabel.Text
        Dim accesskolom As String = Me.txtAccessKolom.Text

        If sqlserver = String.Empty Or sqldatabase = String.Empty Or accessdatabase = String.Empty Or accessdatabase = String.Empty Or accesskolom = String.Empty _
        Or (sqlintegratedsecurity = False And (sqlgebruiker = String.Empty Or sqlpaswoord = String.Empty)) Then
            MessageBox.Show("Een of meerdere vereiste tekstvakken zijn niet ingevuld.")
            Exit Sub
        End If

        If (Me.lblAccessGeldig.Text = "Ongeldig" Or Me.lblSQLGeldig.Text = "Ongeldig") Then
            MessageBox.Show("Gelieve na te kijken of beide connecties geldig zijn.")
            Exit Sub
        End If

        SQLConnectiestring = String.Concat("Data Source=", sqlserver, ";Initial Catalog=", sqldatabase)
        If (sqlintegratedsecurity) Then
            SQLConnectiestring = String.Concat(SQLConnectiestring, ";Integrated Security=True")
        Else
            SQLConnectiestring = String.Concat(SQLConnectiestring, ";Persist Security Info=True;User ID=", sqlgebruiker, ";Password=", sqlpaswoord)
        End If

        frmHoofdMenu.mySQLConnection.p_mConnectionString = SQLConnectiestring
        frmHoofdMenu.BlnSQLConnectieGelukt = frmHoofdMenu.mySQLConnection.f_VerbindMetDatabase()

        AccessConnectieString = String.Concat("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=", accessdatabase)
        AccessSQLString = String.Concat("SELECT ", accesskolom, " FROM ", accesstabel)
        frmHoofdMenu.myAccessConnection.p_mConnectionString = AccessConnectieString
        frmHoofdMenu.myAccessConnection.p_mSQLString = AccessSQLString
        frmHoofdMenu.BlnAccessConnectieGelukt = frmHoofdMenu.myAccessConnection.f_fill()

        frmHoofdMenu.StudentenToolStripMenuItem.Enabled = True
        Me.Close()
    End Sub
End Class