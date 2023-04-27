<div class="row">
    <div class="col-sm-4">
        <div class="box">
            <form action="" method="post">
                <?php
                if (isset($row['contributor_id']))
                {
                    echo '<input type="hidden" name="contributor_id" value="'.$row['contributor_id'].'">';
                }
                ?>
                <div class="box-body">
                    <div class="form-group">
                        <label>Name</label>
                        <input type="text" name="name" class="form-control" value="<?php echo $row['name']; ?>" placeholder="Enter contributor name" required />
                        <?php echo form_error('ig_username'); ?>
                    </div>
                    <div class="form-group">
                        <label>IG Username</label>
                        <input type="text" name="ig_username" class="form-control" value="<?php echo $row['ig_username']; ?>" placeholder="Enter an Instagram account username" required />
                        <?php echo form_error('ig_username'); ?>
                    </div>
                    <div class="form-group">
                        <label>User</label>
                        <select name="user_id" class="form-control" required>
                        <?php foreach ($option_admin as $key => $user) { ?>
                            <option value="<?php echo $user['id_user']; ?>" <?php echo $user['id_user'] == $row['id_admin'] ? 'selected' : ''; ?> ><?php echo $user['name']; ?></option>
                        <?php }?>
                        </select>
                        <?php echo form_error('user_id'); ?>
                    </div>
                </div>
                <div class="box-footer">
                    <button type="submit" class="btn btn-primary">Save</button>
                    <a href="<?php echo site_url('contributor') ?>" class="btn btn-default">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>