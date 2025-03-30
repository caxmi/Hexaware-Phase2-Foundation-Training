-- Create Employees Table

CREATE TABLE employees (
    employee_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Insert Updated Sample Employees (Popular & Cute Names)
INSERT INTO employees (name, department, email, password) VALUES
('Aarav Kumar', 'IT', 'aarav.kumar@example.com', 'passAarav123'),
('Ishaa Raj', 'Finance', 'ishaa.raj@example.com', 'secureIshaa456'),
('Akshaya Karthik', 'HR', 'akshaya.karthik@example.com', 'akshayaPass789'),
('Aditi Rao', 'Operations', 'aditi.rao@example.com', 'aditiSecure123'),
('Vivian Zayden', 'Marketing', 'vivian.zayden@example.com', 'vivian789pass'),
('Haley Pearl', 'Sales', 'haley.pearl@example.com', 'haleyPass123'),
('Riyaa Jones', 'IT', 'riyaa.jones@example.com', 'riyaa@pass456'),
('Zara Zyaana', 'Finance', 'zara.zyaana@example.com', 'zara@123'),
('Muthu Das', 'Admin', 'muthu.das@example.com', 'muthuPass999'),
('Surya Karthick', 'Operations', 'surya.karthick@example.com', 'suryaSuperPass');


-- Create Assets Table
CREATE TABLE assets (
    asset_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL,
    serial_number VARCHAR(50) UNIQUE NOT NULL,
    purchase_date DATE NOT NULL,
    location VARCHAR(100) NOT NULL,
    status VARCHAR(50) CHECK (status IN ('In Use', 'Decommissioned', 'Under Maintenance')) NOT NULL,
    owner_id INT,
    FOREIGN KEY (owner_id) REFERENCES employees(employee_id)
);

-- Insert Sample Assets
INSERT INTO assets (name, type, serial_number, purchase_date, location, status, owner_id) VALUES
('Dell XPS 15', 'Laptop', 'DLXPS12345', '2023-01-10', 'Chennai Office', 'In Use', 1),
('Toyota Innova', 'Vehicle', 'TN09AB5678', '2022-05-20', 'Mumbai Branch', 'In Use', 2),
('HP LaserJet Printer', 'Equipment', 'PR99876', '2021-11-15', 'Delhi HQ', 'Under Maintenance', 3),
('MacBook Air', 'Laptop', 'MBA2023IND', '2023-08-01', 'Bangalore Office', 'In Use', 4),
('Lenovo ThinkPad', 'Laptop', 'THINK56789', '2022-03-11', 'Pune HQ', 'In Use', 5),
('Honda City', 'Vehicle', 'MH12XY7890', '2020-06-21', 'Chennai Office', 'Decommissioned', 6),
('iPad Pro', 'Tablet', 'IPADPRO1234', '2023-05-17', 'Hyderabad Branch', 'In Use', 7),
('Samsung Monitor', 'Monitor', 'SAMMON2024', '2024-02-09', 'Delhi HQ', 'In Use', 8),
('Asus Gaming Laptop', 'Laptop', 'ASUSGAMER99', '2022-12-15', 'Bangalore Office', 'In Use', 9),
('Tesla Model 3', 'Vehicle', 'KA01TESLA99', '2024-01-22', 'Mumbai Branch', 'Under Maintenance', 10);

-- Create Maintenance Records Table
CREATE TABLE maintenance_records (
    maintenance_id INT PRIMARY KEY IDENTITY(1,1),
    asset_id INT,
    maintenance_date DATE NOT NULL,
    description TEXT NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id)
);

-- Insert Sample Maintenance Records
INSERT INTO maintenance_records (asset_id, maintenance_date, description, cost) VALUES
(1, '2024-02-01', 'Replaced battery', 5000.00),
(2, '2024-01-15', 'Car Servicing and Oil Change', 8000.00),
(3, '2023-12-10', 'Printer head replacement', 2500.00),
(4, '2023-07-20', 'MacBook Screen Repair', 12000.00),
(5, '2023-09-05', 'Lenovo Keyboard Replacement', 3500.00),
(6, '2023-11-18', 'Honda City Engine Repair', 18000.00),
(7, '2024-01-08', 'iPad Display Replacement', 9500.00),
(8, '2024-03-12', 'Samsung Monitor Stand Repair', 3000.00),
(9, '2024-02-22', 'Asus Laptop Cooling Fan Replacement', 4200.00),
(10, '2024-02-28', 'Tesla Software Update', 0.00);

-- Create Asset Allocations Table
CREATE TABLE asset_allocations (
    allocation_id INT PRIMARY KEY IDENTITY(1,1),
    asset_id INT,
    employee_id INT,
    allocation_date DATE NOT NULL,
    return_date DATE NULL,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Insert Sample Asset Allocations
INSERT INTO asset_allocations (asset_id, employee_id, allocation_date, return_date) VALUES
(1, 1, '2024-02-01', NULL),
(2, 2, '2024-01-15', '2024-03-15'),
(3, 3, '2023-12-10', NULL),
(4, 4, '2023-07-20', NULL),
(5, 5, '2023-09-05', '2024-02-10'),
(6, 6, '2023-11-18', NULL),
(7, 7, '2024-01-08', NULL),
(8, 8, '2024-03-12', NULL),
(9, 9, '2024-02-22', '2024-03-20'),
(10, 10, '2024-02-28', NULL);

-- Create Reservations Table
CREATE TABLE reservations (
    reservation_id INT PRIMARY KEY IDENTITY(1,1),
    asset_id INT,
    employee_id INT,
    reservation_date DATE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) CHECK (status IN ('Pending', 'Approved', 'Canceled')) NOT NULL,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Insert Sample Reservations
INSERT INTO reservations (asset_id, employee_id, reservation_date, start_date, end_date, status) VALUES
(1, 2, '2024-03-10', '2024-03-15', '2024-03-30', 'Approved'),
(3, 4, '2024-02-20', '2024-02-25', '2024-03-10', 'Canceled'),
(5, 6, '2024-01-15', '2024-01-20', '2024-02-05', 'Approved'),
(7, 8, '2024-02-01', '2024-02-05', '2024-02-20', 'Pending'),
(9, 10, '2024-03-05', '2024-03-10', '2024-03-25', 'Approved'),
(2, 1, '2024-01-30', '2024-02-05', '2024-02-15', 'Canceled'),
(4, 3, '2024-02-15', '2024-02-20', '2024-02-28', 'Pending'),
(6, 5, '2024-03-01', '2024-03-10', '2024-03-20', 'Approved'),
(8, 7, '2024-02-25', '2024-03-01', '2024-03-15', 'Approved'),
(10, 9, '2024-03-12', '2024-03-18', '2024-04-02', 'Pending');

