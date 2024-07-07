CREATE PROCEDURE InsertBook
    @BookTitle NVARCHAR(255),
    @ISBN VARCHAR(50),
    @CategoryTitle NVARCHAR(100),
    @AuthorName NVARCHAR(100),
    @AuthorFamily NVARCHAR(100),
    @TranslatorName NVARCHAR(100) = NULL,
    @TranslatorFamily NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CategoryID INT;
    DECLARE @AuthorID INT;
    DECLARE @TranslatorID INT;

    SELECT @CategoryID = ID
    FROM Category
    WHERE Title = @CategoryTitle;

    IF @CategoryID IS NULL
    BEGIN
        INSERT INTO Category (Title)
        VALUES (@CategoryTitle);

        SET @CategoryID = SCOPE_IDENTITY();
    END;

    SELECT @AuthorID = ID
    FROM Author
    WHERE Name = @AuthorName AND Family = @AuthorFamily;

    IF @AuthorID IS NULL
    BEGIN
        INSERT INTO Author (Name, Family)
        VALUES (@AuthorName, @AuthorFamily);

        SET @AuthorID = SCOPE_IDENTITY();
    END;

    IF @TranslatorName IS NOT NULL AND @TranslatorFamily IS NOT NULL
    BEGIN
        SELECT @TranslatorID = ID
        FROM Translator
        WHERE Name = @TranslatorName AND Family = @TranslatorFamily;

        IF @TranslatorID IS NULL
        BEGIN
            INSERT INTO Translator (Name, Family)
            VALUES (@TranslatorName, @TranslatorFamily);

            SET @TranslatorID = SCOPE_IDENTITY();
        END;
    END;

    INSERT INTO Book (ISBN, Title, CategoryID)
    VALUES (@ISBN, @BookTitle, @CategoryID);

    DECLARE @BookID INT;
    SET @BookID = SCOPE_IDENTITY();

    INSERT INTO BookAuthor (BookID, AuthorID)
    VALUES (@BookID, @AuthorID);

    IF @TranslatorID IS NOT NULL
    BEGIN
        INSERT INTO BookTranslator (BookID, TranslatorID)
        VALUES (@BookID, @TranslatorID);
    END;
END;
GO

CREATE PROCEDURE DeleteBookByID
    @BookID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM BookAuthor
        WHERE BookID = @BookID;

        DELETE FROM BookTranslator
        WHERE BookID = @BookID;

        DELETE FROM Reports
        WHERE BookID = @BookID;

        DELETE FROM BookInfo
        WHERE BookID = @BookID;

        DELETE FROM Book
        WHERE ID = @BookID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

CREATE PROCEDURE AddAuthor
    @BookID INT,
    @AuthorName NVARCHAR(100),
    @AuthorFamily NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AuthorID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @AuthorID = ID
        FROM Author
        WHERE Name = @AuthorName AND Family = @AuthorFamily;

        IF @AuthorID IS NULL
        BEGIN
            INSERT INTO Author (Name, Family)
            VALUES (@AuthorName, @AuthorFamily);

            SET @AuthorID = SCOPE_IDENTITY();
        END;

        INSERT INTO BookAuthor (BookID, AuthorID)
        VALUES (@BookID, @AuthorID);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

CREATE PROCEDURE AddTranslator
    @BookID INT,
    @TranslatorName NVARCHAR(100),
    @TranslatorFamily NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TranslatorID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @TranslatorID = ID
        FROM Translator
        WHERE Name = @TranslatorName AND Family = @TranslatorFamily;

        IF @TranslatorID IS NULL
        BEGIN
            INSERT INTO Translator (Name, Family)
            VALUES (@TranslatorName, @TranslatorFamily);

            SET @TranslatorID = SCOPE_IDENTITY();
        END;

        INSERT INTO BookTranslator (BookID, TranslatorID)
        VALUES (@BookID, @TranslatorID);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO