Imports Microsoft.VisualBasic

Public Class BrandstofBLL
    Private _brandstofdal As New BrandstofDAL

    Public Function GetAllBrandstofTypes() As Autos.tblBrandstofDataTable
        Try
            Return _brandstofdal.GetAllBrandstof()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetBrandstofTypeByID(ByVal brandstofID As Integer) As String
        Try

            Dim dt As Autos.tblBrandstofDataTable = _brandstofdal.GetBrandstofTypeByID(brandstofID)
            If (dt.Rows.Count = 0) Then
                Throw New Exception(String.Concat("Onbestaande brandstof met brandstofID: ", brandstofID))
            Else
                Return CType(dt.Rows(0), Autos.tblBrandstofRow).brandstofNaam
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function


End Class
