<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Classification extends CI_Controller 
{
    var $limit = 15;
    var $offset = 0;
    
    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('crawling_model');
        $this->load->model('label_model');
        $this->load->model('normalization_model');
        $this->load->model('classification_model');
        $this->load->library('template');
    }

    public function index()
    {
        $this->table();
    }

    public function table()
    {
        $q = $this->input->get('q', TRUE);

        $this->offset = $this->input->get('per_page') ? $this->input->get('per_page') : 0;
        $data['pagination'] = $this->configPagination($this->classification_model->getTableTotalRows($q));
        $data['offset'] = $this->offset;
        $data['table'] = $this->classification_model->getTable($this->limit, $this->offset, $q);
        $data['q'] = $q;
        $content = $this->load->view('classification/table', $data, true);
        $this->template->show('template/admin', $content, 'Classification');
    }

    public function crawling($id_crawling)
    {
        if ($this->input->method() == 'post')
        {
            // print_r($this->input->post('id_nor'));
            $data = $this->input->post('id_nor');
            if ($this->classification_model->classification($data, $id_crawling))
            {
                $this->crawling_model->setIsClassified($id_crawling, 1);
                $this->session->set_flashdata('flash_msg', msg('Classification successfully saved.', 'success'));
                redirect('crawling');
                return;
            }
            else
            {
                $this->session->set_flashdata('flash_msg', msg('Sorry, classification failed.<br/>'.$this->db->error()['message'], 'danger'));
                redirect('classification/crawling/'.$id_crawling, 'refresh');
                return;
            }
        }
        $data['labels'] = $this->label_model->getAll();
        $data['normalizations'] = $this->normalization_model->getByCrawling($id_crawling);
        $content = $this->load->view('classification/classification', $data, true);
        $this->template->show('template/admin', $content, 'Classification');
    }

    private function configPagination($total_rows)
    {
        $this->load->library('pagination');
        $config['reuse_query_string'] = true;
        $config['base_url'] = current_url();
        $config['total_rows'] = $total_rows;
        $config['per_page'] = $this->limit;
        $this->pagination->initialize($config);
        return $this->pagination->create_links();
    }
}