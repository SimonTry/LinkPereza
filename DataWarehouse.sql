--Data Warehouse

CREATE DATABASE DW_Skincare_Sales;
GO

USE DW_Skincare_Sales;
GO

-- 2. CREACIÓN DE DIMENSIONES

-- Dimensión Geográfica (Para Mapas y Jerarquías)
CREATE TABLE Dim_Ubicacion (
    UbicacionKey INT PRIMARY KEY IDENTITY(1,1),
    Ciudad NVARCHAR(100),
    Departamento_Estado NVARCHAR(100),
    Pais NVARCHAR(100),
    CodigoISO NVARCHAR(5),
    Latitud DECIMAL(9,6),
    Longitud DECIMAL(9,6)
);

-- Dimensión Clientes
CREATE TABLE Dim_Cliente (
    ClienteKey INT PRIMARY KEY IDENTITY(1,1),
    ClienteID NVARCHAR(20),
    NombreCompleto NVARCHAR(150),
    Genero NVARCHAR(20),
    RangoEdad NVARCHAR(50),
    UbicacionKey INT FOREIGN KEY REFERENCES Dim_Ubicacion(UbicacionKey)
);

-- Dimensión Producto
CREATE TABLE Dim_Producto (
    ProductoKey INT PRIMARY KEY IDENTITY(1,1),
    ProductoNombre NVARCHAR(100),
    Categoria NVARCHAR(50), 
    TipoPiel NVARCHAR(50),  
    PrecioUnitario DECIMAL(18,2)
);

-- Dimensión Empleado (Vendedores)
CREATE TABLE Dim_Empleado (
    EmpleadoKey INT PRIMARY KEY IDENTITY(1,1),
    EmpleadoID NVARCHAR(20),
    NombreCompleto NVARCHAR(150),
    Cargo NVARCHAR(50),
    Equipo NVARCHAR(50),
    FechaContratacion DATE
);


-- 3. TABLA DE HECHOS (FACT TABLE)

CREATE TABLE Fact_Ventas (
    VentaID INT PRIMARY KEY IDENTITY(1,1),
    ClienteKey INT FOREIGN KEY REFERENCES Dim_Cliente(ClienteKey),
    ProductoKey INT FOREIGN KEY REFERENCES Dim_Producto(ProductoKey),
    UbicacionKey INT FOREIGN KEY REFERENCES Dim_Ubicacion(UbicacionKey),
    EmpleadoKey INT FOREIGN KEY REFERENCES Dim_Empleado(EmpleadoKey),
    Cantidad INT,
    PrecioVentaTotal DECIMAL(18,2),
    CostoEnvio DECIMAL(18,2),
    FechaVenta DATE
);
GO
-- 1. LIMPIEZA PREVIA (Opcional, para evitar duplicados si re-ejecutas)
TRUNCATE TABLE Fact_Ventas;
DELETE FROM Dim_Cliente;
DELETE FROM Dim_Producto;
DELETE FROM Dim_Empleado;
DELETE FROM Dim_Ubicacion;
GO

-- 2. INSERCIÓN EN DIMENSIONES (Mínimo 10 registros)

INSERT INTO Dim_Ubicacion (Ciudad, Departamento_Estado, Pais, CodigoISO, Latitud, Longitud) VALUES 
('Medellín', 'Antioquia', 'Colombia', 'CO', 6.2442, -75.5812),
('Bogotá', 'Cundinamarca', 'Colombia', 'CO', 4.7110, -74.0721),
('Cali', 'Valle del Cauca', 'Colombia', 'CO', 3.4516, -76.5320),
('Cartagena', 'Bolívar', 'Colombia', 'CO', 10.3910, -75.4794),
('Ciudad de México', 'CDMX', 'México', 'MX', 19.4326, -99.1332),
('Guadalajara', 'Jalisco', 'México', 'MX', 20.6597, -103.3496),
('Monterrey', 'Nuevo León', 'México', 'MX', 25.6866, -100.3161),
('Cancún', 'Quintana Roo', 'México', 'MX', 21.1619, -86.8515),
('Lima', 'Lima', 'Perú', 'PE', -12.0464, -77.0428),
('Arequipa', 'Arequipa', 'Perú', 'PE', -16.4090, -71.5375);

INSERT INTO Dim_Producto (ProductoNombre, Categoria, TipoPiel, PrecioUnitario) VALUES 
('Serum Vitamina C', 'Tratamiento', 'Todo tipo', 35.00),
('Limpiador Espumoso', 'Limpieza', 'Grasa', 15.00),
('Protector Solar FPS 50', 'Protección', 'Sensible', 25.00),
('Crema Hidratante Pro', 'Hidratación', 'Seca', 22.00),
('Tónico Exfoliante AHA', 'Limpieza', 'Mixta', 18.00),
('Aceite Limpiador', 'Limpieza', 'Seca', 28.00),
('Mascarilla de Arcilla', 'Tratamiento', 'Grasa', 12.00),
('Contorno de Ojos', 'Tratamiento', 'Todo tipo', 40.00),
('Bálsamo Labial UV', 'Protección', 'Todo tipo', 8.00),
('Agua Micelar', 'Limpieza', 'Sensible', 10.00);

INSERT INTO Dim_Empleado (EmpleadoID, NombreCompleto, Cargo, Equipo, FechaContratacion) VALUES 
('EMP001', 'Carlos Ruiz', 'Consultor Senior', 'Ventas Online', '2024-05-12'),
('EMP002', 'Diana Tobón', 'Consultor de Belleza', 'Punto de Venta', '2025-01-20'),
('EMP003', 'Mateo López', 'Vendedor Jr.', 'Telemarketing', '2025-11-05'),
('EMP004', 'Laura Cano', 'Consultor de Belleza', 'Punto de Venta', '2025-02-15'),
('EMP005', 'Andrés Mesa', 'Vendedor Jr.', 'Ventas Online', '2025-06-10'),
('EMP006', 'Sofia Reyes', 'Gerente Regional', 'Estrategia', '2023-10-01'),
('EMP007', 'Jorge Elías', 'Consultor Senior', 'Punto de Venta', '2024-08-22'),
('EMP008', 'Paula Ortiz', 'Vendedor Jr.', 'Telemarketing', '2025-12-01'),
('EMP009', 'Kevin Vaca', 'Consultor de Belleza', 'Ventas Online', '2025-03-14'),
('EMP010', 'Sara Miller', 'Vendedor Jr.', 'Punto de Venta', '2026-01-05');

INSERT INTO Dim_Cliente (ClienteID, NombreCompleto, Genero, RangoEdad, UbicacionKey) VALUES 
('C001', 'Ana García', 'Femenino', '25-34', 1),
('C002', 'Luis Martínez', 'Masculino', '18-24', 3),
('C003', 'Elena Rius', 'Femenino', '35-44', 2),
('C004', 'Sonia Valle', 'Femenino', '45-54', 5),
('C005', 'Pedro Gómez', 'Masculino', '25-34', 7),
('C006', 'Lucía Fernández', 'Femenino', '18-24', 6),
('C007', 'Marta Sánchez', 'Femenino', '55+', 9),
('C008', 'Raúl Castro', 'Masculino', '35-44', 10),
('C009', 'Claudia Luz', 'Femenino', '25-34', 4),
('C010', 'Igor Smith', 'Masculino', '45-54', 8);
GO

-- 3. CICLO PARA LLENAR 100 REGISTROS EN LA TABLA DE HECHOS
-- Usamos fechas aleatorias entre Enero y Marzo de 2026
DECLARE @i INT = 1;
DECLARE @RandomDate DATE;
DECLARE @RandomProduct INT;
DECLARE @RandomPrice DECIMAL(18,2);
DECLARE @RandomQty INT;

WHILE @i <= 100
BEGIN
    -- Genera una fecha aleatoria dentro de los primeros 90 días de 2026
    SET @RandomDate = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 90), '2026-01-01'); 
    SET @RandomProduct = (SELECT TOP 1 ProductoKey FROM Dim_Producto ORDER BY NEWID());
    SET @RandomPrice = (SELECT PrecioUnitario FROM Dim_Producto WHERE ProductoKey = @RandomProduct);
    SET @RandomQty = ABS(CHECKSUM(NEWID()) % 5) + 1;

    INSERT INTO Fact_Ventas (
        ClienteKey, 
        ProductoKey, 
        UbicacionKey, 
        EmpleadoKey, 
        Cantidad, 
        PrecioVentaTotal, 
        CostoEnvio, 
        FechaVenta
    )
    VALUES (
        (SELECT TOP 1 ClienteKey FROM Dim_Cliente ORDER BY NEWID()),
        @RandomProduct,
        (SELECT TOP 1 UbicacionKey FROM Dim_Ubicacion ORDER BY NEWID()),
        (SELECT TOP 1 EmpleadoKey FROM Dim_Empleado ORDER BY NEWID()),
        @RandomQty,
        (@RandomPrice * @RandomQty),
        (5.00 + (ABS(CHECKSUM(NEWID()) % 10))), -- Envío variable entre 5 y 15
        @RandomDate -- Inserción de la fecha generada aleatoriamente
    );
    
    SET @i = @i + 1;
END;
GO


-- Comprobar resultados
SELECT 'Resumen de Carga' AS Mensaje;
SELECT (SELECT COUNT(*) FROM Fact_Ventas) AS TotalVentas
select * from Fact_Ventas order by FechaVenta asc
select * from Dim_Producto
