<div class="content-wrapper" id="cw">
    <section class="content">
        <div class="row">
            <div class="col-md-8">
                <div class="box box-solid">
                    <div class="box-header">
                        <h3 class="box-title">
                            <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="27px" style="margin-right: 10px;" />
                            Top Keyword <span><?php echo ucfirst($this->uri->segment(2)); ?></span>
                        </h3>
                    <div class="box-tools pull-right">
                        <!-- button with a dropdown -->
                        <div class="btn-group">
                            <button type="button" class="btn btn-sm dropdown-toggle text-bold" data-toggle="dropdown">
                                <?php echo urldecode($activeCategory); ?> &nbsp; <i class="fa fa-caret-down"></i>
                            </button>
                            <ul class="dropdown-menu pull-right" role="menu">
                            <?php
                                foreach ($categories as $key => $category) {
                                    echo '<li>';
                                    echo '<a href="./'.$category['category'].'">';
                                    echo $category['category'];
                                    echo '</a>';
                                    echo '</li>';
                                }
                            ?>
                            </ul>
                        </div>
                    </div>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">
                        <div class="chart-responsive">
                            <canvas width="400" height="160" class="chart" id="chart"></canvas>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
            </div>
            <div class="col-md-4">
                <div class="box box-solid">
                    <div class="box-header">
                        <h3 class="box-title">Sumber top keyword <span><?php echo ucfirst($this->uri->segment(2)); ?></span>:</h3>
                    </div>
                    <div class="box-header">
                        <h3 class="box-title text-bold" id="label-sumber" style="color: #15b4c3;"></h3>
                    </div>
                    <div class="box-body no-padding" style="max-height: 326px; overflow: scroll;">
                        <ul class="products-list product-list-in-box" id="list-sumber"></ul>
                    </div>
                </div>
            </div>
        </div>
    <!-- </section> -->

    <!-- <section class="content-header">
      <h1>
        Viral Keyword <span><?php echo ucfirst($this->uri->segment(2)); ?></span>
      </h1>
    </section> -->
    <!-- <section class="content"> -->
        <div class="box box-solid" style="background-color: transparent;">
            <div class="box-header">
                <table width="100%">
                    <tr>
                        <td style="width: 1%; white-space: nowrap; padding-right: 15px;">
                            <h3 class="box-title">
                                <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="27px" style="margin-right: 10px;" />
                                Viral Keyword <span><?php echo ucfirst($this->uri->segment(2)); ?></span>
                            </h3>
                        </td>
                        <td>
                            <hr style="border-color: #15b4c3;"/>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="box-body no-padding">
                <div class="row">
                    <div class="col-md-2">
                        <div class="box box-solid viral-keyword">
                            <div class="box-header">
                                <h3 class="box-title text-bold">Nilai Sosial</h3>
                            </div>
                            <div class="box-body">
                                <div id="tbl-1">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="box box-solid viral-keyword">
                            <div class="box-header">
                                <h3 class="box-title text-bold">Penghubung</h3>
                            </div>
                            <div class="box-body">
                                <div id="tbl-2">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="box box-solid viral-keyword">
                            <div class="box-header">
                                <h3 class="box-title text-bold">Sisi Emosional</h3>
                            </div>
                            <div class="box-body">
                                <div id="tbl-3">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="box box-solid viral-keyword">
                            <div class="box-header">
                                <h3 class="box-title text-bold">Publik</h3>
                            </div>
                            <div class="box-body">
                                <div id="tbl-4">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="box box-solid viral-keyword">
                            <div class="box-header">
                                <h3 class="box-title text-bold">Tips</h3>
                            </div>
                            <div class="box-body">
                                <div id="tbl-5">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="box box-solid viral-keyword">
                            <div class="box-header">
                                <h3 class="box-title text-bold">Cerita</h3>
                            </div>
                            <div class="box-body">
                                <div id="tbl-6">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<script>

var base_url = '<?php echo base_url(); ?>';
var interval = <?php echo 100 ?>;
var category = '<?php echo $activeCategory ?>'

</script>