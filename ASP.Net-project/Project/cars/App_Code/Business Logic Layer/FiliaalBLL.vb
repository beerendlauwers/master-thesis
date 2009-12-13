Imports Microsoft.VisualBasic

Public Class FiliaalBLL
    Private _filiaalAdapter As New AutosTableAdapters.tblFiliaalTableAdapter
    Private _filiaaldal As New FiliaalDAL

    Public Function GetAllFilialen() As Autos.tblFiliaalDataTable
        Try
            Return _filiaalAdapter.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function UpdateFiliaal(ByRef f As Autos.tblFiliaalRow) As Boolean
        Try
            If (_filiaalAdapter.Update(f)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function AddFiliaal(ByRef f As Autos.tblFiliaalRow) As Boolean
        Try
            If (_filiaalAdapter.Insert(f.filiaalLocatie, f.filiaalNaam, f.filiaalTelefoon, f.filiaalContact, f.parkingAantalRijen, f.parkingAantalKolommen)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteFiliaal(ByVal filiaalID As Integer) As Boolean
        Try
            If (_filiaalAdapter.Delete(filiaalID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetFiliaalNaamByFiliaalID(ByVal filiaalID As Integer) As String
        Try

            Dim dt As Autos.tblFiliaalDataTable = _filiaaldal.GetFiliaalByID(filiaalID)
            If (dt.Rows.Count = 0) Then
                Throw New Exception(String.Concat("Onbestaande filiaal met filiaalID: ", filiaalID))
            Else
                Return CType(dt.Rows(0), Autos.tblFiliaalRow).filiaalNaam
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetFiliaalByFiliaalID(ByVal filiaalID As Integer) As Autos.tblFiliaalDataTable
        Try
            Return _filiaaldal.GetFiliaalByID(filiaalID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
