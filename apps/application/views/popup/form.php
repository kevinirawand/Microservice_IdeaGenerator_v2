<div class="row">
    <div class="col-md-7">

<div class="box">
    <!-- <div class="box-header">
        <h3 class="box-title">Create .XLSX FAIR Report</h3>
    </div> -->
    <div class="box-body">
        
                <form id="form" class="form-horizontal" action="#" method="post">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">Active</label>
                        <div class="col-sm-9 control-label" style="text-align: left;">
                            <input type="checkbox" name="iactive" value="1" <?php if($popup['active']) echo 'checked' ?> />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            Title
                        </label>
                        <div class="col-sm-9">
                            <input type="text" name="ititle" class="form-control" placeholder="- Header Title -" value="<?php echo $popup['title']; ?>" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            Message
                        </label>
                        <div class="col-sm-9">
                            <textarea name="imessage" rows="5" class="form-control" placeholder="- Body Messages -"><?php echo $popup['message']; ?></textarea>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Save</button>
                </form>
        
    </div>
</div>

</div>
</div>