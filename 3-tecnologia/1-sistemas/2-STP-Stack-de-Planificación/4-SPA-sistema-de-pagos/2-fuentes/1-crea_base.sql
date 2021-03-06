﻿CREATE SEQUENCE carga_seq INCREMENT 1;

CREATE TABLE stg_pagos_1 (
	id_carga BIGINT NOT NULL DEFAULT nextval('carga_seq'::regclass),
	fe_carga TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
	tx_proyecto   VARCHAR(20) DEFAULT NULL,
	tx_linea_accion_1   VARCHAR(2) DEFAULT NULL,
	tx_linea_accion_2   VARCHAR(2) DEFAULT NULL,
	tx_renglon_categoria_1   VARCHAR(10) DEFAULT NULL,
	tx_renglon_categoria_2   VARCHAR(10) DEFAULT NULL,
	tx_saldo_renglon_categ   VARCHAR(10) DEFAULT NULL,
	tx_cuota   VARCHAR(20) DEFAULT NULL,
	tx_evento   VARCHAR(100) DEFAULT NULL,
	tx_descripcion   VARCHAR(100) DEFAULT NULL,
	tx_fecha_evento   VARCHAR(100) DEFAULT NULL,
	tx_lugar   VARCHAR(50) DEFAULT NULL,
	tx_importe   VARCHAR(20) DEFAULT NULL,
	tx_razon_social   VARCHAR(100) DEFAULT NULL,
	tx_cuit   VARCHAR(20) DEFAULT NULL,
	tx_fecha_comprobante   VARCHAR(15) DEFAULT NULL,
	tx_tipo_comprobante   VARCHAR(2) DEFAULT NULL,
	tx_nro_comprobante   VARCHAR(20) DEFAULT NULL,
	tx_forma_pago   VARCHAR(50) DEFAULT NULL,
	tx_numero_cbu   VARCHAR(50) DEFAULT NULL,
	tx_contacto   VARCHAR(50) DEFAULT NULL,
	tx_mail_contacto   VARCHAR(50) DEFAULT NULL,
	tx_telefono_contacto   VARCHAR(100) DEFAULT NULL,
	tx_fecha_ingreso_unsam   VARCHAR(10) DEFAULT NULL,
	tx_expediente   VARCHAR(10) DEFAULT NULL,
	tx_numero_op   VARCHAR(10) DEFAULT NULL,
	tx_retenciones_realizadas   VARCHAR(20) DEFAULT NULL,
	tx_importe_neto_pagar   VARCHAR(20) DEFAULT NULL,
	tx_estado   VARCHAR(20) DEFAULT NULL,
	tx_fecha_pago   VARCHAR(10) DEFAULT NULL,
	CONSTRAINT stg_pagos_1_pk PRIMARY KEY (id_carga)
);
