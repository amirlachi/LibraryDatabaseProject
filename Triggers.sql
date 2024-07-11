CREATE TRIGGER PreventDeletePublisher
ON Publisher
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR ('Deleting records from the Publisher table is not allowed.', 16, 1);
    ROLLBACK TRANSACTION;
END;
GO

CREATE TRIGGER InsteadOfInsertReports
ON Reports
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Reports
    SET 
        ReserveDate = inserted.ReserveDate,
        DueDate = inserted.DueDate,
        ReturnDate = inserted.ReturnDate
    FROM 
        Reports
    INNER JOIN 
        inserted ON Reports.ReaderID = inserted.ReaderID AND Reports.BookID = inserted.BookID;

    INSERT INTO Reports (ReaderID, BookID, ReserveDate, DueDate, ReturnDate)
    SELECT 
        inserted.ReaderID,
        inserted.BookID,
        inserted.ReserveDate,
        inserted.DueDate,
        inserted.ReturnDate
    FROM 
        inserted
    LEFT JOIN 
        Reports ON Reports.ReaderID = inserted.ReaderID AND Reports.BookID = inserted.BookID
    WHERE 
        Reports.ReaderID IS NULL AND Reports.BookID IS NULL;
END;
GO

CREATE TABLE Book2 (
    ID INT PRIMARY KEY,
    ISBN VARCHAR(50),
    Title VARCHAR(255),
    Edition VARCHAR(50),
    CategoryID INT,
    Price DECIMAL(10, 2),
    PublisherID INT,
    PublishDate DATE
);

CREATE TRIGGER AfterDeleteBookOnEthics
ON Book
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Book2 (ID, ISBN, Title, Edition, CategoryID, Price, PublisherID, PublishDate)
    SELECT 
        deleted.ID, 
        deleted.ISBN, 
        deleted.Title, 
        deleted.Edition, 
        deleted.CategoryID, 
        deleted.Price, 
        deleted.PublisherID, 
        deleted.PublishDate
    FROM 
        deleted
    INNER JOIN 
        Category ON deleted.CategoryID = Category.ID
    WHERE 
        Category.Title = 'اخلاق';
END;
GO

CREATE TABLE BookInfo (
    BookID INT,
    Authors NVARCHAR(MAX),
    PRIMARY KEY (BookID)
);

CREATE TRIGGER AfterInsertAuthor
ON Author
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AuthorID INT;
    DECLARE @AuthorName NVARCHAR(MAX);

    SELECT @AuthorID = ID, @AuthorName = CONCAT(Name, ' ', Family)
    FROM inserted;

    IF EXISTS (
        SELECT 1
        FROM BookInfo
        WHERE BookID = @AuthorID
    )
    BEGIN
        UPDATE BookInfo
        SET Authors = CONCAT(Authors, ', ', @AuthorName)
        WHERE BookID = @AuthorID;
    END
    ELSE
    BEGIN
        INSERT INTO BookInfo (BookID, Authors)
        VALUES (@AuthorID, @AuthorName);
    END
END;
GO

