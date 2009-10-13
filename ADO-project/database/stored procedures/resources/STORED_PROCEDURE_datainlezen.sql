CREATE PROCEDURE STORED_PROCEDURE_datainlezen

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblDoetSport, tblNiveau, tblSport, tblStudent
END
