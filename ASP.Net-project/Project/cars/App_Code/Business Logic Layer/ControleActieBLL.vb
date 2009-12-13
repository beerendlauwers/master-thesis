Imports Microsoft.VisualBasic

Public Class ControleActieBLL
    Private _controleactiedal As New ControleActieDAL
    Private _controleAdapter As New OnderhoudTableAdapters.tblControleActieTableAdapter

    Public Function GetAllActiesByControleID(ByRef controleID As Integer) As Onderhoud.tblControleActieDataTable
        Try
            Return _controleactiedal.GetAllActiesByControleID(controleID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetControleActieByControleIDAndActieID(ByVal controleID As Integer, ByVal actieID As Integer) As Onderhoud.tblControleActieRow
        Try
            Return _controleactiedal.GetControleActieByControleIDAndActieID(controleID, actieID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function InsertControleactie(ByRef c As Onderhoud.tblControleActieRow) As Boolean
        Try
            Return _controleAdapter.Insert(c.controleID, c.actieID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function UpdateControleActie(ByRef c As Onderhoud.tblControleActieRow) As Boolean
        Try
            Return _controleAdapter.Update(c)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteControleActie(ByVal controleactieID As Integer) As Boolean
        Try
            Return _controleAdapter.Delete(controleactieID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
