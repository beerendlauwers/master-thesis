Imports Microsoft.VisualBasic

Public Class AutoStatusBLL
    Private _autostatusdal As New AutoStatusDAL

    Public Function GetAllAutoStatus() As Autos.tblAutostatusDataTable
        Try
            Return _autostatusdal.GetAllAutoStatus()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllAutoStatusToewijsbaarBijMaken() As Autos.tblAutostatusDataTable
        Try
            Return _autostatusdal.GetAutoStatusToewijsbaarBijMaken()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAutostatusNaamByAutostatusID(ByVal autostatusID As Integer) As String
        Try
            Dim dt As Autos.tblAutostatusDataTable = _autostatusdal.GetAutoStatusByID(autostatusID)
            If (dt.Rows.Count = 0) Then
                Throw New Exception(String.Concat("Onbestaande status met autostatusID: ", autostatusID))
            Else
                Return CType(dt.Rows(0), Autos.tblAutostatusRow).autostatusNaam
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
