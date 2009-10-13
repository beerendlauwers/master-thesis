CREATE PROCEDURE STORED_PROCEDURE_nieuwniveau 
	@tempNiveau VARCHAR(50), @tempNiveauID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO tblNiveau(Niveau) VALUES(@tempNiveau)
	SELECT @@IDENTITY AS [@@IDENTITY]
	SET @tempNiveauID = @@IDENTITY
END