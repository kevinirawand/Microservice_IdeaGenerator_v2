<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Engine extends CI_Controller {
    var $limit = 15;
    var $offset = 0;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('engine_model');
        $this->load->library('template');
    }

    public function index()
    {
        redirect('engine/table','refresh');
    }

    public function table()
    {
        $q = $this->input->get('q', TRUE);

        $this->offset = $this->input->get('per_page') ? $this->input->get('per_page') : 0;
        $data['table'] = $this->engine_model->getTable($this->limit, $this->offset, $q);
        $data['pagination'] = $this->configPagination($this->engine_model->getTableTotalRows($q));
        $data['offset'] = $this->offset;
        $data['q'] = $q;
        $content = $this->load->view('engine/list', $data, true);
        $this->template->show('template/admin', $content, 'Crawler Engine');
    }

    public function edit($id_engine)
    {
        $this->load->helper('form_helper');

        if ($this->input->method() == 'post')
        {
            if ($this->save('update'))
            {
                $this->session->set_flashdata('flash_msg', msg('Update was successfuly saved.', 'success'));
                redirect('engine','refresh');
                return;
            }
            else
            {
                $engine['id_engine']   = set_value('id_engine');
                $engine['ig_username'] = set_value('ig_username');
                $engine['ig_password'] = set_value('ig_password');
            }
        }
        else
        {
            $engine = $this->engine_model->getById($id_engine);
        }
        $this->showForm($engine, 'Crawler Engine - Edit');
    }

    public function new()
    {
        $this->load->helper('form_helper');

        if ($this->input->method() == 'post')
        {
            if ($this->save('insert'))
            {
                $this->session->set_flashdata('flash_msg', msg('New crawler engine has been saved', 'success'));
                redirect('engine','refresh');
                return;
            }
        }
        $engine['ig_username'] = set_value('ig_username');
        $engine['ig_password'] = set_value('ig_password');
        $this->showForm($engine, 'Crawler Engine - New');
    }

    private function save($action = 'insert')
    {
        $this->load->library('form_validation');
        $this->form_validation->set_rules('ig_username', 'IG Username', 'required');
        $this->form_validation->set_rules('ig_password', 'IG Password', 'required');

        if ($this->form_validation->run() === FALSE)
        {
            return false;
        }
        else
        {
            $engine['ig_username'] = $this->input->post('ig_username', true);
            $engine['ig_password'] = $this->input->post('ig_password', true);
            if ($action == 'update')
            {
                $engine['id_engine'] = $this->input->post('id_engine', true);
                return $this->engine_model->update($engine);
            }
            else
            {
                return $this->engine_model->insert($engine);
            }
        }
    }

    private function showForm($engine, $title)
    {
        $data['engine'] = $engine;
        $content = $this->load->view('engine/form', $data, true);
        $this->template->show('template/admin', $content, $title);
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

    public function delete($id_engine)
    {
        $this->engine_model->delete($id_engine);

        $this->session->set_flashdata('flash_msg', msg('Crawler engine has been deleted', 'success'));
        redirect('engine','refresh');
        return;
    }
}