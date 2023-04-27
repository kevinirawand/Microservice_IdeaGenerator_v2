<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Normalization extends CI_Controller 
{
    var $limit = 15;
    var $offset = 0;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('extraction_model');
        $this->load->model('normalization_model');
        $this->load->model('crawling_model');
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
            $normalizations = $this->input->post('normalizations');
            $id_extractions = $this->input->post('id_extractions');
            $data = array();
            foreach ($normalizations as $key => $normalization)
            {
                if (!empty($normalization))
                {
                    $data[] = array(
                        'id_crawling' => $id_crawling,
                        'id_extraction' => $id_extractions[$key],
                        'normal_text' => $normalization
                    );
                }
            }
            if ($this->normalization_model->insert_batch($data) > 0)
            {
                $this->crawling_model->setIsNormalized($id_crawling, 1);
                $this->session->set_flashdata('flash_msg', msg('Keywords from a crawled posting was successfuly normalized.', 'success'));
                redirect('crawling');
                return;
            }
            else
            {
                $this->session->set_flashdata('flash_msg', msg('Sorry, your data could not be saved.<br/>'.$this->db->error()['message'], 'danger'));
                redirect('normalization/crawling/'.$id_crawling, 'refresh');
                return;
            }
        }
        $data['extractions'] = $this->extraction_model->getByCrawling($id_crawling);
        $content = $this->load->view('normalization/normalization', $data, true);
        $this->template->show('template/admin', $content, 'Keyword Normalization');
    }

    public function table()
    {
        $q = $this->input->get('q', TRUE);

        $this->offset = $this->input->get('per_page') ? $this->input->get('per_page') : 0;
        $data['pagination'] = $this->configPagination($this->normalization_model->getTableTotalRows($q));
        $data['offset'] = $this->offset;
        $data['table'] = $this->normalization_model->getTable($this->limit, $this->offset, $q);
        $data['q'] = $q;
        $content = $this->load->view('normalization/table', $data, true);
        // $content = "ABC";
        $this->template->show('template/admin', $content, 'Normalization');
    }

    public function get_normal_text_autocomplete() {
        $q = $this->input->get('q', true);
        $this->db->select('tbl_normalizations.normal_text');
        $this->db->like('tbl_normalizations.normal_text', $q);
        $this->db->limit(10);
        $data = $this->db->get('tbl_normalizations')->result();

        $response = [];
        foreach ($data as $dt) {
            $response[] = $dt->normal_text;
        }

        echo json_encode($response);
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