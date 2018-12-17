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
PRINT N'Выполняется создание [dbo].[LevelDataType]...';


GO
CREATE TYPE [dbo].[LevelDataType] AS TABLE (
    [ClientName]   NVARCHAR (MAX) NULL,
    [CreationDate] DATETIME       NULL,
    [ModuleName]   NVARCHAR (MAX) NULL,
    [Level]        FLOAT (53)     NULL);


GO
PRINT N'Выполняется изменение [modules].[spLevelWrite]...';


GO
ALTER PROCEDURE modules.spLevelWrite
	@items LevelDataType READONLY
AS
 SET NOCOUNT ON

    INSERT INTO modules.Levels 
	(
		ClientId
	   ,CreationDate
	   ,ModuleName
	   ,[Level]
	)
	SELECT 
	    ClientId     = cl.Id
	   ,CreationDate = i.CreationDate
	   ,ModuleName   = i,ModuleName
	   ,[Level]      = i.[Level]
	FROM @items i
		JOIN main.Clients cl on cl.Name = i.ClientName
GO
PRINT N'Обновление завершено.'
GO
