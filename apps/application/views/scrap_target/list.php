<?php if (isset($message)) echo $message; ?>
<div class="row">
    <div class="col-sm-4">
        <div class="box">
            <div class="box-header">
                <h3 class="box-title">List of Scraping Target</h3>
            </div>
            <div class="box-body table-responsive">
                <table class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th width="40px">No.</th>
                            <th>Target</th>
                            <th width="40px"></th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        foreach ($scrap_targets as $key => $scrap_target) {
                            echo '<tr>';
                            echo '<td>'.($key + 1).'</td>';
                            echo '<td>'.($scrap_target['ig_username']).'</td>';
                            echo '<td><a href="'.base_url('scrap_target/delete_user_scrap_target/'.$scrap_target['id_user'].'/'.$scrap_target['id_scrap_target']).'" onclick="return confirm(`Are you sure?`)" class="btn btn-xs btn-danger" title="delete"><i class="fa fa-trash"></i></button></td>';
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
                    <h3 class="box-title">Add New Scraping Target</h3>
                </div>
                <div class="box-body">
                    <div class="form-group">
                        <select name="id_scrap_target" class="form-control" placeholder="Instagram Username" required>
                        <?php
                            foreach ($option_scrap_target as $key => $scrap_target) {
                                echo '<option value="'.$scrap_target['id_scrap_target'].'">'.$scrap_target['ig_username'].'</option>';
                            }
                        ?>
                        </select>
                        <!-- <input type="text" name="scrap_target_username" maxlength="50" class="form-control" placeholder="Instagram Username" value="<?php echo set_value('ig_username') ?>" required /> -->
                        <!-- <span class="fa fa-instagram form-control-feedback"></span> -->
                    </div>
                </div>
                <div class="box-footer">
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </form>
        </div>
    </div>
</div>