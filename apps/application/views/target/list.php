<?php if (isset($message)) echo $message; ?>
<div class="row">
    <div class="col-sm-4">
        <div class="box">
            <div class="box-header">
                <h3 class="box-title">List of Crawling Target</h3>
            </div>
            <div class="box-body table-responsive">
                <table class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th width="40px">No.</th>
                            <th>Target</th>
                            <th>Category</th>
                            <th width="40px"></th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        foreach ($targets as $key => $target) {
                            echo '<tr>';
                            echo '<td>'.($key + 1).'</td>';
                            echo '<td>'.($target['ig_username']).'</td>';
                            echo '<td>'.($target['category']).'</td>';
                            echo '<td><a href="'.base_url('target/delete_user_target/'.$target['id_user'].'/'.$target['id_target']).'" onclick="return confirm(`Are you sure?`)" class="btn btn-xs btn-danger" title="delete"><i class="fa fa-trash"></i></button></td>';
                            echo '</tr>';
                        }
                    ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="col-sm-4">
        <div class="box">
            <form action="" method="post">
                <div class="box-header">
                    <h3 class="box-title">Add New Crawling Target</h3>
                </div>
                <div class="box-body">
                    <div class="form-group">
                        <select name="id_target" class="form-control" placeholder="Instagram Username" required>
                        <?php
                            foreach ($option_target as $key => $target) {
                                echo '<option value="'.$target['id_target'].'">'.$target['ig_username'].'</option>';
                            }
                        ?>
                        </select>
                        <!-- <input type="text" name="target_username" maxlength="50" class="form-control" placeholder="Instagram Username" value="<?php echo set_value('ig_username') ?>" required /> -->
                        <!-- <span class="fa fa-instagram form-control-feedback"></span> -->
                    </div>
                    <div class="form-group has-feedback">
                        <input type="text" name="category" maxlength="20" class="form-control" placeholder="Category" value="<?php echo set_value('category') ?>" required />
                        <span class="fa fa-tag form-control-feedback"></span>
                    </div>
                </div>
                <div class="box-footer">
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </form>
        </div>
    </div>
</div>