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
            $field->SetIsNotNull(true);
            $this->dataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('id_tipo_accion');
            $this->dataset->AddField($field, false);
            $this->dataset->AddLookupField('id_tipo_accion', 'public.sga_tipo_accion', new IntegerField('id_tipo_accion', null, null, true), new StringField('ds_referencia', 'id_tipo_accion_ds_referencia', 'id_tipo_accion_ds_referencia_public_sga_tipo_accion'), 'id_tipo_accion_ds_referencia_public_sga_tipo_accion');
            $this->dataset->AddLookupField('id_tipo_espacio', 'public.sga_tipo_espacio', new IntegerField('id_tipo_espacio', null, null, true), new StringField('ds_referencia', 'id_tipo_espacio_ds_referencia', 'id_tipo_espacio_ds_referencia_public_sga_tipo_espacio'), 'id_tipo_espacio_ds_referencia_public_sga_tipo_espacio');
            $this->dataset->AddLookupField('id_tipo_bien', 'public.sga_tipo_bien', new IntegerField('id_tipo_bien', null, null, true), new StringField('ds_referencia', 'id_tipo_bien_ds_referencia', 'id_tipo_bien_ds_referencia_public_sga_tipo_bien'), 'id_tipo_bien_ds_referencia_public_sga_tipo_bien');
            $this->dataset->AddLookupField('id_origen', 'public.sga_origen', new IntegerField('id_origen', null, null, true), new StringField('no_origen', 'id_origen_no_origen', 'id_origen_no_origen_public_sga_origen'), 'id_origen_no_origen_public_sga_origen');
            $this->dataset->AddLookupField('id_metodologia', 'public.sga_metodologia', new IntegerField('id_metodologia', null, null, true), new StringField('no_metodologia', 'id_metodologia_no_metodologia', 'id_metodologia_no_metodologia_public_sga_metodologia'), 'id_metodologia_no_metodologia_public_sga_metodologia');
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
                array('id_accion', 'id_tipo_accion_ds_referencia', 'id_tipo_espacio_ds_referencia', 'id_tipo_bien_ds_referencia', 'id_origen_no_origen', 'id_metodologia_no_metodologia', 'id_periodicidad_no_periodicidad', 'fl_a_demanda', 'ds_referencia'),
                array($this->RenderText('Id Accion'), $this->RenderText('Tipo Accion'), $this->RenderText('Tipo Espacio'), $this->RenderText('Tipo Bien'), $this->RenderText('Origen'), $this->RenderText('Metodología'), $this->RenderText('Periodicidad'), $this->RenderText('A Demanda'), $this->RenderText('Descripción Referencia')),
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
                '"public"."sga_tipo_bien"');
            $field = new IntegerField('id_tipo_bien', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_tipo_bien');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_bien_padre');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('id_tipo_bien', $this->RenderText('Tipo Bien'), $lookupDataset, 'id_tipo_bien', 'ds_referencia', false, 8));
            
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
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('ds_referencia', $this->RenderText('Descripción Referencia')));
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
            // View column for id_accion field
            //
            $column = new TextViewColumn('id_accion', 'Id Accion', $this->dataset);
            $column->SetOrderable(true);
            $column->SetDescription($this->RenderText('Identificador único de la acción.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
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
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_bien_ds_referencia', 'Tipo Bien', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_bien.php?operation=view&pk0=%id_tipo_bien%' , '_self');
            $column->SetDescription($this->RenderText('Tipo de bien sobre el que se ejecuta la acción.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for no_origen field
            //
            $column = new TextViewColumn('id_origen_no_origen', 'Origen', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'origen.php?operation=view&pk0=%id_origen%' , '_self');
            $column->SetDescription($this->RenderText('Origen de la acción.'));
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
            // View column for fl_a_demanda field
            //
            $column = new TextViewColumn('fl_a_demanda', 'A Demanda', $this->dataset);
            $column->SetOrderable(true);
            $column = new CheckBoxFormatValueViewColumnDecorator($column);
            $column->SetDisplayValues($this->RenderText('<img src="images/checked.png" alt="true">'), $this->RenderText(''));
            $column->SetDescription($this->RenderText('Indicador de si la actividad puede ser realizada a demanda.'));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Descripción Referencia', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('public_sga_accionGrid_ds_referencia_handler_list');
            $column->SetDescription($this->RenderText('Referencia del registro.'));
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
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_bien_ds_referencia', 'Tipo Bien', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_bien.php?operation=view&pk0=%id_tipo_bien%' , '_self');
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
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Descripción Referencia', $this->dataset);
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
            // Edit column for id_tipo_bien field
            //
            $editor = new ComboBox('id_tipo_bien_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_tipo_bien"');
            $field = new IntegerField('id_tipo_bien', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_tipo_bien');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_bien_padre');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Tipo Bien', 
                'id_tipo_bien', 
                $editor, 
                $this->dataset, 'id_tipo_bien', 'ds_referencia', $lookupDataset);
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
            // Edit column for id_tipo_bien field
            //
            $editor = new ComboBox('id_tipo_bien_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new PgConnectionFactory(),
                GetConnectionOptions(),
                '"public"."sga_tipo_bien"');
            $field = new IntegerField('id_tipo_bien', null, null, true);
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('no_tipo_bien');
            $field->SetIsNotNull(true);
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('id_tipo_bien_padre');
            $lookupDataset->AddField($field, false);
            $field = new StringField('ds_referencia');
            $lookupDataset->AddField($field, false);
            $lookupDataset->setOrderByField('ds_referencia', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'Tipo Bien', 
                'id_tipo_bien', 
                $editor, 
                $this->dataset, 'id_tipo_bien', 'ds_referencia', $lookupDataset);
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
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_bien_ds_referencia', 'Tipo Bien', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_bien.php?operation=view&pk0=%id_tipo_bien%' , '_self');
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
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('id_tipo_bien_ds_referencia', 'Tipo Bien', $this->dataset);
            $column->SetOrderable(true);
            $column = new ExtendedHyperLinkColumnDecorator($column, $this->dataset, 'tipo_bien.php?operation=view&pk0=%id_tipo_bien%' , '_self');
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
    
            $this->AddFieldColumns($result);
            $this->AddSingleRecordViewColumns($result);
            $this->AddEditColumns($result);
            $this->AddInsertColumns($result);
            $this->AddPrintColumns($result);
            $this->AddExportColumns($result);
            $this->AddOperationsColumns($result);
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
            $this->SetShowTopPageNavigator(false);
            $this->SetShowBottomPageNavigator(false);
    
            //
            // Http Handlers
            //
            //
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Descripción Referencia', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'public_sga_accionGrid_ds_referencia_handler_list', $column);
            GetApplication()->RegisterHTTPHandler($handler);//
            // View column for ds_referencia field
            //
            $column = new TextViewColumn('ds_referencia', 'Descripción Referencia', $this->dataset);
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
	
