Imports Microsoft.VisualBasic

Public Class AutoOptie

    Private _optieID As Integer
    Private _AutoID As Integer

    Public Property OptieID() As Integer
        Get
            Return _optieID
        End Get
        Set(ByVal value As Integer)
            _optieID = value
        End Set
    End Property


    Public Property AutoID() As Integer
        Get
            Return _AutoID
        End Get
        Set(ByVal value As Integer)
            _AutoID = value
        End Set
    End Property
    Public Sub New()

    End Sub
End Class
