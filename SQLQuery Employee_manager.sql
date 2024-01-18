--This investiagtes employee earnings which are more than their managers

CREATE TABLE Employees(
	Emp_id INT PRIMARY KEY,
	Emp_name VARCHAR(255),
	salary INT,
	mgr_id INT
	);

INSERT INTO Employees (Emp_id, Emp_name, salary, mgr_id)
VALUES (1, 'Rashid', 8000, 5),
		(2, 'Timba', 1000, 4),
		(3, 'Pumba', 5000, NULL),
		(4, 'Victor', 7000, 4),
		(5, 'Patrice', 9000, 7),
		(6, 'Partia', 1000, 2),
		(7, 'Timon', 8000, 6);

--SELECT *
--FROM [dbo].[Employees];

SELECT 
	e.Emp_id, e.Emp_name, e.salary, e.mgr_id
FROM 
	Employees e
JOIN Employees m ON e.mgr_id = m.Emp_id
WHERE 
	e.salary > m.salary;
