--Creating the table for the Add on file (services)
CREATE TABLE services
(
	customer_id varchar (15),
	internet_service varchar (30),	
	phone varchar (5),	
	multiple varchar (5),	
	online_security varchar (5),
	online_backup varchar (5),	
	device_protection varchar (5),	
	tech_support varchar (5)
);




--SQL code that loads the data from add-on csv file into table command " 
"\\copy public.services (customer_id, internet_service, phone, multiple, online_security, online_backup, device_protection, tech_support) 
FROM 'C:/Users/alexi/Desktop/SQLDAT~1/SERVIC~1.CSV' DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""


--Looking at the services table to ensure everything was copied correctly 

SELECT *
FROM services;


--Looking at Part A of the research question

SELECT  
	internet_service,
	COUNT(*)
FROM services
GROUP BY internet_service;


--Looking at the columns table

SELECT *
FROM customer;



--PART A cont'd

SELECT  
	c.monthly_charge,
	s.internet_service
FROM customer AS c
LEFT JOIN services AS s
ON c.customer_id = s.customer_id;




--Filtering to get more specific results
SELECT  
	AVG(c.monthly_charge),
	s.internet_service
FROM customer AS c
LEFT JOIN services AS s
ON c.customer_id = s.customer_id
WHERE s.internet_service = 'Fiber Optic'
GROUP BY s.internet_service;


SELECT  
	AVG(c.monthly_charge),
	s.internet_service
FROM customer AS c
LEFT JOIN services AS s
ON c.customer_id = s.customer_id
WHERE s.internet_service = 'DSL'
GROUP BY s.internet_service;



--Looking at the third table to join
SELECT *
FROM location





--Bringing all three tables together to view the data more neatly
SELECT  
	c.monthly_charge,
	s.internet_service,
	l.state
FROM customer AS c
LEFT JOIN services AS s
ON c.customer_id = s.customer_id
LEFT JOIN location AS l
ON c.location_id = l.location_id;


--Range costs of internert service
SELECT  
	AVG(c.monthly_charge) as avg_monthly_charge,
	s.internet_service,
	l.state
FROM customer AS c
LEFT JOIN services AS s
ON c.customer_id = s.customer_id
LEFT JOIN location AS l
ON c.location_id = l.location_id
WHERE state IN ('CA', 'TX', 'FL', 'NY', 'PA')
AND s.internet_service = 'DSL'
GROUP BY 
	s.internet_service,
	l.state;





SELECT  
	AVG(c.monthly_charge) as avg_monthly_charge,
	s.internet_service,
	l.state
FROM customer AS c
LEFT JOIN services AS s
ON c.customer_id = s.customer_id
LEFT JOIN location AS l
ON c.location_id = l.location_id
WHERE state IN ('WY', 'VT', 'DC', 'AK', 'ND')
AND s.internet_service = 'DSL'
GROUP BY 
	s.internet_service,
	l.state;






--Subquery code for finding the average of the averages
SELECT AVG(avg_monthly_charge) FROM
(SELECT  
	AVG(c.monthly_charge) as avg_monthly_charge,
	s.internet_service,
	l.state
FROM customer AS c
LEFT JOIN services AS s
ON c.customer_id = s.customer_id
LEFT JOIN location AS l
ON c.location_id = l.location_id
WHERE state IN ('CA', 'TX', 'FL', 'NY', 'PA')
AND s.internet_service = 'Fiber Optic'
GROUP BY 
	s.internet_service,
	l.state) as avg_cost_state;
