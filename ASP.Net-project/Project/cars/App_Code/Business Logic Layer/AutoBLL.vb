Imports Microsoft.VisualBasic

Public Class AutoBLL
    Private _adapterAuto As New Auto_sTableAdapters.tblAutoTableAdapter
    Private _adapterBrandstofType As New Auto_sTableAdapters.tblBrandstofTableAdapter
    Private _adapterAutoStatus As New Auto_sTableAdapters.tblAutostatusTableAdapter
    Private _adapterFiliaal As New Auto_sTableAdapters.tblFiliaalTableAdapter
    Private _adapterOptie As New Auto_sTableAdapters.tblOptieTableAdapter
    Private _adapterModel As New Auto_sTableAdapters.tblModelTableAdapter
    Private _adapterMerk As New Auto_sTableAdapters.tblMerkTableAdapter
    Private _adapterCategorie As New Auto_sTableAdapters.tblCategorieTableAdapter

    Public Function GetAllAutos() As Auto_s.tblAutoDataTable
        Try
            Return _adapterAuto.GetData()
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

    Public Function AddAuto(ByRef a As Auto) As Boolean
        Try
            If (_adapterAuto.Insert(a.Categorie, a.Model, a.Kleur, a.Bouwjaar, _
                                    a.Foto, a.Brandstoftype, a.Kenteken, a.Dagtarief, _
                                    a.KmTotOnderhoud, a.Status, a.Filiaal, _
                                    a.Parkeerplaats)) Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllBrandstofTypes() As Auto_s.tblBrandstofDataTable
        Try
            Return _adapterBrandstofType.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetBrandstofTypeByBrandstofID(ByVal brandstofID As Integer) As String
        Try

            Dim dt As Auto_s.tblBrandstofDataTable = _adapterBrandstofType.GetBrandstofTypeByBrandstofID(brandstofID)
            If (dt.Rows.Count = 0) Then
                Throw New Exception(String.Concat("Onbestaande brandstof met brandstofID: ", brandstofID))
            Else
                Return CType(dt.Rows(0), Auto_s.tblBrandstofRow).brandstofNaam
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllAutoStatus() As Auto_s.tblAutostatusDataTable
        Try
            Return _adapterAutoStatus.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAutostatusByAutostatusID(ByVal autostatusID As Integer) As String
        Try

            Dim dt As Auto_s.tblAutostatusDataTable = _adapterAutoStatus.GetAutostatusByAutostatusID(autostatusID)
            If (dt.Rows.Count = 0) Then
                Throw New Exception(String.Concat("Onbestaande status met autostatusID: ", autostatusID))
            Else
                Return CType(dt.Rows(0), Auto_s.tblAutostatusRow).autostatusNaam
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllFilialen() As Auto_s.tblFiliaalDataTable
        Try
            Return _adapterFiliaal.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetFiliaalByFiliaalID(ByVal filiaalID As Integer) As String
        Try

            Dim dt As Auto_s.tblFiliaalDataTable = _adapterFiliaal.GetFiliaalByFiliaalID(filiaalID)
            If (dt.Rows.Count = 0) Then
                Throw New Exception(String.Concat("Onbestaande filiaal met filiaalID: ", filiaalID))
            Else
                Return CType(dt.Rows(0), Auto_s.tblFiliaalRow).filiaalNaam
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllOpties() As Auto_s.tblOptieDataTable
        Try
            Return _adapterOptie.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllMerken() As Auto_s.tblMerkDataTable
        Try
            Return _adapterMerk.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllModels() As Auto_s.tblModelDataTable
        Try
            Return _adapterModel.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetModelsByMerk(ByVal MerkID As Integer) As Auto_s.tblModelDataTable
        Try
            Return _adapterModel.GetAllModelsByMerk(MerkID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetAllCategorien() As Auto_s.tblCategorieDataTable
        Try
            Return _adapterCategorie.GetData()
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetCategorieByCategorieID(ByVal categorieID As Integer) As String
        Try

            Dim dt As Auto_s.tblCategorieDataTable = _adapterCategorie.GetCategorieByCategorieID(categorieID)
            If (dt.Rows.Count = 0) Then
                Throw New Exception(String.Concat("Onbestaande categorie met categorieID: ", categorieID))
            Else
                Return CType(dt.Rows(0), Auto_s.tblCategorieRow).categorieNaam
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetBeschikbareAutosBy(ByVal categorieID As Integer, ByVal gewensteBegindatum As Date, ByVal gewensteEinddatum As Date, Optional ByVal kleur As String = "") As Auto_s.tblAutoDataTable
        Try

            If (kleur = "") Then
                kleur = String.Empty
            End If
            'Alle auto's van een bepaalde categorie opvragen.
            Dim autodata As Auto_s.tblAutoDataTable = _adapterAuto.GetAllAutosBy(categorieID)

            'Auto-variabelen.
            Dim returneddata As New Auto_s.tblAutoDataTable
            Dim dr As Auto_s.tblAutoRow
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
                reservatiedata = reservatiebll.GetAllReservatiesBy(autoID)

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

    Public Function GetModelNameByModelID(ByVal modelID As Integer) As String
        Try

            Dim dt As Auto_s.tblModelDataTable = _adapterModel.GetModelNameByModelID(modelID)
            If (dt.Rows.Count = 0) Then
                Throw New Exception(String.Concat("Onbestaand model met modelID: ", modelID))
            Else
                Return CType(dt.Rows(0), Auto_s.tblModelRow).modelNaam
            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Function GetKleurenByCategorie(ByVal categorieID As Integer) As String()
        Try
            Dim autodal As New AutoDAL
            Return autodal.GetKleurenByCategorieID(categorieID)
        Catch ex As Exception
            Throw ex
        End Try
    End Function


End Class
