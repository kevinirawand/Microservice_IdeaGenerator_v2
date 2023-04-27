<div class="box">
    <div class="box-header with-border">
        <h3 class="box-title">List Engines</h3>
        <div class="box-tools">
            <form class="form-inline">
                <div class="form-group">
                    <input type="text" class="form-control" name="q" value="<?php echo $q; ?>">
                </div>
                <button type="submit" class="btn btn-default">Cari</button>&nbsp;&nbsp;&nbsp;&nbsp;
                <?php echo anchor('engine/new', '+ New', 'class="btn btn-md btn-primary"'); ?>
            </form>
        </div>
    </div>
    <div class="box-body table-responsive">
        <table class="table table-hover table-striped">
            <thead>
                <tr>
                    <th width="50px">No.</td>
                    <th>IG Username</th>
                    <th>IG Password</th>
                    <th class="text-right"></th>
                </tr>
            </thead>
            <tbody>
                <?php
                foreach ($table as $key => $row) {
                    echo '<tr>';
                    echo '<td>'.($key + $offset + 1).'</td>';
                    echo '<td>'.($row['ig_username']).'</td>';
                    echo '<td>'.($row['ig_password']).'</td>';
                    echo '<td class="text-right">';
                    echo '<a href="'.(site_url('engine/edit/'.$row['id_engine'])).'" class="btn btn-xs btn-warning" title="Edit"><i class="fa fa-pencil-alt"></i></a> ';
                    echo '<a href="'.base_url('engine/delete/'.$row['id_engine']).'" onclick="return confirm(`Are you sure?`);" class="btn btn-xs btn-danger" title="Delete"><i class="fa fa-trash"></i></a> ';
                    echo '</td>';
                    echo '</tr>';
                }
                ?>
            </tbody>
        </table>
    </div>
    <div class="box-footer">
        <?php echo $pagination; ?>
    </div>
</div>