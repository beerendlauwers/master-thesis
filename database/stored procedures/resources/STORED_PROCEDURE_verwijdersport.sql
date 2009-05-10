CREATE PROCEDURE STORED_PROCEDURE_verwijdersport
	@tempSportID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM tblSport WHERE @tempSportID = SportID
END