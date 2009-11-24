Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Partial Class App_Presentation_ViewImage
    Inherits System.Web.UI.Page
    Private conn As String = ConfigurationManager.ConnectionStrings("ConnectToDatabase").ConnectionString()
    Private myConnection As New SqlConnection(conn)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("ID") IsNot Nothing Then

            myConnection.Open()

            Dim myCommand As New SqlCommand("SELECT autoFotoNaam, autoFotoContentType, autoFoto FROM tblAutoFoto WHERE autoFotoID = @id")
            myCommand.Parameters.Add("@id", SqlDbType.Int)
            myCommand.Parameters("@id").Value = Convert.ToInt32(Request.QueryString("ID"))
            myCommand.Connection = myConnection

            Dim myReader As SqlDataReader
            myReader = myCommand.ExecuteReader

            Dim dt As New DataTable
            dt.Load(myReader)

            myConnection.Close()

            If dt IsNot Nothing Then
                Dim bytes() As Byte = CType(dt.Rows(0)("autoFoto"), Byte())
                Response.Buffer = True
                Response.Charset = ""
                Response.Cache.SetCacheability(HttpCacheability.NoCache)
                Response.ContentType = dt.Rows(0)("autoFotoContentType").ToString()
                Response.AddHeader("content-disposition", "attachment;filename=" + dt.Rows(0)("autoFotoNaam").ToString())
                Response.BinaryWrite(bytes)
                Response.Flush()
                Response.End()
            End If
        End If
    End Sub
End Class
