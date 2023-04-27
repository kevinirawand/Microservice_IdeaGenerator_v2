<fieldset style="margin-bottom: 25px;">
    <legend>Drag this to a classification label</legend>
    <?php
    foreach ($normalizations as $key => $normalization) {
        echo '<label class="btn btn-default draggable">
                <input type="hidden" value="0" name="id_nor['.$normalization['id_normalization'].']"/>
                '.$normalization['normal_text'].'
            </label> ';
    }
    ?>
</fieldset>

<form action="" method="post">
    <div class="row">
        <?php
        foreach ($labels as $key => $label) {
            echo '<div class="col-sm-2">
                    <div class="box box-primary drop-target" id="'.$label['id_label'].'">
                        <div class="box-header">
                            <h3 class="box-title">
                                '.$label['label_name'].'
                            </h3>
                        </div>
                        <div class="box-body">
                        </div>
                    </div>
                </div>';
        }
        ?>
        <div class="col-sm-12">
            <button type="submit" class="btn btn-primary">Save</button>
        </div>
    </div>
</form>