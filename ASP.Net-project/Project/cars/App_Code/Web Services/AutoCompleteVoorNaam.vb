Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Collections.Generic

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class AutoCompleteVoorNaam
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function GetCompletionList() As String()

        Dim BLLKlant As New KlantBLL
        Dim DTKlant As New Klanten.tblUserProfielDataTable
        Dim DRKlant As Klanten.tblUserProfielRow

        Dim items As New List(Of String)

        For Each DRKlant In DTKlant
            items.Add(DRKlant.userVoornaam)
        Next


        Return items.ToArray
    End Function

End Class
