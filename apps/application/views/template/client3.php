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
  <link rel="stylesheet" href="<?php echo base_url('bower_components/jquery-ui/themes/base/jquery-ui.css'); ?>">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/font-awesome/css/all.min.css'); ?>">
  <!-- Ionicons -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/Ionicons/css/ionicons.min.css'); ?>">
  <!-- Theme style -->
  <link rel="stylesheet" href="<?php echo base_url('dist/css/AdminLTE.min.css'); ?>">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/jquery-ui-month-picker/demo/MonthPicker.min.css'); ?>" type="text/css" />
  <link rel="stylesheet" href="<?php echo base_url('dist/css/skins/skin-custom.css'); ?>">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

  <!-- Google Font -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">

  <link rel="stylesheet" href="<?php echo base_url('dist/css/client3.css'); ?>">

  <script type="text/javascript">
    window.BASE_URL = "<?php echo base_url(); ?>";
  </script>
</head>
<body class="hold-transition skin-green sidebar-mini" style="height: auto; min-height: 100%;">

  <!-- REMEMBER SIDEBAR STATE -->
  <script>
    (function () {
      if (Boolean(sessionStorage.getItem('sidebar-toggle-collapsed'))) {
        var body = document.getElementsByTagName('body')[0];
        body.className = body.className + ' sidebar-collapse';
      }
    })();
  </script>


<!-- Site wrapper -->
<div class="wrapper" style="height: auto; min-height: 100%;">

  <header class="main-header">
    <div class="logo" style="text-align: left;" data-toggle="push-menu" role="button">
      <!-- <i class="fa fa-bars"></i> -->
      <img src="<?php echo base_url('dist/image/02-Home/icon_sidebar.svg') ?>"/>
      <span class="logo-lg"><b>IDEA</b>GENERATOR</span>
    </div>
    <!-- Logo -->
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
      <!-- <a href="<?php echo site_url(''); ?>" class="navbar-brand col-sm-4" style="font-size: 20px;"><b>IDEA</b> GENERATOR</a>
      <div class="col-sm-4 user-active"><i class="fa fa-circle"></i> <?php echo $user['name']; ?></div>
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
            <li>
                <a href="<?php echo site_url('auth/logout') ?>" class="btn">Sign Out</a>
            </li>
        </ul>
      </div> -->
        <div class="navbar-header">
            <span class="fa fa-circle" style="height: 40px; width: 40px; text-align: center; line-height: 40px; color: #15b4c3;"></span>
            <span class="navbar-brand"><?php echo $user['name']; ?></span>
            <span id="userIG" class="hide"><?php echo $user['ig_username']; ?></span>
        </div>

        <div class="navbar-custom-menu">
            <!-- <form class="navbar-form navbar-right" role="search"> -->
                <!-- <div class="navbar-form navbar-right"> -->
                    <a href="<?php echo site_url('auth/logout') ?>" class="btn btn-logout">Logout</a>
                <!-- </div> -->
            <!-- </form> -->
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
              echo '<img src="'.base_url($navigation['icon']).'" />';
              // echo '<i class="fa '.$navigation['icon'].'"></i>';
              echo '<span>'.$navigation['caption'].'</span>';
              // echo '<span class="pull-right-container">';
              // echo '<i class="fa fa-angle-left pull-right"></i>';
              // echo '</span>';
              echo '<ul class="treeview-menu">';
              foreach ($navigation['submenu'] as $submenu) {
                $subactive = ($menuactive && strtolower($this->uri->segment(2)) == $submenu['uri']);
                echo '<li class="'.($subactive ? 'active' : '').'">';
                echo '<a href="'.site_url($navigation['uri'].'/'.$submenu['uri']).'" class="sidebar-menu">';
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
              
              echo '<img src="'.base_url($navigation['icon']).'" />';
              
              echo '<span>'.$navigation['caption'].'</span>';
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
  <!-- <main id="content">
    <div class="content-wrapper"></div>
  </main> -->

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
<!-- Bootstrap 3.3.7 -->
<script src="<?php echo base_url('bower_components/bootstrap/dist/js/bootstrap.min.js'); ?>"></script>
<!-- jQueryUI -->
<script src="<?php echo base_url('bower_components/jquery-ui/jquery-ui.min.js'); ?>"></script>
<!-- SlimScroll -->
<script src="<?php echo base_url('bower_components/jquery-slimscroll/jquery.slimscroll.min.js'); ?>"></script>
<!-- FastClick -->
<script src="<?php echo base_url('bower_components/fastclick/lib/fastclick.js'); ?>"></script>
<!-- AdminLTE App -->
<script src="<?php echo base_url('dist/js/adminlte.min.js'); ?>"></script>
<!-- ChartJS -->
<script src="<?php echo base_url('bower_components/chart.js/Chart.js'); ?>"></script>

<script src="<?php echo base_url('dist/js/common.js'); ?>"></script>
<script>
  $(document).ready(function () {
    $('.sidebar-menu').tree();

    $('.logo').click(function(event) {
      event.preventDefault();
      if (Boolean(sessionStorage.getItem('sidebar-toggle-collapsed'))) {
        sessionStorage.setItem('sidebar-toggle-collapsed', '');
      } else {
        sessionStorage.setItem('sidebar-toggle-collapsed', '1');
      }
    });
    
    $('.slim-scroll').slimScroll({
        height: '100%'
    });        
  })
</script>
<?php
  foreach ($scripts as $src) {
    echo '<script src="'.base_url($src).'"></script>';
  }
?>
</body>
</html>
