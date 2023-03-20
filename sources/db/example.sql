-- Table structure for table employees
CREATE TABLE employees (
id int(11) NOT NULL,
name varchar(255) NOT NULL,
email varchar(255) NOT NULL,
salary decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--

-- Dumping data for table employees
INSERT INTO employees (id, name, email, salary) VALUES
(1, 'John Smith', 'john.smith@example.com', 50000.00),
(2, 'Jane Doe', 'jane.doe@example.com', 60000.00),
(3, 'Bob Johnson', 'bob.johnson@example.com', 45000.00),
(4, 'Sara Lee', 'sara.lee@example.com', 55000.00);

--

-- Indexes for table employees
ALTER TABLE employees
ADD PRIMARY KEY (id);

--

-- AUTO_INCREMENT for table employees
ALTER TABLE employees
MODIFY id int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;
