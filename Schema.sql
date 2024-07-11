CREATE TABLE Book (
    ID INT IDENTITY PRIMARY KEY,
    ISBN VARCHAR(50) NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Edition NVARCHAR(50),
    CategoryID INT,
    Price DECIMAL(10, 2),
    PublisherID INT,
    PublishDate DATE,
    FOREIGN KEY (CategoryID) REFERENCES Category(ID),
    FOREIGN KEY (PublisherID) REFERENCES Publisher(ID)
);

CREATE TABLE Category (
    ID INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL
);

CREATE TABLE Author (
    ID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Family NVARCHAR(100) NOT NULL
);

CREATE TABLE Translator (
    ID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Family NVARCHAR(100) NOT NULL
);

CREATE TABLE Reader (
    ID INT IDENTITY PRIMARY KEY,
    Email NVARCHAR(255) NOT NULL,
    Address NVARCHAR(255),
    PhoneNo NVARCHAR(20),
    Name NVARCHAR(100) NOT NULL,
    Family NVARCHAR(100) NOT NULL
);

CREATE TABLE Publisher (
    ID INT IDENTITY PRIMARY KEY,
    RegisterDate DATE NOT NULL,
    Name NVARCHAR(100) NOT NULL
);

CREATE TABLE AuthenticationSystem (
    ID INT IDENTITY PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL,
    Password NVARCHAR(100) NOT NULL,
    ReaderID INT,
    FOREIGN KEY (ReaderID) REFERENCES Reader(ID)
);

CREATE TABLE Reports (
    ID INT IDENTITY PRIMARY KEY,
    ReaderID INT,
    BookID INT,
    ReserveDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (ReaderID) REFERENCES Reader(ID),
    FOREIGN KEY (BookID) REFERENCES Book(ID)
);

CREATE TABLE BookAuthor (
    BookID INT,
    AuthorID INT,
    PRIMARY KEY (BookID, AuthorID),
    FOREIGN KEY (BookID) REFERENCES Book(ID),
    FOREIGN KEY (AuthorID) REFERENCES Author(ID)
);

CREATE TABLE BookTranslator (
    BookID INT,
    TranslatorID INT,
    PRIMARY KEY (BookID, TranslatorID),
    FOREIGN KEY (BookID) REFERENCES Book(ID),
    FOREIGN KEY (TranslatorID) REFERENCES Translator(ID)
);

CREATE TABLE BookInfo (
    BookID INT PRIMARY KEY,
    Authors NVARCHAR(MAX)
);