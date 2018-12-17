CREATE TABLE modules.Levels
(
	[Id]			INT				NOT NULL PRIMARY KEY IDENTITY(1, 1), 
    [ClientId]		INT				NOT NULL, 
    [CreationDate]	DATETIME		NOT NULL, 
    [ModuleName]	NVARCHAR(MAX)	NOT NULL, 
    [Level]			FLOAT			NOT NULL
	CONSTRAINT [FK_Levels_ClientId] FOREIGN KEY (ClientId) REFERENCES main.Clients(Id)
)
GO

CREATE NONCLUSTERED INDEX idx_Levels_ClientId ON modules.Levels (ClientId)
GO

CREATE NONCLUSTERED INDEX idx_Levels_CreationDate ON modules.Levels (CreationDate)
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Имя модуля',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'Levels',
    @level2type = N'COLUMN',
    @level2name = N'ModuleName'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Дата измерения',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'Levels',
    @level2type = N'COLUMN',
    @level2name = 'CreationDate'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Id клиента',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'Levels',
    @level2type = N'COLUMN',
    @level2name = N'ClientId'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Измеренное значение',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'Levels',
    @level2type = N'COLUMN',
    @level2name = N'Level'