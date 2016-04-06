<?php
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                                   ATTENTION!
 * If you see this message in your browser (Internet Explorer, Mozilla Firefox, Google Chrome, etc.)
 * this means that PHP is not properly installed on your web server. Please refer to the PHP manual
 * for more details: http://php.net/manual/install.php 
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 */


    include_once dirname(__FILE__) . '/' . 'components/utils/check_utils.php';
    CheckPHPVersion();
    CheckTemplatesCacheFolderIsExistsAndWritable();


    include_once dirname(__FILE__) . '/' . 'phpgen_settings.php';
    include_once dirname(__FILE__) . '/' . 'database_engine/pgsql_engine.php';
    include_once dirname(__FILE__) . '/' . 'components/page.php';
    include_once dirname(__FILE__) . '/' . 'authorization.php';

    function GetConnectionOptions()
    {
        $result = GetGlobalConnectionOptions();
        $result['client_encoding'] = 'utf8';
        GetApplication()->GetUserAuthorizationStrategy()->ApplyIdentityToConnectionOptions($result);
        return $result;
    }

    
    // OnGlobalBeforePageExecute event handler
    
    
    // OnBeforePageExecute event handler
    
    
    
    class public_sga_accionPage extends Page
    {
        protected function DoBeforeCreate()
        {
            $this->dataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_accion"');
            $field = new IntegerField('id_accion', null, null, true);
            $field->SetIsNotNull(true);
            $this->dataset->AddField($field, true);
            $field = new IntegerField('id_tipo_espacio');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_tipo_bien');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_origen');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_metodologia');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_periodicidad');
            $this->dataset->AddField($field, false);
            $field = new BooleanField('fl_a_demanda');
            $this->dataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_sector');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('nu_personas');
            $this->dataset->AddField($field, false);
            $field = new TimeField('tm_carga_horaria');
            $this->dataset->AddField($field, false);
            $field = new StringField('fe_horas');
            $this->dataset->AddField($field, false);
            $this->dataset->AddLookupField('id_tipo_accion', 'public.sga_tipo_accion', new IntegerField('id_tipo_accion', null, null, true), new StringField('ds_referencia', 'id_tipo_accion_ds_referencia', 'id_tipo_accion_ds_referencia_public_sga_tipo_accion'), 'id_tipo_accion_ds_referencia_public_sga_tipo_accion');
            $this->dataset->AddLookupField('id_tipo_espacio', 'public.sga_tipo_espacio', new IntegerField('id_tipo_espacio', null, null, true), new StringField('ds_referencia', 'id_tipo_espacio_ds_referencia', 'id_tipo_espacio_ds_referencia_public_sga_tipo_espacio'), 'id_tipo_espacio_ds_referencia_public_sga_tipo_espacio');
            $this->dataset->AddLookupField('id_sector', 'public.sga_sector', new IntegerField('id_sector', null, null, true), new StringField('no_sector', 'id_sector_no_sector', 'id_sector_no_sector_public_sga_sector'), 'id_sector_no_sector_public_sga_sector');
            $this->dataset->AddLookupField('id_metodologia', 'public.sga_metodologia', new IntegerField('id_metodologia', null, null, true), new StringField('no_metodologia', 'id_metodologia_no_metodologia', 'id_metodologia_no_metodologia_public_sga_metodologia'), 'id_metodologia_no_metodologia_public_sga_metodologia');
            $this->dataset->AddLookupField('id_periodicidad', 'public.sga_periodicidad', new IntegerField('id_periodicidad', null, null, true), new StringField('no_periodicidad', 'id_periodicidad_no_periodicidad', 'id_periodicidad_no_periodicidad_public_sga_periodicidad'), 'id_periodicidad_no_periodicidad_public_sga_periodicidad');
            $this->dataset->AddLookupField('id_origen', 'public.sga_origen', new IntegerField('id_origen', null, null, true), new StringField('no_origen', 'id_origen_no_origen', 'id_origen_no_origen_public_sga_origen'), 'id_origen_no_origen_public_sga_origen');
        }
    
        protected function DoPrepare() {
    
        }
    
        protected function CreatePageNavigator()
        {
            return null;
        }
    
        public function GetPageList()
        {
            $currentPageCaption = $this->GetShortCaption();
            $result = new PageList($this);
            $result->AddGroup($this->RenderText('Maestras'));
            $result->AddGroup($this->RenderText('Paramétricas'));
            if (GetCurrentUserGrantForDataSource('public.sga_accion')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Acción (Espacio / Bien)'), 'accion.php', $this->RenderText('Acción'), $currentPageCaption == $this->RenderText('Acción (Espacio / Bien)'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.sga_tarea_plan')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tarea Planificada'), 'tarea_plan.php', $this->RenderText('Tarea Planificada'), $currentPageCaption == $this->RenderText('Tarea Planificada'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.sga_espacio')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Espacio'), 'espacio.php', $this->RenderText('Espacio'), $currentPageCaption == $this->RenderText('Espacio'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.sga_metodologia')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Metodologia de Acción'), 'metodologia.php', $this->RenderText('Metodologia'), $currentPageCaption == $this->RenderText('Metodologia de Acción'), false, $this->RenderText('Paramétricas')));
            if (GetCurrentUserGrantForDataSource('public.sga_tipo_accion')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Accion'), 'tipo_accion.php', $this->RenderText('Tipo Accion'), $currentPageCaption == $this->RenderText('Tipo Accion'), false, $this->RenderText('Paramétricas')));
            if (GetCurrentUserGrantForDataSource('public.sga_periodicidad')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Periodicidad'), 'periodicidad.php', $this->RenderText('Periodicidad'), $currentPageCaption == $this->RenderText('Periodicidad'), false, $this->RenderText('Paramétricas')));
            if (GetCurrentUserGrantForDataSource('public.sga_planta')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Planta'), 'planta.php', $this->RenderText('Planta'), $currentPageCaption == $this->RenderText('Planta'), false, $this->RenderText('Paramétricas')));
            if (GetCurrentUserGrantForDataSource('public.sga_sector')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Sector'), 'sector.php', $this->RenderText('Sector'), $currentPageCaption == $this->RenderText('Sector'), false, $this->RenderText('Paramétricas')));
            if (GetCurrentUserGrantForDataSource('public.sga_origen')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Origen'), 'origen.php', $this->RenderText('Origen'), $currentPageCaption == $this->RenderText('Origen'), false, $this->RenderText('Paramétricas')));
            if (GetCurrentUserGrantForDataSource('public.sga_tipo_espacio')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Espacio'), 'tipo_espacio.php', $this->RenderText('Tipo Espacio'), $currentPageCaption == $this->RenderText('Tipo Espacio'), false, $this->RenderText('Paramétricas')));
            
            if ( HasAdminPage() && GetApplication()->HasAdminGrantForCurrentUser() ) {
              $result->AddGroup('Admin area');
              $result->AddPage(new PageLink($this->GetLocalizerCaptions()->GetMessageString('AdminPage'), 'phpgen_admin.php', $this->GetLocalizerCaptions()->GetMessageString('AdminPage'), false, false, 'Admin area'));
            }
            return $result;
        }
    
        protected function CreateRssGenerator()
        {
            return null;
        }
    
        protected function CreateGridSearchControl(Grid $grid)
        {
            $grid->UseFilter = true;
            $grid->SearchControl = new SimpleSearch('public_sga_accionssearch', $this->dataset,
                array('id_accion', 'id_tipo_accion_ds_referencia', 'id_tipo_espacio_ds_referencia', 'id_sector_no_sector', 'id_origen_no_origen', 'id_metodologia_no_metodologia', 'id_periodicidad_no_periodicidad', 'fl_a_demanda', 'nu_personas', 'tm_carga_horaria', 'fe_horas', 'ds_referencia'),
                array($this->RenderText('Id Accion'), $this->RenderText('Tipo Accion'), $this->RenderText('Tipo Espacio'), $this->RenderText('Sector'), $this->RenderText('Origen'), $this->RenderText('Metodología'), $this->RenderText('Periodicidad'), $this->RenderText('A Demanda'), $this->RenderText('Personas'), $this->RenderText('Carga Horária'), $this->RenderText('Horas Ejecución'), $this->RenderText('Descripción')),
                array(
                    '=' => $this->GetLocalizerCaptions()->GetMessageString('equals'),
                    '<>' => $this->GetLocalizerCaptions()->GetMessageString('doesNotEquals'),
                    '<' => $this->GetLocalizerCaptions()->GetMessageString('isLessThan'),
                    '<=' => $this->GetLocalizerCaptions()->GetMessageString('isLessThanOrEqualsTo'),
                    '>' => $this->GetLocalizerCaptions()->GetMessageString('isGreaterThan'),
                    '>=' => $this->GetLocalizerCaptions()->GetMessageString('isGreaterThanOrEqualsTo'),
                    'ILIKE' => $this->GetLocalizerCaptions()->GetMessageString('Like'),
                    'STARTS' => $this->GetLocalizerCaptions()->GetMessageString('StartsWith'),
                    'ENDS' => $this->GetLocalizerCaptions()->GetMessageString('EndsWith'),
                    'CONTAINS' => $this->GetLocalizerCaptions()->GetMessageString('Contains')
                    ), $this->GetLocalizerCaptions(), $this, 'CONTAINS'
                );
        }
    
        protected function CreateGridAdvancedSearchControl(Grid $grid)
        {
            $this->AdvancedSearchControl = new AdvancedSearchControl('public_sga_accionasearch', $this->dataset, $this->GetLocalizerCaptions(), $this->GetColumnVariableContainer(), $this->CreateLinkBuilder());
            $this->AdvancedSearchControl->setTimerInterval(1000);
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('id_accion', $this->RenderText('Id Accion')));
            
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_tipo_accion"');
            $field = new IntegerField('id_tipo_accion', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_tipo_accion');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion_padre');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_tipo_accion', $this->RenderText('Tipo Accion'), $lookupDataset, 'id_tipo_accion', 'ds_referencia', false, 8));
            
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_tipo_espacio"');
            $field = new IntegerField('id_tipo_espacio', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_tipo_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_espacio_padre');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_tipo_espacio', $this->RenderText('Tipo Espacio'), $lookupDataset, 'id_tipo_espacio', 'ds_referencia', false, 8));
            
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_sector"');
            $field = new IntegerField('id_sector', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_sector');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_sector', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_sector', $this->RenderText('Sector'), $lookupDataset, 'id_sector', 'no_sector', false, 8));
            
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_origen"');
            $field = new IntegerField('id_origen', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_origen');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_origen', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_origen', $this->RenderText('Origen'), $lookupDataset, 'id_origen', 'no_origen', false, 8));
            
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_metodologia"');
            $field = new IntegerField('id_metodologia', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_metodologia');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_metodologia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_origen');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_metodologia', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_metodologia', $this->RenderText('Metodología'), $lookupDataset, 'id_metodologia', 'no_metodologia', false, 8));
            
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_periodicidad"');
            $field = new IntegerField('id_periodicidad', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_periodicidad');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('va_frecuencia');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_periodicidad', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_periodicidad', $this->RenderText('Periodicidad'), $lookupDataset, 'id_periodicidad', 'no_periodicidad', false, 8));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('fl_a_demanda', $this->RenderText('A Demanda')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('nu_personas', $this->RenderText('Personas')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('tm_carga_horaria', $this->RenderText('Carga Horária')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('fe_horas', $this->RenderText('Horas Ejecución')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('ds_referencia', $this->RenderText('Descripción')));
        }
    
        protected function AddOperationsColumns(Grid $grid)
        {
            $actionsBandName = 'actions';
            $grid->AddBandToBegin($actionsBandName, $this->GetLocalizerCaptions()->GetMessageString('Actions'), true);
            if ($this->GetSecurityInfo()->HasViewGrant())
            {
                $column = new ModalDialogViewRowColumn(
                    $this->GetLocalizerCaptions()->GetMessageString('View'), $this->dataset,
                    $this->GetLocalizerCaptions()->GetMessageString('View'),
                    $this->GetModalGridViewHandler());
                $grid->AddViewColumn($column, $actionsBandName);
            }
            if ($this->GetSecurityInfo()->HasEditGrant())
            {
                $column = new RowOperationByLinkColumn($this->GetLocalizerCaptions()->GetMessageString('Edit'), OPERATION_EDIT, $this->dataset);
                $grid->AddViewColumn($column, $actionsBandName);
                $column->OnShow->AddListener('ShowEditButtonHandler', $this);
            }
            if ($this->GetSecurityInfo()->HasDeleteGrant())
            {
                $column = new RowOperationByLinkColumn($this->GetLocalizerCaptions()->GetMessageString('Delete'), OPERATION_DELETE, $this->dataset);
                $grid->AddViewColumn($column, $actionsBandName);
                $column->OnShow->AddListener('ShowDeleteButtonHandler', $this);
                $column->SetAdditionalAttribute('data-modal-delete', 'true');
                $column->SetAdditionalAttribute('data-delete-handler-name', $this->GetModalGridDeleteHandler());
            }
            if ($this->GetSecurityInfo()->HasAddGrant())
            {
                $column = new RowOperationByLinkColumn($this->GetLocalizerCaptions()->GetMessageString('Copy'), OPERATION_COPY, $this->dataset);
                $grid->AddViewColumn($column, $actionsBandName);
            }
        }
    
        protected function AddFieldColumns(Grid $grid)
        {
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_accion_ds_referencia', 'Tipo Accion', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_accion.php?operation=view&pk0=%id_tipo_accion%' , '_self');
            $column->SetDescription($this->RenderText('Tipo de la accion.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_espacio_ds_referencia', 'Tipo Espacio', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_espacio.php?operation=view&pk0=%id_tipo_espacio%' , '_self');
            $column->SetDescription($this->RenderText('Tipo de espacio en que se puede ejecutar la acción.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for no_sector field
            //
            $column = new TextViewColumn('id_sector_no_sector', 'Sector', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'sector.php?operation=view&pk0=%id_sector%' , '_self');
            $column->SetDescription($this->RenderText('Sector sobre el que se ejecuta la acción.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for no_metodologia field
            //
            $column = new TextViewColumn('id_metodologia_no_metodologia', 'Metodología', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'metodologia.php?operation=view&pk0=%id_metodologia%' , '_self');
            $column->SetDescription($this->RenderText('Metodología de realización de la acción.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for no_periodicidad field
            //
            $column = new TextViewColumn('id_periodicidad_no_periodicidad', 'Periodicidad', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'periodicidad.php?operation=view&pk0=%id_periodicidad%' , '_self');
            $column->SetDescription($this->RenderText('Periodicidad de ejecución de la acción.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for fe_horas field
            //
            $column = new TextViewColumn('fe_horas', 'Horas Ejecución', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_accionGrid_fe_horas_handler_list');
            $column->SetDescription($this->RenderText(' Horarios de ejecución de las tareas.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
        }
    
        protected function AddSingleRecordViewColumns(Grid $grid)
        {
            //
            // View column for id_accion field
            //
            $column = new TextViewColumn('id_accion', 'Id Accion', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_accion_ds_referencia', 'Tipo Accion', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_accion.php?operation=view&pk0=%id_tipo_accion%' , '_self');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_espacio_ds_referencia', 'Tipo Espacio', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_espacio.php?operation=view&pk0=%id_tipo_espacio%' , '_self');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for no_sector field
            //
            $column = new TextViewColumn('id_sector_no_sector', 'Sector', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'sector.php?operation=view&pk0=%id_sector%' , '_self');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for no_origen field
            //
            $column = new TextViewColumn('id_origen_no_origen', 'Origen', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'origen.php?operation=view&pk0=%id_origen%' , '_self');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for no_metodologia field
            //
            $column = new TextViewColumn('id_metodologia_no_metodologia', 'Metodología', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'metodologia.php?operation=view&pk0=%id_metodologia%' , '_self');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for no_periodicidad field
            //
            $column = new TextViewColumn('id_periodicidad_no_periodicidad', 'Periodicidad', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'periodicidad.php?operation=view&pk0=%id_periodicidad%' , '_self');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for fl_a_demanda field
            //
            $column = new TextViewColumn('fl_a_demanda', 'A Demanda', $this->dataset);
            $column->SetOrderable(true);
            $column = new CheckBoxFormatValueViewColumnDecorator($column);
            $column->SetDisplayValues($this->RenderText('<img src="images/checked.png" alt="true">'), $this->RenderText(''));
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for nu_personas field
            //
            $column = new TextViewColumn('nu_personas', 'Personas', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for tm_carga_horaria field
            //
            $column = new DateTimeViewColumn('tm_carga_horaria', 'Carga Horária', $this->dataset);
            $column->SetDateTimeFormat('H:i:s');
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for fe_horas field
            //
            $column = new TextViewColumn('fe_horas', 'Horas Ejecución', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_accionGrid_fe_horas_handler_view');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Descripción', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_accionGrid_ds_referencia_handler_view');
            $grid->AddSingleRecordViewColumn($column);
        }
    
        protected function AddEditColumns(Grid $grid)
        {
            //
            // Edit column for id_accion field
            //
            $editor = new TextEdit('id_accion_edit');
            $editColumn = new CustomEditColumn('Id Accion', 'id_accion', $editor, $this->dataset);
            $editColumn->SetReadOnly(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_tipo_accion field
            //
            $editor = new ComboBox('id_tipo_accion_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_tipo_accion"');
            $field = new IntegerField('id_tipo_accion', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_tipo_accion');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion_padre');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Tipo Accion', 
                'id_tipo_accion', 
                $editor, 
                $this->dataset, 'id_tipo_accion', 'ds_referencia', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_tipo_espacio field
            //
            $editor = new ComboBox('id_tipo_espacio_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_tipo_espacio"');
            $field = new IntegerField('id_tipo_espacio', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_tipo_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_espacio_padre');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Tipo Espacio', 
                'id_tipo_espacio', 
                $editor, 
                $this->dataset, 'id_tipo_espacio', 'ds_referencia', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_sector field
            //
            $editor = new ComboBox('id_sector_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_sector"');
            $field = new IntegerField('id_sector', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_sector');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_sector', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Sector', 
                'id_sector', 
                $editor, 
                $this->dataset, 'id_sector', 'no_sector', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_origen field
            //
            $editor = new ComboBox('id_origen_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_origen"');
            $field = new IntegerField('id_origen', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_origen');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_origen', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Origen', 
                'id_origen', 
                $editor, 
                $this->dataset, 'id_origen', 'no_origen', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_metodologia field
            //
            $editor = new ComboBox('id_metodologia_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_metodologia"');
            $field = new IntegerField('id_metodologia', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_metodologia');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_metodologia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_origen');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_metodologia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Metodología', 
                'id_metodologia', 
                $editor, 
                $this->dataset, 'id_metodologia', 'no_metodologia', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_periodicidad field
            //
            $editor = new ComboBox('id_periodicidad_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_periodicidad"');
            $field = new IntegerField('id_periodicidad', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_periodicidad');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('va_frecuencia');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_periodicidad', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Periodicidad', 
                'id_periodicidad', 
                $editor, 
                $this->dataset, 'id_periodicidad', 'no_periodicidad', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for fl_a_demanda field
            //
            $editor = new CheckBox('fl_a_demanda_edit');
            $editColumn = new CustomEditColumn('A Demanda', 'fl_a_demanda', $editor, $this->dataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for nu_personas field
            //
            $editor = new TextEdit('nu_personas_edit');
            $editColumn = new CustomEditColumn('Personas', 'nu_personas', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for tm_carga_horaria field
            //
            $editor = new TimeEdit('tm_carga_horaria_edit');
            $editColumn = new CustomEditColumn('Carga Horária', 'tm_carga_horaria', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for fe_horas field
            //
            $editor = new MultiValueSelect('fe_horas_edit');
            $editor->AddValue('00:00', $this->RenderText('00:00'));
            $editor->AddValue('00:15', $this->RenderText('00:15'));
            $editor->AddValue('00:30', $this->RenderText('00:30'));
            $editor->AddValue('00:45', $this->RenderText('00:45'));
            $editor->AddValue('01:00', $this->RenderText('01:00'));
            $editor->AddValue('01:15', $this->RenderText('01:15'));
            $editor->AddValue('01:30', $this->RenderText('01:30'));
            $editor->AddValue('01:45', $this->RenderText('01:45'));
            $editor->AddValue('02:00', $this->RenderText('02:00'));
            $editor->AddValue('02:15', $this->RenderText('02:15'));
            $editor->AddValue('02:30', $this->RenderText('02:30'));
            $editor->AddValue('02:45', $this->RenderText('02:45'));
            $editor->AddValue('03:00', $this->RenderText('03:00'));
            $editor->AddValue('03:15', $this->RenderText('03:15'));
            $editor->AddValue('03:30', $this->RenderText('03:30'));
            $editor->AddValue('03:45', $this->RenderText('03:45'));
            $editor->AddValue('04:00', $this->RenderText('04:00'));
            $editor->AddValue('04:15', $this->RenderText('04:15'));
            $editor->AddValue('04:30', $this->RenderText('04:30'));
            $editor->AddValue('04:45', $this->RenderText('04:45'));
            $editor->AddValue('05:00', $this->RenderText('05:00'));
            $editor->AddValue('05:15', $this->RenderText('05:15'));
            $editor->AddValue('05:30', $this->RenderText('05:30'));
            $editor->AddValue('05:45', $this->RenderText('05:45'));
            $editor->AddValue('06:00', $this->RenderText('06:00'));
            $editor->AddValue('06:15', $this->RenderText('06:15'));
            $editor->AddValue('06:30', $this->RenderText('06:30'));
            $editor->AddValue('06:45', $this->RenderText('06:45'));
            $editor->AddValue('07:00', $this->RenderText('07:00'));
            $editor->AddValue('07:15', $this->RenderText('07:15'));
            $editor->AddValue('07:30', $this->RenderText('07:30'));
            $editor->AddValue('07:45', $this->RenderText('07:45'));
            $editor->AddValue('08:00', $this->RenderText('08:00'));
            $editor->AddValue('08:15', $this->RenderText('08:15'));
            $editor->AddValue('08:30', $this->RenderText('08:30'));
            $editor->AddValue('08:45', $this->RenderText('08:45'));
            $editor->AddValue('09:00', $this->RenderText('09:00'));
            $editor->AddValue('09:15', $this->RenderText('09:15'));
            $editor->AddValue('09:30', $this->RenderText('09:30'));
            $editor->AddValue('09:45', $this->RenderText('09:45'));
            $editor->AddValue('10:00', $this->RenderText('10:00'));
            $editor->AddValue('10:15', $this->RenderText('10:15'));
            $editor->AddValue('10:30', $this->RenderText('10:30'));
            $editor->AddValue('10:45', $this->RenderText('10:45'));
            $editor->AddValue('11:00', $this->RenderText('11:00'));
            $editor->AddValue('11:15', $this->RenderText('11:15'));
            $editor->AddValue('11:30', $this->RenderText('11:30'));
            $editor->AddValue('11:45', $this->RenderText('11:45'));
            $editor->AddValue('12:00', $this->RenderText('12:00'));
            $editor->AddValue('12:15', $this->RenderText('12:15'));
            $editor->AddValue('12:30', $this->RenderText('12:30'));
            $editor->AddValue('12:45', $this->RenderText('12:45'));
            $editor->AddValue('13:00', $this->RenderText('13:00'));
            $editor->AddValue('13:15', $this->RenderText('13:15'));
            $editor->AddValue('13:30', $this->RenderText('13:30'));
            $editor->AddValue('13:45', $this->RenderText('13:45'));
            $editor->AddValue('14:00', $this->RenderText('14:00'));
            $editor->AddValue('14:15', $this->RenderText('14:15'));
            $editor->AddValue('14:30', $this->RenderText('14:30'));
            $editor->AddValue('14:45', $this->RenderText('14:45'));
            $editor->AddValue('15:00', $this->RenderText('15:00'));
            $editor->AddValue('15:15', $this->RenderText('15:15'));
            $editor->AddValue('15:30', $this->RenderText('15:30'));
            $editor->AddValue('15:45', $this->RenderText('15:45'));
            $editor->AddValue('16:00', $this->RenderText('16:00'));
            $editor->AddValue('16:15', $this->RenderText('16:15'));
            $editor->AddValue('16:30', $this->RenderText('16:30'));
            $editor->AddValue('16:45', $this->RenderText('16:45'));
            $editor->AddValue('17:00', $this->RenderText('17:00'));
            $editor->AddValue('17:15', $this->RenderText('17:15'));
            $editor->AddValue('17:30', $this->RenderText('17:30'));
            $editor->AddValue('17:45', $this->RenderText('17:45'));
            $editor->AddValue('18:00', $this->RenderText('18:00'));
            $editor->AddValue('18:15', $this->RenderText('18:15'));
            $editor->AddValue('18:30', $this->RenderText('18:30'));
            $editor->AddValue('18:45', $this->RenderText('18:45'));
            $editor->AddValue('19:00', $this->RenderText('19:00'));
            $editor->AddValue('19:15', $this->RenderText('19:15'));
            $editor->AddValue('19:30', $this->RenderText('19:30'));
            $editor->AddValue('19:45', $this->RenderText('19:45'));
            $editor->AddValue('20:00', $this->RenderText('20:00'));
            $editor->AddValue('20:15', $this->RenderText('20:15'));
            $editor->AddValue('20:30', $this->RenderText('20:30'));
            $editor->AddValue('20:45', $this->RenderText('20:45'));
            $editor->AddValue('21:00', $this->RenderText('21:00'));
            $editor->AddValue('21:15', $this->RenderText('21:15'));
            $editor->AddValue('21:30', $this->RenderText('21:30'));
            $editor->AddValue('21:45', $this->RenderText('21:45'));
            $editor->AddValue('22:00', $this->RenderText('22:00'));
            $editor->AddValue('22:15', $this->RenderText('22:15'));
            $editor->AddValue('22:30', $this->RenderText('22:30'));
            $editor->AddValue('22:45', $this->RenderText('22:45'));
            $editor->AddValue('23:00', $this->RenderText('23:00'));
            $editor->AddValue('23:15', $this->RenderText('23:15'));
            $editor->AddValue('23:30', $this->RenderText('23:30'));
            $editor->AddValue('23:45', $this->RenderText('23:45'));
            $editor->setMaxSelectionSize(0);
            $editColumn = new CustomEditColumn('Horas Ejecución', 'fe_horas', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
        }
    
        protected function AddInsertColumns(Grid $grid)
        {
            //
            // Edit column for id_tipo_accion field
            //
            $editor = new ComboBox('id_tipo_accion_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_tipo_accion"');
            $field = new IntegerField('id_tipo_accion', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_tipo_accion');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion_padre');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Tipo Accion', 
                'id_tipo_accion', 
                $editor, 
                $this->dataset, 'id_tipo_accion', 'ds_referencia', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for id_tipo_espacio field
            //
            $editor = new ComboBox('id_tipo_espacio_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_tipo_espacio"');
            $field = new IntegerField('id_tipo_espacio', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_tipo_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_espacio_padre');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Tipo Espacio', 
                'id_tipo_espacio', 
                $editor, 
                $this->dataset, 'id_tipo_espacio', 'ds_referencia', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for id_sector field
            //
            $editor = new ComboBox('id_sector_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_sector"');
            $field = new IntegerField('id_sector', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_sector');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_sector', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Sector', 
                'id_sector', 
                $editor, 
                $this->dataset, 'id_sector', 'no_sector', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for id_origen field
            //
            $editor = new ComboBox('id_origen_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_origen"');
            $field = new IntegerField('id_origen', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_origen');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_origen', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Origen', 
                'id_origen', 
                $editor, 
                $this->dataset, 'id_origen', 'no_origen', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for id_metodologia field
            //
            $editor = new ComboBox('id_metodologia_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_metodologia"');
            $field = new IntegerField('id_metodologia', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_metodologia');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_metodologia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_origen');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_metodologia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Metodología', 
                'id_metodologia', 
                $editor, 
                $this->dataset, 'id_metodologia', 'no_metodologia', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for id_periodicidad field
            //
            $editor = new ComboBox('id_periodicidad_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_periodicidad"');
            $field = new IntegerField('id_periodicidad', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_periodicidad');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('va_frecuencia');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('no_periodicidad', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Periodicidad', 
                'id_periodicidad', 
                $editor, 
                $this->dataset, 'id_periodicidad', 'no_periodicidad', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for fl_a_demanda field
            //
            $editor = new CheckBox('fl_a_demanda_edit');
            $editColumn = new CustomEditColumn('A Demanda', 'fl_a_demanda', $editor, $this->dataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for nu_personas field
            //
            $editor = new TextEdit('nu_personas_edit');
            $editColumn = new CustomEditColumn('Personas', 'nu_personas', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for tm_carga_horaria field
            //
            $editor = new TimeEdit('tm_carga_horaria_edit');
            $editColumn = new CustomEditColumn('Carga Horária', 'tm_carga_horaria', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for fe_horas field
            //
            $editor = new MultiValueSelect('fe_horas_edit');
            $editor->AddValue('00:00', $this->RenderText('00:00'));
            $editor->AddValue('00:15', $this->RenderText('00:15'));
            $editor->AddValue('00:30', $this->RenderText('00:30'));
            $editor->AddValue('00:45', $this->RenderText('00:45'));
            $editor->AddValue('01:00', $this->RenderText('01:00'));
            $editor->AddValue('01:15', $this->RenderText('01:15'));
            $editor->AddValue('01:30', $this->RenderText('01:30'));
            $editor->AddValue('01:45', $this->RenderText('01:45'));
            $editor->AddValue('02:00', $this->RenderText('02:00'));
            $editor->AddValue('02:15', $this->RenderText('02:15'));
            $editor->AddValue('02:30', $this->RenderText('02:30'));
            $editor->AddValue('02:45', $this->RenderText('02:45'));
            $editor->AddValue('03:00', $this->RenderText('03:00'));
            $editor->AddValue('03:15', $this->RenderText('03:15'));
            $editor->AddValue('03:30', $this->RenderText('03:30'));
            $editor->AddValue('03:45', $this->RenderText('03:45'));
            $editor->AddValue('04:00', $this->RenderText('04:00'));
            $editor->AddValue('04:15', $this->RenderText('04:15'));
            $editor->AddValue('04:30', $this->RenderText('04:30'));
            $editor->AddValue('04:45', $this->RenderText('04:45'));
            $editor->AddValue('05:00', $this->RenderText('05:00'));
            $editor->AddValue('05:15', $this->RenderText('05:15'));
            $editor->AddValue('05:30', $this->RenderText('05:30'));
            $editor->AddValue('05:45', $this->RenderText('05:45'));
            $editor->AddValue('06:00', $this->RenderText('06:00'));
            $editor->AddValue('06:15', $this->RenderText('06:15'));
            $editor->AddValue('06:30', $this->RenderText('06:30'));
            $editor->AddValue('06:45', $this->RenderText('06:45'));
            $editor->AddValue('07:00', $this->RenderText('07:00'));
            $editor->AddValue('07:15', $this->RenderText('07:15'));
            $editor->AddValue('07:30', $this->RenderText('07:30'));
            $editor->AddValue('07:45', $this->RenderText('07:45'));
            $editor->AddValue('08:00', $this->RenderText('08:00'));
            $editor->AddValue('08:15', $this->RenderText('08:15'));
            $editor->AddValue('08:30', $this->RenderText('08:30'));
            $editor->AddValue('08:45', $this->RenderText('08:45'));
            $editor->AddValue('09:00', $this->RenderText('09:00'));
            $editor->AddValue('09:15', $this->RenderText('09:15'));
            $editor->AddValue('09:30', $this->RenderText('09:30'));
            $editor->AddValue('09:45', $this->RenderText('09:45'));
            $editor->AddValue('10:00', $this->RenderText('10:00'));
            $editor->AddValue('10:15', $this->RenderText('10:15'));
            $editor->AddValue('10:30', $this->RenderText('10:30'));
            $editor->AddValue('10:45', $this->RenderText('10:45'));
            $editor->AddValue('11:00', $this->RenderText('11:00'));
            $editor->AddValue('11:15', $this->RenderText('11:15'));
            $editor->AddValue('11:30', $this->RenderText('11:30'));
            $editor->AddValue('11:45', $this->RenderText('11:45'));
            $editor->AddValue('12:00', $this->RenderText('12:00'));
            $editor->AddValue('12:15', $this->RenderText('12:15'));
            $editor->AddValue('12:30', $this->RenderText('12:30'));
            $editor->AddValue('12:45', $this->RenderText('12:45'));
            $editor->AddValue('13:00', $this->RenderText('13:00'));
            $editor->AddValue('13:15', $this->RenderText('13:15'));
            $editor->AddValue('13:30', $this->RenderText('13:30'));
            $editor->AddValue('13:45', $this->RenderText('13:45'));
            $editor->AddValue('14:00', $this->RenderText('14:00'));
            $editor->AddValue('14:15', $this->RenderText('14:15'));
            $editor->AddValue('14:30', $this->RenderText('14:30'));
            $editor->AddValue('14:45', $this->RenderText('14:45'));
            $editor->AddValue('15:00', $this->RenderText('15:00'));
            $editor->AddValue('15:15', $this->RenderText('15:15'));
            $editor->AddValue('15:30', $this->RenderText('15:30'));
            $editor->AddValue('15:45', $this->RenderText('15:45'));
            $editor->AddValue('16:00', $this->RenderText('16:00'));
            $editor->AddValue('16:15', $this->RenderText('16:15'));
            $editor->AddValue('16:30', $this->RenderText('16:30'));
            $editor->AddValue('16:45', $this->RenderText('16:45'));
            $editor->AddValue('17:00', $this->RenderText('17:00'));
            $editor->AddValue('17:15', $this->RenderText('17:15'));
            $editor->AddValue('17:30', $this->RenderText('17:30'));
            $editor->AddValue('17:45', $this->RenderText('17:45'));
            $editor->AddValue('18:00', $this->RenderText('18:00'));
            $editor->AddValue('18:15', $this->RenderText('18:15'));
            $editor->AddValue('18:30', $this->RenderText('18:30'));
            $editor->AddValue('18:45', $this->RenderText('18:45'));
            $editor->AddValue('19:00', $this->RenderText('19:00'));
            $editor->AddValue('19:15', $this->RenderText('19:15'));
            $editor->AddValue('19:30', $this->RenderText('19:30'));
            $editor->AddValue('19:45', $this->RenderText('19:45'));
            $editor->AddValue('20:00', $this->RenderText('20:00'));
            $editor->AddValue('20:15', $this->RenderText('20:15'));
            $editor->AddValue('20:30', $this->RenderText('20:30'));
            $editor->AddValue('20:45', $this->RenderText('20:45'));
            $editor->AddValue('21:00', $this->RenderText('21:00'));
            $editor->AddValue('21:15', $this->RenderText('21:15'));
            $editor->AddValue('21:30', $this->RenderText('21:30'));
            $editor->AddValue('21:45', $this->RenderText('21:45'));
            $editor->AddValue('22:00', $this->RenderText('22:00'));
            $editor->AddValue('22:15', $this->RenderText('22:15'));
            $editor->AddValue('22:30', $this->RenderText('22:30'));
            $editor->AddValue('22:45', $this->RenderText('22:45'));
            $editor->AddValue('23:00', $this->RenderText('23:00'));
            $editor->AddValue('23:15', $this->RenderText('23:15'));
            $editor->AddValue('23:30', $this->RenderText('23:30'));
            $editor->AddValue('23:45', $this->RenderText('23:45'));
            $editor->setMaxSelectionSize(0);
            $editColumn = new CustomEditColumn('Horas Ejecución', 'fe_horas', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            if ($this->GetSecurityInfo()->HasAddGrant())
            {
                $grid->SetShowAddButton(true);
                $grid->SetShowInlineAddButton(false);
            }
            else
            {
                $grid->SetShowInlineAddButton(false);
                $grid->SetShowAddButton(false);
            }
        }
    
        protected function AddPrintColumns(Grid $grid)
        {
            //
            // View column for id_accion field
            //
            $column = new TextViewColumn('id_accion', 'Id Accion', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_accion_ds_referencia', 'Tipo Accion', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_accion.php?operation=view&pk0=%id_tipo_accion%' , '_self');
            $grid->AddPrintColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_espacio_ds_referencia', 'Tipo Espacio', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_espacio.php?operation=view&pk0=%id_tipo_espacio%' , '_self');
            $grid->AddPrintColumn($column);
            
            //
            // View column for no_sector field
            //
            $column = new TextViewColumn('id_sector_no_sector', 'Sector', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'sector.php?operation=view&pk0=%id_sector%' , '_self');
            $grid->AddPrintColumn($column);
            
            //
            // View column for no_origen field
            //
            $column = new TextViewColumn('id_origen_no_origen', 'Origen', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'origen.php?operation=view&pk0=%id_origen%' , '_self');
            $grid->AddPrintColumn($column);
            
            //
            // View column for no_metodologia field
            //
            $column = new TextViewColumn('id_metodologia_no_metodologia', 'Metodología', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'metodologia.php?operation=view&pk0=%id_metodologia%' , '_self');
            $grid->AddPrintColumn($column);
            
            //
            // View column for no_periodicidad field
            //
            $column = new TextViewColumn('id_periodicidad_no_periodicidad', 'Periodicidad', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'periodicidad.php?operation=view&pk0=%id_periodicidad%' , '_self');
            $grid->AddPrintColumn($column);
            
            //
            // View column for fl_a_demanda field
            //
            $column = new TextViewColumn('fl_a_demanda', 'A Demanda', $this->dataset);
            $column->SetOrderable(true);
            $column = new CheckBoxFormatValueViewColumnDecorator($column);
            $column->SetDisplayValues($this->RenderText('<img src="images/checked.png" alt="true">'), $this->RenderText(''));
            $grid->AddPrintColumn($column);
            
            //
            // View column for nu_personas field
            //
            $column = new TextViewColumn('nu_personas', 'Personas', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for tm_carga_horaria field
            //
            $column = new DateTimeViewColumn('tm_carga_horaria', 'Carga Horária', $this->dataset);
            $column->SetDateTimeFormat('H:i:s');
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for fe_horas field
            //
            $column = new TextViewColumn('fe_horas', 'Fe Horas', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Ds Referencia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
        }
    
        protected function AddExportColumns(Grid $grid)
        {
            //
            // View column for id_accion field
            //
            $column = new TextViewColumn('id_accion', 'Id Accion', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_accion_ds_referencia', 'Tipo Accion', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_accion.php?operation=view&pk0=%id_tipo_accion%' , '_self');
            $grid->AddExportColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_espacio_ds_referencia', 'Tipo Espacio', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_espacio.php?operation=view&pk0=%id_tipo_espacio%' , '_self');
            $grid->AddExportColumn($column);
            
            //
            // View column for no_sector field
            //
            $column = new TextViewColumn('id_sector_no_sector', 'Sector', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'sector.php?operation=view&pk0=%id_sector%' , '_self');
            $grid->AddExportColumn($column);
            
            //
            // View column for no_origen field
            //
            $column = new TextViewColumn('id_origen_no_origen', 'Origen', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'origen.php?operation=view&pk0=%id_origen%' , '_self');
            $grid->AddExportColumn($column);
            
            //
            // View column for no_metodologia field
            //
            $column = new TextViewColumn('id_metodologia_no_metodologia', 'Metodología', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'metodologia.php?operation=view&pk0=%id_metodologia%' , '_self');
            $grid->AddExportColumn($column);
            
            //
            // View column for no_periodicidad field
            //
            $column = new TextViewColumn('id_periodicidad_no_periodicidad', 'Periodicidad', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'periodicidad.php?operation=view&pk0=%id_periodicidad%' , '_self');
            $grid->AddExportColumn($column);
            
            //
            // View column for fl_a_demanda field
            //
            $column = new TextViewColumn('fl_a_demanda', 'A Demanda', $this->dataset);
            $column->SetOrderable(true);
            $column = new CheckBoxFormatValueViewColumnDecorator($column);
            $column->SetDisplayValues($this->RenderText('<img src="images/checked.png" alt="true">'), $this->RenderText(''));
            $grid->AddExportColumn($column);
            
            //
            // View column for nu_personas field
            //
            $column = new TextViewColumn('nu_personas', 'Personas', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for tm_carga_horaria field
            //
            $column = new DateTimeViewColumn('tm_carga_horaria', 'Carga Horária', $this->dataset);
            $column->SetDateTimeFormat('H:i:s');
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for fe_horas field
            //
            $column = new TextViewColumn('fe_horas', 'Fe Horas', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Ds Referencia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
        }
    
        public function GetPageDirection()
        {
            return null;
        }
    
        protected function ApplyCommonColumnEditProperties(CustomEditColumn $column)
        {
            $column->SetDisplaySetToNullCheckBox(false);
            $column->SetDisplaySetToDefaultCheckBox(false);
    		$column->SetVariableContainer($this->GetColumnVariableContainer());
        }
    
        function GetCustomClientScript()
        {
            return ;
        }
        
        function GetOnPageLoadedClientScript()
        {
            return ;
        }
        public function GetModalGridViewHandler() { return 'public_sga_accion_inline_record_view'; }
        protected function GetEnableModalSingleRecordView() { return true; }
        public function ShowEditButtonHandler(&$show)
        {
            if ($this->GetRecordPermission() != null)
                $show = $this->GetRecordPermission()->HasEditGrant($this->GetDataset());
        }
        public function ShowDeleteButtonHandler(&$show)
        {
            if ($this->GetRecordPermission() != null)
                $show = $this->GetRecordPermission()->HasDeleteGrant($this->GetDataset());
        }
        
        public function GetModalGridDeleteHandler() { return 'public_sga_accion_modal_delete'; }
        protected function GetEnableModalGridDelete() { return true; }
    
        protected function CreateGrid()
        {
            $result = new Grid($this, $this->dataset, 'public_sga_accionGrid');
            if ($this->GetSecurityInfo()->HasDeleteGrant())
               $result->SetAllowDeleteSelected(true);
            else
               $result->SetAllowDeleteSelected(true);   
            
            ApplyCommonPageSettings($this, $result);
            
            $result->SetUseImagesForActions(true);
            $defaultSortedColumns = array();
            $defaultSortedColumns[] = new SortColumn('id_accion', 'DESC');
            $result->setDefaultOrdering($defaultSortedColumns);
            $result->SetUseFixedHeader(false);
            $result->SetShowLineNumbers(false);
            
            $result->SetHighlightRowAtHover(true);
            $result->SetWidth('');
            $this->CreateGridSearchControl($result);
            $this->CreateGridAdvancedSearchControl($result);
    
            $this->AddFieldColumns($result);
            $this->AddSingleRecordViewColumns($result);
            $this->AddEditColumns($result);
            $this->AddInsertColumns($result);
            $this->AddPrintColumns($result);
            $this->AddExportColumns($result);
            $this->AddOperationsColumns($result);
            $this->SetShowPageList(true);
            $this->SetHidePageListByDefault(false);
            $this->SetExportToExcelAvailable(true);
            $this->SetExportToWordAvailable(true);
            $this->SetExportToXmlAvailable(true);
            $this->SetExportToCsvAvailable(true);
            $this->SetExportToPdfAvailable(true);
            $this->SetPrinterFriendlyAvailable(true);
            $this->SetSimpleSearchAvailable(true);
            $this->SetAdvancedSearchAvailable(true);
            $this->SetFilterRowAvailable(true);
            $this->SetVisualEffectsEnabled(true);
            $this->SetShowTopPageNavigator(true);
            $this->SetShowBottomPageNavigator(true);
    
            //
            // Http Handlers
            //
            //
            // View column for fe_horas field
            //
            $column = new TextViewColumn('fe_horas', 'Horas Ejecución', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_accionGrid_fe_horas_handler_list', $column);
            GetApplication()->RegisterHTTPHandler($handler);//
            // View column for fe_horas field
            //
            $column = new TextViewColumn('fe_horas', 'Horas Ejecución', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_accionGrid_fe_horas_handler_view', $column);
            GetApplication()->RegisterHTTPHandler($handler);
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Descripción', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_accionGrid_ds_referencia_handler_view', $column);
            GetApplication()->RegisterHTTPHandler($handler);
            return $result;
        }
        
        public function OpenAdvancedSearchByDefault()
        {
            return false;
        }
    
        protected function DoGetGridHeader()
        {
            return '';
        }
    }

    SetUpUserAuthorization(GetApplication());

    try
    {
        $Page = new public_sga_accionPage("accion.php", "public_sga_accion", GetCurrentUserGrantForDataSource("public.sga_accion"), 'UTF-8');
        $Page->SetShortCaption('Acción (Espacio / Bien)');
        $Page->SetHeader(GetPagesHeader());
        $Page->SetFooter(GetPagesFooter());
        $Page->SetCaption('Acción');
        $Page->SetRecordPermission(GetCurrentUserRecordPermissionsForDataSource("public.sga_accion"));
        GetApplication()->SetEnableLessRunTimeCompile(GetEnableLessFilesRunTimeCompilation());
        GetApplication()->SetCanUserChangeOwnPassword(
            !function_exists('CanUserChangeOwnPassword') || CanUserChangeOwnPassword());
        GetApplication()->SetMainPage($Page);
        GetApplication()->Run();
    }
    catch(Exception $e)
    {
        ShowErrorPage($e->getMessage());
    }
	
