Imports Manual

Partial Class App_Presentation_MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Trees opbouwen
        Dim dblink As DatabaseLink = DatabaseLink.GetInstance

        Dim dbcategorie As CategorieDAL = dblink.GetCategorieFuncties
        Dim dbtaal As TaalDAL = dblink.GetTaalFuncties
        Dim dbbedrijf As BedrijfDAL = dblink.GetBedrijfFuncties
        Dim dbversie As VersieDAL = dblink.GetVersieFuncties

        dbversie.GetAllVersie()

        'Alle talen ophalen
        Dim taaldt As tblTaalDataTable = dbtaal.GetAllTaal
        Dim bedrijfdt As tblBedrijfDataTable = dbbedrijf.GetAllBedrijf
        Dim versiedt As tblVersieDataTable = dbversie.GetAllVersie
        Dim categoriedt As tblCategorieDataTable

        For Each taal As tblTaalRow In taaldt
            For Each bedrijf As tblBedrijfRow In bedrijfdt
                For Each versie As tblVersieRow In versiedt

                    categoriedt = dbcategorie.GetAllCategorieBy(taal.TaalID, bedrijf.BedrijfID, versie.VersieID)

                    Dim tree As New Tree( 
                    For Each categorie As tblCategorieRow In categoriedt

                    Next categorie

                Next versie
            Next bedrijf
        Next taal






    End Sub
End Class

