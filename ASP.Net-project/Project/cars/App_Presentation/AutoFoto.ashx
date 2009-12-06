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
            Dim autoID As Integer = CType(context.Request.QueryString("autoID"), Integer)
        Catch ex As Exception
            Throw New Exception("Ongeldig Id.")
            Return
        End Try
        
        Try
            
            Dim autoID As Integer = CType(context.Request.QueryString("autoID"), Integer)
            
            Dim autofotobll As New AutoFotoBLL
            Dim dt As Autos.tblAutofotoDataTable = autofotobll.GetReservatieAutoFotoByAutoID(autoID)
            If dt.Rows.Count > 0 then
            Dim row As Autos.tblAutofotoRow = dt.Rows(0)
            
            context.Response.Buffer = True
            context.Response.Charset = ""
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache)
            context.Response.ContentType = row.autoFotoType
            context.Response.AddHeader("content-disposition", String.Concat("attachment;filename=auto", row.autofotoID))
            context.Response.BinaryWrite((DirectCast(row.autoFoto, Byte())))
            context.Response.Flush()
            HttpContext.Current.ApplicationInstance.CompleteRequest()
            
            Else return
            End If

            

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