-------------------------------------------INSERCIÓ------------------------------

-- 1.Genera les sentències SQL necessàries per inserir les següents dades:

-- Un nou client amb dades completament inventades.
INSERT INTO customers (customernumber, customername, contactlastname, contactfirstname, phone, addressline1, addressline2, city, state, postalcode, country,salesrepemployeenumber)
VALUES ('11', 'Los taquitos de Doña Pelos', 'Garza', 
'Julian', '622384201', '52, Culiacán','Lalalal', 'Sinaloa','Sina',
 '81910', 'Mexico','1611');
-- Una nova comanda realitzada pel nou client que contenen els següents productes (el preu de cada producte és el buyPrice):
UPDATE products
SET quantityinstock = '4'
WHERE productcode =' S12_3891';

UPDATE products
SET quantityinstock = '5'
WHERE productcode ='S12_3148';

UPDATE products
SET quantityinstock = '10'
WHERE productcode ='S10_1949';

-- Un nou pagament amb la quantitat total que correspongui.
INSERT INTO orderdetails (ordernumber, productcode, quantityordered, priceeach, orderlinenumber)
VALUES ('11110', 'S18_4409','988794616130', '75.46','5');


--Modifica la BD per descomptar un 50% al buyPrice de tots els productes de la línia “Trains”

UPDATE products 
SET 
    buyPrice = ROUND(buyPrice * 0.5)
WHERE
    productLine = 'Trains';

-- Assigna a cada fila un email on el nom serà la primera lletra del nom seguit d’un ‘_’, 
-- el cognom, un altre ‘_’ i el país en
--  minúscula i el domini vehiclesminiatures.com.
UPDATE employees
        NATURAL JOIN
    offices 
SET 
    email = CONCAT(LEFT(firstName, 1),
            '_',
            lastName,
            '_',
            country,
            '@vehiclesminiatura.com');

--En esta query me daba mal las mayúsculas así que usé una query adicional para arreglar ese problema. 

UPDATE employees 
SET 
    email = (LOWER(email))



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------  CONSULTES  ---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--1. Retorna un llistat el telèfon, direcció completa i estat de les oficines d’Estats Units

SELECT 
    phone, addressline1, addressline2
FROM
    offices
WHERE
    country = 'USA';

-- 2. Mostra un llistat dels empleats que no tenen responsabilitat sobre cap altre empleat (és a dir, que no són caps de ningú).

SELECT 
    employeeNumber, firstName, lastName
FROM
    employees
WHERE
    employeeNumber NOT IN (SELECT DISTINCT
            reportsTo
        FROM
            employees
        WHERE
            reportsTo IS NOT NULL);

--3. Mostra un llistat dels 4 països d’origen dels clients més freqüents.
SELECT 
    COUNT(customers.country) AS pedidos, country
FROM
    customers
        INNER JOIN
    orders ON customers.customerNumber = orders.customerNumber
GROUP BY customers.contactFirstName
ORDER BY pedidos DESC
LIMIT 4;

-- 4. Fes un ranking (mostrant el nom del client) dels 10 clients 
-- que més doblers han gastat en total, ordenats descendentment pel total.

SELECT 
    c.customerName, MAX(payments.amount) AS tot_payments
FROM
    customers
        JOIN
    payments ON payments.customerNumber = c.customerNumber
GROUP BY 1
HAVING tot_payments
ORDER BY 2 DESC
LIMIT 10;

--5. Fes un ranking (mostrant el nom del client) dels 10 clients que més comandes
-- han realitzat (independentment de doblers),  
-- ordenat descendentment pel nombre de comandes.
SELECT 
    customers.customerNumber,
    customers.contactFirstName,
    COUNT(orders.orderNumber) AS totalPedidos
FROM
    customers
        INNER JOIN
    orders ON customers.customerNumber = orders.customerNumber
GROUP BY customerNumber
ORDER BY totalPedidos DESC
LIMIT 10;
 
--6. Calcula el preu total de la comanda 10100.

SELECT 
    SUM(quantityOrdered * priceEach) AS total_comanda
FROM
    orderdetails
WHERE
    orderNumber = 10100;

--7. Retorna una llista que mostri el nombre de comanda 
-- i el total a pagar de cada comanda (com a l’exemple anterior però en general).

SELECT 
    orderNumber as comanda, 
    SUM(quantityOrdered * priceEach) total
FROM
    orderdetails
GROUP BY 
    orderNumber;

--8. Troba qui és el client que ha fet la comanda més gran (en quant a doblers).
SELECT 
    customers.customerName,
    orders.orderNumber,
    orderdetails.priceEach
FROM
    customers
        NATURAL JOIN
    orders
        NATURAL JOIN
    orderdetails
ORDER BY priceEach DESC
LIMIT 1;


--9. Retorna una llista que mostri el millor empleat de cada oficina 
-- (el millor empleat és l’empleat que més clients ha atès) 
-- juntament amb el seu responsable.

SELECT 
    emp.firstName empl_nombre,
    emp.lastName empl_apellido,
    boss.firstName boss_nombre,
    boss.lastName boss_apellido,
    oficina,
    maxoficina
FROM
    employees emp,
    employees boss,
    (SELECT 
        empleado, oficina, MAX(recuento) AS maxoficina
    FROM
        (SELECT 
        empleado, oficina, COUNT(cliente) AS recuento
    FROM
        (SELECT 
        employees.employeeNumber AS empleado,
            employees.officeCode AS oficina,
            customers.customerNumber AS cliente
    FROM
        customers, offices, employees
    WHERE
        employees.officeCode = offices.officeCode
            AND customers.salesrepemployeenumber = employees.employeenumber) clientes
    GROUP BY oficina , empleado) sumaclientes
    GROUP BY oficina) ranking
WHERE
    ranking.empleado = emp.employeeNumber
        AND emp.reportsTo = boss.employeenumber



--10. Retorna una llista que mostri quants productes tenim per cada línia de productes.

SELECT 
    productLine,productName 
FROM 
    Products
ORDER BY 1, 2;

--11. Retorna el producte amb major stock.

SELECT 
    productname AS nombre_producto, quantityinstock
FROM
    Products
WHERE
    quantityinstock > 1000;

--12. Retorna les oficines on no treballen cap dels empleats que hagin estat 
-- els representants de vendes d'algun client que hagi comprat algun producte de la línia ‘Planes’.

SELECT 
    officeCode, country
FROM
    offices
        NATURAL JOIN
    employees
WHERE
    employeeNumber NOT IN (SELECT 
            officeCode
        FROM
            products
                NATURAL JOIN
            orders
                NATURAL JOIN
            customers
                INNER JOIN
            employees ON employees.employeeNumber = customers.salesRepEmployeeNumber
        WHERE
            productLine = 'planes');


--13. Mostra les comandes que han estat enviades (shipped) més tard de la data 
-- requerida i quants de dies s’han estat endarrerit. .

SELECT 
    ordernumber, DATEDIFF(shippeddate, requireddate) as dies
FROM 
    Orders
WHERE 
    shippeddate > requireddate;

--14. Retorna una llista que mostri el total d’ingressos obtinguts a cada any.
SELECT 
    YEAR(o.orderDate) AS orderYear,
    COUNT(b.orderNumber) AS order_number,
    FORMAT(SUM(b.total_quantity), 0) AS order_quantity,
    FORMAT(SUM(b.amount_product), 0) AS order_amount
FROM
    orders o
        JOIN
    (SELECT 
        od.orderNumber,
            SUM(od.quantityOrdered) AS total_quantity,
            SUM((od.quantityOrdered * od.priceEach)) AS amount_product
    FROM
        orderdetails od
    GROUP BY od.orderNumber) b ON o.orderNumber = b.orderNumber
GROUP BY YEAR(o.orderDate);

--15. Quin és el producte més popular? (Del que més unitats s’han comprat)
SELECT 
    orderdetails.productCode,
    products.productName,
    orderdetails.quantityOrdered
FROM
    orderdetails
        INNER JOIN
    products ON orderdetails.productCode = products.productCode
ORDER BY quantityOrdered DESC
LIMIT 1;

--16. Retorna un llistat amb tots els productes que pertanyen a la línia ‘Trains’
--  i que tenen més unitats en estoc que la mitja dels productes de la mateixa línia. 
--El llistat haurà d'estar ordenat pel seu preu de venda, mostrant en primer lloc els de major preu.
SELECT 
    productLine, productName, buyPrice, quantityInStock
FROM
    products
WHERE
    (productLine = 'Trains')
        && (quantityInStock > (SELECT 
            AVG(quantityInStock)
        FROM
            products))
ORDER BY buyPrice DESC;


--17. Retorna la llista de noms de productes que siguin motocicletes, ordenades descendentment per any del model.
SELECT 
    productName AS MOTOCICLETAS
FROM
    products
WHERE
    productLine = 'Motorcycles'
ORDER BY productName DESC;

--18. Retorna el nom dels productes que costen (buyPrice) entre 60$ i 80$ inclòs.
SELECT 
    *
FROM
    products
WHERE
    buyPrice BETWEEN 59.99 AND 79.99
ORDER BY buyPrice ASC;

--19. Mostra quin es el producte que més ingresos ha produït.
SELECT 
    products.productName,
    orderdetails.productCode,
    orderdetails.quantityOrdered * orderdetails.priceEach AS total
FROM
    orderdetails
        INNER JOIN
    products ON orderdetails.productCode = products.productCode
ORDER BY total DESC
LIMIT 1;

--20. Mostra el nom complet de l’empleat que menys clients ha atès.
SELECT 
    employees.firstName,
    employees.lastName,
    COUNT(customers.salesRepEmployeeNumber) AS clientesAtendidos
FROM
    customers
        INNER JOIN
    employees ON customers.salesRepEmployeeNumber = employees.employeeNumber
GROUP BY salesRepEmployeeNumber
ORDER BY clientesAtendidos ASC
LIMIT 1;

--21. Aconsegueix un llistat amb el nom de cada client i el nom i cognom del seu representant de vendes.
SELECT 
    customers.contactFirstName AS NombreCliente,
    employees.firstName AS NombreRep,
    employees.lastName AS ApellidoRep
FROM
    employees
        INNER JOIN
    customers ON employees.employeeNumber = customers.salesRepEmployeeNumber;


--22. Llista les oficines que tenguin clients de USA.
SELECT 
    offices.officeCode,
    customers.contactFirstName,
    customers.contactLastName
FROM
    offices
        NATURAL JOIN
    employees
        NATURAL JOIN
    customers
WHERE
    customers.country = 'USA'
;

--23. Retorna el codi de client, el nom, el telèfon, el nom i llinatges de l’empleat representant de vendes del client (si no en té d’assignats ha de sortir null)
SELECT 
    customerNumber,
    customerName,
    phone teléfono,
    CONCAT(e.firstName, ' ', e.lastName) AS 'representanteVentas'
FROM
    customers
        INNER JOIN
    employees e ON customers.salesRepEmployeeNumber = e.employeeNumber;

--24. Retorna el llistat de clients indicant el nom de el client 
-- i quants comandes ha realitzat. Recordeu que poden existir clients que no 
-- han realitzat cap comanda.

SELECT 
    COUNT(*) AS totalOrdersAmount,
    SUM(quantityordered * priceeach) AS total,
    customername
FROM
    Customers
        NATURAL JOIN
    Orders
        NATURAL JOIN
    OrderDetails
GROUP BY customername
HAVING SUM(quantityordered * priceeach); 

--25. Crea una vista a partir de la consulta 24.
CREATE VIEW consulta24
AS SELECT 
    COUNT(*) AS totalOrdersAmount,
    SUM(quantityordered * priceeach) AS total,
    customername
FROM
    Customers
        NATURAL JOIN
    Orders
        NATURAL JOIN
    OrderDetails
GROUP BY customername
HAVING SUM(quantityordered * priceeach); 
