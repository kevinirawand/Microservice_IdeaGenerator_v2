<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Contributors extends CI_Controller {
	var $user = array();
    
    function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('contributor_model');
        $this->load->model('competitor_model');
		//$this->load->helper('MY_user');
        $this->load->library('template');
		
		$this->auth_model->cekLogin(true);
		$this->user = $this->auth_model->getUser();

        $this->load->model('menu_model');
    }

    function daily()
    {
		$data['interval'] = "daily";
        $this->serve($data);
    }

    function weekly()
    {
		$data['interval'] = "weekly";
        $this->serve($data);
    }

    function monthly()
    {
		$data['interval'] = "monthly";
        $this->serve($data);

        // $this->menu_model->increaseClick('competitor_m', $this->user['id_user']);
    }

    function config() 
    {
        // START create or update
        $this->load->helper('form_helper');
        if ($this->input->method() == 'post')
        {
            // check  contributor_id for update action
            $c_id = $this->input->post('contributor_id');
            if($c_id > 0) {
                if ($this->save('update'))
                {
                    $this->session->set_flashdata('flash_msg', msg('The contributor was successfully saved', 'success'));
                    redirect('contributors/config','refresh');
                    return;
                } else {
                    $this->session->set_flashdata('flash_msg', msg('Can not save data!', 'error'));
                    redirect('contributors/config','refresh');
                    return;
                }
            } else {
                if ($this->save('insert'))
                {
                    $this->session->set_flashdata('flash_msg', msg('A new contributor was successfully saved', 'success'));
                    redirect('contributors/config','refresh');
                    return;
                } else {
                    $this->session->set_flashdata('flash_msg', msg('Can not save data!', 'error'));
                    redirect('contributors/config','refresh');
                    return;
                }
            }
        }
        $data['row_data']['contributor_id'] = set_value('contributor_id');
        $data['row_data']['ig_username'] = set_value('ig_username');
        $data['row_data']['user_id'] = set_value('user_id');
        $data['row_data']['name'] = set_value('name');
        $data['row_data']['bidang'] = set_value('bidang');
        $data['option_admin'] = $this->user['id_user'];
        // END create or update

        $q = $this->input->get('q', TRUE);
        // $this->offset = $this->input->get('per_page') ? $this->input->get('per_page') : 0;
        // $data['offset'] = $this->offset;
        // $data['pagination'] = $this->configPagination($this->contributor_model->getTableTotalRows($q));
        
        $user_id = $this->user['id_user'];
        $data['table'] = $this->contributor_model->getTable($this->limit, $this->offset, $q, $user_id);
        $data['q'] = $q;

        $data['user_id'] = $user_id;

        // get sectors
        $data['sectors'] = $this->contributor_model->getSectors($user_id);

        $content = $this->load->view('client/contributors_config', $data, true);
        $js = array('dist/js/contributors.config.js', 'dist/js/datatables.min.js');
        $this->template->show('template/client3', $content, 'Contributors Config', $js);
    }

    function remove($ig_username)
    {
        $this->contributor_model->delete($ig_username);
        $this->session->set_flashdata('flash_msg', msg('Remove a contributor was successfully', 'success'));
        redirect('contributors/config','refresh');
    }

    private function save($action = 'insert')
    {
        $is_unique = '';
        $this->load->library('form_validation');
        $this->form_validation->set_rules('ig_username', 'IG Username', 'required'.$is_unique);
        $this->form_validation->set_rules('user_id', 'Admin', 'required');
        $this->form_validation->set_rules('bidang', 'Sector', 'required');

        if ($this->form_validation->run() === FALSE)
        {
            return false;
        }
        else
        {
            $contributor['ig_username']  = $this->input->post('ig_username', true);
            $contributor['user_id']     = $this->input->post('user_id');
            $contributor['name']    = $this->input->post('name');
            $contributor['bidang']    = $this->input->post('bidang');
            if ($action == 'update')
            {
                $contributor['contributor_id'] = $this->input->post('contributor_id');
                return $this->contributor_model->update($contributor);
            }
            else
            {
                return $this->contributor_model->insert($contributor);
            }
        }
    }

    private function serve($data)
    {
        $content = $this->load->view('client/contributors', $data, true);
        $js = array('dist/js/contributors.js', 'dist/js/datatables.min.js', 'bower_components/jquery-ui-month-picker/demo/MonthPicker.min.js', 'dist/js/buttons.datatables.min.js', 'dist/js/jszip.min.js', 'dist/js/buttons.html5.min.js');
        $this->template->show('template/client3', $content, 'Contributor Analysis', $js);
    }

    function api_detail_get_content_and_response()
    {
        $interval = $this->input->get('interval');
        $day = $this->input->get('day');
        $year = $this->input->get('year');
        $month = $this->input->get('month') ;
        $ig_username = $this->user['ig_username'];
        
        $result = $this->contributor_model->get_content_and_response($ig_username, $interval, $year, $month, $day);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_detail_get_like_and_comment()
    {
        $interval = $this->input->get('interval');
        $day = $this->input->get('day');
        $year = $this->input->get('year');
        $month = $this->input->get('month');
        $user_id = $this->user['id_user'];
        
        $result = $this->contributor_model->get_like_and_comment($user_id, $interval, $year, $month, $day);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_get_all_contributor_id()
    {
        $user_id = $this->user['id_user'];
        $data = $this->contributor_model->get_contributor_id_list($user_id);
        header('Content-Type: application/json');
        echo json_encode($data);
    }

    function api_get_all_contributor_urgent()
    {
        $interval = $this->input->get('interval');
        $day = $this->input->get('day');
        $year = $this->input->get('year');
        $month = $this->input->get('month') ;
        $user_id = $this->user['id_user'];
        $contributor_id = $this->input->get('contributor_id');
        
        $result = $this->contributor_model->api_get_all_contributor_urgent($user_id, $interval, $year, $month, $day, $contributor_id);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_get_all_contributor()
    {
        $interval = $this->input->get('interval');
        $day = $this->input->get('day');
        $year = $this->input->get('year');
        $month = $this->input->get('month') ;
        $user_id = $this->user['id_user'];
        
        $result = $this->contributor_model->get_all_contributor($user_id, $interval, $year, $month, $day);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_get_top_contributor()
    {
        $interval = $this->input->get('interval');
        $day = $this->input->get('day');
        $year = $this->input->get('year');
        $month = $this->input->get('month') ;
        $user_id = $this->user['id_user'];
        
        $result = $this->contributor_model->get_rank_contributor($user_id, $interval, $year, $month, $day, true, 100);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_get_least_contributor()
    {
        $interval = $this->input->get('interval');
        $day = $this->input->get('day');
        $year = $this->input->get('year');
        $month = $this->input->get('month') ;
        $user_id = $this->user['id_user'];
        
        $result = $this->contributor_model->get_rank_contributor($user_id, $interval, $year, $month, $day, false, 100);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_get_zero_contributor()
    {
        $interval = $this->input->get('interval');
        $day = $this->input->get('day');
        $year = $this->input->get('year');
        $month = $this->input->get('month') ;
        $user_id = $this->user['id_user'];
        
        $result = $this->contributor_model->get_zero_contributor($user_id, $interval, $year, $month, $day);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_get_like_line()
    {
        $interval = $this->input->get('interval');
        $year = $this->input->get('year');
        $month = $this->input->get('month') ;
        $user_id = $this->user['id_user'];
        
        $result = $this->contributor_model->get_data_line($user_id, $interval, $year, $month);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_get_comment_line()
    {
        $interval = $this->input->get('interval');
        $year = $this->input->get('year');
        $month = $this->input->get('month') ;
        $user_id = $this->user['id_user'];
        
        $result = $this->contributor_model->get_data_line($user_id, $interval, $year, $month, false);
        header('Content-Type: application/json');
        echo json_encode($result);
    }

    function api_get_rank_sector()
    {
        $interval = $this->input->get('interval');
        $day = $this->input->get('day');
        $year = $this->input->get('year');
        $month = $this->input->get('month') ;
        $user_id = $this->user['id_user'];
        $ig_username = $this->user['ig_username'];
        
        $result = $this->contributor_model->get_rank_sector($ig_username, $user_id, $interval, $year, $month, $day);
        header('Content-Type: application/json');
        echo json_encode($result);
    }
}