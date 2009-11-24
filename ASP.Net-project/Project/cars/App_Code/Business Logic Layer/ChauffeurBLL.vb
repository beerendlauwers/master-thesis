Imports Microsoft.VisualBasic

Public Class ChauffeurBLL
    Private c As New Chauffeur
    Private _chauffeurAdapter As New KlantenTableAdapters.tblChauffeurTableAdapter

    'Public Function GetAllChauffeurs() As 
    'Try
    '  Return _chauffeurAdapter.GetData()
    ' Catch ex As Exception
    '     Throw ex
    ' End Try
    ' End Function

    Public Function AddChauffeur(ByRef c As Chauffeur) As Boolean
        Try
            If (_chauffeurAdapter.Insert(c.ChauffeurNaam, c.ChauffeurVoornaam, c.ChauffeurBedrijfID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteFiliaal(ByVal ChauffeurID As Integer) As Boolean
        Try
            If (_chauffeurAdapter.Delete(ChauffeurID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
