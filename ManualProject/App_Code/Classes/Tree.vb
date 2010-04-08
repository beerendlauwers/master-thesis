Imports Microsoft.VisualBasic
Imports Manual
Imports System.Web.HttpUtility
Imports ContentType
Imports System.Web.HttpContext

Public Class Tree
    Private _naam As String
    Private _taal As Taal
    Private _versie As Versie
    Private _bedrijf As Bedrijf
    Private _rootnode As Node

    Private Shared FTrees As List(Of Tree) = Nothing

    ''' <summary>
    ''' Maak een nieuwe tree aan
    ''' </summary>
    ''' <param name="naam">De naam van de tree.</param>
    ''' <param name="taal">Het database-ID van de taal van de tree.</param>
    ''' <param name="versie">Het database-ID van de versie van de tree.</param>
    ''' <param name="bedrijf">Het database-ID van het bedrijf van de tree.</param>
    ''' <param name="rootnode">De beginnode van de tree.</param>
    ''' <remarks></remarks>
    Public Sub New(ByVal naam As String, ByVal taal As Integer, ByVal versie As Integer, ByVal bedrijf As Integer, ByVal rootnode As Node)
        _naam = naam
        _taal = New Taal(DatabaseLink.GetInstance.GetTaalFuncties.GetTaalByID(taal))
        _versie = New Versie(DatabaseLink.GetInstance.GetVersieFuncties.GetVersieByID(versie))
        _bedrijf = New Bedrijf(DatabaseLink.GetInstance.GetBedrijfFuncties.GetBedrijfByID(bedrijf))
        _rootnode = rootnode
    End Sub

    Public Property Naam() As String
        Get
            Return _naam
        End Get
        Set(ByVal value As String)
            _naam = value
        End Set
    End Property

    Public Property Bedrijf() As Bedrijf
        Get
            Return _bedrijf
        End Get
        Set(ByVal value As Bedrijf)
            _bedrijf = value
        End Set
    End Property

    Public Property Versie() As Versie
        Get
            Return _versie
        End Get
        Set(ByVal value As Versie)
            _versie = value
        End Set
    End Property

    Public Property Taal() As Taal
        Get
            Return _taal
        End Get
        Set(ByVal value As Taal)
            _taal = value
        End Set
    End Property

    Public Property RootNode() As Node
        Get
            Return _rootnode
        End Get
        Set(ByVal node As Node)
            _rootnode = node
        End Set
    End Property

    ''' <summary>
    ''' Doorzoek recursief de tree om een node te vinden op basis van id en type.
    ''' </summary>
    ''' <param name="id">Het database-ID van de node.</param>
    ''' <param name="type">Het type van de node (Artikel of Categorie).</param>
    ''' <returns>De opgevraagde node of Nothing indien ze niet werd gevonden.</returns>
    Public Function DoorzoekTreeVoorNode(ByVal id As Integer, ByVal type As ContentType) As Node

        If (_rootnode.ID = id And _rootnode.Type = ContentType.Categorie) Then
            Return _rootnode
        End If

        Dim returnednode As Node = _rootnode.GetChildBy(id, type)

        If returnednode Is Nothing Then
            Dim fout As String = String.Concat("De opgevraagde node (zie parameters) bestaat niet.")
            Dim e As New ErrorLogger(fout)
            e.Code = "NODE_0007"
            e.Args.Add("id = " & id.ToString)
            e.Args.Add("type = " & type.ToString)
            ErrorLogger.WriteError(e)
        End If

        Return returnednode
    End Function

    ''' <summary>
    ''' <para>Doorzoek recursief de tree om de parent van een node te vinden.
    ''' Kost is ongeveer 0.1 milliseconde.</para>
    ''' </summary>
    ''' <param name="node">De te vinden node.</param>µ
    ''' <returns>De opgevraagde node of Nothing indien ze niet werd gevonden.</returns>
    Public Function VindParentVanNode(ByRef node As Node) As Node
        Return _rootnode.VindParentVanNode(node)
    End Function

    ''' <summary>
    ''' Haal een tree op op basis van de unieke combinatie van taal, versie en het bedrijf.
    ''' </summary>
    ''' <param name="taal">Het database-ID van de taal.</param>
    ''' <param name="bedrijf">Het database-ID van het bedrijf.</param>
    ''' <param name="versie">Het database-ID van de versie.</param>
    ''' <returns>De opgevraagde tree of Nothing indien ze niet werd gevonden.</returns>
    Public Shared Function GetTree(ByVal taal As Integer, ByVal versie As Integer, ByVal bedrijf As Integer) As Tree

        If FTrees Is Nothing Then
            BouwTrees()
        End If

        If FTrees.Count = 0 Then
            BouwTrees()
        End If

        For Each t As Tree In FTrees
            If (t._taal.ID = taal And t._versie.ID = versie And t._bedrijf.ID = bedrijf) Then
                Return t
            End If
        Next t

        Return Nothing
    End Function

    ''' <summary>
    ''' Haal een tree op op basis van de unieke naam.
    ''' </summary>
    ''' <param name="naam">De unieke naam van de tree.</param>
    ''' <returns>De opgevraagde tree of Nothing indien ze niet werd gevonden.</returns>
    Public Shared Function GetTree(ByVal naam As String) As Tree

        If FTrees Is Nothing Then
            BouwTrees()
        End If

        If FTrees.Count = 0 Then
            BouwTrees()
        End If

        For Each t As Tree In FTrees
            If (t.Naam = naam) Then
                Return t
            End If
        Next t

        Return Nothing
    End Function

    ''' <summary>
    ''' Haal een tree op op basis van de unieke combinatie van taal, versie en het bedrijf.
    ''' </summary>
    ''' <param name="tree">De te vinden tree.</param>
    ''' <returns>De opgevraagde tree of Nothing indien ze niet werd gevonden.</returns>
    Public Shared Function GetTree(ByRef tree As Tree) As Tree
        For Each t As Tree In FTrees
            If (t._taal Is tree._taal And t._versie Is tree._versie And t._bedrijf Is tree._bedrijf) Then
                Return t
            End If
        Next t

        Return Nothing
    End Function

    ''' <summary>
    ''' Voeg een tree toe.
    ''' </summary>
    ''' <param name="tree">De toe te voegen tree.</param>
    Public Shared Sub AddTree(ByVal tree As Tree)
        'Als de treelijst niet bestaat, maken we deze aan
        If (FTrees Is Nothing) Then
            FTrees = New List(Of Tree)
        End If

        'Als de tree niet bestaat, voegen we hem toe
        If (GetTree(tree) Is Nothing) Then
            FTrees.Add(tree)
        End If
    End Sub

    ''' <summary>
    ''' Vraag de verzameling trees op.
    ''' </summary>
    ''' <returns>Lijst van alle trees.</returns>
    Public Shared Function GetTrees() As List(Of Tree)
        'Als de treelijst niet bestaat, maken we deze aan
        If (FTrees Is Nothing) Then
            FTrees = New List(Of Tree)
        End If

        Return FTrees
    End Function

    ''' <summary>
    ''' (Her)bouw de volledige treeverzameling. Dit is zeer intensief voor de server, dus gebruik dit zo weinig mogelijk.
    ''' </summary>
    Public Shared Sub BouwTrees()

        'Als er reeds een verzameling van trees is, maken we deze terug leeg
        If FTrees IsNot Nothing Then
            FTrees = New List(Of Tree)
        End If

        'Databasefuncties ophalen
        Dim dblink As DatabaseLink = DatabaseLink.GetInstance

        Dim dbcategorie As CategorieDAL = dblink.GetCategorieFuncties
        Dim dbtaal As TaalDAL = dblink.GetTaalFuncties
        Dim dbbedrijf As BedrijfDAL = dblink.GetBedrijfFuncties
        Dim dbversie As VersieDAL = dblink.GetVersieFuncties
        Dim dbartikel As ArtikelDAL = dblink.GetArtikelFuncties

        'Alle tabellen ophalen
        Dim taaldt As tblTaalDataTable = dbtaal.GetAllTaal
        Dim bedrijfdt As tblBedrijfDataTable = dbbedrijf.GetAllBedrijf
        Dim versiedt As tblVersieDataTable = dbversie.GetAllVersie

        'Voor elke combinatie van VERSIE, TAAL en BEDRIJF een tree maken.
        For Each versie As tblVersieRow In versiedt

            If (Not BouwTreesVoorVersie(bedrijfdt, versie, taaldt)) Then
                Return
            End If

        Next versie

    End Sub

    ''' <summary>
    ''' Bouwt alle trees voor een bepaalde versie (alle combinaties van versie-taal-bedrijf).
    ''' </summary>
    ''' <param name="bedrijfdt">Een strong-typed DataTable met alle bedrijven erin.</param>
    ''' <param name="versie">De databaserij van de gewenste versie.</param>
    ''' <param name="taaldt">Een strong-typed DataTable met alle talen erin.</param>
    ''' <returns>True indien gelukt, False indien gefaald.</returns>
    ''' <remarks>Indien False, bekijk de logbestanden in de 'Logs'-folder.</remarks>
    Public Shared Function BouwTreesVoorVersie(ByRef bedrijfdt As tblBedrijfDataTable, ByRef versie As tblVersieRow, ByRef taaldt As tblTaalDataTable) As Boolean

        For Each taal As tblTaalRow In taaldt

            For Each bedrijf As tblBedrijfRow In bedrijfdt

                If (Not BouwTreeBedrijf(bedrijf, versie, taal)) Then
                    Return False
                End If

            Next bedrijf

        Next taal

        Return True

    End Function

    ''' <summary>
    ''' Bouwt alle trees voor een bepaalde taal (alle combinaties van versie-taal-bedrijf).
    ''' </summary>
    ''' <param name="bedrijfdt">Een strong-typed DataTable met alle bedrijven erin.</param>
    ''' <param name="versiedt">Een strong-typed DataTable met alle versies erin.</param>
    ''' <param name="taal">De databaserij van de gewenste taal.</param>
    ''' <returns>True indien gelukt, False indien gefaald.</returns>
    ''' <remarks>Indien False, bekijk de logbestanden in de 'Logs'-folder.</remarks>
    Public Shared Function BouwTreesVoorTaal(ByRef bedrijfdt As tblBedrijfDataTable, ByRef versiedt As tblVersieDataTable, ByRef taal As tblTaalRow) As Boolean

        For Each versie As tblVersieRow In versiedt

            For Each bedrijf As tblBedrijfRow In bedrijfdt

                If (Not BouwTreeBedrijf(bedrijf, versie, taal)) Then
                    Return False
                End If

            Next bedrijf

        Next versie

        Return True

    End Function

    ''' <summary>
    ''' Bouwt alle trees voor een bepaald bedrijf (alle combinaties van versie-taal-bedrijf).
    ''' </summary>
    ''' <param name="bedrijf">De databaserij van het gewenste bedrijf.</param>
    ''' <param name="versiedt">Een strong-typed DataTable met alle versies erin.</param>
    ''' <param name="taaldt">Een strong-typed DataTable met alle talen erin.</param>
    ''' <returns>True indien gelukt, False indien gefaald.</returns>
    ''' <remarks>Indien False, bekijk de logbestanden in de 'Logs'-folder.</remarks>
    Public Shared Function BouwTreesVoorBedrijf(ByRef bedrijf As tblBedrijfRow, ByRef versiedt As tblVersieDataTable, ByRef taaldt As tblTaalDataTable) As Boolean

        For Each versie As tblVersieRow In versiedt

            For Each taal As tblTaalRow In taaldt

                If (Not BouwTreeBedrijf(bedrijf, versie, taal)) Then
                    Return False
                End If

            Next taal

        Next versie

        Return True

    End Function

    ''' <summary>
    ''' Bouwt de tree voor de gegeven unieke combinatie van versie, taal en bedrijf.
    ''' </summary>
    ''' <param name="bedrijf">De databaserij van het bedrijf.</param>
    ''' <param name="versie">De databaserij van  de versie.</param>
    ''' <param name="taal">De databaserij van de taal.</param>
    ''' <returns>True indien gelukt, False indien gefaald.</returns>
    ''' <remarks>Indien False, bekijk de logbestanden in de 'Logs'-folder.</remarks>
    Public Shared Function BouwTreeBedrijf(ByRef bedrijf As tblBedrijfRow, ByRef versie As tblVersieRow, ByRef taal As tblTaalRow) As Boolean

        'Databasefuncties ophalen
        Dim dblink As DatabaseLink = DatabaseLink.GetInstance

        Dim dbcategorie As CategorieDAL = dblink.GetCategorieFuncties
        Dim dbtaal As TaalDAL = dblink.GetTaalFuncties
        Dim dbbedrijf As BedrijfDAL = dblink.GetBedrijfFuncties
        Dim dbversie As VersieDAL = dblink.GetVersieFuncties
        Dim dbartikel As ArtikelDAL = dblink.GetArtikelFuncties

        Dim categoriedt As tblCategorieDataTable
        Dim artikeldt As tblArtikelDataTable

        'Root node ophalen en aanmaken
        Dim rootnode As Node
        Dim rootnoderij As tblCategorieRow = dbcategorie.GetRootNode()

        If rootnoderij Is Nothing Then
            Dim fout As String = "Er is een fout gebeurd tijdens het genereren van de categoriestructuren: De basis (of root node) van de boomstructuur bestaat niet in de database."
            fout = String.Concat(fout, " Refereer naar de documentatie om dit probleem op te lossen.")
            Dim e As New ErrorLogger(fout, "TREE_0001")
            ErrorLogger.WriteError(e)
            Return False
        End If

        If rootnoderij.Categorie = "root_node" And rootnoderij.FK_versie = 0 And rootnoderij.FK_taal = 0 And rootnoderij.FK_bedrijf = 0 Then
            rootnode = New Node(rootnoderij.CategorieID, ContentType.Categorie, bedrijf.Naam, 0)
        Else
            Dim fout As String = "Er is een fout gebeurd tijdens het genereren van de categoriestructuren: De basis (of root node) van de boomstructuur is incorrect (zie parameters)."
            Dim e As New ErrorLogger(fout, "TREE_0002")
            e.Args.Add("Titel van de root node (moet 'root_node' zijn): " & rootnoderij.Categorie)
            e.Args.Add("VersieID van de root node (moet 0 zijn): " & rootnoderij.FK_versie.ToString)
            e.Args.Add("BedrijfID van de root node (moet 0 zijn): " & rootnoderij.FK_bedrijf.ToString)
            e.Args.Add("TaalID van de root node (moet 0 zijn):" & rootnoderij.FK_taal.ToString)
            ErrorLogger.WriteError(e)
            Return False
        End If

        Dim treenaam As String = String.Concat("TREE_", versie.Versie, "_", taal.Taal, "_", bedrijf.Naam)
        Dim t As New Tree(treenaam, taal.TaalID, versie.VersieID, bedrijf.BedrijfID, rootnode)
        Dim huidigeParent As Node

        categoriedt = dbcategorie.GetAllCategorieBy(taal.TaalID, bedrijf.BedrijfID, versie.VersieID)

        For Each categorie As tblCategorieRow In categoriedt

            'De root node heeft geen parent, dus in dit geval kunnen we gewoon verdergaan.
            If categorie.FK_parent = categorie.CategorieID Then Continue For

            'Haal de juiste parent op van dit kind.
            huidigeParent = t.DoorzoekTreeVoorNode(categorie.FK_parent, ContentType.Categorie)

            'Check of huidigeParent geldig is
            If (huidigeParent Is Nothing) Then

                Dim fout As String = String.Concat("Fout tijdens genereren van de categoriestructuren: De parent met nummer ", categorie.FK_parent, " bestaat niet in deze tree.")
                Dim e As New ErrorLogger(fout, "TREE_0003")
                e.Args.Add("Treenaam: " & treenaam)
                e.Args.Add("CategorieID van de kindcategorie wiens parent niet bestaat: " & categorie.CategorieID)
                e.Args.Add("VersieID van de kindcategorie: " & categorie.FK_versie.ToString)
                e.Args.Add("BedrijfID van de kindcategorie: " & categorie.FK_bedrijf.ToString)
                e.Args.Add("TaalID van de kindcategorie:" & categorie.FK_taal.ToString)
                ErrorLogger.WriteError(e)
                Return False
            End If

            'Maak een kind aan
            Dim kind As New Node(categorie.CategorieID, ContentType.Categorie, categorie.Categorie, categorie.Hoogte)

            'Plaats het kind onder de parent
            huidigeParent.AddChild(kind)

            'En nu alle artikels die onder deze categorie staan ophalen
            artikeldt = dbartikel.GetArtikelsByParent(categorie.CategorieID)

            'De huidige parent wordt nu het kind
            huidigeParent = kind
            Dim hoogte As Integer = 0
            For Each artikel As tblArtikelRow In artikeldt
                Dim art As New Node(artikel.ArtikelID, ContentType.Artikel, artikel.Titel, hoogte)

                If (categorie.FK_taal = artikel.FK_Taal) And (categorie.FK_versie = artikel.FK_Versie) And (categorie.FK_bedrijf = artikel.FK_Bedrijf) Then
                    huidigeParent.AddChild(art)
                    hoogte = hoogte + 1
                Else
                    Dim fout As String = String.Concat("Waarschuwing: Het artikel """, artikel.Titel, """ (artikelID: ", artikel.ArtikelID, ") heeft andere foreign keys dan de categorie waaronder ze staat (zie parameters).")
                    Dim e As New ErrorLogger(fout, "TREE_0006")
                    e.Args.Add("Treenaam: " & treenaam)
                    e.Args.Add("Categoriegegevens:")
                    e.Args.Add("CategorieID: " & categorie.CategorieID)
                    e.Args.Add("VersieID: " & categorie.FK_versie.ToString)
                    e.Args.Add("BedrijfID: " & categorie.FK_bedrijf.ToString)
                    e.Args.Add("TaalID:" & categorie.FK_taal.ToString)
                    e.Args.Add("Artikelgegevens:")
                    e.Args.Add("ArtikelID: " & artikel.ArtikelID.ToString)
                    e.Args.Add("VersieID: " & artikel.FK_Versie.ToString)
                    e.Args.Add("BedrijfID: " & artikel.FK_Bedrijf.ToString)
                    e.Args.Add("TaalID:" & artikel.FK_Taal.ToString)
                    ErrorLogger.WriteError(e)
                End If

            Next artikel

        Next categorie

        Tree.AddTree(t)

        Return True

    End Function


    ''' <summary>
    ''' Deze functie leest recursief een volledige tree uit en zet alles in een DropDownList.
    ''' </summary>
    ''' <param name="ddl">De te populeren DropDownLijst.</param>
    ''' <param name="diepte">De huidige diepte. Begin met de hoogte van de root node. (Meestal -1)</param>
    ''' <param name="parent">De huidige parent. Begin met de root node.</param>
    Public Sub VulCategorieDropdown(ByRef ddl As DropDownList, ByRef parent As Node, ByVal diepte As Integer)
        Dim huidigediepte As Integer = diepte + 1

        For Each n As Node In parent.GetChildren

            'We willen enkel categorieën
            If n.Type = ContentType.Artikel Then Continue For


            Dim tekst As String = String.Empty

            'Spaties toevoegen
            For index As Integer = 0 To huidigediepte
                tekst = String.Concat(tekst, "---")
            Next index

            tekst = String.Concat(tekst, HtmlDecode(n.Titel))

            Dim listitem As New ListItem(tekst, n.ID)

            ddl.Items.Add(listitem)

            If n.GetChildCount > 0 Then
                VulCategorieDropdown(ddl, n, huidigediepte)
            End If
        Next n

    End Sub

    Public Function LeesTree(ByVal htmlcode As String, ByVal parent As Node, ByVal diepte As Integer) As String

        Dim huidigediepte As Integer = diepte + 1

        If Not parent.GetChildCount = 0 Then
            If parent.ID = 0 Then
                htmlcode = String.Concat(htmlcode, "<div id=""parent_", parent.ID, """><div>")
            Else
                htmlcode = String.Concat(htmlcode, "<div id=""parent_", parent.ID, """ style=""display:none;""><div>")
            End If
        End If

        For Each kind As Node In parent.GetChildren

            For i As Integer = 0 To huidigediepte
                htmlcode = String.Concat(htmlcode, "&nbsp;&nbsp;&nbsp;")
            Next i

            If kind.Type = ContentType.Categorie Then
                htmlcode = String.Concat(htmlcode, "<a href=""#"" onclick=""Effect.toggle('parent_", kind.ID, "', 'slide', { duration: 0.5 }); veranderDropdown('imgtab_", kind.ID, "'); return false;""><img src=""CSS/images/add.png"" border=""0"" id=""imgtab_", kind.ID, """> ", kind.Titel, "</a><br/>")
            Else
                htmlcode = String.Concat(htmlcode, "<img src=""CSS/images/doc_text_image.png"" border=""0"" /> ", kind.Titel, "<br/>")
            End If

            If kind.Type = ContentType.Categorie Then
                htmlcode = LeesTree(htmlcode, kind, huidigediepte)
            End If

        Next kind

        If Not parent.GetChildCount = 0 Then
            htmlcode = String.Concat(htmlcode, "</div></div>")
        End If

        Return htmlcode

    End Function

    ''' <summary>
    ''' Deze functie leest een volledige tree uit en geeft alles weer in unordered list formaat.
    ''' </summary>
    ''' <param name="diepte">De huidige diepte. Begin met de hoogte van de root node. (Meestal -1)</param>
    ''' <param name="parent">De huidige parent. Begin met de root node.</param>
    ''' <param name="htmlcode">De start-HTML-code</param>
    ''' <returns>String met HTML-code voor de volledige tree.</returns>
    Public Function BeginNieuweLijst(ByVal htmlcode As String, ByVal parent As Node, ByVal diepte As Integer) As String

        Dim huidigediepte As Integer = diepte + 1

        If Not parent.GetChildCount = 0 Then
            If parent.ID = 0 Then
                htmlcode = String.Concat(htmlcode, "<div id=""parent_", parent.ID, """><div>")
            Else
                htmlcode = String.Concat(htmlcode, "<div id=""parent_", parent.ID, """ style=""display:none;""><div>")
            End If
        End If

        For Each kind As Node In parent.GetChildren

            For i As Integer = 0 To huidigediepte
                htmlcode = String.Concat(htmlcode, "&nbsp;&nbsp;")
            Next i

            If kind.Type = ContentType.Categorie Then
                htmlcode = String.Concat(htmlcode, "<a href=""#"" onclick=""Effect.toggle('parent_", kind.ID, "', 'slide', { duration: 0.5 }); veranderDropdown('imgtab_", kind.ID, "'); return false;""><img src=""CSS/images/add.png"" border=""0"" id=""imgtab_", kind.ID, """> ", kind.Titel, "</a><br/>")
            Else
                htmlcode = String.Concat(htmlcode, "<a id=""child_", kind.ID, """ href=""page.aspx?id=", kind.ID, """><img src=""CSS/images/doc_text_image.png"" border=""0"" /> ", kind.Titel, "</a><br/>")
            End If

            If kind.Type = ContentType.Categorie Then
                htmlcode = BeginNieuweLijst(htmlcode, kind, huidigediepte)
            End If

        Next kind

        If Not parent.GetChildCount = 0 Then
            htmlcode = String.Concat(htmlcode, "</div></div>")
        End If

        Return htmlcode
    End Function

    ''' <summary>
    ''' Voegt een artikel toe aan een categorie. Geeft de string "OK" terug indien gelukt, foutboodschap bij een fout.
    ''' </summary>
    ''' <param name="categorieID">Het database-ID van de categorie waaraan het artikel zal worden toegevoegd.</param>
    ''' <param name="tag">De unieke tag van het toe te voegen artikel.</param>
    ''' <returns>Geeft de string 'OK' terug indien geslaagd, foutboodschap indien gefaald.</returns>
    Public Function VoegArtikelToeAanCategorie(ByVal tag As String, ByRef categorieID As Integer) As String

        Dim categorie As Node = DoorzoekTreeVoorNode(categorieID, ContentType.Categorie)

        'Even checken of deze categorie wel bestaat
        If (categorie Is Nothing) Then

            Dim fout As String = String.Concat("De opgevraagde node (zie parameters) bestaat niet in het geheugen.")
            Dim err As New ErrorLogger(fout, "TREE_0008")
            err.Args.Add("tag = " & tag)
            err.Args.Add("categorieID = " & categorieID.ToString)
            ErrorLogger.WriteError(err)

            Return String.Concat("De categorie met nummer """, categorieID, """ bestaat niet in de boomstructuur """, Me._naam, """")
        End If

        'Artikel ophalen uit de database
        Dim row As tblArtikelRow = DatabaseLink.GetInstance.GetArtikelFuncties.GetArtikelByTag(tag)

        If row IsNot Nothing Then
            'Artikel toevoegen aan de categorie
            Dim artikelnode As New Node(New Artikel(row))
            artikelnode.Type = ContentType.Artikel
            artikelnode.Hoogte = Node.VindMaxHoogteVanCategorie(categorie)
            categorie.AddChild(artikelnode)
        Else
            Return String.Concat("Het artikel met de tag """, tag, """ werd niet gevonden in de database.")
        End If

        Return "OK"
    End Function
End Class
