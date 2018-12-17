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
:setvar DefaultDataPath "c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\"
:setvar DefaultLogPath "c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\"

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
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Выполняется удаление [main].[FK_ClientProperties_ClientId]...';


GO
ALTER TABLE [main].[ClientProperties] DROP CONSTRAINT [FK_ClientProperties_ClientId];


GO
PRINT N'Выполняется запуск перестройки таблицы [Main].[ClientProperties]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [Main].[tmp_ms_xx_ClientProperties] (
    [Id]       INT            IDENTITY (1, 1) NOT NULL,
    [ClientId] INT            NOT NULL,
    [Desc]     NVARCHAR (MAX) NOT NULL,
    [Position] NVARCHAR (MAX) NOT NULL,
    [Address]  NVARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [main].[ClientProperties])
    BEGIN
        SET IDENTITY_INSERT [Main].[tmp_ms_xx_ClientProperties] ON;
        INSERT INTO [Main].[tmp_ms_xx_ClientProperties] ([Id], [ClientId], [Desc], [Position], [Address])
        SELECT   [Id],
                 [ClientId],
                 [Desc],
                 [Position],
                 [Address]
        FROM     [main].[ClientProperties]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [Main].[tmp_ms_xx_ClientProperties] OFF;
    END

DROP TABLE [main].[ClientProperties];

EXECUTE sp_rename N'[Main].[tmp_ms_xx_ClientProperties]', N'ClientProperties';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Выполняется создание [Main].[FK_ClientProperties_ClientId]...';


GO
ALTER TABLE [Main].[ClientProperties] WITH NOCHECK
    ADD CONSTRAINT [FK_ClientProperties_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [main].[Clients] ([Id]);


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
PRINT N'Выполняется обновление [Main].[UpdateClientProperties]...';


GO
EXECUTE sp_refreshsqlmodule N'[Main].[UpdateClientProperties]';


GO
PRINT N'Существующие данные проверяются относительно вновь созданных ограничений';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [Main].[ClientProperties] WITH CHECK CHECK CONSTRAINT [FK_ClientProperties_ClientId];


GO
PRINT N'Обновление завершено.';


GO
