/*
PRACTICA 1 (SYSTEM):
1.-CREAR TABLESPACE
2.-CREAR USARIO/SCHEMA
3.-SE LE ASIGNA EL TABLESPACE CREADO AL USUARIO
4.-SE LE DAN TODOS LOS PRIVILEGIOS AL USUARIO CREADO
---------------------------------------------------------------------------------------------------------------------*/
/*CREAR UN ESPACIO EN MEMORIA PARA TABLESPACE MITABLESPACE*/
CREATE TABLESPACE MITABLESPACE DATAFILE 'C:\TABLESPACES\DATAFILE1.DBF' SIZE 30M;
/*SE MODIFICA EL TABLESPACE PARA AGREGAR OTRO DATAFILE*/
--ALTER TABLESPACE MITABLESPACE ADD DATAFILE 'C:\TABLESPACES\DATAFILE2.DBF' SIZE 30M;
/*SE ALTERA EL DATAFILE PARA AUMENTARLE LA CAPACIDAD DE ESPACIO DE MEMORIA*/
--ALTER DATABASE DATAFILE 'C:\TABLESPACES\DATAFILE1.DBF' RESIZE 35M;
SELECT * FROM DBA_DATA_FILES;--CONSULTA DATAFILES CREADO
/*SE CREA UN USUARIO Y SE LA ASIGNA EL TABLESPACE "MITABLESPACE" QUE SERA NUESTRO SCHEMA
PARA CREAR COLECCIONES DE OBJETOS (TABLAS, PROC ALMACENADOS, TRIGGERS, VISTAS ETC.)*/
CREATE USER ERICK IDENTIFIED BY ERICK123 DEFAULT TABLESPACE MITABLESPACE QUOTA 65M ON MITABLESPACE;--GRANT UNLIMITED TABLESPACE TO ERICK --(ACCESO A LOS DOS DATAFILE CREADOS)
--DROP USER ERICK CASCADE;
SELECT * FROM DBA_USERS;--CONSULTA USUARIO CREADO Y ASIGNACION DE TABLESPACE
SELECT * FROM DBA_TS_QUOTAS;--CONSULTA QUOTA DE USUARIO EN TABLESPACE
/*ASGINARLE TODOS LOS PRIVILEGIOS AL USUARIO/SCHEMA ERICK*/
GRANT ALL PRIVILEGES TO ERICK;
/*Crear tres tablas, checar sysdate, foreign key, GENERATED ALWAYS AS (), hacer insert sobre las tablas
crear usuario, crear role, asignarle privilegios al role y asignar role al usuario creado, comprobar
los permisos que se le dieron al role con el usuario
*/
CREATE TABLE T_USUARIO(
  CVE_USUARIO NUMBER(15) PRIMARY KEY,
  NOMBRE VARCHAR2(255) NOT NULL,
  CORREO VARCHAR2(255) NOT NULL,
  PASSWD VARCHAR2(255) NOT NULL,
  FCH_CREACION DATE DEFAULT (sysdate),
  FCH_MODIFICACION DATE,
  ACTIVO NUMBER(1));
  
CREATE TABLE T_DEPARTAMENTO(
  CVE_DEPARTAMENTO NUMBER(15) PRIMARY KEY,
  NOMBRE VARCHAR2(255) NOT NULL,
  FCH_CREACION DATE DEFAULT (sysdate),
  FCH_MODIFICACION DATE,
  CVE_USUARIO NUMBER(15),
  ACTIVO NUMBER(1),
  CONSTRAINT FK_USUARIO_DEPARTAMENTO FOREIGN KEY (CVE_USUARIO) REFERENCES T_USUARIO (CVE_USUARIO));
  
CREATE TABLE T_EMPLEADO(
  CVE_EMPLEADO NUMBER(15) PRIMARY KEY,
  NOMBRE VARCHAR2(255) NOT NULL,
  SALARIO_MES NUMBER(7,2),
  SALARIO_QUINCENA NUMBER(7,2) GENERATED ALWAYS AS (SALARIO_MES/2),
  FOTO BLOB,
  FCH_CREACION DATE DEFAULT (sysdate),
  FCH_MODIFICACION DATE,
  CVE_USUARIO NUMBER(15),
  CVE_DEPARTAMENTO NUMBER(15),
  ACTIVO NUMBER(1),
  CONSTRAINT FK_USUARIO_EMPLEADO FOREIGN KEY (CVE_USUARIO) REFERENCES T_USUARIO (CVE_USUARIO),
  CONSTRAINT FK_DEPARTAMENTO_EMPLEADO FOREIGN KEY (CVE_DEPARTAMENTO) REFERENCES T_DEPARTAMENTO (CVE_DEPARTAMENTO));
--DROP TABLE T_DEPARTAMENTO;
--DROP TABLE T_USUARIO;
--DROP TABLE T_EMPLEADO;
INSERT INTO T_USUARIO (CVE_USUARIO,NOMBRE,CORREO,PASSWD,FCH_CREACION,FCH_MODIFICACION,ACTIVO) 
VALUES (1,'Erick','erick-sd@hotmail.com','802744e3204358bd52d2b8e4d39724ed62331fb3','06/01/2017','06/01/2017',1);
INSERT INTO T_USUARIO (CVE_USUARIO,NOMBRE,CORREO,PASSWD,FCH_MODIFICACION,ACTIVO)
VALUES (2,'jorge','jorguitoEmoxito@hotmail.com','802744e3204358bd52d2b8e4d39724ed62331fb3','06/01/2017',1);
INSERT INTO T_USUARIO (CVE_USUARIO,NOMBRE,CORREO,PASSWD,ACTIVO)
VALUES (3,'juan','juan.perez@hotmail.com','802744e3204358bd52d2b8e4d39724ed62331fb3',1);
INSERT INTO T_USUARIO (CVE_USUARIO,NOMBRE,CORREO,PASSWD,FCH_MODIFICACION,ACTIVO)
VALUES (4,'Jhon','jhon@hotmail.com','802744e3204358bd52d2b8e4d39724ed62331fb3',sysdate,1);
--SELECT * FROM T_USUARIO;
INSERT INTO T_DEPARTAMENTO (CVE_DEPARTAMENTO,NOMBRE,FCH_MODIFICACION,CVE_USUARIO,ACTIVO)
VALUES (1,'RECURSOS HUMANOS',sysdate,1,1);
INSERT INTO T_DEPARTAMENTO (CVE_DEPARTAMENTO,NOMBRE,FCH_MODIFICACION,CVE_USUARIO,ACTIVO)
VALUES (2,'RECURSOS MATERIALES',sysdate,1,1);
INSERT INTO T_DEPARTAMENTO (CVE_DEPARTAMENTO,NOMBRE,FCH_MODIFICACION,CVE_USUARIO,ACTIVO)
VALUES (3,'ADMINISTRACIÓN',sysdate,1,1);
INSERT INTO T_DEPARTAMENTO (CVE_DEPARTAMENTO,NOMBRE,FCH_MODIFICACION,CVE_USUARIO,ACTIVO)
VALUES (4,'JURÍDICO',sysdate,3,1);
--SELECT * FROM T_DEPARTAMENTO;
INSERT INTO T_EMPLEADO (CVE_EMPLEADO,NOMBRE,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,CVE_DEPARTAMENTO,ACTIVO) 
VALUES (1,'Roberta',14500.50,sysdate,2,1,1);
INSERT INTO T_EMPLEADO (CVE_EMPLEADO,NOMBRE,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,CVE_DEPARTAMENTO,ACTIVO) 
VALUES (2,'Humberto',8500.50,sysdate,3,2,1);
INSERT INTO T_EMPLEADO (CVE_EMPLEADO,NOMBRE,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,CVE_DEPARTAMENTO,ACTIVO) 
VALUES (3,'Oscar',12500.50,sysdate,4,3,1);
INSERT INTO T_EMPLEADO (CVE_EMPLEADO,NOMBRE,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,CVE_DEPARTAMENTO,ACTIVO) 
VALUES (4,'Luis',18500.50,sysdate,4,4,1);
INSERT INTO T_EMPLEADO (CVE_EMPLEADO,NOMBRE,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,CVE_DEPARTAMENTO,ACTIVO) 
VALUES (5,'Carlos',16500.50,sysdate,3,4,1);
--SELECT * FROM T_EMPLEADO;
/*Crear usuario*/
--DROP USER JURIDICO CASCADE;
CREATE USER JURIDICO IDENTIFIED BY JURIDICO123 DEFAULT TABLESPACE MITABLESPACE;
/*SE LE ASIGNA PERMISO PARA CONECTAR A LA BASE DE DATOS*/
GRANT CREATE SESSION TO JURIDICO;
/*SE LE ASIGNA PERMISOS AL USUARIO JURIDICO A NIVEL DE TABLA Y COLUMNAS*/
GRANT SELECT ON ERICK.T_EMPLEADO TO JURIDICO;
/*CONECTAR CON EL USUARIO A LA DB Y VERIFICAR LOS PERMISOS OTORGADOS*/
/*CONEXION CON USUARIO JURIDICO SOLO PUEDE VER LA TABLA EMPLEADO*/
SELECT * FROM ERICK.T_EMPLEADO;
SELECT * FROM ERICK.T_USUARIO;
/*CREAR UN USUARIO DEPTO_ADMIN, CREAR UN ROL, ASIGNARLE PRIVILEGIOS
AL ROLE Y VERIFICAR PRIVILEGIOS*/
CREATE USER DEPTO_ADMIN IDENTIFIED BY DEPTOADMIN123 DEFAULT TABLESPACE MITABLESPACE;
CREATE ROLE ADMINISTRATIVO;--DROP ROLE ADMINISTRATIVO;
GRANT CREATE SESSION TO ADMINISTRATIVO;
GRANT SELECT ON ERICK.T_USUARIO TO ADMINISTRATIVO;
GRANT SELECT ON ERICK.T_DEPARTAMENTO TO ADMINISTRATIVO;
GRANT UPDATE(NOMBRE,SALARIO_MES,FOTO,CVE_DEPARTAMENTO,ACTIVO), INSERT, SELECT ON ERICK.T_EMPLEADO TO ADMINISTRATIVO;
--CVE_EMPLEADO,SALARIO_QUINCENA,FCH_CREACION,FCH_MODIFICACION,CVE_USUARIO
GRANT ADMINISTRATIVO TO DEPTO_ADMIN;
/*CONECTAR CON EL USUARIO A LA DB Y VERIFICAR LOS PERMISOS OTORGADOS*/
SELECT * FROM ERICK.T_USUARIO;
INSERT INTO ERICK.T_USUARIO (CVE_USUARIO,NOMBRE,CORREO,PASSWD,FCH_CREACION,FCH_MODIFICACION,ACTIVO) 
VALUES (4,'Maguiver','mag@hotmail.com','802744e3204358bd52d2b8e4d39724ed62331fb3',sysdate,'06/01/2017',1);
INSERT INTO ERICK.T_EMPLEADO (CVE_EMPLEADO,NOMBRE,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,CVE_DEPARTAMENTO,ACTIVO) 
VALUES (6,'Ivan',15500.50,sysdate,3,3,1);
SELECT * FROM ERICK.T_EMPLEADO;
/*PROBAR UPDATE EN UN CAMPO DONDE NO TIENE PRIVILEGIOS*/
UPDATE ERICK.T_EMPLEADO SET CVE_USUARIO = 1 WHERE CVE_EMPLEADO=6;
/*UPDATE DONDE TIENE PRIVILEGIOS*/
UPDATE ERICK.T_EMPLEADO SET ACTIVO = 0 WHERE CVE_EMPLEADO=6;
SELECT * FROM ERICK.T_EMPLEADO WHERE CVE_EMPLEADO=6;
/*ULTIMO USUARIO, SIGNAMOS ROLE ADMINISTRATIVO, CREAMOS Y ASIGNAMOS OTRO ROLE INFORMATICO*/
CREATE USER INFORMATICA IDENTIFIED BY INFORMATICA123 DEFAULT TABLESPACE MITABLESPACE;
GRANT ADMINISTRATIVO TO INFORMATICA;
CREATE ROLE INFORMATICO;
GRANT INSERT,UPDATE ON ERICK.T_USUARIO TO INFORMATICO;
GRANT INSERT,UPDATE ON ERICK.T_DEPARTAMENTO TO INFORMATICO;
GRANT INFORMATICO TO INFORMATICA;
/*ABRIR CONEXION CON EL USUARIO CREADO INFORMATICA*/
/*PROVAR SELECT EN T_USUARIO QUE VIENE EN EL ROL ADMINISTRATIVO*/
SELECT * FROM ERICK.T_USUARIO;
/*PROBAR UPDATE EN UN CAMPO DONDE NO TIENE PRIVILEGIOS*/
UPDATE ERICK.T_EMPLEADO SET CVE_USUARIO = 2 WHERE CVE_EMPLEADO=6;
/*OJO SI SE ACTUALIZA EL SALARIO MENSUAL QUE PASA CON EL QUINCENAL? SI LO ACTUALIZA*/
UPDATE ERICK.T_EMPLEADO SET SALARIO_MES = 19500.50 WHERE CVE_EMPLEADO=6;
/*REALIZAR PRUEBAS CON ALUMNO*/
/*VOLVER AL USUARIO "PRINCIPAL" Y ASIGNARLE AL USUARIO INFORMATICA LAS COLUMNAS DEL UPDATE QUE FALTABAN EN EL
ROLE ADMINISTRATIVO OJO AL USUARIO NO AL ROLE*/
GRANT UPDATE(CVE_EMPLEADO,SALARIO_QUINCENA,FCH_CREACION,FCH_MODIFICACION,CVE_USUARIO) ON ERICK.T_EMPLEADO TO INFORMATICA;
/*PROBAR UPDATE EN UN CAMPO DONDE NO TENIA PRIVILEGIOS EL USUARIO INFORMATICA*/
UPDATE ERICK.T_EMPLEADO SET CVE_USUARIO = 2 WHERE CVE_EMPLEADO=6;
/*VOLVER AL USUARIO PRINCIPAL, SE AGREGARA UN CAT_TABULADOR_SUELDO RELACIONADO AL EMPLEADO Y SE LA HACE UN DROPCOLUMN, 
ADDCOLUMN, Y ADDCONTRAINT A LA TABLA T_EMPLEADO*/
CREATE TABLE T_CAT_TABULADOR_SUELDO(
  CVE_TABULADOR NUMBER(15) PRIMARY KEY,
  NIVEL NUMBER(2) NOT NULL,
  PUESTO VARCHAR2(255) NOT NULL,
  SALARIO_MES NUMBER(7,2),
  SALARIO_QUINCENA NUMBER(7,2) GENERATED ALWAYS AS (SALARIO_MES/2),
  FCH_CREACION DATE DEFAULT (sysdate),
  FCH_MODIFICACION DATE,
  CVE_USUARIO NUMBER(15),
  ACTIVO NUMBER(1),
  CONSTRAINT FK_USUARIO_TABULADOR_SUELDO FOREIGN KEY (CVE_USUARIO) REFERENCES T_USUARIO (CVE_USUARIO));

INSERT INTO T_CAT_TABULADOR_SUELDO (CVE_TABULADOR,NIVEL,PUESTO,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,ACTIVO)
VALUES (1,1,'DIRECTOR GENERAL',48000.50,sysdate,1,1);
INSERT INTO T_CAT_TABULADOR_SUELDO (CVE_TABULADOR,NIVEL,PUESTO,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,ACTIVO)
VALUES (2,2,'COORDINADOR GENERAL',30000.50,sysdate,1,1);
INSERT INTO T_CAT_TABULADOR_SUELDO (CVE_TABULADOR,NIVEL,PUESTO,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,ACTIVO)
VALUES (3,3,'DIRECTOR DE ÁREA',28000.50,sysdate,1,1);
INSERT INTO T_CAT_TABULADOR_SUELDO (CVE_TABULADOR,NIVEL,PUESTO,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,ACTIVO)
VALUES (4,3,'TITULAR DE ÁREA',23000.50,sysdate,1,1);
INSERT INTO T_CAT_TABULADOR_SUELDO (CVE_TABULADOR,NIVEL,PUESTO,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,ACTIVO)
VALUES (5,3,'COORDINADOR DE ÁREA',18000.50,sysdate,1,1);
/*INSERT INTO T_CAT_TABULADOR_SUELDO (CVE_TABULADOR,NIVEL,PUESTO,SALARIO_MES,FCH_MODIFICACION,CVE_USUARIO,ACTIVO,
VALUES (5,4,'JEFE DE DEPARTAMENTO',13000.50,sysdate,1,1);*/

ALTER TABLE T_EMPLEADO DROP(SALARIO_MES,SALARIO_QUINCENA);
/*ELIMINAR PRIMERO SALRIO QUINCENA*/
ALTER TABLE T_EMPLEADO DROP(SALARIO_QUINCENA);
ALTER TABLE T_EMPLEADO DROP(SALARIO_MES);
/*AGREGAR COLUMNA CON REFERENCIA AL CAT TABULADOR SUELDO*/
ALTER TABLE T_EMPLEADO ADD(CVE_TABULADOR NUMBER(15));
ALTER TABLE T_EMPLEADO ADD CONSTRAINT FK_CAT_TABULADOR_EMPLEADO FOREIGN KEY (CVE_TABULADOR) REFERENCES T_CAT_TABULADOR_SUELDO (CVE_TABULADOR);
/*SELECT PARA VER LA COLUMNA*/
SELECT * FROM T_EMPLEADO;
/*ACTUALIZAR T_EMPLEADO PARA AGREGAR REFERENCIA HACIA CAT TABULADOR SUELDOS*/
UPDATE ERICK.T_EMPLEADO SET CVE_TABULADOR = 2 WHERE CVE_EMPLEADO=1;
UPDATE ERICK.T_EMPLEADO SET CVE_TABULADOR = 2 WHERE CVE_EMPLEADO=2;
UPDATE ERICK.T_EMPLEADO SET CVE_TABULADOR = 3 WHERE CVE_EMPLEADO=3;
UPDATE ERICK.T_EMPLEADO SET CVE_TABULADOR = 4 WHERE CVE_EMPLEADO=4;
UPDATE ERICK.T_EMPLEADO SET CVE_TABULADOR = 4 WHERE CVE_EMPLEADO=5;
--UPDATE ERICK.T_EMPLEADO SET CVE_TABULADOR = 3 WHERE CVE_EMPLEADO=6;
/*SELECT PARA VER ACTUALIZACIONES*/
SELECT * FROM T_EMPLEADO;
/*SE COMIENZA CON EL USO DE SECUENCIA*/