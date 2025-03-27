-- 1. Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'HotelManagementDB')
BEGIN
    CREATE DATABASE HotelManagementDB;
END
GO
USE HotelManagementDB;

-- 2. Create Tables
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Hotels')
BEGIN
    CREATE TABLE Hotels (
        HotelID INT PRIMARY KEY IDENTITY(1,1),
        Name VARCHAR(255) NOT NULL,
        Location VARCHAR(255) NOT NULL,
        Rating DECIMAL(2,1) CHECK (Rating BETWEEN 1 AND 5)
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Rooms')
BEGIN
    CREATE TABLE Rooms (
        RoomID INT PRIMARY KEY IDENTITY(1,1),
        HotelID INT FOREIGN KEY REFERENCES Hotels(HotelID),
        RoomNumber VARCHAR(50) NOT NULL,
        RoomType VARCHAR(50) NOT NULL,
        PricePerNight DECIMAL(10,2) NOT NULL,
        Available BIT NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Guests')
BEGIN
    CREATE TABLE Guests (
        GuestID INT PRIMARY KEY IDENTITY(1,1),
        FullName VARCHAR(255) NOT NULL,
        Email VARCHAR(255) UNIQUE NOT NULL,
        PhoneNumber VARCHAR(50) UNIQUE NOT NULL,
        CheckInDate DATETIME,
        CheckOutDate DATETIME
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Bookings')
BEGIN
    CREATE TABLE Bookings (
        BookingID INT PRIMARY KEY IDENTITY(1,1),
        GuestID INT FOREIGN KEY REFERENCES Guests(GuestID),
        RoomID INT FOREIGN KEY REFERENCES Rooms(RoomID),
        BookingDate DATETIME NOT NULL,
        TotalAmount DECIMAL(10,2) NOT NULL,
        Status VARCHAR(50) CHECK (Status IN ('Confirmed', 'Cancelled', 'Checked Out'))
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Payments')
BEGIN
    CREATE TABLE Payments (
        PaymentID INT PRIMARY KEY IDENTITY(1,1),
        BookingID INT FOREIGN KEY REFERENCES Bookings(BookingID),
        AmountPaid DECIMAL(10,2) NOT NULL,
        PaymentDate DATETIME NOT NULL,
        PaymentMethod VARCHAR(50) NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Events')
BEGIN
    CREATE TABLE Events (
        EventID INT PRIMARY KEY IDENTITY(1,1),
        HotelID INT FOREIGN KEY REFERENCES Hotels(HotelID),
        EventName VARCHAR(255) NOT NULL,
        EventDate DATETIME NOT NULL,
        Venue VARCHAR(255) NOT NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EventParticipants')
BEGIN
    CREATE TABLE EventParticipants (
        ParticipantID INT PRIMARY KEY IDENTITY(1,1),
        ParticipantName VARCHAR(255) NOT NULL,
        ParticipantType VARCHAR(50) CHECK (ParticipantType IN ('Guest', 'Organization')),
        EventID INT FOREIGN KEY REFERENCES Events(EventID)
    );
END

INSERT INTO Hotels (Name, Location, Rating) VALUES
('Chozha Grand', 'Thanjavur', 4.8),
('Kumarakom Heritage', 'Kanyakumari', 4.5),
('Meenakshi Palace', 'Madurai', 4.9),
('Marina Bay Resort', 'Chennai', 4.7);

INSERT INTO Rooms (HotelID, RoomNumber, RoomType, PricePerNight, Available) VALUES
(1, '101A', 'Suite', 2500.00, 1),
(1, '102B', 'Double', 1800.00, 0),
(2, '201C', 'Single', 1200.00, 1),
(3, '301D', 'Suite', 3000.00, 1),
(4, '401E', 'Double', 2200.00, 1);

INSERT INTO Guests (FullName, Email, PhoneNumber, CheckInDate, CheckOutDate) VALUES
('Arunachalam Venkatesan', 'arun.venkat@example.com', '9845123456', '2025-03-10', '2025-03-15'),
('Lakshmi Narayanan', 'lakshmi.narayan@example.com', '9876543210', '2025-03-12', '2025-03-18'),
('Meera Chandran', 'meera.chandran@example.com', '9090909090', '2025-03-05', '2025-03-10');

INSERT INTO Bookings (GuestID, RoomID, BookingDate, TotalAmount, Status) VALUES
(1, 1, '2025-03-01', 12500.00, 'Confirmed'),
(2, 2, '2025-03-05', 9000.00, 'Checked Out'),
(3, 3, '2025-03-03', 6000.00, 'Confirmed');

INSERT INTO Payments (BookingID, AmountPaid, PaymentDate, PaymentMethod) VALUES
(1, 12500.00, '2025-03-02', 'Credit Card'),
(2, 9000.00, '2025-05-06', 'Cash'),
(3, 6000.00, '2025-06-04', 'Debit Card');

INSERT INTO Events (HotelID, EventName, EventDate, Venue) VALUES
(1, 'Thanjavur Cultural Fest', '2025-04-20', 'Chozha Grand Hall'),
(2, 'Kanyakumari Sunset Carnival', '2025-05-10', 'Heritage Beachfront'),
(3, 'Madurai Temple Festival', '2025-06-15', 'Meenakshi Mahal');

INSERT INTO EventParticipants (ParticipantName, ParticipantType, EventID) VALUES
('Raghunathan Iyer', 'Guest', 1),
('South Indian Classical Society', 'Organization', 2),
('Ananya Krishnan', 'Guest', 3);

-- 4. Retrieve available rooms for booking
SELECT * FROM Rooms WHERE Available = 1;

-- 5. Retrieve names of participants for a specific event

CREATE PROCEDURE GetEventParticipants @EventID INT
AS
BEGIN
    SELECT ParticipantName FROM EventParticipants WHERE EventID = @EventID;
END;
EXEC GetEventParticipants @EventID = 1;

-- 6. Stored Procedure to update hotel information
DROP PROCEDURE UpdateHotelInfo
CREATE PROCEDURE UpdateHotelInfo @HotelID INT, @NewName VARCHAR(255), @NewLocation VARCHAR(255)
AS
BEGIN
    UPDATE Hotels SET Name = @NewName, Location = @NewLocation WHERE HotelID = @HotelID;
END;

-- 7. Calculate total revenue per hotel from confirmed bookings
SELECT h.HotelID, h.Name, SUM(b.TotalAmount) AS TotalRevenue
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
JOIN Bookings b ON r.RoomID = b.RoomID
WHERE b.Status = 'Confirmed'
GROUP BY h.HotelID, h.Name;

-- 8. Find rooms that have never been booked
SELECT * FROM Rooms WHERE RoomID NOT IN (SELECT RoomID FROM Bookings);

-- 9. Retrieve total payments per month and year
SELECT YEAR(PaymentDate) AS Year, MONTH(PaymentDate) AS Month, SUM(AmountPaid) AS TotalPayments
FROM Payments
GROUP BY YEAR(PaymentDate), MONTH(PaymentDate)
ORDER BY Year, Month;

-- 10. Retrieve room types priced between $50 and $150 or above $300
SELECT DISTINCT RoomType FROM Rooms WHERE PricePerNight BETWEEN 50 AND 150 OR PricePerNight > 300;

-- 11. Retrieve occupied rooms with guests
SELECT r.RoomID, r.RoomNumber, g.FullName
FROM Rooms r
JOIN Bookings b ON r.RoomID = b.RoomID
JOIN Guests g ON b.GuestID = g.GuestID
WHERE b.Status = 'Confirmed';

-- 12. Count total participants in events held in a specific city
CREATE PROCEDURE GetEventParticipantsByCity @CityName VARCHAR(255)
AS
BEGIN
    SELECT COUNT(ep.ParticipantID) AS TotalParticipants
    FROM Events e
    JOIN EventParticipants ep ON e.EventID = ep.EventID
    WHERE e.Venue = @CityName;
END;
EXEC GetEventParticipantsByCity @CityName = 'Chozha Grand Hall';

-- 13. Retrieve unique room types in a specific hotel
SELECT DISTINCT RoomType
FROM Rooms
WHERE HotelID = 1 AND Available = 1;

-- 14. Find guests who have never made a booking
SELECT * FROM Guests WHERE GuestID NOT IN (SELECT GuestID FROM Bookings);

-- 15. Retrieve booked rooms along with guest names
SELECT r.RoomNumber, g.FullName FROM Bookings b
JOIN Rooms r ON b.RoomID = r.RoomID
JOIN Guests g ON b.GuestID = g.GuestID;

-- 16. Retrieve all hotels with count of available rooms
SELECT h.Name, COUNT(r.RoomID) AS AvailableRooms FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
WHERE r.Available = 1 GROUP BY h.Name;

-- 17. Find pairs of rooms from the same hotel of the same type
SELECT r1.RoomID AS Room1, r2.RoomID AS Room2, r1.HotelID, r1.RoomType
FROM Rooms r1
JOIN Rooms r2 ON r1.HotelID = r2.HotelID AND r1.RoomType = r2.RoomType AND r1.RoomID < r2.RoomID;

-- 18. List all combinations of hotels and events
SELECT h.Name AS HotelName, e.EventName FROM Hotels h CROSS JOIN Events e;

-- 19. Determine the hotel with the highest number of bookings
SELECT TOP 1 h.HotelID, h.Name, COUNT(b.BookingID) AS BookingCount
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
JOIN Bookings b ON r.RoomID = b.RoomID
GROUP BY h.HotelID, h.Name
ORDER BY BookingCount DESC;
