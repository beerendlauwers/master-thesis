
Partial Class App_Presentation_Webpaginas_Beheer_Onderhoudbeheer
    Inherits System.Web.UI.Page

    Protected Sub repNodigOnderhoudOverzicht_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles repNodigOnderhoudOverzicht.ItemCommand

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim onderhoudbll As New OnderhoudBLL
        Dim autobll As New AutoBLL
        Dim onderhouden As Onderhoud.tblNodigOnderhoudDataTable = onderhoudbll.GetAllNodigOnderhoudVoorVandaag()

        'Dit is onze weergavetabel.
        Dim weergavetabel As New Data.DataTable
        weergavetabel.Columns.Add("Kenteken", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Begindatum", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Einddatum", Type.GetType("System.String"))
        weergavetabel.Columns.Add("MerkModel", Type.GetType("System.String"))
        weergavetabel.Columns.Add("Omschrijving", Type.GetType("System.String"))
        weergavetabel.Columns.Add("controleID", Type.GetType("System.Int32"))

        For Each onderhoud As Onderhoud.tblNodigOnderhoudRow In onderhouden
            'Auto ophalen
            Dim auto As Autos.tblAutoRow = autobll.GetAutoByAutoID(onderhoud.autoID).Rows(0)

            'Nieuwe overzichtsrij
            Dim overzichtrij As Data.DataRow = weergavetabel.NewRow

            'Alle data invullen
            overzichtrij.Item("Kenteken") = auto.autoKenteken
            overzichtrij.Item("MerkModel") = autobll.GetAutoNaamByAutoID(auto.autoID)
            overzichtrij.Item("Begindatum") = Format(onderhoud.nodigOnderhoudBegindat, "dd/MM/yyyy")
            overzichtrij.Item("Einddatum") = Format(onderhoud.nodigOnderhoudEinddat, "dd/MM/yyyy")
            overzichtrij.Item("Omschrijving") = onderhoud.nodigOnderhoudOmschrijving
            overzichtrij.Item("controleID") = onderhoud.controleID

            'Rij toevoegen
            weergavetabel.Rows.Add(overzichtrij)
        Next onderhoud

        If (weergavetabel.Rows.Count = 0) Then
            Me.divOnderhoudVandaag.Visible = False
            Me.lblGeenOnderhoudVandaag.Text = "Er zijn geen geplande onderhouden voor vandaag."
            Me.lblGeenOnderhoudVandaag.Visible = True
        Else
            Me.repOnderhoudVoorVandaag.DataSource = weergavetabel
            Me.repOnderhoudVoorVandaag.DataBind()
            Me.divOnderhoudVandaag.Visible = True
            Me.lblGeenOnderhoudVandaag.Visible = False
        End If

    End Sub
End Class
