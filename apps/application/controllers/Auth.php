<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Auth extends CI_Controller {
    
    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->helper('cookie');
    }
    
    public function login($username = null)
    {
        $user = $this->session->userdata('user');
        if (!empty($user))
        {
            $this->_showHomePage($user['user_type']);
            return;
        }
        else
        {
            $token = $this->input->cookie('token');
            if (!empty($token))
            {
                $user = $this->auth_model->selectUserByToken($token);
                if (empty($user) || $user == [] || $user['active'] == 0)
                {
                    $this->_destroyUserData();
                    $this->_showLoginPage();
                    return;
                }
                else
                {
                    $this->_storeToSession($user);
                    $this->_showHomePage($user['user_type']);
                    return;
                }
            }
            else
            {
                $this->_showLoginPage();
                return;
            }
        }
    }
    
    private function _storeToSession($user)
    {
        $this->session->set_userdata('user', array(
            'id_user' => $user['id_user'],
            'name' => $user['name'],
            'username' => $user['username'],
            'user_type' => $user['user_type'],
            'ig_username' => $user['ig_username']
        ));
    }
    
    private function _showLoginPage()
    {
        $this->load->helper('form');
        $this->load->library('form_validation');

        $this->form_validation->set_rules('username', 'Email/User ID', 'required');
        $this->form_validation->set_rules('password', 'Password', 'required');
        if ($this->form_validation->run() === FALSE)
        {
            $data['alert'] = $this->session->flashdata('alert');
            $this->load->view('auth/login', $data);
        }
        else
        {
            $username = $this->input->post('username', true);
            $password = $this->input->post('password', true);
            $remember = $this->input->post('remember');
            $user     = $this->auth_model->login($username, $password);

            if (empty($user))
            {
                $this->session->set_flashdata('alert', 'Invalid Email/User ID or Password!');
                redirect('login','refresh');
                return;
            }
            else
            {
                if ($user['active'] == 0)
                {
                    $this->session->set_flashdata('alert', 'This account is currently inactive');
                    redirect('login','refresh');
                    return;
                }
                else
                {
                    $this->_storeToSession($user);
                    if ($remember)
                    {
                        $token = hash('ripemd256', time()."".$user['id_user']);
                        $this->db->set('token', $token);
                        $this->db->where('id_user', $user['id_user']);
                        $this->db->update('tbl_users');
                        $this->input->set_cookie('token', $token, (3600*24*7));
                    }
                    $this->_showHomePage($user['user_type']);
                    return;
                }
            }
        }
    }
    
    private function _showHomePage($userType)
    {
        switch ($userType) {
            case 1:
            case 2:
                redirect('crawling/table/with_history');
                break;
            case 3:
                // redirect('dashboard/a');
                redirect('home');
                break;
            default:
                redirect('','refresh');
                break;
        }
    }

    public function logout()
    {
        $this->_destroyUserData();
        $this->session->set_flashdata('alert', 'You are successfuly loged out');
        $this->_showLoginPage();
    }
    
    private function _destroyUserData()
    {
        $this->session->sess_destroy();
        $this->input->set_cookie('token','','');
        delete_cookie('token');
    }
}
