Imports Microsoft.VisualBasic
Imports Manual

Public Class Tree
    Private _naam As String
    Private _taal As Integer
    Private _versie As Integer
    Private _bedrijf As Integer
    Private _rootnode As Node

    Private Shared FTrees As List(Of Tree) = Nothing

    Public Sub New(ByVal naam As String, ByVal taal As Integer, ByVal versie As Integer, ByVal bedrijf As Integer, ByVal rootnode As Node)
        _naam = naam
        _taal = taal
        _versie = versie
        _bedrijf = bedrijf
        _rootnode = rootnode
    End Sub

    Public Property RootNode() As Node
        Get
            Return _rootnode
        End Get
        Set(ByVal node As Node)
            _rootnode = node
        End Set
    End Property

    ''' <summary>
    ''' Doorzoek recursief de tree om een node te vinden op bassi van id en type.
    ''' </summary>
    Public Function DoorzoekTreeVoorNode(ByVal id As Integer, ByVal type As ContentType) As Node

        If (_rootnode.ID = id And _rootnode.Type = ContentType.Categorie) Then
            Return _rootnode
        End If

        Return _rootnode.GetChildBy(id, type)
    End Function

    ''' <summary>
    ''' Haal een tree op op basis van de unieke combinatie van taal, versie en het bedrijf.
    ''' </summary>
    Public Shared Function GetTree(ByVal taal As Integer, ByVal versie As Integer, ByVal bedrijf As Integer) As Tree

        For Each t As Tree In FTrees
            If (t._taal = taal And t._versie = versie And t._bedrijf = bedrijf) Then
                Return t
            End If
        Next t

        Return Nothing
    End Function

    ''' <summary>
    ''' Haal een tree op op basis van de unieke combinatie van taal, versie en het bedrijf.
    ''' </summary>
    Public Shared Function GetTree(ByRef tree As Tree) As Tree
        For Each t As Tree In FTrees
            If (t._taal = tree._taal And t._versie = tree._versie And t._bedrijf = tree._bedrijf) Then
                Return t
            End If
        Next t

        Return Nothing
    End Function

    ''' <summary>
    ''' Voeg een tree toe.
    ''' </summary>
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
    Public Shared Function GetTrees() As List(Of Tree)
        Return FTrees
    End Function

    Public Shared Sub BouwTrees()
        'Trees opbouwen
        Dim dblink As DatabaseLink = DatabaseLink.GetInstance

        Dim dbcategorie As CategorieDAL = dblink.GetCategorieFuncties
        Dim dbtaal As TaalDAL = dblink.GetTaalFuncties
        Dim dbbedrijf As BedrijfDAL = dblink.GetBedrijfFuncties
        Dim dbversie As VersieDAL = dblink.GetVersieFuncties

        'Alle talen ophalen
        Dim taaldt As tblTaalDataTable = dbtaal.GetAllTaal
        Dim bedrijfdt As tblBedrijfDataTable = dbbedrijf.GetAllBedrijf
        Dim versiedt As tblVersieDataTable = dbversie.GetAllVersie
        Dim categoriedt As tblCategorieDataTable

        For Each taal As tblTaalRow In taaldt
            For Each bedrijf As tblBedrijfRow In bedrijfdt
                For Each versie As tblVersieRow In versiedt

                    categoriedt = dbcategorie.GetAllCategorieBy(taal.TaalID, bedrijf.BedrijfID, versie.VersieID)

                    'Root node ophalen en aanmaken
                    Dim rootnode As Node
                    Dim rootnoderij As tblCategorieRow = categoriedt.Rows(0)
                    If rootnoderij.Categorie = "root_node" Then
                        rootnode = New Node(rootnoderij.CategorieID, ContentType.Categorie, String.Empty, bedrijf.Naam)
                    Else
                        MsgBox("Er is een fout gebeurd tijdens het genereren van de categoriestructuren: De basis (of root node) van de boomstructuur bestaat niet.")
                        Return
                    End If

                    Dim treenaam As String = String.Concat("TREE_", taal.Taal, "_", bedrijf.Naam, "_", versie.Versie)
                    Dim t As New Tree(treenaam, taal.TaalID, versie.VersieID, bedrijf.BedrijfID, rootnode)
                    Dim huidigeParent As Node

                    For Each categorie As tblCategorieRow In categoriedt

                        'De root node heeft geen parent, dus in dit geval kunnen we gewoon verdergaan.
                        If categorie.FK_parent = categorie.CategorieID Then Continue For

                        'Haal de juiste parent op van dit kind.
                        huidigeParent = t.DoorzoekTreeVoorNode(categorie.FK_parent, ContentType.Categorie)

                        'Check of huidigeParent geldig is
                        If (huidigeParent Is Nothing) Then
                            MsgBox(String.Concat("Er is een fout gebeurd tijdens het genereren van de categoriestructuren: De parent met nummer ", categorie.FK_parent, " bestaat niet."))
                            Return
                        End If

                        'Maak een kind aan
                        Dim kind As New Node(categorie.CategorieID, ContentType.Categorie, "", categorie.Categorie)

                        'Plaats het kind onder de parent
                        huidigeParent.AddChild(kind)

                    Next categorie

                    Tree.AddTree(t)

                Next versie
            Next bedrijf
        Next taal
    End Sub
End Class
