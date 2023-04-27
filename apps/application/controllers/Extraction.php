<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Extraction extends CI_Controller 
{
    var $limit = 15;
    var $offset = 0;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('crawling_model');
        $this->load->model('extraction_model');
        $this->load->library('template');
    }

    public function index()
    {
        $this->table();
    }

    public function crawling($id_crawling)
    {
        if ($this->input->method() == 'post')
        {
            $extraction = $this->input->post('extraction');
            $data = array();
            foreach ($extraction as $keyword) 
            {
                $data[] = array(
                    'id_crawling' => $id_crawling,
                    'keyword' => $keyword
                );
            }
            if ($this->extraction_model->insert_batch($data) > 0)
            {
                $this->crawling_model->setIsExtracted($id_crawling);
                $this->session->set_flashdata('flash_msg', msg('Caption of a crawled posting was successfuly extracted.', 'success'));
                redirect('crawling');
                return;
            }
            else
            {
                $this->session->set_flashdata('flash_msg', msg('Sorry, your data could not be saved.<br/>'.$this->db->error()['message'], 'danger'));
                redirect('extraction/crawling/'.$id_crawling, 'refresh');
                return;
            }
        }
        $data['crawling'] = $this->crawling_model->getById($id_crawling);
        $caption_text = $data['crawling']['caption_text'];
        $caption_text = preg_replace('/[\.\,\?\!]/', '', $caption_text);
        $caption_text = preg_replace('/\s+/', ' ', $caption_text);
        $data['arr_caption_text'] = explode(' ', strtolower($caption_text));
        $content = $this->load->view('extraction/extraction', $data, true);
        $this->template->show('template/admin', $content, 'Extraction From Crawled Posting');
    }

    public function table()
    {
        $q = $this->input->get('q', TRUE);

        $this->offset = $this->input->get('per_page') ? $this->input->get('per_page') : 0;
        $data['pagination'] = $this->configPagination($this->extraction_model->getTableTotalRows($q));
        $data['offset'] = $this->offset;
        $data['table'] = $this->extraction_model->getTable($this->limit, $this->offset, $q);
        $data['q'] = $q;
        $content = $this->load->view('extraction/table', $data, true);
        $this->template->show('template/admin', $content, 'Extraction');
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