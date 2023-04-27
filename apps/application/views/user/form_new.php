<?php if (isset($message)) echo $message; ?>
<div class="row">
    <div class="col-md-4">
        <div class="box box-primary">
            <form action="" method="post">
                <div class="box-body">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input name="name" type="text" class="form-control" value="<?php echo set_value('name'); ?>" />
                        <?php echo form_error('name'); ?>
                    </div>
                    <div class="form-group">
                        <label>Username (Email)</label>
                        <input name="username" type="email" class="form-control" value="<?php echo set_value('username'); ?>" />
                        <?php echo form_error('username'); ?>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input name="password" type="password" class="form-control" />
                        <?php echo form_error('password'); ?>
                    </div>
                    <div class="form-group">
                        <label>Retype Password</label>
                        <input name="conf_password" type="password" class="form-control" />
                        <?php echo form_error('conf_password'); ?>
                    </div>
                    <div class="form-group">
                        <label>User Type</label>
                        <div class="row">
                            <label class="col-sm-4">
                                <input type="radio" name="user_type" value="2" <?php echo set_radio('user_type', '2'); ?> /> Admin
                            </label>
                            <label class="col-sm-4">
                                <input type="radio" name="user_type" value="3" <?php echo set_radio('user_type', '3', TRUE); ?> /> User
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Instagram</label>
                        <input name="ig_username" type="text" class="form-control" maxlength="50" />
                        <?php echo form_error('ig_username'); ?>
                    </div>
                </div>
                <!-- /.box-body -->
                <div class="box-footer">
                    <div class="row">
                        <div class="col-xs-5">
                            <div class="">
                                <label>
                                    <input name="active" type="checkbox" value="1" <?php echo set_checkbox('active', '1'); ?> /> Active
                                </label>
                            </div>
                        </div>
                        <!-- /.col -->
                        <div class="col-xs-7 text-right">
                            <button type="submit" class="btn btn-primary">Save</button>
                            <?php echo  anchor('user', 'Cancel', 'class="btn btn-default"'); ?>
                        </div>
                        <!-- /.col -->
                    </div>
                </div>
                <!-- /.box-footer-->
            </form>
        </div>
        <!--/.direct-chat -->
    </div>
    <!-- /.col -->
</div>