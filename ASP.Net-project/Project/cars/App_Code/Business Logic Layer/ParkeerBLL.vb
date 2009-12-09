Imports Microsoft.VisualBasic
Imports System.Data

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

    Public Function UpdateParkeerPlaats(ByVal p As Autos.tblParkeerPlaatsRow) As Boolean
        Try
            Return _parkeerdal.UpdateParkeerPlaatsTypeByID(p.parkeerPlaatsID, p.parkeerPlaatsType)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetParkeerPlaatsByRijKolomFiliaalID(ByVal filiaalID As Integer, ByVal rij As Integer, ByVal kolom As Integer) As Autos.tblParkeerPlaatsRow
        Try
            Return _parkeerdal.GetParkeerPlaatsByRijKolomFiliaalID(filiaalID, rij, kolom)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetParkeerPlaatsKolommenByFiliaalID(ByVal filiaalID As Integer) As DataTable
        Try
            Return _parkeerdal.GetParkeerPlaatsKolommenByFiliaalID(filiaalID)
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
