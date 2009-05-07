Imports System.Text.RegularExpressions

Public Class frmBeheerStudent
    Private mBlnNewStudent As Boolean = False
    Private mCollection As Collection

    Private Sub frmViaSql_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Combobox invullen
        Me.cboNaamFilter.Items.Add("Naam")
        Me.cboNaamFilter.Items.Add("Voornaam")
        Me.cboNaamFilter.SelectedIndex = 0

        'Alle textvelden disablen
        Call ConEnab(False)
        Call MenuEnab(1)

        'De tblStudent ophalen
        If (frmHoofdMenu.BlnSQLConnectieGelukt) Then
            Me.cboNaamData.DataSource = frmHoofdMenu.mySQLConnection.p_datavStud
        End If
    End Sub

    Private Sub DetailToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DetailToolStripMenuItem.Click
        Dim MyDataRowView As DataRowView
        Dim iStudentID As Int16 = Me.cboNaamData.SelectedValue

        If iStudentID = -1 Then
            MessageBox.Show("U heeft geen student geselecteerd!")
            Exit Sub
        End If

        'Data uit de DataRowView overkopiëren
        MyDataRowView = frmHoofdMenu.mySQLConnection.f_ToonStudentDetails(iStudentID)

        Me.txtNaam.DataBindings.Add("text", MyDataRowView, "StudentNaam")
        Me.txtNaam.DataBindings.Clear()
        Me.txtVoornaam.DataBindings.Add("text", MyDataRowView, "StudentVoornaam")
        Me.txtVoornaam.DataBindings.Clear()
        Me.txtGSM.DataBindings.Add("text", MyDataRowView, "StudentGSM")
        Me.txtGSM.DataBindings.Clear()
        Me.txtSchoolMail.DataBindings.Add("text", MyDataRowView, "StudentSchoolEmail")
        Me.txtSchoolMail.DataBindings.Clear()
        Me.txtPriveMail.DataBindings.Add("text", MyDataRowView, "StudentPriveEmail")
        Me.txtPriveMail.DataBindings.Clear()
        Me.dtpGebDat.DataBindings.Add("text", MyDataRowView, "StudentGebDat")
        Me.dtpGebDat.DataBindings.Clear()
        Me.txtFinRek.DataBindings.Add("text", MyDataRowView, "StudentFinRek")
        Me.txtFinRek.DataBindings.Clear()

        Call MenuEnab(3)
    End Sub

    Private Sub MenuEnab(ByVal i_situatie As String)
        Select Case i_situatie
            Case 1 'Form load
                Me.EditToolStripMenuItem.Enabled = False
                Me.DetailToolStripMenuItem.Enabled = True
                Me.SaveToolStripMenuItem.Enabled = False
                Me.NewToolStripMenuItem.Enabled = True
                Me.DeleteToolStripMenuItem.Enabled = False
                Me.CancelToolStripMenuItem.Enabled = False
                Me.ExitToolStripMenuItem.Enabled = True
            Case 2 'Geklikt op New
                Me.EditToolStripMenuItem.Enabled = False
                Me.DetailToolStripMenuItem.Enabled = False
                Me.SaveToolStripMenuItem.Enabled = True
                Me.NewToolStripMenuItem.Enabled = False
                Me.DeleteToolStripMenuItem.Enabled = False
                Me.CancelToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = False
            Case 3 'Geklikt op Detail
                Me.EditToolStripMenuItem.Enabled = True
                Me.DetailToolStripMenuItem.Enabled = False
                Me.SaveToolStripMenuItem.Enabled = False
                Me.NewToolStripMenuItem.Enabled = False
                Me.DeleteToolStripMenuItem.Enabled = True
                Me.CancelToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = True
                Me.btnStudentMail.Enabled = True
            Case 4 'Geklikt op Edit
                Me.EditToolStripMenuItem.Enabled = False
                Me.DetailToolStripMenuItem.Enabled = False
                Me.SaveToolStripMenuItem.Enabled = True
                Me.NewToolStripMenuItem.Enabled = False
                Me.DeleteToolStripMenuItem.Enabled = False
                Me.CancelToolStripMenuItem.Enabled = True
                Me.ExitToolStripMenuItem.Enabled = False
        End Select
    End Sub

    Private Sub ConEnab(ByVal BlnEnabled As Boolean)
        Me.txtVoornaam.Enabled = BlnEnabled
        Me.txtNaam.Enabled = BlnEnabled
        Me.txtGSM.Enabled = BlnEnabled
        Me.txtFinRek.Enabled = BlnEnabled
        Me.txtPriveMail.Enabled = BlnEnabled
        Me.txtSchoolMail.Enabled = BlnEnabled
        Me.dtpGebDat.Enabled = BlnEnabled
        Me.btnStudentMail.Enabled = BlnEnabled
    End Sub

    Private Sub ConClear()
        Me.txtVoornaam.Text = String.Empty
        Me.txtNaam.Text = String.Empty
        Me.txtGSM.Text = String.Empty
        Me.txtFinRek.Text = String.Empty
        Me.txtPriveMail.Text = String.Empty
        Me.txtSchoolMail.Text = String.Empty
        Me.dtpGebDat.Value = "01-01-1980"
    End Sub


    Private Sub CancelToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelToolStripMenuItem.Click
        Call MenuEnab(1)
        Call ConEnab(False)
        mBlnNewStudent = False
    End Sub

    Private Sub NewToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewToolStripMenuItem.Click
        Call MenuEnab(2)
        Call ConEnab(True)
        Call ConClear()
        Me.txtNaam.Focus()
        mBlnNewStudent = True
    End Sub

    Private Sub EditToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditToolStripMenuItem.Click
        Call ConEnab(True)
        Call MenuEnab(4)
        mBlnNewStudent = False
    End Sub

    Private Sub SaveToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveToolStripMenuItem.Click
        If (CheckClear()) Then

            If (Not EmailAddressCheck(Me.txtPriveMail.Text) And Not EmailAddressCheck(Me.txtSchoolMail.Text)) Then
                MsgBox("De tekstvelden 'Privé-mail' en 'Schoolmail' zijn incorrect ingevuld.")
                Exit Sub
            End If
            If (Not EmailAddressCheck(Me.txtPriveMail.Text)) Then
                MsgBox("Het tekstveld 'Privé-mail' is incorrect ingevuld.")
                Exit Sub
            End If
            If (Not EmailAddressCheck(Me.txtSchoolMail.Text)) Then
                MsgBox("Het tekstveld 'Schoolmail' is incorrect ingevuld.")
                Exit Sub
            End If

            If (mBlnNewStudent) Then
                'Als er een nieuwe student wordt toegevoegd, voeren we deze functie uit:
                Dim newID = frmHoofdMenu.mySQLConnection.f_NieuweStudent(Me.txtNaam.Text, Me.txtVoornaam.Text, Me.txtGSM.Text, Me.txtSchoolMail.Text, Me.txtPriveMail.Text, Me.dtpGebDat.Text, Me.txtFinRek.Text)
            Else
                'Anders voeren we de update-functie uit:
                frmHoofdMenu.mySQLConnection.f_UpdateStudent(Me.txtNaam.Text, Me.txtVoornaam.Text, Me.txtGSM.Text, Me.txtSchoolMail.Text, Me.txtPriveMail.Text, Me.dtpGebDat.Text, Me.txtFinRek.Text, Me.cboNaamData.SelectedValue, Me.cboNaamData.SelectedIndex)
            End If
            Call MenuEnab(1)
            Call ConEnab(False)
        Else
            MsgBox("Er zijn één of meerdere velden niet ingevuld.")
            Exit Sub
        End If
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        If (frmHoofdMenu.mySQLConnection.f_VerwijderStudent(Me.cboNaamData.SelectedValue, Me.cboNaamData.SelectedIndex)) Then
            Call ConClear()
            MsgBox("Student verwijderd.")
        End If
    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        frmHoofdMenu.ToonStartScherm()
    End Sub

    Private Function CheckClear() As Boolean
        Dim blntest As Boolean = True
        Dim TextControl As Control
        For Each TextControl In Controls
            If TextControl.Name.Substring(0, 3) = "txt" Then
                If (TextControl.Text = String.Empty) Then
                    Return blntest = False
                    Exit Function
                End If
            End If
        Next
        Return blntest
    End Function

    Private Sub cboStudentNaam_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboNaamFilter.TextChanged

        frmHoofdMenu.mySQLConnection.s_FilterStudentOp(Me.cboNaamFilter.Text)

        If (Me.cboNaamFilter.Text = "Naam") Then
            Me.cboNaamData.DisplayMember = "StudentNaam"
        Else
            Me.cboNaamData.DisplayMember = "StudentVoornaam"
        End If
        Me.cboNaamData.ValueMember = "StudentID"

        Call MenuEnab(1)
        Call ConClear()
        Call ConEnab(False)
    End Sub

    Function EmailAddressCheck(ByVal emailAddress As String) As Boolean
        'Uitleg: ^ zorgt ervoor dat ons patroon bij het begin van de string begint te zoeken.
        'De [a-zA-Z] laat ons toe alle soorten letters te typen.
        ' \w refereert naar [A-Za-z0-9_], \. laat ons toe een punt te typen,
        'en de - laat ons een minpunt typen. De * laat ons toe deze voorgaande
        'patronen oneindig toe te passen. [a-zA-Z0-9] zoekt dan nog eens naar alle
        'letters en nummers om bv. adressen zoals 'beerend.lauwers' te vangen. Hierna komt de @ .
        'Na de @ hebben we opnieuw de bovengenoemde filters, dan een punt ( \. ),
        'En dan zoeken we naar geldig top-level domains, die tevens een punt mogen
        'bevatten. het $ teken betekent dat deze filter op het einde van de string moet worden toegepast.
        Dim pattern As String = "^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
        'We vergelijken het email-adres met onze filter.
        Dim emailAddressMatch As Match = Regex.Match(emailAddress, pattern)
        If emailAddressMatch.Success Then
            EmailAddressCheck = True
        Else
            EmailAddressCheck = False
        End If
    End Function

    Private Sub cboNaamData_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboNaamData.TextChanged
        Call MenuEnab(1)
        Call ConClear()
        Call ConEnab(False)
    End Sub

    Private Sub btnStudentMail_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStudentMail.Click
        Process.Start("mailto:" & Me.txtSchoolMail.Text & "?subject=Vult zelf is iets in luierik!! &body=")
    End Sub

    Private Sub MenuStrip1_ItemClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ToolStripItemClickedEventArgs) Handles MenuStrip1.ItemClicked

    End Sub

    Private Sub txtFinRek_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtFinRek.TextChanged
        Dim rekeningstring As String = Me.txtFinRek.Text

        If (Not rekeningstring = String.Empty) Then
            Dim rekeningarray() As String = rekeningstring.Split("-")
            Dim ab As String = rekeningarray(0) & rekeningarray(1)
            Dim c As String = rekeningarray(2)
            Dim d As Int32 = CInt(ab) Mod 97
            If (d = CInt(c)) Then
                Me.pctGeldigeRekening.Image = My.Resources.tick
                Me.lblGeldigeRekening.Text = "Rekening Geldig"
                Me.lblGeldigeRekening.ForeColor = Color.ForestGreen
            Else
                Me.pctGeldigeRekening.Image = My.Resources.remove
                Me.lblGeldigeRekening.Text = "Rekening Ongeldig"
                Me.lblGeldigeRekening.ForeColor = Color.Firebrick
            End If
        End If
    End Sub
End Class