Imports Microsoft.VisualBasic
Imports Manual

Public Class Taal
    Private _ID As Integer
    Private _taal As String
    Private _taalTag As String
    Private Shared FTalen As List(Of Taal) = Nothing

    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property

    Public Property TaalNaam() As String
        Get
            Return _taal
        End Get
        Set(ByVal value As String)
            _taal = value
        End Set
    End Property

    Public Property TaalTag() As String
        Get
            Return _taalTag
        End Get
        Set(ByVal value As String)
            _taalTag = value
        End Set
    End Property

    ''' <summary>
    ''' Maak een nieuwe taal aan.
    ''' </summary>
    ''' <param name="id">Het database-ID van de taal.</param>
    ''' <param name="taal">De naam van de taal.</param>
    ''' <param name="taaltag">De afkorting van de taal.</param>
    ''' <remarks></remarks>
    Public Sub New(ByVal id As Integer, ByVal taal As String, ByVal taaltag As String)
        _ID = id
        _taal = taal
        _taalTag = TaalTag
    End Sub

    ''' <summary>
    ''' Maak een nieuwe taal aan.
    ''' </summary>
    ''' <param name="row">Een taalrij uit de database.</param>
    ''' <remarks></remarks>
    Public Sub New(ByRef row As tblTaalRow)
        Try
            _ID = row.TaalID
            _taal = row.Taal
            _taalTag = row.TaalTag
        Catch ex As Exception
            Dim e As New ErrorLogger(ex.Message)
            e.Args.Add("_ID = " & row.TaalID.ToString)
            e.Args.Add("_Taal = " & row.Taal)
            e.Args.Add("_taaltag = " & row.TaalTag)
            ErrorLogger.WriteError(e)
        End Try

    End Sub

    ''' <summary>
    ''' Haalt alle talen op vanuit het geheugen
    ''' </summary>
    ''' <returns>Taallijst</returns>
    Public Shared Function GetTalen() As List(Of Taal)
        If (FTalen Is Nothing) Then
            FTalen = New List(Of Taal)
            BouwTaalLijst()
        End If

        Return FTalen
    End Function

    ''' <summary>
    ''' Voeg een taal toe.
    ''' </summary>
    ''' <param name="taal">De toe te voegen taal.</param>
    Public Shared Sub AddTaal(ByVal taal As Taal)
        'Als de taallijst niet bestaat, maken we deze aan
        If (FTalen Is Nothing) Then
            FTalen = New List(Of Taal)
        End If

        'Als de taal niet bestaat, voegen we hem toe
        If (GetTaal(taal) Is Nothing) Then
            FTalen.Add(taal)
        End If
    End Sub

    ''' <summary>
    ''' Voeg een taal toe.
    ''' </summary>
    ''' <param name="taal">De te verwijderen taal.</param>
    Public Shared Sub RemoveTaal(ByVal taal As Taal)
        'Als de taallijst niet bestaat, maken we deze aan
        If (FTalen Is Nothing) Then
            FTalen = New List(Of Taal)
        End If

        FTalen.Remove(taal)
    End Sub

    ''' <summary>
    ''' Haal een taal op op basis van een taal
    ''' </summary>
    ''' <param name="taal">De te vinden taal.</param>
    ''' <returns>De gezochte taal indien gevonden, Nothing indien niet gevonden</returns>
    Public Shared Function GetTaal(ByVal taal As Taal) As Taal

        If FTalen Is Nothing Then
            BouwTaalLijst()
        End If

        For Each t As Taal In FTalen
            If (t.ID = taal.ID And t.TaalNaam = taal.TaalNaam And t.TaalTag = taal.TaalTag) Then
                Return t
            End If
        Next t

        Return Nothing
    End Function

    ''' <summary>
    ''' Haal een taal op op basis van het ID
    ''' </summary>
    ''' <returns>De gezochte taal indien gevonden, Nothing indien niet gevonden</returns>
    Public Shared Function GetTaal(ByVal ID As Integer) As Taal

        If FTalen Is Nothing Then
            BouwTaalLijst()
        End If

        For Each t As Taal In FTalen
            If (t.ID = ID) Then
                Return t
            End If
        Next t

        Return Nothing
    End Function

    ''' <summary>
    ''' (Her)bouw de taallijst.
    ''' </summary>
    Public Shared Sub BouwTaalLijst()
        Dim dblink As DatabaseLink = DatabaseLink.GetInstance
        Dim dbtaal As TaalDAL = dblink.GetTaalFuncties
        Dim taaldt As tblTaalDataTable = dbtaal.GetAllTaal

        For Each rij As tblTaalRow In taaldt
            Dim t As New Taal(rij)
            Taal.AddTaal(t)
        Next rij
    End Sub


End Class
