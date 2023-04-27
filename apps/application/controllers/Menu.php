<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Menu extends CI_Controller
{
    
    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('user_model');
        $this->load->helper('MY_user');
        $this->auth_model->cekLogin(true);
        $this->load->library('template');

        $this->load->model('menu_model');
    }

    public function index()
    {
        $this->tracking();
    }

    public function tracking()
    {
        $q = $this->input->get('q', TRUE);
        $data['tracking'] = $this->menu_model->getTrackingMenu( $q );
        $data['q'] = $q;
        $content = $this->load->view('menu/tracking', $data, true);
        $this->template->show('template/admin', $content, 'Tracking Menu');
    }
}
