Imports Microsoft.VisualBasic

Public Class AutoOptieBLL
    Private _autoOptieAdapter As New AutosTableAdapters.tblAutoOptieTableAdapter
    Private _autoOAdapter As New AutosTableAdapters.tblAutoTableAdapter
    Private _autooptiedal As New AutoOptieDAL
    Private pAutoID As Integer

    Public Function autoOptieAdd(ByRef r As Autos.tblAutoOptieRow) As Boolean
        Try
            If (_autoOptieAdapter.Insert(r.optieID, r.autoID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllAutoOptie() As Autos.tblAutoOptieDataTable
        Try
            Return _autooptiedal.GetAllAutoOptie()
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
