--This project identifies the top-selling products as per total sales through analyzing product sales

CREATE TABLE PRODUCTS(
	product_id INT PRIMARY KEY,
	product_name VARCHAR(40),
	price DECIMAL (10, 3)
);

INSERT INTO PRODUCTS (product_id, product_name, price)
VALUES (1, 'Mango', 2.0),
		(2, 'Avocado', 3.5),
		(3, 'Pineapple', 5.5),
		(4, 'Orange', 3.0);

SELECT *
FROM PRODUCTS;

CREATE TABLE ORDERS (
	order_id INT PRIMARY KEY,
	product_id INT,
	quantity INT,
	sales DECIMAL(10, 3)
	FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
);

INSERT INTO ORDERS (order_id,product_id,quantity,sales)
VALUES (1, 1, 10, 26.0),
		(2, 1, 4, 45.0),
		(3, 2, 7, 34.0),
		(4, 3, 12, 23.0),
		(5, 4, 8, 12.0);

SELECT *
FROM ORDERS;

--Getting totalRevenue 

SELECT 
	p.product_name, SUM(o.quantity * p.price) AS total_revenue
FROM 
	PRODUCTS p
JOIN 
	ORDERS o ON p.product_id = o.product_id
GROUP BY 
	p.product_name
ORDER BY
	total_revenue DESC;

