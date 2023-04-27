<?php if (isset($message)) echo $message; ?>
<div class="row">
    <div class="col-md-4">
        <div class="box box-primary">
            <form action="" method="post">
                <div class="box-header">
                    <h3 class="box-title">Update User Data</h3>
                </div>
                <div class="box-body">
                    <input type="hidden" name="id_user" value="<?php echo $row['id_user']; ?>" required />
                    <div class="form-group">
                        <label>Full Name</label>
                        <input value="<?php echo $row['name']; ?>" name="name" type="text" class="form-control" required />
                        <?php echo form_error('name'); ?>
                    </div>
                    <div class="form-group">
                        <label>Username (Email)</label>
                        <input value="<?php echo $row['username']; ?>" name="username" type="email" class="form-control" required />
                        <?php echo form_error('username'); ?>
                    </div>
                    <div class="form-group">
                        <label>User Type</label>
                        <select name="user_type" class="form-control" required>
                            <option value="2" <?php if ($row['user_type'] == 2) echo 'selected="true"' ?> >Admin</option>
                            <option value="3" <?php if ($row['user_type'] == 3) echo 'selected="true"' ?> >User</option>
                        </select>
                        <?php echo form_error('user_type'); ?>
                    </div>
                    <div class="form-group">
                        <label>Instagram</label>
                        <input value="<?php echo $row['ig_username']; ?>" name="ig_username" type="text" class="form-control" />
                        <?php echo form_error('ig_username'); ?>
                    </div>
                </div>
                <!-- /.box-body -->
                <div class="box-footer">
                    <div class="row">
                        <div class="col-xs-8">
                            <label>
                                <input type="checkbox" name="active" value="1" <?php if ($row['active'] == 1) echo 'checked="true"' ?> />
                                Active
                            </label>  
                        </div>
                        <!-- /.col -->
                        <div class="col-xs-4 text-right">
                            <button type="submit" class="btn btn-primary btn-flat">Save</button>
                        </div>
                        <!-- /.col -->
                    </div>
                </div>
                <!-- /.box-footer-->
            </div>
        </form>
    </div>
    <div class="col-md-4">
        <div class="box box-primary">
            <form action="" method="post">
                <div class="box-header">
                    <h3 class="box-title">Reset User Password</h3>
                </div>
                <div class="box-body">
                    <div class="form-group">
                        <label>New Password</label>
                        <input name="password" type="password" class="form-control" required="true" />
                        <?php echo form_error('password'); ?>
                    </div>
                    <div class="form-group">
                        <label>Retype Password</label>
                        <input name="conf_password" type="password" class="form-control" required="true" />
                        <?php echo form_error('conf_password'); ?>
                    </div>
                </div>
                <div class="box-footer text-right">
                    <button type="submit" class="btn btn-primary btn-flat">Save</button>
                </div>
            </form>
        </div>
    </div>
    <!-- /.col -->
</div>