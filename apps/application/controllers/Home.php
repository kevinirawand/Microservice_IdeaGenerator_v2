<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Home extends CI_Controller {
    var $user = array();

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('user_model');
        $this->load->helper('MY_user');
        $this->auth_model->cekLogin(true);

        $this->load->library('template');
        $this->user = $this->auth_model->getUser();

        $this->load->model('popup_model');
    }

	public function index()
	{
        $data['user'] = $this->user;

        $data['popup'] = $this->popup_model->getPopup();

        $content = $this->load->view('home/index', $data, true);

        $js = array('dist/js/home.js');
        $this->template->show('template/client3', $content, 'Home', $js);
    }
}