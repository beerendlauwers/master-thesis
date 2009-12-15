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

    Public Function GetUserProfielByNaamEnVoornaam(ByVal naam As String, ByVal voornaam As String) As Klanten.tblUserProfielDataTable
        Try
            Return _klantdal.GetUserProfielByNaamEnVoornaam(naam, voornaam)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetUserProfielByIdentiteitskaartNr(ByVal identiteitskaartnr As String) As Klanten.tblUserProfielDataTable
        Try
            Return _klantdal.GetUserProfielByIdentiteitskaartNr(identiteitskaartnr)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetUserProfielByRijbewijs(ByVal rijbewijs As String) As Klanten.tblUserProfielDataTable
        Try
            Return _klantdal.GetUserProfielByRijbewijs(rijbewijs)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function UpdateUserProfiel(ByRef r As Klanten.tblUserProfielRow) As Boolean

        Try
            If (_klantdal.UpdateUserByID(r)) Then
                Return True
            End If
        Catch ex As Exception

        End Try


        Return 0
    End Function
    Public Function getAllUserprofielen() As Klanten.tblUserProfielDataTable
        Dim dt As Klanten.tblUserProfielDataTable = _klantdal.GetAllUserprofielen
        Return dt
    End Function

End Class
