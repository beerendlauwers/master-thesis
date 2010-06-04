Imports Microsoft.VisualBasic
Imports Manual

Public Class Bedrijf
    Private _ID As Integer
    Private _naam As String
    Private _tag As String

    Private Shared FBedrijven As List(Of Bedrijf) = Nothing

    Public Property ID() As Integer
        Get
            Return _ID
        End Get
        Set(ByVal value As Integer)
            _ID = value
        End Set
    End Property

    Public Property Naam() As String
        Get
            Return _naam
        End Get
        Set(ByVal value As String)
            _naam = value
        End Set
    End Property

    Public Property Tag() As String
        Get
            Return _tag
        End Get
        Set(ByVal value As String)
            _tag = value
        End Set
    End Property

    Public Sub New(ByVal id As Integer, ByVal naam As String, ByVal tag As String)
        _ID = id
        _naam = naam
        _tag = Tag
    End Sub

    Public Sub New(ByRef row As tblBedrijfRow)
		Try
			_ID = row.BedrijfID
			_naam = row.Naam
			_tag = row.Tag
		Catch ex as Exception
			Dim e as new ErrorLogger("De constructor van klasse Bedrijf kreeg een ongeldige rij binnen van tblBedrijf.","BEDRIJF_0001")
			ErrorLogger.WriteError( e )
		End Try

    End Sub

    Public Shared Function GetBedrijven() As List(Of Bedrijf)
        If (FBedrijven Is Nothing) Then
            FBedrijven = New List(Of Bedrijf)
            BouwBedrijfLijst()
        End If

        Return FBedrijven
    End Function

    ''' <summary>
    ''' Voeg een bedrijf toe.
    ''' </summary>
    Public Shared Sub AddBedrijf(ByVal bedrijf As Bedrijf)
        'Als de treelijst niet bestaat, maken we deze aan
        If (FBedrijven Is Nothing) Then
            FBedrijven = New List(Of Bedrijf)
        End If

        'Als de tree niet bestaat, voegen we hem toe
        If (GetBedrijf(bedrijf) Is Nothing) Then
            FBedrijven.Add(bedrijf)
        End If
    End Sub

    ''' <summary>
    ''' Verwijder een bedrijf.
    ''' </summary>
    Public Shared Sub RemoveBedrijf(ByVal bedrijf As Bedrijf)
        'Als de treelijst niet bestaat, maken we deze aan
        If (FBedrijven Is Nothing) Then
            FBedrijven = New List(Of Bedrijf)
        End If

        FBedrijven.Remove(bedrijf)
    End Sub

    ''' <summary>
    ''' Haal een bedrijf op op basis van de naam.
    ''' </summary>
    Public Shared Function GetBedrijf(ByVal naam As String) As Bedrijf

        If FBedrijven Is Nothing Then
            BouwBedrijfLijst()
        End If

        For Each b As Bedrijf In FBedrijven
            If (b.Naam = naam) Then
                Return b
            End If
        Next b

        Return Nothing
    End Function

    ''' <summary>
    ''' Haal een bedrijf op op basis van het bedrijf
    ''' </summary>
    Public Shared Function GetBedrijf(ByVal bedrijf As Bedrijf) As Bedrijf

        If FBedrijven Is Nothing Then
            BouwBedrijfLijst()
        End If

        For Each b As Bedrijf In FBedrijven
            If (b.ID = bedrijf.ID And b.Tag = bedrijf.Tag And b.Naam = bedrijf.Naam) Then
                Return b
            End If
        Next b

        Return Nothing
    End Function

    ''' <summary>
    ''' Haal een bedrijf op op basis van het ID
    ''' </summary>
    Public Shared Function GetBedrijf(ByVal ID As Integer) As Bedrijf

        If FBedrijven Is Nothing Then
            BouwBedrijfLijst()
        End If

        For Each b As Bedrijf In FBedrijven
            If (b.ID = ID) Then
                Return b
            End If
        Next b

        Return Nothing
    End Function

    Public Shared Sub BouwBedrijfLijst()
        Dim dblink As DatabaseLink = DatabaseLink.GetInstance
        Dim dbbedrijf As BedrijfDAL = dblink.GetBedrijfFuncties
        Dim bedrijfdt As tblBedrijfDataTable = dbbedrijf.GetAllBedrijf

        For Each rij As tblBedrijfRow In bedrijfdt
            Dim b As New Bedrijf(rij.BedrijfID, rij.Naam, rij.Tag)
            Bedrijf.AddBedrijf(b)
        Next rij
    End Sub

End Class
