<?php

//  define('SHOW_VARIABLES', 1);
//  define('DEBUG_LEVEL', 1);

//  error_reporting(E_ALL ^ E_NOTICE);
//  ini_set('display_errors', 'On');

set_include_path('.' . PATH_SEPARATOR . get_include_path());


include_once dirname(__FILE__) . '/' . 'components/utils/system_utils.php';

//  SystemUtils::DisableMagicQuotesRuntime();

SystemUtils::SetTimeZoneIfNeed('America/Argentina/Buenos_Aires');

function GetGlobalConnectionOptions()
{
    return array(
  'server' => '10.13.18.28',
  'port' => '5432',
  'username' => 'rcdto',
  'password' => 'rcdto',
  'database' => 'RCDTO'
);
}

function HasAdminPage()
{
    return false;
}

function GetPageGroups()
{
    $result = array('Maestras', 'Relaciones', 'Paramétricas', 'Transacciones');
    return $result;
}

function GetPageInfos()
{
    $result = array();
    $result[] = array('caption' => 'Area', 'short_caption' => 'Area', 'filename' => 'area.php', 'name' => 'public.ods_area', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Bien', 'short_caption' => 'Bien', 'filename' => 'bien.php', 'name' => 'public.ods_bien', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Empresa', 'short_caption' => 'Empresa', 'filename' => 'empresa.php', 'name' => 'public.ods_empresa', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Espacio', 'short_caption' => 'Espacio', 'filename' => 'espacio.php', 'name' => 'public.ods_espacio', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Insumo', 'short_caption' => 'Insumo', 'filename' => 'insumo.php', 'name' => 'public.ods_insumo', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Lectura', 'short_caption' => 'Lectura', 'filename' => 'lectura.php', 'name' => 'public.ods_lectura', 'group_name' => 'Transacciones', 'add_separator' => false);
    $result[] = array('caption' => 'Lugar', 'short_caption' => 'Lugar', 'filename' => 'lugar.php', 'name' => 'public.ods_lugar', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Ocupa (Area / Espacio)', 'short_caption' => 'Ocupa', 'filename' => 'ocupa.php', 'name' => 'public.ods_ocupa', 'group_name' => 'Relaciones', 'add_separator' => false);
    $result[] = array('caption' => 'Origen Lectura', 'short_caption' => 'Origen Lectura', 'filename' => 'origen_lectura.php', 'name' => 'public.ods_origen_lectura', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Origen', 'short_caption' => 'Origen', 'filename' => 'origen.php', 'name' => 'public.ods_origen', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Periodicidad', 'short_caption' => 'Periodicidad', 'filename' => 'periodicidad.php', 'name' => 'public.ods_periodicidad', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Persona', 'short_caption' => 'Persona', 'filename' => 'persona.php', 'name' => 'public.ods_persona', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Realiza (Persona / Tarea)', 'short_caption' => 'Realiza', 'filename' => 'realiza.php', 'name' => 'public.ods_realiza', 'group_name' => 'Relaciones', 'add_separator' => false);
    $result[] = array('caption' => 'Requiere (Actividad / Insumo)', 'short_caption' => 'Requiere', 'filename' => 'requiere.php', 'name' => 'public.ods_requiere', 'group_name' => 'Relaciones', 'add_separator' => false);
    $result[] = array('caption' => 'Tarea', 'short_caption' => 'Tarea', 'filename' => 'tarea.php', 'name' => 'public.ods_tarea', 'group_name' => 'Transacciones', 'add_separator' => false);
    $result[] = array('caption' => 'Tarea Planificada', 'short_caption' => 'Tarea Planificada', 'filename' => 'tarea_plan.php', 'name' => 'public.ods_tarea_plan', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Tipo Bien', 'short_caption' => 'Tipo Bien', 'filename' => 'tipo_bien.php', 'name' => 'public.ods_tipo_bien', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Tipo Espacio', 'short_caption' => 'Tipo Espacio', 'filename' => 'tipo_espacio.php', 'name' => 'public.ods_tipo_espacio', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Tipo Insumo', 'short_caption' => 'Tipo Insumo', 'filename' => 'tipo_insumo.php', 'name' => 'public.ods_tipo_insumo', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Tipo Persona', 'short_caption' => 'Tipo Persona', 'filename' => 'tipo_persona.php', 'name' => 'public.ods_tipo_persona', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Accion (Espacio / Tarea)', 'short_caption' => 'Accion', 'filename' => 'accion.php', 'name' => 'public.ods_accion', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Metodologia de Acción', 'short_caption' => 'Metodologia', 'filename' => 'metodologia.php', 'name' => 'public.ods_metodologia', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Tipo Accion', 'short_caption' => 'Tipo Accion', 'filename' => 'tipo_accion.php', 'name' => 'public.ods_tipo_accion', 'group_name' => 'Paramétricas', 'add_separator' => false);
    return $result;
}

function GetPagesHeader()
{
    return
    '<br>
<h2 style="text-align:left;color:lightgrey">Dirección Técnica Operativa</h2>
<h3>Sistema de Gestión de Activos</h3>
<br>';
}

function GetPagesFooter()
{
    return
        ''; 
    }

function ApplyCommonPageSettings(Page $page, Grid $grid)
{
    $page->SetShowUserAuthBar(true);
    $page->OnCustomHTMLHeader->AddListener('Global_CustomHTMLHeaderHandler');
    $page->OnGetCustomTemplate->AddListener('Global_GetCustomTemplateHandler');
    $grid->BeforeUpdateRecord->AddListener('Global_BeforeUpdateHandler');
    $grid->BeforeDeleteRecord->AddListener('Global_BeforeDeleteHandler');
    $grid->BeforeInsertRecord->AddListener('Global_BeforeInsertHandler');
}

/*
  Default code page: 1252
*/
function GetAnsiEncoding() { return 'windows-1252'; }

function Global_CustomHTMLHeaderHandler($page, &$customHtmlHeaderText)
{

}

function Global_GetCustomTemplateHandler($part, $mode, &$result, &$params, Page $page = null)
{

}

function Global_BeforeUpdateHandler($page, &$rowData, &$cancel, &$message, $tableName)
{

}

function Global_BeforeDeleteHandler($page, &$rowData, &$cancel, &$message, $tableName)
{

}

function Global_BeforeInsertHandler($page, &$rowData, &$cancel, &$message, $tableName)
{

}

function GetDefaultDateFormat()
{
    return 'Y-m-d';
}

function GetFirstDayOfWeek()
{
    return 1;
}

function GetEnableLessFilesRunTimeCompilation()
{
    return false;
}



?>