Public Class frmHoofdMenu
    Public mySQLConnection As clDataViaSql
    Public myAccessConnection As clDataViaAccess
    Public BlnSQLConnectieGelukt As Boolean
    Public BlnAccessConnectieGelukt As Boolean
    Public HuidigForm As Form = New frmConfig()

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
        HuidigForm.Show()
    End Sub
End Class
