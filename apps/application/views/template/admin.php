<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Idea Generator | <?php echo $title ?></title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <link rel="stylesheet" href="<?php echo base_url('bower_components/jquery-ui/themes/base/jquery-ui.css'); ?>">
  <link rel="stylesheet" href="<?php echo base_url('bower_components/bootstrap/dist/css/bootstrap.min.css'); ?>">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/font-awesome/css/all.min.css'); ?>">
  <!-- Ionicons -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/Ionicons/css/ionicons.min.css'); ?>">
  <!-- Theme style -->
  <link rel="stylesheet" href="<?php echo base_url('dist/css/AdminLTE.min.css'); ?>">
  <!-- iCheck -->
  <link rel="stylesheet" href="<?php echo base_url('plugins/iCheck/square/blue.css'); ?>">
  <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
        page. However, you can choose any other skin. Make sure you
        apply the skin class to the body tag so the changes take effect. -->
  <link rel="stylesheet" href="<?php echo base_url('dist/css/skins/skin-blue.min.css'); ?>">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

  <link rel="stylesheet" href="<?php echo base_url('styles/custom.css'); ?>">

  <!-- Google Font -->
  <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
</head>
<!--
BODY TAG OPTIONS:
=================
Apply one or more of the following classes to get the
desired effect
|---------------------------------------------------------|
| SKINS         | skin-blue                               |
|               | skin-black                              |
|               | skin-purple                             |
|               | skin-yellow                             |
|               | skin-red                                |
|               | skin-green                              |
|---------------------------------------------------------|
|LAYOUT OPTIONS | fixed                                   |
|               | layout-boxed                            |
|               | layout-top-nav                          |
|               | sidebar-collapse                        |
|               | sidebar-mini                            |
|---------------------------------------------------------|
-->
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  <!-- Main Header -->
  <header class="main-header">

    <!-- Logo -->
    <a href="<?php echo site_url(''); ?>" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>i</b>G</span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b>Idea</b>Generator</span>
    </a>

    <!-- Header Navbar -->
    <nav class="navbar navbar-static-top" role="navigation">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
        <span class="fa fa-bars"></span>
        <span class="sr-only">Toggle navigation</span>
      </a>
      <!-- Navbar Right Menu -->
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
          <?php
            $__hide_setting_button = $this->db->query("SELECT * FROM tbl_results WHERE DATE(updated) = DATE(NOW())")->num_rows();
            if(!$__hide_setting_button){
          ?>
          <li><a href="<?php echo base_url('setting/change_scraping_status'); ?>">Calculate Viral Dashboard</a></li>
          <?php } ?>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><?php echo $user['name']; ?> <span class="caret"></span></a>
            <ul class="dropdown-menu" role="menu">
              <li><a href="#">Change Password</a></li>
              <li class="divider"></li>
              <li><a href="<?php echo site_url('auth/logout') ?>">Sign Out</a></li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">

    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
      <!-- Sidebar Menu -->
      <ul class="sidebar-menu" data-widget="tree">
        <li class="header"><?php echo userType($user['user_type']); ?></li>
        <?php
        foreach ($menu as $navigation) {
            echo '<li class="'.($activeMenu == $navigation['uri'] ? 'active' : '').'">';
            echo '<a href="'.site_url($navigation['uri']).'">';
            echo '<i class="fa '.$navigation['icon'].'"></i>';
            echo '<span>'.$navigation['caption'].'</span>';
            echo '</a>';
            echo '</li>';
        }
        ?>
      </ul>
      <!-- /.sidebar-menu -->
    </section>
    <!-- /.sidebar -->
  </aside>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><?php echo $title ?></h1>
    </section>

    <!-- Main content -->
    <section class="content container-fluid">

      <!--------------------------
        | Your Page Content Here |
        -------------------------->
        <?php echo $this->session->flashdata('flash_msg'); ?>
        <?php echo ($content ? $content : ''); ?>

    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

  <!-- Main Footer -->
  <footer class="main-footer">
    <!-- Default to the left -->
    &copy; 2019 Focus On. All rights reserved.
  </footer>
</div>
<!-- ./wrapper -->

<!-- REQUIRED JS SCRIPTS -->

<!-- jQuery 3 -->
<script src="<?php echo base_url('bower_components/jquery/dist/jquery.min.js'); ?>"></script>
<!-- jQueryUI -->
<script src="<?php echo base_url('bower_components/jquery-ui/jquery-ui.min.js'); ?>"></script>
<!-- Bootstrap 3.3.7 -->
<script src="<?php echo base_url('bower_components/bootstrap/dist/js/bootstrap.min.js'); ?>"></script>
<!-- AdminLTE App -->
<script src="<?php echo base_url('dist/js/adminlte.min.js'); ?>"></script>
<!-- iCheck -->
<script src="<?php echo base_url('plugins/iCheck/icheck.min.js'); ?>"></script>
<?php
  foreach ($scripts as $src) {
    echo '<script src="'.base_url($src).'"></script>';
  }
?>
<script>

  $(document).ready(function(){
    $(".autocompleteNormalization").autocomplete({
        source: [],
        minLength: 0,
      }).keyup(function () {
        let q = $(this).val()
        let availableText = [];
        $(this).autocomplete({
          source: function (request, response) {
            jQuery.get("<?php echo base_url(); ?>normalization/get_normal_text_autocomplete?q="+q, {
              query: request.term
            }, function (data) {
              response(JSON.parse(data));
            });
          },
          minLength: 0,
        });
      });
  });

  $(function () {
    
    $('.iCheck').iCheck({
      checkboxClass: 'icheckbox_square-blue',
      radioClass: 'iradio_square-blue',
      increaseArea: '20%' /* optional */
    });

    $('.checkboxradio').checkboxradio({
      icon: false,
      classes: {
        "ui-checkboxradio-checked": "btn-default"
      }
    });

    $( ".draggable" ).draggable({
        revert: "invalid", // when not dropped, the item will revert back to its initial position
        containment: "document",
        helper: "clone",
        cursor: "move"
    });

    $( ".drop-target" ).droppable({
      accept: ".draggable",
      drop: function( event, ui ) {
        console.log(ui);
        // this.append("<input type='text' value='" + ui.draggable[0].innerText + "' disabled />");
        ui.draggable.appendTo( $(".box-body", this) );
        ui.draggable.addClass("btn-block");

        $( "input", ui.draggable ).val($(this).attr('id'));
        // $("<input type='text' value='" + ui.draggable[0].innerText + "' class='form-control' disabled />").appendTo( $(".box-body", this) );
        // ui.draggable.remove();
      }
    });
  });
</script>
<!-- Optionally, you can add Slimscroll and FastClick plugins.
     Both of these plugins are recommended to enhance the
     user experience. -->
</body>
</html>