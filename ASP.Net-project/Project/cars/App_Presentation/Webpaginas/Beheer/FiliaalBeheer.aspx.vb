
Partial Class App_Presentation_Webpaginas_FiliaalBeheer
    Inherits System.Web.UI.Page
    Private _filiaalbll As New FiliaalBLL

    Private Sub ClearWijzigTextBoxes()
        Me.txtFiliaalWijzigenNaam.Text = String.Empty
        Me.txtFiliaalWijzigenLocatie.Text = String.Empty
        Me.txtFiliaalWijzigenStraatNr.Text = String.Empty
    End Sub

    Protected Sub btnVoegtoe_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVoegtoe.Click
        Dim dt As New Autos.tblFiliaalDataTable
        Dim f As Autos.tblFiliaalRow = dt.NewRow

        f.filiaalLocatie = String.Concat(txtLocatie.Text, ", ", txtAdres.Text)
        f.filiaalNaam = txtFiliaalNaam.Text
        f.parkingAantalKolommen = 0
        f.parkingAantalRijen = 0

        If _filiaalbll.AddFiliaal(f) Then
            lblGeslaagd.Text = "Filiaal is toegevoegd."
            ddlFiliaal.DataBind()
            ddlFilialen.DataBind()
            Me.txtAdres.Text = String.Empty
            Me.txtLocatie.Text = String.Empty
            Me.txtFiliaalNaam.Text = String.Empty
        End If





    End Sub

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        Dim pfiliaalID As Integer
        pfiliaalID = Me.ddlFiliaal.SelectedValue

        If _filiaalbll.DeleteFiliaal(pfiliaalID) Then
            ddlFiliaal.DataBind()
            ddlFilialen.DataBind()
            lblDelete.Text = "filiaal verwijderd"
            ClearWijzigTextBoxes()
        End If

    End Sub

    Protected Sub ddlFilialen_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlFilialen.SelectedIndexChanged

        Dim dt As Autos.tblFiliaalDataTable = _filiaalbll.GetFiliaalByFiliaalID(Me.ddlFilialen.SelectedValue)
        Dim row As Autos.tblFiliaalRow = dt.Item(0)

        If (row.filiaalLocatie = "DUMMY_FILIAAL") Then
            ClearWijzigTextBoxes()
            Return
        End If


        Me.txtFiliaalWijzigenNaam.Text = row.filiaalNaam
        Dim split() As String = row.filiaalLocatie.Split(",")
        Me.txtFiliaalWijzigenLocatie.Text = split(0).Trim
        Me.txtFiliaalWijzigenStraatNr.Text = split(1).Trim
    End Sub

    Protected Sub btnFiliaalWijzigen_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFiliaalWijzigen.Click
        Dim dt As New Autos.tblFiliaalDataTable
        Dim f As Autos.tblFiliaalRow = dt.NewRow

        f.filiaalID = Me.ddlFilialen.SelectedValue
        f.filiaalLocatie = String.Concat(Me.txtFiliaalWijzigenLocatie.Text, ", ", Me.txtFiliaalWijzigenStraatNr.Text)
        f.filiaalNaam = Me.txtFiliaalWijzigenNaam.Text

        If _filiaalbll.UpdateFiliaal(f) Then
            lblUpdate.Text = "wijziging uitgevoerd."
            ClearWijzigTextBoxes()
        End If
    End Sub
End Class
