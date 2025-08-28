Project Overview:

Step 1: The database was created in PostgreSQL using pgAdmin.
- It includes multiple tables, including one primary table containing all the data from a .csv file.

Step 2: The tables were created by executing queries from the `create.sql` file in the query tool of pgAdmin.
- The SQL file defines the structure of the tables and their relationships, including primary and foreign keys.

Step 3: Data was directly imported into the primary table using the import feature available in pgAdmin.
- The `.csv` file was imported into the primary table to load the bulk of the data.

Step 4: Data was inserted into the remaining tables by running the queries listed in the `load.sql` file.
- The `load.sql` file contains SQL queries to insert unique data into related tables by avoiding duplicate entries.
- The primary table was used to extract distinct values for tables such as `Department`, `Insurance`, and `Marital_Status`.

Step 5: Once data was loaded, the primary table was deleted to maintain database normalization and integrity.
- After the data insertion, the primary table was no longer needed and was removed to optimize database structure.

Step 6: Several queries listed in `queries.sql` were executed to perform data analysis and retrieve relevant information from the database.
- These queries help in extracting specific insights and working with the loaded data.

Step 7: A live website was developed using Streamlit in Python. The website creation code can be found in the `app.py` file.
- The website provides an interactive front-end interface to query and display the data from the database.

How Tables Were Built and Data Was Imported:

1. **Creating Tables:**
   - The tables were created using SQL queries written in the `create.sql` file. This file defines each table's structure, including columns, data types, and relationships between tables through foreign keys.
   - The tables created include `Department`, `Insurance`, `Marital_Status`, `Employee`, `Compensation`, `Experience`, and a primary table.

2. **Importing Data:**
   - The data for the primary table was imported directly from a `.csv` file using the import feature in pgAdmin.
   - After the primary table was populated, the data from the primary table was used to populate the remaining tables.
   - The `load.sql` file contains queries to insert unique values into the related tables, such as `Department`, `Insurance`, and `Marital_Status`, ensuring that duplicate entries are avoided.
   - The primary table was removed once the data was inserted into the related tables to ensure a clean and normalized database structure.
