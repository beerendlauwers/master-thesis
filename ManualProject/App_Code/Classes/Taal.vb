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

    Public Sub New(ByVal id As Integer, ByVal taal As String, ByVal taaltag As String)
        _ID = id
        _taal = taal
        _taalTag = TaalTag
    End Sub

    Public Sub New(ByRef row As tblTaalRow)
        _ID = row.TaalID
        _taal = row.Taal
        _taalTag = row.TaalTag
    End Sub


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
    ''' Haal een taal op op basis van een taal
    ''' </summary>
    Public Shared Function GetTaal(ByVal taal As Taal) As Taal

        If FTalen Is Nothing Then
            BouwTaalLijst()
        End If

        For Each t As Taal In FTalen
            If (t Is taal) Then
                Return t
            End If
        Next t

        Return Nothing
    End Function

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
