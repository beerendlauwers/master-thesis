Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Presentation_Webpaginas_GebruikersOnly_Reserveer
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("autoID") IsNot Nothing And _
        Request.QueryString("begindat") IsNot Nothing And _
        Request.QueryString("einddat") IsNot Nothing And _
        Request.QueryString("userID") IsNot Nothing Then

            If (Request.QueryString("userID") = "00000000-0000-0000-0000-000000000000") Then
                'Dit is een anonieme gebruiker. We sturen hem naar MaakNieuweGebruikerAan.aspx

                'Alles opslaan in een cookie
                Dim tempCookie As New HttpCookie("reservatieCookie")
                tempCookie.Expires = DateTime.Now.AddDays(2)
                tempCookie("autoID") = Request.QueryString("autoID")
                tempCookie("begindat") = Request.QueryString("begindat")
                tempCookie("einddat") = Request.QueryString("einddat")
                Response.Cookies.Add(tempCookie)

                'En wegsturen maar
                Response.Redirect("~/App_Presentation/Webpaginas/NieuweGebruikerAanmaken.aspx")
            End If

            'Nog eens een opvangnetje voor anonieme gebruikers als de vorige niet werkte
            If (Not User.Identity.IsAuthenticated) Then
                MsgBox("U bent niet ingelogd.")
            End If

            Try
                'Als we hier zijn geraakt, is de gebruiker een geauthenticeerde gebruiker.
                Dim reservatiebll As New ReservatieBLL
                Dim dt As New Reservaties.tblReservatieDataTable
                Dim r As Reservaties.tblReservatieRow = dt.NewRow

                'Basisreservatieinformatie.
                r.userID = New Guid(Request.QueryString("userID"))
                r.autoID = Convert.ToString(Request.QueryString("autoID"))
                r.reservatieBegindat = Date.Parse(Request.QueryString("begindat"))
                r.reservatieEinddat = Date.Parse(Request.QueryString("einddat"))

                'Deze eerste medewerker zou moeten worden ingevuld als een echte medewerker
                'als we de functionaliteit toevoegen dat een medewerker een reservatie voor een klant
                'kan toevoegen. Niet erg moeilijk, maar niet vergeten.
                r.reservatieGereserveerdDoorMedewerker = New Guid("7a73f865-ec29-4efd-bf09-70a9f9493d21")

                'De volgende twee medewerkers worden enkel aangepast bij een in- of uitcheckprocedure.
                r.reservatieIngechecktDoorMedewerker = New Guid("7a73f865-ec29-4efd-bf09-70a9f9493d21")
                r.reservatieUitgechecktDoorMedewerker = New Guid("7a73f865-ec29-4efd-bf09-70a9f9493d21")

                r.verkoopscontractOpmerking = String.Empty
                r.verkoopscontractIsOndertekend = 0

                r.factuurBijschrift = String.Empty
                r.factuurIsInWacht = 0

                If (reservatiebll.InsertReservatie(r)) Then
                    MsgBox("juij!")
                End If
                reservatiebll = Nothing
            Catch ex As Exception
                Throw ex
            End Try

        End If
    End Sub
End Class
