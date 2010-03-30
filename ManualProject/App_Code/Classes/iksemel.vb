Imports Microsoft.VisualBasic
Imports System.IO
Imports System.Xml
Public Class iksemel
    Public Function alles() As String
        Dim spancode As String = "<link href=""CSS/iksemel.css""" + "type=""text/css""" + "rel=""stylesheet"""
        Dim m_xmlr As XmlTextReader
        'Create the XML Reader

        m_xmlr = New XmlTextReader("C:\ReferenceManual\template.xml")
        'Disable whitespace so that you don't have to read over whitespaces

        m_xmlr.WhitespaceHandling = WhitespaceHandling.None
        'read the xml declaration and advance to family tag

        m_xmlr.Read()
        'read the artikel tag

        m_xmlr.Read()
        'Load the Loop

        While Not m_xmlr.EOF
            'Go to the titel tag

            m_xmlr.Read()
            'if not start element exit while loop

            If Not m_xmlr.IsStartElement() Then
                Exit While
            End If
            'Get the paragraaf Attribute Value
            Dim paragraafAttribute = m_xmlr.GetAttribute("titel")
            'Read elements firstname and lastname

            m_xmlr.Read()
            'Get the titel Element Value

            Dim titel2NameValue = m_xmlr.ReadElementString("titelklein")
            'Get the tekst Element Value

            Dim tekstNameValue = m_xmlr.ReadElementString("tekst")
            'Write Result to the Console
            'spancode = spancode + "<span id=""titel""" + "> " + paragraafAttribute + "</span><br \>"
            spancode = spancode + "<span id=""titelklein""" + "> " + titel2NameValue + "</span><br \><br \>"
            spancode = spancode + "<span id=""tekst""" + "> " + tekstNameValue + "</span><br \><br \><br \>"

        End While
        'close the reader
        m_xmlr.Close()
        Return spancode
        'Dim span As String = " "
        'Dim m_xmlr As XmlTextReader
        ''Create the XML Reader

        'm_xmlr = New XmlTextReader("C:\ReferenceManual\file.xml")
        ''Disable whitespace so that you don't have to read over whitespaces

        'm_xmlr.WhitespaceHandling = WhitespaceHandling.None
        ''read the xml declaration and advance to family tag

        'm_xmlr.Read()
        ''read the family tag

        'm_xmlr.Read()
        ''Load the Loop

        'While Not m_xmlr.EOF
        '    'Go to the name tag

        '    m_xmlr.Read()
        '    'if not start element exit while loop

        '    If Not m_xmlr.IsStartElement() Then
        '        Exit While
        '    End If
        '    'Get the Gender Attribute Value

        '    Dim genderAttribute = m_xmlr.GetAttribute("titel")
        '    'Read elements firstname and lastname

        '    m_xmlr.Read()
        '    'Get the firstName Element Value

        '    Dim firstNameValue = m_xmlr.ReadElementString("titelklein")
        '    'Get the lastName Element Value

        '    Dim lastNameValue = m_xmlr.ReadElementString("tekst")
        '    'Write Result to the Console
        '    span = span + genderAttribute + " " + firstNameValue + " " + lastNameValue + "."

        'End While
        ''close the reader

        'm_xmlr.Close()
        'Return span
    End Function
End Class
