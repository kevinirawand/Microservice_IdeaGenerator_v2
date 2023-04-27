<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Pattern extends CI_Controller {
    var $user = array();

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('user_model');
        $this->load->model('target_model');
        $this->load->model('dashboard_model');
        $this->load->helper('MY_user');
        $this->auth_model->cekLogin(true);

        $this->load->model('pattern_model');
        $this->load->library('template');
        $this->user = $this->auth_model->getUser();

        $this->load->model('menu_model');
    }

	public function index()
	{
        $data['days'] = [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ];
        
        $system_dow = date( "w" ); // 0 (for Sunday) through 6 (for Saturday)
        $data['current_dow'] = $system_dow + 1; // In the database 1 (for Sunday) through 7 (for Saturday)

        // $q_day = $this->input->get('day', TRUE);
        // $q_keyword = $this->input->get('keyword', TRUE);
        // if (!$q_day) {
        //     $q_day = 2;
        // }
        // if (!$q_keyword){
        //     $q_keyword = '';
        // }

        // $data['user'] = $this->user;

        // $data['days_array'] = [2 => 'Monday', 3 => 'Tuesday', 4 => 'Wednesday', 5 => 'Thursday', 6 => 'Friday', 7 => 'Saturday', 1 => 'Sunday'];
        // $data['q_day'] = $data['current_dow'];
        // $data['q_keyword'] = $q_keyword;

        
        $data['keyword_cycle'] = $this->pattern_model->sp_keyword_cycle([$this->user['id_user']]);
        // $data['source'] = $this->pattern_model->sp_source([$this->user['id_user'], $q_day, $q_keyword]);

        $content = $this->load->view('client/pattern', $data, true);
        $js = array('dist/js/pattern.js');
        $this->template->show('template/client3', $content, 'Pattern', $js);

        $this->menu_model->increaseClick('pattern', $this->user['id_user']);
    }

    public function playground()
    {
        $id_user = $this->user['id_user'];

        $data['keyword_cycle'] = $this->pattern_model->sp_keyword_cycle([$id_user]);
        $data['source'] = $this->pattern_model->sp_source([$id_user, '1', '', '1']);

        echo '<pre>';
            print_r($data);
        echo '</pre>';
    }

    public function api_get_source()
    {
        $dow = $this->input->get('dow');
        $keyword = $this->input->get('keyword', TRUE);
        $keyword = urldecode($keyword);
        $id_label = $this->input->get('id_label');

        $resp = $this->pattern_model->sp_source($this->user['id_user'], $dow, $keyword, $id_label);
        header('Content-Type: application/json');
        echo json_encode($resp);
    }
}
