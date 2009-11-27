Imports Microsoft.VisualBasic

Public Class ModelBLL
    Private _modeldal As New ModelDAL

    Public Function GetAllModels() As Autos.tblModelDataTable
        Try
            Return _modeldal.GetAllModel()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetModelsByMerkID(ByVal merkID As Integer) As Autos.tblModelDataTable
        Try
            Return _modeldal.GetModelByMerkID(merkID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetModelNaamByModelID(ByVal modelID As Integer) As String
        Try

            Dim returnstring As String = _modeldal.GetModelNaamByModelID(modelID)

            If (returnstring = String.Empty) Then
                Throw New Exception(String.Concat("Onbestaand model met modelID: ", modelID))
            Else
                Return returnstring
            End If

        Catch ex As Exception
            Throw ex
            Return String.Empty
        End Try
    End Function
End Class
