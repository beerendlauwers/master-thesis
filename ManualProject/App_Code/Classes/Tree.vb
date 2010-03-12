Imports Microsoft.VisualBasic

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
    ''' Voeg een tree toe 
    ''' </summary>
    Public Shared WriteOnly Property AddTree() As Tree
        Set(ByVal tree As Tree)

            'Als de treelijst niet bestaat, maken we deze aan
            If (FTrees Is Nothing) Then
                FTrees = New List(Of Tree)
            End If

            'Als de tree niet bestaat, voegen we hem toe
            If (GetTree(tree) Is Nothing) Then
                FTrees.Add(tree)
            End If
        End Set
    End Property
End Class
