/*
Скрипт развертывания для Database

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Database"
:setvar DefaultFilePrefix "Database"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEX\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEX\MSSQL\DATA\"

GO
:on error exit
GO
/*
Проверьте режим SQLCMD и отключите выполнение скрипта, если режим SQLCMD не поддерживается.
Чтобы повторно включить скрипт после включения режима SQLCMD выполните следующую инструкцию:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Для успешного выполнения этого скрипта должен быть включен режим SQLCMD.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
Удаляется столбец [main].[Clients].[Desc], возможна потеря данных.
*/

PRINT N'Выполняется изменение [main].[Clients]...';


GO
ALTER TABLE [main].[Clients] DROP COLUMN [Desc];


GO
PRINT N'Выполняется создание [Main].[ClientProperties]...';


GO
CREATE TABLE [Main].[ClientProperties] (
    [Id]       INT            NOT NULL,
    [ClientId] INT            NOT NULL,
    [Desc]     NVARCHAR (MAX) NOT NULL,
    [Position] NVARCHAR (MAX) NOT NULL,
    [Address]  NVARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [modules].[LevelModules]...';


GO
CREATE TABLE [modules].[LevelModules] (
    [Id]                 INT            NOT NULL,
    [ClientId]           INT            NOT NULL,
    [ModuleName]         NVARCHAR (MAX) NOT NULL,
    [FirstAlertEnabled]  BIT            NOT NULL,
    [FirstAlertLevel]    FLOAT (53)     NOT NULL,
    [SecondAlertEnabled] BIT            NOT NULL,
    [SecondAlertLevel]   FLOAT (53)     NOT NULL,
    [MaxLevel]           FLOAT (53)     NOT NULL,
    [MinLevel]           FLOAT (53)     NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание Ограничение по умолчанию в [modules].[LevelModules]....';


GO
ALTER TABLE [modules].[LevelModules]
    ADD DEFAULT (0) FOR [FirstAlertEnabled];


GO
PRINT N'Выполняется создание Ограничение по умолчанию в [modules].[LevelModules]....';


GO
ALTER TABLE [modules].[LevelModules]
    ADD DEFAULT (0) FOR [SecondAlertEnabled];


GO
PRINT N'Выполняется создание FK_ClientProperties_ClientId...';


GO
ALTER TABLE [Main].[ClientProperties] WITH NOCHECK
    ADD CONSTRAINT [FK_ClientProperties_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [main].[Clients] ([Id]);


GO
PRINT N'Выполняется создание FK_LevelModules_ClientId...';


GO
ALTER TABLE [modules].[LevelModules] WITH NOCHECK
    ADD CONSTRAINT [FK_LevelModules_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [main].[Clients] ([Id]);


GO
PRINT N'Выполняется создание FK_Levels_ClientId...';


GO
ALTER TABLE [modules].[Levels] WITH NOCHECK
    ADD CONSTRAINT [FK_Levels_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [main].[Clients] ([Id]);


GO
PRINT N'Выполняется создание [Main].[UpdateClientProperties]...';


GO
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
GO
PRINT N'Выполняется создание [Main].[ClientProperties].[ClientId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id клиента', @level0type = N'SCHEMA', @level0name = N'main', @level1type = N'TABLE', @level1name = N'ClientProperties', @level2type = N'COLUMN', @level2name = N'ClientId';


GO
PRINT N'Выполняется создание [Main].[ClientProperties].[Desc].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Описание клиента', @level0type = N'SCHEMA', @level0name = N'main', @level1type = N'TABLE', @level1name = N'ClientProperties', @level2type = N'COLUMN', @level2name = N'Desc';


GO
PRINT N'Выполняется создание [Main].[ClientProperties].[Position].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Позиция на карте', @level0type = N'SCHEMA', @level0name = N'main', @level1type = N'TABLE', @level1name = N'ClientProperties', @level2type = N'COLUMN', @level2name = N'Position';


GO
PRINT N'Выполняется создание [Main].[ClientProperties].[Address].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Адрес клиента', @level0type = N'SCHEMA', @level0name = N'main', @level1type = N'TABLE', @level1name = N'ClientProperties', @level2type = N'COLUMN', @level2name = N'Address';


GO
PRINT N'Выполняется создание [main].[Clients].[Name].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя', @level0type = N'SCHEMA', @level0name = N'main', @level1type = N'TABLE', @level1name = N'Clients', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'Выполняется создание [main].[Clients].[Password].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Пароль', @level0type = N'SCHEMA', @level0name = N'main', @level1type = N'TABLE', @level1name = N'Clients', @level2type = N'COLUMN', @level2name = N'Password';


GO
PRINT N'Выполняется создание [modules].[LevelModules].[ClientId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id Клиента', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'LevelModules', @level2type = N'COLUMN', @level2name = N'ClientId';


GO
PRINT N'Выполняется создание [modules].[LevelModules].[ModuleName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя модуля', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'LevelModules', @level2type = N'COLUMN', @level2name = N'ModuleName';


GO
PRINT N'Выполняется создание [modules].[LevelModules].[FirstAlertEnabled].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Первое предупреждение запрещено', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'LevelModules', @level2type = N'COLUMN', @level2name = N'FirstAlertEnabled';


GO
PRINT N'Выполняется создание [modules].[LevelModules].[FirstAlertLevel].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уровень первого предупреждения', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'LevelModules', @level2type = N'COLUMN', @level2name = N'FirstAlertLevel';


GO
PRINT N'Выполняется создание [modules].[LevelModules].[SecondAlertEnabled].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Второе предупреждение запрещено', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'LevelModules', @level2type = N'COLUMN', @level2name = N'SecondAlertEnabled';


GO
PRINT N'Выполняется создание [modules].[LevelModules].[SecondAlertLevel].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уровень второго предупреждения', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'LevelModules', @level2type = N'COLUMN', @level2name = N'SecondAlertLevel';


GO
PRINT N'Выполняется создание [modules].[LevelModules].[MaxLevel].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Максимальный уровень', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'LevelModules', @level2type = N'COLUMN', @level2name = N'MaxLevel';


GO
PRINT N'Выполняется создание [modules].[LevelModules].[MinLevel].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Минимальный уровень', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'LevelModules', @level2type = N'COLUMN', @level2name = N'MinLevel';


GO
PRINT N'Выполняется обновление [modules].[spLevelWrite]...';


GO
EXECUTE sp_refreshsqlmodule N'modules.spLevelWrite';


GO
PRINT N'Выполняется обновление [modules].[spPingWrite]...';


GO
EXECUTE sp_refreshsqlmodule N'modules.spPingWrite';


GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '000eec49-8384-4e47-ba5e-dfd530e4e32b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('000eec49-8384-4e47-ba5e-dfd530e4e32b')

GO

GO
PRINT N'Существующие данные проверяются относительно вновь созданных ограничений';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [Main].[ClientProperties] WITH CHECK CHECK CONSTRAINT [FK_ClientProperties_ClientId];

ALTER TABLE [modules].[LevelModules] WITH CHECK CHECK CONSTRAINT [FK_LevelModules_ClientId];

ALTER TABLE [modules].[Levels] WITH CHECK CHECK CONSTRAINT [FK_Levels_ClientId];


GO
PRINT N'Обновление завершено.'
GO
