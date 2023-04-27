<?php

class Auth_model extends CI_Model {

    public function __construct()
    {
        $this->load->database();
    }

    public function cekLogin($redirectToLogin = true)
    {
        if ($this->session->userdata('user')) 
        {
            return true;
        }
        else
        {
            if ($redirectToLogin)
            {
                redirect('login','refresh');
            }
            return false;
        }
    }

    public function getUser()
    {
        $user = $this->session->userdata('user');
        return $user;
    }
    
    public function login($username, $password)
    {
        $this->db->where('username', $username);
        $this->db->where('password', md5($password));
        $this->db->limit(1);
        $query = $this->db->get('tbl_users');
        return $query->row_array();
    }
    
    public function selectUserByToken($token)
    {
        $this->db->where('token', $token);
        $query = $this->db->get('tbl_users', 1);
        return $query->row_array();
    }

    public function hasContributor($user) {
        $this->db->where('user_id', $user['id_user']);
        if($this->db->count_all_results('tbl_contributors') > 0) {
            return true;
        } else {
            return false;
        }
    }
}
?>