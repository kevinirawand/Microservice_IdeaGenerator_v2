<div class="content-wrapper" id="cw">
    <section class="content" interval="<?php echo $interval; ?>" category="<?php echo $category; ?>">
        <?php if (!$isDataExist) { ?>
            <p class="msg-not-counted" style="text-align: center; padding: 10px 5px; color: rgb(255, 200, 0); background-color: rgba(255, 200, 0, 0.2); border-radius: 3px;">
                Today, data has not been counted yet. Latest update <?php echo $latestUpdate; ?>.
            </p>
        <?php } ?>
        <div class="row">
            <div class="col-md-8">
                <div class="box box-solid">
                    <div class="box-header" style="padding: 12px;">
                        <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                            <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                            Top Keyword
                        </h3>
                        <div class="box-tools pull-right">
                            <!-- button with a dropdown -->
                            <div class="btn-group">
                                <button type="button" class="btn btn-sm dropdown-toggle text-bold" data-toggle="dropdown">
                                    <?php echo urldecode($category); ?> &nbsp; <i class="fa fa-caret-down"></i>
                                </button>
                                <ul class="dropdown-menu pull-right" role="menu">
                                <?php
                                    foreach ($categories as $key => $row) {
                                        echo '<li>';
                                        echo '<a href="./'.$row['category'].'">';
                                        echo $row['category'];
                                        echo '</a>';
                                        echo '</li>';
                                    }
                                ?>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body" style="padding: 12px;">
                        <div id="chart-container">
                            <canvas class="chart" id="chart"></canvas>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
            </div>
            <div class="col-md-4" style="">
                <div class="box box-solid box-source" style="height: inherit;">
                    <div class="box-header" style="padding: 12px;">
                        <h4 class="box-title" style="font-size: 14px; line-height: 24px;">Keyword Source : <span id="selected-label" style="color: #15b4c3; font-weight: bold;"></span></h4>
                    </div>
                    <!-- <div class="box-header">
                        <h3 class="box-title text-bold" id="label-sumber" style="color: #15b4c3;"></h3>
                    </div> -->
                    <div id="loading-source" style="display: none; position: absolute; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 2; margin-top: 12px;">
                        <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                    </div>
                    <div class="box-body" style="padding: 12px;">
                        <div id="keyword-source-container">
                            <ul class="products-list product-list-in-box slim-scroll" id="list-sumber">
                                <!-- <a haref="#" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" alt="" style="height: 32px; width: 32px;" />
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="font-weight: normal;">Miskin</span>
                                            <span class="product-description" style="font-size: 10px; line-height: 11px; color: #15b4c3;">https://www.instagram.com/p/B9IQtJbH8cy</span>
                                        </div>
                                    </li>
                                </a> -->
                            </ul>
                        </div>
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
            <div class="box-header no-padding">
                <table width="100%">
                    <tr>
                        <td style="width: 1%; white-space: nowrap; padding-right: 15px; line-height: 14px;">
                            <h3 class="box-title text-bold">
                                <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px; margin-left: 12px;" />
                                Viral Keyword
                            </h3>
                        </td>
                        <td>
                            <hr style="border-color: #15b4c3;"/>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="box-body no-padding">
                <div class="row" style="padding-top: 12px; padding-bottom: 12px;">
                    <div class="col-sm-4 col-sm-offset-8">
                        <div id="input-search" class="input-group" style="border-radius: 10px; border: 2px solid #15b4c3; overflow: hidden;">
                            <input type="text" placeholder="Search" class="form-control no-border" style="color: white; background-color: transparent;" />
                            <span class="input-group-addon" style="border: 0; background: transparent; color: white; display: none;">
                                <i class="fa fa-spinner fa-spin"></i>
                            </span>
                            <span class="input-group-btn btn-clear" style="display: none;">
                                <button type="button" class="btn btn-flat no-border" style="height: 34px;">
                                    <i class="fa fa-times"></i>
                                </button>
                            </span>
                            <span class="input-group-btn btn-search">
                                <button type="button" class="btn btn-flat no-border" style="height: 34px;">
                                    <i class="fa fa-search"></i>
                                </button>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2">
                        <div class="box box-solid box-flat viral-keyword box-label" id="keyword-0">
                            <div class="box-header">
                                <h3 class="box-title text-bold" style="white-space: nowrap; overflow: hidden;">Nilai Sosial</h3>
                            </div>
                            <div class="loading-list-keyword" style="display: none; position: absolute; width: 100%; height: 232px; justify-content: center; background-color: rgba(30,30,40,0.5);">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>
                            <div class="box-body">
                                <div class="list-keyword">
                                    <div class="slim-scroll">
                                        <!-- <a href="#" class="box-keyword" title="Miskin">
                                            <div class="keyword">Miskin</div>
                                            <table>
                                                <tr>
                                                    <td class="progress progress-flat">
                                                        <div class="progress-bar" style="width: 90%; background-color: #0ED1D6;"></div>
                                                    </td>
                                                    <td class="value-keyword">
                                                        1.23%
                                                    </td>
                                                </tr>
                                            </table>
                                        </a> -->
                                    </div>
                                </div>
                                <button class="btn btn-flat btn-block no-border btn-loadmore">See more keywords</button>
                            </div>
                            <div class="loading-box-label">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="box box-solid box-flat viral-keyword box-label" id="keyword-1">
                            <div class="box-header">
                                <h3 class="box-title text-bold" style="white-space: nowrap; overflow: hidden;">Penghubung</h3>
                            </div>
                            <!--<div class="loading-list-keyword" style="display: flex; position: absolute; width: 100%; height: 232px; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 10;">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>-->
                            <div class="box-body">
                                <div class="list-keyword">
                                    <div class="slim-scroll">
									</div>
                                </div>
                                <button class="btn btn-flat btn-block no-border btn-loadmore">See more keywords</button>
                            </div>
                            <div class="loading-box-label">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="box box-solid box-flat viral-keyword box-label" id="keyword-2">
                            <div class="box-header">
                                <h3 class="box-title text-bold" style="white-space: nowrap; overflow: hidden;">Sisi Emosional</h3>
                            </div>
                            <div class="box-body">
                                <div class="list-keyword">
                                    <div class="slim-scroll"></div>
                                </div>
                                <button class="btn btn-flat btn-block no-border btn-loadmore">See more keywords</button>
                            </div>
                            <div class="loading-box-label">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="box box-solid box-flat viral-keyword box-label" id="keyword-3">
                            <div class="box-header">
                                <h3 class="box-title text-bold">Publik</h3>
                            </div>
                            <div class="box-body">
                                <div class="list-keyword">
                                    <div class="slim-scroll"></div>
                                </div>
                                <button class="btn btn-flat btn-block no-border btn-loadmore">See more keywords</button>
                            </div>
                            <div class="loading-box-label">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="box box-solid box-flat viral-keyword box-label" id="keyword-4">
                            <div class="box-header">
                                <h3 class="box-title text-bold">Tips</h3>
                            </div>
                            <div class="box-body">
                                <div class="list-keyword">
                                    <div class="slim-scroll"></div>
                                </div>
                                <button class="btn btn-flat btn-block no-border btn-loadmore">See more keywords</button>
                            </div>
                            <div class="loading-box-label">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="box box-solid box-flat viral-keyword box-label" id="keyword-5">
                            <div class="box-header">
                                <h3 class="box-title text-bold">Cerita</h3>
                            </div>
                            <div class="box-body">
                                <div class="list-keyword">
                                    <div class="slim-scroll"></div>
                                </div>
                                <button class="btn btn-flat btn-block no-border btn-loadmore">See more keywords</button>
                            </div>
                            <div class="loading-box-label">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>