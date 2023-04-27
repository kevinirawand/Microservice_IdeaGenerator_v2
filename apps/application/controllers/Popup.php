<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Popup extends CI_Controller 
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('user_model');
        $this->load->helper('MY_user');
        $this->auth_model->cekLogin(true);

        $this->load->library('template');

        $this->load->model('popup_model');
    }

    public function index()
    {
        $this->load->helper('form_helper');

        if ($this->input->method() == 'post')
        {
            $popup['title']     = $this->input->post('ititle', true);
            $popup['message']   = $this->input->post('imessage', true);
            $popup['active']    = $this->input->post('iactive');

            if ($this->popup_model->setPopup($popup))
            {
                $this->session->set_flashdata('flash_msg', msg('Pop up dialog was successfuly updated.', 'success'));
                redirect('popup','refresh');
                return;
            }

            $data['popup'] = $popup;
        }
        else
        {
            $data['popup'] = $this->popup_model->getPopup();
        }
        
        $content = $this->load->view('popup/form', $data, true);
        $this->template->show('template/admin', $content, 'Pop Up');
    }
}
?>