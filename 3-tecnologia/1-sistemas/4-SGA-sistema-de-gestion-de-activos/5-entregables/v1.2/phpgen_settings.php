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
  'server' => '10.13.18.133',
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
    $result = array('Maestras', 'Paramétricas');
    return $result;
}

function GetPageInfos()
{
    $result = array();
    $result[] = array('caption' => 'Acción (Espacio / Bien)', 'short_caption' => 'Acción', 'filename' => 'accion.php', 'name' => 'public.sga_accion', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Tarea Planificada', 'short_caption' => 'Tarea Planificada', 'filename' => 'tarea_plan.php', 'name' => 'public.sga_tarea_plan', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Espacio', 'short_caption' => 'Espacio', 'filename' => 'espacio.php', 'name' => 'public.sga_espacio', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Bien', 'short_caption' => 'Bien', 'filename' => 'bien.php', 'name' => 'public.sga_bien', 'group_name' => 'Maestras', 'add_separator' => false);
    $result[] = array('caption' => 'Metodologia de Acción', 'short_caption' => 'Metodologia', 'filename' => 'metodologia.php', 'name' => 'public.sga_metodologia', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Tipo Accion', 'short_caption' => 'Tipo Accion', 'filename' => 'tipo_accion.php', 'name' => 'public.sga_tipo_accion', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Tipo Bien', 'short_caption' => 'Tipo Bien', 'filename' => 'tipo_bien.php', 'name' => 'public.sga_tipo_bien', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Periodicidad', 'short_caption' => 'Periodicidad', 'filename' => 'periodicidad.php', 'name' => 'public.sga_periodicidad', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Planta', 'short_caption' => 'Planta', 'filename' => 'planta.php', 'name' => 'public.sga_planta', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Sector', 'short_caption' => 'Sector', 'filename' => 'sector.php', 'name' => 'public.sga_sector', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Origen', 'short_caption' => 'Origen', 'filename' => 'origen.php', 'name' => 'public.sga_origen', 'group_name' => 'Paramétricas', 'add_separator' => false);
    $result[] = array('caption' => 'Tipo Espacio', 'short_caption' => 'Tipo Espacio', 'filename' => 'tipo_espacio.php', 'name' => 'public.sga_tipo_espacio', 'group_name' => 'Paramétricas', 'add_separator' => false);
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
    return 'd/m/Y';
}

function GetFirstDayOfWeek()
{
    return 0;
}

function GetEnableLessFilesRunTimeCompilation()
{
    return false;
}



?>