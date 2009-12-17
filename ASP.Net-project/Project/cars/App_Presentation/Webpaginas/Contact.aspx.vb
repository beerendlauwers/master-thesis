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
            .Width = 737

            .GZoom = 8
            .addGMapUI(New GMapUI())
            .enableHookMouseWheelToZoom = True

        End With


        'key inlezen vanuit web.conf <AppSettings/>

        Dim MapKey As String = ConfigurationManager.AppSettings("googlemaps.subgurim.net")
        Dim Adres As String = ""
        Dim GeoCode As GeoCode

        'Icoon opties

        Dim filicon = New GIcon()
        With filicon
            .image = "../Images/icoon_auto.jpg"

            .iconSize = New GSize(39, 29)

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
                .icon = filicon
            End With

            marker = New GMarker(New GLatLng(GeoCode.Placemark.coordinates.lat, GeoCode.Placemark.coordinates.lng), markopts)

            ' window


            Dim htmlstring As String = String.Empty
            htmlstring = htmlstring + "Locatie: " + dr.filiaalLocatie + "<br/><br/>"
            htmlstring = htmlstring + "Telefoon: " + dr.filiaalTelefoon + "<br/><br/>"
            htmlstring = htmlstring + "Contact: <a href=mailto:" + dr.filiaalContact + ">Contacteer ons</a><br/><br/>"

            htmlstring = htmlstring + "<hr/><a href= contact.aspx?fil="


            ' filiaal locatie splitten op spaties en samensmijten met %20
            ' voor in querystring (url) te kunnen zetten

            Dim strArray() As String = dr.filiaalLocatie.Split(" ")
            For Each item In strArray
                htmlstring = htmlstring + item + "%20"
            Next

            htmlstring = htmlstring + ">Hier naartoe</a><br/><br/>"

            winopts = New GInfoWindowOptions("<h2>" + Adres + "</h2>", htmlstring)
            window = New GInfoWindow(marker, "<h2>" + Adres + "</h2>" + htmlstring)
            window.options = winopts

            ' markers/windows toekennen
            With GMap1
                .addGMarker(marker)
                .addInfoWindow(window)
            End With
        Next


        ' Plaatsen van marker op klantadres
        ' Inlezen van klantadres in textbox
        ' ->enkel indien ingelogd!
        If User.Identity.IsAuthenticated Then
            Dim BLLKlant As New KlantBLL
            Dim dtKlant As New Klanten.tblUserProfielDataTable
            Dim drKlant As Klanten.tblUserProfielRow
            Dim klantLocatie As String

            dtKlant = BLLKlant.GetUserProfielByUserID(New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString()))
            drKlant = dtKlant.Rows(0)

            klantLocatie = drKlant.userBedrijfVestigingslocatie
            txtVan.Text = klantLocatie

            'User icoon aanmaken
            Dim usricon = New GIcon()
            With usricon
                .image = "../Images/Person_icon.png"

                .iconSize = New GSize(40, 40)

                .iconAnchor = New GPoint(16, 32)
                .infoWindowAnchor = New GPoint(10, 12)
            End With

            'Marker opties aanmaken
            markopts = New GMarkerOptions

            With markopts
                .title = klantLocatie
                .icon = usricon
            End With

            GeoCode = GMap.geoCodeRequest(klantLocatie, MapKey)

            marker = New GMarker(New GLatLng(GeoCode.Placemark.coordinates.lat, GeoCode.Placemark.coordinates.lng), markopts)
            window = New GInfoWindow(marker, "<p>" + klantLocatie + "</p>" + "<h3>U bevindt zich hier!</h3> Klik op de andere iconen om meer informatie te bekomen of om een route uit te stippelen <br /> Klik op het printicoon om uw routeplan af te drukken", True)

            With GMap1
                .addGMarker(marker)
                .addInfoWindow(window)
            End With

        End If



        ' Direction toevoegen

        If Not Context.Request.QueryString("fil") = "" Then

            ' inlezen fil van querystring
            txtNaar.Text = Context.Request.QueryString("fil")

            If Not IsPostBack Then


                Dim direction As New GDirection()
                direction.autoGenerate = False
                direction.buttonElementId = "cmdGo"
                direction.fromElementId = txtVan.ClientID
                direction.toElementId = txtNaar.ClientID
                direction.divElementId = "div_directions"
                direction.clearMap = True


                '// Optional
                '// direction.locale = "be-BE";

                GMap1.Add(direction)

            End If





        End If




    End Sub

    'Protected Sub cmdAfdrukken_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmdAfdrukken.Click



    Protected Sub cmdAfdrukken_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles cmdAfdrukken.click



        Dim strAdres As String
        Dim strNaar As String = txtNaar.Text
        Dim strVan As String = txtVan.Text



        strAdres = "http://maps.google.be/maps?saddr="

        'spatie vervangen door +

        Dim strArrayVan() As String = strVan.Split(" ")
        For Each item In strArrayVan
            strAdres = strAdres + item + "+"
        Next

        strAdres = strAdres + "&daddr="

        Dim strArrayNaar() As String = strNaar.Split(" ")
        For Each item In strArrayNaar
            strAdres = strAdres + item + "+"
        Next

        strAdres = strAdres + "&ie=UTF8&ll=51.159969,4.247589&spn=0.201964,0.617294&z=11&pw=2"



        Response.Redirect(strAdres)


    End Sub

End Class
