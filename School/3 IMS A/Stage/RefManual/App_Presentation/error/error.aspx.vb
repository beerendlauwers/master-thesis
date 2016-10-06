
Partial Class _error
    Inherits System.Web.UI.Page

    Protected Sub lbl404Uitleg_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbl404Uitleg.Load
        Me.lbl404uitleg.Text = Lokalisatie.GetString("FOUTTIJDENSUITVOERENPAGINA")
        Page.Title = Lokalisatie.GetString("FOUTTIJDENSUITVOERENPAGINATITEL")
    End Sub
End Class
