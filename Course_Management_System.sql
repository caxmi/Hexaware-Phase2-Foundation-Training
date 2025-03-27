CREATE DATABASE CourseManagement;
GO
USE CourseManagement;
GO

-- Table: Instructors
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Expertise VARCHAR(255) NOT NULL
);

-- Table: Courses
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName VARCHAR(255) NOT NULL,
    Category VARCHAR(255) NOT NULL,
    Duration INT NOT NULL,
    InstructorID INT NOT NULL,
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

-- Table: Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL
);

-- Table: Enrollments
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    CONSTRAINT UniqueEnrollment UNIQUE (StudentID, CourseID) -- Prevent double enrollment
);

-- Table: Payments
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- Table: Assessments
CREATE TABLE Assessments (
    AssessmentID INT PRIMARY KEY IDENTITY(1,1),
    CourseID INT NOT NULL,
    AssessmentType VARCHAR(50) NOT NULL,
    TotalMarks INT NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Additional Table: Certificates (New Feature)
CREATE TABLE Certificates (
    CertificateID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    IssuedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    CONSTRAINT UniqueCertificate UNIQUE (StudentID, CourseID) -- One certificate per course per student
);


--Insert Sample Data
-- Instructors
INSERT INTO Instructors (FullName, Email, Expertise) VALUES 
('Dr. Arun Kumar', 'arun.kumar@example.com', 'Data Science'),
('Prof. Lakshmi Narayanan', 'lakshmi.narayanan@example.com', 'Cybersecurity'),
('Dr. Priya Shankar', 'priya.shankar@example.com', 'AI & Machine Learning');

-- Courses
INSERT INTO Courses (CourseName, Category, Duration, InstructorID) VALUES 
('Python for Beginners', 'Technology', 40, 1),
('Advanced Cybersecurity', 'Security', 50, 2),
('AI & Deep Learning', 'AI', 60, 3),
('Database Management', 'Technology', 35, 1);

-- Students
INSERT INTO Students (FullName, Email, PhoneNumber) VALUES 
('Rajeshwari R', 'rajeshwari.r@example.com', '9876543210'),
('Venkatesh M', 'venkatesh.m@example.com', '8765432109'),
('Meenakshi S', 'meenakshi.s@example.com', '7654321098'),
('Karthikeyan P', 'karthikeyan.p@example.com', '6543210987');

-- Enrollments


INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate) VALUES 
(1, 1, '2025-03-01'),
(2, 1, '2025-03-02'),
(2, 3, '2025-03-03'),
(4, 4, '2025-03-04'),
(1, 4, '2025-03-05');

-- Payments
INSERT INTO Payments (StudentID, AmountPaid, PaymentDate) VALUES 
(1, 500.00, '2025-03-02'),
(2, 700.00, '2025-03-03'),
(4, 600.00, '2025-03-05');

-- Assessments
INSERT INTO Assessments (CourseID, AssessmentType, TotalMarks) VALUES 
(1, 'Quiz', 100),
(1, 'Assignment', 50),
(3, 'Project', 200),
(4, 'Midterm', 150);

-- 3. Retrieve Available Courses
SELECT c.CourseName, c.Category, c.Duration, i.FullName AS InstructorName
FROM Courses c
JOIN Instructors i ON c.InstructorID = i.InstructorID;

-- 4. Retrieve Students Enrolled in a Specific Course
DECLARE @CourseID INT = 1; 
SELECT s.FullName, s.Email, e.EnrollmentDate
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
WHERE e.CourseID = @CourseID;

-- 5. Update Instructor Information (Stored Procedure)
CREATE PROCEDURE UpdateInstructorInfo
    @InstructorID INT,
    @NewFullName VARCHAR(255),
    @NewEmail VARCHAR(255)
AS
BEGIN
    UPDATE Instructors
    SET FullName = @NewFullName, Email = @NewEmail
    WHERE InstructorID = @InstructorID;
END;
GO

-- 6. Calculate Total Payments per Student
SELECT s.FullName, COALESCE(SUM(p.AmountPaid), 0) AS TotalPaid
FROM Students s
LEFT JOIN Payments p ON s.StudentID = p.StudentID
GROUP BY s.FullName;

-- 7. Retrieve Students Without Enrollments
SELECT s.FullName, s.Email
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.EnrollmentID IS NULL;

-- 8. Retrieve Monthly Revenue
SELECT YEAR(PaymentDate) AS Year, MONTH(PaymentDate) AS Month, SUM(AmountPaid) AS TotalRevenue
FROM Payments
GROUP BY YEAR(PaymentDate), MONTH(PaymentDate)
ORDER BY Year, Month;

-- 9. Find Students Enrolled in More Than 3 Courses
SELECT s.FullName, COUNT(e.CourseID) AS CourseCount
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
GROUP BY s.FullName
HAVING COUNT(e.CourseID) > 3;

-- 10. Retrieve Instructor-wise Course Count
SELECT i.FullName AS InstructorName, COUNT(c.CourseID) AS CourseCount
FROM Instructors i
LEFT JOIN Courses c ON i.InstructorID = c.InstructorID
GROUP BY i.FullName;

-- 11. Find Students Without Payments
SELECT s.FullName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Payments p ON s.StudentID = p.StudentID
WHERE p.PaymentID IS NULL;

-- 12. Retrieve Courses with No Enrollments
SELECT c.CourseName
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.EnrollmentID IS NULL;

-- 13. Find the Most Popular Course
SELECT TOP 1 c.CourseName, COUNT(e.EnrollmentID) AS EnrollmentCount
FROM Enrollments e
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY c.CourseName
ORDER BY EnrollmentCount DESC;

-- 14. Retrieve Students and Their Total Marks in a Course
SELECT s.FullName, c.CourseName, SUM(a.TotalMarks) AS TotalMarks
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
JOIN Assessments a ON c.CourseID = a.CourseID
GROUP BY s.FullName, c.CourseName;

-- 15. List Courses with Assessments but No Enrollments
SELECT DISTINCT c.CourseName
FROM Courses c
JOIN Assessments a ON c.CourseID = a.CourseID
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE e.EnrollmentID IS NULL;

-- 16. Retrieve Payment Status per Student
SELECT s.FullName, COUNT(e.CourseID) AS EnrolledCourses, COALESCE(SUM(p.AmountPaid), 0) AS TotalPaid
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Payments p ON s.StudentID = p.StudentID
GROUP BY s.FullName;

-- 17. Find Course Pairs with the Same Instructor
SELECT c1.CourseName AS Course1, c2.CourseName AS Course2, i.FullName AS InstructorName
FROM Courses c1
JOIN Courses c2 ON c1.InstructorID = c2.InstructorID AND c1.CourseID < c2.CourseID
JOIN Instructors i ON c1.InstructorID = i.InstructorID;

-- 18. List All Possible Student-Course Combinations
SELECT s.FullName AS StudentName, c.CourseName AS CourseName
FROM Students s
CROSS JOIN Courses c;

-- 19. Determine the Instructor with the Highest Number of Students
SELECT TOP 1 i.FullName AS InstructorName, COUNT(e.StudentID) AS TotalStudents
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName
ORDER BY TotalStudents DESC;

-- 20. Trigger to Prevent Double Enrollment
CREATE TRIGGER PreventDuplicateEnrollment
ON Enrollments
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Enrollments e
        JOIN inserted i ON e.StudentID = i.StudentID AND e.CourseID = i.CourseID
        GROUP BY e.StudentID, e.CourseID
        HAVING COUNT(*) > 1
    )
    BEGIN
        PRINT 'Error: A student cannot enroll in the same course more than once!';
        ROLLBACK TRANSACTION;
    END
END;
