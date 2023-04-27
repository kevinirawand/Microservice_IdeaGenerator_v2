<div class="content-wrapper" id="cw">
    <section class="content">
        <div class="box box-solid" style="background-color: transparent; box-shadow: none;">
            <div class="box-header" style="padding: 12px;">
                <h3 class="box-title text-bold" style="font-size: 18px; line-height: 21px;">
                    <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                    Keyword Cycle
                </h3>
            </div>
            <!-- /.box-header -->
            <div class="box-body no-padding">
                <?php foreach ($days as $key => $day) { ?>
                    <div class="pattern-panel-day">
                        <div style="<?php if( $current_dow == $key + 1) echo 'border-color: #15b4c3;'; ?>">
                            <h4 style="border-color: #15b4c3;"><?php echo $day; ?></h4>
                            <div class="pattern-panel-day-content">
                                <div class="slim-scroll">
                                    <ul>
                                        <?php 
                                            if (isset($keyword_cycle[$key + 1]))
                                            foreach($keyword_cycle[$key + 1] as $row) {
                                                echo '<a href="#" dow="'.$row['dow'].'" id_label="'.$row['id_label'].'">';
                                                echo '<li>'.$row['normal_text'].'</li>';
                                                echo '</a>';
                                            }
                                        ?>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                <?php } ?>
            </div>
            <!-- /.box-body -->
        </div>

        <div class="box box-solid" style="background-color: transparent; box-shadow: none;">
            <div class="box-header pattern-source-header" style="padding: 12px;">
                <table width="100%">
                    <tr>
                        <td style="width: 1%; white-space: nowrap; padding-right: 15px; line-height: 14px;">
                            <h3 class="box-title text-bold">
                                <img src="<?php echo base_url('dist/image/icon-circle.png') ?>" height="24px" style="margin-right: 12px;" />
                                Source : <span style="color: #15b4c3;"><?php echo date("l"); ?></span>
                            </h3>
                        </td>
                        <td>
                            <hr style="border-color: #15b4c3;"/>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="box-body no-padding">
                <div class="pattern-panel-source">
                    <div>
                        <div class="slim-scroll">
                            <div class="row"></div>
                        </div>
                    </div>
                    <div class="loading" style="display: none; margin-top: -267px; width: 100%; justify-content: center; background-color: rgba(30,30,40,0.5); position: relative;">
                        <div style="align-self: center;" class="lds-facebook"><div></div><div></div><div></div></div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>