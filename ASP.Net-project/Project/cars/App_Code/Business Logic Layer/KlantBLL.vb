Imports Microsoft.VisualBasic

Public Class KlantBLL
    Private _klantdal As New KlantDAL
    Private _adapterUserProfiel As New KlantenTableAdapters.tblUserProfielTableAdapter

    Public Function InsertUserProfiel(ByRef r As Klanten.tblUserProfielRow) As Boolean
        Try
            If (_adapterUserProfiel.Insert(r.userID, r.userVoornaam, r.userNaam, r.userGeboortedatum, r.userIdentiteitskaartnr, r.userRijbewijsnr, r.userTelefoon, r.userCommentaar, r.userIsProblematisch, r.userHeeftRechtOpKorting, r.userKortingWaarde, r.userAantalDagenGehuurd, r.userAantalDagenGereserveerd, r.userAantalKilometerGereden, r.userIsBedrijf, r.userBTWnummer, r.userBedrijfnaam, r.userBedrijfVestigingslocatie)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetUserProfielByUserID(ByRef userID As Guid) As Klanten.tblUserProfielDataTable
        Try
            Return _klantdal.GetUserProfielByUserID(userID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
