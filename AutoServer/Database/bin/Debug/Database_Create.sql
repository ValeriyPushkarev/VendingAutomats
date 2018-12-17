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
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Выполняется создание $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)] COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Параметры базы данных изменить нельзя. Применить эти параметры может только пользователь SysAdmin.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Параметры базы данных изменить нельзя. Применить эти параметры может только пользователь SysAdmin.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Выполняется создание [modules]...';


GO
CREATE SCHEMA [modules]
    AUTHORIZATION [dbo];


GO
PRINT N'Выполняется создание [main]...';


GO
CREATE SCHEMA [main]
    AUTHORIZATION [dbo];


GO
PRINT N'Выполняется создание [modules].[PingDataType]...';


GO
CREATE TYPE [modules].[PingDataType] AS TABLE (
    [ClientName] NVARCHAR (MAX) NULL,
    [ChangeDate] DATETIME       NULL);


GO
PRINT N'Выполняется создание [modules].[LevelDataType]...';


GO
CREATE TYPE [modules].[LevelDataType] AS TABLE (
    [ClientName]   NVARCHAR (MAX) NULL,
    [CreationDate] DATETIME       NULL,
    [ModuleName]   NVARCHAR (MAX) NULL,
    [Level]        FLOAT (53)     NULL);


GO
PRINT N'Выполняется создание [modules].[LevelModules]...';


GO
CREATE TABLE [modules].[LevelModules] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
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
PRINT N'Выполняется создание [modules].[Levels]...';


GO
CREATE TABLE [modules].[Levels] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [ClientId]     INT            NOT NULL,
    [CreationDate] DATETIME       NOT NULL,
    [ModuleName]   NVARCHAR (MAX) NOT NULL,
    [Level]        FLOAT (53)     NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [modules].[Levels].[idx_Levels_ClientId]...';


GO
CREATE NONCLUSTERED INDEX [idx_Levels_ClientId]
    ON [modules].[Levels]([ClientId] ASC);


GO
PRINT N'Выполняется создание [modules].[Levels].[idx_Levels_CreationDate]...';


GO
CREATE NONCLUSTERED INDEX [idx_Levels_CreationDate]
    ON [modules].[Levels]([CreationDate] ASC);


GO
PRINT N'Выполняется создание [modules].[Ping]...';


GO
CREATE TABLE [modules].[Ping] (
    [Id]       INT      IDENTITY (1, 1) NOT NULL,
    [ClientId] INT      NOT NULL,
    [LastPing] DATETIME NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [modules].[Ping].[idx_Ping_ClientId]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_Ping_ClientId]
    ON [modules].[Ping]([ClientId] ASC);


GO
PRINT N'Выполняется создание [main].[Clients]...';


GO
CREATE TABLE [main].[Clients] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [Name]     NVARCHAR (50) NOT NULL,
    [Password] NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание [main].[Clients].[ix_Clients_Name]...';


GO
CREATE NONCLUSTERED INDEX [ix_Clients_Name]
    ON [main].[Clients]([Name] DESC);


GO
PRINT N'Выполняется создание [Main].[ClientProperties]...';


GO
CREATE TABLE [Main].[ClientProperties] (
    [Id]       INT            IDENTITY (1, 1) NOT NULL,
    [ClientId] INT            NOT NULL,
    [Desc]     NVARCHAR (MAX) NOT NULL,
    [Position] NVARCHAR (MAX) NOT NULL,
    [Address]  NVARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Выполняется создание ограничение без названия для [modules].[LevelModules]...';


GO
ALTER TABLE [modules].[LevelModules]
    ADD DEFAULT (0) FOR [FirstAlertEnabled];


GO
PRINT N'Выполняется создание ограничение без названия для [modules].[LevelModules]...';


GO
ALTER TABLE [modules].[LevelModules]
    ADD DEFAULT (0) FOR [SecondAlertEnabled];


GO
PRINT N'Выполняется создание [modules].[FK_LevelModules_ClientId]...';


GO
ALTER TABLE [modules].[LevelModules]
    ADD CONSTRAINT [FK_LevelModules_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [main].[Clients] ([Id]);


GO
PRINT N'Выполняется создание [modules].[FK_Levels_ClientId]...';


GO
ALTER TABLE [modules].[Levels]
    ADD CONSTRAINT [FK_Levels_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [main].[Clients] ([Id]);


GO
PRINT N'Выполняется создание [Main].[FK_ClientProperties_ClientId]...';


GO
ALTER TABLE [Main].[ClientProperties]
    ADD CONSTRAINT [FK_ClientProperties_ClientId] FOREIGN KEY ([ClientId]) REFERENCES [main].[Clients] ([Id]);


GO
PRINT N'Выполняется создание [modules].[spGetLevels]...';


GO
CREATE PROCEDURE modules.spGetLevels
     @DateFrom		DATETIME
    ,@DateTo		DATETIME
	,@Resolution	INT      = 100
	,@ModuleName	NVARCHAR(MAX)
	,@ClientId		INT
AS
BEGIN
	SET NOCOUNT ON

	DECLARE 	@Count		BIGINT

	SELECT @Count = COUNT(*)/@Resolution
	FROM modules.Levels l (NOLOCK)
	WHERE l.ModuleName = @ModuleName
	  AND l.CreationDate BETWEEN @DateFrom AND @DateTo
	  AND l.ClientId = @ClientId

	SELECT t.CreationDate, t.Level
	FROM
	(
		SELECT l.CreationDate, l.Level, rowNum = ROW_NUMBER() OVER (ORDER BY l.Id DESC)
		FROM modules.Levels l (NOLOCK)
		WHERE l.ModuleName = @ModuleName
		  AND l.CreationDate BETWEEN @DateFrom AND @DateTo
		  AND l.ClientId = @ClientId
	) t
	WHERE t.rowNum % @Count =0
END
GO
PRINT N'Выполняется создание [modules].[spLevelWrite]...';


GO
CREATE PROCEDURE modules.spLevelWrite
	@items LevelDataType READONLY
AS
 SET NOCOUNT ON

    INSERT INTO modules.Levels 
	(
		ClientId
	   ,CreationDate
	   ,ModuleName
	   ,Level
	)
	SELECT 
	    ClientId     = cl.Id
	   ,CreationDate = CreationDate
	   ,ModuleName   = ModuleName
	   ,Level        = [Level]
	FROM @items
		JOIN main.Clients cl on cl.Name = ClientName
		;
GO
PRINT N'Выполняется создание [modules].[spPingWrite]...';


GO
CREATE PROCEDURE modules.spPingWrite
	@items PingDataType READONLY
AS
 SET NOCOUNT ON

	MERGE modules.Ping AS trg
	USING 
	(

		SELECT 
			Id		   = cl.Id
		   ,ChangeDate = MAX(ChangeDate)
		FROM @items
			JOIN main.Clients cl on cl.Name = Name
		GROUP BY cl.id

	) AS src (Id, ChangeDate)
	ON trg.ClientId = src.Id

	WHEN MATCHED
		THEN UPDATE SET LastPing = ChangeDate

	WHEN NOT MATCHED BY TARGET
		THEN INSERT (ClientId, LastPing) VALUES (Id, ChangeDate)
	;
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
PRINT N'Выполняется создание [modules].[Levels].[ClientId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id клиента', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Levels', @level2type = N'COLUMN', @level2name = N'ClientId';


GO
PRINT N'Выполняется создание [modules].[Levels].[CreationDate].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Дата измерения', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Levels', @level2type = N'COLUMN', @level2name = N'CreationDate';


GO
PRINT N'Выполняется создание [modules].[Levels].[ModuleName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя модуля', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Levels', @level2type = N'COLUMN', @level2name = N'ModuleName';


GO
PRINT N'Выполняется создание [modules].[Levels].[Level].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Измеренное значение', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Levels', @level2type = N'COLUMN', @level2name = N'Level';


GO
PRINT N'Выполняется создание [modules].[Ping].[ClientId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id клиента', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Ping', @level2type = N'COLUMN', @level2name = N'ClientId';


GO
PRINT N'Выполняется создание [modules].[Ping].[LastPing].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Дата и время последнего пинга', @level0type = N'SCHEMA', @level0name = N'modules', @level1type = N'TABLE', @level1name = N'Ping', @level2type = N'COLUMN', @level2name = N'LastPing';


GO
PRINT N'Выполняется создание [main].[Clients].[Name].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя', @level0type = N'SCHEMA', @level0name = N'main', @level1type = N'TABLE', @level1name = N'Clients', @level2type = N'COLUMN', @level2name = N'Name';


GO
PRINT N'Выполняется создание [main].[Clients].[Password].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Пароль', @level0type = N'SCHEMA', @level0name = N'main', @level1type = N'TABLE', @level1name = N'Clients', @level2type = N'COLUMN', @level2name = N'Password';


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
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '000eec49-8384-4e47-ba5e-dfd530e4e32b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('000eec49-8384-4e47-ba5e-dfd530e4e32b')

GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET MULTI_USER 
    WITH ROLLBACK IMMEDIATE;


GO
PRINT N'Обновление завершено.';


GO
