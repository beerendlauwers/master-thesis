Imports Microsoft.VisualBasic

Public Class BeschadigingBLL
    Private _beschadigingAdapter As New OnderhoudTableAdapters.tblAutoBeschadigingTableAdapter
    Private _beschadigingdal As New BeschadigingDAL

    Public Function GetAllBeschadigingByAutoID(ByVal autoID As Integer) As Onderhoud.tblAutoBeschadigingDataTable
        Try
            Return _beschadigingdal.GetAllBeschadigingByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetBeschadigingByBeschadigingID(ByVal beschadigingID As Integer) As Onderhoud.tblAutoBeschadigingRow
        Try
            Return _beschadigingdal.GetBeschadigingByBeschadigingID(beschadigingID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertBeschadiging(ByRef b As Onderhoud.tblAutoBeschadigingRow) As Integer
        Try
            Return _beschadigingdal.InsertBeschadiging(b)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function UpdateBeschadiging(ByRef b As Onderhoud.tblAutoBeschadigingRow) As Boolean
        Try
            Return _beschadigingAdapter.Update(b)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteBeschadiging(ByVal beschadigingID As Integer) As Boolean
        Try
            Dim autofotobll As New AutoFotoBLL
            If (autofotobll.DeleteAutoFotoVanBeschadiging(beschadigingID)) Then
                Return _beschadigingAdapter.Delete(beschadigingID)
            Else
                Return False
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
