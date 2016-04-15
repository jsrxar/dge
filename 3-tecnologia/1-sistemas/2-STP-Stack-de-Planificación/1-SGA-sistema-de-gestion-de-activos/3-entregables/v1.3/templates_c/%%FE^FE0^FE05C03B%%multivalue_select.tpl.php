<select multiple
    <?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "editors/editor_options.tpl", 'smarty_include_vars' => array('Editor' => $this->_tpl_vars['MultiValueSelect'],'Multiple' => true)));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
    data-max-selection-size="<?php echo $this->_tpl_vars['MultiValueSelect']->getMaxSelectionSize(); ?>
">

    <?php $_from = $this->_tpl_vars['MultiValueSelect']->GetValues(); if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['Value'] => $this->_tpl_vars['Name']):
?>
        <option value="<?php echo $this->_tpl_vars['Value']; ?>
"<?php if (( $this->_tpl_vars['MultiValueSelect']->IsValueSelected($this->_tpl_vars['Value']) )): ?> selected<?php endif; ?>><?php echo $this->_tpl_vars['Name']; ?>
</option>
    <?php endforeach; endif; unset($_from); ?>
</select>