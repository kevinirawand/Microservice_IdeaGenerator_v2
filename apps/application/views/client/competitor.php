<div class="content-wrapper">
    <section class="content" interval="<?php echo $interval; ?>">
		<p class="msg-not-counted" style="display: none; text-align: center; padding: 10px 5px; color: rgb(255, 200, 0); background-color: rgba(255, 200, 0, 0.2); border-radius: 3px;">
			Today, data has not been counted yet.
		</p>
        <div class="row">
            <div class="col-md-8">
                <div class="box box-solid box-fair-score">
                    <div class="box-header" style="padding: 12px;">
                        <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                            <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                            FAIR Score
                        </h3>
                        <div class="box-tools pull-right">
                            <?php if ($interval == 'daily') { ?>
                            <!-- month picker -->
                            <div class="btn-group" id="month-picker">
                                <input type="text" name="selected_month" style="display: none;" />
                            </div>
                            <?php } else { ?>
                            <!-- button with a dropdown -->
                            <div class="btn-group" id="dropdown-year">
                                <button type="button" class="btn btn-sm dropdown-toggle text-bold" data-toggle="dropdown">
                                    Data Records &nbsp; <i class="fa fa-caret-down"></i>
                                </button>
                                <ul class="dropdown-menu pull-right" role="menu" style="max-height: 350px; overflow-y: scroll;">
                                <?php
                                    for ($i=0; $i < 10; $i++) {
                                        $year = date("Y") - $i;
                                        $selected = $year == date("Y") ? 'class="selected"' : '';
                                        echo '<li><a href="#" '.$selected.'>';
                                        echo $year;
                                        echo '</a></li>';
                                    }
                                ?>
                                </ul>
                            </div>
                            <?php } ?>
                            <!-- button with a dropdown -->
                            <div class="btn-group" id="dropdown-competitors">
                                <button type="button" class="btn btn-sm dropdown-toggle text-bold" data-toggle="dropdown">
                                    Hide/Show Competitors &nbsp; <i class="fa fa-caret-down"></i>
                                </button>
                                <ul class="dropdown-menu pull-right" role="menu" style="max-height: 350px; overflow-y: scroll;">
                                <!--
									<li><a href="#">
										<span class="fa fa-square" style="color: #0ED1D6"></span>
										Humas Jabar
									</a></li>
                                -->
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
                <div class="box box-solid viral-keyword box-top-rangking" style="height: inherit;">
                    <div class="box-header" style="padding: 12px;">
                        <h4 class="box-title" style="font-size: 14px; line-height: 24px;">
							Top Ranking
						</h4>
						<h4 class="box-title" style="font-size: 14px; line-height: 24px; float: right; margin: 0 4px;">
							Score
						</h4>
                    </div>
                    <div class="loading" style="display: none; position: absolute; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 2; margin-top: 12px;">
                        <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                    </div>
                    <div class="box-body" style="padding: 12px;">
                        <div id="keyword-source-container">
                            <ul class="products-list product-list-in-box slim-scroll" id="list-sumber">
                            <!--
                                <a href="#" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/bintang.svg') ?>" alt="" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            80
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="font-weight: normal;">Humas Jabar</span>
                                            <span class="product-description" style="font-size: 10px; line-height: 11px; color: #15b4c3;">https://www.instagram.com/p/B9IQtJbH8cy</span>
                                        </div>
                                    </li>
                                </a>
                            -->
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="box box-solid box-fair" style="background-color: transparent; box-shadow: none;">
            <div class="box-header" style="padding: 12px;">
                <table width="100%">
                    <tr>
                        <td style="width: 1%; white-space: nowrap; padding-right: 15px; line-height: 14px;">
                            <h3 class="box-title text-bold">
                                <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                                Fair
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
                    <div class="col-md-3">
                        <div class="box box-solid box-flat viral-keyword box-follower">
                            <div class="box-header">
                                <h3 class="box-title text-bold" style="white-space: nowrap; overflow: hidden;">Follower</h3>
                            </div>
                            <div class="box-body">
                                <div class="list-keyword">
                                    <div class="slim-scroll">
                                    <!--
                                        <div class="box-keyword">
                                            <div class="keyword">Humas Jabar</div>
                                            <table>
                                                <tr>
                                                    <td class="progress progress-flat">
                                                        <div class="progress-bar" style="width: 90%; background-color: #0ED1D6;"></div>
                                                    </td>
                                                    <td class="value-keyword">
                                                        11321
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
					<div class="col-md-3">
                        <div class="box box-solid box-flat viral-keyword box-activity">
                            <div class="box-header">
                                <h3 class="box-title text-bold" style="white-space: nowrap; overflow: hidden;">Activity</h3>
                            </div>
                            <div class="box-body">
                                <div class="list-keyword">
                                    <div class="slim-scroll">
									<!--
                                        <div class="box-keyword">
                                            <div class="keyword">Humas Jabar</div>
                                            <table>
                                                <tr>
                                                    <td class="progress progress-flat">
                                                        <div class="progress-bar" style="width: 90%; background-color: #D58F51;"></div>
                                                    </td>
                                                    <td class="value-keyword">
                                                        5.2/Day
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
									-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
					<div class="col-md-3">
                        <div class="box box-solid box-flat viral-keyword box-interaction">
                            <div class="box-header">
                                <h3 class="box-title text-bold" style="white-space: nowrap; overflow: hidden;">Interaction</h3>
                            </div>
                            <div class="box-body">
                                <div class="list-keyword">
                                    <div class="slim-scroll">
									<!--
                                        <div class="box-keyword">
                                            <div class="keyword">Humas Jabar</div>
                                            <table>
                                                <tr>
                                                    <td class="progress progress-flat">
                                                        <div class="progress-bar" style="width: 90%; background-color: #603CD6;"></div>
                                                    </td>
                                                    <td class="value-keyword">
                                                        1000/Post
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
									-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
					<div class="col-md-3">
                        <div class="box box-solid box-flat viral-keyword box-responsiveness">
                            <div class="box-header">
                                <h3 class="box-title text-bold" style="white-space: nowrap; overflow: hidden;">Responsiveness</h3>
                            </div>
                            <div class="box-body">
                                <div class="list-keyword">
                                    <div class="slim-scroll">
									<!--
                                        <div class="box-keyword">
                                            <div class="keyword">Humas Jabar</div>
                                            <table>
                                                <tr>
                                                    <td class="progress progress-flat">
                                                        <div class="progress-bar" style="width: 90%; background-color: #EB5757;"></div>
                                                    </td>
                                                    <td class="value-keyword">
                                                        89%
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
									-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>