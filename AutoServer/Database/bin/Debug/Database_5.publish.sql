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
PRINT N'Операция рефакторинга Rename с помощью ключа ed195233-dcb2-4848-b126-4fa99097b153, a26f6d28-f50c-498e-b28a-b0eaece97691 пропущена, элемент [modules].[Distance].[LastPing] (SqlSimpleColumn) не будет переименован в CreationDate';


GO
PRINT N'Операция рефакторинга Rename с помощью ключа b669db94-e2ee-467b-a37b-c71a1d88cb84 пропущена, элемент [modules].[Level].[Value] (SqlSimpleColumn) не будет переименован в Level';


GO
PRINT N'Выполняется создание [modules].[spLevelWrite]...';


GO
CREATE PROCEDURE modules.spLevelWrite
	@Name nvarchar(50),
	@ModuleName nvarchar(MAX),
	@Date datetime,
	@Level FLOAT
AS
 SET NOCOUNT ON

    INSERT INTO modules.Levels (ClientId, CreationDate, ModuleName, Level)
	SELECT 
	    ClientId     = cl.Id
	   ,CreationDate = val.ChangeDate
	   ,ModuleName   = @ModuleName
	   ,Level        = @Level  
	FROM (VALUES (@Name, @Date)) AS val(Name, ChangeDate)
		JOIN main.Clients cl on cl.Name = val.Name
GO
PRINT N'Выполняется создание [modules].[Levels].[ClientId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id клиента', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Levels', @level2type = N'COLUMN', @level2name = N'ClientId';


GO
PRINT N'Выполняется создание [modules].[Levels].[CreationDate].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Дата измерения', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Levels', @level2type = N'COLUMN', @level2name = N'CreationDate';


GO
PRINT N'Выполняется создание [modules].[Levels].[Level].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Измеренное значение', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Levels', @level2type = N'COLUMN', @level2name = N'Level';


GO
PRINT N'Выполняется создание [modules].[Levels].[ModuleName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя модуля', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Levels', @level2type = N'COLUMN', @level2name = N'ModuleName';


GO
PRINT N'Выполняется создание [modules].[Ping].[ClientId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id клиента', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Ping', @level2type = N'COLUMN', @level2name = N'ClientId';


GO
PRINT N'Выполняется создание [modules].[Ping].[LastPing].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Дата и время последнего пинга', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Ping', @level2type = N'COLUMN', @level2name = N'LastPing';


GO
-- Выполняется этап рефакторинга для обновления развернутых журналов транзакций на целевом сервере

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ed195233-dcb2-4848-b126-4fa99097b153')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ed195233-dcb2-4848-b126-4fa99097b153')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a26f6d28-f50c-498e-b28a-b0eaece97691')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a26f6d28-f50c-498e-b28a-b0eaece97691')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b669db94-e2ee-467b-a37b-c71a1d88cb84')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b669db94-e2ee-467b-a37b-c71a1d88cb84')

GO

GO
PRINT N'Обновление завершено.'
GO
