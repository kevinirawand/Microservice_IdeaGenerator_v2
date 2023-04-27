<div class="box">
    <div class="box-header">
        <h3 class="box-title">List of Classification</h3>
        <div class="box-tools">
            <form class="form-inline">
                <div class="form-group">
                    <input type="text" class="form-control" name="q" value="<?php echo $q; ?>">
                </div>
                <button type="submit" class="btn btn-default">Cari</button>&nbsp;&nbsp;&nbsp;&nbsp;
            </form>        
        </div>
    </div>
    <div class="box-body table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th width="40px">No.</th>
                    <th>ID Crawling</th>
                    <th>Keyword</th>
                    <th>Label Name</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            <?php
                foreach ($table as $key => $row) {
                    echo '<tr>';
                    echo '<td>';
                    echo ($key + $offset + 1);
                    echo '</td>';
                    echo '<td>';
                    echo $row['id_crawling'];
                    echo '</td>';
                    echo '<td>';
                    echo $row['normal_text'];
                    echo '</td>';
                    echo '<td>';
                    echo $row['label_name'];
                    echo '</td>';
                    echo '<td>';
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