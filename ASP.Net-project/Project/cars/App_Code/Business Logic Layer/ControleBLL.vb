Imports Microsoft.VisualBasic

Public Class ControleBLL
    Private _controleAdapter As New OnderhoudTableAdapters.tblControleTableAdapter
    Private _onderhoudAdapter As New OnderhoudTableAdapters.tblNodigOnderhoudTableAdapter
    Private _controledal As New ControleDAL
    Private _onderhoudbll As New OnderhoudBLL

    Public Function GetControleByReservatieID(ByVal reservatieID As Integer) As Onderhoud.tblControleRow
        Try
            Return _controledal.GetControleByReservatieID(reservatieID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertControle(ByRef c As Onderhoud.tblControleRow) As Boolean
        Try
            If (_controleAdapter.Insert(c.medewerkerID, c.autoID, c.reservatieID, c.controleBegindat, c.controleEinddat, c.controleIsNazicht, c.controleKilometerstand, c.controleBrandstofkost)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertNieuweControle(ByRef c As Onderhoud.tblControleRow) As Integer
        Try
            Return _controledal.InsertNieuweControle(c)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertNazicht(ByRef c As Onderhoud.tblControleRow) As Boolean
        Try
            Dim controleID As Integer = InsertNieuweControle(c)

            If (controleID > 0) Then

                Dim omschrijving As String = String.Concat("Nazicht voor de reservatie die eindigt op ", Format(DateAdd(DateInterval.Day, -1, c.controleBegindat), "dd/MM/yyyy"))

                If (_onderhoudAdapter.Insert(c.autoID, controleID, c.controleBegindat, c.controleEinddat, omschrijving)) Then
                    Return True
                Else
                    Return False
                End If

            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function UpdateControle(ByRef c As Onderhoud.tblControleRow) As Boolean
        Try
            If (_controleAdapter.Update(c)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function UpdateNazicht(ByRef c As Onderhoud.tblControleRow) As Boolean
        Try
            If (_controleAdapter.Update(c)) Then

                'Nu de rij in NodigOnderhoud updaten
                Dim omschrijving As String = String.Concat("Nazicht voor de reservatie die eindigt op ", Format(DateAdd(DateInterval.Day, -1, c.controleBegindat), "dd/MM/yyyy"))
                Dim o As Onderhoud.tblNodigOnderhoudRow = _onderhoudbll.GetNazichtByDatumAndAutoID(c.controleBegindat, c.autoID)
                o.nodigOnderhoudOmschrijving = omschrijving
                o.nodigOnderhoudBegindat = c.controleBegindat
                o.nodigOnderhoudEinddat = c.controleEinddat
                o.autoID = c.autoID
                o.controleID = c.controleID

                If (_onderhoudAdapter.Update(o)) Then
                    Return True
                Else
                    Return False
                End If
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteControle(ByVal controleID As Integer) As Boolean
        Try
            If (_controleAdapter.Delete(controleID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
