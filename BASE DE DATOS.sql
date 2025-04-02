CREATE SCHEMA users;
CREATE SCHEMA store;
CREATE SCHEMA buys;
CREATE SCHEMA sale;
CREATE SCHEMA promotion;

CREATE TABLE sale.sale(
	id SERIAL,
	id_user INTEGER NOT NULL,
	id_client INTEGER NOT NULL,
	id_detail INTEGER NOT NULL,
	date_sale DATE DEFAULT CURRENT_TIMESTAMP,
	stock INTEGER NULL,

	CONSTRAINT pk_sale PRIMARY KEY(id),
	CONSTRAINT fk_users_user FOREIGN KEY(id_user) REFERENCES users.users(id),
	CONSTRAINT fk_sale_client FOREIGN KEY(id_client) REFERENCES sale.client(id),
	CONSTRAINT fk_sale_detail FOREIGN KEY(id_detail) REFERENCES sale.sale_detail(id),
	CONSTRAINT stock_valid CHECK (stock>=0)
);

-- Índices para mejorar la búsqueda de ventas por usuario
CREATE INDEX idx_sale_user ON sale.sale (id_user); 
-- Ubicación: Después de la creación de la tabla `sale.sale`
CREATE INDEX idx_sale_date ON sale.sale (date_sale);
-- Ubicación: Después de la creación de la tabla `sale.sale`
-- Índices para mejorar la consulta de ingresos por mes y año
CREATE INDEX idx_sale_date_month_year ON sale.sale (date_sale);
-- Ubicación: Después de la creación de la tabla `sale.sale`
-- Índices para mejorar la consulta de productos con bajo stock
CREATE INDEX idx_stock ON sale.sale (stock);
-- Ubicación: Después de la creación de la tabla `sale.sale`
-- Índices para mejorar la consulta de clientes con compras más altas
CREATE INDEX idx_client_id ON sale.sale (id_client);
-- Ubicación: Después de la creación de la tabla `sale.sale`

CREATE TABLE sale.client(
	id SERIAL,
	name_client TEXT NOT NULL,

	CONSTRAINT pk_client PRIMARY KEY(id)
);

CREATE TABLE sale.sale_detail(
	id SERIAL,
	id_item INTEGER NOT NULL,
	cost_detail INTEGER NOT NULL,
	amount INTEGER NULL,

	CONSTRAINT pk_detail PRIMARY KEY(id),
	CONSTRAINT fk_store_item FOREIGN KEY(id_item) REFERENCES store.item(id),
	CONSTRAINT amount_valid CHECK (amount>=0)
);

CREATE INDEX idx_sale_detail_id ON sale.sale_detail (id);
-- Ubicación: Después de la creación de la tabla `sale.sale_detail

CREATE TABLE store.store(
	id SERIAL,
	id_user INTEGER NOT NULL,
	id_item INTEGER NOT NULL,
	date_store DATE DEFAULT CURRENT_TIMESTAMP,
	motion CHAR(1) NOT NULL,
	amount_store INTEGER NULL,
	final_amount INTEGER NULL,

	CONSTRAINT pk_store PRIMARY KEY(id),
	CONSTRAINT fk_users_user FOREIGN KEY(id_user) REFERENCES users.users(id),
	CONSTRAINT fk_store_item FOREIGN KEY(id_item) REFERENCES store.item(id),
	CONSTRAINT motion_valid CHECK (motion IN ('i', 's')),
	CONSTRAINT amount_valid CHECK (amount_store>=0)
);

-- Índices para mejorar la consulta de cantidad restante de productos
CREATE INDEX idx_store_item ON store.store (id_item);
-- Ubicación: Después de la creación de la tabla `store.store`

CREATE TABLE store.item(
	id SERIAL,
	name_item TEXT NOT NULL,
	description_item TEXT NOT NULL,

	CONSTRAINT pk_item PRIMARY KEY(id)
);

CREATE INDEX idx_item_id ON store.item (id);
-- Ubicación: Después de la creación de la tabla `store.item`

CREATE TABLE users.users(
	id SERIAL,
	name_user TEXT NOT NULL,
	password_user TEXT NOT NULL,

	CONSTRAINT pk_user PRIMARY KEY(id)
);

CREATE TABLE users.employee(
	id SERIAL,
	id_users INTEGER NOT NULL,
	name_employee TEXT NOT NULL,
	ap_paterno TEXT NULL,
	ap_materno TEXT NULL,

	CONSTRAINT pk_users_employee PRIMARY KEY(id),
	CONSTRAINT fk_users_user FOREIGN KEY(id_users) REFERENCES users.users(id)
);

CREATE TABLE users.contrat(
	id SERIAL,
	id_employee INTEGER NOT NULL,
	id_position INTEGER NOT NULL,
	date_contract DATE DEFAULT CURRENT_TIMESTAMP,
	type_contract TEXT NOT NULL,
	time_contrat INTEGER,
	
	CONSTRAINT pk_users_contract PRIMARY KEY(id),
	CONSTRAINT fk_uers_employee FOREIGN KEY(id_employee) REFERENCES users.employee(id),
	CONSTRAINT fk_uers_position FOREIGN KEY(id_position) REFERENCES users.position(id),
	CONSTRAINT time_valid CHECK (time_contrat>0)
);

CREATE INDEX idx_employee_position ON users.contrat (id_position);
-- Ubicación: Después de la creación de la tabla `users.contrat`

CREATE TABLE users.position(
	id SERIAL,
	name_position TEXT,
	description_position TEXT,

	CONSTRAINT pk_users_position PRIMARY KEY(id)
);

-- Índices para mejorar la búsqueda de empleados por cargo
CREATE INDEX idx_position_name ON users.position (name_position);
-- Ubicación: Después de la creación de la tabla `users.position`

CREATE TABLE users.area(
	id SERIAL,
	id_users_employee INTEGER NOT NULL,
	id_users_area INTEGER NOT NULL,

	CONSTRAINT pk_users_assing_area PRIMARY KEY(id),
	CONSTRAINT fk_uers_employee FOREIGN KEY(id_users_employee) REFERENCES users.employee(id),
	CONSTRAINT fk_uers_area FOREIGN KEY(id_users_area) REFERENCES users.area(id)
);

CREATE TABLE users.control_access(
	id SERIAL,
	id_user INTEGER NOT NULL,
	admin_control_access TEXT NULL,
	buys_control_access TEXT NULL,
	sale_control_access TEXT NULL,
	store_control_access TEXT NULL,

	CONSTRAINT pk_users_control_access PRIMARY KEY(id),
	CONSTRAINT fk_users_user FOREIGN KEY(id_user) REFERENCES users.users(id)
);

CREATE TABLE buys.buys(
	id SERIAL,
	id_user INTEGER NOT NULL,
	id_buys_detail INTEGER NOT NULL,
	id_buys_supplier INTEGER NOT NULL,
	date_buys DATE DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT pk_buys PRIMARY KEY(id),
	CONSTRAINT fk_users_user FOREIGN KEY(id_user) REFERENCES users.users(id),
	CONSTRAINT fk_buys_detail FOREIGN KEY(id_buys_detail) REFERENCES buys.buys_detail(id),
	CONSTRAINT fk_buys_supplier FOREIGN KEY(id_buys_supplier) REFERENCES buys.buys_supplier(id)
);

-- Índices para mejorar la consulta de empleados que han realizado compras
CREATE INDEX idx_buys_user ON buys.buys (id_user);
-- Ubicación: Después de la creación de la tabla `buys.buys`

CREATE TABLE buys.buys_detail(
	id SERIAL,
	id_item INTEGER NOT NULL,
	cost_detail INTEGER NOT NULL,
	amount_detail INTEGER NULL,

	CONSTRAINT pk_detail PRIMARY KEY(id),
	CONSTRAINT fk_store_item FOREIGN KEY(id_item) REFERENCES store.item(id),
	CONSTRAINT cost_valid CHECK (cost_detail>=0),
	CONSTRAINT amount_valid CHECK (amount_detail>=0)
);

-- Índices para mejorar la consulta de proveedores de un producto específico
CREATE INDEX idx_buys_detail_item ON buys.buys_detail (id_item);
-- Ubicación: Después de la creación de la tabla `buys.buys_detail`

CREATE TABLE buys.buys_supplier(
	id SERIAL,
	supplier_name TEXT NOT NULL,
	company_name TEXT NOT NULL,
	email TEXT NOT NULL,
	number_phone TEXT NOT NULL,

	CONSTRAINT pk_buys_supplier PRIMARY KEY(id)
);

CREATE TABLE promotion.promotion(
	id SERIAL,
	id_item INTEGER NOT NULL,
	date_promotion DATE DEFAULT CURRENT_TIMESTAMP,
	amount_promotion INTEGER NULL,
	discount INTEGER NULL,
	
	CONSTRAINT pk_promotion PRIMARY KEY(id),
	CONSTRAINT fk_store_item FOREIGN KEY(id_item) REFERENCES store.item(id),
	CONSTRAINT amount_valid CHECK (amount_promotion>=0),
	CONSTRAINT discount_valid CHECK (discount>0)
);

-- Índices para mejorar la consulta de promociones
CREATE INDEX idx_promotion_item ON promotion.promotion (id_item);
-- Ubicación: Después de la creación de la tabla `promotion.promotion`
CREATE INDEX idx_promotion_date ON promotion.promotion (date_promotion);
-- Ubicación: Después de la creación de la tabla `promotion.promotion`


-- Inserciones en la tabla users.users
INSERT INTO users.users (name_user, password_user) VALUES
('user1', 'pass1'), ('user2', 'pass2'), ('user3', 'pass3'),
('user4', 'pass4'), ('user5', 'pass5'), ('user6', 'pass6'),
('user7', 'pass7'), ('user8', 'pass8'), ('user9', 'pass9'), ('user10', 'pass10'),
('user11', 'pass11'), ('user12', 'pass12'), ('user13', 'pass13'), ('user14', 'pass14'), ('user15', 'pass15'),
('user16', 'pass16'), ('user17', 'pass17'), ('user18', 'pass18'), ('user19', 'pass19'), ('user20', 'pass20'),
('user21', 'pass21'), ('user22', 'pass22'), ('user23', 'pass23'), ('user24', 'pass24'), ('user25', 'pass25'),
('user26', 'pass26'), ('user27', 'pass27'), ('user28', 'pass28'), ('user29', 'pass29'), ('user30', 'pass30'),
('user31', 'pass31'), ('user32', 'pass32'), ('user33', 'pass33'), ('user34', 'pass34'), ('user35', 'pass35'),
('user36', 'pass36'), ('user37', 'pass37'), ('user38', 'pass38'), ('user39', 'pass39'), ('user40', 'pass40'),
('user41', 'pass41'), ('user42', 'pass42'), ('user43', 'pass43'), ('user44', 'pass44'), ('user45', 'pass45'),
('user46', 'pass46'), ('user47', 'pass47'), ('user48', 'pass48'), ('user49', 'pass49'), ('user50', 'pass50'),
('user51', 'pass51'), ('user52', 'pass52'), ('user53', 'pass53'), ('user54', 'pass54'), ('user55', 'pass55'),
('user56', 'pass56'), ('user57', 'pass57'), ('user58', 'pass58'), ('user59', 'pass59'), ('user60', 'pass60'),
('user61', 'pass61'), ('user62', 'pass62'), ('user63', 'pass63'), ('user64', 'pass64'), ('user65', 'pass65'),
('user66', 'pass66'), ('user67', 'pass67'), ('user68', 'pass68'), ('user69', 'pass69'), ('user70', 'pass70'),
('user71', 'pass71'), ('user72', 'pass72'), ('user73', 'pass73'), ('user74', 'pass74'), ('user75', 'pass75'),
('user76', 'pass76'), ('user77', 'pass77'), ('user78', 'pass78'), ('user79', 'pass79'), ('user80', 'pass80');

SELECT * FROM users.users; 

-- Inserciones en la tabla users.employee
INSERT INTO users.employee (id_users, name_employee, ap_paterno, ap_materno) VALUES
(1, 'Juan', 'Pérez', 'Gómez'), (2, 'María', 'López', 'Díaz'),
(3, 'Carlos', 'Martínez', 'Fernández'), (4, 'Ana', 'García', 'Rodríguez'),
(5, 'Pedro', 'Hernández', 'Ruiz'), (6, 'Laura', 'Torres', 'Sánchez'),
(7, 'Javier', 'Vargas', 'Ortega'), (8, 'Sofía', 'Jiménez', 'Morales'),
(9, 'Daniel', 'Castro', 'Mendoza'), (10, 'Lucía', 'Flores', 'González'),
(11, 'Ricardo', 'Mendoza', 'Alvarez'), (12, 'Elena', 'Ortega', 'Salinas'),
(13, 'Hugo', 'Ramírez', 'Cabrera'), (14, 'Beatriz', 'Domínguez', 'Cordero'),
(15, 'Andrés', 'Serrano', 'Galindo'), (16, 'Clara', 'Reyes', 'Bermúdez'),
(17, 'Santiago', 'Figueroa', 'Peralta'), (18, 'Gabriela', 'Escobar', 'Delgado'),
(19, 'Fernando', 'Carrasco', 'Esquivel'), (20, 'Patricia', 'Navarro', 'Pineda'),
(21, 'Alberto', 'Castañeda', 'Mejía'), (22, 'Diana', 'Cortés', 'Silva'),
(23, 'Raúl', 'Rangel', 'Ríos'), (24, 'Rosa', 'Meza', 'Villanueva'),
(25, 'Gustavo', 'Velázquez', 'Chávez'), (26, 'Isabel', 'Guerrero', 'Campos'),
(27, 'Francisco', 'Santos', 'Valencia'), (28, 'Alejandra', 'Pacheco', 'Peña'),
(29, 'Ernesto', 'Acosta', 'Miranda'), (30, 'Teresa', 'Barrera', 'Rojas'),
(31, 'Oscar', 'Luna', 'Aguilar'), (32, 'Verónica', 'Estrada', 'Paz'),
(33, 'Eduardo', 'Fuentes', 'Valdez'), (34, 'Silvia', 'Méndez', 'Lara'),
(35, 'Manuel', 'Salazar', 'Nava'), (36, 'Gloria', 'Arroyo', 'Ibarra'),
(37, 'Rodrigo', 'Herrera', 'Tapia'), (38, 'Carmen', 'Ríos', 'Solano'),
(39, 'Jorge', 'Montes', 'Quintero'), (40, 'Natalia', 'Rivera', 'Escamilla'),
(41, 'Adrián', 'López', 'Castaño'), (42, 'Mónica', 'Jiménez', 'Robledo'),
(43, 'Felipe', 'Ortega', 'Cardenas'), (44, 'Paula', 'Ramírez', 'Alcántara'),
(45, 'Emilio', 'Hernández', 'Montoya'), (46, 'Lorena', 'Serrano', 'Zamora'),
(47, 'Marcos', 'Gómez', 'Palacios'), (48, 'Valeria', 'Cortés', 'Burgos'),
(49, 'Héctor', 'Torres', 'Soria'), (50, 'Julia', 'Navarro', 'Trejo'),
(51, 'Armando', 'Vega', 'Franco'), (52, 'Estefanía', 'Salinas', 'Padilla'),
(53, 'Antonio', 'Rangel', 'Arellano'), (54, 'Elisa', 'Mejía', 'Beltrán'),
(55, 'Sebastián', 'Guerrero', 'Esparza'), (56, 'Marina', 'Acosta', 'Coronado'),
(57, 'Vicente', 'Flores', 'Velasco'), (58, 'Lourdes', 'Pacheco', 'Zavala'),
(59, 'Guillermo', 'Fuentes', 'Escobedo'), (60, 'Regina', 'Montoya', 'Galván'),
(61, 'Efraín', 'Méndez', 'Carrera'), (62, 'Celeste', 'Estrada', 'Cruz'),
(63, 'Raquel', 'Domínguez', 'Trujillo'), (64, 'Camilo', 'Salazar', 'Robles'),
(65, 'Bruno', 'Luna', 'Benavides'), (66, 'Violeta', 'Vega', 'Saldívar'),
(67, 'Israel', 'Herrera', 'Larios'), (68, 'Adriana', 'Reyes', 'Gallegos'),
(69, 'Mauricio', 'Gómez', 'Cervantes'), (70, 'Tatiana', 'Santos', 'Bravo'),
(71, 'Diego', 'Carrasco', 'Fierro'), (72, 'Susana', 'Ortega', 'Bautista'),
(73, 'Raúl', 'Arroyo', 'Mota'), (74, 'Fernanda', 'Cortés', 'Llamas'),
(75, 'Alejandro', 'Rivera', 'Urbina'), (76, 'Berenice', 'Ríos', 'Castañón'),
(77, 'Humberto', 'Meza', 'Tobías'), (78, 'Rosalía', 'Barrera', 'Del Río'),
(79, 'Pablo', 'Velázquez', 'Zárate'), (80, 'Carla', 'Guerrero', 'Cedillo');


SELECT * FROM users.employee;

-- Inserciones en la tabla users.position
INSERT INTO users.position (name_position, description_position) VALUES
('Gerente', 'Encargado general'), ('Vendedor', 'Atención al cliente'),
('Administrador', 'Gestión de recursos'), ('Supervisor', 'Control de procesos'),
('Contador', 'Manejo financiero'), ('Cajero', 'Cobro de ventas'),
('Almacén', 'Organización de stock'), ('Soporte', 'Asistencia técnica'),
('Marketing', 'Publicidad y promociones'), ('Seguridad', 'Vigilancia y control'),
('Analista', 'Análisis de datos y procesos'), ('Recepcionista', 'Atención de visitas y llamadas'),
('Técnico', 'Mantenimiento y reparación'), ('Diseñador', 'Creación de contenido visual'),
('Programador', 'Desarrollo de software'), ('Consultor', 'Asesoría y estrategias'),
('Operador', 'Manejo de maquinaria'), ('Coordinador', 'Supervisión de equipos'),
('Investigador', 'Análisis y estudios de mercado'), ('Instructor', 'Capacitación de personal'),
('Redactor', 'Elaboración de textos y documentos'), ('Editor', 'Revisión y corrección de contenido'),
('Ingeniero', 'Desarrollo de proyectos técnicos'), ('Especialista', 'Experto en área específica'),
('Abogado', 'Asesoría legal y cumplimiento'), ('Médico', 'Atención de salud interna'),
('Enfermero', 'Asistencia médica'), ('Psicólogo', 'Evaluación y bienestar del personal'),
('Arquitecto', 'Diseño y planificación estructural'), ('Desarrollador', 'Creación de aplicaciones y sistemas'),
('Community Manager', 'Gestión de redes sociales'), ('Fotógrafo', 'Captura y edición de imágenes'),
('Videógrafo', 'Producción y edición de videos'), ('Logística', 'Coordinación de transporte y entrega'),
('Mecánico', 'Mantenimiento de vehículos y maquinaria'), ('Electricista', 'Instalación y reparación eléctrica'),
('Plomero', 'Mantenimiento de tuberías y drenajes'), ('Carpintero', 'Fabricación de estructuras de madera'),
('Chef', 'Elaboración de platillos y menús'), ('Mesero', 'Atención en restaurantes y cafeterías'),
('Barman', 'Preparación de bebidas y cócteles'), ('Panadero', 'Producción de pan y repostería'),
('Pastelero', 'Elaboración de postres y dulces'), ('Conductor', 'Transporte de mercancía o personal'),
('Mensajero', 'Entrega de documentos y paquetes'), ('Agente de ventas', 'Promoción y comercialización'),
('Representante de clientes', 'Gestión de relaciones comerciales'), ('Capacitador', 'Formación de empleados'),
('Tesorero', 'Administración de fondos y presupuestos'), ('Auditor', 'Control financiero y administrativo'),
('Notario', 'Autenticación de documentos legales'), ('Traductor', 'Conversión de idiomas en documentos'),
('Intérprete', 'Traducción simultánea en eventos'), ('Guía turístico', 'Acompañamiento en recorridos turísticos'),
('Entrenador', 'Preparación física y deportiva'), ('Nutricionista', 'Planificación alimenticia'),
('Científico', 'Investigación y experimentación'), ('Biotecnólogo', 'Desarrollo de procesos biológicos'),
('Farmacéutico', 'Manejo de medicamentos y fórmulas'), ('Químico', 'Análisis y manipulación de sustancias'),
('Fisiólogo', 'Estudio del cuerpo humano y su funcionamiento'), ('Antropólogo', 'Investigación cultural y social'),
('Historiador', 'Análisis de eventos pasados'), ('Sociólogo', 'Estudios de comportamiento social'),
('Economista', 'Evaluación de mercados y políticas económicas'), ('Matemático', 'Desarrollo de modelos y análisis numéricos'),
('Profesor', 'Educación en distintas disciplinas'), ('Investigador académico', 'Desarrollo de estudios especializados'),
('Escritor', 'Creación de obras literarias'), ('Poeta', 'Composición de textos poéticos'),
('Músico', 'Interpretación y creación musical'), ('Cantante', 'Ejecución vocal en presentaciones'),
('Actor', 'Representación en obras y medios audiovisuales'), ('Director', 'Supervisión de producciones artísticas'),
('Productor', 'Gestión de proyectos audiovisuales'), ('Escultor', 'Creación de obras en tres dimensiones'),
('Pintor', 'Elaboración de obras pictóricas'), ('Ilustrador', 'Diseño gráfico y artístico');


SELECT * FROM users.position;

-- Inserciones en la tabla store.item
INSERT INTO store.item (name_item, description_item) VALUES
('Laptop', 'Computadora portátil'), ('Mouse', 'Dispositivo de entrada'),
('Teclado', 'Periférico de escritura'), ('Monitor', 'Pantalla LED'),
('Impresora', 'Equipo de impresión'), ('Router', 'Dispositivo de red'),
('Disco Duro', 'Almacenamiento externo'), ('Memoria RAM', 'Módulo de memoria'),
('Tablet', 'Dispositivo táctil'), ('Celular', 'Teléfono inteligente'),
('Cargador', 'Accesorio de carga eléctrica'), ('Auriculares', 'Dispositivo de audio personal'),
('Micrófono', 'Captación de sonido'), ('Cámara Web', 'Dispositivo de videoconferencia'),
('Smartwatch', 'Reloj inteligente'), ('Tarjeta Gráfica', 'Procesador de gráficos'),
('Fuente de Poder', 'Suministro eléctrico para computadoras'), ('Motherboard', 'Placa base de computadora'),
('Procesador', 'Unidad de procesamiento central'), ('Ventilador', 'Sistema de enfriamiento'),
('SSD', 'Unidad de estado sólido'), ('Cable HDMI', 'Conexión de video y audio'),
('Cable USB', 'Interfaz de conexión universal'), ('Bocinas', 'Sistema de audio externo'),
('Proyector', 'Dispositivo de proyección de imágenes'), ('Joystick', 'Controlador de videojuegos'),
('Gamepad', 'Mando para videojuegos'), ('Silla Gamer', 'Asiento ergonómico para jugadores'),
('Escritorio', 'Mueble para computadora'), ('Lámpara LED', 'Iluminación eficiente'),
('UPS', 'Sistema de alimentación ininterrumpida'), ('Mochila para Laptop', 'Bolsa de transporte'),
('Soporte para Monitor', 'Base ajustable para pantalla'), ('Teclado Mecánico', 'Teclado con interruptores mecánicos'),
('Mouse Inalámbrico', 'Dispositivo de entrada sin cables'), ('Memoria USB', 'Almacenamiento portátil'),
('HDD Externo', 'Disco duro portátil'), ('Hub USB', 'Extensión de puertos USB'),
('Convertidor VGA a HDMI', 'Adaptador de señal de video'), ('Adaptador Bluetooth', 'Conexión inalámbrica para dispositivos'),
('Software Antivirus', 'Protección contra malware'), ('Sistema Operativo', 'Software de gestión de hardware'),
('Impresora 3D', 'Fabricación aditiva'), ('Escáner', 'Digitalización de documentos'),
('Cámara Digital', 'Captura de imágenes'), ('Drone', 'Vehículo aéreo no tripulado'),
('GPS', 'Sistema de posicionamiento global'), ('Router Mesh', 'Sistema de red distribuida'),
('Extensor de WiFi', 'Ampliador de señal inalámbrica'), ('Smart TV', 'Televisor con conexión a internet'),
('Control Remoto', 'Dispositivo de mando a distancia'), ('Reproductor Blu-ray', 'Lector de discos ópticos'),
('Consola de Videojuegos', 'Plataforma de entretenimiento digital'), ('Tarjeta de Sonido', 'Mejora de audio en computadoras'),
('Panel Solar', 'Generador de energía renovable'), ('Cargador Inalámbrico', 'Carga por inducción electromagnética'),
('Batería Externa', 'Fuente de energía portátil'), ('Cámara de Seguridad', 'Sistema de vigilancia'),
('Alarma Inteligente', 'Dispositivo de seguridad doméstica'), ('Sensor de Movimiento', 'Detección de actividad'),
('Interruptor Inteligente', 'Control remoto de energía eléctrica'), ('Bombilla Inteligente', 'Iluminación programable'),
('Termostato Inteligente', 'Regulación automática de temperatura'), ('Aspiradora Robot', 'Limpieza automatizada'),
('Altavoz Inteligente', 'Dispositivo con asistente virtual'), ('Monitor Ultrawide', 'Pantalla de gran amplitud'),
('Laptop Gaming', 'Computadora portátil para juegos'), ('Cable Ethernet', 'Conexión de red cableada');

SELECT * FROM store.item;

-- Inserciones en la tabla sale.client
INSERT INTO sale.client (name_client) VALUES
('Cliente1'), ('Cliente2'), ('Cliente3'), ('Cliente4'), ('Cliente5'),
('Cliente6'), ('Cliente7'), ('Cliente8'), ('Cliente9'), ('Cliente10'),
('Cliente11'), ('Cliente12'), ('Cliente13'), ('Cliente14'), ('Cliente15'),
('Cliente16'), ('Cliente17'), ('Cliente18'), ('Cliente19'), ('Cliente20'),
('Cliente21'), ('Cliente22'), ('Cliente23'), ('Cliente24'), ('Cliente25'),
('Cliente26'), ('Cliente27'), ('Cliente28'), ('Cliente29'), ('Cliente30'),
('Cliente31'), ('Cliente32'), ('Cliente33'), ('Cliente34'), ('Cliente35'),
('Cliente36'), ('Cliente37'), ('Cliente38'), ('Cliente39'), ('Cliente40'),
('Cliente41'), ('Cliente42'), ('Cliente43'), ('Cliente44'), ('Cliente45'),
('Cliente46'), ('Cliente47'), ('Cliente48'), ('Cliente49'), ('Cliente50'),
('Cliente51'), ('Cliente52'), ('Cliente53'), ('Cliente54'), ('Cliente55'),
('Cliente56'), ('Cliente57'), ('Cliente58'), ('Cliente59'), ('Cliente60'),
('Cliente61'), ('Cliente62'), ('Cliente63'), ('Cliente64'), ('Cliente65'),
('Cliente66'), ('Cliente67'), ('Cliente68'), ('Cliente69'), ('Cliente70');

SELECT * FROM sale.client;

-- Inserciones en la tabla store.store
INSERT INTO store.store (id_user, id_item, motion, amount_store, final_amount) VALUES
(1, 1, 'i', 10, 10), (2, 2, 'i', 15, 15), (3, 3, 'i', 20, 20),
(4, 4, 'i', 25, 25), (5, 5, 'i', 30, 30), (6, 6, 'i', 12, 12),
(7, 7, 'i', 8, 8), (8, 8, 'i', 18, 18), (9, 9, 'i', 5, 5), (10, 10, 'i', 7, 7),
(11, 11, 'i', 14, 14), (12, 12, 'i', 22, 22), (13, 13, 'i', 16, 16),
(14, 14, 'i', 19, 19), (15, 15, 'i', 24, 24), (16, 16, 'i', 28, 28),
(17, 17, 'i', 11, 11), (18, 18, 'i', 9, 9), (19, 19, 'i', 21, 21), (20, 20, 'i', 13, 13),
(21, 21, 'i', 17, 17), (22, 22, 'i', 23, 23), (23, 23, 'i', 27, 27), (24, 24, 'i', 26, 26),
(25, 25, 'i', 29, 29), (26, 26, 'i', 31, 31), (27, 27, 'i', 33, 33), (28, 28, 'i', 35, 35),
(29, 29, 'i', 37, 37), (30, 30, 'i', 39, 39), (31, 31, 'i', 41, 41), (32, 32, 'i', 43, 43),
(33, 33, 'i', 45, 45), (34, 34, 'i', 47, 47), (35, 35, 'i', 49, 49), (36, 36, 'i', 51, 51),
(37, 37, 'i', 53, 53), (38, 38, 'i', 55, 55), (39, 39, 'i', 57, 57), (40, 40, 'i', 59, 59),
(41, 41, 'i', 61, 61), (42, 42, 'i', 63, 63), (43, 43, 'i', 65, 65), (44, 44, 'i', 67, 67),
(45, 45, 'i', 69, 69), (46, 46, 'i', 71, 71), (47, 47, 'i', 73, 73), (48, 48, 'i', 75, 75),
(49, 49, 'i', 77, 77), (50, 50, 'i', 79, 79), (51, 51, 'i', 81, 81), (52, 52, 'i', 83, 83),
(53, 53, 'i', 85, 85), (54, 54, 'i', 87, 87), (55, 55, 'i', 89, 89), (56, 56, 'i', 91, 91),
(57, 57, 'i', 93, 93), (58, 58, 'i', 95, 95), (59, 59, 'i', 97, 97), (60, 60, 'i', 99, 99),
(61, 61, 'i', 101, 101), (62, 62, 'i', 103, 103), (63, 63, 'i', 105, 105), (64, 64, 'i', 107, 107),
(65, 65, 'i', 109, 109), (66, 66, 'i', 111, 111), (67, 67, 'i', 113, 113), (68, 68, 'i', 115, 115),
(69, 69, 'i', 117, 117), (70, 70, 'i', 119, 119), (71, 71, 'i', 121, 121), (72, 72, 'i', 123, 123),
(73, 73, 'i', 125, 125), (74, 74, 'i', 127, 127), (75, 75, 'i', 129, 129), (76, 76, 'i', 131, 131),
(77, 77, 'i', 133, 133), (78, 78, 'i', 135, 135), (79, 79, 'i', 137, 137), (80, 80, 'i', 139, 139);


SELECT * FROM store.store;

-- Inserciones en la tabla buys.buys_supplier
INSERT INTO buys.buys_supplier (supplier_name, company_name, email, number_phone) VALUES
('Proveedor1', 'Empresa1', 'proveedor1@email.com', '555-1111'),
('Proveedor2', 'Empresa2', 'proveedor2@email.com', '555-2222'),
('Proveedor3', 'Empresa3', 'proveedor3@email.com', '555-3333'),
('Proveedor4', 'Empresa4', 'proveedor4@email.com', '555-4444'),
('Proveedor5', 'Empresa5', 'proveedor5@email.com', '555-5555'),
('Proveedor6', 'Empresa6', 'proveedor6@email.com', '555-6666'),
('Proveedor7', 'Empresa7', 'proveedor7@email.com', '555-7777'),
('Proveedor8', 'Empresa8', 'proveedor8@email.com', '555-8888'),
('Proveedor9', 'Empresa9', 'proveedor9@email.com', '555-9999'),
('Proveedor10', 'Empresa10', 'proveedor10@email.com', '555-0000'),
('Proveedor11', 'Empresa11', 'proveedor11@email.com', '555-1112'),
('Proveedor12', 'Empresa12', 'proveedor12@email.com', '555-2223'),
('Proveedor13', 'Empresa13', 'proveedor13@email.com', '555-3334'),
('Proveedor14', 'Empresa14', 'proveedor14@email.com', '555-4445'),
('Proveedor15', 'Empresa15', 'proveedor15@email.com', '555-5556'),
('Proveedor16', 'Empresa16', 'proveedor16@email.com', '555-6667'),
('Proveedor17', 'Empresa17', 'proveedor17@email.com', '555-7778'),
('Proveedor18', 'Empresa18', 'proveedor18@email.com', '555-8889'),
('Proveedor19', 'Empresa19', 'proveedor19@email.com', '555-9990'),
('Proveedor20', 'Empresa20', 'proveedor20@email.com', '555-0001'),
('Proveedor21', 'Empresa21', 'proveedor21@email.com', '555-1113'),
('Proveedor22', 'Empresa22', 'proveedor22@email.com', '555-2224'),
('Proveedor23', 'Empresa23', 'proveedor23@email.com', '555-3335'),
('Proveedor24', 'Empresa24', 'proveedor24@email.com', '555-4446'),
('Proveedor25', 'Empresa25', 'proveedor25@email.com', '555-5557'),
('Proveedor26', 'Empresa26', 'proveedor26@email.com', '555-6668'),
('Proveedor27', 'Empresa27', 'proveedor27@email.com', '555-7779'),
('Proveedor28', 'Empresa28', 'proveedor28@email.com', '555-8880'),
('Proveedor29', 'Empresa29', 'proveedor29@email.com', '555-9991'),
('Proveedor30', 'Empresa30', 'proveedor30@email.com', '555-0002'),
('Proveedor31', 'Empresa31', 'proveedor31@email.com', '555-1114'),
('Proveedor32', 'Empresa32', 'proveedor32@email.com', '555-2225'),
('Proveedor33', 'Empresa33', 'proveedor33@email.com', '555-3336'),
('Proveedor34', 'Empresa34', 'proveedor34@email.com', '555-4447'),
('Proveedor35', 'Empresa35', 'proveedor35@email.com', '555-5558'),
('Proveedor36', 'Empresa36', 'proveedor36@email.com', '555-6669'),
('Proveedor37', 'Empresa37', 'proveedor37@email.com', '555-7770'),
('Proveedor38', 'Empresa38', 'proveedor38@email.com', '555-8881'),
('Proveedor39', 'Empresa39', 'proveedor39@email.com', '555-9992'),
('Proveedor40', 'Empresa40', 'proveedor40@email.com', '555-0003'),
('Proveedor41', 'Empresa41', 'proveedor41@email.com', '555-1115'),
('Proveedor42', 'Empresa42', 'proveedor42@email.com', '555-2226'),
('Proveedor43', 'Empresa43', 'proveedor43@email.com', '555-3337'),
('Proveedor44', 'Empresa44', 'proveedor44@email.com', '555-4448'),
('Proveedor45', 'Empresa45', 'proveedor45@email.com', '555-5559'),
('Proveedor46', 'Empresa46', 'proveedor46@email.com', '555-6670'),
('Proveedor47', 'Empresa47', 'proveedor47@email.com', '555-7781'),
('Proveedor48', 'Empresa48', 'proveedor48@email.com', '555-8892'),
('Proveedor49', 'Empresa49', 'proveedor49@email.com', '555-9903'),
('Proveedor50', 'Empresa50', 'proveedor50@email.com', '555-0014');


SELECT * FROM buys.buys_supplier;

-- Inserciones en la tabla promotion.promotion
INSERT INTO promotion.promotion (id_item, amount_promotion, discount) VALUES
(1, 5, 10), (2, 7, 15), (3, 6, 20), (4, 8, 25), (5, 10, 30),
(6, 9, 35), (7, 12, 40), (8, 14, 45), (9, 11, 50), (10, 13, 55);

SELECT * FROM promotion.promotion;

INSERT INTO buys.buys_detail (id, id_item, cost_detail, amount_detail) VALUES
(1, 1, 1000, 5), (2, 2, 1500, 10), (3, 3, 2000, 8), (4, 4, 2500, 6), 
(5, 5, 3000, 12), (6, 6, 3500, 15), (7, 7, 4000, 20), (8, 8, 4500, 25), 
(9, 9, 5000, 30), (10, 10, 5500, 35), 

SELECT * FROM buys.buys_detail;

-- Inserciones en la tabla buys.buys
INSERT INTO buys.buys (id_user, id_buys_detail, id_buys_supplier) VALUES
(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5),
(6, 6, 6), (7, 7, 7), (8, 8, 8), (9, 9, 9), (10, 10, 10);

SELECT * FROM buys.buys;

-- Inserciones en la tabla sale.sale
INSERT INTO sale.sale (id_user, id_client, id_detail, stock) VALUES
(1, 1, 1, 5), (2, 2, 2, 10), (3, 3, 3, 8), (4, 4, 4, 6), (5, 5, 5, 12),
(6, 6, 6, 15), (7, 7, 7, 20), (8, 8, 8, 25), (9, 9, 9, 30), (10, 10, 10, 35);

SELECT * FROM sale.sale;

-- Inserciones en la tabla sale.sale_detail
INSERT INTO sale.sale_detail (id_item, cost_detail, amount) VALUES
(1, 500, 2), (2, 150, 4), (3, 250, 3), (4, 350, 5), (5, 450, 6),
(6, 550, 7), (7, 650, 8), (8, 750, 9), (9, 850, 10), (10, 950, 11),
(11, 1050, 12), (12, 1150, 13), (13, 1250, 14), (14, 1350, 15), (15, 1450, 16),
(16, 1550, 17), (17, 1650, 18), (18, 1750, 19), (19, 1850, 20), (20, 1950, 21),
(21, 2050, 22), (22, 2150, 23), (23, 2250, 24), (24, 2350, 25), (25, 2450, 26),
(26, 2550, 27), (27, 2650, 28), (28, 2750, 29), (29, 2850, 30), (30, 2950, 31),
(31, 3050, 32), (32, 3150, 33), (33, 3250, 34), (34, 3350, 35), (35, 3450, 36),
(36, 3550, 37), (37, 3650, 38), (38, 3750, 39), (39, 3850, 40), (40, 3950, 41),
(41, 4050, 42), (42, 4150, 43), (43, 4250, 44), (44, 4350, 45), (45, 4450, 46),
(46, 4550, 47), (47, 4650, 48), (48, 4750, 49), (49, 4850, 50), (50, 4950, 51);

SELECT * FROM sale.sale_detail;



----------------------------------------------------------------------------------------------------------------------------------------------------------------------


DELETE FROM buys.buys;
DELETE FROM buys.buys_detail;
DELETE FROM buys.buys_supplier;
DELETE FROM sale.sale;
DELETE FROM sale.client;
DELETE FROM sale.sale_detail;
DELETE FROM store.store;
DELETE FROM store.item;
DELETE FROM users.control_access;
DELETE FROM users.area;
DELETE FROM users.contrat;
DELETE FROM users.position;
DELETE FROM users.employee;
DELETE FROM users.users;
DELETE FROM promotion.promotion;








 SELECT 
    s.id AS product_id,               -- ID del producto
    s.name_item AS product_name,       -- Nombre del producto
    s.description_item AS product_description,  -- Descripción del producto
    p.id AS promotion_id,              -- ID de la promoción
    p.date_promotion AS promotion_date, -- Fecha de la promoción
    p.amount_promotion AS promotion_amount, -- Cantidad de la promoción
    p.discount AS promotion_discount  -- Descuento de la promoción
FROM 
    store.item s
JOIN 
    promotion.promotion p ON s.id = p.id_item  -- Relaciona la promoción con el producto
ORDER BY 
    p.date_promotion DESC; 



    

SELECT 
    s.id AS sale_id,                      -- ID de la venta
    s.date_sale AS sale_date,              -- Fecha de la venta
    c.name_client AS client_name,          -- Nombre del cliente asociado a la venta
    sd.id_item AS product_id,              -- ID del producto vendido
    i.name_item AS product_name,           -- Nombre del producto vendido
    sd.cost_detail AS product_cost,        -- Costo del producto vendido
    sd.amount AS amount_sold,              -- Cantidad del producto vendido
    s.stock AS stock_after_sale            -- Stock después de la venta
FROM 
    sale.sale s
JOIN 
    sale.client c ON s.id_client = c.id   -- Relaciona la venta con el cliente
JOIN 
    sale.sale_detail sd ON s.id_detail = sd.id  -- Relaciona la venta con los detalles
JOIN 
    store.item i ON sd.id_item = i.id    -- Relaciona los detalles con los productos
WHERE 
    s.id_user = 1                         -- Reemplaza '1' con el ID del usuario específico
ORDER BY 
    s.date_sale DESC;                     -- Ordena las ventas por la fecha, de más reciente a más antigua



	SELECT 
    e.id AS employee_id,                   -- ID del empleado
    e.name_employee AS employee_name,       -- Nombre del empleado
    e.ap_paterno AS paternal_last_name,     -- Apellido paterno
    e.ap_materno AS maternal_last_name,     -- Apellido materno
    p.name_position AS position_name,       -- Nombre del cargo/posición
    p.description_position AS position_desc -- Descripción del cargo
FROM 
    users.employee e
JOIN 
    users.contrat c ON e.id = c.id_employee       -- Relaciona el empleado con su contrato
JOIN 
    users.position p ON c.id_position = p.id      -- Relaciona el contrato con la posición
WHERE 
    p.name_position = 'Cargo X';                 -- Reemplaza 'Cargo X' con el nombre del cargo deseado


SELECT 
    e.id AS employee_id,                    -- ID del empleado
    e.name_employee AS employee_name,        -- Nombre del empleado
    e.ap_paterno AS paternal_last_name,      -- Apellido paterno del empleado
    e.ap_materno AS maternal_last_name,      -- Apellido materno del empleado
    p.name_position AS position_name,        -- Nombre del cargo/posición
    p.description_position AS position_desc, -- Descripción del cargo
    b.id AS buy_id,                          -- ID de la compra
    b.date_buys AS buy_date                  -- Fecha de la compra
FROM 
    users.employee e
JOIN 
    users.contrat c ON e.id = c.id_employee         -- Relaciona el empleado con su contrato
JOIN 
    users.position p ON c.id_position = p.id        -- Relaciona el contrato con la posición
JOIN 
    buys.buys b ON b.id_user = e.id                 -- Relaciona la compra con el empleado
WHERE 
    b.id_user IS NOT NULL;                          -- Solo empleados que han realizado una compra



	SELECT 
    i.name_item,                                  -- Nombre del producto
    i.description_item,                           -- Descripción del producto
    COALESCE(SUM(CASE WHEN s.motion = 'i' THEN s.amount_store ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN s.motion = 's' THEN s.amount_store ELSE 0 END), 0) AS remaining_quantity -- Cantidad restante
FROM 
    store.item i
LEFT JOIN 
    store.store s ON i.id = s.id_item            -- Unir con la tabla de inventarios
WHERE 
    i.id = 1                                      -- Reemplaza con el ID del producto que deseas consultar
GROUP BY 
    i.id, i.name_item, i.description_item;        -- Agrupar por el producto



SELECT 
    bs.supplier_name,        -- Nombre del proveedor
    bs.company_name,         -- Nombre de la empresa del proveedor
    bs.email,                -- Correo electrónico del proveedor
    bs.number_phone          -- Número de teléfono del proveedor
FROM 
    buys.buys b
JOIN 
    buys.buys_detail bd ON b.id_buys_detail = bd.id  -- Correlacionamos id_buys_detail con id de buys_detail
JOIN 
    buys.buys_supplier bs ON b.id_buys_supplier = bs.id
JOIN 
    store.item i ON bd.id_item = i.id
WHERE 
    i.id = 1;  -- Reemplaza "1" con el ID del producto que deseas buscar


SELECT 
    SUM(sd.amount * sd.cost_detail) AS total_income  -- Sumar los ingresos (cantidad * precio)
FROM 
    sale.sale s
JOIN 
    sale.sale_detail sd ON s.id_detail = sd.id  -- Unir las tablas de ventas y detalles de ventas
WHERE 
    EXTRACT(MONTH FROM s.date_sale) = 3   -- Reemplaza el 3 con el mes deseado (1-12)
    AND EXTRACT(YEAR FROM s.date_sale) = 2025;  -- Reemplaza 2025 con el año deseado


SELECT 
    i.name_item,                          -- Nombre del producto
    SUM(sd.amount) AS total_sold          -- Suma de las cantidades vendidas
FROM 
    sale.sale s
JOIN 
    sale.sale_detail sd ON s.id_detail = sd.id   -- Unimos las tablas de ventas y detalles de ventas
JOIN 
    store.item i ON sd.id_item = i.id           -- Unimos con la tabla de productos
GROUP BY 
    i.name_item                                -- Agrupamos por producto
ORDER BY 
    total_sold DESC                            -- Ordenamos por la cantidad vendida de mayor a menor
                                        -- Limitamos a 1 para obtener solo el más vendido


SELECT 
    c.name_client,                         -- Nombre del cliente
    SUM(sd.amount) AS total_products_bought -- Suma de la cantidad de productos comprados
FROM 
    sale.sale s
JOIN 
    sale.sale_detail sd ON s.id_detail = sd.id  -- Unimos la tabla de ventas con los detalles de venta
JOIN 
    sale.client c ON s.id_client = c.id        -- Unimos la tabla de clientes
GROUP BY 
    c.name_client                             -- Agrupamos por cliente
ORDER BY 
    total_products_bought DESC                 -- Ordenamos de mayor a menor por la cantidad de productos comprados
                                       -- Limitamos a 1 para obtener al cliente que más productos ha comprado



SELECT 
    c.name_client,                                   -- Nombre del cliente
    SUM(sd.amount * sd.cost_detail) AS total_cost     -- Suma del costo total de las compras
FROM 
    sale.sale s
JOIN 
    sale.sale_detail sd ON s.id_detail = sd.id       -- Unimos la tabla de ventas con los detalles de venta
JOIN 
    sale.client c ON s.id_client = c.id              -- Unimos la tabla de clientes
GROUP BY 
    c.name_client                                    -- Agrupamos por cliente
ORDER BY 
    total_cost DESC                                  -- Ordenamos de mayor a menor por el costo total de compra
                                            -- Limitamos a 1 para obtener al cliente con el costo más alto



SELECT COUNT(*) AS total_clients
FROM sale.client;



SELECT sd.id_item, i.name_item, i.description_item, s.stock
FROM sale.sale s
JOIN sale.sale_detail sd ON s.id_detail = sd.id
JOIN store.item i ON sd.id_item = i.id
WHERE s.stock < 10;
