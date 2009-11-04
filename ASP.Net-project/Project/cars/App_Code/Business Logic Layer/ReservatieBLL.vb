Imports Microsoft.VisualBasic

Public Class ReservatieBLL
    Private _adapterReservatie As New ReservatiesTableAdapters.tblReservatieTableAdapter

    Public Function GetAllReservaties() As Reservaties.tblReservatieDataTable
        Try
            Return _adapterReservatie.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllReservatiesBy(ByVal autoID As Integer) As Reservaties.tblReservatieDataTable
        Try
            Return _adapterReservatie.GetAllReservatiesBy(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertReservatie(ByRef r As Reservatie) As Boolean
        Try
            If (_adapterReservatie.Insert(r.KlantID, r.AutoID, r.GereserveerdDoorMedewerker, _
                                          r.UitgechecktDoorMedewerker, r.IngechecktDoorMedewerker, _
                                          r.Begindatum, r.Einddatum)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteReservatie(ByVal reservatieID As Integer) As Boolean
        Try
            If (_adapterReservatie.Delete(reservatieID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
