<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Idea Generator | <?php echo $title ?></title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <link rel="shortcut icon" href="<?php echo base_url('dist/image/logo.png'); ?>">
  <!-- Bootstrap 3.3.7 -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/bootstrap/dist/css/bootstrap.min.css'); ?>">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/font-awesome/css/font-awesome.min.css'); ?>">
  <!-- Ionicons -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/Ionicons/css/ionicons.min.css'); ?>">
  <!-- Theme style -->
  <link rel="stylesheet" href="<?php echo base_url('dist/css/AdminLTE.min.css'); ?>">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="<?php echo base_url('dist/css/skins/skin-custom.css'); ?>">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

  <!-- Google Font -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">

  <link rel="stylesheet" href="<?php echo base_url('dist/css/client2.css'); ?>">
</head>
<body class="hold-transition skin-green fixed sidebar-mini" style="height: auto; min-height: 100%;">
<!-- Site wrapper -->
<div class="wrapper" style="height: auto; min-height: 100%;">

  <header class="main-header">
    <div class="logo" style="text-align: left; padding-left: 14px;" data-toggle="push-menu" role="button">
      <!-- <i class="fa fa-bars"></i> -->
      <img src="<?php echo base_url('dist/image/icon-menu.png') ?>" height="25px" style="margin-top: -4px;" />
      <span class="logo-lg" style="margin-left: 3px; display: inline-block;">DASHBOARD</span>
    </div>
    <!-- Logo -->
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top row">
      <!-- Sidebar toggle button-->
        <!-- <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </a> -->
      <a href="<?php echo site_url(''); ?>" class="navbar-brand col-sm-4" style="font-size: 20px;"><b>IDEA</b> GENERATOR</a>
      <div class="col-sm-4 user-active"><i class="fa fa-circle"></i> <?php echo $user['name']; ?></div>
      <div class="navbar-custom-menu">
      </div>
    </nav>
  </header>

  <!-- =============================================== -->

  <!-- Left side column. contains the sidebar -->
  <aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu" data-widget="tree">
        <?php
        foreach ($menu as $navigation) {
            

            if (isset($navigation['submenu'])) {
              $menuactive = (strtolower($this->uri->segment(1)) == $navigation['uri']);
              echo '<li class="treeview '.($menuactive ? 'active' : '').'">';
              echo '<a href="#">';
              echo '<i class="fa">';
              echo '<img src="'.base_url($navigation['icon']).'" width="20px" />';
              // echo '<i class="fa '.$navigation['icon'].'"></i>';
              echo '</i>';
              echo '<span style="margin-left: 7px;">'.$navigation['caption'].'</span>';
              echo '<span class="pull-right-container">';
              echo '<i class="fa fa-angle-left pull-right"></i>';
              echo '</span>';
              echo '<ul class="treeview-menu">';
              foreach ($navigation['submenu'] as $submenu) {
                $subactive = ($menuactive && strtolower($this->uri->segment(2)) == $submenu['uri']);
                echo '<li class="'.($subactive ? 'active' : '').'">';
                echo '<a href="'.site_url($navigation['uri'].'/'.$submenu['uri']).'">';
                echo '<i class="fa '.$submenu['icon'].'"></i> '.$submenu['caption'];
                echo '</a>';
                echo '</li>';
              }
              echo '</ul>';
              echo '</a>';
              echo '</li>';
            }
            else {
              echo '<li class="'.($activeMenu == $navigation['uri'] ? 'active' : '').'">';
              echo '<a href="'.site_url($navigation['uri']).'">';
              // echo '<i class="fa '.$navigation['icon'].'"></i>';
              echo '<i class="fa">';
              echo '<img src="'.base_url($navigation['icon']).'" width="20px" />';
              echo '</i>';
              echo '<span style="margin-left: 7px;">'.$navigation['caption'].'</span>';
              echo '</a>';
              echo '</li>';
            }
        }
        ?>
      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>

  <!-- =============================================== -->

  <!-- Content Wrapper. Contains page content -->
  <?php echo ($content ? $content : ''); ?>

  <!-- <footer class="main-footer">
    <div class="pull-right hidden-xs">
      <b>Version</b> 2.0.0
    </div>
    &copy; 2019 Focus On. All rights reserved.
  </footer> -->

</div>
<!-- ./wrapper -->

<!-- jQuery 3 -->
<script src="<?php echo base_url('bower_components/jquery/dist/jquery.min.js'); ?>"></script>
<!-- jQueryUI -->
<script src="<?php echo base_url('bower_components/jquery-ui/jquery-ui.min.js'); ?>"></script>
<!-- Bootstrap 3.3.7 -->
<script src="<?php echo base_url('bower_components/bootstrap/dist/js/bootstrap.min.js'); ?>"></script>
<!-- SlimScroll -->
<script src="<?php echo base_url('bower_components/jquery-slimscroll/jquery.slimscroll.min.js'); ?>"></script>
<!-- FastClick -->
<script src="<?php echo base_url('bower_components/fastclick/lib/fastclick.js'); ?>"></script>
<!-- AdminLTE App -->
<script src="<?php echo base_url('dist/js/adminlte.min.js'); ?>"></script>
<!-- ChartJS -->
<script src="<?php echo base_url('bower_components/chart.js/Chart.js'); ?>"></script>
<script>
  $(document).ready(function () {
    $('.sidebar-menu').tree()
  })
</script>
<?php
  foreach ($scripts as $src) {
    echo '<script src="'.base_url($src).'"></script>';
  }
?>
</body>
</html>
