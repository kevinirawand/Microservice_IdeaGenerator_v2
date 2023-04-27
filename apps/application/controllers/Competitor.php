<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Competitor extends CI_Controller {
	var $user = array();
    
    function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('competitor_model');
		//$this->load->helper('MY_user');
        $this->load->library('template');
		
		$this->auth_model->cekLogin(true);
		$this->user = $this->auth_model->getUser();

        $this->load->model('menu_model');
    }

    function daily()
    {
        # get data
        # tampilkan
		$data['interval'] = "daily";
        $this->serve($data);

        $this->menu_model->increaseClick('competitor_d', $this->user['id_user']);
    }

    function monthly()
    {
        # get data
        # tampilkan
		$data['interval'] = "monthly";
        $this->serve($data);

        $this->menu_model->increaseClick('competitor_m', $this->user['id_user']);
    }

    private function serve($data)
    {
        $content = $this->load->view('client/competitor', $data, true);
        $js = array('dist/js/competitor.js', 'bower_components/jquery-ui-month-picker/demo/MonthPicker.min.js');
        $this->template->show('template/client3', $content, 'Competitor Analysis', $js);
    }

    function api_top_rangking()
    {
		$interval = $this->input->get("interval");
        $year = $this->input->get("year");
        $month = $this->input->get("month");
        $result = $this->competitor_model->get_top_rangking($this->user["id_user"], $interval, $year, $month);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_history_target()
    {
        $id_target = $this->input->get("id_target");
        $interval = $this->input->get("interval");
        $year = $this->input->get("year");
        $month = $this->input->get("month");
        $result = $this->competitor_model->get_history_target($this->user["id_user"], $id_target, $interval, $year, $month);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_top_follower()
    {
        $interval = $this->input->get("interval");
        $year = $this->input->get("year");
        $month = $this->input->get("month");
        $result = $this->competitor_model->get_top_follower($this->user["id_user"], $interval, $year, $month);
        header('Content-Type: application/json');
        echo json_encode($result);
    }
	
	function api_top_activity()
    {
        $interval = $this->input->get("interval");
        $year = $this->input->get("year");
        $month = $this->input->get("month");
        $result = $this->competitor_model->get_top_activity($this->user["id_user"], $interval, $year, $month);
        header('Content-Type: application/json');
        echo json_encode($result);
    }
	
	function api_top_interaction()
    {
        $interval = $this->input->get("interval");
        $year = $this->input->get("year");
        $month = $this->input->get("month");
        $result = $this->competitor_model->get_top_interaction($this->user["id_user"], $interval, $year, $month);
        header('Content-Type: application/json');
        echo json_encode($result);
    }
	
	function api_top_responsiveness()
    {
        $interval = $this->input->get("interval");
        $year = $this->input->get("year");
        $month = $this->input->get("month");
        $result = $this->competitor_model->get_top_responsiveness($this->user["id_user"], $interval, $year, $month);
        header('Content-Type: application/json');
        echo json_encode($result);
    }
}