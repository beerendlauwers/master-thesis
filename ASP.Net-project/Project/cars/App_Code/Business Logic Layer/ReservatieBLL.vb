Imports Microsoft.VisualBasic

Public Class ReservatieBLL
    Private _adapterReservatie As New ReservatiesTableAdapters.tblReservatieTableAdapter
    Private _reservatiedal As New ReservatieDAL

    Public Function GetAllReservaties() As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllReservaties()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllReservatiesByAutoID(ByVal autoID As Integer) As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllReservatiesByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllReservatiesByUserID(ByVal userID As Guid) As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllReservatiesByUserID(userID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertReservatie(ByRef r As Reservaties.tblReservatieRow) As Boolean
        Try
            If (_adapterReservatie.Insert(r.userID, r.autoID, r.reservatieBegindat, _
                                          r.reservatieEinddat, r.reservatieGereserveerdDoorMedewerker, _
                                          r.reservatieUitgechecktDoorMedewerker, r.reservatieIngechecktDoorMedewerker, _
                                          r.verkoopscontractIsOndertekend, r.verkoopscontractOpmerking, _
                                          r.factuurBijschrift, r.factuurIsInWacht)) Then
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
