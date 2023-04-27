<div class="box">
    <div class="box-header with-border">
        <h3 class="box-title">List of Scraping Targets</h3>
        <div class="box-tools">
        <form class="form-inline">
            <div class="form-group">
                <input type="text" class="form-control" name="q" value="<?php echo $q; ?>">
            </div>
            <button type="submit" class="btn btn-default">Cari</button>&nbsp;&nbsp;&nbsp;&nbsp;
            <?php echo anchor('scrap_target/new', '+ New', 'class="btn btn-primary btn-sm"') ?>
        </form>
        </div>
    </div>
    <div class="box-body table-responsive">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th width="40px">No.</th>
                    <th>IG Username</th>
                    <th>Admin</th>
                    <th>Engine</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            <?php
                foreach ($table as $key => $row)
                {
                    echo '<tr>';
                    echo '<td>';
                    echo ($key + $offset + 1);
                    echo '</td>';
                    echo '<td>';
                    echo $row['ig_username'];
                    echo '</td>';
                    echo '<td>';
                    echo $row['name'];
                    echo '</td>';
                    echo '<td>';
                    echo $row['engine'];
                    echo '</td>';
                    echo '<td class="text-right">';
                    echo '<a href="'.base_url('scrap_target/edit/'.$row['id_scrap_target']).'" title="Edit" class="btn btn-xs btn-warning"><span class="fa fa-pencil-alt"></span></a>
                        <a href="'.base_url('scrap_target/delete/'.$row['id_scrap_target']).'" onclick="return confirm(`Are you sure?`)" title="Delete" class="btn btn-xs btn-danger"><span class="fa fa-trash"></span></a>';
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