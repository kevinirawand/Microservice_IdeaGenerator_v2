<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Performance extends CI_Controller {
    var $user = array();
    
    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('performance_model');
        $this->load->library('template');

        $this->auth_model->cekLogin(true);
		$this->user = $this->auth_model->getUser();

        $this->load->model('menu_model');
    }

    public function daily()
    {
        # get data
        $data['list_month'] = array();
        for ($i=0; $i < 12; $i++) { 
            $timestamp = mktime(0, 0, 0, $i + 1, 1);
            $data['list_month'][] = date('F', $timestamp);
        }
        # tampilkan
        $data['interval'] = 'daily';
        $this->serve($data);
        # update tracking menu
        $this->menu_model->increaseClick('performance_d', $this->user['id_user']);
    }

    public function monthly()
    {
        # get data
        # tampilkan
        $data['interval'] = 'monthly';
        $this->serve($data);
        # update tracking menu
        $this->menu_model->increaseClick('performance_m', $this->user['id_user']);
    }

    private function serve($data)
    {
        // $data['content'] = '';
        $data['list_year'] = array();
        for ($i=0; $i < 10; $i++) { 
            $data['list_year'][] = date('Y') - $i;
        }

        $content = $this->load->view('client/performance', $data, true);
        $js = array('dist/js/performance2.js', 'bower_components/jquery-ui-month-picker/demo/MonthPicker.min.js');
        $this->template->show('template/client3', $content, 'Self Performance', $js);
    }

    public function api_history_follower_interaction()
    {
        $interval = $this->input->get('interval');
        $year = $this->input->get('year');
        $month = $this->input->get('month');
      //   GET IG USERNAME FROM INPUT
        $ig_username = $this->input->get('ig_username');
      //   print_r($this->user);
        $id_user = $this->user["id_user"];
        $result = $this->performance_model->get_history_follower_interaction($id_user, $ig_username, $interval, $year, $month);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    public function api_source()
    {
        $interval = $this->input->get('interval');
        $index = $this->input->get('index');
        $year = $this->input->get('year');
        $month = $this->input->get('month') ;
        $ig_username = $this->user['ig_username'];
        if ($interval == 'daily')
        {
            $result = $this->performance_model->get_source_daily($ig_username, $index, $month, $year);
        }
        else
        {
            $result = $this->performance_model->get_source_monthly($ig_username, $index, $year);
        }
        header('Content-Type: application/json');
      //   $this->output->enable_profiler(TRUE);
        var_dump(json_encode($index));
        echo json_encode($result);
    }

    public function api_gauge()
    {
        $interval = $this->input->get('interval');
        
        $ig_username = $this->input->get('ig_username');
        if ($interval == "daily")
        {
            $date = $this->input->get('date');
            $result = $this->performance_model->get_gauge_daily($ig_username, strtotime($date));
        }
        else
        {
            $month = $this->input->get('month');
            $year = $this->input->get('year');
            $result = $this->performance_model->get_gauge_monthly($ig_username, $month, $year);
        }
        header('Content-Type: application/json');
      //   print_r($result);
      //   echo json_encode(["test"]);
        echo json_encode($result);
    }



   //  SEND RESPONSE TARGERTS
    public function api_get_targets(){
      $id_user = $this->user["id_user"];
      $result = $this->performance_model->get_targets_by_id($id_user);
      header('Content-Type: application/json');
      echo json_encode($result);
    }
}