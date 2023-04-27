<div class="row">
    <div class="col-sm-6">
        <div class="box box-primary">
            <form action="" method="post" class="form-horizontal">
                <div class="box-header with-border">
                    <label class="col-sm-5 text-right">Keyword</label>
                    <label class="col-sm-6">Normalization</label>
                </div>
                <div class="box-body">
                <?php
                    foreach ($extractions as $key => $keyword) {
                        echo '<div class="form-group">';
                        echo '<label class="col-sm-5 control-label size-30">'.$keyword['keyword'].'</label>';
                        echo '<div class="col-sm-6">';
                        echo '<input type="hidden" name="id_extractions[]" value="'.$keyword['id_extraction'].'" />';
                        echo '<input type="text" name="normalizations[]" class="form-control size-30 autocompleteNormalization" />';
                        // echo '<span class="input-group-btn">
                        //         <button type="button" class="btn btn-danger"><i class="fa fa-times"></i></button>
                        //       </span>';
                        echo '</div>';
                        echo '</div>';
                    }
                ?>
                    <div class="form-group">
                        <label class="col-sm-5 control-label size-30"></label>
                        <div class="col-sm-6">
                            <input type="hidden" name="id_extractions[]" value="0" />
                            <input type="text" name="normalizations[]" class="form-control size-30 autocompleteNormalization" placeholder="Additional" value="" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-5 control-label size-30"></label>
                        <div class="col-sm-6">
                            <input type="hidden" name="id_extractions[]" value="0" />
                            <input type="text" name="normalizations[]" class="form-control size-30 autocompleteNormalization" placeholder="Additional" value="" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-5 control-label size-30"></label>
                        <div class="col-sm-6">
                            <input type="hidden" name="id_extractions[]" value="0" />
                            <input type="text" name="normalizations[]" class="form-control size-30 autocompleteNormalization" placeholder="Additional" value="" />
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </form>
        </div>
    </div>
</div>