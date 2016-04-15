<?php ob_start(); ?>
    <div class="page-header">
        <h1>
            <?php echo $this->_tpl_vars['Page']->GetCaption(); ?>

        </h1>
        <?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "export-button.tpl", 'smarty_include_vars' => array('Items' => $this->_tpl_vars['Page']->GetExportButtonsViewData())));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
    </div>

    <?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "page_description_block.tpl", 'smarty_include_vars' => array('Description' => $this->_tpl_vars['Page']->GetGridHeader())));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

    <?php echo $this->_tpl_vars['PageNavigator']; ?>


    <?php echo $this->_tpl_vars['Grid']; ?>


    <?php echo $this->_tpl_vars['PageNavigator2']; ?>

<?php $this->_smarty_vars['capture']['default'] = ob_get_contents();  $this->assign('ContentBlock', ob_get_contents());ob_end_clean(); ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/list_page_template.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>