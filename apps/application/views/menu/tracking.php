<div class="box">
    <div class="box-header with-border">
        <h3 class="box-title">Click Counter</h3>
        <div class="box-tools">
            <form class="form-inline">
                <div class="form-group">
                    <input type="text" class="form-control" name="q" value="<?php echo $q; ?>">
                </div>
                <button type="submit" class="btn btn-default">Cari</button>
            </form>
        </div>
    </div>
    <div class="box-body table-responsive">
        <table class="table table-hover table-striped table-bordered">
            <thead>
                <tr>
                    <th class="text-center" width="50px" rowspan="2" style="vertical-align: middle;">No.</td>
                    <th class="text-center" rowspan="2" style="vertical-align: middle;">Client Name</th>
                    <th class="text-center" colspan="3">Viral Analysis</th>
                    <th class="text-center" rowspan="2" style="vertical-align: middle;">Pattern</th>
                    <th class="text-center" colspan="2">Competitor</th>
                    <th class="text-center" colspan="2">Self Performance</th>
                </tr>
                <tr>
                    <th class="text-center">Daily</th>
                    <th class="text-center">Weekly</th>
                    <th class="text-center">Monthly</th>
                    <th class="text-center">Daily</th>
                    <th class="text-center">Monthly</th>
                    <th class="text-center">Daily</th>
                    <th class="text-center">Monthly</th>
                </tr>
            </thead>
            <tbody>
                <?php
                foreach ($tracking as $key => $row) {
                    echo '<tr>';
                    echo '<td class="text-right">'.($key + 1).'</td>';
                    echo '<td>'.'<i class="fa fa-circle '.($row['active'] ? 'text-success' : 'text-danger').'"></i> &nbsp; '.($row['name']).'</td>';
                    echo '<td class="text-right" style="width: 110px;">'.($row['viral_d']).'</td>';
                    echo '<td class="text-right" style="width: 110px;">'.($row['viral_w']).'</td>';
                    echo '<td class="text-right" style="width: 110px;">'.($row['viral_m']).'</td>';
                    echo '<td class="text-right" style="width: 110px;">'.($row['pattern']).'</td>';
                    echo '<td class="text-right" style="width: 110px;">'.($row['competitor_d']).'</td>';
                    echo '<td class="text-right" style="width: 110px;">'.($row['competitor_m']).'</td>';
                    echo '<td class="text-right" style="width: 110px;">'.($row['performance_d']).'</td>';
                    echo '<td class="text-right" style="width: 110px;">'.($row['performance_m']).'</td>';
                    echo '</tr>';
                }
                ?>
            </tbody>
        </table>
    </div>
</div>