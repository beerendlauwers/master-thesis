Imports Microsoft.VisualBasic

Public Class OnderhoudBLL
    Private _onderhoudAdapter As New OnderhoudTableAdapters.tblNodigOnderhoudTableAdapter
    Private _onderhouddal As New OnderhoudDAL

    Public Function GetAllNodigOnderhoudByAutoID(ByVal autoID As Integer) As Onderhoud.tblNodigOnderhoudDataTable
        Try
            Return _onderhouddal.GetAllNodigOnderhoudByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetNazichtByDatumAndAutoID(ByVal datum As Date, ByVal autoID As Integer) As Onderhoud.tblNodigOnderhoudRow
        Try
            Return _onderhouddal.GetNazichtByDatumAndAutoID(datum, autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertNodigOnderhoud(ByRef o As Onderhoud.tblNodigOnderhoudRow) As Boolean
        Try
            If (_onderhoudAdapter.Insert(o.autoID, o.nodigOnderhoudBegindat, o.nodigOnderhoudEinddat, o.nodigOnderhoudOmschrijving)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function UpdateNodigOnderhoud(ByRef o As Onderhoud.tblNodigOnderhoudRow) As Boolean
        Try
            If (_onderhoudAdapter.Update(o)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function VerwijderNodigOnderhoud(ByVal onderhoudID As Integer) As Boolean
        Try
            If (_onderhoudAdapter.Delete(onderhoudID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
