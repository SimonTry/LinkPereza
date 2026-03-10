Script Base de datos


-- --------------------------------------------------------
-- Tabla de Autores
-- --------------------------------------------------------
CREATE TABLE Autores (
    id_autor INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(50)
);
GO

-- Inserción de datos en Autores
INSERT INTO Autores (id_autor, nombre, apellido, nacionalidad) VALUES
(1, 'Gabriel', 'García Márquez', 'Colombiana'),
(2, 'Isabel', 'Allende', 'Chilena'),
(3, 'Julio', 'Cortázar', 'Argentina'),
(4, 'Mario', 'Vargas Llosa', 'Peruana'),
(5, 'Jorge Luis', 'Borges', 'Argentina'),
(6, 'Hang', 'Kang', 'Coreana');
GO

-- --------------------------------------------------------
-- Tabla de Libros
-- --------------------------------------------------------
CREATE TABLE Libros (
    id_libro INT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    genero VARCHAR(50),
    anio_publicacion INT,
    precio DECIMAL(10, 2),
    id_autor INT,
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor)
);
GO

-- Inserción de datos en Libros
INSERT INTO Libros (id_libro, titulo, genero, anio_publicacion, precio, id_autor) VALUES
(101, 'Cien años de soledad', 'Ficción', 1967, 25.50, 1),
(102, 'El amor en los tiempos del cólera', 'Ficción', 1985, 20.00, 1),
(103, 'La casa de los espíritus', 'Ficción', 1982, 22.75, 2),
(104, 'De amor y de sombra', 'Romance', 1984, 18.99, 2),
(105, 'Rayuela', 'Experimental', 1963, 30.00, 3),
(106, 'Bestiario', 'Cuentos', 1951, 15.00, 3),
(107, 'La ciudad y los perros', 'Ficción', 1963, 28.50, 4),
(108, 'Ficciones', 'Cuentos', 1944, 17.50, 5),
(109, 'El aleph', 'Cuentos', 1949, 16.00, 5),
(110, 'La vegetariana', 'Novela', 2007, 21.00, 6);
GO

-- --------------------------------------------------------
-- Tabla de Clientes
-- --------------------------------------------------------
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50),
    email VARCHAR(100)
);
GO

-- Inserción de datos en Clientes
INSERT INTO Clientes (id_cliente, nombre, apellido, ciudad, email) VALUES
(201, 'Ana', 'Gómez', 'Medellín', 'ana.gomez@mail.com'),
(202, 'Luis', 'Pérez', 'Bogotá', 'luis.perez@mail.com'),
(203, 'Sofía', 'Rodríguez', 'Medellín', 'sofia.rodriguez@mail.com'),
(204, 'Pedro', 'Sánchez', 'Cali', 'pedro.sanchez@mail.com'),
(205, 'María', 'López', 'Bogotá', 'maria.lopez@mail.com');
GO

-- --------------------------------------------------------
-- Tabla de Ventas
-- --------------------------------------------------------
CREATE TABLE Ventas (
    id_venta INT PRIMARY KEY,
    id_libro INT,
    id_cliente INT,
    fecha_venta DATE,
    cantidad INT,
    FOREIGN KEY (id_libro) REFERENCES Libros(id_libro),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);
GO

-- Inserción de datos en Ventas
INSERT INTO Ventas (id_venta, id_libro, id_cliente, fecha_venta, cantidad) VALUES
(301, 101, 201, '2025-01-15', 1),
(302, 103, 202, '2025-01-18', 2),
(303, 105, 201, '2025-01-20', 1),
(304, 102, 203, '2025-02-01', 1),
(305, 101, 204, '2025-02-05', 1),
(306, 106, 202, '2025-02-08', 3),
(307, 107, 205, '2025-02-10', 1),
(308, 108, 203, '2025-02-12', 2),
(309, 104, 201, '2025-02-15', 1),
(310, 109, 204, '2025-02-18', 1);
GO

a. Sentencia SELECT

* Pregunta: Muestra todos los libros disponibles en la librería.
* Consulta: SQL  SELECT * FROM Libros;
*    
* Pregunta: Muestra únicamente los nombres y apellidos de todos los autores.
* Consulta: SQL  SELECT nombre, apellido FROM Autores;
*    

b. Cláusula WHERE

* Pregunta: Encuentra los libros cuyo precio sea superior a $25.
* Consulta: SQL  SELECT titulo, precio FROM Libros WHERE precio > 25.00;
*    
* Pregunta: Muestra todos los clientes que viven en la ciudad de Medellín.
* Consulta: SQL  SELECT * FROM Clientes WHERE ciudad = 'Medellín';
*    

c. Cláusula JOIN

* Pregunta: Muestra el título de cada libro junto con el nombre y apellido de su autor.
* Consulta: SQL  SELECT
*     L.titulo,
*     A.nombre,
*     A.apellido
* FROM Libros AS L
* INNER JOIN Autores AS A ON L.id_autor = A.id_autor;
*    
* Pregunta: Muestra el nombre del cliente que compró cada libro y la fecha de la venta.
* Consulta: SQL  SELECT
*     C.nombre AS nombre_cliente,
*     L.titulo AS titulo_libro,
*     V.fecha_venta
* FROM Ventas AS V
* INNER JOIN Clientes AS C ON V.id_cliente = C.id_cliente
* INNER JOIN Libros AS L ON V.id_libro = L.id_libro;
*    

d. Cláusula GROUP BY y Funciones de Agregación

* Pregunta: ¿Cuántos libros hay por cada género?
* Consulta: SQL  SELECT genero, COUNT(*) AS total_libros
* FROM Libros
* GROUP BY genero;
*    
* Pregunta: ¿Cuál es el precio promedio de los libros de cada autor?
* Consulta: SQL  SELECT
*     A.nombre,
*     A.apellido,
*     AVG(L.precio) AS precio_promedio
* FROM Libros AS L
* INNER JOIN Autores AS A ON L.id_autor = A.id_autor
* GROUP BY A.id_autor, A.nombre, A.apellido;
*    
* Pregunta: Calcula la cantidad total de libros vendidos por cada cliente.
* Consulta: SQL  SELECT
*     C.nombre,
*     C.apellido,
*     SUM(V.cantidad) AS total_libros_comprados
* FROM Ventas AS V
* INNER JOIN Clientes AS C ON V.id_cliente = C.id_cliente
* GROUP BY C.id_cliente, C.nombre, C.apellido;
*    

e. Cláusula ORDER BY

* Pregunta: Muestra todos los libros, ordenados del más nuevo al más antiguo por su año de publicación.
* Consulta: SQL  SELECT titulo, anio_publicacion FROM Libros
* ORDER BY anio_publicacion DESC;
*    
* Pregunta: Lista los autores en orden alfabético por su apellido.
* Consulta: SQL  SELECT nombre, apellido FROM Autores
* ORDER BY apellido ASC;
*    

f. Cláusula HAVING
    
* Pregunta: Muestra los géneros de libros donde la cantidad de libros es mayor a 1.
* Consulta: SQL  SELECT genero, COUNT(*) AS total_libros
* FROM Libros
* GROUP BY genero
* HAVING COUNT(*) > 1;
*    
* Pregunta: ¿Qué autores tienen un precio promedio de sus libros superior a $20?
* Consulta: SQL  SELECT
*     A.nombre,
*     A.apellido,
*     AVG(L.precio) AS precio_promedio
* FROM Libros AS L
* INNER JOIN Autores AS A ON L.id_autor = A.id_autor
* GROUP BY A.id_autor
* HAVING AVG(L.precio) > 20.00;
*    

g. Subconsultas

* Pregunta: Encuentra los títulos de los libros que han sido vendidos.
* Consulta: SQL  SELECT titulo FROM Libros
* WHERE id_libro IN (SELECT DISTINCT id_libro FROM Ventas);
*    
* Pregunta: Muestra el nombre de los clientes que han comprado el libro 'Cien años de soledad'.
* Consulta: SQL  SELECT nombre, apellido FROM Clientes
* WHERE id_cliente IN (
*     SELECT id_cliente FROM Ventas
*     WHERE id_libro = (SELECT id_libro FROM Libros WHERE titulo = 'Cien años de soledad')
* );
*    

