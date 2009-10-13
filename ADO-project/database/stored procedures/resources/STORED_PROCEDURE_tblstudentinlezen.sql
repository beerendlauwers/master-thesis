CREATE PROCEDURE STORED_PROCEDURE_tblstudentinlezen
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblStudent
END