-- init.sql
-- Este script se ejecutará automáticamente al crear la base de datos.
-- Contiene datos de prueba ampliados para alumnos, clases y asistencias.

USE instituto_adv;

-- -----------------------------------------------------
-- Tabla alumnos
-- -----------------------------------------------------
CREATE TABLE alumnos (
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    dni INT NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    direccion VARCHAR(200),
    localidad VARCHAR(100),
    nacionalidad VARCHAR(100),
    telefono BIGINT,
    profesion VARCHAR(100),
    referencia VARCHAR(200),
    esta_activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Tabla clases
-- -----------------------------------------------------
CREATE TABLE clases (
    id_clase INT AUTO_INCREMENT PRIMARY KEY,
    fecha_clase DATE NOT NULL,
    isDebug BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Tabla asistentes (profesores/secretarios)
-- -----------------------------------------------------
CREATE TABLE asistentes (
    id_asistente INT AUTO_INCREMENT PRIMARY KEY,
    dni INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    esta_activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Tabla login
-- -----------------------------------------------------
CREATE TABLE login (
    id_asistente INT PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_asistente) REFERENCES asistentes(id_asistente) ON DELETE CASCADE
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Tabla asistencias (tabla intermedia)
-- -----------------------------------------------------
CREATE TABLE asistencias (
    id_alumno INT NOT NULL,
    id_clase INT NOT NULL,
    id_asistente INT,
    fecha_asistencia DATE NOT NULL,
    PRIMARY KEY (id_alumno, id_clase)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- INSERTS PARA DATOS DE PRUEBA
-- -----------------------------------------------------

-- Insertar múltiples alumnos de prueba
INSERT INTO alumnos (dni, nombre, apellido, email, esta_activo) 
VALUES 
(12345678, 'Juan', 'Perez', 'juan@test.com', TRUE),
(43473506, 'Santiago', 'Galo', 'santiago@test.com', TRUE), -- Alumno solicitado
(34567890, 'Ana', 'Garcia', 'ana@test.com', TRUE),
(31234567, 'Carlos', 'Martinez', 'carlos@test.com', TRUE),
(38765432, 'Laura', 'Rodriguez', 'laura@test.com', TRUE),
(33445566, 'Pedro', 'Lopez', 'pedro@test.com', TRUE),
(29876543, 'Sofia', 'Fernandez', 'sofia@test.com', TRUE);

-- Insertar un asistente de prueba (secretaria/profesor)
INSERT INTO asistentes (dni, nombre, apellido, email, esta_activo) 
VALUES (87654321, 'Maria', 'Garcia', 'maria@test.com', TRUE);

-- Insertar login de prueba para el asistente (debe ejecutarse después del asistente)
-- El id_asistente será 1 porque es el primer registro en la tabla 'asistentes'
INSERT INTO login (id_asistente, usuario, contrasena) 
VALUES (1, 'usuario_prueba', 'password123');

-- Insertar múltiples fechas de clases
-- Usaremos una fecha pasada, una futura cercana y el resto más lejanas para probar la lógica de estados
INSERT INTO clases (fecha_clase) VALUES 
('2024-08-16'), -- id_clase = 1
('2025-08-22'), -- id_clase = 2 (pasada)
('2025-08-29'), -- id_clase = 3 (hoy o recién pasada)
('2025-09-05'), -- id_clase = 4 (futura)
('2025-09-12'), -- id_clase = 5
('2025-09-19'), -- id_clase = 6
('2025-09-26'), -- id_clase = 7
('2025-10-03'), -- id_clase = 8
('2025-10-10'), -- id_clase = 9
('2025-10-17'); -- id_clase = 10

-- Insertar múltiples asistencias para distintas clases
-- Los id_alumno corresponden al orden en que fueron insertados arriba (Juan=1, Santiago=2, etc.)
-- El id_asistente siempre es 1 (Maria Garcia)

-- Asistencias para la clase del 2024-08-16 (id_clase = 1)
INSERT INTO asistencias (id_alumno, id_clase, id_asistente, fecha_asistencia) VALUES
(1, 1, 1, '2024-08-16'), -- Juan Perez
(3, 1, 1, '2024-08-16'), -- Ana García
(6, 1, 1, '2024-08-16'); -- Pedro Lopez

-- Asistencias para la clase del 2025-08-22 (id_clase = 2)
INSERT INTO asistencias (id_alumno, id_clase, id_asistente, fecha_asistencia) VALUES
(1, 2, 1, '2025-08-22'), -- Juan Perez
(2, 2, 1, '2025-08-22'), -- Santiago Galo
(4, 2, 1, '2025-08-22'), -- Carlos Martinez
(5, 2, 1, '2025-08-22'); -- Laura Rodriguez

-- Asistencias para la clase del 2025-08-29 (id_clase = 3)
INSERT INTO asistencias (id_alumno, id_clase, id_asistente, fecha_asistencia) VALUES
(2, 3, 1, '2025-08-29'), -- Santiago Galo
(3, 3, 1, '2025-08-29'), -- Ana García
(5, 3, 1, '2025-08-29'), -- Laura Rodriguez
(7, 3, 1, '2025-08-29'); -- Sofia Fernandez