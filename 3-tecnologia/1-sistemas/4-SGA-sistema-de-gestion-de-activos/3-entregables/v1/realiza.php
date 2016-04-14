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
    
    
    
    class public_ods_realizaPage extends Page
    {
        protected function DoBeforeCreate()
        {
            $this->dataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."ods_realiza"');
            $field = new IntegerField('id_persona');
            $field->SetIsNotNull(true);
            $this->dataset->AddField($field, true);
            $field = new IntegerField('id_tarea');
            $field->SetIsNotNull(true);
            $this->dataset->AddField($field, true);
            $this->dataset->AddLookupField('id_persona', 'public.ods_persona', new IntegerField('id_persona', null, null, true), new IntegerField('id_tipo_persona', 'id_persona_id_tipo_persona', 'id_persona_id_tipo_persona_public_ods_persona'), 'id_persona_id_tipo_persona_public_ods_persona');
            $this->dataset->AddLookupField('id_tarea', 'public.ods_tarea', new IntegerField('id_tarea', null, null, true), new IntegerField('id_tarea_plan', 'id_tarea_id_tarea_plan', 'id_tarea_id_tarea_plan_public_ods_tarea'), 'id_tarea_id_tarea_plan_public_ods_tarea');
        }
    
        protected function DoPrepare() {
    
        }
    
        protected function CreatePageNavigator()
        {
            $result = new CompositePageNavigator($this);
            
            $partitionNavigator = new PageNavigator('pnav', $this, $this->dataset);
            $partitionNavigator->SetRowsPerPage(100);
            $result->AddPageNavigator($partitionNavigator);
            
            return $result;
        }
    
        public function GetPageList()
        {
            $currentPageCaption = $this->GetShortCaption();
            $result = new PageList($this);
            $result->AddGroup($this->RenderText('Maestras'));
            $result->AddGroup($this->RenderText('Relaciones'));
            $result->AddGroup($this->RenderText('Param�tricas'));
            $result->AddGroup($this->RenderText('Transacciones'));
            if (GetCurrentUserGrantForDataSource('public.ods_area')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Area'), 'area.php', $this->RenderText('Area'), $currentPageCaption == $this->RenderText('Area'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.ods_bien')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Bien'), 'bien.php', $this->RenderText('Bien'), $currentPageCaption == $this->RenderText('Bien'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.ods_empresa')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Empresa'), 'empresa.php', $this->RenderText('Empresa'), $currentPageCaption == $this->RenderText('Empresa'), false, $this->RenderText('Param�tricas')));
            if (GetCurrentUserGrantForDataSource('public.ods_espacio')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Espacio'), 'espacio.php', $this->RenderText('Espacio'), $currentPageCaption == $this->RenderText('Espacio'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.ods_insumo')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Insumo'), 'insumo.php', $this->RenderText('Insumo'), $currentPageCaption == $this->RenderText('Insumo'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.ods_lectura')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Lectura'), 'lectura.php', $this->RenderText('Lectura'), $currentPageCaption == $this->RenderText('Lectura'), false, $this->RenderText('Transacciones')));
            if (GetCurrentUserGrantForDataSource('public.ods_lugar')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Lugar'), 'lugar.php', $this->RenderText('Lugar'), $currentPageCaption == $this->RenderText('Lugar'), false, $this->RenderText('Param�tricas')));
            if (GetCurrentUserGrantForDataSource('public.ods_ocupa')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Ocupa (Area / Espacio)'), 'ocupa.php', $this->RenderText('Ocupa'), $currentPageCaption == $this->RenderText('Ocupa (Area / Espacio)'), false, $this->RenderText('Relaciones')));
            if (GetCurrentUserGrantForDataSource('public.ods_origen_lectura')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Origen Lectura'), 'origen_lectura.php', $this->RenderText('Origen Lectura'), $currentPageCaption == $this->RenderText('Origen Lectura'), false, $this->RenderText('Param�tricas')));
            if (GetCurrentUserGrantForDataSource('public.ods_origen')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Origen'), 'origen.php', $this->RenderText('Origen'), $currentPageCaption == $this->RenderText('Origen'), false, $this->RenderText('Param�tricas')));
            if (GetCurrentUserGrantForDataSource('public.ods_periodicidad')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Periodicidad'), 'periodicidad.php', $this->RenderText('Periodicidad'), $currentPageCaption == $this->RenderText('Periodicidad'), false, $this->RenderText('Param�tricas')));
            if (GetCurrentUserGrantForDataSource('public.ods_persona')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Persona'), 'persona.php', $this->RenderText('Persona'), $currentPageCaption == $this->RenderText('Persona'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.ods_realiza')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Realiza (Persona / Tarea)'), 'realiza.php', $this->RenderText('Realiza'), $currentPageCaption == $this->RenderText('Realiza (Persona / Tarea)'), false, $this->RenderText('Relaciones')));
            if (GetCurrentUserGrantForDataSource('public.ods_requiere')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Requiere (Actividad / Insumo)'), 'requiere.php', $this->RenderText('Requiere'), $currentPageCaption == $this->RenderText('Requiere (Actividad / Insumo)'), false, $this->RenderText('Relaciones')));
            if (GetCurrentUserGrantForDataSource('public.ods_tarea')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tarea'), 'tarea.php', $this->RenderText('Tarea'), $currentPageCaption == $this->RenderText('Tarea'), false, $this->RenderText('Transacciones')));
            if (GetCurrentUserGrantForDataSource('public.ods_tarea_plan')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tarea Planificada'), 'tarea_plan.php', $this->RenderText('Tarea Planificada'), $currentPageCaption == $this->RenderText('Tarea Planificada'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.ods_tipo_bien')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Bien'), 'tipo_bien.php', $this->RenderText('Tipo Bien'), $currentPageCaption == $this->RenderText('Tipo Bien'), false, $this->RenderText('Param�tricas')));
            if (GetCurrentUserGrantForDataSource('public.ods_tipo_espacio')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Espacio'), 'tipo_espacio.php', $this->RenderText('Tipo Espacio'), $currentPageCaption == $this->RenderText('Tipo Espacio'), false, $this->RenderText('Param�tricas')));
            if (GetCurrentUserGrantForDataSource('public.ods_tipo_insumo')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Insumo'), 'tipo_insumo.php', $this->RenderText('Tipo Insumo'), $currentPageCaption == $this->RenderText('Tipo Insumo'), false, $this->RenderText('Param�tricas')));
            if (GetCurrentUserGrantForDataSource('public.ods_tipo_persona')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Persona'), 'tipo_persona.php', $this->RenderText('Tipo Persona'), $currentPageCaption == $this->RenderText('Tipo Persona'), false, $this->RenderText('Param�tricas')));
            if (GetCurrentUserGrantForDataSource('public.ods_accion')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Accion (Espacio / Tarea)'), 'accion.php', $this->RenderText('Accion'), $currentPageCaption == $this->RenderText('Accion (Espacio / Tarea)'), false, $this->RenderText('Maestras')));
            if (GetCurrentUserGrantForDataSource('public.ods_metodologia')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Metodologia de Acci�n'), 'metodologia.php', $this->RenderText('Metodologia'), $currentPageCaption == $this->RenderText('Metodologia de Acci�n'), false, $this->RenderText('Param�tricas')));
            if (GetCurrentUserGrantForDataSource('public.ods_tipo_accion')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Accion'), 'tipo_accion.php', $this->RenderText('Tipo Accion'), $currentPageCaption == $this->RenderText('Tipo Accion'), false, $this->RenderText('Param�tricas')));
            
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
            $grid->SearchControl = new SimpleSearch('public_ods_realizassearch', $this->dataset,
                array('id_persona_id_tipo_persona', 'id_tarea_id_tarea_plan'),
                array($this->RenderText('Id Persona'), $this->RenderText('Id Tarea')),
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
            $this->AdvancedSearchControl = new AdvancedSearchControl('public_ods_realizaasearch', $this->dataset, $this->GetLocalizerCaptions(), $this->GetColumnVariableContainer(), $this->CreateLinkBuilder());
            $this->AdvancedSearchControl->setTimerInterval(1000);
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."ods_persona"');
            $field = new IntegerField('id_persona', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_persona');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_dni_cuit');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_legajo');
            $lookupDataset->AddField($field, false);
            $field = new StringField('no_persona');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_empresa');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_area');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('id_tipo_persona', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_persona', $this->RenderText('Id Persona'), $lookupDataset, 'id_persona', 'id_tipo_persona', false, 8));
            
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."ods_tarea"');
            $field = new IntegerField('id_tarea', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tarea_plan');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new DateTimeField('fe_ejecucion');
            $lookupDataset->AddField($field, false);
            $field = new BooleanField('fl_realizada');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_observaciones');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('id_tarea_plan', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_tarea', $this->RenderText('Id Tarea'), $lookupDataset, 'id_tarea', 'id_tarea_plan', false, 8));
        }
    
        protected function AddOperationsColumns(Grid $grid)
        {
            $actionsBandName = 'actions';
            $grid->AddBandToBegin($actionsBandName, $this->GetLocalizerCaptions()->GetMessageString('Actions'), true);
            if ($this->GetSecurityInfo()->HasViewGrant())
            {
                $column = new RowOperationByLinkColumn($this->GetLocalizerCaptions()->GetMessageString('View'), OPERATION_VIEW, $this->dataset);
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
            // View column for id_tipo_persona field
            //
            $column = new TextViewColumn('id_persona_id_tipo_persona', 'Id Persona', $this->dataset);
            $column->SetOrderable(true);
            $column->SetDescription($this->RenderText('Identificador �nico de la persona.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for id_tarea_plan field
            //
            $column = new TextViewColumn('id_tarea_id_tarea_plan', 'Id Tarea', $this->dataset);
            $column->SetOrderable(true);
            $column->SetDescription($this->RenderText('Identificador �nico de la tarea.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
        }
    
        protected function AddSingleRecordViewColumns(Grid $grid)
        {
            //
            // View column for id_tipo_persona field
            //
            $column = new TextViewColumn('id_persona_id_tipo_persona', 'Id Persona', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for id_tarea_plan field
            //
            $column = new TextViewColumn('id_tarea_id_tarea_plan', 'Id Tarea', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
        }
    
        protected function AddEditColumns(Grid $grid)
        {
            //
            // Edit column for id_persona field
            //
            $editor = new ComboBox('id_persona_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."ods_persona"');
            $field = new IntegerField('id_persona', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_persona');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_dni_cuit');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_legajo');
            $lookupDataset->AddField($field, false);
            $field = new StringField('no_persona');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_empresa');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_area');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('id_tipo_persona', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Id Persona', 
                'id_persona', 
                $editor, 
                $this->dataset, 'id_persona', 'id_tipo_persona', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_tarea field
            //
            $editor = new ComboBox('id_tarea_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."ods_tarea"');
            $field = new IntegerField('id_tarea', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tarea_plan');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new DateTimeField('fe_ejecucion');
            $lookupDataset->AddField($field, false);
            $field = new BooleanField('fl_realizada');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_observaciones');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('id_tarea_plan', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Id Tarea', 
                'id_tarea', 
                $editor, 
                $this->dataset, 'id_tarea', 'id_tarea_plan', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
        }
    
        protected function AddInsertColumns(Grid $grid)
        {
            //
            // Edit column for id_persona field
            //
            $editor = new ComboBox('id_persona_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."ods_persona"');
            $field = new IntegerField('id_persona', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tipo_persona');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_dni_cuit');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new StringField('co_legajo');
            $lookupDataset->AddField($field, false);
            $field = new StringField('no_persona');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_empresa');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_area');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('id_tipo_persona', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Id Persona', 
                'id_persona', 
                $editor, 
                $this->dataset, 'id_persona', 'id_tipo_persona', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for id_tarea field
            //
            $editor = new ComboBox('id_tarea_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."ods_tarea"');
            $field = new IntegerField('id_tarea', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new IntegerField('id_tarea_plan');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new DateTimeField('fe_ejecucion');
            $lookupDataset->AddField($field, false);
            $field = new BooleanField('fl_realizada');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_observaciones');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('id_tarea_plan', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Id Tarea', 
                'id_tarea', 
                $editor, 
                $this->dataset, 'id_tarea', 'id_tarea_plan', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
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
            // View column for id_tipo_persona field
            //
            $column = new TextViewColumn('id_persona_id_tipo_persona', 'Id Persona', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for id_tarea_plan field
            //
            $column = new TextViewColumn('id_tarea_id_tarea_plan', 'Id Tarea', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
        }
    
        protected function AddExportColumns(Grid $grid)
        {
            //
            // View column for id_tipo_persona field
            //
            $column = new TextViewColumn('id_persona_id_tipo_persona', 'Id Persona', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for id_tarea_plan field
            //
            $column = new TextViewColumn('id_tarea_id_tarea_plan', 'Id Tarea', $this->dataset);
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
        
        public function GetModalGridDeleteHandler() { return 'public_ods_realiza_modal_delete'; }
        protected function GetEnableModalGridDelete() { return true; }
    
        protected function CreateGrid()
        {
            $result = new Grid($this, $this->dataset, 'public_ods_realizaGrid');
            if ($this->GetSecurityInfo()->HasDeleteGrant())
               $result->SetAllowDeleteSelected(true);
            else
               $result->SetAllowDeleteSelected(true);   
            
            ApplyCommonPageSettings($this, $result);
            
            $result->SetUseImagesForActions(true);
            $result->SetUseFixedHeader(false);
            $result->SetShowLineNumbers(false);
            $result->SetShowKeyColumnsImagesInHeader(false);
            
            $result->SetHighlightRowAtHover(true);
            $result->SetWidth('');
            $this->CreateGridSearchControl($result);
            $this->CreateGridAdvancedSearchControl($result);
            $this->AddOperationsColumns($result);
            $this->AddFieldColumns($result);
            $this->AddSingleRecordViewColumns($result);
            $this->AddEditColumns($result);
            $this->AddInsertColumns($result);
            $this->AddPrintColumns($result);
            $this->AddExportColumns($result);
    
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
        $Page = new public_ods_realizaPage("realiza.php", "public_ods_realiza", GetCurrentUserGrantForDataSource("public.ods_realiza"), 'UTF-8');
        $Page->SetShortCaption('Realiza (Persona / Tarea)');
        $Page->SetHeader(GetPagesHeader());
        $Page->SetFooter(GetPagesFooter());
        $Page->SetCaption('Realiza');
        $Page->SetRecordPermission(GetCurrentUserRecordPermissionsForDataSource("public.ods_realiza"));
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
	