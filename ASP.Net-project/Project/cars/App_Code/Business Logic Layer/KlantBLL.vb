Imports Microsoft.VisualBasic

Public Class KlantBLL
    Private _adapterKlant As New KlantenTableAdapters.tblKlantTableAdapter

    Public Function GetAllKlanten() As Klanten.tblKlantDataTable
        Try
            Return _adapterKlant.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteKlant(ByVal klantID As Integer) As Boolean
        Try
            If (_adapterKlant.Delete(klantID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function AddKlant(ByRef k As Klant) As Boolean
        Try
            If (_adapterKlant.Insert(k.Gebruikersnaam, k.Gebruikerspaswoord, k.Naam, _
                                     k.Voornaam, k.Geboortedatum, k.Identiteitskaartnummer, _
                                     k.Rijbewijsnummer, k.Telefoon, k.Email, k.Commentaar, _
                                     k.BTWnummer, k.IsProblematisch, k.HeeftRechtOpKorting, _
                                     k.KortingWaarde, k.AantalDagenGehuurd, k.AantalDagenGereserveerd, _
                                     k.AantalKilometerGereden)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    'Public Function EditKlant(ByRef k As Klant) As Boolean
    'Try
    '  If (_adapterKlant.Update(k.Gebruikersnaam, k.Gebruikerspaswoord, k.Naam, _
    '                          k.Voornaam, k.Geboortedatum, k.Identiteitskaartnummer, _
    '                            k.Rijbewijsnummer, k.Telefoon, k.Email, k.Commentaar, _
    '                             k.BTWnummer, k.IsProblematisch, k.HeeftRechtOpKorting, _
    '                             k.KortingWaarde, k.AantalDagenGehuurd, k.AantalDagenGereserveerd, _
    '                             k.AantalKilometerGereden)) Then
    '         Return True
    '      Else
    '         Return False
    '      End If
    '    Catch ex As Exception
    '      Throw ex
    '    End Try
    'End Function
End Class
