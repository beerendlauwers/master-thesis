
Partial Class _404
    Inherits System.Web.UI.Page

    Protected Sub lbl404Uitleg_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbl404Uitleg.Load
        Me.lbl404uitleg.Text = Lokalisatie.GetString("PAGINANIETGEVONDEN")
        Page.Title = Lokalisatie.GetString("PAGINANIETGEVONDENTITEL")
    End Sub
End Class
