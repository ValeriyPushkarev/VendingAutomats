CREATE TABLE Main.[ClientProperties]
(
	[Id]		INT IDENTITY(1,1)	NOT NULL PRIMARY KEY,
	ClientId	INT					NOT NULL, 
    [Desc]		NVARCHAR(MAX)		NOT NULL, 
    [Position]	NVARCHAR(MAX)		NOT NULL,
    [Address] NVARCHAR(MAX)			NOT NULL, 
    CONSTRAINT [FK_ClientProperties_ClientId] FOREIGN KEY (ClientId) REFERENCES main.Clients(Id)
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Id клиента',
    @level0type = N'SCHEMA',
    @level0name = N'Main',
    @level1type = N'TABLE',
    @level1name = N'ClientProperties',
    @level2type = N'COLUMN',
    @level2name = N'ClientId'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Описание клиента',
    @level0type = N'SCHEMA',
    @level0name = N'Main',
    @level1type = N'TABLE',
    @level1name = N'ClientProperties',
    @level2type = N'COLUMN',
    @level2name = N'Desc'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Позиция на карте',
    @level0type = N'SCHEMA',
    @level0name = N'Main',
    @level1type = N'TABLE',
    @level1name = N'ClientProperties',
    @level2type = N'COLUMN',
    @level2name = N'Position'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Адрес клиента',
    @level0type = N'SCHEMA',
    @level0name = N'Main',
    @level1type = N'TABLE',
    @level1name = N'ClientProperties',
    @level2type = N'COLUMN',
    @level2name = N'Address'