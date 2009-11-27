Imports Microsoft.VisualBasic

Public Class AutoFotoBLL
    Private _autofotodal As New AutoFotoDAL

    Public Function GetAutoFotoByAutoID(ByVal autoID As Integer) As Autos.tblAutofotoDataTable
        Try
            Return _autofotodal.GetAutoFotoByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
