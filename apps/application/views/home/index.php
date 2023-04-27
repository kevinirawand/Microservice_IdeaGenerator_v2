<div class="content-wrapper">
    <img src="<?php echo base_url('dist/image/logo-focus-on.png') ?>" width="300px" style="position: absolute; top: 50%; right: 50%; transform: translate(50%, -50%);" />
</div>

<?php if ($popup['active']) { ?>
    <div id="popup-dialog" title="<?php echo $popup['title'] ?>">
        <p><?php echo $popup['message'] ?></p>
    </div>
<?php } ?>