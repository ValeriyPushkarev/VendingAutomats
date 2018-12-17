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
PRINT N'Выполняется удаление DF__LevelModu__First__38996AB5...';


GO
ALTER TABLE [modules].[LevelModules] DROP CONSTRAINT [DF__LevelModu__First__38996AB5];


GO
PRINT N'Выполняется удаление DF__LevelModu__Secon__398D8EEE...';


GO
ALTER TABLE [modules].[LevelModules] DROP CONSTRAINT [DF__LevelModu__Secon__398D8EEE];


GO
PRINT N'Выполняется удаление FK_LevelModules_ClientId...';


GO
ALTER TABLE [modules].[LevelModules] DROP CONSTRAINT [FK_LevelModules_ClientId];


GO
PRINT N'Выполняется запуск перестройки таблицы [modules].[LevelModules]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [modules].[tmp_ms_xx_LevelModules] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [ClientId]           INT            NOT NULL,
    [ModuleName]         NVARCHAR (MAX) NOT NULL,
    [FirstAlertEnabled]  BIT            DEFAULT (0) NOT NULL,
    [FirstAlertLevel]    FLOAT (53)     NOT NULL,
    [SecondAlertEnabled] BIT            DEFAULT (0) NOT NULL,
    [SecondAlertLevel]   FLOAT (53)     NOT NULL,
    [MaxLevel]           FLOAT (53)     NOT NULL,
    [MinLevel]           FLOAT (53)     NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [modules].[LevelModules])
    BEGIN
        SET IDENTITY_INSERT [modules].[tmp_ms_xx_LevelModules] ON;
        INSERT INTO [modules].[tmp_ms_xx_LevelModules] ([Id], [ClientId], [ModuleName], [FirstAlertEnabled], [FirstAlertLevel], [SecondAlertEnabled], [SecondAlertLevel], [MaxLevel], [MinLevel])
        SELECT   [Id],
                 [ClientId],
                 [ModuleName],
                 [FirstAlertEnabled],
                 [FirstAlertLevel],
                 [SecondAlertEnabled],
                 [SecondAlertLevel],
                 [MaxLevel],
                 [MinLevel]
        FROM     [modules].[LevelModules]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [modules].[tmp_ms_xx_LevelModules] OFF;
    END

DROP TABLE [modules].[LevelModules];

EXECUTE sp_rename N'[modules].[tmp_ms_xx_LevelModules]', N'LevelModules';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Выполняется создание FK_LevelModules_ClientId...';


GO
ALTER TABLE [modules].[LevelModules] WITH NOCHECK
    ADD CONSTRAINT [FK_LevelModules_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [main].[Clients] ([Id]);


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
PRINT N'Существующие данные проверяются относительно вновь созданных ограничений';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [modules].[LevelModules] WITH CHECK CHECK CONSTRAINT [FK_LevelModules_ClientId];


GO
PRINT N'Обновление завершено.'
GO
