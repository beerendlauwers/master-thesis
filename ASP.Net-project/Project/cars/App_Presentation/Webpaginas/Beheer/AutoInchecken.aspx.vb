
Partial Class App_Presentation_Webpaginas_Beheer_AutoInchecken
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Dim autobll As New AutoBLL
        'Dim kentekens() As String = autobll.GetAllKentekens()

        'For Each waarde In kentekens
        '    Me.ddlKenteken.Items.Add(waarde)
        'Next

        If Not IsPostBack Then
            txtDatum.Text = DateTime.Now.Date()
            'txtBoete.Enabled = False
            chkProblematisch.Checked = False
        End If

        



    End Sub

    Protected Sub cmdCheckIn_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmdCheckIn.Click

        Try

            

            ' Reservatie
            Dim BLLReservatie As New ReservatieBLL
            Dim DRReservatie As Reservaties.tblReservatieRow

            DRReservatie = BLLReservatie.GetReservatieByReservatieID(txtResID.Text)

            ' Auto
            Dim BLLAuto As New AutoBLL
            Dim DTAuto As Autos.tblAutoDataTable
            Dim DRAuto As Autos.tblAutoRow

            DTAuto = BLLAuto.GetAutoByAutoID(DRReservatie.autoID)
            DRAuto = DTAuto.Rows(0)

            ' Klant
            Dim BLLKlant As New KlantBLL
            Dim DTKlant As New Klanten.tblUserProfielDataTable
            Dim DRKlant As Klanten.tblUserProfielRow

            '   Hij kan user ID niet inlezen van DRReservatie(verkloot de hele sub)
            DTKlant = BLLKlant.GetUserProfielByUserID(DRReservatie.userID)
            DRKlant = DTKlant.Rows(0)



            ' Instellen Gegevens

            ' Reservatie
            ' Reservatiestatus 4 betekent: uitgecheckt en opnieuw ingecheckt
            DRReservatie.reservatieStatus = 4
            DRReservatie.reservatieIngechecktDoorMedewerker = New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString())

            ' Auto
            DRAuto.statusID = 5 'Vrij(?)

            ' Klant



            If chkProblematisch.Checked = True Then
                DRKlant.userIsProblematisch = 1
            Else
                DRKlant.userIsProblematisch = 0
            End If

            DRKlant.userCommentaar = txtCommentaar.Text

            ' Wegschrijven gegevens

            If (BLLReservatie.UpdateReservatie(DRReservatie)) Then
                'Gelukt!



                If (BLLAuto.UpdateAuto(DRAuto)) Then
                    'Gelukt!
                    lblResultaat.Text = "De auto werd succesvol ingecheckt."
                Else
                    lblResultaat.Text = "Er was een probleem bij het aanpassen van de autogegevens. Contacteer de systeembeheerder."
                End If

                If (BLLKlant.UpdateUserProfiel(DRKlant)) Then
                    'Gelukt!
                    lblResultaat.Text = "De auto werd succesvol ingecheckt."
                Else
                    lblResultaat.Text = "Er was een probleem bij het aanpassen van de klantgegevens. Contacteer de systeembeheerder."
                End If

            Else
                lblResultaat.Text = "Er was een probleem bij het aanpassen van de reservatiegegevens. Contacteer de systeembeheerder."
            End If

            Me.lblResultaat.Visible = True

        Catch ex As Exception
            Throw ex
        End Try


    End Sub

    Private Sub AlterFields()
        ' Boete bepalen


        Dim BLLReservatie As New ReservatieBLL
        Dim DRReservatie As Reservaties.tblReservatieRow

        DRReservatie = BLLReservatie.GetReservatieByReservatieID(txtResID.Text)

        Dim BLLAuto As New AutoBLL
        Dim DTAuto As Autos.tblAutoDataTable
        Dim DRAuto As Autos.tblAutoRow

        DTAuto = BLLAuto.GetAutoByAutoID(DRReservatie.autoID)
        DRAuto = DTAuto.Rows(0)


        ' Berekent aantal dagen te laat

        Dim ts As TimeSpan = CDate(txtDatum.Text).Subtract(DRReservatie.reservatieEinddat)

        If ts.Days <= 0 Then
            txtBoete.Enabled = False
            'MsgBox("ts.Days <= 0")
        Else
            txtBoete.Text = ts.Days * DRAuto.autoDagTarief
            'MsgBox("ts.Days > 0")
        End If



        ' Commentaar bij klant invullen


        Dim BLLKlant As New KlantBLL
        Dim DTKlant As New Klanten.tblUserProfielDataTable
        Dim DRKlant As Klanten.tblUserProfielRow


        'Hij kan user ID niet inlezen van DRReservatie(verkloot de hele sub)
        DTKlant = BLLKlant.GetUserProfielByUserID(DRReservatie.userID)
        DRKlant = DTKlant.Rows(0)

        'commentaar uitlezen
        txtCommentaar.Text = DRKlant.userCommentaar

        'checkbox problematisch instellen

        ' blijkbaar is het veld "UserIsProblematisch een int ipv boolean
        ' Ik ga er van uit dat er dus nog andere bedoelingen bij zijn...
        If DRKlant.userIsProblematisch > 0 Then
            chkProblematisch.Checked = True
        End If

    End Sub

    Protected Sub txtResID_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtResID.TextChanged
        AlterFields()
    End Sub

    Protected Sub txtDatum_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtDatum.TextChanged
        AlterFields()
    End Sub
End Class
