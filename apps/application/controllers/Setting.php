<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Setting extends CI_Controller {
    var $user = array();

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->helper('MY_user');
        $this->auth_model->cekLogin(true);

        $this->load->library('template');
        $this->user = $this->auth_model->getUser();
    }

	public function change_scraping_status()
	{
        $check = $this->db->query("SELECT * FROM tbl_results WHERE DATE(updated) = DATE(NOW())")->num_rows();

        if(!$check){
            $this->db->where('name', 'is_result_need_scraped');
            $this->db->set('value', 1);
            $this->db->update('tbl_settings');
            $this->session->set_flashdata('flash_msg', msg('Calculate viral dashboard has been triggered', 'success'));
        }

        redirect('/crawling/table');
    }
}