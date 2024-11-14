drop table if exists historial_stock;
drop table if exists detalle_pedido;
drop table if exists cabecera_pedido;
drop table if exists estado_pedido;
drop table if exists proveedores;
drop table if exists tipo_documento;
drop table if exists detalle_venta;
drop table if exists productos;
drop table if exists unidades_medida;
drop table if exists categorias_um;
drop table if exists categorias;
drop table if exists cabecera_venta;


create table categorias(
	codigo_cat serial not null,
	nombre varchar(100) not null,
	categoria_padre int,
	constraint categorias_pk primary key(codigo_cat),
	constraint categorias_fk foreign key(categoria_padre)
	references categorias(codigo_cat)
);
insert into categorias(nombre, categoria_padre)
values('Materia Prima',null),
('Proteina',1),
('Salsas',1),
('Punto de Venta',null),
('Bebidas',4),
('Con Alcohol',5),
('Sin Alcohol',5);
create table categorias_um(
	codigo_um char(1) not null,
	nombre varchar(100) not null,
	constraint categorias_um_pk primary key (codigo_um)
);
insert into categorias_um(codigo_um, nombre)
values('U','Unidad'),
('V','Volumen'),
('P','Peso'),
('L','Longitud');
create table unidades_medida(
	codigo_um varchar(2) not null,
	descripcion varchar(100) not null,
	categoria_um char(1) not null,
	constraint unidades_medida_pk primary key(codigo_um),
	constraint unidades_medida_fk foreign key(categoria_um)
	references categorias_um(codigo_um)
);
insert into unidades_medida(codigo_um,descripcion,categoria_um)
values('ml','Mililitros','V'),
('l','Litros','V'),
('u','Unidad','U'),
('d','Docena','U'),
('g','Gramos','P'),
('kg','Kilogramos','P'),
('lb','Libras','P');
create table productos(
	codigo_pr serial not null,
	nombre varchar(100) not null,
	unidad_m varchar(2) not null,
	precio_venta money not null,
	tiene_iva boolean not null,
	coste money not null,
	categoria int not null,
	stock int not null,
	constraint productos_pk primary key (codigo_pr),
	constraint productos_fk foreign key (unidad_m)
	references unidades_medida(codigo_um),
	constraint productos_fk2 foreign key (categoria)
	references categorias(codigo_cat)
);
insert into productos(nombre,unidad_m,precio_venta,tiene_iva,coste,categoria,stock)
values ('Coca-Cola','u',0.58, TRUE,0.37,7,100),
('Salsa de Tomate','kg',0.95, TRUE,0.87,3,50),
('Fuze Tea','u',0.23, TRUE,0.19,7,67);
create table cabecera_venta(
	codigo serial not null,
	fecha timestamp not null,
	total_sin_iva money not null,
	iva money not null,
	total money not null,
	constraint cabecera_venta_pk primary key (codigo)
);
insert into cabecera_venta(fecha,total_sin_iva,iva,total)
values('20/10/2023 20:23',3.26,0.39,3.65);
create table detalle_venta(
	codigo serial not null,
	cabecera_venta int not null,
	producto int not null,
	cantidad int not null,
	precio_venta money not null,
	subtotal money not null,
	subtotal_con_iva money not null,
	constraint detalle_venta_pk primary key(codigo),
	constraint detalle_venta_cabecera_venta_Fk foreign key (cabecera_venta)
	references cabecera_venta(codigo),
	constraint detalle_venta_productos_Fk foreign key (producto)
	references productos(codigo_pr)
);
insert into detalle_venta(cabecera_venta,producto,cantidad,precio_venta,subtotal,subtotal_con_iva)
values(1,1,5,0.58,2.9,3.25),
(1,3,1,0.36,0.36,0.4);
create table tipo_documento(
	codigo char(1) not null,
	descripcion varchar(50) not null,
	constraint tipo_documento_pk primary key(codigo)
);
insert into tipo_documento(codigo, descripcion)
values ('C','Cedula'),
('R','Ruc');
create table proveedores(
	identificador varchar(13) not null,
	tipo_documento char(1)not null,
	nombre varchar(100)not null,
	telefono char(10) not null,
	correo varchar(100) not null,
	direccion varchar(100) not null,
	constraint proveedores_pk primary key(identificador),
	constraint proveedores_fk foreign key (tipo_documento)
	references tipo_documento(codigo)
);
insert into proveedores(identificador,tipo_documento,nombre,telefono,correo,direccion)
values('1715614788001','R','Alexandra Flores','0998733975','alexaflorib@gmail.com','Comité del Pueblo'),
('1751013192','C','Martín Simbaña','0983331900', 'martin.simbana007@gmail.com','Comité del Pueblo');
create table estado_pedido(
	codigo char(1)not null,
	descripcion varchar(50) not null,
	constraint estado_pedido_PK primary key (codigo)
);
insert into estado_pedido(codigo, descripcion)
values ('S', 'Solicitado'),
('R','Recibido');
create table cabecera_pedido(
	numero_pedido serial not null,
	proveedor varchar(13) not null,
	fecha date not null,
	estado char(1) not null,
	constraint cabecera_pedido_PK primary key(numero_pedido),
	constraint cabecera_pedido_proveedores_Fk foreign key (proveedor)
	references proveedores(identificador),
	constraint cabecera_pedido_estado_pedido_Fk foreign key (estado)
	references estado_pedido(codigo)	
);
insert into cabecera_pedido(proveedor,fecha,estado)
values('1751013192','30/11/2023','R'),
('1715614788001','30/11/2023','S');
create table detalle_pedido(
	codigo serial not null,
	cabecera_pedido int not null,
	producto int not null,
	cantidad_solicitada int not null,
	subtotal money not null,
	cantida_recibida int not null,
	constraint detalle_pedido_Pk primary key (codigo),
	constraint detalle_pedido_cabecera_pedido_Fk foreign key(cabecera_pedido)
	references cabecera_pedido(numero_pedido),
	constraint detalle_pedido_productos_Fk foreign key (producto)
	references productos(codigo_pr)
);
insert into detalle_pedido(cabecera_pedido,producto,cantidad_solicitada,subtotal,cantida_recibida)
values(1,1,100,37.29,100),
(1,3,50,11.8,50);
create table historial_stock(
	codigo serial not null,
	fecha timestamp not null,
	referencia varchar(100)not null,
	producto int not null,
	cantidad int not null,
	constraint historial_stock_PK primary key(codigo),
	constraint historial_stock_productos_Fk foreign key (producto)
	references productos(codigo_pr)
);
insert into historial_stock(fecha,referencia,producto,cantidad)
values('19/10/2023 15:23:27','P1',1,100),
('20/10/2023 24:00','P1',3,50);

select * from detalle_pedido
