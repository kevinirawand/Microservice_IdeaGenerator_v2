<?php

function msg($text, $type = 'info')
{
    if (!trim($text)) return '';
    return '
    <div class="alert alert-'.$type.' alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
        '.$text.'
    </div>';
}

?>