Imports Subgurim.Controles
Imports System.Data

Partial Class App_Presentation_Webpaginas_Default2
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        'Visibility van directions controls false

        'lblNaar.Visible = False
        'lblVan.Visible = False
        'tb_endPoint.Visible = False
        'tb_fromPoint.Visible = False
        'bt_Go.visible = False



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

           
            Dim strArray() As String = dr.filiaalLocatie.Split(" ")

            


            Dim htmlstring As String = String.Empty
            htmlstring = htmlstring + "Locatie: " + dr.filiaalLocatie + "<br/><br/>"
            htmlstring = htmlstring + "Telefoon: " + dr.filiaalTelefoon + "<br/><br/>"
            htmlstring = htmlstring + "Contact: <a href=mailto:" + dr.filiaalContact + ">Contacteer ons</a><br/><br/>"

            htmlstring = htmlstring + "<hr/><a href= contact.aspx?fil="

            For Each i In strArray
                htmlstring = htmlstring + i + "%20"
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





        ' Inlezen van klantadres in textbox
        ' enkel indien ingelogd!
        If User.Identity.IsAuthenticated Then
            Dim BLLKlant As New KlantBLL
            Dim dtKlant As New Klanten.tblUserProfielDataTable
            Dim drKlant As Klanten.tblUserProfielRow

            dtKlant = BLLKlant.GetUserProfielByUserID(New Guid(Membership.GetUser(User.Identity.Name).ProviderUserKey.ToString()))
            drKlant = dtKlant.Rows(0)

            txtVan.Text = drKlant.userBedrijfVestigingslocatie
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


End Class
