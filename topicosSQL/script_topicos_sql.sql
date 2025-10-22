if NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'miniBD')
BEGIN
	CREATE DATABASE miniBD
	COLLATE Latin1_General_100_CI_AS_SC_UTF8;
END
GO

USE miniBD;
GO

-- Creación de tablas
IF OBJECT_ID('clientes', 'U') IS NOT NULL DROP TABLE clientes;

CREATE TABLE clientes(
	Idcliente INT not null, 
	Nombre NVARCHAR(100),
	Edad INT,
	Ciudad NVARCHAR(100)
	CONSTRAINT pk_clientes
	PRIMARY KEY (idcliente)
);
GO

IF OBJECT_ID('productos', 'U') IS NOT NULL DROP TABLE productos;

CREATE TABLE productos(
	Idproducto int primary key, 
	NombreProducto NVARCHAR(200),
	Categoria NVARCHAR(200),
	Precio DECIMAL(12,2)
);
END
GO

/*
 =========================== Inserción de registros en las tablas ==================??
*/

INSERT INTO clientes
VALUES(1, 'Ana Torres', 25, 'Ciudad de México');

INSERT INTO clientes (Idcliente, Nombre, Edad, Ciudad)
VALUES(2, 'Luis Perez', 34, 'Guadalajara');

INSERT INTO clientes (Idcliente, Edad, Nombre, Ciudad)
VALUES(3, 29, 'Soy la Vaca', NULL);

INSERT INTO clientes (Idcliente, Nombre, Edad)
VALUES(4, 'Natacha', 41);

INSERT INTO clientes (Idcliente, Nombre, Edad, Ciudad)
VALUES(5, 'Sofa Lopez', 19, 'Chapulhuacan'),
	  (6, 'Laura Hernandez', 38, NULL),
	  (7, 'Victor Trujillo', 25, 'Zacualtipan');


GO

CREATE OR ALTER PROCEDURE sp_add_customer
	@Id INT, @Nombre NVARCHAR(100), @edad INT, @ciudad NVARCHAR(100)
AS
BEGIN
	INSERT INTO clientes (Idcliente, Nombre, Edad, Ciudad)
	VALUES (@Id, @Nombre, @edad, @ciudad);
END;

EXEC sp_add_customer 8, 'Carlos Ruiz', 41, 'Monterrey'; 
EXEC sp_add_customer 9, 'Jose Angel Perez', 74, 'Salte si Puedes'; 

SELECT *
FROM clientes;

SELECT COUNT(*) AS [Número de Clientes]
FROM clientes;

-- Mostrar todos los clientes ordenados por edad de menor a mayor
SELECT UPPER (Nombre) AS [Cliente],edad, UPPER(Ciudad) AS [Ciudad]
FROM clientes
ORDER BY edad DESC;

--- Listar los clientes que viven en Guadalajara
SELECT UPPER (Nombre) AS [Cliente],edad, UPPER(Ciudad) AS [Ciudad]
FROM clientes
WHERE Ciudad = 'Guadalajara';


--Listar los clientes con una edad mayor o igual a 30 
SELECT UPPER (Nombre) AS [Cliente],edad, UPPER(Ciudad) AS [Ciudad]
FROM clientes
WHERE Edad >=30;

-- Listar los clientes cuya ciudad sea nula
SELECT UPPER (Nombre) AS [Cliente],edad, UPPER(Ciudad) AS [Ciudad]
FROM clientes
WHERE Ciudad is Null;

-- Reemplazar en la consulta las ciudades nulas por la palabra DESCONOCIDA (sin modificar los datos originales)
SELECT UPPER (Nombre) AS [Cliente],edad, ISNULL(UPPER(Ciudad), 'DESCONOCIDO') AS [ciudad]
FROM clientes;

-- Selecciona los clientes que tengan edad entre 20 y 35 y que vivan en puebla o Monterrey
SELECT UPPER (Nombre) AS [Cliente],edad, ISNULL(UPPER(Ciudad), 'DESCONOCIDO') AS [ciudad]
FROM clientes
WHERE Edad between 20 and 35
	AND 
	Ciudad IN ('Guadalajara', 'Chapuhualcan');

/*

================== Actualización de Datos ============================

*/

SELECT * 
FROM clientes;

UPDATE clientes
SET Ciudad = 'Xochitlan'
WHERE IdCliente = 5;

UPDATE clientes
SET Ciudad = 'Sin ciudad'
WHERE Ciudad IS NULL;

UPDATE clientes
SET Edad = 30
WHERE IdCliente BETWEEN 3 AND 6;

UPDATE clientes
SET Ciudad = 'Metropoli'
WHERE Ciudad IN ('ciudad de México', 'Guadalajara', 'Monterrey');

UPDATE clientes
SET Nombre = 'Juan Perez',
	Edad = 27,
	Ciudad = 'Ciudad Gotica'
WHERE IdCliente = 2;

UPDATE clientes
SET Nombre = 'Cliente Premiun'
WHERE Nombre LIKE 'A%';

UPDATE clientes
SET Nombre = 'Silver customer'
WHERE Nombre LIKE 'er%';

UPDATE clientes
SET Edad = (Edad * 2)
WHERE Edad >= 30 AND Ciudad = 'Metropili';


/*
==================== Eliminación de Datos ===========================
*/

SELECT * 
FROM clientes;

DELETE FROM clientes
WHERE Edad BETWEEN 25 AND 30;

DELETE clientes
WHERE Nombre LIKE '%r';

TRUNCATE TABLE clientes;


/*
=================== Store prosedures de update, delete y select ========================
*/

-- MODIFICA LOS DATOS POR ID
CREATE OR ALTER PROCEDURE sp_update_customers
	@id INT,
	@nombre NVARCHAR(100),
	@edad INT,
	@ciudad NVARCHAR(100)
AS
BEGIN
	UPDATE cliente 
	SET NombreCliente = @nombre,
		Edad = @edad,
		Ciudad = @ciudad
	WHERE IdCliente = @id;
END;
GO

EXEC sp_update_customers 
7, 'Benito Kano', 24, 'Lima los Pies'

EXEC sp_update_customers 
@ciudad = 'Martinez de la Torre', 
@edad = 56, @id = 3, 
@nombre = 'Toribio Trompudo';


-- Ejercicio completo donde se pueda insertar datos en una tabla principal (Encabezado) y una tabla detalle utilizando un sp.

-- Tabla principal
CREATE TABLE ventas(

	IdVenta int IDENTITY (1,1) PRIMARY KEY,
	FechaVenta DATETIME NOT NULL DEFAULT GETDATE(),
	Cliente NVARCHAR(100) NOT NULL,
	Total DECIMAL  (10,2) NULL
);

-- Tabla detalle
CREATE TABLE DetalleVenta(
	IdDetalle INT IDENTITY (1,1) PRIMARY KEY,
	IdVenta INT NOT NULL,
	Producto NVARCHAR(100) NOT NULL,
	Cantidad INT NOT NULL, 
	Precio DECIMAL(10,2) NOT NULL,
	CONSTRAINT pk_detalleVenta_venta
	FOREIGN KEY (IdVenta)
	REFERENCES Ventas(IdVenta)
);


-- Crear un tipo de tabla (Tabla Type)
--Este tipo de tabla servira como estructura para enviar los detalles al sp

CREATE TYPE TipoDetalleVentas AS TABLE (
	Producto NVARCHAR(100),
	Cantidad INT,
	Precio DECIMAL(10,2)
);

-- Crear el store procedure 
-- El sp insertara el encabezado y uego todos los detalles, utilizando el tipo de tabla 
GO
CREATE OR ALTER PROCEDURE InsertarVentaConDetalle
	@Cliente nvarchar(100),
	@Detalles TipoDetalleVentas READONLY 
	AS
	BEGIN
		SET NOCOUNT ON;

		DECLARE @IdVenta INT;
		BEGIN TRY 
			BEGIN TRANSACTION;

			-- Insertar en la tabla principal
			INSERT INTO ventas(Cliente)
			VALUES(@Cliente);

			-- Obtener el ID recien generado
			SET @IdVenta = SCOPE_IDENTITY();

			--Insertar los detalles (tabla detalles)
			INSERT INTO DetalleVenta (IdVenta, Producto, Cantidad, Precio)
			SELECT @IdVenta, Producto, Cantidad, Precio
			FROM @Detalles;

			--Calcular el total de venta
			UPDATE Ventas 
			SET Total = (SELECT SUM(Cantidad * Precio) FROM @Detalles)
			WHERE IdVenta = @IdVenta;
			
			COMMIT TRANSACTION;

		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
			THROW;
		END CATCH;
	END;

	Go
	-- Ejecutar el sp con datos de prueba

	--Declarar una variable tipo tabla
	DECLARE @MisDetalles AS TipoDetalleVentas

	-- Insertar productos en el Type Table 
	INSERT INTO @MisDetalles (Producto, Cantidad, Precio)
	VALUES 
	('Laptop', 1, 15000),
	('Mouse', 2, 300),
	('Teclado', 1, 500),
	('Pantalla', 5, 4500);

	

	-- Ejecutar el SP
EXEC InsertarVentaConDetalle @Cliente='Uriel Edgar', @Detalles = @MisDetalles;

GO

	Select * from ventas;
	Select * from DetalleVenta;

-- Funciones Integradas (Built-in Fuctions)

SELECT 
Nombre as [Nombre Fuente],
LTRIM(UPPER(Nombre)) AS Mayusculas,
LOWER(Nombre) AS Minusculas,
LEN(Nombre) AS Longitud,
SUBSTRING(Nombre, 1, 3) AS Prefijo,
LTRIM(Nombre) AS [Sin Espacios Izquierda],
CONCAT(Nombre, ' - ', Edad) AS [Nombre Edad],
UPPER(REPLACE(TRIM(Ciudad), 'Chapulhuacan', 'Chapu'))AS [Ciudad Normal]
FROM clientes;

SELECT * FROM clientes

INSERT INTO clientes(Idcliente, Nombre, Edad, Ciudad)
VALUES(10,'Luis Lopez', 45, 'Achichinilco');

INSERT INTO clientes(Idcliente, Nombre, Edad, Ciudad)
VALUES(11,'German Galindo', 32, 'Achichinilco2 ');

INSERT INTO clientes(Idcliente, Nombre, Edad, Ciudad)
VALUES(12,'Jean Porfirio', 19, 'Achichinilco3');

INSERT INTO clientes(Idcliente, Nombre, Edad, Ciudad)
VALUES(13,'Roberto Estrada  ', 19, 'Chapulhuacan');



-- Crear una tabla a partir de una consulta
SELECT TOP 0
idCliente, 
Nombre as [Nombre Fuente],
LTRIM(UPPER(Nombre)) AS Mayusculas,
LOWER(Nombre) AS Minusculas,
LEN(Nombre) AS Longitud,
SUBSTRING(Nombre, 1, 3) AS Prefijo,
LTRIM(Nombre) AS [Sin Espacios Izquierda],
CONCAT(Nombre, ' - ', Edad) AS [Nombre Edad],
UPPER(REPLACE(TRIM(Ciudad), 'Chapulhuacan', 'Chapu'))AS [Ciudad Normal]
into stage_clientes
FROM clientes;


-- Agrega un constrint a la tabla(primary key)
ALTER TABLE stage_clientes
ADD CONSTRAINT pk_stage_clientes
PRIMARY KEY(idCliente);

SELECT * FROM 
stage_clientes;

-- Insetar datos a partir de una consulta
INSERT INTO stage_clientes (Idcliente,
							[Nombre Fuente],
							Mayusculas,
							Minusculas,
							Longitud,
							Prefijo,
							[Sin Espacios Izquierda],
							[Nombre Edad], 
							[Ciudad Normal])


SELECT 
idCliente, 
Nombre as [Nombre Fuente],
LTRIM(UPPER(Nombre)) AS Mayusculas,
LOWER(Nombre) AS Minusculas,
LEN(Nombre) AS Longitud,
SUBSTRING(Nombre, 1, 3) AS Prefijo,
LTRIM(Nombre) AS [Sin Espacios Izquierda],
CONCAT(Nombre, ' - ', Edad) AS [Nombre Edad],
UPPER(REPLACE(TRIM(Ciudad), 'Chapulhuacan', 'Chapu'))AS [Ciudad Normal]
FROM clientes;

-- Funciones de Fecha

Use NORTHWND
GO
Select 
OrderDate,
GETDATE() AS [FECHA ACTUAL],
DATEADD(DAY,10, OrderDate ) AS [FechaMas10Dias],
DATEPART(quarter,OrderDate) AS [Trimestre],
DATEPART(MONTH, OrderDate) AS [MESCONNUMERO],
DATENAME(MONTH, OrderDate) AS [MESCONNOMBRE],
DATENAME(WEEKDAY, OrderDate) AS [NOMBREDIA],
DATEDIFF(DAY, OrderDate, GETDATE()) AS [DIASTRANSCURRIDOS],
DATEDIFF(YEAR,OrderDate, GETDATE()) AS [AÑOSTRANSCURRIDOS],
DATEDIFF(YEAR, '2003-07-13', GETDATE()) AS [EDADJAEN],
DATEDIFF(YEAR, '1979-07-13', GETDATE()) AS [EDADJAEN]
from Orders;


-- Manejo de Valores Nulos

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    SecondaryEmail NVARCHAR(100),
    Phone NVARCHAR(20),
    Salary DECIMAL(10,2),
    Bonus DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, SecondaryEmail,
						phone, Salary, Bonus)
VALUES(1, 'Ana', 'Lopez', 'ana.lopez@empresa.com',NULL,'555-2345', 12000, 100),
      (2, 'Carlos', 'Ramirez', NULL, 'c.ramirez@empresa.com', NULL, 9500, NULL),
      (3, 'Laura', 'Gomez', NULL, NULL, '555-8900', 0, 500),
      (4, 'Jorge', 'Diaz', 'jorge.diaz@empresa.com', NULL, NULL, 15000, 0);

-- Ejercicio1 - ISNULL
-- Mostrar el nombre completo del empleado junto con su número de telefono, 
-- Sino tiene telefono, mostrar el texto "No disponible"

SELECT CONCAT(FirstName, ' ', LastName) AS [FULLNAME],
	ISNULL(phone, 'No Disponible') AS [PHONE]
FROM Employees;

-- Ejercicio 2. Mostrar el nombre del empleado y su correo de contacto

SELECT CONCAT(FirstName, ' ', LastName) AS [Nombre Completo],
email,
secondaryEmail,
COALESCE(email, SecondaryEmail, 'Sin correo') AS Correo_Contanto
from Employees;

-- Ejercicio 3. NULLIF

-- Mostrar el nombre del empleado, su salario y el resultado de NULLIF(salary,0) para detectar quien tiene salario cero

SELECT 
		CONCAT(FirstName, ' ', LastName) AS [Nombre Completo], Salary,
		NULLIF(salary, 0) AS [SalarioEvaluable]
FROM Employees;

-- Evita error de división por cero:

SELECT FirstName, 
		Bonus,
		(Bonus/NULLIF(Salary, 0)) AS Bonus_Salario
FROM Employees;


--Expresiones condicionales Cse
-- Permite crear condiciones dentro de una consulta 

select
	UPPER(CONCAT(FirstName, ' ', LastName)) AS [FULLNAME],
	ROUND(Salary, 2 ) AS SALARIO,
	CASE
		WHEN ROUND(Salary, 2 ) >= 10000 THEN 'Alto'
		WHEN ROUND(Salary, 2 ) BETWEEN 5000 AND 9999 THEN 'MEDIO'
		ELSE 'BAJO'
		END AS [NIVEL SALARIAL]
from Employees

--- Combinar Funciones y CASE

-- Seleccioanr el nombre del producto, fecha de la orden, telefono
-- Nombre del Cliente el mayusculas, validar si el telefono
-- es null, poner la palabra, no disponible,
-- comprobar la fecha de la orden restando los dias de la fecha de orden
-- con respecto a la fecha de hoy, si estos dias son menores a 30 entonces,
-- mostrar la Palabra reciente y sino Antiguo, el campo debe llamarse Estado de
-- pedido, utiliza la bd northwind

use NORTHWND

SELECT UPPER(c.CompanyName) AS [Nombre Cliente],
ISNULL(c.Phone, 'No Disponible') AS [Telefono],
p.ProductName,
CASE
    WHEN DATEDIFF(day, o.OrderDate, GETDATE()) <  30 THEN 'Reciente'
    ELSE 'Antiguo'
END AS [Estado del Pedido]
FROM ( Select customerId, companyName, Phone From Customers) AS c
INNER JOIN ( SELECT OrderID, CustomerID ,OrderDate FROM Orders) AS o
ON c.CustomerID = o.CustomerID
INNER JOIN ( SELECT ProductID, OrderID FROM [Order Details] ) AS od
ON o.OrderID = od.OrderID
INNER JOIN ( SELECT ProductID, ProductName FROM Products) AS p
ON p.ProductID = od.ProductID;


-- Create tabla a partir de esta consulta

SELECT UPPER(c.CompanyName) AS [Nombre Cliente],
ISNULL(c.Phone, 'No Disponible') AS [Telefono],
p.ProductName,
CASE
    WHEN DATEDIFF(day, o.OrderDate, GETDATE()) <  30 THEN 'Reciente'
    ELSE 'Antiguo'
END AS [Estado del Pedido]
INTO tablaformateada
FROM ( Select customerId, companyName, Phone From Customers) AS c
INNER JOIN ( SELECT OrderID, CustomerID ,OrderDate FROM Orders) AS o
ON c.CustomerID = o.CustomerID
INNER JOIN ( SELECT ProductID, OrderID FROM [Order Details] ) AS od
ON o.OrderID = od.OrderID
INNER JOIN ( SELECT ProductID, ProductName FROM Products) AS p
ON p.ProductID = od.ProductID;

CREATE OR ALTER VIEW v_pedidosAntiguos
AS

SELECT [Nombre Cliente], ProductName
FROM tablaformateada
WHERE [Estado del Pedido] = 'Antiguo';













