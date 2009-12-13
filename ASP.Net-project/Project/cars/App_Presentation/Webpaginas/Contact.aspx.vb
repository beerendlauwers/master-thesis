Imports Subgurim.Controles
Imports System.Data

Partial Class App_Presentation_Webpaginas_Default2
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ' vereist Imports Subgurim.Controles

        GMap1.setCenter(New GLatLng(51, 4.5), 7)

        With GMap1

            ' layout
            .Height = 700
            .Width = 700

            .GZoom = 8
            .addGMapUI(New GMapUI())
            .enableHookMouseWheelToZoom = True

        End With


        'key inlezen vanuit web.conf <AppSettings/>

        Dim MapKey As String = ConfigurationManager.AppSettings("googlemaps.subgurim.net")
        Dim Adres As String = ""
        Dim GeoCode As GeoCode

        'Icoon opties

        Dim icon = New GIcon()
        With icon
            .image = "../Images/gmapcar.png"

            .iconSize = New GSize(32, 32)

            .iconAnchor = New GPoint(16, 32)
            .infoWindowAnchor = New GPoint(10, 12)
        End With

        Dim bllFiliaal As New FiliaalBLL

        Dim tblFil As New Autos.tblFiliaalDataTable

        tblFil = bllFiliaal.GetAllFilialen()


        Dim MarkerList As New System.Collections.Generic.List(Of GMarker)
        Dim WindowList As New System.Collections.Generic.List(Of GInfoWindow)

        Dim marker As GMarker
        Dim markopts As GMarkerOptions

        Dim window As GInfoWindow
        Dim winopts As GInfoWindowOptions

        Dim dr As Autos.tblFiliaalRow

        For Each dr In tblFil.Rows

            Adres = dr.filiaalNaam
            GeoCode = GMap.geoCodeRequest(Adres, MapKey)
            ' marker

            markopts = New GMarkerOptions

            With markopts
                .title = Adres
                .icon = icon
            End With

            marker = New GMarker(New GLatLng(GeoCode.Placemark.coordinates.lat, GeoCode.Placemark.coordinates.lng), markopts)

            ' window
            Dim htmlstring As String = String.Empty
            htmlstring = htmlstring + "Locatie: " + dr.filiaalLocatie + "<br/><br/>"
            htmlstring = htmlstring + "Telefoon: " + dr.filiaalTelefoon + "<br/><br/>"
            htmlstring = htmlstring + "Contact: <a href=mailto:" + dr.filiaalContact + ">Contacteer ons</a><br/><br/>"

            winopts = New GInfoWindowOptions("<h1>" + Adres + "</h1>", htmlstring)
            window = New GInfoWindow(marker, "<h1>" + Adres + "</h1>" + htmlstring)
            window.options = winopts

            ' markers/windows toekennen
            With GMap1
                .addGMarker(marker)
                .addInfoWindow(window)
            End With
        Next

    End Sub

    Protected Sub ddlGmap_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlGmap.SelectedIndexChanged
        Dim GeoCode As GeoCode
        Dim MapKey As String = ConfigurationManager.AppSettings("googlemaps.subgurim.net")

        GeoCode = GMap.geoCodeRequest(ddlGmap.SelectedItem.Text, MapKey)
        GMap1.setCenter(New GLatLng(GeoCode.Placemark.coordinates.lat, GeoCode.Placemark.coordinates.lng), 18)
    End Sub
End Class
