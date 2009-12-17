Imports Microsoft.VisualBasic

Public Class FactuurBLL
    Private _factuurAdapter As New ReservatiesTableAdapters.tblFactuurlijnTableAdapter
    Private _factuurdal As New FactuurDAL

    Public Function InsertFactuurLijn(ByRef f As Reservaties.tblFactuurlijnRow) As Boolean

        Try
            Return _factuurAdapter.Insert(f.reservatieID, f.factuurlijnTekst, f.factuurlijnKost, f.factuurlijnCode)
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function GetAllFactuurLijnenByReservatieID(ByVal reservatieID As Integer) As Reservaties.tblFactuurlijnDataTable

        Try
            Return _factuurdal.GetAllFactuurLijnenByReservatieID(reservatieID)
        Catch ex As Exception
            Throw ex
        End Try

    End Function

    Public Function GetAllFacturenInWacht() As Reservaties.tblReservatieDataTable

        Try
            Return _factuurdal.GetAllFacturenInWacht()
        Catch ex As Exception
            Throw ex
        End Try

    End Function
End Class
