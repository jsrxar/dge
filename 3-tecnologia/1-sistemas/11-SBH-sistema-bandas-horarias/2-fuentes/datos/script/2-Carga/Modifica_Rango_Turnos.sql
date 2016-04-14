UPDATE fac_lectura le
SET fl_procesado = FALSE,
    id_tipo_hora = CASE
        -- Fin de semana anterior al 22/02/2016 (turno 12h)
        WHEN (SELECT fl_fin_semana FROM dim_fecha WHERE id_fecha = le.id_fecha) = 'Si' AND id_fecha < 20160222 THEN
        CASE
            WHEN TO_CHAR(fe_hora, 'HH24MI') BETWEEN '0300' AND '0900' THEN 1
            WHEN TO_CHAR(fe_hora, 'HH24MI') BETWEEN '1500' AND '2100' THEN 4
            ELSE 0 END
        -- Otro tipo de fecha (turno 8hs)
        WHEN TO_CHAR(fe_hora, 'HH24MI') BETWEEN '0300' AND '0900' THEN 1
        WHEN TO_CHAR(fe_hora, 'HH24MI') BETWEEN '1100' AND '1700' THEN 2
        WHEN TO_CHAR(fe_hora, 'HH24MI') BETWEEN '1900' AND '2359' THEN 3
        ELSE 0 END;

TRUNCATE fac_turnos CASCADE;

SELECT fn_Carga_Turnos();

