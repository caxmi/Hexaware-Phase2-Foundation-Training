-- Step 1: Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'PetCare')
CREATE DATABASE PetCare;
GO
USE PetCare;
GO

-- Step 2: Drop existing tables (if any)
IF OBJECT_ID('Pets', 'U') IS NOT NULL DROP TABLE Pets;
IF OBJECT_ID('Shelters', 'U') IS NOT NULL DROP TABLE Shelters;
IF OBJECT_ID('Donations', 'U') IS NOT NULL DROP TABLE Donations;
IF OBJECT_ID('AdoptionEvents', 'U') IS NOT NULL DROP TABLE AdoptionEvents;
IF OBJECT_ID('Participants', 'U') IS NOT NULL DROP TABLE Participants;
GO

-- Step 3: Create Tables
CREATE TABLE Shelters (
    ShelterID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Location NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Pets (
    PetID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL,
    Age INT CHECK (Age >= 0),
    Breed NVARCHAR(50) NOT NULL,
    Type NVARCHAR(50) NOT NULL,
    AvailableForAdoption BIT NOT NULL DEFAULT 1,
    ShelterID INT FOREIGN KEY REFERENCES Shelters(ShelterID) ON DELETE SET NULL
);

CREATE TABLE Donations (
    DonationID INT PRIMARY KEY IDENTITY(1,1),
    DonorName NVARCHAR(100) NOT NULL,
    DonationType NVARCHAR(50) NOT NULL,
    DonationAmount DECIMAL(10,2) CHECK (DonationAmount >= 0),
    DonationItem NVARCHAR(100),
    DonationDate DATE NOT NULL
);

CREATE TABLE AdoptionEvents (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    EventName NVARCHAR(100) NOT NULL,
    EventDate DATE NOT NULL,
    Location NVARCHAR(100) NOT NULL
);

CREATE TABLE Participants (
    ParticipantID INT PRIMARY KEY IDENTITY(1,1),
    ParticipantName NVARCHAR(100) NOT NULL,
    ParticipantType NVARCHAR(50) CHECK (ParticipantType IN ('Adopter', 'Volunteer', 'Sponsor')),
    EventID INT FOREIGN KEY REFERENCES AdoptionEvents(EventID) ON DELETE CASCADE
);
GO

-- Step 4: Insert Sample Data (5 Records Each)
INSERT INTO Shelters (Name, Location) VALUES
('Happy Paws Shelter', 'Chennai'),
('Blue Cross Shelter', 'Bangalore'),
('Rescue Haven', 'Hyderabad'),
('Helping Hands Shelter', 'Coimbatore'),
('Safe Haven', 'Mysore');

INSERT INTO Pets (Name, Age, Breed, Type, AvailableForAdoption, ShelterID) VALUES
('Bruno', 2, 'Labrador', 'Dog', 1, 1),
('Mithu', 1, 'Persian', 'Cat', 1, 2),
('Tommy', 5, 'Golden Retriever', 'Dog', 0, 3),
('Simba', 3, 'Siamese', 'Cat', 1, 4),
('Rocky', 6, 'Beagle', 'Dog', 0, 3);

INSERT INTO Donations (DonorName, DonationType, DonationAmount, DonationItem, DonationDate) VALUES
('Arun Kumar', 'Cash', 5000, NULL, '2025-03-01'),
('Divya Menon', 'Food', 0, 'Dog Food Pack', '2025-03-02'),
('Ramesh Babu', 'Medicine', 0, 'Vaccines', '2025-03-03'),
('Sneha Nair', 'Cash', 2500, NULL, '2025-03-04'),
('Vikram Raj', 'Food', 0, 'Cat Food Pack', '2025-03-05');

INSERT INTO AdoptionEvents (EventName, EventDate, Location) VALUES
('Pet Adoption Drive', '2025-04-10', 'Chennai'),
('Rescue & Adopt', '2025-04-15', 'Bangalore'),
('Stray Help', '2025-04-20', 'Hyderabad'),
('Animal Welfare Meet', '2025-04-25', 'Coimbatore'),
('Furry Friends Event', '2025-04-30', 'Mysore');

INSERT INTO Participants (ParticipantName, ParticipantType, EventID) VALUES
('Karthik Srinivasan', 'Adopter', 1),
('Meera Rajan', 'Volunteer', 2),
('Suresh Menon', 'Sponsor', 3),
('Lakshmi Narayan', 'Adopter', 4),
('Anand Kumar', 'Volunteer', 5);
GO

-- 3. Retrieve Available Pets
SELECT Name, Age, Breed, Type 
FROM Pets 
WHERE AvailableForAdoption = 1;

-- 4. Retrieve Event Participants
SELECT ParticipantName, ParticipantType 
FROM Participants 
WHERE EventID = 1;

-- 5. Update Shelter Information (Stored Procedure)
CREATE PROCEDURE UpdateShelter
    @ShelterID INT,
    @NewName NVARCHAR(100),
    @NewLocation NVARCHAR(100)
AS
BEGIN
    UPDATE Shelters 
    SET Name = @NewName, Location = @NewLocation 
    WHERE ShelterID = @ShelterID;
END;
GO
EXEC UpdateShelter @ShelterID = 1, @NewName = 'New Happy Paws Shelter', @NewLocation = 'Chennai Central';


-- 6. Calculate Shelter Donations
SELECT s.Name AS ShelterName, COALESCE(SUM(d.DonationAmount), 0) AS TotalDonation
FROM Shelters s
LEFT JOIN Donations d ON s.ShelterID = d.DonationID
GROUP BY s.Name;

-- 7. Retrieve Pets Without Owners
ALTER TABLE Pets
ADD OwnerID INT NULL;
SELECT *FROM Pets
WHERE OwnerID IS NULL;
-- 8. Monthly Donation Summary
SELECT YEAR(DonationDate) AS Year, MONTH(DonationDate) AS Month, SUM(DonationAmount) AS TotalDonations
FROM Donations
GROUP BY YEAR(DonationDate), MONTH(DonationDate);

-- 9. Filter Pets by Age
SELECT DISTINCT Breed 
FROM Pets 
WHERE Age BETWEEN 1 AND 3 OR Age > 5;

-- 10. Pets and Their Shelters
SELECT p.Name AS PetName, s.Name AS ShelterName 
FROM Pets p
JOIN Shelters s ON p.ShelterID = s.ShelterID
WHERE p.AvailableForAdoption = 1;

-- 11. Count Event Participants by City
SELECT a.Location, COUNT(p.ParticipantID) AS TotalParticipants 
FROM AdoptionEvents a
JOIN Participants p ON a.EventID = p.EventID
WHERE a.Location = 'Chennai'
GROUP BY a.Location;

-- 12. Unique Breeds of Young Pets
SELECT DISTINCT Breed 
FROM Pets 
WHERE Age BETWEEN 1 AND 5;

-- 13. Find Pets Not Yet Adopted
SELECT * FROM Pets WHERE AvailableForAdoption = 1;

-- 14. Retrieve Adopted Pets and Adopters
SELECT p.Name AS PetName, pa.ParticipantName AS Adopter
FROM Participants pa
JOIN AdoptionEvents ae ON pa.EventID = ae.EventID
JOIN Pets p ON p.ShelterID = ae.EventID
WHERE pa.ParticipantType = 'Adopter';

-- 15. Count Available Pets in Shelters
SELECT s.Name AS ShelterName, COUNT(p.PetID) AS AvailablePets
FROM Shelters s
JOIN Pets p ON s.ShelterID = p.ShelterID
WHERE p.AvailableForAdoption = 1
GROUP BY s.Name;

-- 16. Find Matching Pet Pairs in Shelters
SELECT p1.Name AS Pet1, p2.Name AS Pet2, p1.Breed, s.Name AS Shelter
FROM Pets p1
JOIN Pets p2 ON p1.ShelterID = p2.ShelterID 
AND p1.Breed = p2.Breed 
AND p1.PetID < p2.PetID
JOIN Shelters s ON p1.ShelterID = s.ShelterID;

-- 17. Find All Shelter-Event Combinations
SELECT s.Name AS ShelterName, ae.EventName AS EventName
FROM Shelters s
CROSS JOIN AdoptionEvents ae;

-- 18. Identify the Most Successful Shelter
SELECT TOP 1 s.Name AS ShelterName, COUNT(p.PetID) AS AdoptedPets
FROM Shelters s
JOIN Pets p ON s.ShelterID = p.ShelterID
WHERE p.AvailableForAdoption = 0  
GROUP BY s.Name
ORDER BY COUNT(p.PetID) DESC;


-- 19. Trigger: Update Adoption Status
CREATE TRIGGER UpdateAdoptionStatus
ON Participants
AFTER INSERT
AS
BEGIN
    UPDATE Pets
    SET AvailableForAdoption = 0
    WHERE PetID IN (SELECT PetID FROM inserted);
END;

-- 20. Data Integrity Check: Prevent Duplicate Adoptions
ALTER TABLE Participants
ADD CONSTRAINT UniqueAdoption UNIQUE (ParticipantName, EventID);
GO

-- Testing: Insert Adopters
INSERT INTO Participants (ParticipantName, ParticipantType, EventID)
VALUES ('Rajesh Iyer', 'Adopter', 1); -- Should succeed

INSERT INTO Participants (ParticipantName, ParticipantType, EventID)
VALUES ('Rajesh Iyer', 'Adopter', 1); -- Should fail due to UniqueAdoption constraint



