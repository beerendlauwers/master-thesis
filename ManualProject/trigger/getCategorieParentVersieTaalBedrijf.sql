SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Manual_getCategorieByParentVersieTaalBedrijf]
	@FK_Parent int,
	@FK_Taal INT,
	@FK_Versie INT,
	@FK_Bedrijf INT
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblCategorie where FK_Parent=@FK_Parent AND FK_TAAL = @FK_TAAL AND FK_Versie = @FK_Versie AND FK_Bedrijf = @FK_Bedrijf AND Categorie != 'root_node' ORDER BY Hoogte
END
