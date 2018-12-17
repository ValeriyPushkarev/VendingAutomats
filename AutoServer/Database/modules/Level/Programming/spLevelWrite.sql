CREATE PROCEDURE modules.spLevelWrite
	@items LevelDataType READONLY
AS
 SET NOCOUNT ON

    INSERT INTO modules.Levels 
	(
		ClientId
	   ,CreationDate
	   ,ModuleName
	   ,Level
	)
	SELECT 
	    ClientId     = cl.Id
	   ,CreationDate = CreationDate
	   ,ModuleName   = ModuleName
	   ,Level        = [Level]
	FROM @items
		JOIN main.Clients cl on cl.Name = ClientName
		;
    GO


