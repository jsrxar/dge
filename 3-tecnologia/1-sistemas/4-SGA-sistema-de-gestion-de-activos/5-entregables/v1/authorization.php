<?php

require_once 'components/page.php';
require_once 'components/security/datasource_security_info.php';
require_once 'components/security/security_info.php';
require_once 'components/security/hardcoded_auth.php';
require_once 'components/security/user_grants_manager.php';

include_once 'components/security/user_identity_storage/user_identity_session_storage.php';

$users = array('admin' => 'ccee5504c9d889922b101124e9e43b71');

$usersIds = array('admin' => -1);

$dataSourceRecordPermissions = array();

$grants = array('guest' => 
        array()
    ,
    'defaultUser' => 
        array('public.ods_area' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_empresa' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_espacio' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_insumo' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_lectura' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_lugar' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_ocupa' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_origen_lectura' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_origen' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_periodicidad' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_persona' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_realiza' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_requiere' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tarea' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tarea_plan' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_espacio' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_insumo' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_persona' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_accion' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_metodologia' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_accion' => new DataSourceSecurityInfo(false, false, false, false))
    ,
    'beto' => 
        array('public.ods_area' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_empresa' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_espacio' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_insumo' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_lectura' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_lugar' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_ocupa' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_origen_lectura' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_origen' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_periodicidad' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_persona' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_realiza' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_requiere' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tarea' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tarea_plan' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_espacio' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_insumo' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_persona' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_accion' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_metodologia' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_accion' => new DataSourceSecurityInfo(false, false, false, false))
    ,
    'admin' => 
        array('public.ods_area' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_empresa' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_espacio' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_insumo' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_lectura' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_lugar' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_ocupa' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_origen_lectura' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_origen' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_periodicidad' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_persona' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_realiza' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_requiere' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tarea' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tarea_plan' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_espacio' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_insumo' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_persona' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_accion' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_metodologia' => new DataSourceSecurityInfo(false, false, false, false),
        'public.ods_tipo_accion' => new DataSourceSecurityInfo(false, false, false, false))
    );

$appGrants = array('guest' => new DataSourceSecurityInfo(false, false, false, false),
    'defaultUser' => new DataSourceSecurityInfo(false, false, false, false),
    'beto' => new DataSourceSecurityInfo(true, true, true, true),
    'admin' => new AdminDataSourceSecurityInfo());

$tableCaptions = array('public.ods_area' => 'Area',
'public.ods_bien' => 'Bien',
'public.ods_empresa' => 'Empresa',
'public.ods_espacio' => 'Espacio',
'public.ods_insumo' => 'Insumo',
'public.ods_lectura' => 'Lectura',
'public.ods_lugar' => 'Lugar',
'public.ods_ocupa' => 'Ocupa (Area / Espacio)',
'public.ods_origen_lectura' => 'Origen Lectura',
'public.ods_origen' => 'Origen',
'public.ods_periodicidad' => 'Periodicidad',
'public.ods_persona' => 'Persona',
'public.ods_realiza' => 'Realiza (Persona / Tarea)',
'public.ods_requiere' => 'Requiere (Actividad / Insumo)',
'public.ods_tarea' => 'Tarea',
'public.ods_tarea_plan' => 'Tarea Planificada',
'public.ods_tipo_bien' => 'Tipo Bien',
'public.ods_tipo_espacio' => 'Tipo Espacio',
'public.ods_tipo_insumo' => 'Tipo Insumo',
'public.ods_tipo_persona' => 'Tipo Persona',
'public.ods_accion' => 'Accion (Espacio / Tarea)',
'public.ods_metodologia' => 'Metodologia de Acción',
'public.ods_tipo_accion' => 'Tipo Accion');

function SetUpUserAuthorization()
{
    global $usersIds;
    global $grants;
    global $appGrants;
    global $dataSourceRecordPermissions;
    $userAuthorizationStrategy = new HardCodedUserAuthorization(new UserIdentitySessionStorage(GetIdentityCheckStrategy()), new HardCodedUserGrantsManager($grants, $appGrants), $usersIds);
    GetApplication()->SetUserAuthorizationStrategy($userAuthorizationStrategy);

GetApplication()->SetDataSourceRecordPermissionRetrieveStrategy(
    new HardCodedDataSourceRecordPermissionRetrieveStrategy($dataSourceRecordPermissions));
}

function GetIdentityCheckStrategy()
{
    global $users;
    return new SimpleIdentityCheckStrategy($users, 'md5');
}

?>