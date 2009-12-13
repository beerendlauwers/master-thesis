<%@ WebHandler Language="VB" Class="AutoFoto" %>

Imports System
Imports System.Web
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO


Public Class AutoFoto : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Try
            Dim beschadigingID As Integer = CType(context.Request.QueryString("beschadigingID"), Integer)
        Catch ex As Exception
            Throw New Exception("Ongeldig Id.")
            Return
        End Try
        
        Try
            
            Dim beschadigingID As Integer = CType(context.Request.QueryString("beschadigingID"), Integer)
            
            Dim autofotobll As New AutoFotoBLL
            Dim row As Autos.tblAutofotoRow = autofotobll.GetAutoFotoByBeschadigingID(beschadigingID)

            If row Is Nothing Then Return
            
            context.Response.Buffer = True
            context.Response.Charset = ""
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache)
            context.Response.ContentType = row.autoFotoType
            context.Response.AddHeader("content-disposition", String.Concat("attachment;filename=beschadiging", row.autofotoID))
            context.Response.BinaryWrite((DirectCast(row.autoFoto, Byte())))
            context.Response.Flush()
            HttpContext.Current.ApplicationInstance.CompleteRequest()

        Catch ex As Exception
            Throw ex
        End Try

    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class