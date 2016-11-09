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
    
    
    
    class ver_honorario_nuevoPage extends Page
    {
        protected function DoBeforeCreate()
        {
            $selectQuery = 'SELECT
                  id_honorario,
                  id_contrato,
                  (SELECT no_tipo_honorario
                   FROM facturas.tipo_honorario
                   WHERE id_tipo_honorario = sa.id_tipo_honorario) ||
                  \' (\' || CAST(CAST(CONVERT_FROM(DECRYPT(sa.va_honorario,CAST(RPAD(\'F4ct#r4s@2016\', 24, \'*\') AS BYTEA),\'AES\'),\'SQL_ASCII\') AS TEXT) AS MONEY) ||\')\' AS ds_honorario
            FROM facturas.honorario sa
            WHERE NOT EXISTS ( SELECT 1 FROM facturas.factura WHERE id_honorario = sa.id_honorario )
            ORDER BY ds_honorario';
            $insertQuery = array();
            $updateQuery = array();
            $deleteQuery = array();
            $this->dataset = new QueryDataset(
              new PgConnectionFactory(), 
              GetConnectionOptions(),
              $selectQuery, $insertQuery, $updateQuery, $deleteQuery, 'ver_honorario_nuevo');
            $field = new IntegerField('id_honorario');
            $this->dataset->AddField($field, true);
            $field = new IntegerField('id_contrato');
            $this->dataset->AddField($field, false);
            $field = new StringField('ds_honorario');
            $this->dataset->AddField($field, false);
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
            $result->AddGroup($this->RenderText('Facturas'));
            $result->AddGroup($this->RenderText('Contratos de Agentes'));
            $result->AddGroup($this->RenderText('Administrador'));
            if (GetCurrentUserGrantForDataSource('facturas.factura')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Factura'), 'factura.php', $this->RenderText('Factura'), $currentPageCaption == $this->RenderText('Factura'), false, $this->RenderText('Facturas')));
            if (GetCurrentUserGrantForDataSource('facturas.certificacion')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Lote Certificación'), 'certificacion.php', $this->RenderText('Lote Certificación'), $currentPageCaption == $this->RenderText('Lote Certificación'), true, $this->RenderText('Facturas')));
            if (GetCurrentUserGrantForDataSource('facturas.agente')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Agente'), 'agente.php', $this->RenderText('Agente'), $currentPageCaption == $this->RenderText('Agente'), false, $this->RenderText('Contratos de Agentes')));
            if (GetCurrentUserGrantForDataSource('facturas.dependencia')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Dependencia'), 'dependencia.php', $this->RenderText('Dependencia'), $currentPageCaption == $this->RenderText('Dependencia'), true, $this->RenderText('Contratos de Agentes')));
            if (GetCurrentUserGrantForDataSource('facturas.ubicacion_fisica')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Ubicacion Fisica'), 'ubicacion_fisica.php', $this->RenderText('Ubicacion Fisica'), $currentPageCaption == $this->RenderText('Ubicacion Fisica'), false, $this->RenderText('Contratos de Agentes')));
            if (GetCurrentUserGrantForDataSource('facturas.puesto')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Puesto'), 'puesto.php', $this->RenderText('Puesto'), $currentPageCaption == $this->RenderText('Puesto'), false, $this->RenderText('Contratos de Agentes')));
            if (GetCurrentUserGrantForDataSource('facturas.convenio_at')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Convenio AT'), 'convenio_at.php', $this->RenderText('Convenio Asistencia Tecnica'), $currentPageCaption == $this->RenderText('Convenio AT'), false, $this->RenderText('Contratos de Agentes')));
            if (GetCurrentUserGrantForDataSource('facturas.tipo_contrato')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Contrato'), 'tipo_contrato.php', $this->RenderText('Tipo Contrato'), $currentPageCaption == $this->RenderText('Tipo Contrato'), true, $this->RenderText('Contratos de Agentes')));
            if (GetCurrentUserGrantForDataSource('facturas.contrato')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Contrato'), 'contrato.php', $this->RenderText('Contrato'), $currentPageCaption == $this->RenderText('Contrato'), false, $this->RenderText('Contratos de Agentes')));
            if (GetCurrentUserGrantForDataSource('facturas.tipo_honorario')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Tipo Honorario'), 'tipo_honorario.php', $this->RenderText('Tipo Honorario'), $currentPageCaption == $this->RenderText('Tipo Honorario'), false, $this->RenderText('Contratos de Agentes')));
            if (GetCurrentUserGrantForDataSource('facturas.honorario')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Honorario'), 'honorario.php', $this->RenderText('Honorario'), $currentPageCaption == $this->RenderText('Honorario'), false, $this->RenderText('Contratos de Agentes')));
            if (GetCurrentUserGrantForDataSource('facturas.categoria_lm')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Categoria LM'), 'categoria_lm.php', $this->RenderText('Categoria Ley Marco'), $currentPageCaption == $this->RenderText('Categoria LM'), false, $this->RenderText('Contratos de Agentes')));
            if (GetCurrentUserGrantForDataSource('audit.logged_actions')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Auditoría'), 'auditoria.php', $this->RenderText('Auditoría'), $currentPageCaption == $this->RenderText('Auditoría'), false, $this->RenderText('Administrador')));
            if (GetCurrentUserGrantForDataSource('estado_lote')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Estado Lote'), 'estado_lote.php', $this->RenderText('Estado Lote'), $currentPageCaption == $this->RenderText('Estado Lote'), false, $this->RenderText('Administrador')));
            if (GetCurrentUserGrantForDataSource('ver_tipo_honorario')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Ver Tipo Honorario'), 'ver_tipo_honorario.php', $this->RenderText('Ver Tipo Honorario'), $currentPageCaption == $this->RenderText('Ver Tipo Honorario'), false, $this->RenderText('Administrador')));
            if (GetCurrentUserGrantForDataSource('ver_contrato_factura')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Ver Contrato Factura'), 'ver_contrato_factura.php', $this->RenderText('Ver Contrato Factura'), $currentPageCaption == $this->RenderText('Ver Contrato Factura'), false, $this->RenderText('Administrador')));
            if (GetCurrentUserGrantForDataSource('ver_dependencia')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Ver Dependencia'), 'ver_dependencia.php', $this->RenderText('Ver Dependencia'), $currentPageCaption == $this->RenderText('Ver Dependencia'), false, $this->RenderText('Administrador')));
            if (GetCurrentUserGrantForDataSource('ver_honorario')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Ver Honorario'), 'ver_honorario.php', $this->RenderText('Ver Honorario'), $currentPageCaption == $this->RenderText('Ver Honorario'), false, $this->RenderText('Administrador')));
            if (GetCurrentUserGrantForDataSource('ver_lote_cert')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Ver Lote Cert'), 'ver_lote_cert.php', $this->RenderText('Ver Lote Cert'), $currentPageCaption == $this->RenderText('Ver Lote Cert'), false, $this->RenderText('Administrador')));
            if (GetCurrentUserGrantForDataSource('ver_tipo')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Ver Categ Honorario'), 'ver_categ_honorario.php', $this->RenderText('Ver Categ Honorario'), $currentPageCaption == $this->RenderText('Ver Categ Honorario'), false, $this->RenderText('Administrador')));
            if (GetCurrentUserGrantForDataSource('ver_contrato')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Ver Contrato'), 'ver_contrato.php', $this->RenderText('Ver Contrato'), $currentPageCaption == $this->RenderText('Ver Contrato'), false, $this->RenderText('Administrador')));
            if (GetCurrentUserGrantForDataSource('ver_honorario_nuevo')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Ver Honorario Nuevo'), 'ver_honorario_nuevo.php', $this->RenderText('Ver Honorario Nuevo'), $currentPageCaption == $this->RenderText('Ver Honorario Nuevo'), false, $this->RenderText('Default')));
            
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
            $grid->SearchControl = new SimpleSearch('ver_honorario_nuevossearch', $this->dataset,
                array('id_honorario', 'id_contrato', 'ds_honorario'),
                array($this->RenderText('Id Honorario'), $this->RenderText('Id Contrato'), $this->RenderText('Ds Honorario')),
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
            $this->AdvancedSearchControl = new AdvancedSearchControl('ver_honorario_nuevoasearch', $this->dataset, $this->GetLocalizerCaptions(), $this->GetColumnVariableContainer(), $this->CreateLinkBuilder());
            $this->AdvancedSearchControl->setTimerInterval(1000);
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('id_honorario', $this->RenderText('Id Honorario')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('id_contrato', $this->RenderText('Id Contrato')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('ds_honorario', $this->RenderText('Ds Honorario')));
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
        }
    
        protected function AddFieldColumns(Grid $grid)
        {
            //
            // View column for id_honorario field
            //
            $column = new TextViewColumn('id_honorario', 'Id Honorario', $this->dataset);
            $column->SetOrderable(true);
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for id_contrato field
            //
            $column = new TextViewColumn('id_contrato', 'Id Contrato', $this->dataset);
            $column->SetOrderable(true);
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for ds_honorario field
            //
            $column = new TextViewColumn('ds_honorario', 'Ds Honorario', $this->dataset);
            $column->SetOrderable(true);
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
        }
    
        protected function AddSingleRecordViewColumns(Grid $grid)
        {
            //
            // View column for id_honorario field
            //
            $column = new TextViewColumn('id_honorario', 'Id Honorario', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for id_contrato field
            //
            $column = new TextViewColumn('id_contrato', 'Id Contrato', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for ds_honorario field
            //
            $column = new TextViewColumn('ds_honorario', 'Ds Honorario', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
        }
    
        protected function AddEditColumns(Grid $grid)
        {
            //
            // Edit column for id_honorario field
            //
            $editor = new SpinEdit('id_honorario_edit');
            $editColumn = new CustomEditColumn('Id Honorario', 'id_honorario', $editor, $this->dataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for id_contrato field
            //
            $editor = new SpinEdit('id_contrato_edit');
            $editColumn = new CustomEditColumn('Id Contrato', 'id_contrato', $editor, $this->dataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for ds_honorario field
            //
            $editor = new TextEdit('ds_honorario_edit');
            $editColumn = new CustomEditColumn('Ds Honorario', 'ds_honorario', $editor, $this->dataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
        }
    
        protected function AddInsertColumns(Grid $grid)
        {
            //
            // Edit column for id_honorario field
            //
            $editor = new SpinEdit('id_honorario_edit');
            $editColumn = new CustomEditColumn('Id Honorario', 'id_honorario', $editor, $this->dataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for id_contrato field
            //
            $editor = new SpinEdit('id_contrato_edit');
            $editColumn = new CustomEditColumn('Id Contrato', 'id_contrato', $editor, $this->dataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for ds_honorario field
            //
            $editor = new TextEdit('ds_honorario_edit');
            $editColumn = new CustomEditColumn('Ds Honorario', 'ds_honorario', $editor, $this->dataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            if ($this->GetSecurityInfo()->HasAddGrant())
            {
                $grid->SetShowAddButton(false);
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
            // View column for id_honorario field
            //
            $column = new TextViewColumn('id_honorario', 'Id Honorario', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for id_contrato field
            //
            $column = new TextViewColumn('id_contrato', 'Id Contrato', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for ds_honorario field
            //
            $column = new TextViewColumn('ds_honorario', 'Ds Honorario', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
        }
    
        protected function AddExportColumns(Grid $grid)
        {
            //
            // View column for id_honorario field
            //
            $column = new TextViewColumn('id_honorario', 'Id Honorario', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for id_contrato field
            //
            $column = new TextViewColumn('id_contrato', 'Id Contrato', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for ds_honorario field
            //
            $column = new TextViewColumn('ds_honorario', 'Ds Honorario', $this->dataset);
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
        public function GetModalGridViewHandler() { return 'ver_honorario_nuevo_inline_record_view'; }
        protected function GetEnableModalSingleRecordView() { return true; }
    
        protected function CreateGrid()
        {
            $result = new Grid($this, $this->dataset, 'ver_honorario_nuevoGrid');
            if ($this->GetSecurityInfo()->HasDeleteGrant())
               $result->SetAllowDeleteSelected(false);
            else
               $result->SetAllowDeleteSelected(false);   
            
            ApplyCommonPageSettings($this, $result);
            
            $result->SetUseImagesForActions(false);
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
            $this->SetExportToExcelAvailable(false);
            $this->SetExportToWordAvailable(false);
            $this->SetExportToXmlAvailable(false);
            $this->SetExportToCsvAvailable(false);
            $this->SetExportToPdfAvailable(false);
            $this->SetPrinterFriendlyAvailable(false);
            $this->SetSimpleSearchAvailable(true);
            $this->SetAdvancedSearchAvailable(false);
            $this->SetFilterRowAvailable(false);
            $this->SetVisualEffectsEnabled(false);
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
        $Page = new ver_honorario_nuevoPage("ver_honorario_nuevo.php", "ver_honorario_nuevo", GetCurrentUserGrantForDataSource("ver_honorario_nuevo"), 'UTF-8');
        $Page->SetShortCaption('Ver Honorario Nuevo');
        $Page->SetHeader(GetPagesHeader());
        $Page->SetFooter(GetPagesFooter());
        $Page->SetCaption('Ver Honorario Nuevo');
        $Page->SetRecordPermission(GetCurrentUserRecordPermissionsForDataSource("ver_honorario_nuevo"));
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
	
