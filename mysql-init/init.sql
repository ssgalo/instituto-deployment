-- Script para crear la base de datos y tablas del sistema de asistencias en MySQL
-- Basado en el modelo relacional proporcionado
-- Configurado para uso con API y Docker

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS instituto_adv
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE instituto_adv;

-- Crear usuario específico para la aplicación (API) - SOLO ACCESO INTERNO
-- Usando mysql_native_password para mayor compatibilidad
CREATE USER IF NOT EXISTS 'adv_usr'@'localhost' IDENTIFIED WITH mysql_native_password BY 'hje5PkH4IE8WOmzY2ETXzZoK4cjkTPQQQ';
CREATE USER IF NOT EXISTS 'adv_usr'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'hje5PkH4IE8WOmzY2ETXzZoK4cjkTPQQQ';
CREATE USER IF NOT EXISTS 'adv_usr'@'::1' IDENTIFIED WITH mysql_native_password BY 'hje5PkH4IE8WOmzY2ETXzZoK4cjkTPQQQ';

-- Crear usuario para acceso externo/administración (VPS) - ACCESO DESDE CUALQUIER IP
CREATE USER IF NOT EXISTS 'adv_external'@'%' IDENTIFIED WITH mysql_native_password BY 'Ext_AdV_2024#Secure!';

-- Tabla alumnos
CREATE TABLE alumnos (
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    dni INT NOT NULL,
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

-- Tabla cursos (debe crearse antes que clases para la FK)
CREATE TABLE cursos (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    fecha_comienzo DATE NOT NULL,
    fecha_fin DATE NOT NULL
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla clases (ahora con FK a cursos)
CREATE TABLE clases (
    id_clase INT AUTO_INCREMENT PRIMARY KEY,
    fecha_clase DATE NOT NULL,
    id_curso INT,
    isDebug BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) ON DELETE SET NULL
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla asistentes
CREATE TABLE asistentes (
    id_asistente INT AUTO_INCREMENT PRIMARY KEY,
    dni INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    esta_activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla login
CREATE TABLE login (
    id_asistente INT PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_asistente) REFERENCES asistentes(id_asistente) ON DELETE CASCADE
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla inscripciones
CREATE TABLE inscripciones (
    id_alumno INT NOT NULL,
    id_curso INT NOT NULL,
    modalidad VARCHAR(100) NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno) ON DELETE CASCADE,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) ON DELETE CASCADE
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla asistencias (tabla intermedia)
CREATE TABLE asistencias (
    id_alumno INT NOT NULL,
    id_clase INT NOT NULL,
    id_asistente INT,
    fecha_asistencia DATE NOT NULL,
    esta_eliminada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno) ON DELETE CASCADE,
    FOREIGN KEY (id_clase) REFERENCES clases(id_clase) ON DELETE CASCADE,
    FOREIGN KEY (id_asistente) REFERENCES asistentes(id_asistente) ON DELETE SET NULL
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ahora que las tablas existen, otorgar permisos específicos sobre la base de datos instituto_adv para API
GRANT SELECT, INSERT, UPDATE, DELETE ON instituto_adv.* TO 'adv_usr'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON instituto_adv.* TO 'adv_usr'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE, DELETE ON instituto_adv.* TO 'adv_usr'@'::1';

-- Permitir crear tablas temporales y ejecutar procedimientos (útil para APIs)
GRANT CREATE TEMPORARY TABLES ON instituto_adv.* TO 'adv_usr'@'localhost';
GRANT EXECUTE ON instituto_adv.* TO 'adv_usr'@'localhost';
GRANT CREATE TEMPORARY TABLES ON instituto_adv.* TO 'adv_usr'@'127.0.0.1';
GRANT EXECUTE ON instituto_adv.* TO 'adv_usr'@'127.0.0.1';
GRANT CREATE TEMPORARY TABLES ON instituto_adv.* TO 'adv_usr'@'::1';
GRANT EXECUTE ON instituto_adv.* TO 'adv_usr'@'::1';

-- Permisos limitados para usuario externo (NO incluye tabla login por seguridad)
GRANT SELECT ON instituto_adv.alumnos TO 'adv_external'@'%';
GRANT SELECT ON instituto_adv.clases TO 'adv_external'@'%';
GRANT SELECT ON instituto_adv.asistentes TO 'adv_external'@'%';
GRANT SELECT ON instituto_adv.cursos TO 'adv_external'@'%';
GRANT SELECT ON instituto_adv.inscripciones TO 'adv_external'@'%';
GRANT SELECT ON instituto_adv.asistencias TO 'adv_external'@'%';

GRANT INSERT ON instituto_adv.alumnos TO 'adv_external'@'%';
GRANT INSERT ON instituto_adv.clases TO 'adv_external'@'%';
GRANT INSERT ON instituto_adv.asistentes TO 'adv_external'@'%';
GRANT INSERT ON instituto_adv.cursos TO 'adv_external'@'%';
GRANT INSERT ON instituto_adv.inscripciones TO 'adv_external'@'%';
GRANT INSERT ON instituto_adv.asistencias TO 'adv_external'@'%';

GRANT UPDATE ON instituto_adv.alumnos TO 'adv_external'@'%';
GRANT UPDATE ON instituto_adv.clases TO 'adv_external'@'%';
GRANT UPDATE ON instituto_adv.asistentes TO 'adv_external'@'%';
GRANT UPDATE ON instituto_adv.cursos TO 'adv_external'@'%';
GRANT UPDATE ON instituto_adv.inscripciones TO 'adv_external'@'%';
GRANT UPDATE ON instituto_adv.asistencias TO 'adv_external'@'%';

GRANT CREATE ON instituto_adv.* TO 'adv_external'@'%';
GRANT ALTER ON instituto_adv.* TO 'adv_external'@'%';
GRANT INDEX ON instituto_adv.* TO 'adv_external'@'%';

-- NO se otorgan permisos sobre la tabla login (seguridad)
-- NO se otorga DELETE (no puede eliminar datos físicamente)
-- NO se otorga DROP (no puede eliminar estructuras)

-- Aplicar los cambios
FLUSH PRIVILEGES;

-- Comentarios para documentar las tablas (MySQL no soporta COMMENT ON TABLE)
ALTER TABLE alumnos COMMENT = 'Tabla que almacena la información de los alumnos';
ALTER TABLE clases COMMENT = 'Tabla que almacena las clases programadas con referencia al curso';
ALTER TABLE asistentes COMMENT = 'Tabla que almacena la información de los asistentes/profesores';
ALTER TABLE login COMMENT = 'Tabla que almacena las credenciales de acceso de los asistentes';
ALTER TABLE cursos COMMENT = 'Tabla que almacena los cursos disponibles en el instituto';
ALTER TABLE inscripciones COMMENT = 'Tabla que registra las inscripciones de alumnos a cursos';
ALTER TABLE asistencias COMMENT = 'Tabla que registra la asistencia de alumnos a clases';

-- Verificar permisos de los usuarios creados
SHOW GRANTS FOR 'adv_usr'@'localhost';
SHOW GRANTS FOR 'adv_usr'@'127.0.0.1';
SHOW GRANTS FOR 'adv_usr'@'::1';
SHOW GRANTS FOR 'adv_external'@'%';

-- Insertar cursos de prueba PRIMERO
INSERT INTO cursos (nombre, fecha_comienzo, fecha_fin) VALUES 
('Clase de Prueba 1', '2025-08-01', '2025-12-15'),
('Clase de Prueba 2', '2025-09-01', '2025-12-31'),
('Clase de Prueba 3', '2025-10-01', '2025-12-28');

-- inserts para usuarios de prueba
INSERT INTO alumnos (dni, nombre, apellido, email, direccion, localidad, nacionalidad, telefono, profesion, referencia, esta_activo) 
VALUES (12345678, 'Juan', 'Perez', 'juan@test.com', 'Av Test 123', 'Buenos Aires', 'Argentina', 1112345678, 'Estudiante', 'Referencia test', TRUE);

-- Insertar un asistente de prueba
INSERT INTO asistentes (dni, nombre, apellido, email, esta_activo) 
VALUES (87654321, 'Maria', 'Garcia', 'maria@test.com', TRUE);

-- Insertar clases de prueba con id_curso
INSERT INTO clases (fecha_clase, id_curso) 
VALUES ('2025-08-16', 1);

INSERT INTO clases (fecha_clase, id_curso) VALUES 
('2025-10-03', 1),
('2025-10-10', 1),
('2025-10-17', 1),
('2025-10-24', 1),
('2025-10-31', 2),
('2025-11-07', 2),
('2025-11-14', 2),
('2025-11-21', 2),
('2025-11-28', 3),
('2025-12-05', 3);

-- Insertar login de prueba (debe ejecutarse después del asistente)
INSERT INTO login (id_asistente, usuario, contrasena) 
VALUES (1, 'usuario_prueba', 'password123');

-- Insertar inscripciones de prueba (usando el alumno existente)
INSERT INTO inscripciones (id_alumno, id_curso, modalidad, fecha_inscripcion) VALUES 
(1, 1, 'Presencial', '2025-07-15'),
(1, 2, 'Virtual', '2025-08-20');

-- Actualizar usuarios existentes para usar mysql_native_password
ALTER USER 'adv_usr'@'localhost' IDENTIFIED WITH mysql_native_password BY 'hje5PkH4IE8WOmzY2ETXzZoK4cjkTPQQQ';
ALTER USER 'adv_usr'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'hje5PkH4IE8WOmzY2ETXzZoK4cjkTPQQQ';
ALTER USER 'adv_usr'@'::1' IDENTIFIED WITH mysql_native_password BY 'hje5PkH4IE8WOmzY2ETXzZoK4cjkTPQQQ';
FLUSH PRIVILEGES;