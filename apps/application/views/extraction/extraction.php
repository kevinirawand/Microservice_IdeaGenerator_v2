<div class="box">
    <div class="box-header">
        <h3 class="box-title">Original Caption</h3>
    </div>
    <div class="box-body">
    <?php
        echo $crawling['caption_text'];
    ?>
    </div>
</div>
<div class="box">
    <form action="" method="post">
        <div class="box-header">
            <h3 class="box-title">Extraction</h3>
        </div>
        <div class="box-body">
        <?php
            foreach ($arr_caption_text as $key => $word) {
                echo '<label class="btn btn-flat"><input type="checkbox" name="extraction[]" value="'.$word.'" class="checkboxradio">'.$word.'</label>';
            }
        ?>
        </div>
        <div class="box-footer">
            <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> Save</button>
        </div>
    </form>
</div>