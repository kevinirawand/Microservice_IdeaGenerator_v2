<link rel="stylesheet" href="<?php echo base_url('dist/css/datatables.min.css'); ?>">
<link rel="stylesheet" href="<?php echo base_url('dist/css/buttons.datatables.min.css'); ?>">

<style>
    table.dataTable tbody tr {
        background: transparent;
    }
    .dataTables_wrapper .dataTables_length, .dataTables_wrapper .dataTables_filter, .dataTables_wrapper .dataTables_info, .dataTables_wrapper .dataTables_processing, .dataTables_wrapper .dataTables_paginate {
        color: white;
    }
    .dataTables_wrapper .dataTables_paginate .paginate_button {
        color: white !important;
    }
    table.dataTable thead .sorting_asc {
      background: url("http://cdn.datatables.net/1.10.0/images/sort_asc.png") no-repeat center left;
    }
    table.dataTable thead .sorting_desc {
      background: url("http://cdn.datatables.net/1.10.0/images/sort_desc.png") no-repeat center left;
    }
    table.dataTable thead .sorting {
      background: url("http://cdn.datatables.net/1.10.0/images/sort_both.png") no-repeat center left;
    }
    .dataTables_filter {
        display: none;
    }
    button.dt-button, div.dt-button, a.dt-button, input.dt-button {
        color: white;
    }
</style>

<div class="content-wrapper">
    <section class="content" interval="<?php echo $interval; ?>">
		<p class="msg-not-counted" style="display: none; text-align: center; padding: 10px 5px; color: rgb(255, 200, 0); background-color: rgba(255, 200, 0, 0.2); border-radius: 3px;">
			Today, data has not been counted yet.
		</p>
        <div class="row">
            <div class="col-md-6">
                <div class="box box-solid box-top-sector">
                    <div class="box-header" style="padding: 12px;">
                        <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                            <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                            <!-- <span id="title_like_count">0</span> Likes -->
                            Sector Contribution
                        </h3>
                        <div class="box-tools pull-right" style="display: none;">
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
                        </div>
                    </div>
                    <div class="loading" style="display: none; position: absolute; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 2; margin-top: 12px;">
                        <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                    </div>
                    <!-- /.box-header -->
                    <!-- <div class="box-body" style="padding: 12px;">
                        <div id="chart-container">
                            <canvas class="chart" id="chart"></canvas>
                        </div>
                    </div> -->
                    <div class="box-body" style="padding: 12px;">
                        <div id="chart-container-sector">
                            <canvas class="chart" id="chart-sector"></canvas>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
            </div>
            <div class="col-md-6">
                <div class="box box-solid box-fair-score">
                    <div class="box-header" style="padding: 12px;">
                        <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                            <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                            Summary
                        </h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body" style="padding: 12px;">
                        <div class="row">
                            <div class="col-md-6" style="margin:15px auto">
                                <div class="info-box" style="background:#1e1e2a;">
                                    <span class="info-box-icon bg-info elevation-1"><i class="fas fa-clone"></i></span>

                                    <div class="info-box-content">
                                        <span id="detail_content_count" class="info-box-number" style="font-size:40px">
                                        0
                                        </span>
                                        <span class="info-box-text">Contents</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" style="margin:15px auto">
                                <div class="info-box" style="background:#1e1e2a;">
                                    <span class="info-box-icon bg-info elevation-1"><i class="fas fa-comment"></i></span>

                                    <div class="info-box-content">
                                        <span id="detail_comment_count" class="info-box-number" style="font-size:40px">
                                        0
                                        </span>
                                        <span class="info-box-text">Comments</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" style="margin:5px auto">
                                <div class="info-box" style="background:#1e1e2a;">
                                    <span class="info-box-icon bg-info elevation-1"><i class="fas fa-heart"></i></span>

                                    <div class="info-box-content">
                                        <span id="detail_like_count" class="info-box-number" style="font-size:40px">
                                        0
                                        </span>
                                        <span class="info-box-text">Likes</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" style="margin:5px auto">
                                <div class="info-box" style="background:#1e1e2a;">
                                    <span class="info-box-icon bg-info elevation-1"><i class="fas fa-cog"></i></span>

                                    <div class="info-box-content">
                                        <span id="detail_respon_avg" class="info-box-number" style="font-size:40px">
                                        0
                                        </span>
                                        <span class="info-box-text">Respons</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.box-body -->
                </div>
            </div>
        </div>
        
        <div class="box box-solid" style="background-color: transparent;">
            <div class="box-header no-padding">
                <table width="100%">
                    <tr>
                        <td style="width: 1%; white-space: nowrap; padding-right: 15px; line-height: 14px;">
                            <h3 class="box-title text-bold">
                                <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px; margin-left: 12px;" />
                                Detail Contributors
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
                            <input type="text" placeholder="Search" class="form-control no-border" style="color: white; background-color: transparent;" onkeyup="searchKeyUp(this)"/>
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
                    <div class="col-md-6">
                        <div class="box box-solid viral-keyword box-list-contributor" style="height: inherit;">
                            <div class="box-header" style="padding: 12px;">
                                <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                                    <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                                    List
                                </h3>
                            </div>
                            <div class="loading" style="display: none; position: absolute; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 2; margin-top: 12px;">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>
                            <div class="box-body" style="padding: 12px;">
                                <div id="keyword-source-container" style="height:530px">
                                    <div class="slim-scroll">
                                        <table id="table-list"></table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="box box-solid viral-keyword box-top-rangking" style="height: inherit;">
                            <div class="box-header" style="padding: 12px;">
                                <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                                    <img src="<?php echo base_url('dist/image/icon-circle-green.png') ?>" height="24px" style="margin-right: 12px;" />
                                    Major
                                </h3>
                            </div>
                            <div class="loading" style="display: none; position: absolute; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 2; margin-top: 12px;">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>
                            <div class="box-body" style="padding: 12px;">
                                <div id="keyword-source-container">
                                    <div class="slim-scroll">
                                        <table id="table-top"></table>
                                    </div>
                                    <!-- <ul class="products-list product-list-in-box slim-scroll" id="list-sumber"></ul> -->
                                </div>
                            </div>
                        </div>
                        <div class="box box-solid viral-keyword box-least-rangking" style="height: inherit;">
                            <div class="box-header" style="padding: 12px;">
                                <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                                    <img src="<?php echo base_url('dist/image/icon-circle-red.png') ?>" height="24px" style="margin-right: 12px;" />
                                    Minor
                                </h3>
                            </div>
                            <div class="loading" style="display: none; position: absolute; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 2; margin-top: 12px;">
                                <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                            </div>
                            <div class="box-body" style="padding: 12px;">
                                <div id="keyword-source-container">
                                    <div class="slim-scroll">
                                        <table id="table-least"></table>
                                    </div>
                                    <!-- <ul class="products-list product-list-in-box slim-scroll" id="list-sumber"></ul> -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>