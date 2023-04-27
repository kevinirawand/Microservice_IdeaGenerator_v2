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

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Google Font -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Helvetica">

    <link rel="shortcut icon" href="<?php echo base_url('dist/image/logo.png'); ?>">
    <link rel="stylesheet" href="<?php echo base_url('dist/css/common.css'); ?>">
	<link rel="stylesheet" href="<?php echo base_url('dist/css/login.css'); ?>">
</head>
<body class="hold-transition" style="background: url('<?php echo base_url('dist/image/bg@3x.png'); ?>') center center fixed repeat; background-size: cover;">
    <div class="container" style="width: 1280px;">
        <table width="100%" height="100%">
            <tr>
                <td>
                    <img src="<?php echo base_url('dist/image/logo_horizontal.svg'); ?>" height="58px;" />
                    <p style="font-size: 76px; font-weight: bold; margin: 126px 0; line-height: 95%; color: white;">
                        Hatch<br/>Your Idea
                    </p>
                    <div style="height: 12px; width: 200px; background-color: white; margin-bottom: 24px;"></div>
                    <p style="font-size: 20px; color: white;">
                        With Idea Generator V2.0<br/>
                        get daily fresh idea<br/>
                        and monitor your competitors
                    </p>
                </td>
                <td width="316px";>
                    <?php echo form_open('login'); ?>
                        <div style="width: 316px; padding: 24px 28px; border-radius: 16px 16px 0 0; background-color: white;">
                            <h2 style="font-size: 30px;letter-spacing: -0.02em;line-height: 34px;margin-bottom: 16px;">
                                <b>IDEA</b> GENERATOR
                            </h2>
                            <div style="padding: 24px 0;">
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <img src="<?php echo base_url('dist/image/icon_mail.svg'); ?>" />
                                    </span>
                                    <input type="text" class="form-control" name="username" placeholder="Email/User ID" />
                                </div>
                                <div style="height: 16px;"></div>
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <img src="<?php echo base_url('dist/image/icon_lock.svg'); ?>" />
                                    </span>
                                    <input type="password" class="form-control" name="password" placeholder="Password" />
                                </div>
                            </div>
                            <?php
                                if ($alert)
                                {
                                    echo '<div class="text-danger">';
                                    echo $alert;
                                    echo '</div>';
                                }
                            ?>
                        </div>
                        <button id="btn-login" type="submit">
                            LOGIN
                        </button>
                    </form>
                </td>
            </tr>
        </table>
    </div>

<!-- jQuery 3 -->
<script src="<?php echo base_url('bower_components/jquery/dist/jquery.min.js'); ?>"></script>
<!-- Bootstrap 3.3.7 -->
<script src="<?php echo base_url('bower_components/bootstrap/dist/js/bootstrap.min.js'); ?>"></script>
</body>
</html>
