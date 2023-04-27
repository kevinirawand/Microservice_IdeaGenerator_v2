<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Crawling extends CI_Controller 
{    
    var $limit = 15;
    var $offset = 0;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('crawling_model');
        $this->load->model('target_model');
        $this->load->library('template');
    }

    public function index()
    {
        redirect('crawling/table','refresh');
    }

    public function table($show_history = null)
    {
        $q = $this->input->get('q', TRUE);

        $this->offset = $this->input->get('per_page') ? $this->input->get('per_page') : 0;

        $show_history = $show_history ? true : false;

        $data['table'] = $this->crawling_model->getTable($this->limit, $this->offset, $show_history, $q);
        
        $data['pagination'] = $this->configPagination($show_history, $q);
        
        $data['offset'] = $this->offset;
        
        $data['show_history'] = $show_history;
        
        $data['q'] = $q;
        var_dump($data['q']);
        $content = $this->load->view('crawling/table', $data, true);
        $this->template->show('template/admin', $content, 'Crawling');
    }

    private function configPagination($show_history = null, $q = null)
    {
        $this->load->library('pagination');
        $config['reuse_query_string'] = true;
        $config['base_url'] = current_url();
        $config['total_rows'] = $this->crawling_model->getTableTotalRows($show_history, $q);
        $config['per_page'] = $this->limit;
        $this->pagination->initialize($config);
        return $this->pagination->create_links();
    }

    // function generate_result($id_user)
    // {
    //     if (!isset($id_user)) return;
    //     $this->generate_result_daily($id_user);
    // }

    // private function generate_result_daily($id_user)
    // {
    //     /** get array categories */
    //     $arr_category = $this->target_model->getCategoriesByClient($id_user);
    //     $arr_
    // }
}