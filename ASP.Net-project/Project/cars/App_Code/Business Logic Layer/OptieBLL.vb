Imports Microsoft.VisualBasic

Public Class OptieBLL
    Private _optieAdapter As New Auto_sTableAdapters.tblOptieTableAdapter
    Public Function AddOptie(ByRef o As Optie) As Boolean
        Try
            If (_optieAdapter.Insert(o.Omschrijving, o.Prijs)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function
    
End Class
