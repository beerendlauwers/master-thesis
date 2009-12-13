Imports Microsoft.VisualBasic

Public Class AutoFotoBLL
    Private _autofotodal As New AutoFotoDAL
    Private _adapterAutoFoto As New AutosTableAdapters.tblAutofotoTableAdapter

    Public Function GetAutoFotoByAutoID(ByVal autoID As Integer) As Autos.tblAutofotoDataTable
        Try
            Return _autofotodal.GetAutoFotoByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAutoFotoByBeschadigingID(ByVal beschadigingID As Integer) As Autos.tblAutofotoRow
        Try
            Return _autofotodal.GetAutoFotoByBeschadigingID(beschadigingID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetReservatieAutoFotoByAutoID(ByVal autoID As Integer) As Autos.tblAutofotoDataTable
        Try
            Return _autofotodal.GetReservatieAutoFotoByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertAutoFoto(ByRef r As Autos.tblAutofotoRow) As Boolean
        Try
            If (_autofotodal.InsertAutoFoto(r)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertBeschadigingAutoFoto(ByRef r As Autos.tblAutofotoRow) As Integer
        Try
            If (_autofotodal.InsertBeschadigingAutoFoto(r)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteAutoFotoVanBeschadiging(ByVal beschadigingID As Integer) As Boolean
        Try
            Dim foto As Autos.tblAutofotoRow = GetAutoFotoByBeschadigingID(beschadigingID)

            If foto Is Nothing Then Return Nothing

            Return _adapterAutoFoto.Delete(foto.autofotoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
