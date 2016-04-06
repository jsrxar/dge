<?php ob_start(); ?>
    <?php echo $this->_tpl_vars['App']['ClientSideEvents']['OnBeforeLoadEvent']; ?>

<?php echo '
    $(function() {
'; ?>
<?php echo $this->_tpl_vars['App']['ClientSideEvents']['OnAfterLoadEvent']; ?>
<?php echo '
    });
'; ?>

<?php $this->_smarty_vars['capture']['default'] = ob_get_contents();  $this->assign('Scripts', ob_get_contents());ob_end_clean(); ?>

<?php ob_start(); ?><?php $this->_smarty_vars['capture']['SideBar'] = ob_get_contents(); ob_end_clean(); ?>

<?php $this->assign('JavaScriptMain', "pgui.list-page-main"); ?>

<?php $this->assign('HideSideBarByDefault', $this->_tpl_vars['HideSideBarByDefault']); ?>

<?php if ($this->_tpl_vars['Page']->GetShowPageList()): ?>
    <?php ob_start(); ?>
        <?php echo $this->_tpl_vars['PageList']; ?>

    <?php $this->_smarty_vars['capture']['default'] = ob_get_contents();  $this->assign('SideBar', ob_get_contents());ob_end_clean(); ?>
<?php endif; ?>

<?php ob_start(); ?><?php echo $this->_tpl_vars['Variables']; ?>
<?php $this->_smarty_vars['capture']['default'] = ob_get_contents();  $this->assign('DebugFooter', ob_get_contents());ob_end_clean(); ?>

<?php ob_start(); ?>
    <?php echo $this->_tpl_vars['Page']->GetFooter(); ?>

<?php $this->_smarty_vars['capture']['default'] = ob_get_contents();  $this->assign('Footer', ob_get_contents());ob_end_clean(); ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => $this->_tpl_vars['LayoutTemplateName'], 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>