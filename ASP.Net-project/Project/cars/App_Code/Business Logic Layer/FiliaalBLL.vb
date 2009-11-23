Imports Microsoft.VisualBasic

Public Class FiliaalBLL
    Private _filiaalAdapter As New Auto_sTableAdapters.tblFiliaalTableAdapter



    Public Function GetAllFilialen() As Auto_s.tblFiliaalDataTable
        Try
            Return _filiaalAdapter.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function AddFiliaal(ByRef f As Filiaal) As Boolean
        Try
            If (_filiaalAdapter.Insert(f.FiliaalLocatie, f.FiliaalNaam, f.FiliaalAdres)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteFiliaal(ByVal filiaalID As Integer) As Boolean
        Try
            If (_filiaalAdapter.Delete(filiaalID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
