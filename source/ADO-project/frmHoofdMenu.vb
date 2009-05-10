Public Class frmHoofdMenu

#Region "Publieke Variabelen"
    Public mySQLConnection As clDataViaSql
    Public myAccessConnection As clDataViaAccess
    Public BlnSQLConnectieGelukt As Boolean
    Public BlnAccessConnectieGelukt As Boolean
    Public HuidigForm As Form = New frmConfig()

    Public Structure LabelSettings
        Public SQLServer As String
        Public SQLDataBase As String
        Public SQLGebruiker As String
        Public AccessDataBase As String
        Public AccessTabel As String
        Public AccessKolom As String
    End Structure

    Public mLabels As LabelSettings
#End Region

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.
        mySQLConnection = New clDataViaSql
        myAccessConnection = New clDataViaAccess
    End Sub

    Public Sub ClearOtherWindows()
        If (HuidigForm.Created) Then
            HuidigForm.Close()
        End If
    End Sub

    Private Sub frmHoofdMenu_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        HuidigForm.MdiParent = Me
        HuidigForm.Show()
    End Sub

    Public Sub ToonStartScherm()
        ClearOtherWindows()
        HuidigForm = New frmStart()
        HuidigForm.MdiParent = Me
        If (HuidigForm.Name = frmStart.Name) Then
            CType(HuidigForm, frmStart).mLabels = Me.mLabels
        End If
        HuidigForm.Show()
    End Sub
End Class
