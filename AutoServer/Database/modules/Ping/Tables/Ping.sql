CREATE TABLE modules.Ping
(
	[Id]	   INT		NOT NULL PRIMARY KEY IDENTITY(1, 1), 
    [ClientId] INT		NOT NULL, 
    [LastPing] DATETIME NOT NULL
)
GO

CREATE UNIQUE NONCLUSTERED INDEX idx_Ping_ClientId ON modules.Ping (ClientId)
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Id клиента',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'Ping',
    @level2type = N'COLUMN',
    @level2name = N'ClientId'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Дата и время последнего пинга',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'Ping',
    @level2type = N'COLUMN',
    @level2name = N'LastPing'