<div class="row">
    <div class="col-sm-4">
        <div class="box">
            <form action="" method="post">
                <?php
                if (isset($engine['id_engine']))
                {
                    echo '<input type="hidden" name="id_engine" value="'.$engine['id_engine'].'">';
                }
                ?>
                <div class="box-body">
                    <div class="form-group">
                        <label for="0001">IG Username</label>
                        <input type="text" name="ig_username" id="0001" class="form-control" value="<?php echo $engine['ig_username'] ?>" placeholder="Enter an Instagram account username" required />
                        <?php echo form_error('ig_username'); ?>
                    </div>
                    <div class="form-group">
                        <label for="0002">IG Password</label>
                        <input type="text" name="ig_password" id="0002" class="form-control" value="<?php echo $engine['ig_password'] ?>" placeholder="Enter the account password" required />
                        <?php echo form_error('ig_password'); ?>
                    </div>
                </div>
                <div class="box-footer">
                    <button type="submit" class="btn btn-primary">Save</button>
                    <a href="<?php echo site_url('engine') ?>" class="btn btn-default">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>