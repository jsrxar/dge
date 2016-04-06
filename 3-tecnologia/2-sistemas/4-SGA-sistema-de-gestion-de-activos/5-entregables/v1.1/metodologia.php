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
    
    
    
    class public_sga_metodologiaPage extends Page
    {
        protected function DoBeforeCreate()
        {
            $this->dataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_metodologia"');
            $field = new IntegerField('id_metodologia', null, null, true);
            $field->SetIsNotNull(true);
            $this->dataset->AddField($field, true);
            $field = new StringField('no_metodologia');
            $field->SetIsNotNull(true);
            $this->dataset->AddField($field, false);
            $field = new StringField('ds_metodologia');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_origen');
            $this->dataset->AddField($field, false);
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
            $grid->SearchControl = new SimpleSearch('public_sga_metodologiassearch', $this->dataset,
                array('id_metodologia', 'no_metodologia', 'ds_metodologia', 'id_origen_no_origen'),
                array($this->RenderText('Id Metodologia'), $this->RenderText('Nombre'), $this->RenderText('Descripción Metodo'), $this->RenderText('Origen')),
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
            $this->AdvancedSearchControl = new AdvancedSearchControl('public_sga_metodologiaasearch', $this->dataset, $this->GetLocalizerCaptions(), $this->GetColumnVariableContainer(), $this->CreateLinkBuilder());
            $this->AdvancedSearchControl->setTimerInterval(1000);
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('id_metodologia', $this->RenderText('Id Metodologia')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('no_metodologia', $this->RenderText('Nombre')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('ds_metodologia', $this->RenderText('Descripción Metodo')));
            
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
            // View column for id_metodologia field
            //
            $column = new TextViewColumn('id_metodologia', 'Id Metodologia', $this->dataset);
            $column->SetOrderable(true);
            $column->SetDescription($this->RenderText('Identificador único de una metodología.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for no_metodologia field
            //
            $column = new TextViewColumn('no_metodologia', 'Nombre', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_metodologiaGrid_no_metodologia_handler_list');
            $column->SetDescription($this->RenderText('Nombre de la metodología.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for ds_metodologia field
            //
            $column = new TextViewColumn('ds_metodologia', 'Descripción Metodo', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_metodologiaGrid_ds_metodologia_handler_list');
            $column->SetDescription($this->RenderText('Descripción del metodología.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for no_origen field
            //
            $column = new TextViewColumn('id_origen_no_origen', 'Origen', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'origen.php?operation=view&pk0=%id_origen%' , '_self');
            $column->SetDescription($this->RenderText('Origen de la metodología.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
        }
    
        protected function AddSingleRecordViewColumns(Grid $grid)
        {
            //
            // View column for id_metodologia field
            //
            $column = new TextViewColumn('id_metodologia', 'Id Metodologia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for no_metodologia field
            //
            $column = new TextViewColumn('no_metodologia', 'Nombre', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_metodologiaGrid_no_metodologia_handler_view');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for ds_metodologia field
            //
            $column = new TextViewColumn('ds_metodologia', 'Descripción Metodo', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_metodologiaGrid_ds_metodologia_handler_view');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for no_origen field
            //
            $column = new TextViewColumn('id_origen_no_origen', 'Origen', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'origen.php?operation=view&pk0=%id_origen%' , '_self');
            $grid->AddSingleRecordViewColumn($column);
        }
    
        protected function AddEditColumns(Grid $grid)
        {
            //
            // Edit column for id_metodologia field
            //
            $editor = new TextEdit('id_metodologia_edit');
            $editColumn = new CustomEditColumn('Id Metodologia', 'id_metodologia', $editor, $this->dataset);
            $editColumn->SetReadOnly(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for no_metodologia field
            //
            $editor = new TextEdit('no_metodologia_edit');
            $editor->SetSize(100);
            $editor->SetMaxLength(100);
            $editColumn = new CustomEditColumn('Nombre', 'no_metodologia', $editor, $this->dataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for ds_metodologia field
            //
            $editor = new HtmlWysiwygEditor('ds_metodologia_edit');
            $editor->SetAllowColorControls(true);
            $editColumn = new CustomEditColumn('Descripción Metodo', 'ds_metodologia', $editor, $this->dataset);
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
        }
    
        protected function AddInsertColumns(Grid $grid)
        {
            //
            // Edit column for no_metodologia field
            //
            $editor = new TextEdit('no_metodologia_edit');
            $editor->SetSize(100);
            $editor->SetMaxLength(100);
            $editColumn = new CustomEditColumn('Nombre', 'no_metodologia', $editor, $this->dataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for ds_metodologia field
            //
            $editor = new HtmlWysiwygEditor('ds_metodologia_edit');
            $editor->SetAllowColorControls(true);
            $editColumn = new CustomEditColumn('Descripción Metodo', 'ds_metodologia', $editor, $this->dataset);
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
            // View column for id_metodologia field
            //
            $column = new TextViewColumn('id_metodologia', 'Id Metodologia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for no_metodologia field
            //
            $column = new TextViewColumn('no_metodologia', 'No Metodologia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for ds_metodologia field
            //
            $column = new TextViewColumn('ds_metodologia', 'Ds Metodologia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for no_origen field
            //
            $column = new TextViewColumn('id_origen_no_origen', 'Origen', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'origen.php?operation=view&pk0=%id_origen%' , '_self');
            $grid->AddPrintColumn($column);
        }
    
        protected function AddExportColumns(Grid $grid)
        {
            //
            // View column for id_metodologia field
            //
            $column = new TextViewColumn('id_metodologia', 'Id Metodologia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for no_metodologia field
            //
            $column = new TextViewColumn('no_metodologia', 'No Metodologia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for ds_metodologia field
            //
            $column = new TextViewColumn('ds_metodologia', 'Ds Metodologia', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for no_origen field
            //
            $column = new TextViewColumn('id_origen_no_origen', 'Origen', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'origen.php?operation=view&pk0=%id_origen%' , '_self');
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
        
        public function GetModalGridDeleteHandler() { return 'public_sga_metodologia_modal_delete'; }
        protected function GetEnableModalGridDelete() { return true; }
    
        protected function CreateGrid()
        {
            $result = new Grid($this, $this->dataset, 'public_sga_metodologiaGrid');
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
            // View column for no_metodologia field
            //
            $column = new TextViewColumn('no_metodologia', 'Nombre', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_metodologiaGrid_no_metodologia_handler_list', $column);
            GetApplication()->RegisterHTTPHandler($handler);
            //
            // View column for ds_metodologia field
            //
            $column = new TextViewColumn('ds_metodologia', 'Descripción Metodo', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_metodologiaGrid_ds_metodologia_handler_list', $column);
            GetApplication()->RegisterHTTPHandler($handler);//
            // View column for no_metodologia field
            //
            $column = new TextViewColumn('no_metodologia', 'Nombre', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_metodologiaGrid_no_metodologia_handler_view', $column);
            GetApplication()->RegisterHTTPHandler($handler);
            //
            // View column for ds_metodologia field
            //
            $column = new TextViewColumn('ds_metodologia', 'Descripción Metodo', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_metodologiaGrid_ds_metodologia_handler_view', $column);
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
        $Page = new public_sga_metodologiaPage("metodologia.php", "public_sga_metodologia", GetCurrentUserGrantForDataSource("public.sga_metodologia"), 'UTF-8');
        $Page->SetShortCaption('Metodologia de Acción');
        $Page->SetHeader(GetPagesHeader());
        $Page->SetFooter(GetPagesFooter());
        $Page->SetCaption('Metodologia');
        $Page->SetRecordPermission(GetCurrentUserRecordPermissionsForDataSource("public.sga_metodologia"));
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
	
