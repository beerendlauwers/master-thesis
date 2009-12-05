Imports Microsoft.VisualBasic

Public Class MerkBLL
    Private _merkdal As New MerkDAL

    Public Function GetAllMerken() As Autos.tblMerkDataTable
        Try
            Return _merkdal.GetAllMerk()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetMerkenByCategorie(ByVal categorieID As Integer) As Autos.tblMerkDataTable
        Try
            Return _merkdal.GetMerkByCategorie(categorieID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetMerkByMerkID(ByVal merkID As Integer) As Autos.tblMerkDataTable
        Try
            Return _merkdal.GetMerkByMerkID(merkID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetMerkByModelID(ByVal modelID As Integer) As Autos.tblMerkDataTable
        Try
            Return _merkdal.GetMerkByModelID(modelID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
