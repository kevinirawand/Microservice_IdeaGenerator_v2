<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Idea Generator | Log in</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- Bootstrap 3.3.7 -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/bootstrap/dist/css/bootstrap.min.css'); ?>">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/font-awesome/css/font-awesome.min.css'); ?>">
  <!-- Ionicons -->
  <link rel="stylesheet" href="<?php echo base_url('bower_components/Ionicons/css/ionicons.min.css'); ?>">
  <!-- Theme style -->
  <link rel="stylesheet" href="<?php echo base_url('dist/css/AdminLTE.min.css'); ?>">
  <!-- iCheck -->
  <link rel="stylesheet" href="<?php echo base_url('plugins/iCheck/square/blue.css'); ?>">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

  <!-- Google Font -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
</head>
<body class="hold-transition" style="background-color: #1E1E2A;">
<div class="container">
    <div class="row" style="padding: 5%;">
        <div class="col-sm-6">
            <img src="<?php echo base_url("dist/image/logo.png") ?>" height="60px" />
            <span style="font-size: 22pt; color: white; margin-left: 10px;">
                FOCUS<b>ON</b>
            </span>
        </div>
        <div class="col-sm-6" style="text-align: right;">
            <span style="font-size: 40pt; color: white;">
            <b>IDEA</b> GENERATOR
            </span>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12">
        <?php
            if ($alert)
            {
                echo '<p class="alert alert-danger">';
                echo $alert;
                echo '</p>';
            }
        ?>
        </div>
    </div>
    <div class="row" style="padding: 5%;">
        <div class="col-sm-6">
            <div style="font-size: 50pt; color: white; font-weight: bold; line-height: 60pt;">
                Faster<br/>Your Idea<br/>Today
            </div>
            <div style="width: 180px; height: 20px; background-color: white; margin-top: 5%;"></div>
            <div style="font-size: 15pt; color: white; margin: 5% 0;">
                With Idea Generator V.0.2 you can get daily fresh idea<br/>and tracking your competitor performance also forecast<br/>your idea weekly.
            </div>
        </div>
        <div class="col-sm-6" style="text-align: right;">
            <div style="width: 75%; background-color: white; border-radius: 25px; margin-left: auto;">
            <?php echo form_open('login'); ?>
                <div style="padding: 5% 10%;">
                    <div style="width: 130px; height: 130px; border-radius: 100%; border: 1px solid silver; margin: 0 auto 5% auto;"></div>
                    <div class="form-group has-feedback">
                      <input name="username" type="email" class="form-control" placeholder="Email" style="border-width: 0 0 2px 0; padding: 15px 40px 20px 10px; font-size: 14pt;">
                      <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
                    </div>
                    <div class="form-group has-feedback">
                      <input name="password" type="password" class="form-control" placeholder="Password" style="border-width: 0 0 2px 0; padding: 15px 40px 20px 10px; font-size: 14pt;">
                      <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    </div>
                </div>
                <div style="width: 100%; height: 20px; background-color: #1E1E2A;"></div>
                <div style="padding: 5% 10%;">
                    <button type="submit" style="background: none; outline: none; font-size: 15pt; font-weight: bold; border: 0; width: 100%">LOGIN</button>
                </div>
            </form>
            </div>
        </div>
    </div>
</div>

<!-- jQuery 3 -->
<script src="<?php echo base_url('bower_components/jquery/dist/jquery.min.js'); ?>"></script>
<!-- Bootstrap 3.3.7 -->
<script src="<?php echo base_url('bower_components/bootstrap/dist/js/bootstrap.min.js'); ?>"></script>
<!-- iCheck -->
<script src="<?php echo base_url('plugins/iCheck/icheck.min.js'); ?>"></script>
<script>
  $(function () {
    $('input').iCheck({
      checkboxClass: 'icheckbox_square-blue',
      radioClass: 'iradio_square-blue',
      increaseArea: '20%' /* optional */
    });
  });
</script>
</body>
</html>
