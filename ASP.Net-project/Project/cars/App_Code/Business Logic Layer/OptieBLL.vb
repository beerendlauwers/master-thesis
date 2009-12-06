Imports Microsoft.VisualBasic

Public Class OptieBLL
    Private _adapterOptie As New AutosTableAdapters.tblOptieTableAdapter
    Private _optiedal As New OptieDAL

    Public Function AddOptie(ByRef o As Optie) As Boolean
        Try
            If (_adapterOptie.Insert(o.Omschrijving, o.Prijs)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllOpties() As Autos.tblOptieDataTable
        Try
            Return _optiedal.GetAllOptie()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllOptiesByAutoID(ByVal autoID As Integer) As Autos.tblOptieDataTable
        Try
            Return _optiedal.GetAllOptiesByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetOptieByNaam(ByVal naam As String) As Autos.tblOptieDataTable
        Try
            Return _optiedal.GetOptieByNaam(naam)
        Catch ex As Exception
            Throw ex
        End Try
    End Function



End Class
