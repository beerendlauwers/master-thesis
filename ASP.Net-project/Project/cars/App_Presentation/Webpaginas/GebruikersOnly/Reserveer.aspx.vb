Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Presentation_Webpaginas_GebruikersOnly_Reserveer
    Inherits System.Web.UI.Page
    Private conn As String = ConfigurationManager.ConnectionStrings("ConnectToDatabase").ConnectionString()
    Private myConnection As New SqlConnection(conn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("autoID") IsNot Nothing And _
        Request.QueryString("begindat") IsNot Nothing And _
        Request.QueryString("einddat") IsNot Nothing And _
        Request.QueryString("userID") IsNot Nothing Then

            Dim myCommand As New SqlCommand("INSERT INTO tblReservatie(klantID, autoID, reservatieBegindat, reservatieEinddat) VALUES( @klantID, @autoID, @begindat, @einddat)")
            myCommand.Parameters.Add("@klantID", SqlDbType.Int).Value = Convert.ToInt32(Request.QueryString("userID"))
            myCommand.Parameters.Add("@autoID", SqlDbType.Int).Value = Convert.ToInt32(Request.QueryString("autoID"))
            myCommand.Parameters.Add("@begindat", SqlDbType.DateTime).Value = Date.Parse(Request.QueryString("begindat"))
            myCommand.Parameters.Add("@einddat", SqlDbType.DateTime).Value = Date.Parse(Request.QueryString("einddat"))
            myCommand.Connection = myConnection

            Try
                myConnection.Open()
                myCommand.ExecuteNonQuery()
                Page.Title = "Gelukt!"
            Catch ex As Exception
                Throw ex
            Finally
                myConnection.Close()
            End Try

        End If
    End Sub
End Class
