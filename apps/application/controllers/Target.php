<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Target extends CI_Controller 
{    
    var $limit = 15;
    var $offset = 0;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('target_model');
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
        $data['pagination'] = $this->configPagination($this->target_model->getTableTotalRows($q));
        $data['table'] = $this->target_model->getTable($this->limit, $this->offset, $q);
        $data['q'] = $q;
        $content = $this->load->view('target/table', $data, true);
        $this->template->show('template/admin', $content, 'Targets');
    }

    public function user($id_user)
    {   
        $this->load->library('form_validation');

        $data = array();
        $data['targets'] = array();
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
        }

        if ($this->input->method() == 'post')
        {
            $this->form_validation->set_rules('id_target', 'Instagram Username', 'required');
            $this->form_validation->set_rules('category', 'Category', 'required');
            if ($this->form_validation->run() === TRUE)
            {
                $target['id_target'] = $this->input->post('id_target', true);
                $target['category'] = $this->input->post('category', true);
                $insert = $this->target_model->insertUsersTargets($target, $id_user);
                
                if ($insert != -1)
                {
                    $this->session->set_flashdata('flash_msg', msg('New crawling target was successfuly saved.', 'success'));
                    redirect(uri_string(),'refresh');
                    return;
                }
                else
                {
                    $data['message'] = msg('Sorry, your data could not be saved.<br/>'.$this->db->error()['message'], 'danger');  
                }
            }
        }

        $data['targets'] = $this->target_model->getTargetByUser($id_user);
        $data['option_target'] = $this->target_model->getTargetAll();
        $content = $this->load->view('target/list', $data, true);
        $this->template->show('template/admin', $content, 'Crawling Target');
    }

    public function new()
    {
        $this->load->helper('form_helper');

        if ($this->input->method() == 'post')
        {
            if ($this->save('insert'))
            {
                $this->session->set_flashdata('flash_msg', msg('A new Target Crawling was successfully saved', 'success'));
                redirect('target','refresh');
                return;
            }
        }
        $data['row']['id_target'] = set_value('id_target');
        $data['row']['ig_username'] = set_value('ig_username');
        $data['row']['id_admin'] = set_value('id_admin');
        $data['row']['id_engine'] = set_value('id_engine');

        $data['form_action'] = base_url('target/new');
        $data['option_admin'] = $this->user_model->getAdmin();
        $data['option_engine'] = $this->engine_model->getEngineForOption();
        $content = $this->load->view('target/form', $data, true);
        $this->template->show('template/admin', $content, 'Add a New Target Crawling');
    }

    public function edit($id_target)
    {
        $this->load->helper('form_helper');

        if ($this->input->method() == 'post')
        {
            if ($this->save('update'))
            {
                $this->session->set_flashdata('flash_msg', msg('A target crawling was successfully updated', 'success'));
                redirect('target','refresh');
                return;
            }
        }

        $result = $this->target_model->getById($id_target);

        $data['row']['id_target'] = set_value('id_target', $result->id_target);
        $data['row']['ig_username'] = set_value('ig_username', $result->ig_username);
        $data['row']['id_admin'] = set_value('id_admin', $result->id_admin);
        $data['row']['id_engine'] = set_value('id_engine', $result->id_engine);

        $data['form_action'] = base_url('target/edit');
        $data['option_admin'] = $this->user_model->getAdmin();
        $data['option_engine'] = $this->engine_model->getEngineForOption();
        $content = $this->load->view('target/form', $data, true);
        $this->template->show('template/admin', $content, 'Add a New Target Scraping');
    }

    private function save($action = 'insert')
    {
        $is_unique = '|is_unique[tbl_targets.ig_username]';

        if($action == 'update'){
            $check = $this->target_model->getById($this->input->post('id_target'));
            if($check->ig_username == $this->input->post('ig_username')){
                $is_unique = '';
            }
        }
        
        $this->load->library('form_validation');
        $this->form_validation->set_rules('ig_username', 'IG Username', 'required'.$is_unique);
        $this->form_validation->set_rules('id_admin', 'Admin', 'required');
        $this->form_validation->set_rules('id_engine', 'Crawler Engine', 'required');

        if ($this->form_validation->run() === FALSE)
        {
            return false;
        }
        else
        {
            $target['ig_username']  = $this->input->post('ig_username', true);
            $target['id_admin']     = $this->input->post('id_admin');
            $target['id_engine']    = $this->input->post('id_engine');
            if ($action == 'update')
            {
                $target['id_target'] = $this->input->post('id_target');
                return $this->target_model->update($target);
            }
            else
            {
                return $this->target_model->insert($target);
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

    // delete target
    public function delete($id_target){
        $this->target_model->delete($id_target);
        $this->session->set_flashdata('flash_msg', msg('A crawling target was successfully deleted', 'success'));
        redirect('target', 'refresh');
    }

    // delete user target by user id and target id
    public function delete_user_target($id_user, $id_target){
        $this->target_model->delete_user_target($id_user, $id_target);
        $this->session->set_flashdata('flash_msg', msg('A crawling user target was successfully deleted', 'success'));
        redirect('user/target/'.$id_user,'refresh');
    }
}