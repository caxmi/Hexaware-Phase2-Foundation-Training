CREATE DATABASE HospitalManagement
USE HospitalManagement
CREATE TABLE Patient (
    patientId INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    dateOfBirth DATE,
    gender VARCHAR(10),
    contactNumber VARCHAR(15),
    address VARCHAR(255)
);

INSERT INTO Patient VALUES
(101, 'Arjun', 'Krishna', '1994-03-15', 'Male', '9876543210', '12 MG Road, Bengaluru'),
(102, 'Keerthi', 'Ramesh', '1997-07-22', 'Female', '9876543211', '45 T Nagar, Chennai'),
(103, 'Rohit', 'Menon', '1989-11-05', 'Male', '9876543212', '89 Kakkanad, Kochi'),
(104, 'Ananya', 'Murthy', '1995-01-28', 'Female', '9876543213', '110 Jubilee Hills, Hyderabad'),
(105, 'Harsha', 'Vijay', '1992-05-09', 'Male', '9876543214', '22 Banjara Hills, Hyderabad'),
(106, 'Meera', 'Suresh', '1996-08-13', 'Female', '9876543215', '76 Indiranagar, Bengaluru'),
(107, 'Karthik', 'Rao', '1990-12-17', 'Male', '9876543216', '34 Anna Nagar, Chennai'),
(108, 'Sneha', 'Pillai', '1993-09-30', 'Female', '9876543217', '60 Vellayambalam, Trivandrum'),
(109, 'Varun', 'Sundar', '1988-02-04', 'Male', '9876543218', '5 Ashok Nagar, Chennai'),
(110, 'Divya', 'Mohan', '1999-06-21', 'Female', '9876543219', '150 HSR Layout, Bengaluru');

CREATE TABLE Doctor (
    doctorId INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    specialization VARCHAR(100),
    contactNumber VARCHAR(15)
);

INSERT INTO Doctor VALUES
(201, 'Dr. Nithya', 'Narayanan', 'Cardiologist', '9000011111'),
(202, 'Dr. Ajay', 'Sankar', 'Neurologist', '9000011112'),
(203, 'Dr. Priya', 'Jayaram', 'Dermatologist', '9000011113'),
(204, 'Dr. Vignesh', 'Balaji', 'Orthopedic', '9000011114'),
(205, 'Dr. Lakshmi', 'Iyer', 'Pediatrician', '9000011115'),
(206, 'Dr. Aravind', 'Raj', 'ENT Specialist', '9000011116'),
(207, 'Dr. Shruti', 'Anand', 'Gynecologist', '9000011117'),
(208, 'Dr. Manoj', 'Menon', 'Oncologist', '9000011118'),
(209, 'Dr. Deepa', 'Varma', 'General Physician', '9000011119'),
(210, 'Dr. Sathish', 'Muralidharan', 'Gastroenterologist', '9000011120');

CREATE TABLE Appointment (
    appointmentId INT PRIMARY KEY,
    patientId INT FOREIGN KEY REFERENCES Patient(patientId),
    doctorId INT FOREIGN KEY REFERENCES Doctor(doctorId),
    appointmentDate DATETIME,
    description VARCHAR(255)
);

INSERT INTO Appointment VALUES
(301, 101, 201, '2025-04-18 10:00:00', 'Routine heart check-up'),
(302, 102, 202, '2025-04-19 11:30:00', 'Migraine consultation'),
(303, 103, 203, '2025-04-20 09:45:00', 'Skin rash evaluation'),
(304, 104, 204, '2025-04-21 15:00:00', 'Joint pain follow-up'),
(305, 105, 205, '2025-04-22 10:15:00', 'Pediatric vaccine consultation'),
(306, 106, 206, '2025-04-23 14:00:00', 'Hearing loss review'),
(307, 107, 207, '2025-04-24 13:45:00', 'Prenatal check-up'),
(308, 108, 208, '2025-04-25 12:00:00', 'Cancer screening'),
(309, 109, 209, '2025-04-26 16:30:00', 'General health check-up'),
(310, 110, 210, '2025-04-27 11:15:00', 'Stomach pain diagnosis');

SELECT * FROM Appointment