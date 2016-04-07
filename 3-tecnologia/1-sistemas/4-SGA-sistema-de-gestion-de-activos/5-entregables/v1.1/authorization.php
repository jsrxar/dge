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
        array('public.sga_accion' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tarea_plan' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_espacio' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_metodologia' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tipo_accion' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tipo_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_periodicidad' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_planta' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_origen' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tipo_espacio' => new DataSourceSecurityInfo(false, false, false, false))
    ,
    'beto' => 
        array('public.sga_accion' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tarea_plan' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_espacio' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_metodologia' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tipo_accion' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tipo_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_periodicidad' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_planta' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_origen' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tipo_espacio' => new DataSourceSecurityInfo(false, false, false, false))
    ,
    'admin' => 
        array('public.sga_accion' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tarea_plan' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_espacio' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_metodologia' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tipo_accion' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tipo_bien' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_periodicidad' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_planta' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_origen' => new DataSourceSecurityInfo(false, false, false, false),
        'public.sga_tipo_espacio' => new DataSourceSecurityInfo(false, false, false, false))
    );

$appGrants = array('guest' => new DataSourceSecurityInfo(false, false, false, false),
    'defaultUser' => new DataSourceSecurityInfo(false, false, false, false),
    'beto' => new DataSourceSecurityInfo(true, true, true, true),
    'admin' => new AdminDataSourceSecurityInfo());

$tableCaptions = array('public.sga_accion' => 'Acción (Espacio / Bien)',
'public.sga_tarea_plan' => 'Tarea Planificada',
'public.sga_espacio' => 'Espacio',
'public.sga_bien' => 'Bien',
'public.sga_metodologia' => 'Metodologia de Acción',
'public.sga_tipo_accion' => 'Tipo Accion',
'public.sga_tipo_bien' => 'Tipo Bien',
'public.sga_periodicidad' => 'Periodicidad',
'public.sga_planta' => 'Planta',
'public.sga_origen' => 'Origen',
'public.sga_tipo_espacio' => 'Tipo Espacio');

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