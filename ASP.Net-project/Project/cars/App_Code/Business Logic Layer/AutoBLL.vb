Imports Microsoft.VisualBasic

Public Class AutoBLL
    Private _adapterAuto As New AutosTableAdapters.tblAutoTableAdapter
    Private _autodal As New AutoDAL

    Public Function GetAllAutos() As Autos.tblAutoDataTable
        Try
            Return _adapterAuto.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAutoByAutoID(ByVal autoID As Integer) As Autos.tblAutoDataTable
        Try
            Return _autodal.GetAutoByAutoID(autoID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAutoNaamByAutoID(ByVal id As Integer) As String
        Try
            Return _autodal.GetAutoNaamByAutoID(id)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function CheckOfKentekenReedsBestaat(ByVal kenteken As String) As Boolean
        Try
            If (_autodal.getAutoIDByKenteken(kenteken) = 0) Then
                Return False
            Else
                Return True
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function DeleteAuto(ByVal autoID As Integer) As Boolean
        Try
            If (_adapterAuto.Delete(autoID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function UpdateAuto(ByRef autorow As Autos.tblAutoRow) As Boolean
        Try
            If (_adapterAuto.Update(autorow)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function AddAuto(ByRef a As Autos.tblAutoRow) As Boolean
        Try
            If (_adapterAuto.Insert(a.categorieID, a.modelID, a.autoKleur, a.autoBouwjaar, a.brandstofID, a.autoKenteken, a.autoDagTarief, a.autoKMTotOlieVerversing, a.statusID, a.filiaalID, a.parkeerPlaatsID)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetBeschikbareAutosBy(ByVal gewensteBegindatum As Date, ByVal gewensteEinddatum As Date, ByVal filterOpties() As String) As Autos.tblAutoDataTable
        Try

            'Alle auto's van een bepaalde categorie opvragen.
            Dim autodata As Autos.tblAutoDataTable = _autodal.GetAutosBy(filterOpties)

            'Auto-variabelen.
            Dim returneddata As New Autos.tblAutoDataTable
            Dim dr As Autos.tblAutoRow
            Dim autoID As Integer

            'Logica-variabelen.
            Dim autonummer As Integer = 0
            Dim autobeschikbaar As Boolean = True

            'Variabelen om de reservatiereeksen op te vangen.
            Dim reservatiedata As New Reservaties.tblReservatieDataTable
            Dim reservatiebll As New ReservatieBLL
            Dim reservatierow As Reservaties.tblReservatieRow

            'We gaan voor elke auto binnen onze gewenste categorie
            'de reeks reservaties ophalen en nakijken of de auto beschikbaar is.
            For autonummer = 0 To autodata.Rows.Count

                'Nakijken of er wel auto's zitten in onze selectie.
                If (autodata.Rows.Count = 0 Or autonummer >= autodata.Rows.Count) Then
                    Return returneddata
                Else 'Indien er nog een volgende auto is,
                    'lezen we een nieuwe rij uit de autodata.
                    dr = autodata.Rows(autonummer)
                    'We slaan het autoID uit deze rij op.
                    autoID = dr.autoID
                End If


                'Nu gaan we de reservaties nakijken.

                'Reservatiedata voor deze auto ophalen.
                reservatiedata = reservatiebll.GetAllReservatiesByAutoID(autoID)

                'Even nakijken of er wel reservaties voor deze auto zijn.
                If reservatiedata.Rows.Count = 0 Then
                    'Deze auto toevoegen aan de lijst van beschikbare auto's,
                    'er zijn immers geen reservaties voor deze auto.
                    returneddata.ImportRow(dr)

                Else 'er zijn reservaties.

                    'Voor elke reservatie gaan we checken of deze reservatie
                    'de auto heeft gereserveerd voor onze gewenste datum
                    For Each reservatierow In reservatiedata
                        Dim rowBegindatum As Date = CType(reservatierow.reservatieBegindat, Date)
                        Dim rowEinddatum As Date = CType(reservatierow.reservatieEinddat, Date)

                        'Overlapt deze reservatie met onze gewenste reservatiedatum?
                        If (rowBegindatum <= gewensteEinddatum And gewensteBegindatum <= rowEinddatum) Then

                            'Dikke pech, deze auto kunnen we niet weergeven!
                            autobeschikbaar = False
                            Exit For
                        End If
                    Next

                    'We hebben alle reservaties voor deze auto nagekeken. Is hij 
                    'beschikbaar? Zoja, dan voegen we hem toe aan onze lijst.
                    If (autobeschikbaar) Then
                        returneddata.ImportRow(dr)
                    End If

                End If

            Next autonummer

            Return returneddata

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetKleurenByCategorie(ByVal categorieID As Integer) As String()
        Try
            Return _autodal.GetKleurenByCategorieID(categorieID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function


    Public Function getAutoIDByKenteken(ByVal autoKenteken As String) As Integer
        Try
            Return _autodal.getAutoIDByKenteken(autoKenteken)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class
