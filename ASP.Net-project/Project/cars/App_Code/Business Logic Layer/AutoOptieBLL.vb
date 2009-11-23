Imports Microsoft.VisualBasic

Public Class AutoOptieBLL
    Private _autoOptieAdapter As New Auto_sTableAdapters.tblAutoOptieTableAdapter
    Private _autoOAdapter As New Auto_sTableAdapters.tblAutoTableAdapter
    Private pAutoID As Integer

    Public Function autoOptieAdd(ByRef a As AutoOptie) As Boolean

        Try
            If (_autoOptieAdapter.Insert(a.OptieID, a.AutoID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function




End Class
