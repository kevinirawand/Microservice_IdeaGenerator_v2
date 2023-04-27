      <div class="box">
        <div class="box-header with-border">
          <h3 class="box-title">List Users</h3>

          <div class="box-tools">
            <form class="form-inline">
              <div class="form-group">
                  <input type="text" class="form-control" name="q" value="<?php echo $q; ?>">
              </div>
              <button type="submit" class="btn btn-default" id="cari_users">Cari</button>&nbsp;&nbsp;&nbsp;&nbsp;
              <?php if ($user_type == 1) echo anchor('user/new', '+ New', 'class="btn btn-primary btn-sm"') ?>
            </form>
          </div>
        </div>
        <!-- /.box-header -->
        <div class="box-body table-responsive">
          <table class="table table-hover">
            <thead>
                <tr>
                  <th width="50px">No.</th>
                  <th>Name</th>
                  <th>Username</th>
                  <th>Type</th>
                  <th>Active</th>
                  <th>IG Username</th>
                  <!-- <th>Created</th>
                  <th>Updated</th> -->
                  <th></th>
                </tr>
            </thead>
            <tbody>
            <?php
              foreach ($table as $key=>$row) {
                echo '<tr>';
                echo '<td>'.($key+$offset+1).'</td>';
                echo '<td>'.$row['name'].'</td>';
                echo '<td>'.$row['username'].'</td>';
                echo '<td>'.userType($row['user_type']).'</td>';
                echo '<td><i class="fa fa-circle '.($row['active'] ? 'text-success' : 'text-danger').'"></i></td>';
                echo '<td>'.$row['ig_username'].'</td>';
                // echo '<td title="'.$row['created'].'">'.date("d M Y", strtotime($row['created'])).'</td>';
                // echo '<td title="'.$row['updated'].'">'.date("d M Y", strtotime($row['updated'])).'</td>';
                echo '<td class="text-right">';
                if ($row['user_type'] == 3)
                {
                  echo '<a href="'.site_url('user/target/'.$row['id_user']).'" class="btn btn-xs btn-primary">Crawling Targets</a> ';
                  echo '<a href="'.site_url('user/scrap_target/'.$row['id_user']).'" class="btn btn-xs btn-primary">Scraping Targets</a> ';
                }
                if ($user_type == 1)
                {
                  echo '<a href="'.site_url('user/edit/'.$row['id_user']).'" title="Edit" class="btn btn-xs btn-warning"><span class="fa fa-pencil-alt"></span></a>
                        <a href="'.site_url('user/delete/'.$row['id_user']).'" onclick="return confirm(`Are you sure?`);" title="Delete" class="btn btn-xs btn-danger"><span class="fa fa-trash"></span></a>';
                }
                echo '</td>';
                echo '</tr>';
              }
            ?>
            </tbody>
          </table>
        </div>
        <!-- /.box-body -->
        <div class="box-footer">
          <?php echo $pagination; ?>
        </div>
      </div>
      <!-- /.box -->