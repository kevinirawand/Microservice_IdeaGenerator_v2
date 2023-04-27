<div class="row">
    <div class="col-sm-4">
        <div class="box">
            <form action="" method="post">
                <?php
                if (isset($row['id_target']))
                {
                    echo '<input type="hidden" name="id_target" value="'.$row['id_target'].'">';
                }
                ?>
                <div class="box-body">
                    <div class="form-group">
                        <label>IG Username</label>
                        <input type="text" name="ig_username" class="form-control" value="<?php echo $row['ig_username']; ?>" placeholder="Enter an Instagram account username" required />
                        <?php echo form_error('ig_username'); ?>
                    </div>
                    <div class="form-group">
                        <label>Admin</label>
                        <select name="id_admin" class="form-control" required>
                        <?php foreach ($option_admin as $key => $user) { ?>
                            <option value="<?php echo $user['id_user']; ?>" <?php echo $user['id_user'] == $row['id_admin'] ? 'selected' : ''; ?> ><?php echo $user['name']; ?></option>
                        <?php }?>
                        </select>
                        <?php echo form_error('id_admin'); ?>
                    </div>
                    <div class="form-group">
                        <label>Crawler Engine</label>
                        <select name="id_engine" class="form-control" required>
                        <?php foreach ($option_engine as $key => $engine) { ?>
                            <option value="<?php echo $engine['id_engine']; ?>" <?php echo $engine['id_engine'] == $row['id_engine'] ? 'selected' : ''; ?> ><?php echo $engine['ig_username']; ?></option>
                        <?php } ?>
                        </select>
                        <?php echo form_error('id_engine'); ?>
                    </div>
                </div>
                <div class="box-footer">
                    <button type="submit" class="btn btn-primary">Save</button>
                    <a href="<?php echo site_url('target') ?>" class="btn btn-default">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>