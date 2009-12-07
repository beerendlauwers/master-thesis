Imports Subgurim.Controles
Imports System.Data

Partial Class App_Presentation_Webpaginas_Default2
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ' vereist Imports Subgurim.Controles

        GMap1.setCenter(New GLatLng(51, 4), 7)

        With GMap1

            ' layout
            .Height = 750
            .Width = 738

            .GZoom = 9
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
            .image = "images/gmapcar.png"

            .iconSize = New GSize(32, 32)

            .iconAnchor = New GPoint(16, 32)
            .infoWindowAnchor = New GPoint(10, 12)
        End With

        Dim bllFiliaal As New FiliaalBLL

        Dim tblFil As New DataTable

        tblFil = bllFiliaal.GetAllFilialen()


        Dim MarkerList As New System.Collections.Generic.List(Of GMarker)
        Dim WindowList As New System.Collections.Generic.List(Of GInfoWindow)

        Dim marker As GMarker
        Dim markopts As GMarkerOptions

        Dim window As GInfoWindow
        Dim winopts As GInfoWindowOptions

        Dim dr As DataRow

        For Each dr In tblFil.Rows

            Adres = dr("filiaalLocatie")
            GeoCode = GMap.geoCodeRequest(Adres, MapKey)

            ' marker

            markopts = New GMarkerOptions

            With markopts
                .title = Adres
                .icon = icon
            End With

            marker = New GMarker(New GLatLng(GeoCode.Placemark.coordinates.lat, GeoCode.Placemark.coordinates.lng), markopts)

            ' window

            winopts = New GInfoWindowOptions(Adres, "<h1>Lorem ipsum</h1> <hr /><br /><br />Dolor sit amet, consectetur adipiscing elit. In blandit, purus id elementum fermentum, tellus nibh eleifend ante, id lacinia erat turpis quis mauris. Donec gravida tellus sed erat porta at scelerisque justo feugiat. Aliquam sit amet feugiat purus. Nam facilisis sapien id tellus venenatis tincidunt. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vestibulum vitae varius odio. Pellentesque faucibus nunc non metus pharetra nec feugiat mi condimentum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vivamus mollis leo at sapien pulvinar pharetra. Sed imperdiet nulla vitae velit ullamcorper auctor tristique tellus hendrerit.Sed eget mi massa, eu feugiat libero. Integer rhoncus laoreet nulla, nec dignissim nisi placerat eu. Nam leo elit, porta sit amet convallis vitae, pretium quis sapien. Pellentesque gravida diam nec diam dapibus non faucibus neque fringilla. Fusce nec justo mi, ac molestie est. Suspendisse lacinia congue auctor. Ut condimentum scelerisque dapibus. Suspendisse vulputate dictum felis, non adipiscing arcu scelerisque ac. Pellentesque lacus nibh, commodo id elementum sit amet, eleifend ac magna. Praesent vulputate purus ac diam aliquam ac dapibus erat tristique. Maecenas lobortis ultricies est, id dictum ante vehicula nec. Aliquam mi tellus, commodo non egestas at, molestie et dolor. Quisque a turpis sit amet odio porttitor suscipit vel non ligula. Aliquam varius pretium tempor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Fusce sed lacus justo, a elementum magna. Fusce sapien lorem, auctor vitae posuere vel, bibendum ut urna. ")
            window = New GInfoWindow(marker, "<h3>" & Adres & "</h3> <hr /> <br /><br /> <hr /> <input type='button' value='Bepaal filiaal' onClick= & test() & />")
            window.options = winopts

            ' markers/windows toekennen
            With GMap1
                .addGMarker(marker)
                .addInfoWindow(window)
            End With
        Next

    End Sub

    'Protected Sub ddlGmap_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlGmap.SelectedIndexChanged
    '    Dim GeoCode As GeoCode
    '    Dim MapKey As String = ConfigurationManager.AppSettings("googlemaps.subgurim.net")

    '    GeoCode = GMap.geoCodeRequest(ddlGmap.SelectedItem.Text, MapKey)
    '    GMap1.setCenter(New GLatLng(GeoCode.Placemark.coordinates.lat, GeoCode.Placemark.coordinates.lng), 18)
    'End Sub
End Class
