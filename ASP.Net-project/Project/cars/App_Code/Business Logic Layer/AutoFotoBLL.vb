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

    Public Function GetReservatieAutoFotoByAutoID(ByVal autoID As Integer) As Autos.tblAutofotoDataTable
        Try
            Return _autofotodal.GetReservatieAutoFotoByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertAutoFoto(ByRef r As Autos.tblAutofotoRow) As Boolean
        Try
            If (_adapterAutoFoto.Insert(r.autoID, r.autoFoto, r.autoFotoDatum, r.autoFotoVoorReservatie, r.autoFotoType)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
