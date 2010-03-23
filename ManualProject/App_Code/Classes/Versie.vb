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

    Public Sub New(ByVal id As Integer, ByVal versie As String)
        _ID = id
        _versie = versie
    End Sub

    Public Sub New(ByRef row As tblVersieRow)
        _ID = row.VersieID
        _versie = row.Versie
    End Sub

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
    ''' Haal een versie op op basis van een versie
    ''' </summary>
    Public Shared Function GetVersie(ByVal versie As Versie) As Versie

        If FVersies Is Nothing Then
            BouwVersieLijst()
        End If

        For Each v As Versie In FVersies
            If (v Is versie) Then
                Return v
            End If
        Next v

        Return Nothing
    End Function

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
