<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Scrap_target extends CI_Controller 
{    
    var $limit = 15;
    var $offset = 0;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('scrap_target_model');
        $this->load->model('user_model');
        $this->load->model('engine_model');
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
        $data['pagination'] = $this->configPagination($this->scrap_target_model->getTableTotalRows($q));
        $data['table'] = $this->scrap_target_model->getTable($this->limit, $this->offset, $q);
        $data['q'] = $q;
        $content = $this->load->view('scrap_target/table', $data, true);
        $this->template->show('template/admin', $content, 'Scraping Targets');
    }

    public function user($id_user)
    {   
        $this->load->library('form_validation');

        $data = array();
        $data['scrap_targets'] = array();
        $data['message'] = '';
        $data['name'] = '';

        $user = $this->user_model->getUser($id_user);
        if (empty($user) || $user == [])
        {
            $this->session->set_flashdata('flash_msg', msg('User not found!', 'danger'));
            redirect('user','refresh');
            return;
        }
        else
        {
            $data['name'] = $user['name'];
            if(!$this->scrap_target_model->self_target($user, false, $this->user_model->getAdmin(), $this->engine_model->getEngineForOption())) {
                $this->session->set_flashdata('flash_msg', msg('User cannot be add as target!', 'danger'));
                redirect('user','refresh');
                return;
            }
        }

        if ($this->input->method() == 'post')
        {
            $this->form_validation->set_rules('id_scrap_target', 'Instagram Username', 'required');
            if ($this->form_validation->run() === TRUE)
            {
                $scrap_target['id_scrap_target'] = $this->input->post('id_scrap_target', true);
                $insert = $this->scrap_target_model->insertUsersScrap_targets($scrap_target, $id_user);
                if ($insert != -1)
                {
                    $this->session->set_flashdata('flash_msg', msg('New scraping target was successfuly saved.', 'success'));
                    redirect(uri_string(),'refresh');
                    return;
                }
                else
                {
                    $data['message'] = msg('Sorry, your data could not be saved.<br/>'.$this->db->error()['message'], 'danger');  
                }
            }
        }

        $data['scrap_targets'] = $this->scrap_target_model->getScrap_targetByUser($id_user);
        $data['option_scrap_target'] = $this->scrap_target_model->getScrap_targetAll();
        $content = $this->load->view('scrap_target/list', $data, true);
        $this->template->show('template/admin', $content, 'Scraping Target');
    }

    public function new()
    {
        $this->load->helper('form_helper');

        if ($this->input->method() == 'post')
        {
            if ($this->save('insert'))
            {
                $this->session->set_flashdata('flash_msg', msg('A new target scraping was successfully saved', 'success'));
                redirect('scrap_target','refresh');
                return;
            }
        }
        $data['row']['id_scrap_target'] = set_value('id_scrap_target');
        $data['row']['ig_username'] = set_value('ig_username');
        $data['row']['id_admin'] = set_value('id_admin');
        $data['row']['id_engine'] = set_value('id_engine');

        $data['form_action'] = base_url('scrap_target/new');
        $data['option_admin'] = $this->user_model->getAdmin();
        $data['option_engine'] = $this->engine_model->getEngineForOption();
        $content = $this->load->view('scrap_target/form', $data, true);
        $this->template->show('template/admin', $content, 'Add a New Target Scraping');
    }

    public function edit($id_scrap_target)
    {
        $this->load->helper('form_helper');

        if ($this->input->method() == 'post')
        {
            if ($this->save('update'))
            {
                $this->session->set_flashdata('flash_msg', msg('A target scraping was successfully updated', 'success'));
                redirect('scrap_target','refresh');
                return;
            }
        }

        $result = $this->scrap_target_model->getById($id_scrap_target);

        $data['row']['id_scrap_target'] = set_value('id_scrap_target', $result->id_scrap_target);
        $data['row']['ig_username'] = set_value('ig_username', $result->ig_username);
        $data['row']['id_admin'] = set_value('id_admin', $result->id_admin);
        $data['row']['id_engine'] = set_value('id_engine', $result->id_engine);

        $data['form_action'] = base_url('scrap_target/edit');
        $data['option_admin'] = $this->user_model->getAdmin();
        $data['option_engine'] = $this->engine_model->getEngineForOption();
        $content = $this->load->view('scrap_target/form', $data, true);
        $this->template->show('template/admin', $content, 'Add a New Target Scraping');
    }

    private function save($action = 'insert')
    {
        $is_unique = '|is_unique[tbl_scrap_targets.ig_username]';

        if($action == 'update'){
            $check = $this->scrap_target_model->getById($this->input->post('id_scrap_target'));
            if($check->ig_username == $this->input->post('ig_username')){
                $is_unique = '';
            }
        }

        $this->load->library('form_validation');
        $this->form_validation->set_rules('ig_username', 'IG Username', 'required'.$is_unique);
        $this->form_validation->set_rules('id_admin', 'Admin', 'required');
        $this->form_validation->set_rules('id_engine', 'Scraping Engine', 'required');

        if ($this->form_validation->run() === FALSE)
        {
            return false;
        }
        else
        {
            $scrap_target['ig_username']  = $this->input->post('ig_username', true);
            $scrap_target['id_admin']     = $this->input->post('id_admin');
            $scrap_target['id_engine']    = $this->input->post('id_engine');
            if ($action == 'update')
            {
                $scrap_target['id_scrap_target'] = $this->input->post('id_scrap_target');
                return $this->scrap_target_model->update($scrap_target);
            }
            else
            {
                return $this->scrap_target_model->insert($scrap_target);
            }
        }
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

    // delete scrap_target
    public function delete($id_scrap_target){
        $this->scrap_target_model->delete($id_scrap_target);
        $this->session->set_flashdata('flash_msg', msg('A scraping target was successfully deleted', 'success'));
        redirect('scrap_target', 'refresh');
    }

    // delete user scrap target by user id and scrap target id
    public function delete_user_scrap_target($id_user, $id_scrap_target){
        $this->scrap_target_model->delete_user_scrap_target($id_user, $id_scrap_target);
        $this->session->set_flashdata('flash_msg', msg('A scraping user target was successfully deleted', 'success'));
        redirect('user/scrap_target/'.$id_user,'refresh');
    }
}