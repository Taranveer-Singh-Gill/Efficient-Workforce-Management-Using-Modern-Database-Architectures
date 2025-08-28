INSERT INTO Department (Department_Name)
SELECT DISTINCT M.Department
FROM Main M
LEFT JOIN Department D ON M.Department = D.Department_Name
WHERE D.Department_Name IS NULL;

INSERT INTO Insurance (Insurance_Type)
SELECT DISTINCT M.Insurance
FROM Main M
LEFT JOIN Insurance I ON M.Insurance = I.Insurance_Type
WHERE I.Insurance_Type IS NULL;

INSERT INTO Marital_Status (Status)
SELECT DISTINCT M.Marital_Status
FROM Main M
LEFT JOIN Marital_Status MS ON M.Marital_Status = MS.Status
WHERE MS.Status IS NULL;

INSERT INTO Employee (
    Employee_ID, Name, Address, Salary, DOJ, DOB, Age, Sex, Dependents, 
    Insurance_ID, Marital_Status_ID, Department_ID, Position_Title
)
SELECT 
    M.Employee_ID, M.Name, M.Address, M.Salary, M.DOJ, M.DOB, M.Age, M.Sex, M.Dependents, 
    I.Insurance_ID, 
    MS.Marital_Status_ID, 
    D.Department_ID,
    M.Position
FROM Main M
JOIN Insurance I ON M.Insurance = I.Insurance_Type
LEFT JOIN Marital_Status MS ON M.Marital_Status = MS.Status
JOIN Department D ON M.Department = D.Department_Name;

INSERT INTO Compensation (
    Employee_ID, HRA, DA, PF, Gross_Salary
)
SELECT 
    M.Employee_ID, M.HRA, M.DA, M.PF, M.Gross_Salary
FROM Main M
LEFT JOIN Compensation C ON M.Employee_ID = C.Employee_ID
WHERE C.Employee_ID IS NULL;

INSERT INTO Experience (
    Employee_ID, In_Company_Years, Year_of_Experience
)
SELECT 
    M.Employee_ID, M.In_Company_Years, M.Year_of_Experience
FROM Main M
LEFT JOIN Experience E ON M.Employee_ID = E.Employee_ID
WHERE E.Employee_ID IS NULL;
