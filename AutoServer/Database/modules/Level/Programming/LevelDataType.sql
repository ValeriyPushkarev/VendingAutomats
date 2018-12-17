
CREATE TYPE modules.LevelDataType AS TABLE
(
	ClientName		NVARCHAR(MAX),
    CreationDate	DATETIME,
	ModuleName		NVARCHAR(MAX),
	[Level]			FLOAT 
)
