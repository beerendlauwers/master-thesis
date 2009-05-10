CREATE PROCEDURE STORED_PROCEDURE_updatesport
	@tempSport VARCHAR(50), @tempSportID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE tblSport SET SportNaam = @tempSport WHERE SportID = @tempSportID
END
