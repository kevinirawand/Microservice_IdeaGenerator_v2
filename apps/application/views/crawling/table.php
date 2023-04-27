<div class="box">
    <div class="box-header">
        <h3 class="box-title">
            List of Crawled Results
        </h3>

        <div class="box-tools">
            <form class="form-inline">
                <div class="form-group">
                    <input type="text" class="form-control" name="q" value="<?php echo $q; ?>">
                </div>
                <button type="submit" class="btn btn-default">Cari</button>&nbsp;&nbsp;&nbsp;&nbsp;
                <a href="<?php echo ($show_history ? site_url('crawling/table') : site_url('crawling/table/with_history')) ?>" class="btn btn-sm <?php echo ($show_history ? "btn-success" : "btn-default") ?>">
                    <input type="checkbox" disabled <?php if ($show_history) echo 'checked' ?> />&nbsp;
                    Show History
                </a>
            </form>
        </div>
    </div>
    <div class="box-body table-responsive">
        <table class="table table-hover table-striped">
        <thead>
            <tr>
                <th width="40px">No.</th>
                <th>IG Username</th>
                <th>Follower</th>
                <th>Like</th>
                <th>ID</th>
                <th>Caption</th>
                <th>Phase</th>
                <th>Taken At</th>
                <th title="Time Frame">TF</th>
                <!-- <th></th> -->
            </tr>
        </thead>
        <tbody>
        <?php
            foreach ($table as $key => $row) {
                echo '<tr>';
                echo '<td>';
                echo ($key + 1 + $offset);
                echo '</td>';
                echo '<td>';
                echo $row['ig_username'];
                echo '</td>';
                echo '<td>';
                echo $row['follower_count'];
                echo '</td>';
                echo '<td>';
                echo $row['like_count'];
                echo '</td>';
                echo '<td>';
                echo $row['id_crawling'];
                echo '</td>';
                echo '<td>';
                echo substr($row['caption_text'], 0, 50);
                if (strlen($row['caption_text']) > 50) echo '...';
                echo '</td>';
                echo '<td>';
                echo '<a href="'.$row['url'].'" target="_blank" class="btn btn-xs btn-default" title="Go to posting page"><i class="fa fa-link"></i></a> ';
                echo anchor('extraction/crawling/'.$row['id_crawling'], '<i class="fa fa-share-square"></i>', 'class="btn btn-xs '.($row['is_extracted'] ? 'btn-success' : 'btn-default').'" title="Extraction"').' ';
                echo '<a '.($row['is_extracted'] ? 'href="'.site_url('normalization/crawling/'.$row['id_crawling']).'"' : 'disabled').' class="btn btn-xs '.($row['is_normalized'] ? 'btn-success' : 'btn-default').'" title="Normalization"><i class="fa fa-font"></i></a> ';
                echo '<a '.($row['is_normalized'] ? 'href="'.site_url('classification/crawling/'.$row['id_crawling']).'"' : 'disabled').' class="btn btn-xs '.($row['is_classified'] ? 'btn-success' : 'btn-default').'" title="Classification"><i class="fa fa-tags"></i></a> ';
                // echo anchor('normalization/crawling/'.$row['id_crawling'], '<i class="fa fa-font"></i>', 'class="btn btn-xs '.($row['is_normalized'] ? 'btn-success' : 'btn-default').'" title="Normalization" '.($row['is_extracted'] ? '' : 'disabled')).' ';
                // echo anchor('classification/crawling/'.$row['id_crawling'], '<i class="fa fa-tags"></i>', 'class="btn btn-xs '.($row['is_classified'] ? 'btn-success' : 'btn-default').'" title="Classification" '.($row['is_normalized'] ? '' : 'disabled')).' ';
                echo '</td>';
                echo '<td>';
                echo $row['taken_at'];
                echo '</td>';
                echo '<td>';
                echo $row['time_frame'];
                echo '</td>';
                // echo '<td class="text-right">';
                // echo anchor('crawling/detail/'.$row['id_crawling'], '<i class="fa fa-search"></i>', 'class="btn btn-xs btn-primary" title="View detail"').' ';
                // echo '</td>';
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