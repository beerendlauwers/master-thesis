Imports Microsoft.VisualBasic

Public Class ChauffeurBLL
    Private c As New Chauffeur
    Private _chauffeurDAL As New ChauffeurDAL
    Private _chauffeurAdapter As New KlantenTableAdapters.tblChauffeurTableAdapter

    Public Function GetAllChauffeurs() As Klanten.tblChauffeurDataTable
        Try
            Return _chauffeurAdapter.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function AddChauffeur(ByRef c As Klanten.tblChauffeurRow) As Boolean
        Try
            If (_chauffeurAdapter.Insert(c.chauffeurNaam, c.chauffeurVoornaam, c.chauffeurRijbewijs, c.userID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteChauffeurByID(ByVal ChauffeurID As Integer) As Boolean
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

    Public Function GetChauffeurByChauffeurID(ByRef chauffeurID As Integer) As Klanten.tblChauffeurDataTable
        Try
            Return _chauffeurDAL.GetChauffeurByChauffeurID(chauffeurID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function


    Public Function GetChauffeurByUserID(ByRef UserID As Guid) As Klanten.tblChauffeurDataTable
        Try
            Return _chauffeurDAL.GetChauffeursByUserID(UserID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function UpdateChauffeur(ByRef dr As Klanten.tblChauffeurRow) As Klanten.tblChauffeurDataTable
        Try
            Return _chauffeurDAL.UpdateChauffeur(dr)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
