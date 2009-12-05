Imports Microsoft.VisualBasic

Public Class ParkeerBLL
    Private _parkeerdal As New ParkeerDAL
    Private _adapterParkeerPlaats As New AutosTableAdapters.tblParkeerPlaatsTableAdapter

    Public Function InsertParkeerPlaats(ByVal p As Autos.tblParkeerPlaatsRow) As Boolean
        Try
            If (_adapterParkeerPlaats.Insert(p.filiaalID, p.parkeerPlaatsKolom, p.parkeerPlaatsRij, p.parkeerPlaatsType)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetParkeerPlaatsenByFiliaalID(ByVal filiaalID As Integer) As Autos.tblParkeerPlaatsDataTable
        Try
            Return _parkeerdal.GetParkeerPlaatsenByFiliaalID(filiaalID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
