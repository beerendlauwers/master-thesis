Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class DALFunctions

    Public Function ExecuteScalar(ByRef command As SqlCommand) As Object
        Try
            command.Connection.Open()

            Return command.ExecuteScalar()

        Catch ex As Exception
            Throw ex
        Finally
            command.Connection.Close()
        End Try
    End Function

    Public Function ExecuteNonQuery(ByRef command As SqlCommand) As Boolean
        Try
            command.Connection.Open()

            Return command.ExecuteNonQuery()

        Catch ex As Exception
            Throw ex
        Finally
            command.Connection.Close()
        End Try
    End Function

    Public Function ReadSingleItem(ByRef command As SqlCommand, ByVal item As String) As Object
        Try
            Dim myReader As SqlDataReader

            command.Connection.Open()

            myReader = command.ExecuteReader

            If (myReader.HasRows) Then
                myReader.Read()
                Return myReader.Item(item)
            End If

            Return Nothing

        Catch ex As Exception
            Throw ex
        Finally
            command.Connection.Close()
        End Try
    End Function

    Public Function ReadDataTable(ByRef command As SqlCommand, ByRef dt As Object) As Object
        Try
            Dim myReader As SqlDataReader

            command.Connection.Open()

            myReader = command.ExecuteReader

            If (myReader.HasRows) Then dt.Load(myReader)

            Return dt
        Catch ex As Exception
            Throw ex
        Finally
            command.Connection.Close()
        End Try
    End Function
End Class