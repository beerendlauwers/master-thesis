Imports Microsoft.VisualBasic
Imports System.IO
Imports System.Web.HttpContext
Imports System.Globalization
Imports System.Diagnostics

''' <summary>
''' Een klasse die fouten wegschrijft naar logbestanden.
''' </summary>
''' <remarks>Gelieve niet teveel te gebruiken, enkel voor kritische fouten. Deze manier van error logging is niet zo performant.</remarks>
Public Class ErrorLogger
    Private _boodschap As String
    Private _code As String
    Private _locatie As String
    Private _argumenten As List(Of String)
    Private Shared _errorLock As New Object

    ''' <summary>
    ''' Maak een nieuwe error aan.
    ''' </summary>
    ''' <param name="boodschap">De foutboodschap.</param>
    Public Sub New(ByVal boodschap As String)
        _boodschap = boodschap
        _argumenten = New List(Of String)
    End Sub

    ''' <summary>
    ''' Maak een nieuwe error aan.
    ''' </summary>
    ''' <param name="boodschap">De foutboodschap.</param>
    ''' <param name="code">De unieke foutcode.</param>
    Public Sub New(ByVal boodschap As String, ByVal code As String)
        _boodschap = boodschap
        _code = code
        _argumenten = New List(Of String)
    End Sub

    Public ReadOnly Property Args() As List(Of String)
        Get
            Return _argumenten
        End Get
    End Property

    Public Property Boodschap() As String
        Get
            Return _boodschap
        End Get
        Set(ByVal value As String)
            _boodschap = value
        End Set
    End Property

    Public Property Code() As String
        Get
            Return _code
        End Get
        Set(ByVal value As String)
            _code = value
        End Set
    End Property

    Public Property Locatie() As String
        Get
            Return _locatie
        End Get
        Set(ByVal value As String)
            _locatie = value
        End Set
    End Property

    ''' <summary>
    ''' Schrijf een error weg naar het logbestand van vandaag.
    ''' </summary>
    ''' <param name="e">De weg te schrijven fout.</param>
    Public Shared Sub WriteError(ByRef e As ErrorLogger)

        Try
            Dim trace As New StackTrace(True)
            Dim fr As StackFrame = trace.GetFrame(1)

            Dim split As String() = fr.GetFileName.Split("\")
            e.Locatie = split(split.Length - 1)
            e.Locatie = String.Concat(e.Locatie, "::", fr.GetMethod)

            If e.Code = String.Empty Then
                e.Code = "ONBEKENDE FOUT"
            End If

            SyncLock _errorLock

                Dim logpad As String = String.Concat("~/Logs/", DateTime.Today.ToString("dd-MM-yyyy"), ".txt")

                'Als het logbestand nog niet bestaat, maken we het aan
                If Not File.Exists(Current.Server.MapPath(logpad)) Then
                    File.Create(Current.Server.MapPath(logpad)).Close()
                End If

                'Klaarmaken om te schrijven
                Dim w As StreamWriter = File.AppendText(Current.Server.MapPath(logpad))

                'Newline
                w.WriteLine(vbCrLf)

                'Datum van vandaag
                w.WriteLine(String.Concat(DateTime.Now.ToString(CultureInfo.InvariantCulture), ":"))

                'Foutboodschap
                w.WriteLine(String.Concat("[", e.Code, "] ", "Fout in ", e.Locatie, ": ", e.Boodschap))

                'Newline
                w.WriteLine(vbCrLf)

                'Argumenten
                If e.Args.Count > 0 Then
                    w.WriteLine("Meegekregen argumenten: ")
                    For Each arg As String In e.Args
                        w.WriteLine(arg)
                    Next
                End If

                'Newline
                w.WriteLine(vbCrLf)

                'Stack Trace
                Dim st As New StackTrace(True)
                w.WriteLine("Stack trace:")

                For i As Integer = 0 To st.FrameCount - 1
                    Dim frame As StackFrame = st.GetFrame(i)
                    w.WriteLine(String.Concat("Bestand: ", frame.GetFileName, " | Method: ", frame.GetMethod, " | Lijn: ", frame.GetFileLineNumber))
                Next i

                'Lijntje
                w.WriteLine("__________________________________________________")

                'Newline
                w.WriteLine(vbCrLf)

                'Flushen en sluiten
                w.Flush()
                w.Close()

            End SyncLock

        Catch ex As Exception
            Return
        End Try

    End Sub


End Class
