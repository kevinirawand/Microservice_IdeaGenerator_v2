<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class User extends CI_Controller
{
    var $user;
    var $limit = 15;
    var $offset = 0;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('user_model');
        // $this->load->model('engine_model');
        $this->load->helper('MY_user');
        $this->auth_model->cekLogin(true);

        $this->load->library('template');
        $this->user = $this->auth_model->getUser();

        $this->load->model('menu_model');
    }

	public function index()
	{
      //   $this->table();
      redirect('user/table','refresh');
    }
    
    public function table()
    {
        $q = $this->input->get('q', TRUE);

        $this->offset = $this->input->get('per_page') ? $this->input->get('per_page') : 0;

        $data['table'] = $this->user_model->getTableUser($this->user['user_type'], $this->limit, $this->offset, $q);

        $data['pagination'] = $this->configPagination($this->user_model->getTableTotalRows($this->user['user_type'], $q));

        $data['offset'] = $this->offset;

        $data['user_type'] = $this->user['user_type'];

        $data['q'] = $q;
      //   var_dump($q);
        $content = $this->load->view('user/list', $data, true);
        $this->template->show('template/admin', $content, 'User');
    }

    private function show($content) 
    {
        $template['user'] = $this->user;
        $template['content'] = $content;
        $this->load->view('template/admin', $template);
    }

    public function new()
    {
        $this->load->library('form_validation');
        $data = array();
        if ($this->input->method() == 'post')
        {
            // $this->form_validation->set_rules('id_engine', 'Crawler Engine', 'required');
            $this->form_validation->set_rules('username', 'Username', 'required|valid_email|is_unique[tbl_users.username]', array('is_unique' => 'Email / Username already exists.'));
            $this->form_validation->set_rules('name', 'Name', 'required');
            $this->form_validation->set_rules('password', 'Password', 'required');
            $this->form_validation->set_rules('conf_password', 'Retype Password', 'required|matches[password]');
            if ($this->form_validation->run() === TRUE)
            {
                // $user['id_engine'] = $this->input->post('id_engine');
                $user['username'] = $this->input->post('username', true);
                $user['name'] = $this->input->post('name', true);
                $user['user_type'] = $this->input->post('user_type', true);
                $user['active'] = $this->input->post('active') ? 1 : 0;
                $user['password'] = $this->input->post('password', true);
                $user['ig_username'] = $this->input->post('ig_username', true);
                if ($this->user_model->insert($user))
                {
                    # jika tipe = user, tambahkan user baru ke tabel tracking_menu
                    $tracking_menu_msg = '';
                    if ($user['user_type'] == '3') {
                        $id_user = $this->db->insert_id();
                        $inserted = $this->menu_model->insertUser($id_user);
                        if ($inserted == 0) $tracking_menu_msg = '<br/> But failed to create a row in tracking menu [important]';
                    }

                    $this->session->set_flashdata('flash_msg', msg('New user '.$user['username'].' has been saved.'.$tracking_menu_msg, 'success'));
                    redirect('user','refresh');
                    return;
                }
                else
                {
                    $data['message'] = 'Sorry, your data could not be saved.';
                }
            }
        }
        // $data['engines'] = $this->engine_model->getEngineForOption();
        $content = $this->load->view('user/form_new', $data, true);
        $this->template->show('template/admin', $content, 'Register a New User');
    }

    public function edit($id_user = null) 
    {
        if (empty($id_user))
        {
            redirect('user');
            return;
        }
        
        $this->load->library('form_validation');

        // $data['engines'] = $this->engine_model->getEngineForOption();

        if ($this->input->method() == 'post') {
            if (isset($_POST['name']))
            {
                # Update User Data
                // $this->form_validation->set_rules('id_engine', 'Crawler Engine', 'required');
                $this->form_validation->set_rules('username', 'Username', 'required|valid_email', array('is_unique' => 'Email / Username already exists.'));
                $this->form_validation->set_rules('name', 'Name', 'required');
                $this->form_validation->set_rules('user_type', 'User Type', 'required');
                // $user['id_engine']  = $this->input->post('id_engine');
                $user['username']   = $this->input->post('username', true);
                $user['name']       = $this->input->post('name', true);
                $user['user_type']  = $this->input->post('user_type', true);
                $user['active']     = $this->input->post('active') ? 1 : 0;
                $user['ig_username']= $this->input->post('ig_username', true);
                if ($this->form_validation->run() === TRUE)
                {
                    $user['id_user'] = $id_user;
                    if ($this->user_model->update($user) > 0)
                    {
                        $data['message'] = msg('Update was successfuly saved', 'success');
                        $data['row'] = $this->user_model->getUser($id_user);
                    }
                    else
                    {
                        $data['message'] = msg('Sorry, your data could not be saved', 'danger');
                        // $data['row']['id_engine'] = set_value('id_engine');
                        $data['row']['username']   = set_value('username');
                        $data['row']['name']       = set_value('name');
                        $data['row']['user_type']  = set_value('user_type');
                        $data['row']['active']     = set_value('active');
                        $data['row']['ig_username']= set_value('ig_username');
                        $data['row']['id_user']    = $id_user;
                    }
                }
                else
                {
                    // $data['row']['id_engine'] = set_value('id_engine');
                    $data['row']['username']   = set_value('username');
                    $data['row']['name']       = set_value('name');
                    $data['row']['user_type']  = set_value('user_type');
                    $data['row']['active']     = set_value('active');
                    $data['row']['ig_username']= set_value('ig_username');
                    $data['row']['id_user']    = $id_user;
                }
            } 
            elseif (isset($_POST['password']))
            {
                # Reset User Password
                $this->form_validation->set_rules('password', 'Password', 'required');
                $this->form_validation->set_rules('conf_password', 'Retype Password', 'required|matches[password]');
                $user['password']   = $this->input->post('password', true);
                if ($this->form_validation->run() === TRUE)
                {
                    $user['id_user'] = $id_user;
                    if ($this->user_model->update($user) > 0)
                    {
                        $data['message'] = msg('User password was successfuly changed', 'success');
                    }
                    else
                    {
                        $data['message'] = msg('Sorry, reset password failed.', 'danger');
                    }
                    $data['row'] = $this->user_model->getUser($id_user);
                }
                else
                {
                    $data['row'] = $this->user_model->getUser($id_user);
                }
            }
            else
            {
                $data['row'] = $this->user_model->getUser($id_user);
            }
        }
        else
        {
            $data['row'] = $this->user_model->getUser($id_user);
        }
        $content = $this->load->view('user/form_update', $data, true);
        $this->template->show('template/admin', $content, 'Edit User');
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

    public function delete($id_user)
    {   
        $this->user_model->delete($id_user);
        $this->menu_model->deleteUser($id_user);

        $data['message'] = msg('User was successfuly deleted', 'success');
        redirect('user');
        return;
    }
}
