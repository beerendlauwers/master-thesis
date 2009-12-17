Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class FactuurDAL
    Private conn As String = ConfigurationManager.ConnectionStrings("frankRemoteDB").ConnectionString()
    Private _myConnection As New SqlConnection(conn)
    Private _f As New DALFunctions

End Class
