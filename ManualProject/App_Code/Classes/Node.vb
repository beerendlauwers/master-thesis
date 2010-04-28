Imports Microsoft.VisualBasic

Public Enum ContentType
    Categorie = 0
    Artikel = 1
End Enum

Public Class Node
    Implements IComparable

    Private _ID As Integer
    Private _type As ContentType
    Private _titel As String
    Private _hoogte As Integer
    Private _children As List(Of Node)

    ''' <summary>
    ''' Maak een nieuwe node aan. Werkt voor artikels en categorieën.
    ''' </summary>
    ''' <param name="id">Het database-ID van de bron.</param>
    ''' <param name="type">Het type van de bron.</param>
    ''' <param name="titel">De titel van de bron.</param>
    ''' <param name="hoogte">De hoogte van de bron.</param>
    ''' <remarks></remarks>
    Public Sub New(ByVal id As Integer, ByVal type As ContentType, ByVal titel As String, ByVal hoogte As Integer)
        _ID = id
        _type = type
        _titel = titel
        _hoogte = hoogte
        _children = New List(Of Node)
    End Sub

    ''' <summary>
    ''' <para>Maak een nieuwe node aan op basis van een artikel.
    ''' Vergeet niet <see cref="VindMaxHoogteVanCategorie"/> te gebruiken
    ''' om de hoogte van deze nieuwe node juist in te stellen.</para>
    ''' </summary>
    Public Sub New(ByRef artikel As Artikel)
        If artikel Is Nothing Then
            Dim e As New ErrorLogger("Kon een node niet aanmaken omdat het gegeven artikel niet bestaat in de database.", "NODE0001")
        End If
        _ID = artikel.ID
        _type = ContentType.Artikel
        _titel = artikel.Titel
        _children = New List(Of Node)
    End Sub

    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property

    Public Property Type() As ContentType
        Get
            Return _type
        End Get
        Set(ByVal value As ContentType)
            _type = value
        End Set
    End Property

    Public Property Titel() As String
        Get
            Return _titel
        End Get
        Set(ByVal value As String)
            _titel = value
        End Set
    End Property

    Public Property Hoogte() As Integer
        Get
            Return _hoogte
        End Get
        Set(ByVal value As Integer)
            _hoogte = value
        End Set
    End Property

    Public Overloads Function CompareTo(ByVal obj As Object) As Integer Implements IComparable.CompareTo
        Dim anderobject As Node = TryCast(obj, Node)
        If anderobject IsNot Nothing Then
            Return Me.Hoogte.CompareTo(anderobject.Hoogte)
        End If
    End Function


    ''' <summary>
    ''' Haal de kinderen op van deze node.
    ''' </summary>
    ''' <returns>Lijst van kinderen.</returns>
    Public Function GetChildren() As List(Of Node)
        Return _children
    End Function

    ''' <summary>
    ''' Voeg een kind aan deze node toe.
    ''' </summary>
    ''' <param name="node">De toe te voegen node.</param>
    Public Sub AddChild(ByRef node As Node)
        _children.Add(node)
    End Sub

    ''' <summary>
    ''' Verwijder een kind van deze node.
    ''' </summary>
    ''' <param name="node">De te verwijderen node.</param>
    Public Sub RemoveChild(ByRef node As Node)
        _children.Remove(node)
    End Sub

    ''' <summary>
    ''' Geeft het aantal kinderen van deze node terug.
    ''' </summary>
    ''' <returns>Het aantal kinderen onder deze node</returns>
    Public Function GetChildCount() As Integer
        Return _children.Count
    End Function

    ''' <summary>
    ''' Telt recursief het aantal categoriën onder deze node.
    ''' </summary>
    ''' <param name="aantal">Het huidige aantal categorieën.</param>
    ''' <returns>Totaal aantal categorieën</returns>
    Public Function GetRecursiveCategorieCount(ByVal aantal As Integer) As Integer

        For Each kind As Node In _children
            If kind.Type = ContentType.Categorie Then
                aantal = aantal + 1
                aantal = kind.GetRecursiveCategorieCount(aantal)
            End If
        Next kind

        Return aantal

    End Function

    ''' <summary>
    ''' Telft recursief het aantal artikels onder deze node.
    ''' </summary>
    ''' <param name="aantal">Het huidige aantal artikels.</param>
    ''' <returns>Totaal aantal artikels.</returns>
    Public Function GetRecursiveArtikelCount(ByVal aantal As Integer) As Integer

        For Each kind As Node In _children
            If kind.Type = ContentType.Artikel Then
                aantal = aantal + 1
            End If
            If kind.Type = ContentType.Categorie Then
                aantal = kind.GetRecursiveArtikelCount(aantal)
            End If
        Next kind

        Return aantal

    End Function

    ''' <summary>
    ''' Doorzoek recursief de kinderen van deze node, de kinderen van de kinderen, etc om een node te vinden
    ''' </summary>
    ''' <param name="id">Het database-ID van de te vinden node.</param>
    ''' <param name="type">Het type van de te vinden node.</param>
    ''' <returns>De gezochte node indien gevonden, Nothing indien niet gevonden.</returns>
    Public Function GetChildBy(ByVal id As Integer, ByVal type As ContentType) As Node

        For Each n As Node In _children
            'Huidige kinderen doorzoeken
            If n._ID = id And n._type = type Then
                Return n
            End If

            'Kinderen van dit kind doorzoeken
            Dim child As Node = n.GetChildBy(id, type)
            If child IsNot Nothing Then
                Return child
            End If
        Next n

        Return Nothing
    End Function

    ''' <summary>
    ''' Verwijder het gegeven kind uit de lijst van kinderen.
    ''' </summary>
    ''' <param name="kind">Het te verwijderen kind.</param>
    Public Sub VerwijderKind(ByRef kind As Node)
        Dim hoogte As Integer = -1

        'Kind opzoeken, hoogte opslaan en dan verwijderen
        For Each n As Node In _children
            If n Is kind Then
                hoogte = n.Hoogte
                _children.Remove(n)
                Exit For
            End If
        Next n

        If hoogte = -1 Then Return

        'Hoogte aanpassen voor de resterende kinderen
        For Each n As Node In _children
            If (n.Hoogte > hoogte) Then
                n.Hoogte = n.Hoogte - 1
            End If
        Next n

    End Sub

    ''' <summary>
    ''' Doorzoek recursief de kinderen van deze node, de kinderen van de kinderen, etc om de parent van een node te vinden
    ''' </summary>
    ''' <param name="node">De node waarvan men de parent zoekt.</param>
    ''' <returns>De parent van de gegeven node indien gevonden, Nothing indien niet gevonden.</returns>
    Public Function VindParentVanNode(ByRef node As Node) As Node

        For Each kind As Node In _children
            If (kind.ID = node.ID And kind.Type = node.Type) Then
                Return Me
            End If

            Dim returnednode As Node = kind.VindParentVanNode(node)
            If returnednode IsNot Nothing Then
                Return returnednode
            End If
        Next

        Return Nothing
    End Function

    ''' <summary>
    ''' Doorzoek de kinderen van deze node om de hoogste waarde van 'Hoogte' te vinden.
    ''' </summary>
    ''' <param name="node">De node waarvan men de kinderen wilt doorzoeken.</param>
    ''' <returns>De hoogste waarde van attribuut 'Hoogte'.</returns>
    Public Shared Function VindMaxHoogteVanCategorie(ByRef node As Node) As Integer
        Dim maxhoogte As Integer = 0

        For Each kind As Node In node.GetChildren
            If (kind.Hoogte > maxhoogte) Then
                maxhoogte = kind.Hoogte
            End If
        Next kind

        Return maxhoogte
    End Function

End Class
