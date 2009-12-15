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

    Public Function GetAllOnbevestigdeReservaties() As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllOnbevestigdeReservaties()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllbevestigdeReservaties() As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllbevestigdeReservaties()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetReservatieByReservatieID(ByVal reservatieID As Integer) As Reservaties.tblReservatieRow
        Try
            Return _reservatiedal.GetReservatieByReservatieID(reservatieID)
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

    Public Function GetMeestRecenteReservatieByAutoID(ByVal autoID As Integer) As Reservaties.tblReservatieRow
        Try
            Return _reservatiedal.GetMeestRecenteReservatieByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllBevestigdeReservatiesByUserID(ByVal userID As Guid) As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllBevestigdeReservatiesByUserID(userID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllBevestigdeReservatiesByAutoIDAndUserID(ByVal autoID As Integer, ByVal userID As Guid) As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllBevestigdeReservatiesByAutoIDAndUserID(autoID, userID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllUitgecheckteReservatiesByUserID(ByVal userID As Guid) As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllUitgecheckteReservatiesByUserID(userID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function


    Public Function GetAllBevestigdeReservatiesByAutoID(ByVal autoID As Integer) As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllBevestigdeReservatiesByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllBeschikbareReservatiesInMaandByUserID(ByVal userID As Guid, ByVal maand As Date) As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllBeschikbareReservatiesInMaandByUserID(userID, maand)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllUitgecheckteReservatiesByAutoIDAndUserID(ByVal autoID As Integer, ByVal userID As Guid) As Reservaties.tblReservatieDataTable
        Try
            Return _reservatiedal.GetAllUitgecheckteReservatiesByAutoIDAndUserID(autoID, userID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetSpecificReservatieByDatumAndAutoID(ByRef r As Reservatie) As Reservaties.tblReservatieRow
        Try
            Return _reservatiedal.GetSpecificReservatieByDatumAndAutoID(r)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertReservatie(ByRef r As Reservaties.tblReservatieRow) As Boolean
        Try
            If (_adapterReservatie.Insert(r.userID, r.autoID, r.reservatieStatus, r.reservatieBegindat, _
                                          r.reservatieEinddat, r.reservatieIsBevestigd, r.reservatieLaatstBekeken, r.reservatieGereserveerdDoorMedewerker, _
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

    Public Function UpdateReservatie(ByRef r As Reservaties.tblReservatieRow) As Boolean
        Try
            If (_adapterReservatie.Update(r)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteReservatie(ByRef r As Reservaties.tblReservatieRow) As Integer

        Dim seconde As Integer = 59
        Dim minuut As Integer = 59
        Dim uur As Integer = 23
        Dim laatsteincheckmoment As Date = Date.Parse(String.Concat(Format(DateAdd(DateInterval.Day, -2, r.reservatieBegindat), "dd/MM/yyyy"), " ", uur, ":", minuut, ":", seconde))

        If Now >= laatsteincheckmoment Then
            Return -5
        End If


        Try
            If (_adapterReservatie.Delete(r.reservatieID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
