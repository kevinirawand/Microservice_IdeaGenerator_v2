<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Report extends CI_Controller 
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('user_model');
        $this->load->model('competitor_model');
        $this->load->helper('MY_user');
        $this->auth_model->cekLogin(true);

        $this->load->library('template');
    }

    public function index()
    {
        $data['users'] = $this->user_model->getUserByType(3);
        $content = $this->load->view('report/form', $data, true);
        $js = array(
            'bower_components/js-xlsx/dist/xlsx.full.min.js',
            'dist/js/report.js'
        );
        $this->template->show('template/admin', $content, 'Report', $js);
    }

    public function fair_report()
    {
        $id_user = $this->input->post('iid_user', true);
        $year = $this->input->post('iyear', true);
        $month = $this->input->post('imonth', true);

        if (empty($id_user) || empty($year) || empty($month)) throw new Exception("Invalid params");

        $F = $this->competitor_model->get_report_follower($id_user, $year, $month);
        $A = $this->competitor_model->get_report_activity($id_user, $year, $month);
        $I = $this->competitor_model->get_report_interaction($id_user, $year, $month);
        $R = $this->competitor_model->get_report_responsiveness($id_user, $year, $month);
        $user = $this->user_model->getUser($id_user);

        header('Content-Type: application/json');
        echo json_encode((object) ['F' => $F, 'A' => $A, 'I' => $I, 'R' => $R, 'user' => $user]);
    }
}
?>