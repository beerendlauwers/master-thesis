Imports Microsoft.VisualBasic
Imports Manual

Public Class Versie
    Private _ID As Integer
    Private _versie As String
    Private Shared FVersies As List(Of Versie) = Nothing

    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property

    Public Property VersieNaam() As String
        Get
            Return _versie
        End Get
        Set(ByVal value As String)
            _versie = value
        End Set
    End Property

    ''' <summary>
    '''Maak een nieuwe versie aan.
    ''' </summary>
    ''' <param name="id">Het database-ID van de versie.</param>
    ''' <param name="versie">Het versienummer van de versie.</param>
    Public Sub New(ByVal id As Integer, ByVal versie As String)
        _ID = id
        _versie = versie
    End Sub
    ''' <summary>
    '''Maak een nieuwe versie aan.
    ''' </summary>
    ''' <param name="row">Een versierij vanuit de database</param>
    Public Sub New(ByRef row As tblVersieRow)

        If row Is Nothing Then
            Dim e As New ErrorLogger("De constructor van klasse Versie kreeg een ongeldige rij binnen van tblVersie.", "VERSIE0001")
            ErrorLogger.WriteError(e)
            Return
        End If

        _ID = row.VersieID
        _versie = row.Versie
    End Sub

    ''' <summary>
    ''' Haalt alle versies op vanuit het geheugen.
    ''' </summary>
    ''' <returns>Versielijst</returns>
    Public Shared Function GetVersies() As List(Of Versie)
        If (FVersies Is Nothing) Then
            FVersies = New List(Of Versie)
            BouwVersieLijst()
        End If

        Return FVersies
    End Function

    ''' <summary>
    ''' Voeg een versie toe.
    ''' </summary>
    ''' <param name="versie">De toe te voegen versie.</param>
    Public Shared Sub AddVersie(ByVal versie As Versie)
        'Als de treelijst niet bestaat, maken we deze aan
        If (FVersies Is Nothing) Then
            FVersies = New List(Of Versie)
        End If

        'Als de tree niet bestaat, voegen we hem toe
        If (GetVersie(versie) Is Nothing) Then
            FVersies.Add(versie)
        End If
    End Sub

    ''' <summary>
    ''' Verwijder een versie.
    ''' </summary>
    ''' <param name="versie">De te verwijderen versie.</param>
    Public Shared Sub RemoveVersie(ByVal versie As Versie)
        'Als de treelijst niet bestaat, maken we deze aan
        If (FVersies Is Nothing) Then
            FVersies = New List(Of Versie)
        End If

        FVersies.Remove(versie)
    End Sub

    ''' <summary>
    ''' Haal een versie op op basis van een versie
    ''' </summary>
    ''' <param name="versie">De te vinden versie.</param>
    ''' <returns>De gezochte versie indien gevonden, Nothing indien niet gevonden</returns>
    Public Shared Function GetVersie(ByVal versie As Versie) As Versie

        If FVersies Is Nothing Then
            BouwVersieLijst()
        End If

        For Each v As Versie In FVersies
            If (v.ID = versie.ID And v.VersieNaam = versie.VersieNaam) Then
                Return v
            End If
        Next v

        Return Nothing
    End Function

    ''' <summary>
    ''' Haal een versie op op basis van het ID
    ''' </summary>
    ''' <param name="ID">Het database-ID van de te vinden versie.</param>
    '''   <returns>De gezochte versie indien gevonden, Nothing indien niet gevonden</returns>
    Public Shared Function GetVersie(ByVal ID As Integer) As Versie

        If FVersies Is Nothing Then
            BouwVersieLijst()
        End If

        For Each v As Versie In FVersies
            If (v.ID = ID) Then
                Return v
            End If
        Next v

        Return Nothing
    End Function

    ''' <summary>
    ''' (Her)bouw de versielijst.
    ''' </summary>
    Public Shared Sub BouwVersieLijst()
        Dim dblink As DatabaseLink = DatabaseLink.GetInstance
        Dim dbversie As VersieDAL = dblink.GetVersieFuncties
        Dim versiedt As tblVersieDataTable = dbversie.GetAllVersie

        For Each rij As tblVersieRow In versiedt
            Dim v As New Versie(rij.VersieID, rij.Versie)
            Versie.AddVersie(v)
        Next rij
    End Sub

End Class
