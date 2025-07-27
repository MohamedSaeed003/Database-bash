# Database-bash 🗄️

A complete database management system implemented entirely in Bash scripting. This project provides a command-line interface for creating, managing, and querying databases with full CRUD operations.

## 📋 Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Database Operations](#database-operations)
- [Table Operations](#table-operations)
- [Data Operations](#data-operations)
- [Technical Details](#technical-details)

## ✨ Features

### Database Management
- ✅ Create new databases
- ✅ List existing databases
- ✅ Delete databases
- ✅ Connect to specific databases

### Table Operations
- ✅ Create tables with custom columns and data types
- ✅ List all tables in a database
- ✅ Drop tables
- ✅ Metadata management for tables

### Data Operations
- ✅ **INSERT**: Add new records with data validation
- ✅ **SELECT**: Query data with advanced column selection
- ✅ **UPDATE**: Modify existing records
- ✅ **DELETE**: Remove records based on conditions

### SELECT Features
- 🔍 **Column Selection**: Choose specific columns to display
- 🔍 **Conditional Queries**: Filter data with WHERE-like conditions
- 🔍 **Data Type Validation**: Ensure data integrity
- 🔍 **User-friendly Interface**: Interactive column selection

## 📁 Project Structure

```
Database-bash/
├── start.sh              # Main entry point
├── connect_db.sh          # Database connection and main menu
├── create_db.sh           # Create new databases
├── list_db.sh             # List existing databases
├── drop_db.sh             # Delete databases
├── create_table.sh        # Create new tables
├── list_tables.sh         # List tables in database
├── drop_table.sh          # Delete tables
├── insert_data.sh         # Insert records into tables
├── select_data.sh         # Query and display data
├── delete_data.sh         # Delete records
├── update_table.sh        # Update existing records
└── Databases/             # Storage directory
    └── [database_name]/   # Individual database folders
        ├── table_file     # Table data (colon-separated)
        └── .table_file.meta_data  # Column metadata
```

## 🚀 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/MohamedSaeed003/Database-bash.git
   cd Database-bash
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x *.sh
   ```

3. **Run the application:**
   ```bash
   ./start.sh
   ```

## 💻 Usage

### Starting the Application
```bash
./start.sh
```

The application will present you with the main menu:
```
1) Press 1 to Create Database
2) Press 2 to List Databases  
3) Press 3 to Drop Database
4) Press 4 to Connect Database
5) Press 5 to Exit
```

### Connecting to a Database
Select option 4 and enter your database name. Once connected, you'll see:
```
1) Press 1 to Create Table
2) Press 2 to List Tables
3) Press 3 to Drop Table
4) Press 4 to Insert Data
5) Press 5 to Select Data
6) Press 6 to Delete Data
7) Press 7 to Update Table
8) Press 8 to Exit
```

## 🗃️ Database Operations

### Create Database
- Creates a new database directory
- Validates database name format
- Prevents duplicate database names

### List Databases
- Displays all existing databases
- Shows creation information

### Drop Database
- Safely deletes database and all contents
- Confirms deletion before proceeding

## 📊 Table Operations

### Create Table
- Define custom column names and data types
- Supported data types: `string`, `int`
- Automatic metadata file generation
- Input validation for table structure

### Example Table Creation:
![alt text](image.png) ![alt text](image-1.png)

## 📝 Data Operations

### INSERT Data
- Interactive data entry with validation
- Data type checking based on table schema
- User-friendly prompts showing expected data types

### SELECT Data (Advanced Features)
- **Column Selection**: Choose specific columns to display
- **Conditional Queries**: 
  - Equal to a value
  - Greater than (for numeric columns)
  - Less than (for numeric columns)
- **Smart Column Display**: Shows only selected columns in results

### SELECT Examples:
![alt text](image-2.png) ![alt text](image-6.png)

### UPDATE Data
- Modify existing records
- Condition-based updates
- Data validation for new values

### DELETE Data
- Remove records based on conditions

## 🔧 Technical Details

### Data Storage Format
- **Table Files**: Colon-separated values (CSV-like with `:`)
  ```
  id:name:salary
  1:John Doe:50000
  2:Jane Smith:60000
  ```

- **Metadata Files**: Store column information
  ```
  PK:id:int
  :name:string
  :salary:int
  ```

### Key Technologies
- **Pure Bash Scripting**: No external dependencies
- **AWK**: For data processing and filtering
- **Cut**: For column selection
- **File System**: Database and table storage

### Advanced Features
- **Data Type Validation**: Ensures data integrity
- **Interactive Menus**: User-friendly select loops
- **Modular Design**: Separated concerns across multiple scripts
- **Error Handling**: Comprehensive input validation
## 👨‍💻 Authors

**Mohamed Saeed** - [MohamedSaeed003](https://github.com/MohamedSaeed003)

**Youssef Waheed** - [youssefwahiid](https://github.com/youssefwahiid)

## 🙏 Acknowledgments

- Built with pure Bash scripting
- Inspired by traditional database management systems
- Designed for educational purposes and practical use

---

⭐ **If you find this project useful, please give it a star!** ⭐
