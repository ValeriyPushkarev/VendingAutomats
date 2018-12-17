CREATE PROCEDURE Main.[UpdateClientProperties]
	@Name		NVARCHAR(50),
	@Desc		NVARCHAR(MAX),
	@Position	NVARCHAR(MAX),
	@Address	NVARCHAR(MAX)
AS
BEGIN
	MERGE Main.ClientProperties AS trg
    USING 
	(
	
		SELECT @Desc, @Position,@Address, c.Id
		FROM Main.Clients c
		WHERE c.Name = @Name
		
	) AS src ([Desc], [Position], [Address], [ClientId])
    ON (trg.ClientId = src.ClientId)
    WHEN MATCHED THEN 
        UPDATE SET 
			 [Desc]     = src.[Desc]
		    ,[Position] = src.[Position]
			,[Address]  = src.[Address]
	WHEN NOT MATCHED THEN
		INSERT ([Desc], [Position],[Address],[ClientId])
		VALUES (src.[Desc], src.[Position], src.[Address], src.[ClientId])
	;
END

