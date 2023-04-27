<div class="content-wrapper" id="self-performance">
    <section class="content" interval="<?php echo $interval; ?>">
        <div class="row">
            <div class="col-md-8">
                <div class="box box-solid">
                    <div class="box-header" style="padding: 12px;">
                        <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                            <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                            Follower & Interaction
                        </h3>
                        <div class="box-tools pull-right" style="line-height: 24px;">
                            <?php if ($interval == 'daily') { ?>
                            <!-- month picker -->
                              <div class="btn-group">
                              <button type="button" class="btn btn-sm dropdown-toggle text-bold" data-toggle="dropdown">
                                    <span id="target-anchor">Select Target</span>&nbsp; <i class="fa fa-caret-down"></i>
                                </button>
                                <ul class="dropdown-menu pull-right" role="menu" style="max-height: 350px; overflow-y: scroll;" id="target-container">
                                 <!-- TARGET CONTENT -->
                                </ul>
                              </div>


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
                            <span class="spacer"></span>
                            <span class="small"><i class="fa fa-circle" style="color: #0ED1D6;"></i> Follower</span>
							<span class="spacer"></span>
							<span class="small"><i class="fa fa-circle" style="color: #D58F51;"></i> Interaction</span>
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
            <div class="col-md-4">
                <div class="box box-solid viral-keyword box-source-like" style="height: inherit;">
                    <div class="box-header" style="padding: 12px;">
                        <h4 class="box-title" style="font-size: 14px; line-height: 24px;">
							Source
						</h4>
						<div class="pull-right small" style="line-height: 24px;">
							<span><i class="fa fa-circle" style="color: green"></i> High</span>
							<span class="spacer"></span>
							<span><i class="fa fa-circle" style="color: red"></i> Low</span>
							<span class="spacer"></span>
							<span><i class="fa fa-circle" style="color: white"></i> Normal</span>
						</div>
                    </div>
                    <div id="loading-source" style="display: none; position: absolute; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 2; margin-top: 12px;">
                        <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                    </div>
                    <div class="box-body" style="padding: 12px;">
                        <div id="keyword-source-container">
                            <ul class="products-list product-list-in-box slim-scroll">
                                <!-- LIST -->
							</ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

		<div class="row">
			<div class="col-xs-12" style="margin-bottom: 20px;">
				<hr style="border-color: #15b4c3;"/>
			</div>
		</div>
		
		<div class="row">
            <div class="col-md-8">
                <div class="box box-solid box-gauge">
                    <div class="box-header" style="padding: 12px;">
                        <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                            <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                            Activity & Responsiveness
                        </h3>
                        <div class="box-tools pull-right">
                            <!-- month picker for monthly -->
                            <div class="btn-group" id="month-picker2">
                                <input type="text" name="selected_month" style="display: none;" />
                            </div>

                            <!-- date picker for daily -->
							<input type="input" id="hiddenField" class="datepicker" onchange="onDateChange()" style="display: none;" />
                        </div>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body" style="padding: 12px;">
                        <div class="row">
							<div class="col-md-6 gauge-activity">
								<div class="speedometer" onClick="getSourceActivity()">
                                    <img src="<?php echo base_url('dist/image/gauge_hand.svg') ?>" class="gauge-hand" />
								</div>
								<div>
									AVERAGE ACTIVITY
								</div>
								<div>
									<span class="small"><i class="fa fa-circle" style="color: #e73031;"></i> Pasive</span>
									<span class="spacer"></span>
									<span class="small"><i class="fa fa-circle" style="color: #37b34a;"></i> Active</span>
									<span class="spacer"></span>
									<span class="small"><i class="fa fa-circle" style="color: #e73031;"></i> Over Active</span>
								</div>
							</div>
							<div class="col-md-6 gauge-responsiveness">
								<div class="speedometer" onClick="getSourceActivity()">
									<!-- <img src="<?php echo base_url('dist/image/responsiveness/responsiveness-0.svg') ?>" id="gauge-responsiveness" onClick="getSourceActivity()" /> -->
                                    <img src="<?php echo base_url('dist/image/gauge_hand.svg') ?>" class="gauge-hand" />
								</div>
								<div>
									AVERAGE RESPONSIVENESS
								</div>
								<div>
									<span class="small"><i class="fa fa-circle" style="color: #e73031;"></i> Low</span>
									<span class="spacer"></span>
									<span class="small"><i class="fa fa-circle" style="color: #f9ec31;"></i> Medium</span>
									<span class="spacer"></span>
                                    <span class="small"><i class="fa fa-circle" style="color: #006837;"></i> High</span>
								</div>
							</div>
						</div>
                    </div>
                    <!-- /.box-body -->
                </div>
            </div>
            <div class="col-md-4" style="">
                <div class="box box-solid viral-keyword box-source-activity" style="height: inherit;">
                    <div class="box-header" style="padding: 12px;">
                        <h4 class="box-title" style="font-size: 14px; line-height: 24px;">
							Activity
						</h4>
						<h4 class="box-title" style="font-size: 14px; line-height: 24px; float: right; margin: 0 4px;">
							Responsiveness
						</h4>
                    </div>
                    <div id="loading-source" style="display: none; position: absolute; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 2; margin-top: 12px;">
                        <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                    </div>
                    <div class="box-body" style="padding: 12px;">
                        <div id="keyword-source-container">
                            <ul class="products-list product-list-in-box slim-scroll" id="list-sumber">
                            <!--
                                <a href="#" target="_blank" class="box-keyword svg-green" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            80 %
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="color: white;">Sun May 03 2020</span>
                                            <span class="product-description">Time 07.30</span>
                                        </div>
                                    </li>
                                </a>
								<a href="#" target="_blank" class="box-keyword svg-red" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            70 %
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="color: white;">Sun May 03 2020</span>
                                            <span class="product-description">Time 07.30</span>
                                        </div>
                                    </li>
                                </a>
								<a href="#" target="_blank" class="box-keyword svg-yellow" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            60 %
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="color: white;">Sun May 03 2020</span>
                                            <span class="product-description">Time 07.30</span>
                                        </div>
                                    </li>
                                </a>
								<a href="#" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            50 %
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="color: white;">Sun May 03 2020</span>
                                            <span class="product-description">Time 07.30</span>
                                        </div>
                                    </li>
                                </a>
								<a href="#" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            40 %
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="color: white;">Sun May 03 2020</span>
                                            <span class="product-description">Time 07.30</span>
                                        </div>
                                    </li>
                                </a>
								<a href="#" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            30 %
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="color: white;">Sun May 03 2020</span>
                                            <span class="product-description">Time 07.30</span>
                                        </div>
                                    </li>
                                </a>
								<a href="#" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            20 %
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="color: white;">Sun May 03 2020</span>
                                            <span class="product-description">Time 07.30</span>
                                        </div>
                                    </li>
                                </a>
								<a href="#" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            10 %
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="color: white;">Sun May 03 2020</span>
                                            <span class="product-description">Time 07.30</span>
                                        </div>
                                    </li>
                                </a>
								<a href="#" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            5 %
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="color: white;">Sun May 03 2020</span>
                                            <span class="product-description">Time 07.30</span>
                                        </div>
                                    </li>
                                </a>
								<a href="#" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">
                                    <li class="item">
                                        <div class="product-img">
                                            <img src="<?php echo base_url('dist/image/instagram.svg') ?>" style="height: 32px; width: 32px;" />
                                        </div>
										<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">
                                            1 %
                                        </div>
                                        <div class="product-info" style="margin-left: 44px;">
                                            <span class="product-title" style="color: white;">Sun May 03 2020</span>
                                            <span class="product-description">Time 07.30</span>
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

    </section>
</div>