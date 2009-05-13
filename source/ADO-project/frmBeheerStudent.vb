Imports System.Text.RegularExpressions

Public Class frmBeheerStudent

#Region "Private Variabelen"
    Private Structure TekstControl
        Public Control As Control
        Public Label As String
        Public Type As String
    End Structure

    Private mBlnNewStudent As Boolean = False
    Private mTekstControls(6) As TekstControl
#End Region

#Region "Form Load"
    Private Sub frmViaSql_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Onze Text Controls inladen in onze Struct
        Call FillTextControls()

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
#End Region

#Region "Toolstrip Menu Item Events"
    Private Sub DetailToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DetailToolStripMenuItem.Click
        Dim MyDataRowView As DataRowView
        Dim iStudentID As Int16 = Me.cboNaamData.SelectedValue

        If iStudentID = -1 Or Me.cboNaamData.Text = String.Empty Then
            MessageBox.Show("U heeft geen student geselecteerd!")
            Exit Sub
        End If

        'Data uit de DataRowView overkopiëren
        MyDataRowView = frmHoofdMenu.mySQLConnection.f_ToonStudentDetails(iStudentID)

        Me.txtNaam.Text = MyDataRowView.Item("StudentNaam").ToString
        Me.txtVoornaam.Text = MyDataRowView.Item("StudentVoornaam").ToString
        Me.txtGSM.Text = MyDataRowView.Item("StudentGSM").ToString
        Me.txtSchoolMail.Text = MyDataRowView.Item("StudentSchoolEmail").ToString
        Me.txtPriveMail.Text = MyDataRowView.Item("StudentPriveEmail").ToString
        Me.dtpGebDat.Text = MyDataRowView.Item("StudentGebDat").ToString
        Me.txtFinRek.Text = MyDataRowView.Item("StudentFinRek").ToString

        Call MenuEnab(3)
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
        Dim fouten As String = CheckClear()
        If (fouten = String.Empty) Then

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
            MessageBox.Show(fouten, "Ongeldig formulier", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        If (frmHoofdMenu.mySQLConnection.f_VerwijderStudent(Me.cboNaamData.SelectedValue, Me.cboNaamData.SelectedIndex)) Then
            Call ConClear()
            MessageBox.Show("Student verwijderd.", "Student Verwijderd", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End If
    End Sub

    Private Sub CancelToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelToolStripMenuItem.Click
        Call MenuEnab(1)
        Call ConEnab(False)
        mBlnNewStudent = False
    End Sub

    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        frmHoofdMenu.ToonStartScherm()
    End Sub
#End Region

#Region "Student Mailen Event"
    Private Sub btnStudentMail_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStudentMail.Click
        If (EmailAddressCheck(Me.txtSchoolMail.Text)) Then
            Process.Start(String.Concat("mailto:", " ", "?bcc=", Me.txtSchoolMail.Text, "&subject=Vult zelf is iets in luierik!! &body="))
        End If
    End Sub
#End Region

#Region "OnTextChanged Events"
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

    Private Sub cboNaamData_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboNaamData.TextChanged
        Call MenuEnab(1)
        Call ConClear()
        Call ConEnab(False)
    End Sub

    Private Sub txtNaam_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtNaam.TextChanged
        Call CheckTekst(Me.txtNaam.Text, Me.lblNaamgeldig, Me.picNaamGeldig, "Naam")
    End Sub

    Private Sub txtVoornaam_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtVoornaam.TextChanged
        Call CheckTekst(Me.txtVoornaam.Text, Me.lblVoornaamGeldig, Me.picVoornaamGeldig, "Voornaam")
    End Sub

    Private Sub txtGSM_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtGSM.TextChanged
        Call CheckGSM(Me.txtGSM.Text, Me.lblGSMGeldig, Me.picGSMGeldig, "GSM")
    End Sub

    Private Sub txtSchoolMail_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtSchoolMail.TextChanged
        Call CheckEmail(Me.txtSchoolMail.Text, Me.lblSchoolMailGeldig, Me.picSchoolMailGeldig, "School-mail")
    End Sub

    Private Sub txtPriveMail_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtPriveMail.TextChanged
        Call CheckEmail(Me.txtPriveMail.Text, Me.lblPriveMailGeldig, Me.picPriveMailGeldig, "Privé-mail")
    End Sub

    Private Sub dtpGebDat_ValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles dtpGebDat.ValueChanged
        Call CheckGeboorteDatum(Me.lblGeboorteDatumGeldig, Me.picGeboorteDatumGeldig, "Geboortedatum")
    End Sub

    Private Sub txtFinRek_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtFinRek.TextChanged
        Call CheckRekening(Me.txtFinRek.Text, Me.lblGeldigeRekening, Me.picGeldigeRekening, "Rekening")
    End Sub
#End Region

#Region "Formcontrole"
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
        Dim i As Int16
        For i = 0 To mTekstControls.Length() - 1
            mTekstControls(i).Control.Enabled = BlnEnabled
        Next i
    End Sub

    Private Sub ConClear()
        Dim i As Int16
        For i = 0 To mTekstControls.Length() - 2
            mTekstControls(i).Control.Text = String.Empty
        Next i
        mTekstControls(6).Control.Text = "01-01-1980"
    End Sub

    Private Sub SetGeldig(ByVal Geldig As Boolean, ByVal LabelControl As Label, ByVal ImageControl As PictureBox, ByVal LabelString As String)
        If (Geldig) Then
            ImageControl.Image = My.Resources.tick
            LabelControl.Text = String.Concat(LabelString, " Geldig")
            LabelControl.ForeColor = Color.ForestGreen
        Else
            ImageControl.Image = My.Resources.remove
            LabelControl.Text = String.Concat(LabelString, " Ongeldig")
            LabelControl.ForeColor = Color.Firebrick
        End If
    End Sub

    Private Sub CheckGeboorteDatum(ByVal LabelControl As Label, ByVal ImageControl As PictureBox, ByVal LabelString As String)
        Call SetGeldig(True, LabelControl, ImageControl, LabelString)
    End Sub

    Private Sub CheckEmail(ByVal EmailAdres As String, ByVal LabelControl As Label, ByVal ImageControl As PictureBox, ByVal LabelString As String)
        Dim IsAdresGeldig As Boolean = EmailAddressCheck(EmailAdres)

        Call SetGeldig(IsAdresGeldig, LabelControl, ImageControl, LabelString)

        If (LabelString = "School-mail") Then
            If IsAdresGeldig Then
                Me.btnStudentMail.Enabled = True
            Else
                Me.btnStudentMail.Enabled = False
            End If
        Else
            Me.btnStudentMail.Enabled = False
        End If

    End Sub

    Private Sub CheckRekening(ByVal RekeningString As String, ByVal LabelControl As Label, ByVal ImageControl As PictureBox, ByVal LabelString As String)
        Call SetGeldig(GeldigeRekening(RekeningString), LabelControl, ImageControl, LabelString)
    End Sub

    Private Sub CheckTekst(ByVal Tekst As String, ByVal LabelControl As Label, ByVal ImageControl As PictureBox, ByVal LabelString As String)
        Call SetGeldig(TekstCheck(Tekst), LabelControl, ImageControl, LabelString)
    End Sub

    Private Sub CheckGSM(ByVal nummer As String, ByVal LabelControl As Label, ByVal ImageControl As PictureBox, ByVal LabelString As String)
        Call SetGeldig(GSMValidatie(nummer), LabelControl, ImageControl, LabelString)
    End Sub
#End Region

#Region "Algemene Validatie"
    Private Function CheckClear() As String
        'Index
        Dim i As Int16 = 0

        'Boolean die bepaalt of we aan het laatste tekstveld zitten
        'Variabelen voor de errors.
        Dim aantalerrors As Int16 = 0
        Dim errors As String = String.Empty

        While (i < mTekstControls.Length())

            Select Case mTekstControls(i).Type
                Case "Text"
                    If (Not TekstCheck(mTekstControls(i).Control.Text)) Then
                        errors = VoegErrorToe(errors, mTekstControls(i).Label, aantalerrors)
                        aantalerrors = aantalerrors + 1
                    End If
                Case "Mail"
                    If (Not EmailAddressCheck(mTekstControls(i).Control.Text)) Then
                        errors = VoegErrorToe(errors, mTekstControls(i).Label, aantalerrors)
                        aantalerrors = aantalerrors + 1
                    End If
                Case "Rekening"
                    If (Not GeldigeRekening(mTekstControls(i).Control.Text)) Then
                        errors = VoegErrorToe(errors, mTekstControls(i).Label, aantalerrors)
                        aantalerrors = aantalerrors + 1
                    End If
                Case "Datum"
                    'Niks doen
                Case "Telefoon"
                    If (Not GSMValidatie(mTekstControls(i).Control.Text)) Then
                        errors = VoegErrorToe(errors, mTekstControls(i).Label, aantalerrors)
                        aantalerrors = aantalerrors + 1
                    End If
                Case Else
                    Return "Ongeldig type! Contacteer een programmeur."

            End Select

            i = i + 1
        End While

        If (aantalerrors > 0) Then
            If (aantalerrors > 1) Then
                errors = String.Concat("De volgende tekstvelden zijn incorrect ingevuld: ", errors)
            Else
                errors = String.Concat("Het volgende tekstveld is incorrect ingevuld: ", errors)
            End If
        End If

        Return errors
    End Function

    Private Function VoegErrorToe(ByVal errorlist As String, ByVal label As String, ByVal errorcount As Int16) As String

        If (errorcount >= 1) Then
            errorlist = String.Concat(errorlist, ", ")
        End If

        errorlist = String.Concat(errorlist, label)

        Return errorlist
    End Function
#End Region

#Region "Tekstvalidatie"
    Private Function TekstCheck(ByVal Text As String) As Boolean
        If (Text = String.Empty Or BestaatUitSpatiesOfTabs(Text) = True) Then
            Return False
        Else
            Return True
        End If
    End Function

    Private Function BestaatUitSpatiesOfTabs(ByVal Text As String) As Boolean
        If (Text.Length > 0) Then
            'Het patroon \s is gelijk aan een spatie, tab of line break
            Dim bestaatuitwitruimtes As Match = Regex.Match(Text, "^\s*$")
            If (bestaatuitwitruimtes.Success) Then
                Return True
            Else
                Return False
            End If
        End If

        Return True
    End Function
#End Region

#Region "E-mailvalidatie"
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
            Return True
        Else
            Return False
        End If

    End Function
#End Region

#Region "GSM-validatie"
    Private Function GSMValidatie(ByVal nummer As String) As Boolean
        If (Not nummer = String.Empty And nummer.Length() >= 3) Then

            'Alles is optioneel wegens de {0,x} achter de elke reeks brackets, behalve achter de laatste reeks cijfers.
            'Voorbeeld van een geldig nummer:
            '                                +        0032    spatie   (      0497        ) spatie    79         -         39          -         55 
            Dim geldigetekens As String = "^[+]{0,1}[0-9]{0,4}[-\/() ]{0,2}[0-9]{0,4}[-\/() ]{0,2}[0-9]{0,4}[-\/() ]{0,1}[0-9]{0,4}[-\/() ]{0,1}[0-9]*$"

            'We vergelijken het nummer met onze filter.
            Dim gsmmatch As Match = Regex.Match(nummer, geldigetekens)

            If gsmmatch.Success Then
                Return True
            Else
                Return False
            End If

        Else
            Return False
        End If
    End Function
#End Region

#Region "Rekeningvalidatie"
    Private Function GeldigeRekening(ByVal rekening As String) As Boolean
        If (Not rekening = String.Empty And rekening.Length() = 14) Then

            Dim rekeningarray() As String = rekening.Split("-")

            If (rekeningarray.Length = 3) Then
                If (Not rekeningarray(0) = String.Empty And Not rekeningarray(1) = String.Empty And Not rekeningarray(2) = String.Empty) Then
                    Dim ab As String = rekeningarray(0) & rekeningarray(1)
                    Dim c As String = rekeningarray(2)
                    Try
                        Dim d As Int64 = Convert.ToInt64(ab) Mod 97

                        If ((d = Convert.ToInt64(c))) Then
                            Return True
                        Else
                            Return False
                        End If
                    Catch
                        Return False
                    End Try
                End If
            End If
        End If

        Return False
    End Function
#End Region

#Region "Tekstcontroles uit form inladen"
    Private Sub FillTextControls()
        mTekstControls(0).Control = Me.txtNaam
        mTekstControls(0).Label = Me.lblNaam.Text
        mTekstControls(0).Type = "Text"
        mTekstControls(1).Control = Me.txtVoornaam
        mTekstControls(1).Label = Me.lblVoornaam.Text
        mTekstControls(1).Type = "Text"
        mTekstControls(2).Control = Me.txtGSM
        mTekstControls(2).Label = Me.lblGSM.Text
        mTekstControls(2).Type = "Telefoon"
        mTekstControls(3).Control = Me.txtPriveMail
        mTekstControls(3).Label = Me.lblPriveMail.Text
        mTekstControls(3).Type = "Mail"
        mTekstControls(4).Control = Me.txtSchoolMail
        mTekstControls(4).Label = Me.lblSchoolMail.Text
        mTekstControls(4).Type = "Mail"
        mTekstControls(5).Control = Me.txtFinRek
        mTekstControls(5).Label = Me.lblFinRek.Text
        mTekstControls(5).Type = "Rekening"
        mTekstControls(6).Control = Me.dtpGebDat
        mTekstControls(6).Label = Me.lblGebDat.Text
        mTekstControls(6).Type = "Datum"
    End Sub
#End Region

End Class