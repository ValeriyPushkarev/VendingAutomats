CREATE TABLE [modules].[LevelModules]
(
	[Id]				INT				IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [ClientId]			INT				NOT NULL, 
    [ModuleName]		NVARCHAR(MAX)	NOT NULL, 
	FirstAlertEnabled	BIT				NOT NULL DEFAULT (0),
    [FirstAlertLevel]	FLOAT			NOT NULL, 
	SecondAlertEnabled	BIT				NOT NULL DEFAULT (0),
    [SecondAlertLevel]	FLOAT			NOT NULL, 
    [MaxLevel]			FLOAT			NOT NULL, 
    [MinLevel]			FLOAT			NOT NULL, 
    CONSTRAINT [FK_LevelModules_ClientId] FOREIGN KEY (ClientId) REFERENCES main.Clients(Id)
)
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Id Клиента',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'LevelModules',
    @level2type = N'COLUMN',
    @level2name = N'ClientId'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Имя модуля',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'LevelModules',
    @level2type = N'COLUMN',
    @level2name = N'ModuleName'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Первое предупреждение запрещено',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'LevelModules',
    @level2type = N'COLUMN',
    @level2name = N'FirstAlertEnabled'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Уровень первого предупреждения',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'LevelModules',
    @level2type = N'COLUMN',
    @level2name = N'FirstAlertLevel'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Второе предупреждение запрещено',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'LevelModules',
    @level2type = N'COLUMN',
    @level2name = N'SecondAlertEnabled'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Уровень второго предупреждения',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'LevelModules',
    @level2type = N'COLUMN',
    @level2name = N'SecondAlertLevel'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Максимальный уровень',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'LevelModules',
    @level2type = N'COLUMN',
    @level2name = N'MaxLevel'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Минимальный уровень',
    @level0type = N'SCHEMA',
    @level0name = N'modules',
    @level1type = N'TABLE',
    @level1name = N'LevelModules',
    @level2type = N'COLUMN',
    @level2name = N'MinLevel'