
CREATE PROCEDURE [dbo].[Manual_GetArtikelByTag_Versie_Bedrijf_Taal] 
	@tag nvarchar(1000), @versie INT, @bedrijf INT, @taal INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--WORDT GEBRUIKT OM EEN ARTIKEL OP TE ZOEKEN DAT WE BINNENKRIJGEN BIJ DOORSTEEK
	SELECT * from tblArtikel where FK_versie = @versie AND FK_bedrijf = @bedrijf AND FK_TAAL = @taal AND tag LIKE @tag ORDER BY tag;
END



ALTER PROCEDURE [dbo].[Check_ArtikelsbyModule] 
	@Module NVarchar(1000)
AS

BEGIN
--DEZE STORED PROCEDURE GEBRUIKEN WE OM NA TE GAAN OF ER NOG ARTIKELS GEBRUIK MAKEN VAN DIE MODULE IN HUN TAG
-- ALS DEZE QUERY 1 OF MEERDERE ARTIKELS TERUGGEEFT MOGEN WE DAN DIE MODULE NATUURLIJK NIET VERWIJDEREN

    SET NOCOUNT ON;
	SELECT * from tblArtikel where dbo.getModule(tag)=@Module
END

CREATE PROCEDURE [dbo].[Manual_GetCategorieByParentTaalVersieBedrijfNotByHoogte]
	@FK_Parent int,
	@FK_Taal INT,
	@FK_Versie INT,
	@FK_Bedrijf INT
AS
BEGIN
	
	SET NOCOUNT ON;
--HAAL EEN CATEGORIE OP, OP BASIS VAN TAAL,BEDRIJF,VERSIE EN DE PARENT
    select * from tblCategorie where FK_Parent=@FK_Parent AND FK_TAAL = @FK_TAAL AND FK_Versie = @FK_Versie AND FK_Bedrijf = @FK_Bedrijf AND Categorie != 'root_node' ORDER BY Categorie
END




CREATE PROCEDURE [dbo].[Manual_GetArtikelKeysByParent]
	@categorieID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAALT ALLE ARTIKELS ONDER EEN BEPAALDE CATEGORIE OP
	SELECT artikelID, Titel, FK_Taal, FK_Versie, FK_Bedrijf FROM tblArtikel WHERE FK_categorie = @categorieID ORDER BY Titel;
END