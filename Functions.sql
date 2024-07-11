CREATE FUNCTION GetAuthorsByBookID(
    @bookID INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @authors VARCHAR(MAX);
    
    SELECT @authors = STRING_AGG(CONCAT(Name, ' ', Family), ', ')
    FROM Author
    INNER JOIN BookAuthor ON Author.ID = BookAuthor.AuthorID
    WHERE BookAuthor.BookID = @bookID;

    RETURN @authors;
END;

CREATE FUNCTION GetTranslatorsByBookID(
    @bookID INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @translators VARCHAR(MAX);
    
    SELECT @translators = STRING_AGG(CONCAT(Name, ' ', Family), ', ')
    FROM Translator
    JOIN BookTranslator ON Translator.ID = BookTranslator.TranslatorID
    WHERE BookTranslator.BookID = @BookID;

    RETURN @translators;
END;

CREATE FUNCTION NumberOfBookReaders(
    @bookID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @readerCount INT;
    
    SELECT @readerCount = COUNT(DISTINCT ReaderID)
    FROM Reports WHERE BookID = @bookID;

    RETURN @readerCount;
END;

CREATE FUNCTION NumberOfReaderBooks(
	@readerID INT
)
RETURNS INT
AS
BEGIN
	DECLARE @bookCount INT
	
	SELECT @bookCount = COUNT(DISTINCT BookID)
	FROM Reports WHERE ReaderID = @readerID;
	
	RETURN @bookCount;
END;

CREATE FUNCTION GetBookList(
	@readerID INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT Book.Title, Reports.ReserveDate, Reports.DueDate, Reports.ReturnDate
	FROM Book JOIN Reports ON Book.ID = Reports.BookID
	WHERE ReaderID = @readerID
);

CREATE FUNCTION GetMostPopularCategory()
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1
        c.Title AS CategoryTitle,
        COUNT(DISTINCT r.ReaderID) AS ReaderCount
    FROM Reports r JOIN Book b ON r.BookID = b.ID
    JOIN Category c ON b.CategoryID = c.ID
    GROUP BY c.Title ORDER BY ReaderCount DESC
);

CREATE FUNCTION GetBooksByPublisherAndDateRange (
    @PublisherID INT,
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT Book.ID AS BookID, Book.Title AS BookTitle, Book.PublishDate
    FROM Book WHERE Book.PublisherID = @PublisherID
    AND Book.PublishDate BETWEEN @StartDate AND @EndDate
);