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
    
    
    
    class public_sga_tarea_planPage extends Page
    {
        protected function DoBeforeCreate()
        {
            $this->dataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_tarea_plan"');
            $field = new IntegerField('id_tarea_plan', null, null, true);
            $field->SetIsNotNull(true);
            $this->dataset->AddField($field, true);
            $field = new IntegerField('id_accion');
            $field->SetIsNotNull(true);
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_bien');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_periodicidad');
            $this->dataset->AddField($field, false);
            $field = new StringField('ds_detalle');
            $this->dataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_espacio');
            $this->dataset->AddField($field, false);
            $field = new DateTimeField('fe_inicio');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('nu_personas');
            $this->dataset->AddField($field, false);
            $field = new TimeField('tm_carga_horaria');
            $this->dataset->AddField($field, false);
            $field = new StringField('fe_horas');
            $this->dataset->AddField($field, false);
            $this->dataset->AddLookupField('id_accion', 'public.sga_accion', new IntegerField('id_accion', null, null, true), new StringField('ds_referencia', 'id_accion_ds_referencia', 'id_accion_ds_referencia_public_sga_accion'), 'id_accion_ds_referencia_public_sga_accion');
            $this->dataset->AddLookupField('id_espacio', 'public.sga_espacio', new IntegerField('id_espacio', null, null, true), new StringField('ds_referencia', 'id_espacio_ds_referencia', 'id_espacio_ds_referencia_public_sga_espacio'), 'id_espacio_ds_referencia_public_sga_espacio');
            $this->dataset->AddLookupField('id_periodicidad', 'public.sga_periodicidad', new IntegerField('id_periodicidad', null, null, true), new StringField('no_periodicidad', 'id_periodicidad_no_periodicidad', 'id_periodicidad_no_periodicidad_public_sga_periodicidad'), 'id_periodicidad_no_periodicidad_public_sga_periodicidad');
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
            $grid->SearchControl = new SimpleSearch('public_sga_tarea_planssearch', $this->dataset,
                array('id_tarea_plan', 'id_accion_ds_referencia', 'id_espacio_ds_referencia', 'id_periodicidad_no_periodicidad', 'ds_detalle', 'fe_inicio', 'nu_personas', 'tm_carga_horaria', 'fe_horas', 'ds_referencia'),
                array($this->RenderText('Id Tarea Plan'), $this->RenderText('Acción'), $this->RenderText('Espacio'), $this->RenderText('Periodicidad'), $this->RenderText('Detalle'), $this->RenderText('Fecha Início'), $this->RenderText('Personas'), $this->RenderText('Carga Horária'), $this->RenderText('Horas Ejecución'), $this->RenderText('Descripción')),
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
            $this->AdvancedSearchControl = new AdvancedSearchControl('public_sga_tarea_planasearch', $this->dataset, $this->GetLocalizerCaptions(), $this->GetColumnVariableContainer(), $this->CreateLinkBuilder());
            $this->AdvancedSearchControl->setTimerInterval(1000);
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('id_tarea_plan', $this->RenderText('Id Tarea Plan')));
            
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_accion"');
            $field = new IntegerField('id_accion', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_espacio');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_bien');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_origen');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_metodologia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_periodicidad');
            $lookupDataset->AddField($field, false);
            $field = new BooleanField('fl_a_demanda');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_sector');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('nu_personas');
            $lookupDataset->AddField($field, false);
            $field = new TimeField('tm_carga_horaria');
            $lookupDataset->AddField($field, false);
            $field = new StringField('fe_horas');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_accion', $this->RenderText('Acción'), $lookupDataset, 'id_accion', 'ds_referencia', false, 8));
            
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_espacio"');
            $field = new IntegerField('id_espacio', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_espacio_contenedor');
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('no_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_plano');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_planta');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_sector');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_espacio', $this->RenderText('Espacio'), $lookupDataset, 'id_espacio', 'ds_referencia', false, 8));
            
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
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('ds_detalle', $this->RenderText('Detalle')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateDateTimeSearchInput('fe_inicio', $this->RenderText('Fecha Início'), 'd/m/Y H:i:s'));
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
            // View column for id_tarea_plan field
            //
            $column = new TextViewColumn('id_tarea_plan', 'Id Tarea Plan', $this->dataset);
            $column->SetOrderable(true);
            $column->SetDescription($this->RenderText('Identificador único de la planificación de la tarea.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_accion_ds_referencia', 'Acción', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'accion.php?operation=view&pk0=%id_accion%' , '_self');
            $column->SetDescription($this->RenderText('Acción que ejecuta la tarea planificada.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_espacio_ds_referencia', 'Espacio', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'espacio.php?operation=view&pk0=%id_espacio%' , '_self');
            $column->SetDescription($this->RenderText('Espacio sobre el que se ejecuta la tarea planificada.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for no_periodicidad field
            //
            $column = new TextViewColumn('id_periodicidad_no_periodicidad', 'Periodicidad', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'periodicidad.php?operation=view&pk0=%id_periodicidad%' , '_self');
            $column->SetDescription($this->RenderText('Periodicidad de ejecución de la tarea planificada.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for ds_detalle field
            //
            $column = new TextViewColumn('ds_detalle', 'Detalle', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_tarea_planGrid_ds_detalle_handler_list');
            $column->SetDescription($this->RenderText('Detalles adicionales necesarios para la realización de la tarea.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for fe_horas field
            //
            $column = new TextViewColumn('fe_horas', 'Horas Ejecución', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_tarea_planGrid_fe_horas_handler_list');
            $column->SetDescription($this->RenderText(' Horarios de ejecución de las tareas.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
        }
    
        protected function AddSingleRecordViewColumns(Grid $grid)
        {
            //
            // View column for id_tarea_plan field
            //
            $column = new TextViewColumn('id_tarea_plan', 'Id Tarea Plan', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_accion_ds_referencia', 'Acción', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'accion.php?operation=view&pk0=%id_accion%' , '_self');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_espacio_ds_referencia', 'Espacio', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'espacio.php?operation=view&pk0=%id_espacio%' , '_self');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for no_periodicidad field
            //
            $column = new TextViewColumn('id_periodicidad_no_periodicidad', 'Periodicidad', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'periodicidad.php?operation=view&pk0=%id_periodicidad%' , '_self');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for ds_detalle field
            //
            $column = new TextViewColumn('ds_detalle', 'Detalle', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_tarea_planGrid_ds_detalle_handler_view');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for fe_inicio field
            //
            $column = new DateTimeViewColumn('fe_inicio', 'Fecha Início', $this->dataset);
            $column->SetDateTimeFormat('d/m/Y H:i:s');
            $column->SetOrderable(true);
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
            $column->SetFullTextWindowHandlerName('public_sga_tarea_planGrid_fe_horas_handler_view');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Descripción', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_tarea_planGrid_ds_referencia_handler_view');
            $grid->AddSingleRecordViewColumn($column);
        }
    
        protected function AddEditColumns(Grid $grid)
        {
            //
            // Edit column for id_tarea_plan field
            //
            $editor = new TextEdit('id_tarea_plan_edit');
            $editColumn = new CustomEditColumn('Id Tarea Plan', 'id_tarea_plan', $editor, $this->dataset);
            $editColumn->SetReadOnly(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_accion field
            //
            $editor = new ComboBox('id_accion_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $editor->setInlineStyles('width: 440px;');
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_accion"');
            $field = new IntegerField('id_accion', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_espacio');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_bien');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_origen');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_metodologia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_periodicidad');
            $lookupDataset->AddField($field, false);
            $field = new BooleanField('fl_a_demanda');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_sector');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('nu_personas');
            $lookupDataset->AddField($field, false);
            $field = new TimeField('tm_carga_horaria');
            $lookupDataset->AddField($field, false);
            $field = new StringField('fe_horas');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Acción', 
                'id_accion', 
                $editor, 
                $this->dataset, 'id_accion', 'ds_referencia', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_espacio field
            //
            $editor = new ComboBox('id_espacio_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $editor->setInlineStyles('width: 440px;');
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_espacio"');
            $field = new IntegerField('id_espacio', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_espacio_contenedor');
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('no_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_plano');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_planta');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_sector');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Espacio', 
                'id_espacio', 
                $editor, 
                $this->dataset, 'id_espacio', 'ds_referencia', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
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
            // Edit column for ds_detalle field
            //
            $editor = new TextAreaEdit('ds_detalle_edit', 50, 8);
            $editColumn = new CustomEditColumn('Detalle', 'ds_detalle', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for fe_inicio field
            //
            $editor = new DateTimeEdit('fe_inicio_edit', true, 'd/m/Y H:i:s', GetFirstDayOfWeek());
            $editColumn = new CustomEditColumn('Fecha Início', 'fe_inicio', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
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
            // Edit column for id_accion field
            //
            $editor = new ComboBox('id_accion_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $editor->setInlineStyles('width: 440px;');
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_accion"');
            $field = new IntegerField('id_accion', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_espacio');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_bien');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_origen');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_metodologia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_periodicidad');
            $lookupDataset->AddField($field, false);
            $field = new BooleanField('fl_a_demanda');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_sector');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('nu_personas');
            $lookupDataset->AddField($field, false);
            $field = new TimeField('tm_carga_horaria');
            $lookupDataset->AddField($field, false);
            $field = new StringField('fe_horas');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Acción', 
                'id_accion', 
                $editor, 
                $this->dataset, 'id_accion', 'ds_referencia', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for id_espacio field
            //
            $editor = new ComboBox('id_espacio_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $editor->setInlineStyles('width: 440px;');
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_espacio"');
            $field = new IntegerField('id_espacio', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_espacio_contenedor');
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('no_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_plano');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_planta');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_sector');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Espacio', 
                'id_espacio', 
                $editor, 
                $this->dataset, 'id_espacio', 'ds_referencia', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
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
            // Edit column for ds_detalle field
            //
            $editor = new TextAreaEdit('ds_detalle_edit', 50, 8);
            $editColumn = new CustomEditColumn('Detalle', 'ds_detalle', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for fe_inicio field
            //
            $editor = new DateTimeEdit('fe_inicio_edit', true, 'd/m/Y H:i:s', GetFirstDayOfWeek());
            $editColumn = new CustomEditColumn('Fecha Início', 'fe_inicio', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
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
            // View column for id_tarea_plan field
            //
            $column = new TextViewColumn('id_tarea_plan', 'Id Tarea Plan', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_accion_ds_referencia', 'Acción', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'accion.php?operation=view&pk0=%id_accion%' , '_self');
            $grid->AddPrintColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_espacio_ds_referencia', 'Espacio', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'espacio.php?operation=view&pk0=%id_espacio%' , '_self');
            $grid->AddPrintColumn($column);
            
            //
            // View column for no_periodicidad field
            //
            $column = new TextViewColumn('id_periodicidad_no_periodicidad', 'Periodicidad', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'periodicidad.php?operation=view&pk0=%id_periodicidad%' , '_self');
            $grid->AddPrintColumn($column);
            
            //
            // View column for ds_detalle field
            //
            $column = new TextViewColumn('ds_detalle', 'Ds Detalle', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for fe_inicio field
            //
            $column = new DateTimeViewColumn('fe_inicio', 'Fecha Início', $this->dataset);
            $column->SetDateTimeFormat('d/m/Y H:i:s');
            $column->SetOrderable(true);
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
            // View column for id_tarea_plan field
            //
            $column = new TextViewColumn('id_tarea_plan', 'Id Tarea Plan', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_accion_ds_referencia', 'Acción', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'accion.php?operation=view&pk0=%id_accion%' , '_self');
            $grid->AddExportColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_espacio_ds_referencia', 'Espacio', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'espacio.php?operation=view&pk0=%id_espacio%' , '_self');
            $grid->AddExportColumn($column);
            
            //
            // View column for no_periodicidad field
            //
            $column = new TextViewColumn('id_periodicidad_no_periodicidad', 'Periodicidad', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'periodicidad.php?operation=view&pk0=%id_periodicidad%' , '_self');
            $grid->AddExportColumn($column);
            
            //
            // View column for ds_detalle field
            //
            $column = new TextViewColumn('ds_detalle', 'Ds Detalle', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for fe_inicio field
            //
            $column = new DateTimeViewColumn('fe_inicio', 'Fecha Início', $this->dataset);
            $column->SetDateTimeFormat('d/m/Y H:i:s');
            $column->SetOrderable(true);
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
        public function GetModalGridViewHandler() { return 'public_sga_tarea_plan_inline_record_view'; }
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
        
        public function GetModalGridDeleteHandler() { return 'public_sga_tarea_plan_modal_delete'; }
        protected function GetEnableModalGridDelete() { return true; }
    
        protected function CreateGrid()
        {
            $result = new Grid($this, $this->dataset, 'public_sga_tarea_planGrid');
            if ($this->GetSecurityInfo()->HasDeleteGrant())
               $result->SetAllowDeleteSelected(true);
            else
               $result->SetAllowDeleteSelected(true);   
            
            ApplyCommonPageSettings($this, $result);
            
            $result->SetUseImagesForActions(true);
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
            // View column for ds_detalle field
            //
            $column = new TextViewColumn('ds_detalle', 'Detalle', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_tarea_planGrid_ds_detalle_handler_list', $column);
            GetApplication()->RegisterHTTPHandler($handler);
            //
            // View column for fe_horas field
            //
            $column = new TextViewColumn('fe_horas', 'Horas Ejecución', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_tarea_planGrid_fe_horas_handler_list', $column);
            GetApplication()->RegisterHTTPHandler($handler);//
            // View column for ds_detalle field
            //
            $column = new TextViewColumn('ds_detalle', 'Detalle', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_tarea_planGrid_ds_detalle_handler_view', $column);
            GetApplication()->RegisterHTTPHandler($handler);
            //
            // View column for fe_horas field
            //
            $column = new TextViewColumn('fe_horas', 'Horas Ejecución', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_tarea_planGrid_fe_horas_handler_view', $column);
            GetApplication()->RegisterHTTPHandler($handler);
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Descripción', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_tarea_planGrid_ds_referencia_handler_view', $column);
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
        $Page = new public_sga_tarea_planPage("tarea_plan.php", "public_sga_tarea_plan", GetCurrentUserGrantForDataSource("public.sga_tarea_plan"), 'UTF-8');
        $Page->SetShortCaption('Tarea Planificada');
        $Page->SetHeader(GetPagesHeader());
        $Page->SetFooter(GetPagesFooter());
        $Page->SetCaption('Tarea Planificada');
        $Page->SetRecordPermission(GetCurrentUserRecordPermissionsForDataSource("public.sga_tarea_plan"));
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
	
?>
<script>
document.getElementById("id_accion_edit").addEventListener("change", function(){
    //alert(this.value);

	var datos = {
		"id_accion": this.value
	};

	$.ajax({
		data: datos,
		url: 'ax_option_espacio.php',
		type: 'post',
		success: function(respuesta) {
			$("#id_espacio_edit").html(respuesta);
		}
	});
	$.ajax({
		data: datos,
		url: 'ax_option_bien.php',
		type: 'post',
		success: function(respuesta) {
			$("#id_bien_edit").html(respuesta);
		}
	});
	$.ajax({
		data: datos,
		url: 'ax_default_horas.php',
		type: 'post',
		success: function(respuesta) {
			if ($("#auxHoras").length > 0){
				$( "#auxHoras" ).html(respuesta);
			} else {
				$( "#s2id_fe_horas_edit" ).before('<div id="auxHoras">' + respuesta + '</div>');
			}
		}
	});
	$.ajax({
		data: datos,
		url: 'ax_default_personas.php',
		type: 'post',
		success: function(respuesta) {
			if(respuesta) {
				$("#nu_personas_edit")[0].value = respuesta;
			}
		}
	});
	$.ajax({
		data: datos,
		url: 'ax_default_carga_horaria.php',
		type: 'post',
		success: function(respuesta) {
			if(respuesta) {
				$("#tm_carga_horaria_edit")[0].value = respuesta;
			}
		}
	});
	$.ajax({
		data: datos,
		url: 'ax_default_periodicidad.php',
		type: 'post',
		success: function(respuesta) {
			if(respuesta) {
				//document.getElementById("id_periodicidad_edit").value = respuesta;
				$("#id_periodicidad_edit")[0].value = respuesta;
			}
		}
	});
});
</script>