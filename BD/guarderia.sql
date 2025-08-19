-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS guarderia;
USE guarderia;

-- Tabla: Padres/Tutores
CREATE TABLE padres_tutores (
    codigo_tutor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_completo VARCHAR(100) NOT NULL,
    relacion_con_nino VARCHAR(50) NOT NULL,
    direccion VARCHAR(150),
    telefono VARCHAR(20),
    correo VARCHAR(100)
);

-- Tabla: Grupos
CREATE TABLE grupos (
    codigo_grupo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_grupo VARCHAR(50) NOT NULL
);

-- Tabla: Educadoras
CREATE TABLE educadoras (
    codigo_educadora INT PRIMARY KEY AUTO_INCREMENT,
    nombre_completo VARCHAR(100) NOT NULL,
    nivel_academico VARCHAR(50),
    anios_experiencia INT,
    telefono VARCHAR(20),
    codigo_grupo INT,
    FOREIGN KEY (codigo_grupo) REFERENCES grupos(codigo_grupo)
);

-- Tabla: Niños
CREATE TABLE ninos (
    codigo_nino INT PRIMARY KEY AUTO_INCREMENT,
    nombre_completo VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero VARCHAR(100) NOT NULL,
    codigo_grupo INT,
    codigo_tutor INT,
    FOREIGN KEY (codigo_grupo) REFERENCES grupos(codigo_grupo),
    FOREIGN KEY (codigo_tutor) REFERENCES padres_tutores(codigo_tutor)
);

-- Tabla: Actividades
CREATE TABLE actividades (
    codigo_actividad INT PRIMARY KEY AUTO_INCREMENT,
    nombre_actividad VARCHAR(100) NOT NULL,
    descripcion TEXT,
    edad_recomendada INT,
    duracion_minutos INT
);

-- Tabla: Horarios
CREATE TABLE horarios (
    codigo_horario INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    codigo_grupo INT,
    codigo_actividad INT,
    FOREIGN KEY (codigo_grupo) REFERENCES grupos(codigo_grupo),
    FOREIGN KEY (codigo_actividad) REFERENCES actividades(codigo_actividad)
);

-- Tabla: Asistencia
CREATE TABLE asistencia (
    codigo_asistencia INT PRIMARY KEY AUTO_INCREMENT,
    codigo_nino INT,
    fecha DATE NOT NULL,
    estado VARCHAR(100) NOT NULL,
    observaciones VARCHAR(200),
    FOREIGN KEY (codigo_nino) REFERENCES ninos(codigo_nino)
);

-- Tabla: Evaluaciones
CREATE TABLE evaluaciones (
    codigo_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    codigo_nino INT,
    fecha DATE NOT NULL,
    aspecto_evaluado VARCHAR(100),
    calificacion VARCHAR(20),
    comentarios TEXT,
    codigo_educadora INT,
    FOREIGN KEY (codigo_nino) REFERENCES ninos(codigo_nino),
    FOREIGN KEY (codigo_educadora) REFERENCES educadoras(codigo_educadora)
);

Create table usuarios (
    id_usuario int primary key auto_increment,
    nombre_usuario varchar(100),
    contrasena varchar(255),
    rol varchar(50)
);

INSERT INTO padres_tutores (nombre_completo, relacion_con_nino, direccion, telefono, correo) VALUES
('Juan Pérez', 'Padre', 'Calle Falsa 123', '555-1234', 'juan.perez@example.com'),
('María López', 'Madre', 'Avenida Siempre Viva 742', '555-5678', 'maria.lopez@example.com'),
('Carlos Sánchez', 'Padre', 'Calle Verdadera 456', '555-8765', 'carlos.sanchez@example.com');

INSERT INTO grupos (nombre_grupo) VALUES
('Grupo A'),
('Grupo B'),
('Grupo C');

INSERT INTO educadoras (nombre_completo, nivel_academico, anios_experiencia, telefono, codigo_grupo) VALUES
('Ana Gómez', 'Licenciatura en Educación', 5, '555-1111', 1),
('Luis Martínez', 'Licenciatura en Psicología', 3, '555-2222', 2),
('María Fernández', 'Licenciatura en Pedagogía', 4, '555-3333', 3);

INSERT INTO ninos (nombre_completo, fecha_nacimiento, genero, codigo_grupo, codigo_tutor) VALUES
('Sofía Pérez', '2018-05-15', 'F', 1, 1),
('Diego López', '2019-08-22', 'M', 2, 2),
('Carlos Sánchez', '2020-02-10', 'M', 3, 3);

INSERT INTO actividades (nombre_actividad, descripcion, edad_recomendada, duracion_minutos) VALUES
('Pintura', 'Actividad de pintura con acuarelas', 3, 30),
('Cuentacuentos', 'Lectura de cuentos para niños', 4, 45),
('Juegos al aire libre', 'Actividades recreativas en el patio', 5, 60);

INSERT INTO horarios (fecha, hora_inicio, hora_fin, codigo_grupo, codigo_actividad) VALUES
('2023-10-01', '09:00:00', '10:00:00', 1, 1),
('2023-10-01', '10:30:00', '11:15:00', 2, 2),
('2023-10-01', '11:30:00', '12:15:00', 3, 3);

INSERT INTO asistencia (codigo_nino, fecha, estado, observaciones) VALUES
(1, '2023-10-01', 'Presente', 'Llegó a tiempo'),
(2, '2023-10-01', 'Ausente', 'No asistió por enfermedad'),
(3, '2023-10-01', 'Presente', 'Llegó a tiempo');

INSERT INTO evaluaciones (codigo_nino, fecha, aspecto_evaluado, calificacion, comentarios, codigo_educadora) VALUES
(1, '2023-10-01', 'Desempeño en actividades artísticas', 'Excelente', 'Sofía muestra gran creatividad', 1),
(2, '2023-10-01', 'Interacción social', 'Bueno', 'Diego interactúa bien con sus compañeros', 2),
(3, '2023-10-01', 'Desempeño en actividades físicas', 'Regular', 'Carlos necesita mejorar su coordinación', 3);




-- Crear Usuarios de la base de

CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'admin1';
CREATE USER 'desarrollador'@'localhost' IDENTIFIED BY 'dev1';
CREATE USER 'supervisor'@'localhost' IDENTIFIED BY 'super1';

-- Otorgar todos los privilegios sobre toda la base de datos
GRANT ALL PRIVILEGES ON guarderia.* TO 'administrador'@'localhost';

-- Otorgar permisos SELECT, INSERT, UPDATE, DELETE en todas las tablas relevantes
GRANT SELECT, INSERT, UPDATE, DELETE ON guarderia.* TO 'desarrollador'@'localhost';

-- Permisos de solo lectura para todas las tablas del sistema
GRANT SELECT ON guarderia.* TO 'supervisor'@'localhost';

