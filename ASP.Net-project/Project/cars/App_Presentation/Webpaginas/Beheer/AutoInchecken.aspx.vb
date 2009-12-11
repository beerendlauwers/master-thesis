
Partial Class App_Presentation_Webpaginas_Beheer_AutoInchecken
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim autobll As New AutoBLL
        Dim kentekens() As String = autobll.GetAllKentekens()

        For Each waarde In kentekens
            Me.ddlKenteken.Items.Add(waarde)
        Next

        txtDatum.Text = DateTime.Now.Date()


    End Sub

    Protected Sub cmdCheckIn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmdCheckIn.Click

        Dim BLLReservatie As New ReservatieBLL
        Dim DTReservatie As Reservaties.tblReservatieDataTable
        Dim DRReservatie As Reservaties.tblReservatieRow

        DTReservatie = BLLReservatie.GetReservatieByReservatieID(txtResID.Text)
        DRReservatie = DTReservatie.Rows(0)

        Dim BLLAuto As New AutoBLL
        Dim DTAuto As Autos.tblAutoDataTable
        Dim DRAuto As Autos.tblAutoRow

        DTAuto = BLLAuto.GetAutoByAutoID(DRReservatie.autoID)
        DRAuto = DTAuto.Rows(0)

        Dim DatNu, DatRes As Date
        

        Dim ts As TimeSpan = CDate(txtDatum.Text).Subtract(DRReservatie.reservatieEinddat)

        If ts.Days <= 0 Then
            txtBoete.Enabled = False
        Else
            txtBoete.Text = ts.Days * DRAuto.autoDagTarief
        End If

    End Sub
End Class
