USE [Reference_manual]
GO
/****** Object:  StoredProcedure [dbo].[Check_Categorie]    Script Date: 03/25/2010 09:50:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Manual_InsertVersie] 
	@versie VARCHAR(50)
AS
BEGIN
	
	INSERT INTO tblVersie(Versie)
	VALUES( @versie);

	SELECT SCOPE_IDENTITY();

END
