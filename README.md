# Library Database Project

This project is a library management database built using SQL Server. It includes the schema, stored procedures, triggers, and sample data for managing books, authors, translators, readers, and publishers.

## Features

- Manage books, authors, and translators
- Track book borrowing and returning
- Prevent deletion of publishers
- Automatically handle duplicates in reports

## Files

- `Database/Schema.sql`: Contains the database schema (tables, columns, and relationships).
- `Database/Procedures.sql`: Contains all stored procedures.
- `Database/Triggers.sql`: Contains all triggers.
- `Database/SeedData.sql`: Contains seed data to populate the database with initial values.
- `Scripts/InsertBookWithAuthorsAndTranslator.sql`: Script to insert a book with authors and translators.
- `Scripts/DeleteBookByID.sql`: Script to delete a book by its ID.
- `Scripts/AddAuthor.sql`: Script to add an author to a book.
- `Scripts/AddTranslator.sql`: Script to add a translator to a book.

## How to Use

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/LibraryDatabaseProject.git
    ```

2. Open SQL Server Management Studio (SSMS) and connect to your database server.

3. Create a new database or use an existing one.

4. Run the scripts in the following order:
    - `Database/Schema.sql`
    - `Database/Procedures.sql`
    - `Database/Triggers.sql`
    - `Database/SeedData.sql`

5. Use the scripts in the `Scripts` folder to interact with the database.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

