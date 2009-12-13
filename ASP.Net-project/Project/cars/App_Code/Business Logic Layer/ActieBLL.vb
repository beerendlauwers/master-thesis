Imports Microsoft.VisualBasic

Public Class ActieBLL
    Private _actiedal As New ActieDAL
    Private _actieAdapter As New OnderhoudTableAdapters.tblActieTableAdapter

    Public Function GetActieByActieID(ByVal actieID As Integer) As Onderhoud.tblActieRow
        Try
            Return _actiedal.GetActieByActieID(actieID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllActiesByControleID(ByVal controleID As Integer) As Onderhoud.tblActieDataTable
        Try
            Return _actiedal.GetAllActiesByControleID(controleID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllStandaardActies() As Onderhoud.tblActieDataTable
        Try
            Return _actiedal.GetAllStandaardActies()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertActie(ByRef a As Onderhoud.tblActieRow) As Integer
        Try
            Return _actiedal.InsertActie(a)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteActie(ByVal actieID As Integer) As Boolean
        Try
            Return _actieAdapter.Delete(actieID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class

