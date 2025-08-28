DROP TABLE IF EXISTS Main CASCADE;
DROP TABLE IF EXISTS Experience CASCADE;
DROP TABLE IF EXISTS Compensation CASCADE;
DROP TABLE IF EXISTS Employee CASCADE;
DROP TABLE IF EXISTS Marital_Status CASCADE;
DROP TABLE IF EXISTS Insurance CASCADE;
DROP TABLE IF EXISTS Department CASCADE;

CREATE TABLE Department (
    Department_ID SERIAL PRIMARY KEY,
    Department_Name VARCHAR(255) NOT NULL
);

CREATE TABLE Insurance (
    Insurance_ID SERIAL PRIMARY KEY,
    Insurance_Type VARCHAR(50)
);

CREATE TABLE Marital_Status (
    Marital_Status_ID SERIAL PRIMARY KEY,
    Status VARCHAR(50)
);

CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    Salary NUMERIC(10, 2),
    DOJ DATE,
    DOB DATE,
    Age INT,
    Sex VARCHAR(10),
    Dependents INT,
    Insurance_ID INT,
    Marital_Status_ID INT,
    Department_ID INT,
    Position_Title VARCHAR(255),
    FOREIGN KEY (Insurance_ID) REFERENCES Insurance(Insurance_ID),
    FOREIGN KEY (Marital_Status_ID) REFERENCES Marital_Status(Marital_Status_ID),
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
);

CREATE TABLE Compensation (
    Employee_ID INT PRIMARY KEY,
    HRA NUMERIC(10, 2),
    DA NUMERIC(10, 2),
    PF NUMERIC(10, 2),
    Gross_Salary NUMERIC(10, 2),
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);

CREATE TABLE Experience (
    Employee_ID INT PRIMARY KEY,
    In_Company_Years INT,
    Year_of_Experience INT,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);

CREATE TABLE Main (
    Employee_ID INT PRIMARY KEY,      
    Name VARCHAR(255) NOT NULL,         
    Address VARCHAR(255),                
    Salary NUMERIC(10, 2),               
    DOJ DATE,                            
    DOB DATE,                            
    Age INT,                             
    Sex VARCHAR(10),
    Dependents INT,                      
    HRA NUMERIC(10, 2),                  
    DA NUMERIC(10, 2),                   
    PF NUMERIC(10, 2),                   
    Gross_Salary NUMERIC(10, 2),        
    Insurance VARCHAR(50),               
    Marital_Status VARCHAR(50),          
    In_Company_Years INT,                
    Year_of_Experience INT,              
    Department VARCHAR(255),             
    Position VARCHAR(255)    
);
