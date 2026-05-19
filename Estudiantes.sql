USE master;
GO

-- Recrear la base de datos limpiamente
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'SistemaAcademico')
BEGIN
    ALTER DATABASE SistemaAcademico SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SistemaAcademico;
END
GO

CREATE DATABASE SistemaAcademico;
GO

USE SistemaAcademico;
GO

/* ==========================================================================
   1. CREACIÓN DE TABLAS (INCLUYENDO HISTORIAL)
   ========================================================================== */

CREATE TABLE Profesores (
    ProfesorID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Cursos (
    CursoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreCurso VARCHAR(100) NOT NULL,
    Creditos INT DEFAULT 3,
    ProfesorID INT FOREIGN KEY REFERENCES Profesores(ProfesorID)
);

CREATE TABLE Estudiantes (
    EstudianteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Estado VARCHAR(20) DEFAULT 'Cursando'
);

CREATE TABLE Notas (
    NotaID INT IDENTITY(1,1) PRIMARY KEY,
    EstudianteID INT FOREIGN KEY REFERENCES Estudiantes(EstudianteID),
    CursoID INT FOREIGN KEY REFERENCES Cursos(CursoID),
    Nota1 NUMERIC(3,1) CHECK (Nota1 BETWEEN 0.0 AND 5.0), -- 15%
    Nota2 NUMERIC(3,1) CHECK (Nota2 BETWEEN 0.0 AND 5.0), -- 15%
    Nota3 NUMERIC(3,1) CHECK (Nota3 BETWEEN 0.0 AND 5.0), -- 20%
    Nota4 NUMERIC(3,1) CHECK (Nota4 BETWEEN 0.0 AND 5.0), -- 20%
    Nota5 NUMERIC(3,1) CHECK (Nota5 BETWEEN 0.0 AND 5.0), -- 30%
    NotaFinal NUMERIC(3,1) NULL
);

CREATE TABLE HistorialNotasAuditoria (
    AuditoriaID INT IDENTITY(1,1) PRIMARY KEY,
    NotaID INT,
    EstudianteID INT,
    CursoID INT,
    NotaViejas VARCHAR(200),
    NotasNuevas VARCHAR(200),
    FechaCambio DATETIME DEFAULT GETDATE(),
    Usuario VARCHAR(100) DEFAULT SYSTEM_USER
);
GO

/* ==========================================================================
   2. INSERCIÓN DE DATOS DE PRUEBA (SEED DATA)
   ========================================================================== */

-- 3 Profesores
INSERT INTO Profesores (Nombre, Email) VALUES 
('Carlos Mendoza', 'carlos.mendoza@universidad.edu'),
('Ana María López', 'ana.lopez@universidad.edu'),
('Roberto Gómez', 'roberto.gomez@universidad.edu');

-- 3 Cursos
INSERT INTO Cursos (NombreCurso, Creditos, ProfesorID) VALUES 
('Bases de Datos I', 4, 1),
('Programación Orientada a Objetos', 3, 2),
('Arquitectura de Software', 3, 3);

-- 5 Estudiantes
INSERT INTO Estudiantes (Nombre) VALUES 
('Juan Pérez'),
('María Rodríguez'),
('Santiago Gómez'),
('Valentina Restrepo'),
('Andrés Castro');

-- Inscripciones y Notas para Curso 1 (Bases de Datos I) - 5 Estudiantes
INSERT INTO Notas (EstudianteID, CursoID, Nota1, Nota2, Nota3, Nota4, Nota5) VALUES 
(1, 1, 4.5, 3.8, 4.0, 3.5, 4.2), 
(2, 1, 2.5, 3.0, 2.8, 2.0, 3.2), 
(3, 1, 3.0, 3.5, 2.0, 4.0, 2.5), 
(4, 1, 4.8, 4.2, 4.5, 4.0, 5.0), 
(5, 1, 3.5, 3.8, 3.2, 3.0, 4.0);

-- Inscripciones y Notas para Curso 2 (POO) - 5 Estudiantes
INSERT INTO Notas (EstudianteID, CursoID, Nota1, Nota2, Nota3, Nota4, Nota5) VALUES 
(1, 2, 2.0, 1.5, 3.0, 2.5, 2.0), 
(2, 2, 4.0, 4.0, 3.8, 4.2, 4.5), 
(3, 2, 3.2, 3.0, 3.5, 2.8, 3.0), 
(4, 2, 5.0, 4.8, 4.7, 4.9, 5.0), 
(5, 2, 1.5, 2.0, 2.5, 2.0, 1.8);

-- Inscripciones y Notas para Curso 3 (Arquitectura de Software) - 5 Estudiantes
-- (Dejamos la Nota 5 en NULL en algunos para simulaciones de clase)
INSERT INTO Notas (EstudianteID, CursoID, Nota1, Nota2, Nota3, Nota4, Nota5) VALUES 
(1, 3, 4.0, 4.0, 4.0, 4.0, NULL), 
(2, 3, 3.5, 3.5, 3.0, 3.0, 3.5), 
(3, 3, 2.8, 2.5, 3.0, 2.0, NULL), 
(4, 3, 4.5, 4.5, 4.0, 4.5, 4.8), 
(5, 3, 3.0, 3.0, 3.0, 3.0, 3.0);
GO
