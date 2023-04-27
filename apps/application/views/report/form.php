<?php
    $year = date('Y');
    $month = date('n');
?>
        <div class="box">
            <div class="box-header">
                <h3 class="box-title">Create .XLSX FAIR Report</h3>
            </div>
            <div class="box-body">
                <div class="row">
                    <div class="col-md-5">
                        <form id="form" class="form-horizontal" action="#" method="post">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">User</label>
                                <div class="col-sm-9">
                                    <select class="form-control" name="iid_user" style="max-width: 400px;" required>
                                        <option value="">- Choose -</option>
                                        <?php
                                            foreach ($users as $user) {
                                                echo '<option value="'.$user['id_user'].'">'.$user['name'].'</option>';
                                            }
                                        ?>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">
                                    Year
                                </label>
                                <div class="col-sm-9">
                                    <input type="number" name="iyear" class="form-control" placeholder="2021" value="<?php echo $year; ?>" style="max-width: 100px;" max="<?php echo $year; ?>" min="2020" required />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">
                                    Month
                                </label>
                                <div class="col-sm-9">
                                    <input type="number" name="imonth" class="form-control" placeholder="1 - 12" value="<?php echo $month; ?>" style="max-width: 100px;" max="12" min="1" required />
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">Process</button>
                        </form>
                    </div>
                </div>
                
            </div>
        </div>