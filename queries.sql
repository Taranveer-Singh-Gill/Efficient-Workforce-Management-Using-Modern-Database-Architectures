SELECT D.Department_Name, COUNT(E.Employee_ID) AS Number_of_Employees
FROM Employee E
JOIN Department D ON E.Department_ID = D.Department_ID
GROUP BY D.Department_Name;


SELECT 
    E.Name, 
    D.Department_Name, 
    E.Position_Title, 
    I.Insurance_Type, 
    Exp.Year_of_Experience
FROM Employee E
JOIN Department D ON E.Department_ID = D.Department_ID
JOIN Insurance I ON E.Insurance_ID = I.Insurance_ID
JOIN Experience Exp ON E.Employee_ID = Exp.Employee_ID;


SELECT 
    D.Department_Name, 
    AVG(E.Salary) AS Average_Salary
FROM Employee E
JOIN Department D ON E.Department_ID = D.Department_ID
GROUP BY D.Department_Name;


SELECT 
    E.Name AS Employee_Name, 
    Exp.Year_of_Experience
FROM Employee E
JOIN Experience Exp ON E.Employee_ID = Exp.Employee_ID
WHERE Exp.Year_of_Experience > 10;

SELECT 
    D.Department_Name, 
    MAX(E.Salary) AS Highest_Salary
FROM Employee E
JOIN Department D ON E.Department_ID = D.Department_ID
GROUP BY D.Department_Name;
CREATE TABLE Salary_Changes (
    Change_ID SERIAL PRIMARY KEY,
    Employee_ID INT,
    Old_Salary NUMERIC(10, 2),
    New_Salary NUMERIC(10, 2),
    Change_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);

CREATE OR REPLACE FUNCTION log_salary_changes()
RETURNS TRIGGER 
LANGUAGE plpgsql AS
$$
BEGIN
    IF NEW.Salary <> OLD.Salary THEN
        INSERT INTO Salary_Changes (Employee_ID, Old_Salary, New_Salary)
        VALUES (NEW.Employee_ID, OLD.Salary, NEW.Salary);
    END IF;
    RETURN NEW;
END;
$$;

--Creating Trigger
CREATE TRIGGER salary_update_trigger
AFTER UPDATE OF Salary
ON Employee
FOR EACH ROW
EXECUTE FUNCTION log_salary_changes();

UPDATE Employee
SET Salary = 75000
WHERE Employee_ID = 101;

SELECT * FROM Salary_Changes;


CREATE TABLE Employee_Salary_Logs (
    Log_ID SERIAL PRIMARY KEY,
    Employee_ID INT,
    Old_Salary NUMERIC(10, 2),
    New_Salary NUMERIC(10, 2),
    Change_Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--Creating Procedure
CREATE OR REPLACE PROCEDURE give_bonus_to_experienced_employees()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Employee
    SET Salary = Salary * 1.10
    WHERE Employee_ID IN (
        SELECT Employee_ID
        FROM Experience
        WHERE Year_of_Experience > 5
    );
END;
$$;

CALL give_bonus_to_experienced_employees();


CREATE INDEX idx_employee_id ON Employee(Employee_ID);

-- Index on Department_ID, Insurance_ID, Marital_Status_ID in Employee table
CREATE INDEX idx_employee_department ON Employee(Department_ID);
CREATE INDEX idx_employee_insurance ON Employee(Insurance_ID);
CREATE INDEX idx_employee_marital_status ON Employee(Marital_Status_ID);

-- Index on Salary in Employee table (if needed for queries filtering or sorting by Salary)
CREATE INDEX idx_employee_salary ON Employee(Salary);

-- Index on Employee_ID in Compensation table
CREATE INDEX idx_compensation_employee_id ON Compensation(Employee_ID);

-- Index on Employee_ID in Experience table
CREATE INDEX idx_experience_employee_id ON Experience(Employee_ID);


DELETE FROM Compensation WHERE Employee_ID = 99;

INSERT INTO Compensation (Employee_ID, HRA, DA, PF, Gross_Salary)
VALUES (99, 5000, 3000, 2000, 75000);

UPDATE Employee SET Salary = 70000 WHERE Employee_ID = 101;



DELETE FROM Compensation WHERE Employee_ID = 99;

INSERT INTO Compensation (Employee_ID, HRA, DA, PF, Gross_Salary)
VALUES (99, 5000, 3000, 2000, 75000);

UPDATE Employee SET Salary = 70000 WHERE Employee_ID = 101;

SELECT D.Department_Name, 
       SUM(C.Gross_Salary) AS Total_Compensation,
       AVG(C.Gross_Salary) AS Average_Compensation,
       MAX(C.Gross_Salary) AS Max_Compensation
FROM Employee E
JOIN Department D ON E.Department_ID = D.Department_ID
JOIN Compensation C ON E.Employee_ID = C.Employee_ID
GROUP BY D.Department_Name;

SELECT MS.Status AS Marital_Status, SUM(E.Dependents) AS Total_Dependents
FROM Employee E
JOIN Marital_Status MS ON E.Marital_Status_ID = MS.Marital_Status_ID
GROUP BY MS.Status;



SELECT E.Name, E.Employee_ID
FROM Employee E
WHERE E.Dependents = 0;


SELECT E.Name, E.Employee_ID, D.Department_Name, E.Salary
FROM Employee E
JOIN Department D ON E.Department_ID = D.Department_ID
ORDER BY D.Department_Name, E.Salary DESC;

SELECT D.Department_Name, E.Name AS Employee_Name, C.Gross_Salary
FROM Employee E
JOIN Department D ON E.Department_ID = D.Department_ID
JOIN Compensation C ON E.Employee_ID = C.Employee_ID
WHERE (E.Department_ID, C.Gross_Salary) IN (
    SELECT Department_ID, MAX(Gross_Salary)
    FROM Compensation C
    JOIN Employee E ON C.Employee_ID = E.Employee_ID
    GROUP BY Department_ID
);


SELECT E1.Name AS Employee_Name_1, E1.Department_ID AS Department_1,
       E2.Name AS Employee_Name_2, E2.Department_ID AS Department_2, 
       E1.Position_Title
FROM Employee E1, Employee E2
WHERE E1.Position_Title = E2.Position_Title
  AND E1.Department_ID <> E2.Department_ID
  AND E1.Employee_ID < E2.Employee_ID;


SELECT SUBSTRING(E.Name FROM 1 FOR 1) AS Initial, COUNT(E.Employee_ID) AS Number_of_Employees
FROM Employee E
GROUP BY SUBSTRING(E.Name FROM 1 FOR 1)
ORDER BY Initial;


INSERT INTO Employee (Employee_ID, Name, Address, Salary, DOJ, DOB, Age, Sex, Dependents, Insurance_ID, Marital_Status_ID, Department_ID, Position_Title)
VALUES (5001, 'John Doe', '456 Elm St', 80000, '2019-01-01', '1990-06-15', 34, 'Male', 1, 5, 6, 6, 'Senior Developer'); 

UPDATE Employee
SET Salary = 85000, Position_Title = 'Lead Developer'
WHERE Employee_ID = 5001;

DELETE FROM Employee
WHERE Employee_ID = 5001;

DELETE FROM Salary_Changes
WHERE Employee_ID = 5001;

SELECT 
    E.Name,
    D.Department_Name,
    E.Salary,
    RANK() OVER (PARTITION BY E.Department_ID ORDER BY E.Salary DESC) AS Salary_Rank
FROM Employee E
JOIN Department D ON E.Department_ID = D.Department_ID;

WITH RECURSIVE OrgHierarchy AS (
    SELECT 
        E.Employee_ID,
        E.Name,
        E.Position_Title,
        E.Department_ID,
        NULL AS Manager_ID  -- Manager_ID is unavailable in the current schema
    FROM Employee E
    WHERE E.Department_ID = 1  -- Example: Department ID for the root

    UNION ALL

    SELECT 
        E.Employee_ID,
        E.Name,
        E.Position_Title,
        E.Department_ID,
        NULL AS Manager_ID
    FROM Employee E
    INNER JOIN OrgHierarchy OH ON E.Department_ID = OH.Department_ID
)
SELECT * FROM OrgHierarchy;


SELECT 
    D.Department_Name,
    E.Name AS Employee_Name,
    E.Salary AS Highest_Salary
FROM Employee E
JOIN Department D ON E.Department_ID = D.Department_ID
WHERE E.Salary = (
    SELECT MAX(Salary)
    FROM Employee
    WHERE Department_ID = E.Department_ID
);