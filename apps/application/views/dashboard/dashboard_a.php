<div class="content-wrapper">
    <div class="">
      <!-- Content Header (Page header) -->
      <section class="content-header">
        <h1>
          Dashboard
          <small>A</small>
          <!-- <select name="day_count" onChange="changeDayCount(this.value)">
            <option value="1" set>Hari ini</option>
            <option value="7" >Minggu ini</option>
            <option value="30" >Bulan ini</option>
          </select> -->
        </h1>
        <ol class="breadcrumb">
        <?php echo form_dropdown('day_count', $options_day_count, $day_offset, 'onChange="changeDayCount(this.value)" style="margin-right: 30px;"'); ?>
          <li><i class="fa fa-tags"></i></li>
          <?php
            foreach ($categories as $key => $category) {
                echo '<li>';
                echo ($category['category'] == urldecode($activeCategory) ? '<a href="#" class="text-light-blue text-bold">' : '<a href="../'.$category['category'].'/'.$day_offset.'">');
                echo $category['category'];
                echo '</a>';
                echo '</li>';
            }
          ?>
        </ol>
      </section>

      <!-- Main content -->
      <section class="content">
        <div class="row">
            <div class="col-md-4">
                <div class="box box-solid">
                  <div class="box-header">
                    <h3 class="box-title">Nilai Sosial</h3>
                  </div>
                  <!-- /.box-header -->
                  <div class="box-body">
                      <div class="chart-responsive">
                          <canvas id="" width="400" height="160" class="chart"></canvas>
                      </div>
                  </div>
                  <!-- /.box-body -->
                </div>
            </div>
            <div class="col-md-4">
              <div class="box box-solid">
                <div class="box-header">
                    <h3 class="box-title">Penghubung</h3>
                </div>
                <!-- /.box-header -->
                <div class="box-body">
                    <div class="chart-responsive">
                        <canvas id="" width="400" height="160" class="chart"></canvas>
                    </div>
                </div>
                <!-- /.box-body -->
              </div>
            </div>
            <div class="col-md-4">
              <div class="box box-solid">
                <div class="box-header">
                  <h3 class="box-title">Sisi Emosional</h3>
                </div>
                <!-- /.box-header -->
                <div class="box-body">
                    <div class="chart-responsive">
                      <canvas id="" width="400" height="160" class="chart"></canvas>
                    </div>
                </div>
                <!-- /.box-body -->
              </div>
            </div>
            <div class="col-md-4">
              <div class="box box-solid">
                <div class="box-header">
                  <h3 class="box-title">Publik</h3>
                </div>
                <!-- /.box-header -->
                <div class="box-body">
                    <div class="chart-responsive">
                      <canvas id="" width="400" height="160" class="chart"></canvas>
                    </div>
                </div>
                <!-- /.box-body -->
              </div>
            </div>
            <div class="col-md-4">
              <div class="box box-solid">
                <div class="box-header">
                  <h3 class="box-title">Tips</h3>
                </div>
                <!-- /.box-header -->
                <div class="box-body">
                    <div class="chart-responsive">
                      <canvas id="" width="400" height="160" class="chart"></canvas>
                    </div>
                </div>
                <!-- /.box-body -->
              </div>
            </div>
            <div class="col-md-4">
              <div class="box box-solid">
                <div class="box-header">
                  <h3 class="box-title">Cerita</h3>
                </div>
                <!-- /.box-header -->
                <div class="box-body">
                    <div class="chart-responsive">
                      <canvas id="" width="400" height="160" class="chart"></canvas>
                    </div>
                </div>
                <!-- /.box-body -->
              </div>
            </div>
        </div>
      </section>
      <!-- /.content -->
    </div>
    <!-- /.container -->
</div>