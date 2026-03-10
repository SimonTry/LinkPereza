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
