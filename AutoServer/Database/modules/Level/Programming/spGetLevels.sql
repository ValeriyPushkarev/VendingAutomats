CREATE PROCEDURE modules.spGetLevels
     @DateFrom		DATETIME
    ,@DateTo		DATETIME
	,@Resolution	INT      = 100
	,@ModuleName	NVARCHAR(MAX)
	,@ClientId		INT
AS
BEGIN
	SET NOCOUNT ON

	DECLARE 	@Count		BIGINT

	SELECT @Count = COUNT(*)/@Resolution
	FROM modules.Levels l (NOLOCK)
	WHERE l.ModuleName = @ModuleName
	  AND l.CreationDate BETWEEN @DateFrom AND @DateTo
	  AND l.ClientId = @ClientId

	SELECT t.CreationDate, t.Level
	FROM
	(
		SELECT l.CreationDate, l.Level, rowNum = ROW_NUMBER() OVER (ORDER BY l.Id DESC)
		FROM modules.Levels l (NOLOCK)
		WHERE l.ModuleName = @ModuleName
		  AND l.CreationDate BETWEEN @DateFrom AND @DateTo
		  AND l.ClientId = @ClientId
	) t
	WHERE t.rowNum % @Count =0
END