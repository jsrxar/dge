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
            $this->dataset->AddLookupField('id_accion', 'public.sga_accion', new IntegerField('id_accion', null, null, true), new StringField('ds_referencia', 'id_accion_ds_referencia', 'id_accion_ds_referencia_public_sga_accion'), 'id_accion_ds_referencia_public_sga_accion');
            $this->dataset->AddLookupField('id_espacio', 'public.sga_espacio', new IntegerField('id_espacio', null, null, true), new StringField('ds_referencia', 'id_espacio_ds_referencia', 'id_espacio_ds_referencia_public_sga_espacio'), 'id_espacio_ds_referencia_public_sga_espacio');
            $this->dataset->AddLookupField('id_bien', 'public.sga_bien', new IntegerField('id_bien', null, null, true), new StringField('ds_observacion', 'id_bien_ds_observacion', 'id_bien_ds_observacion_public_sga_bien'), 'id_bien_ds_observacion_public_sga_bien');
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
            if (GetCurrentUserGrantForDataSource('public.sga_bien')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Bien'), 'bien.php', $this->RenderText('Bien'), $currentPageCaption == $this->RenderText('Bien'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.sga_metodologia')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Metodologia de Acción'), 'metodologia.php', $this->RenderText('Metodologia'), $currentPageCaption == $this->RenderText('Metodologia de Acción'), false, $this->RenderText('Paramétricas')));
            if (GetCurrentUserGrantForDataSource('public.sga_tipo_accion')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Accion'), 'tipo_accion.php', $this->RenderText('Tipo Accion'), $currentPageCaption == $this->RenderText('Tipo Accion'), false, $this->RenderText('Paramétricas')));
            if (GetCurrentUserGrantForDataSource('public.sga_tipo_bien')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Bien'), 'tipo_bien.php', $this->RenderText('Tipo Bien'), $currentPageCaption == $this->RenderText('Tipo Bien'), false, $this->RenderText('Paramétricas')));
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
                array('id_tarea_plan', 'id_accion_ds_referencia', 'id_espacio_ds_referencia', 'id_bien_ds_observacion', 'id_periodicidad_no_periodicidad', 'ds_detalle', 'ds_referencia', 'fe_inicio'),
                array($this->RenderText('Id Tarea Plan'), $this->RenderText('Acción'), $this->RenderText('Espacio'), $this->RenderText('Bien'), $this->RenderText('Periodicidad'), $this->RenderText('Detalle'), $this->RenderText('Descripción'), $this->RenderText('Fecha Início')),
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
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_sector');
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
                '"public"."sga_bien"');
            $field = new IntegerField('id_bien', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_bien');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_observacion');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('nu_cantidad');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_observacion', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_bien', $this->RenderText('Bien'), $lookupDataset, 'id_bien', 'ds_observacion', false, 8));
            
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
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('ds_referencia', $this->RenderText('Descripción')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateDateTimeSearchInput('fe_inicio', $this->RenderText('Fecha Início'), 'd/m/Y H:i:s'));
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
            // View column for ds_observacion field
            //
            $column = new TextViewColumn('id_bien_ds_observacion', 'Bien', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'bien.php?operation=view&pk0=%id_bien%' , '_self');
            $column->SetDescription($this->RenderText('Bien asociado a la tarea planificada.'));
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
            // View column for ds_observacion field
            //
            $column = new TextViewColumn('id_bien_ds_observacion', 'Bien', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'bien.php?operation=view&pk0=%id_bien%' , '_self');
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
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Descripción', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_tarea_planGrid_ds_referencia_handler_view');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for fe_inicio field
            //
            $column = new DateTimeViewColumn('fe_inicio', 'Fecha Início', $this->dataset);
            $column->SetDateTimeFormat('d/m/Y H:i:s');
            $column->SetOrderable(true);
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
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_sector');
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
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_bien field
            //
            $editor = new ComboBox('id_bien_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_bien"');
            $field = new IntegerField('id_bien', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_bien');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_observacion');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('nu_cantidad');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_observacion', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Bien', 
                'id_bien', 
                $editor, 
                $this->dataset, 'id_bien', 'ds_observacion', $lookupDataset);
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
        }
    
        protected function AddInsertColumns(Grid $grid)
        {
            //
            // Edit column for id_accion field
            //
            $editor = new ComboBox('id_accion_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
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
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_sector');
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
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for id_bien field
            //
            $editor = new ComboBox('id_bien_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_bien"');
            $field = new IntegerField('id_bien', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_bien');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_espacio');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_observacion');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('nu_cantidad');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_observacion', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Bien', 
                'id_bien', 
                $editor, 
                $this->dataset, 'id_bien', 'ds_observacion', $lookupDataset);
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
            // View column for ds_observacion field
            //
            $column = new TextViewColumn('id_bien_ds_observacion', 'Bien', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'bien.php?operation=view&pk0=%id_bien%' , '_self');
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
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Ds Referencia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for fe_inicio field
            //
            $column = new DateTimeViewColumn('fe_inicio', 'Fecha Início', $this->dataset);
            $column->SetDateTimeFormat('d/m/Y H:i:s');
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
            // View column for ds_observacion field
            //
            $column = new TextViewColumn('id_bien_ds_observacion', 'Bien', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'bien.php?operation=view&pk0=%id_bien%' , '_self');
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
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Ds Referencia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for fe_inicio field
            //
            $column = new DateTimeViewColumn('fe_inicio', 'Fecha Início', $this->dataset);
            $column->SetDateTimeFormat('d/m/Y H:i:s');
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
            GetApplication()->RegisterHTTPHandler($handler);//
            // View column for ds_detalle field
            //
            $column = new TextViewColumn('ds_detalle', 'Detalle', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_tarea_planGrid_ds_detalle_handler_view', $column);
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