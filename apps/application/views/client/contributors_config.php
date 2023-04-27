<link rel="stylesheet" href="<?php echo base_url('dist/css/datatables.min.css'); ?>">

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
</style>

<div class="content-wrapper">
    <section class="content" interval="<?php echo $interval; ?>">
        <div class="row">
            <div class="col-md-6">
                <div class="box box-solid viral-keyword box-top-rangking" style="height: inherit;">
                    <div class="box-header" style="padding: 12px;">
                        <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                            <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                            Contributor List
                        </h3>
                        <div class="box-tools pull-right">
                            <div id="input-search" class="input-group" style="border-radius: 10px; border: 1px solid #15b4c3; overflow: hidden;">
                                <input type="text" placeholder="Search" class="form-control no-border" style="color: white; background-color: transparent;" onkeyup="searchKeyUp(this)"/>
                            </div>
                        </div>
                    </div>
                    <div class="loading" style="display: none; position: absolute; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 2; margin-top: 12px;">
                        <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                    </div>
                    <div class="box-body" style="padding: 12px;">
                        <div id="keyword-source-container" style="height: 75vh;">
                            <div class="slim-scroll">
                                <table id="table-config">
                                    <thead>
                                        <tr>
                                            <th>Name</th>
                                            <th>IG Username</th>
                                            <th>Sector</th>
                                            <th>Action</th>
                                            <th style="display:none;">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php 
                                        foreach ($table as $key => $row){
                                        echo '
                                        <tr onclick="onRowClick(this)" style="cursor:pointer;">
                                            <td>'. $row->name .'</td>
                                            <td>'.$row->ig_username.'</td>
                                            <td>'.$row->bidang.'</td>
                                            <td>'
                                            . '<a href="./remove/'.$row->ig_username.'" onclick="return confirm(\'Are you sure?\')" class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: center; line-height: 32px; font-weight: bold;">'
                                            .'<span><i class="fas fa-trash"></i></span> '
                                            . '</a></td>
                                            <td style="display:none;">'.$row->contributor_id.'</td>
                                            </tr>
                                        ';
                                        }
                                        ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
            <div class="box box-solid viral-keyword box-least-rangking" style="height: inherit;">
                    <div class="box-header" style="padding: 12px;">
                        <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                            <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                            Add New Contributor
                        </h3>
                    </div>
                    <div class="loading" style="display: none; position: absolute; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); z-index: 2; margin-top: 12px;">
                        <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                    </div>
                    <div class="box-body" style="padding: 12px;">
                    <form action="" method="post">
                        <?php
                        if (isset($row_data['contributor_id']))
                        {
                            echo '<input type="hidden" name="contributor_id" value="'.$row_data['contributor_id'].'">';
                        }
                        ?>
                        <div class="box-body">
                            <div class="form-group">
                                <label>Name</label>
                                <input style="background-color:#1e1e2a;color:#ffffff;" type="text" name="name" class="form-control" value="<?php echo $row_data['name']; ?>" placeholder="Enter contributor name" required />
                                <?php echo form_error('ig_username'); ?>
                            </div>
                            <div class="form-group">
                                <label>IG Username</label>
                                <input style="background-color:#1e1e2a;color:#ffffff;" type="text" name="ig_username" class="form-control" value="<?php echo $row_data['ig_username']; ?>" placeholder="Enter an Instagram account username" required />
                                <?php echo form_error('ig_username'); ?>
                            </div>
                            <div class="form-group">
                                <label>Sector</label>
                                <select name="bidang" class="form-control" required style="color:white;background:#1e1e2a;">
                                    <?php
                                    foreach ($sectors as $value) {
                                        echo '<option value="'.$value['bidang'].'">'.$value['bidang'].'</option>';
                                    }
                                    ?>
                                </select>
                                <?php echo form_error('bidang'); ?>
                            </div>
                            <input type="hidden" name="user_id" value="<?php echo $user_id; ?>" />
                        </div>
                        <div class="box-footer" style="background-color:#1e1e2a;border:none;">
                            <button type="submit" class="btn btn-primary">Save</button>
                        </div>
                    </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
