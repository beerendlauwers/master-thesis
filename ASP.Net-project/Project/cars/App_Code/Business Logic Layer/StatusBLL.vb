Imports Microsoft.VisualBasic

Public Class StatusBLL
    Private _statusdal As New StatusDAL

    Public Function GetAllStatus() As Autos.tblAutostatusDataTable
        Try
            Return _statusdal.GetAllStatus()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetStatusByStatusNaam(ByVal naam As String) As Autos.tblAutostatusDataTable
        Try
            Return _statusdal.GetStatusByStatusNaam(naam)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
