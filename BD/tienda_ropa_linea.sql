/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     18/8/2025 12:49:33                           */
/*==============================================================*/


CREATE DATABASE tienda_ropa_linea;

drop table if exists CATEGORIAS;

drop table if exists CLIENTES;

drop table if exists DETALLE_PEDIDOS;

drop table if exists INVENTARIO;

drop table if exists PAGOS;

drop table if exists PEDIDOS;

drop table if exists PRODUCTOS;

drop table if exists USUARIOS;

/*==============================================================*/
/* Table: CATEGORIAS                                            */
/*==============================================================*/
create table CATEGORIAS
(
   ID_CATEGORIA         int not null,
   NOMBRE_CATEGORIA     varchar(50),
   primary key (ID_CATEGORIA)
);

/*==============================================================*/
/* Table: CLIENTES                                              */
/*==============================================================*/
create table CLIENTES
(
   ID_CLIENTE           int not null,
   NOMBRE_COMPLETO      varchar(50),
   DIRECCION            varchar(50),
   CORREO_ELECTRONICO   varchar(50),
   NUMERO_TELEFONICO    int,
   primary key (ID_CLIENTE)
);

/*==============================================================*/
/* Table: DETALLE_PEDIDOS                                       */
/*==============================================================*/
create table DETALLE_PEDIDOS
(
   ID_DETALLE_PEDIDOS   int not null,
   ID_PEDIDO            int not null,
   ID_PRODUCTO          int not null,
   FECHA_PEDIDO_DETALLE int,
   PRECIO_UNITARIO      numeric(50,0),
   primary key (ID_DETALLE_PEDIDOS)
);

/*==============================================================*/
/* Table: INVENTARIO                                            */
/*==============================================================*/
create table INVENTARIO
(
   ID_INVENTARIO        int not null,
   CANTIDAD             numeric(50,0),
   primary key (ID_INVENTARIO)
);

/*==============================================================*/
/* Table: PAGOS                                                 */
/*==============================================================*/
create table PAGOS
(
   ID_PAGO              int not null,
   ID_PEDIDO            int not null,
   FECHA_PAGO           date,
   MONTO_TOTAL          float(50),
   METODO_PAGO          varchar(50),
   primary key (ID_PAGO)
);

/*==============================================================*/
/* Table: PEDIDOS                                               */
/*==============================================================*/
create table PEDIDOS
(
   ID_PEDIDO            int not null,
   ID_CLIENTE           int not null,
   FECHA_PEDIDO_DETALLE int,
   ESTADO               varchar(50),
   primary key (ID_PEDIDO)
);

/*==============================================================*/
/* Table: PRODUCTOS                                             */
/*==============================================================*/
create table PRODUCTOS
(
   ID_PRODUCTO          int not null,
   ID_CATEGORIA         int not null,
   ID_INVENTARIO        int not null,
   NOMBRE               varchar(50),
   DESCRIPCION          varchar(50),
   PRECIO               float(50),
   TALLA                varchar(50),
   COLOR                varchar(50),
   primary key (ID_PRODUCTO)
);

/*==============================================================*/
/* Table: USUARIOS                                              */
/*==============================================================*/
create table USUARIOS
(
   ID_USUARIO           int not null,
   NOMBRE_USUARIO       varchar(50),
   CONTRASENA           varchar(50),
   ROL                  varchar(50),
   primary key (ID_USUARIO)
);

alter table DETALLE_PEDIDOS add constraint FK_APARECE_EN foreign key (ID_PRODUCTO)
      references PRODUCTOS (ID_PRODUCTO) on delete restrict on update restrict;

alter table DETALLE_PEDIDOS add constraint FK_INCLUYE foreign key (ID_PEDIDO)
      references PEDIDOS (ID_PEDIDO) on delete restrict on update restrict;

alter table PAGOS add constraint FK_TIENE_PAGO foreign key (ID_PEDIDO)
      references PEDIDOS (ID_PEDIDO) on delete restrict on update restrict;

alter table PEDIDOS add constraint FK_REALIZA foreign key (ID_CLIENTE)
      references CLIENTES (ID_CLIENTE) on delete restrict on update restrict;

alter table PRODUCTOS add constraint FK_CONTIENE foreign key (ID_CATEGORIA)
      references CATEGORIAS (ID_CATEGORIA) on delete restrict on update restrict;

alter table PRODUCTOS add constraint FK_TIENE foreign key (ID_INVENTARIO)
      references INVENTARIO (ID_INVENTARIO) on delete restrict on update restrict;

--- Creacion de Usuarios y privilegios ---

-- Usuarios MySQL
CREATE USER 'Administrador'@'localhost' IDENTIFIED BY 'administrador';
CREATE USER 'Desarrollador'@'localhost' IDENTIFIED BY 'desarollador';
CREATE USER 'Supervisor'@'localhost' IDENTIFIED BY 'supervisor';

-- Otorgar todos los privilegios sobre toda la base de datos
GRANT ALL PRIVILEGES ON tienda_ropa_linea.* TO 'Administrador'@'localhost';

-- Otorgar permisos SELECT, INSERT, UPDATE, DELETE en todas las tablas relevantes
GRANT SELECT, INSERT, UPDATE ON tienda_ropa_linea.categorias TO 'Desarrollador'@'localhost';
GRANT SELECT, INSERT, UPDATE ON tienda_ropa_linea.clientes TO 'Desarrollador'@'localhost';
GRANT SELECT, INSERT, UPDATE ON tienda_ropa_linea.detalle_pedidos TO 'Desarrollador'@'localhost';
GRANT SELECT, INSERT, UPDATE ON tienda_ropa_linea.inventario TO 'Desarrollador'@'localhost';
GRANT SELECT, INSERT, UPDATE ON tienda_ropa_linea.pedidos TO 'Desarrollador'@'localhost';
GRANT SELECT, INSERT, UPDATE ON tienda_ropa_linea.prooductos TO 'Desarrollador'@'localhost';
GRANT SELECT, INSERT, UPDATE ON tienda_ropa_linea.pagos TO 'Desarrollador'@'localhost';

-- Permisos de solo lectura para todas las tablas del sistema
GRANT SELECT ON tienda_ropa_linea.categorias TO 'Supervisor'@'localhost';
GRANT SELECT ON tienda_ropa_linea.clientes TO 'Supervispr'@'localhost';
GRANT SELECT ON tienda_ropa_linea.detalle_pedidos TO 'Supervisor'@'localhost';
GRANT SELECT ON tienda_ropa_linea.inventario TO 'Supervisor'@'localhost';
GRANT SELECT ON tienda_ropa_linea.pedidos TO 'Supervisor'@'localhost';
GRANT SELECT ON tienda_ropa_linea.prooductos TO 'Supervisor'@'localhost';
GRANT SELECT ON tienda_ropa_linea.pagos TO 'Supervisor'@'localhost';
