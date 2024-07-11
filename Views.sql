CREATE VIEW BooksWithDetails AS
SELECT 
    b.Title AS BookTitle,
    dbo.GetAuthorsByBookID(b.ID) AS Authors,
    dbo.GetTranslatorsByBookID(b.ID) AS Translators,
    dbo.NumberOfBookReaders(b.ID) AS ReaderCount
FROM 
    Book b;
GO

CREATE VIEW BookCategoriesWithCount AS
SELECT 
    c.Title AS CategoryTitle,
    COUNT(b.ID) AS BookCount
FROM 
    Book b
INNER JOIN 
    Category c ON ‌b.CategoryID = c.ID
GROUP BY 
    c.Title;
GO

CREATE VIEW ReadersList AS
SELECT 
    r.Name + ' ' + r.Family AS ReaderName,
    r.Email,
    r.Address,
    COUNT(CASE WHEN rp.ReserveDate IS NOT NULL THEN 1 END) AS ReservedBookCount,
    COUNT(CASE WHEN rp.DueDate IS NOT NULL THEN 1 END) AS BorrowedBookCount,
    COUNT(CASE WHEN rp.ReturnDate IS NOT NULL THEN 1 END) AS ReturnedBookCount
FROM 
    Reader r
LEFT JOIN 
    Reports rp ON r.ID = rp.ReaderID
GROUP BY 
    r.Name,
    r.Family,
    r.Email,
    r.Address;
GO

CREATE VIEW PublishersList AS
SELECT 
    p.Name AS PublisherName,
    p.RegisterDate,
    COUNT(b.ID) AS BookCount
FROM 
    Publisher p
LEFT JOIN 
    Book b ON p.ID = b.PublisherID
GROUP BY 
    p.Name,
    p.RegisterDate;
GO