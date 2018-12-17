CREATE TABLE [main].Clients
(
    [Id]		INT				NOT NULL PRIMARY KEY IDENTITY(1,1), 
    [Name]		NVARCHAR(50)	NOT NULL, 
    [Password]	NVARCHAR(50)	NOT NULL
)
GO

CREATE NONCLUSTERED INDEX ix_Clients_Name ON [main].Clients (Name DESC)
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Имя',
    @level0type = N'SCHEMA',
    @level0name = N'main',
    @level1type = N'TABLE',
    @level1name = N'Clients',
    @level2type = N'COLUMN',
    @level2name = N'Name'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Пароль',
    @level0type = N'SCHEMA',
    @level0name = N'main',
    @level1type = N'TABLE',
    @level1name = N'Clients',
    @level2type = N'COLUMN',
    @level2name = N'Password'