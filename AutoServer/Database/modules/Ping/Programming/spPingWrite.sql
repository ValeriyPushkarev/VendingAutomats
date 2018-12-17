CREATE PROCEDURE modules.spPingWrite
	@items PingDataType READONLY
AS
 SET NOCOUNT ON

	MERGE modules.Ping AS trg
	USING 
	(

		SELECT 
			Id		   = cl.Id
		   ,ChangeDate = MAX(ChangeDate)
		FROM @items
			JOIN main.Clients cl on cl.Name = Name
		GROUP BY cl.id

	) AS src (Id, ChangeDate)
	ON trg.ClientId = src.Id

	WHEN MATCHED
		THEN UPDATE SET LastPing = ChangeDate

	WHEN NOT MATCHED BY TARGET
		THEN INSERT (ClientId, LastPing) VALUES (Id, ChangeDate)
	;
	GO


