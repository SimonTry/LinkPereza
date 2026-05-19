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

-- 1. ¿Cuál es la nota defitiniva de los estudiantes por cada curso?
-- Nota 1 y 2: 15%
-- Nota 3 y 4: 20%
-- Nota 5: 30%
select e.Nombre, c.NombreCurso,
N.Nota1 * 0.15 + N.Nota2 * 0.15 + N.Nota3 * 0.20 + N.Nota4 * 0.20 + ISNULL(N.Nota5 * 0.30,0) 
as NotaDefinitiva
from Notas as N 
join Estudiantes as E on n.EstudianteID = e.EstudianteID
join Cursos as C on n.CursoID = c.CursoID
order by e.Nombre asc

-- Top 3 de mejores estudiantes (Rendimiento general de los esutidante)
select Top 3 e.Nombre,
AVG(N.Nota1 * 0.15 + N.Nota2 * 0.15 + N.Nota3 * 0.20 + 
N.Nota4 * 0.20 + ISNULL(N.Nota5 * 0.30,0))
as PromedioGeneral
from Notas as N 
join Estudiantes as E on n.EstudianteID = e.EstudianteID
join Cursos as C on n.CursoID = c.CursoID
group by e.Nombre
order by PromedioGeneral desc

-- ¿Cuál es el Curso con el peor rendimiento promedio?
select Top 1 c.NombreCurso,
AVG(N.Nota1 * 0.15 + N.Nota2 * 0.15 + N.Nota3 * 0.20 + 
N.Nota4 * 0.20 + ISNULL(N.Nota5 * 0.30,0))
as PromedioGeneral
from Notas as N 
join Estudiantes as E on n.EstudianteID = e.EstudianteID
join Cursos as C on n.CursoID = c.CursoID

--¿Cuál es el curso con más estudiantes aprobados?
select c.NombreCurso,
SUM(CASE WHEN N.Nota1 * 0.15 + N.Nota2 * 0.15 + N.Nota3 * 0.20 + 
N.Nota4 * 0.20 + ISNULL(N.Nota5 * 0.30,0) >= 3 THEN 1 ELSE 0 END) 
as CantidadEstudiantes
from Notas as N 
join Estudiantes as E on n.EstudianteID = e.EstudianteID
join Cursos as C on n.CursoID = c.CursoID
GROUP BY c.NombreCurso, c.CursoID
order by CantidadEstudiantes desc

-- Crear una función para calcular la nota definitiva
CREATE FUNCTION calcularNotaDefinitiva(
    @Nota1 FLOAT, @Nota2 FLOAT, @Nota3 FLOAT, @Nota4 FLOAT, @Nota5 FLOAT
)
RETURNS FLOAT
AS
BEGIN
    declare @resultado FLOAT
    set @resultado = @Nota1 * 0.15 + @Nota2 * 0.15 + @Nota3 * 0.20 + 
    @Nota4 * 0.20 + ISNULL(@Nota5 * 0.30,0)
    return @resultado
END

select e.Nombre, c.NombreCurso, 
dbo.calcularNotaDefinitiva(n.nota1, n.nota2,
n.nota3,n.nota4, n.nota5)  from Notas as n join Estudiantes as e
on n.EstudianteID = e.EstudianteID
join Cursos as c on n.CursoID = c.CursoID

-- Crear un procedimiento almacenado para actualizar
-- masivamente las notas de los estudiantes usando la función
-- anterior para un curso específico
CREATE PROCEDURE ActualizarNotaDefinitivaCurso(
    @idCurso INT
)
AS
BEGIN
    IF not exists(select 1 from Cursos where CursoID = @idCurso)
    BEGIN
        print('El curso no existe')
    END
    ELSE
    BEGIN
        Update Notas SET NotaFinal = 
        dbo.calcularNotaDefinitiva(Nota1, Nota2, Nota3, Nota4, Nota5)
        Where CursoID = @idCurso
        AND Nota5 IS NOT NULL  
        AND Nota4 IS NOT NULL 
        AND Nota3 IS NOT NULL 
        AND Nota4 IS NOT NULL
        AND Nota1 IS NOT NULL
    END

    print('Notas actualizadas')
END

exec ActualizarNotaDefinitivaCurso @idCurso = 2

-- Trigger para que al calcular la nota final de un estudiante
-- Se actulice el estado a Aprobado o Reprobado
CREATE TRIGGER ActualiazarEstadoEstudiante
ON Notas
AFTER UPDATE
AS
BEGIN
    IF UPDATE(NotaFinal)
    BEGIN
        Update e set e.Estado = 
            CASE WHEN i.NotaFinal >= 3 THEN 'Aprobado' ELSE 'Reprobado' END
         from Estudiantes as e join inserted as I on e.EstudianteId = I.EstudianteID
         where I.NotaFinal is not null
    END
END


select * from Estudiantes
select EstudianteID,NotaFinal from Notas where CursoID = 2
exec ActualizarNotaDefinitivaCurso @idCurso = 2
