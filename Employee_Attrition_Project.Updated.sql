USE master

GO

IF EXISTS (SELECT * FROM SYSDATABASES WHERE NAME= 'Employee_Attrition1')
DROP DATABASE Employee_Attrition1

GO

CREATE DATABASE Employee_Attrition1

GO

USE Employee_Attrition1

GO

CREATE TABLE Departments 
(
    Department_ID INT IDENTITY(1,1) CONSTRAINT Dep_DepID_PK PRIMARY KEY, /*מפתח ראשי עם אינדקס ייחודי*/
    Department NVARCHAR(30) CONSTRAINT Dep_Depa_NN NOT NULL CONSTRAINT Dep_Depa_CK CHECK(Department IN ('Sales', 'Research & Development', 'Human Resources')) /*בדיקה לערכים*/
);
 
 GO

CREATE TABLE Education 
(
    Education_ID INT IDENTITY(1,1) CONSTRAINT Edu_EduID_PK PRIMARY KEY, /*מפתח ראשי עם אינדקס ייחודי*/
    Education_Level INT CONSTRAINT Edu_EduL_NN NOT NULL CONSTRAINT Edu_EduL_CK CHECK(Education_Level BETWEEN 1 AND 5),  /*בדיקה לטווח תקין*/
    Education_Field NVARCHAR(30) CONSTRAINT Edu_EduF_NN NOT NULL CONSTRAINT Edu_EduF_CK CHECK(Education_Field IN ('Marketing', 'Medical', 'Human Resources', 'Life Sciences', 'Technical Degree', 'Other')),  /*בדיקה לערכיםי*/
    CONSTRAINT Edu_Unique UNIQUE (Education_Field, Education_Level) /*מניעת כפילות*/
);
 
 GO

CREATE TABLE Job_Roles 
(
    Job_Roles_ID INT IDENTITY(1,1) CONSTRAINT Job_JbrID_PK PRIMARY KEY,   /*מפתח ראשי עם אינדקס ייחודי*/
    Job_Role NVARCHAR(30) CONSTRAINT Job_JobR_NN NOT NULL CONSTRAINT Job_JobR_CK CHECK(Job_Role IN ('Human Resources', 'Manager', 'Research Director', 'Sales Representative', 'Healthcare Representative', 'Manufacturing Director', 'Laboratory Technician', 'Research Scientist', 'Sales Executive')),  /*בדיקה לערכיםי*/
    Job_Level INT CONSTRAINT Job_JobL_NN NOT NULL CONSTRAINT Job_JobL_CK CHECK(Job_Level BETWEEN 1 AND 5),   /*בדיקה לטווח תקין*/
    CONSTRAINT Job_Unique UNIQUE (Job_Role, Job_Level)   /*מניעת כפילות*/
);
 
 GO

  /* יצירת טבלת פרטי עובדים הכוללת נתונים אישיים, נתוני עבודה וקשרים לטבלאות קודמות*/

CREATE TABLE Employees_Details 
(
    Employee_ID INT CONSTRAINT Emp_EmpID_PK PRIMARY KEY,  /*מפתח ראשי */
    Age INT CONSTRAINT Emp_Ag_NN NOT NULL, /*גיל*/
    Gender NVARCHAR(20) CONSTRAINT Emp_Gen_NN NOT NULL CONSTRAINT Emp_Gen_CK CHECK(Gender IN ('Male', 'Female', 'Non-Binary', 'Other')), /*מין*/
    Marital_Status NVARCHAR(20) CONSTRAINT Emp_MarS_NN NOT NULL CONSTRAINT Emp_MarS_CK CHECK(Marital_Status IN ('Single', 'Married', 'Divorced')),  /*מצב משפחתי*/
    Department_ID INT CONSTRAINT Dep_DepID_NN NOT NULL CONSTRAINT Dep_DepID_FK FOREIGN KEY REFERENCES Departments(Department_ID), /*מפתח זר מטבלת המחלקות*/
    Over18 NVARCHAR(3) CONSTRAINT Emp_Ov18_NN NOT NULL CONSTRAINT Emp_Ov18_CK CHECK(Over18 IN ('Yes', 'No')), /*אימות גיל*/
    Education_ID INT CONSTRAINT Edu_EduID_NN NOT NULL CONSTRAINT Edu_EduID_FK FOREIGN KEY REFERENCES Education(Education_ID), /*מפתח זר מטבלת השכלה*/
    Total_Working_Years INT, /*סה"כ שנות עבודה*/
    Num_Companies_Worked INT,  /*מספר מקומות עבודה קודמים*/
    Years_Since_Last_Promotion INT,  /*מספר שנים מהקידום האחרון*/
    Years_With_Current_Manager INT, /*מספר שנים עם מנהל נוכחי*/
    Training_Time_Last_Year INT, /*זמן הדרכה בשנה האחרונה*/
    Job_Level INT, /*רמת התפקיד*/
    Job_Roles_ID INT CONSTRAINT Job_JbrID_NN NOT NULL CONSTRAINT Job_JbrID_FK FOREIGN KEY REFERENCES Job_Roles(Job_Roles_ID), /*מפתח זר מטבלת המשרות*/
    Monthly_Income DECIMAL(10, 2), /*משכורת חודשית*/
    Hourly_Rate DECIMAL(5, 2), /*תשלום שעתי*/
    Stock_Option_Level INT, /*רמת מניות*/
    Percent_Salary_Hike DECIMAL(5, 2), /*אחוז עליית שכר*/
    Years_At_Company INT, /*מספר שנים בחברה*/
    Years_In_Current_Role INT /*מספר שנים בתפקיד נוכחי*/
);

GO



/*הכנסת נתונים לטבלת מחלקות*/




INSERT INTO DEPARTMENTS (DEPARTMENT)
VALUES
('Sales'),
('Research & Development'), 
('Human Resources');

GO

/*הכנסת נתונים לטבלת השכלה*/


INSERT INTO EDUCATION (Education_Level, Education_Field)
VALUES
    (1, 'Marketing'),
    (2, 'Marketing'),
    (3, 'Marketing'),
    (4, 'Marketing'),
    (5, 'Marketing'),
    (1, 'Medical'),
    (2, 'Medical'),
    (3, 'Medical'),
    (4, 'Medical'),
    (5, 'Medical'),
    (1, 'Human Resources'),
    (2, 'Human Resources'),
    (3, 'Human Resources'),
    (4, 'Human Resources'),
    (5, 'Human Resources'),
    (1, 'Life Sciences'),
    (2, 'Life Sciences'),
    (3, 'Life Sciences'),
    (4, 'Life Sciences'),
    (5, 'Life Sciences'),
    (1, 'Technical Degree'),
    (2, 'Technical Degree'),
    (3, 'Technical Degree'),
    (4, 'Technical Degree'),
    (5, 'Technical Degree'),
    (1, 'Other'),
    (2, 'Other'),
    (3, 'Other'),
    (4, 'Other'),
    (5, 'Other');

	GO

	/*הכנסת נתונים לטבלת תפקידים*/


INSERT INTO Job_Roles (Job_Level, Job_Role)
VALUES

(2, 'Sales Executive'),
(2, 'Research Scientist'),
(1, 'Laboratory Technician'),
(1, 'Research Scientist'),
(3, 'Manufacturing Director'),
(2, 'Healthcare Representative'),
(2, 'Laboratory Technician'),
(4, 'Manager'),
(2, 'Manufacturing Director'),
(1, 'Sales Representative'),
(3, 'Research Director'),
(5, 'Manager'),
(3, 'Healthcare Representative'),
(2, 'Sales Representative'),
(3, 'Sales Executive'),
(5, 'Research Director'),
(3, 'Laboratory Technician'),
(3, 'Research Scientist'),
(2, 'Human Resources'),
(4, 'Healthcare Representative'),
(4, 'Sales Executive'),
(1, 'Human Resources'),
(3, 'Manager'),
(4, 'Research Director'),
(3, 'Human Resources'),
(4, 'Manufacturing Director');

GO

/*הכנסת נתונים לטבלת העובדים*/


INSERT INTO Employees_Details (
    Employee_ID,
    Age,
    Gender,
    Marital_Status,
    Department_ID,
    Over18,
    Education_ID,
    Total_Working_Years,
    Num_Companies_Worked,
    Years_Since_Last_Promotion,
    Years_With_Current_Manager,
    Training_Time_Last_Year,
    Job_Level,
    Job_Roles_ID,
    Monthly_Income,
    Hourly_Rate,
    Stock_Option_Level,
    Percent_Salary_Hike,
    Years_At_Company,
    Years_In_Current_Role)
VALUES
( 1, 41, 'Female', 'Single', 1, 'yes', 17, 8, 8, 0, 5, 0, 2, 1, 5993, 94, 0, 11, 6, 4),
( 2, 49, 'Male', 'Married', 2, 'yes', 16, 10, 1, 1, 7, 3, 2, 2, 5130, 61, 1, 23, 10, 7),
( 4, 37, 'Male', 'Single', 2, 'yes', 27, 7, 6, 0, 0, 3, 1, 3, 2090, 92, 0, 15, 0, 0),
( 5, 33, 'Female', 'Married', 2, 'yes', 19, 8, 1, 3, 0, 3, 1, 4, 2909, 56, 0, 11, 8, 7),
( 7, 27, 'Male', 'Married', 2, 'yes', 6, 6, 9, 2, 2, 3, 1, 3, 3468, 40, 1, 12, 2, 2),
( 8, 32, 'Male', 'Single', 2, 'yes', 17, 8, 0, 3, 6, 2, 1, 3, 3068, 79, 0, 13, 7, 7),
( 10, 59, 'Female', 'Married', 2, 'yes', 8, 12, 4, 0, 0, 3, 1, 3, 2670, 81, 3, 20, 1, 0),
( 11, 30, 'Male', 'Divorced', 2, 'yes', 16, 1, 1, 0, 0, 2, 1, 3, 2693, 67, 1, 22, 1, 0),
( 12, 38, 'Male', 'Single', 2, 'yes', 18, 10, 0, 1, 8, 2, 3, 5, 9526, 44, 0, 21, 9, 7),
( 13, 36, 'Male', 'Married', 2, 'yes', 8, 17, 6, 7, 7, 3, 2, 6, 5237, 94, 2, 13, 7, 7),
( 14, 35, 'Male', 'Married', 2, 'yes', 8, 6, 0, 0, 3, 5, 1, 3, 2426, 84, 1, 13, 5, 4),
( 15, 29, 'Female', 'Single', 2, 'yes', 17, 10, 0, 0, 8, 3, 2, 7, 4193, 49, 0, 12, 9, 5),
( 16, 31, 'Male', 'Divorced', 2, 'yes', 16, 5, 1, 4, 3, 1, 1, 4, 2911, 31, 1, 17, 5, 2),
( 18, 34, 'Male', 'Divorced', 2, 'yes', 7, 3, 0, 1, 2, 2, 1, 3, 2661, 93, 1, 11, 2, 2),
( 19, 28, 'Male', 'Single', 2, 'yes', 18, 6, 5, 0, 3, 4, 1, 3, 2028, 50, 0, 14, 4, 2),
( 20, 29, 'Female', 'Divorced', 2, 'yes', 19, 10, 1, 8, 8, 1, 3, 5, 9980, 51, 1, 11, 10, 9),
( 21, 32, 'Male', 'Divorced', 2, 'yes', 17, 7, 0, 0, 5, 5, 1, 4, 3298, 80, 2, 12, 6, 2),
( 22, 22, 'Male', 'Divorced', 2, 'yes', 7, 1, 1, 0, 0, 2, 1, 3, 2935, 96, 2, 13, 1, 0),
( 23, 53, 'Female', 'Married', 1, 'yes', 19, 31, 2, 3, 7, 3, 4, 8, 15427, 78, 0, 16, 25, 8),
( 24, 38, 'Male', 'Single', 2, 'yes', 18, 6, 5, 1, 2, 3, 1, 4, 3944, 45, 0, 11, 3, 2),
( 26, 24, 'Female', 'Divorced', 2, 'yes', 27, 5, 0, 1, 3, 5, 2, 9, 4011, 96, 1, 18, 4, 2),
( 27, 36, 'Male', 'Single', 1, 'yes', 19, 10, 7, 0, 3, 4, 1, 10, 3407, 82, 0, 23, 5, 3),
( 28, 34, 'Female', 'Single', 2, 'yes', 19, 13, 0, 2, 11, 4, 3, 11, 11994, 53, 0, 11, 12, 6),
( 30, 21, 'Male', 'Single', 2, 'yes', 17, 0, 1, 0, 0, 6, 1, 4, 1232, 96, 0, 14, 0, 0),
( 31, 34, 'Male', 'Single', 2, 'yes', 6, 8, 2, 1, 3, 2, 1, 4, 2960, 83, 0, 11, 4, 2),
( 32, 53, 'Female', 'Divorced', 2, 'yes', 28, 26, 4, 4, 8, 3, 5, 12, 19094, 58, 1, 11, 14, 13),
( 33, 32, 'Female', 'Single', 2, 'yes', 16, 10, 1, 6, 7, 5, 1, 4, 3919, 72, 0, 22, 10, 2),
( 35, 42, 'Male', 'Married', 1, 'yes', 4, 10, 0, 4, 2, 2, 2, 1, 6825, 48, 1, 11, 9, 7),
( 36, 44, 'Female', 'Married', 2, 'yes', 9, 24, 3, 5, 17, 4, 3, 13, 10248, 42, 1, 14, 22, 6),
( 38, 46, 'Female', 'Single', 1, 'yes', 4, 22, 3, 2, 1, 2, 5, 12, 18947, 83, 0, 12, 2, 2),
( 39, 33, 'Male', 'Single', 2, 'yes', 8, 7, 4, 0, 0, 3, 1, 3, 2496, 78, 0, 11, 1, 1),
( 40, 44, 'Male', 'Married', 2, 'yes', 29, 9, 2, 1, 3, 5, 2, 6, 6465, 41, 0, 13, 4, 2),
( 41, 30, 'Male', 'Single', 2, 'yes', 7, 10, 1, 1, 8, 5, 1, 3, 2206, 83, 0, 13, 10, 0),
( 42, 39, 'Male', 'Married', 1, 'yes', 23, 19, 3, 0, 0, 6, 2, 14, 2086, 56, 1, 14, 1, 0),
( 45, 24, 'Male', 'Married', 2, 'yes', 8, 6, 2, 2, 0, 2, 1, 4, 2293, 61, 1, 16, 2, 0),
( 46, 43, 'Female', 'Divorced', 2, 'yes', 7, 6, 1, 1, 4, 3, 1, 4, 2645, 72, 2, 12, 5, 3),
( 47, 50, 'Male', 'Married', 1, 'yes', 2, 3, 1, 0, 2, 2, 1, 10, 2683, 86, 0, 14, 3, 2),
( 49, 35, 'Female', 'Married', 1, 'yes', 3, 2, 1, 2, 2, 3, 1, 10, 2014, 97, 0, 13, 2, 2),
( 51, 36, 'Female', 'Married', 2, 'yes', 19, 6, 9, 0, 0, 3, 1, 4, 3419, 82, 1, 14, 1, 1),
( 52, 33, 'Female', 'Married', 1, 'yes', 18, 10, 2, 1, 3, 3, 2, 1, 5376, 42, 2, 19, 5, 3),
( 53, 35, 'Male', 'Divorced', 2, 'yes', 27, 1, 1, 0, 0, 3, 1, 3, 1951, 75, 1, 12, 1, 0),
( 54, 27, 'Female', 'Divorced', 2, 'yes', 19, 1, 1, 0, 0, 6, 1, 3, 2341, 33, 1, 13, 1, 0),
( 55, 26, 'Male', 'Single', 2, 'yes', 18, 1, 1, 0, 1, 2, 1, 3, 2293, 48, 0, 12, 1, 0),
( 56, 27, 'Male', 'Single', 1, 'yes', 18, 9, 1, 1, 7, 0, 3, 15, 8726, 37, 0, 15, 9, 8),
( 57, 30, 'Female', 'Single', 2, 'yes', 7, 12, 1, 3, 7, 2, 2, 7, 4011, 58, 0, 23, 12, 8),
( 58, 41, 'Female', 'Married', 2, 'yes', 23, 23, 1, 15, 8, 0, 5, 16, 19545, 49, 0, 12, 22, 15),
( 60, 34, 'Male', 'Single', 1, 'yes', 4, 10, 0, 8, 7, 2, 2, 1, 4568, 72, 0, 20, 9, 5),
( 61, 37, 'Male', 'Married', 2, 'yes', 17, 8, 4, 0, 0, 1, 1, 4, 3022, 73, 0, 21, 1, 0),
( 62, 46, 'Male', 'Single', 1, 'yes', 4, 14, 4, 0, 8, 4, 2, 1, 5772, 98, 0, 21, 9, 6),
( 63, 35, 'Male', 'Married', 2, 'yes', 16, 1, 1, 0, 1, 2, 1, 3, 2269, 36, 0, 19, 1, 0),
( 64, 48, 'Male', 'Single', 2, 'yes', 17, 23, 9, 0, 0, 2, 3, 17, 5381, 98, 0, 13, 1, 0),
( 65, 28, 'Male', 'Single', 2, 'yes', 24, 2, 1, 2, 2, 3, 1, 3, 3441, 50, 0, 13, 2, 2),
( 68, 44, 'Female', 'Divorced', 1, 'yes', 5, 9, 5, 1, 3, 2, 2, 1, 5454, 75, 1, 21, 4, 3),
( 70, 35, 'Male', 'Married', 2, 'yes', 7, 10, 2, 2, 3, 3, 3, 13, 9884, 79, 1, 13, 4, 0),
( 72, 26, 'Female', 'Married', 1, 'yes', 3, 5, 7, 0, 0, 2, 2, 1, 4157, 47, 1, 19, 2, 2),
( 73, 33, 'Female', 'Single', 2, 'yes', 17, 15, 1, 8, 12, 1, 3, 11, 13458, 98, 0, 12, 15, 14),
( 74, 35, 'Male', 'Married', 1, 'yes', 20, 9, 1, 1, 8, 3, 3, 15, 9069, 71, 1, 22, 9, 8),
( 75, 35, 'Female', 'Married', 2, 'yes', 9, 4, 3, 2, 2, 3, 1, 3, 4014, 30, 1, 15, 2, 2),
( 76, 31, 'Male', 'Divorced', 2, 'yes', 19, 10, 3, 1, 7, 3, 2, 7, 5915, 48, 1, 22, 7, 7),
( 77, 37, 'Male', 'Divorced', 2, 'yes', 19, 7, 1, 0, 7, 2, 2, 9, 5993, 51, 1, 18, 7, 5),
( 78, 32, 'Male', 'Married', 2, 'yes', 8, 9, 1, 7, 8, 3, 2, 9, 6162, 33, 1, 22, 9, 8),
( 79, 38, 'Female', 'Single', 2, 'yes', 20, 10, 1, 9, 9, 2, 2, 7, 2406, 50, 0, 11, 10, 3),
( 80, 50, 'Female', 'Divorced', 2, 'yes', 7, 29, 5, 13, 8, 2, 5, 16, 18740, 43, 1, 12, 27, 3),
( 81, 59, 'Female', 'Single', 1, 'yes', 18, 28, 7, 7, 9, 3, 3, 15, 7637, 99, 0, 11, 21, 16),
( 83, 36, 'Female', 'Divorced', 2, 'yes', 23, 17, 1, 12, 8, 2, 3, 13, 10096, 59, 3, 13, 17, 14),
( 84, 55, 'Female', 'Divorced', 2, 'yes', 8, 21, 2, 0, 2, 2, 4, 8, 14756, 33, 3, 14, 5, 0),
( 85, 36, 'Male', 'Single', 2, 'yes', 18, 6, 1, 0, 3, 3, 2, 9, 6499, 95, 0, 13, 6, 5),
( 86, 45, 'Male', 'Divorced', 2, 'yes', 18, 25, 2, 0, 0, 2, 3, 18, 9724, 59, 1, 17, 1, 0),
( 88, 35, 'Male', 'Married', 2, 'yes', 8, 5, 4, 1, 2, 2, 1, 4, 2194, 79, 1, 13, 3, 2),
( 90, 36, 'Male', 'Married', 2, 'yes', 8, 2, 0, 0, 0, 0, 1, 4, 3388, 79, 1, 17, 1, 0),
( 91, 59, 'Female', 'Single', 1, 'yes', 16, 20, 7, 1, 3, 2, 2, 1, 5473, 57, 0, 11, 4, 3),
( 94, 29, 'Male', 'Married', 2, 'yes', 18, 6, 0, 0, 4, 3, 1, 4, 2703, 76, 1, 23, 5, 4),
( 95, 31, 'Male', 'Single', 2, 'yes', 9, 1, 1, 1, 0, 4, 1, 4, 2501, 87, 0, 17, 1, 1),
( 96, 32, 'Male', 'Married', 2, 'yes', 18, 10, 1, 0, 9, 3, 2, 2, 6220, 66, 2, 17, 10, 4),
( 97, 36, 'Female', 'Married', 2, 'yes', 18, 5, 3, 0, 0, 3, 1, 3, 3038, 55, 0, 12, 1, 0),
( 98, 31, 'Female', 'Single', 2, 'yes', 19, 11, 1, 1, 8, 2, 2, 9, 4424, 61, 0, 23, 11, 7),
( 100, 35, 'Male', 'Single', 1, 'yes', 4, 16, 0, 2, 8, 2, 2, 1, 4312, 32, 0, 14, 15, 13),
( 101, 45, 'Male', 'Married', 2, 'yes', 29, 17, 4, 0, 0, 3, 3, 11, 13245, 52, 0, 14, 0, 0),
( 102, 37, 'Male', 'Single', 2, 'yes', 9, 16, 4, 0, 2, 3, 3, 11, 13664, 30, 0, 13, 5, 2),
( 103, 46, 'Male', 'Divorced', 3, 'yes', 7, 16, 8, 0, 2, 2, 2, 19, 5021, 80, 1, 22, 4, 2),
( 104, 30, 'Male', 'Married', 2, 'yes', 16, 10, 1, 3, 0, 1, 2, 7, 5126, 55, 2, 12, 10, 8),
( 105, 35, 'Male', 'Single', 2, 'yes', 8, 6, 1, 0, 4, 3, 1, 4, 2859, 30, 0, 18, 6, 4),
( 106, 55, 'Male', 'Married', 1, 'yes', 17, 24, 3, 1, 0, 4, 3, 15, 10239, 70, 1, 14, 1, 0),
( 107, 38, 'Female', 'Divorced', 2, 'yes', 8, 17, 7, 1, 9, 3, 2, 2, 5329, 79, 3, 12, 13, 11),
( 110, 34, 'Male', 'Married', 2, 'yes', 7, 5, 1, 1, 3, 2, 2, 9, 4325, 94, 0, 15, 5, 2),
( 112, 56, 'Male', 'Single', 2, 'yes', 18, 37, 4, 0, 2, 3, 3, 5, 7260, 49, 0, 11, 6, 4),
( 113, 23, 'Male', 'Divorced', 1, 'yes', 21, 3, 3, 0, 0, 3, 1, 10, 2322, 62, 1, 13, 0, 0),
( 116, 51, 'Male', 'Married', 2, 'yes', 19, 10, 3, 0, 3, 4, 1, 3, 2075, 96, 2, 23, 4, 2),
( 117, 30, 'Male', 'Married', 2, 'yes', 18, 11, 1, 10, 8, 3, 2, 6, 4152, 99, 3, 19, 11, 10),
( 118, 46, 'Male', 'Single', 1, 'yes', 7, 9, 1, 4, 7, 3, 3, 15, 9619, 64, 0, 16, 9, 8),
( 119, 40, 'Male', 'Married', 2, 'yes', 19, 22, 1, 11, 11, 3, 4, 20, 13503, 78, 1, 22, 22, 3),
( 120, 51, 'Male', 'Single', 1, 'yes', 4, 11, 0, 1, 0, 2, 2, 1, 5441, 71, 0, 22, 10, 7),
( 121, 30, 'Female', 'Divorced', 1, 'yes', 7, 11, 1, 2, 7, 4, 2, 1, 5209, 63, 3, 12, 11, 8),
( 124, 46, 'Male', 'Married', 2, 'yes', 8, 21, 2, 9, 5, 5, 3, 13, 10673, 40, 1, 13, 10, 9),
( 125, 32, 'Male', 'Single', 1, 'yes', 9, 12, 1, 5, 7, 0, 2, 1, 5010, 87, 0, 16, 11, 8),
( 126, 54, 'Female', 'Married', 2, 'yes', 24, 16, 9, 0, 3, 5, 3, 11, 13549, 60, 1, 12, 4, 3),
( 128, 24, 'Female', 'Married', 1, 'yes', 27, 4, 0, 0, 2, 2, 2, 1, 4999, 33, 1, 21, 3, 2),
( 129, 28, 'Male', 'Married', 1, 'yes', 8, 5, 1, 0, 4, 3, 2, 1, 4221, 43, 0, 15, 5, 4),
( 131, 58, 'Male', 'Single', 1, 'yes', 9, 38, 0, 1, 8, 1, 4, 21, 13872, 37, 0, 13, 37, 10),
( 132, 44, 'Male', 'Married', 2, 'yes', 8, 17, 4, 1, 2, 3, 2, 7, 2042, 67, 1, 12, 3, 2),
( 133, 37, 'Male', 'Divorced', 3, 'yes', 14, 7, 4, 0, 2, 3, 1, 22, 2073, 63, 0, 22, 3, 2),
( 134, 32, 'Male', 'Single', 2, 'yes', 16, 1, 1, 0, 0, 2, 1, 4, 2956, 71, 0, 13, 1, 0),
( 137, 20, 'Female', 'Single', 2, 'yes', 18, 1, 1, 1, 0, 5, 1, 3, 2926, 66, 0, 18, 1, 0),
( 138, 34, 'Female', 'Single', 2, 'yes', 29, 16, 1, 2, 10, 3, 2, 2, 4809, 41, 0, 14, 16, 13),
( 139, 37, 'Male', 'Divorced', 2, 'yes', 17, 17, 5, 0, 0, 2, 2, 6, 5163, 100, 1, 14, 1, 0),
( 140, 59, 'Female', 'Married', 3, 'yes', 14, 30, 9, 2, 2, 3, 5, 12, 18844, 32, 1, 21, 3, 2),
( 141, 50, 'Female', 'Married', 2, 'yes', 18, 28, 3, 0, 7, 1, 5, 16, 18172, 73, 0, 19, 8, 3),
( 142, 25, 'Male', 'Single', 1, 'yes', 3, 6, 1, 0, 3, 1, 2, 1, 5744, 46, 0, 11, 6, 4),
( 143, 25, 'Male', 'Married', 2, 'yes', 6, 2, 1, 2, 1, 2, 1, 4, 2889, 64, 2, 11, 2, 2),
( 144, 22, 'Female', 'Single', 2, 'yes', 8, 1, 1, 0, 0, 5, 1, 3, 2871, 59, 0, 15, 0, 0),
( 145, 51, 'Female', 'Single', 2, 'yes', 9, 23, 3, 12, 8, 1, 3, 13, 7484, 30, 0, 20, 13, 12),
( 147, 34, 'Male', 'Single', 2, 'yes', 18, 9, 1, 0, 6, 3, 2, 7, 6074, 66, 0, 24, 9, 7),
( 148, 54, 'Female', 'Single', 3, 'yes', 13, 23, 2, 4, 4, 3, 4, 8, 17328, 30, 0, 12, 5, 3),
( 150, 24, 'Male', 'Married', 2, 'yes', 16, 6, 0, 1, 2, 2, 1, 3, 2774, 52, 1, 12, 5, 3);