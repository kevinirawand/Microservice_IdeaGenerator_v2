<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Contributor extends CI_Controller 
{    
    var $limit = 15;
    var $offset = 0;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('contributor_model');
        $this->load->model('user_model');
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
        $data['offset'] = $this->offset;
        $data['pagination'] = $this->configPagination($this->contributor_model->getTableTotalRows($q));
        $data['table'] = $this->contributor_model->getTable($this->limit, $this->offset, $q);
        $data['q'] = $q;
        $content = $this->load->view('contributor/table', $data, true);
        $this->template->show('template/admin', $content, 'Contributors');
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

    public function new()
    {
        $this->load->helper('form_helper');

        if ($this->input->method() == 'post')
        {
            if ($this->save('insert'))
            {
                $this->session->set_flashdata('flash_msg', msg('A new contributor was successfully saved', 'success'));
                redirect('contributor','refresh');
                return;
            }
        }
        $data['row']['contributor_id'] = set_value('contributor_id');
        $data['row']['ig_username'] = set_value('ig_username');
        $data['row']['user_id'] = set_value('user_id');
        $data['row']['name'] = set_value('name');

        $data['form_action'] = base_url('contributor/new');
        $data['option_admin'] = $this->user_model->getUsers();
        $content = $this->load->view('contributor/form', $data, true);
        $this->template->show('template/admin', $content, 'Add a New Contributor');
    }

    private function save($action = 'insert')
    {
        // unique is not necessary because the data based on user id
        // $is_unique = '|is_unique[tbl_contributors.ig_username]';
        $is_unique = '';

        // if($action == 'update'){
        //     $check = $this->contributor_model->getById($this->input->post('contributor_id'));
        //     if($check->ig_username == $this->input->post('ig_username')){
        //         $is_unique = '';
        //     }
        // }

        $this->load->library('form_validation');
        $this->form_validation->set_rules('ig_username', 'IG Username', 'required'.$is_unique);
        $this->form_validation->set_rules('user_id', 'Admin', 'required');

        if ($this->form_validation->run() === FALSE)
        {
            return false;
        }
        else
        {
            $contributor['ig_username']  = $this->input->post('ig_username', true);
            $contributor['user_id']     = $this->input->post('user_id');
            $contributor['name']    = $this->input->post('name');
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

    public function edit($contributor_id)
    {
        $this->load->helper('form_helper');

        if ($this->input->method() == 'post')
        {
            if ($this->save('update'))
            {
                $this->session->set_flashdata('flash_msg', msg('A contributor was successfully updated', 'success'));
                redirect('contributor','refresh');
                return;
            }
        }

        $result = $this->contributor_model->getById($contributor_id);

        $data['row']['contributor_id'] = set_value('contributor_id', $result->contributor_id);
        $data['row']['ig_username'] = set_value('ig_username', $result->ig_username);
        $data['row']['user_id'] = set_value('user_id', $result->user_id);
        $data['row']['name'] = set_value('name', $result->name);

        $data['form_action'] = base_url('contributor/edit');
        $data['option_admin'] = $this->user_model->getUsers();
        $content = $this->load->view('contributor/form', $data, true);
        $this->template->show('template/admin', $content, 'Edit a Contributor');
    }
}