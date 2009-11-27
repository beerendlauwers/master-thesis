Imports Microsoft.VisualBasic

Public Class CategorieBLL
    Private _categoriedal As New CategorieDAL

    Public Function GetAllCategorien() As Autos.tblCategorieDataTable
        Try
            Return _categoriedal.GetAllCategories()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetCategorieByID(ByVal categorieID As Integer) As String
        Try
            Dim dt As Autos.tblCategorieDataTable = _categoriedal.GetCategorieByID(categorieID)
            If (dt.Rows.Count = 0) Then
                Throw New Exception(String.Concat("Onbestaande categorie met categorieID: ", categorieID))
            Else
                Return CType(dt.Rows(0), Autos.tblCategorieRow).categorieNaam
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
