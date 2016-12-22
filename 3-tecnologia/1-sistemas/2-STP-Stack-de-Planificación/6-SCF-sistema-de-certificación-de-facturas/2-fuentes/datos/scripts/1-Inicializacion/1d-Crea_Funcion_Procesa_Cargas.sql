/* Procesa los registros generados por una carga desde una planilla Excel */
/* Lanzador: SELECT facturas.fn_xls_procesa_cargas('F4ct#r4s@2016'); */

CREATE OR REPLACE FUNCTION facturas.fn_xls_procesa_cargas(IN pKey TEXT DEFAULT NULL, IN pFull BOOLEAN DEFAULT FALSE) RETURNS INTEGER
	LANGUAGE plpgsql AS $xls_procesa_cargas$
DECLARE
	v_mensajes     HSTORE;
	v_cantidad     INTEGER;
	v_error        TEXT;
	r_cargas       RECORD;
	v_tp_contr_at  facturas.tipo_contrato.id_tipo_contrato%TYPE;
	v_tp_honorario facturas.tipo_honorario.id_tipo_honorario%TYPE;
	v_contrato     facturas.contrato.id_contrato%TYPE;
BEGIN
	/* Estados del proceso de carga, campo "co_estado_proceso":
		C: Cargada, sin procesar
		N: Normalizada
		P: Procesada
		P con "fl_reproc" en True: Reprocesar
		E: Error (se agrega mensaje)
		R: Rechazada (se agrega mensaje)
	*/

	-- Arma los mensajes de ERROR y RECHAZO
	v_mensajes =
		'"ERR_CUI_NULL"=>"No se reconoce el CUIT o está vacío",
		 "ERR_CUI_INEX"=>"No se encuentra el agente con el CUIT \"%s\"",
		 "ERR_AGE_NULL"=>"No se reconoce el Nombre del Agente o está vacío",
		 "ERR_AGE_DIFE"=>"Nombre Agente \"%s\" (carga) diferente a \"%s\" (base)",
		 "ERR_MES_FORM"=>"El mes \"%s\" no se encuentra con formato \"YYYY-MM\"",
		 "ERR_HON_INEX"=>"No existe honorario del Mes \"%s\" para el agente \"%s\"",
		 "ERR_VAL_CRYP"=>"El valor \"%s\" no es un monto numérico",
		 "ERR_CBU_FORM"=>"El CBU \"%s\" no es un numérico de 22 posiciones",
		 "ERR_FAC_NULL"=>"No se reconoce el número de la Factura",
		 "WRN_FAC_DIFE"=>"El monto de la Factura (carga) no coincide con el Honorario",
		 "RCH_FAC_EXIS"=>"La factura ya se encuentra cargada en la base",
		 "RCH_FAC_DUPL"=>"Hay una factura más nueva para este honorario en la misma carga",
		 "RCH_FAC_ANTE"=>"Se carga una nueva factura para este honorario: %s%s",
		 "CRG_FAC_CORR"=>"Carga OK"';

	/* Para volver a poner una carga como disponible para procesar
	UPDATE facturas.stg_xls_facturas
	SET
		nm_no_agente = NULL, nm_nu_pto_venta = NULL, nm_nu_factura = NULL, nm_va_factura = NULL,
		nm_id_agente = NULL, nm_fe_mes = NULL, nm_id_honorario = NULL, nm_mensaje = NULL, nm_nu_cbu = NULL,
		nm_co_cuit = NULL, nm_co_categ_fact = NULL, fl_reproc = FALSE, nu_carga = NULL, co_estado_proceso = 'C'
	WHERE fe_carga = '2016-11-25 11:24:05.728448'
	*/

	-- Numera las cargas
	PERFORM facturas.fn_xls_numera_carga();

	-- Reproceso FULL
	IF pFull = TRUE THEN
		UPDATE facturas.stg_xls_facturas st
		SET fl_reproc = TRUE
		WHERE co_estado_proceso = 'E'
		  AND nu_carga IS NOT NULL;
	END IF;

	-- Normalizando los valores
	BEGIN
		UPDATE facturas.stg_xls_facturas st
		SET
			fe_reproc         = CASE WHEN fl_reproc THEN NOW() END,
			nm_co_cuit        = TRIM(ds_cuit),
			nm_no_agente      = INITCAP(TRIM(REPLACE(REPLACE(ds_nombre, ',', ''), '  ', ' '))),
			nm_fe_mes         = fn_valida_mes(ds_mes),
			nm_nu_pto_venta   = fn_valida_numero(ds_factura_numero, 1),
			nm_nu_factura     = fn_valida_numero(ds_factura_numero, 2),
			nm_va_factura     = fn_valida_encrypt(ds_importe, pKey),
			nm_co_categ_fact  = CASE WHEN TRIM(UPPER(ds_observaciones)) = 'ADICIONAL' THEN 'A' ELSE 'M' END,
			nm_nu_cbu         = CASE WHEN TRIM(ds_cbu) ~ '^[0-9]{22}$' THEN ds_cbu::NUMERIC END,
			nm_mensaje        = NULL,
			fl_reproc         = FALSE,
			co_estado_proceso = 'N'
		WHERE (co_estado_proceso = 'C' OR fl_reproc)
		  AND nu_carga IS NOT NULL;
	EXCEPTION WHEN OTHERS THEN
		RAISE NOTICE 'Error (%) al normalizar carga desde XLS: %', SQLSTATE, SQLERRM;
		RETURN -1;
	END;

	--------------------------------  Verifica el Agente  --------------------------------
	-- Error si no existe el CUIT
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = v_mensajes -> 'ERR_CUI_NULL'
	WHERE co_estado_proceso = 'N'
	  AND nm_co_cuit IS NULL;

	-- Error si no puede controlar el CBU
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_CBU_FORM', TRIM(ds_cbu))
	WHERE co_estado_proceso = 'N'
	  AND nm_nu_cbu IS NULL
	  AND ds_cbu IS NOT NULL;

	-- Error si no existe el Nombre
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = v_mensajes -> 'ERR_AGE_NULL'
	WHERE co_estado_proceso = 'N'
	  AND COALESCE(nm_no_agente, '') = '';

	-- Obtiene el Agente usando el CUIT
	UPDATE facturas.stg_xls_facturas st
	SET nm_id_agente = (
		SELECT MAX(id_agente)
		FROM facturas.agente
		WHERE co_cuit = st.nm_co_cuit )
	WHERE st.co_estado_proceso = 'N';

	-- Error si el nombre del Agente es diferente (se indica pero no se rechaza)
	UPDATE facturas.stg_xls_facturas st
	SET
		--co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_AGE_DIFE', st.nm_no_agente, ag.no_agente)
	FROM facturas.agente ag
	WHERE st.co_estado_proceso = 'N'
	  AND st.nm_id_agente = ag.id_agente
	  AND fn_compara_nombres(st.nm_no_agente, ag.no_agente) = FALSE;

	-- Error si no existe el Agente
	UPDATE facturas.stg_xls_facturas
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_CUI_INEX', nm_co_cuit)
	WHERE co_estado_proceso = 'N'
	  AND nm_id_agente IS NULL;

	--------------------------------  Verificaciones de los datos de factura  --------------------------------
	-- Verifica la exisrtencia del Mes
	UPDATE facturas.stg_xls_facturas
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_MES_FORM', ds_mes)
	WHERE co_estado_proceso = 'N'
	  AND nm_fe_mes IS NULL;

	-- Verifica la exisrtencia del Valor
	UPDATE facturas.stg_xls_facturas
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_VAL_CRYP', ds_importe)
	WHERE co_estado_proceso = 'N'
	  AND nm_va_factura IS NULL;

	-- Verifica la exisrtencia del Número de Factura
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = v_mensajes -> 'ERR_FAC_NULL'
	WHERE co_estado_proceso = 'N'
	  AND (nm_nu_pto_venta IS NULL
	    OR nm_nu_factura   IS NULL);

	--------------------------------  Proceso de Contratos y Honorarios  --------------------------------
	BEGIN -- Bloque para el tratamiento de facturas Adicionales
		-- Toma el tipo de contrato AT
		SELECT id_tipo_contrato
		INTO v_tp_contr_at
		FROM facturas.tipo_contrato
		WHERE co_tipo_contrato = 'AT';

		-- Para todas las facturas cargadas como "Adicional"
		FOR r_cargas IN
			SELECT
				nm_id_agente                         AS id_agente,
				nm_fe_mes                            AS fe_mes,
				TO_CHAR(nm_fe_mes, 'MM')::SMALLINT   AS nu_mes,
				TO_CHAR(nm_fe_mes, 'YYYY')::SMALLINT AS nu_anio,
				nm_va_factura                        AS va_honorario,
				nm_co_categ_fact                     AS co_categ
			FROM facturas.stg_xls_facturas
			WHERE co_estado_proceso = 'N'
			  AND nm_co_categ_fact  = 'A'
			  AND nm_fe_mes    IS NOT NULL
			  AND nm_id_agente IS NOT NULL
		LOOP
			-- Si no existe el tipo de honorario Adicional...
			IF NOT EXISTS (
				SELECT 1 FROM facturas.tipo_honorario
				WHERE co_categ_honorario = r_cargas.co_categ
				  AND nu_mes_honorario   = r_cargas.nu_mes
				  AND nu_anio_honorario  = r_cargas.nu_anio ) THEN
				-- ... lo creamos
				INSERT INTO facturas.tipo_honorario (
					id_tipo_honorario,
					nu_mes_honorario,
					nu_anio_honorario,
					no_tipo_honorario,
					va_pct_ajuste,
					co_categ_honorario )
				SELECT
					MAX(id_tipo_honorario)+1 AS id_tipo_honorario,
					r_cargas.nu_mes          AS nu_mes_honorario,
					r_cargas.nu_anio         AS nu_anio_honorario,
					TO_CHAR(r_cargas.fe_mes, '"Adicional "MM/YYYY') AS no_tipo_honorario,
					0                        AS va_pct_ajuste,
					r_cargas.co_categ        AS co_categ_honorario
				FROM facturas.tipo_honorario
				WHERE nu_mes_honorario  = r_cargas.nu_mes
				  AND nu_anio_honorario = r_cargas.nu_anio;
			END IF;
			-- Tomamos el tipo de honorario Adicional
			BEGIN
				SELECT MAX(id_tipo_honorario)
				INTO STRICT v_tp_honorario
				FROM facturas.tipo_honorario
				WHERE co_categ_honorario = r_cargas.co_categ
				  AND nu_mes_honorario   = r_cargas.nu_mes
				  AND nu_anio_honorario  = r_cargas.nu_anio;
			EXCEPTION WHEN OTHERS THEN
				EXIT; -- Salimos del LOOP
			END;

			-- Procesamos Contratos y Honorarios
			<<bk_contrato_honorario>>
			BEGIN
				-- Si no existe el contrato Adicional...
				IF NOT EXISTS (
					SELECT 1 FROM facturas.contrato
					WHERE id_agente         = r_cargas.id_agente
					  AND id_tipo_contrato  = v_tp_contr_at
					  AND r_cargas.fe_mes BETWEEN COALESCE(fe_inicio, r_cargas.fe_mes)
					                          AND COALESCE(fe_fin, r_cargas.fe_mes)
					  AND co_categ_contrato = r_cargas.co_categ ) THEN
					-- ... lo creamos a partir del Mensual
					INSERT INTO facturas.contrato (
						id_agente,
						fe_inicio,
						fe_fin,
						id_tipo_contrato,
						id_convenio_at,
						co_categ_contrato )
					SELECT
						r_cargas.id_agente                                   AS nm_id_agente,
						r_cargas.fe_mes::DATE                                AS fe_inicio,
						(r_cargas.fe_mes + INTERVAL '1 MONTH - 1 DAY')::DATE AS fe_fin,
						v_tp_contr_at                                        AS id_tipo_contrato,
						MAX(id_convenio_at)                                  AS id_convenio_at,
						r_cargas.co_categ                                    AS co_categ_contrato
					FROM facturas.contrato
					WHERE id_agente         = r_cargas.id_agente
					  AND id_tipo_contrato  = v_tp_contr_at
					  AND r_cargas.fe_mes BETWEEN COALESCE(fe_inicio, r_cargas.fe_mes)
								  AND COALESCE(fe_fin, r_cargas.fe_mes)
					  AND co_categ_contrato = 'M';
				END IF;
				-- Tomamos el Contrato adicional
				BEGIN
					SELECT id_contrato
					INTO STRICT v_contrato
					FROM facturas.contrato
					WHERE id_agente         = r_cargas.id_agente
					  AND id_tipo_contrato  = v_tp_contr_at
					  AND r_cargas.fe_mes BETWEEN COALESCE(fe_inicio, r_cargas.fe_mes)
					                          AND COALESCE(fe_fin, r_cargas.fe_mes)
					  AND co_categ_contrato = r_cargas.co_categ;
				EXCEPTION WHEN OTHERS THEN
					EXIT bk_contrato_honorario;  -- Salimos del bloque BEGIN...END
				END;

				-- Si no existe el honorario Adicional...
				IF NOT EXISTS (
					SELECT 1 FROM facturas.honorario
					WHERE id_contrato       = v_contrato
					  AND id_tipo_honorario = v_tp_honorario ) THEN
					-- ... lo creamos
					INSERT INTO facturas.honorario (
						id_tipo_honorario,
						id_contrato,
						va_honorario )
					VALUES (
						v_tp_honorario,
						v_contrato,
						r_cargas.va_honorario );
				END IF;
			END;
		END LOOP;
	END;

	--------------------------------  Prepara la carga de la factura  --------------------------------
	-- Obtiene el Honorario
	UPDATE facturas.stg_xls_facturas st
	SET
		nm_id_honorario =
			(SELECT ho.id_honorario FROM facturas.honorario ho
			 LEFT JOIN facturas.tipo_honorario th ON ho.id_tipo_honorario = th.id_tipo_honorario
			 LEFT JOIN facturas.contrato co       ON ho.id_contrato = co.id_contrato
			 WHERE co.id_agente          = st.nm_id_agente
			   AND co.co_categ_contrato  = st.nm_co_categ_fact
			   AND th.co_categ_honorario = st.nm_co_categ_fact
			   AND th.nu_mes_honorario   = TO_CHAR(nm_fe_mes, 'MM')::SMALLINT
			   AND th.nu_anio_honorario  = TO_CHAR(nm_fe_mes, 'YYYY')::SMALLINT)
	WHERE co_estado_proceso = 'N';

	-- Verifica el Honorario
	UPDATE facturas.stg_xls_facturas
	SET
		co_estado_proceso = 'E',
		nm_mensaje        = FORMAT(v_mensajes -> 'ERR_HON_INEX', ds_mes, nm_no_agente)
	WHERE co_estado_proceso = 'N'
	  AND nm_id_honorario IS NULL;

	-- Rechazan las facturas ya cargadas (iguales)
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'R',
		nm_mensaje        = v_mensajes -> 'RCH_FAC_EXIS'
	WHERE co_estado_proceso = 'N'
	  AND EXISTS (
		SELECT 1 FROM facturas.factura
		WHERE id_honorario = st.nm_id_honorario
		  AND nu_pto_venta = st.nm_nu_pto_venta
		  AND nu_factura   = st.nm_nu_factura
		  AND va_factura   = st.nm_va_factura
		  AND fl_rechazo   = FALSE );

	-- Rechaza la factura más vieja si hay más de una para el mismo Honorario
	UPDATE facturas.stg_xls_facturas st
	SET
		co_estado_proceso = 'R',
		nm_mensaje        = v_mensajes -> 'RCH_FAC_DUPL'
	WHERE co_estado_proceso = 'N'
	  AND EXISTS (
		SELECT 1 FROM facturas.stg_xls_facturas
		WHERE co_estado_proceso = 'N'
		  AND nm_id_honorario = st.nm_id_honorario
		  AND id_carga        > st.id_carga );

	-- Si la factura no es Erronea ni Rechazada, se actualiza CBU de agente
	UPDATE facturas.agente ag
	SET
		nu_cbu = nm_nu_cbu
	FROM facturas.stg_xls_facturas fa
	WHERE fa.co_estado_proceso = 'N'
	  AND ag.id_agente         = fa.nm_id_agente
	  AND nm_nu_cbu IS NOT NULL;

	-- Marca como Rechazada la factura del mismo Honorario, si ya existe
	UPDATE facturas.factura fa
	SET
		fl_rechazo = TRUE,
		ds_comentario = FORMAT(v_mensajes -> 'RCH_FAC_ANTE', TO_CHAR(NOW(), 'DD/MM/YYYY HH24:MI'), COALESCE('. ' || ds_comentario, ''))
	FROM facturas.stg_xls_facturas st
	WHERE st.co_estado_proceso = 'N'
	  AND st.nm_id_honorario   = fa.id_honorario
	  AND fa.fl_rechazo        = FALSE;

	-- Se agrega comentario a facturas con monto diferente al honorario, pero se cargan igualmente (se podrían rechazar)
	UPDATE facturas.stg_xls_facturas fa
	SET
		nm_mensaje        = v_mensajes -> 'WRN_FAC_DIFE'
	FROM facturas.honorario ho
	WHERE fa.co_estado_proceso = 'N'
	  AND fa.nm_id_honorario   = ho.id_honorario
	  AND fa.nm_va_factura    != ho.va_honorario;

	--------------------------------  Se cargan las Facturas  --------------------------------
	-- Carga las facturas en la tabla de facturas
	INSERT INTO facturas.factura (
		id_carga,
		id_honorario,
		nu_pto_venta,
		nu_factura,
		fe_factura, 
		fe_carga,
		va_factura,
		ds_certificacion,
		ds_comentario )
	SELECT
		id_carga,
		nm_id_honorario,
		nm_nu_pto_venta,
		nm_nu_factura,
		fe_modif, 
		fe_carga,
		nm_va_factura,
		ds_observaciones,
		nm_mensaje
	FROM facturas.stg_xls_facturas st
	WHERE co_estado_proceso = 'N';

	-- Actualiza estado de Cargado a Procesado
	WITH procesado AS (
		UPDATE facturas.stg_xls_facturas
		SET co_estado_proceso = 'P'
		WHERE co_estado_proceso = 'N'
		RETURNING 1
	) SELECT COUNT(1) INTO v_cantidad FROM procesado;

	RETURN v_cantidad;
--EXCEPTION WHEN others THEN
--	RAISE NOTICE 'Error (%) al normalizar carga desde XLS: %', SQLSTATE, SQLERRM;
--	RETURN -1;
END;
$xls_procesa_cargas$;
