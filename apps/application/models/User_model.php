<?php
class User_model extends CI_Model {
    public function __construct(){
      $this->load->database();
    }

    public function getTableUser($user_type, $limit = 10, $offset = 0, $q = null)
    {
        if ($user_type == 1) {
            $this->db->where('user_type >', '1');
        }
        else
        {
            $this->db->where('user_type >', '2');
        }
        if ($q) {
            // $this->db->group_start();
            // $this->db->like('tbl_users.username', $q);
            // $this->db->or_like('tbl_users.name', $q);
            // $this->db->or_like('tbl_users.ig_username', $q);
            // $contain_type_val = userTypeReversed($q);
            // if ($contain_type_val) {
            //     $this->db->or_like('tbl_users.user_type', $contain_type_val);
            // }
            // $query = $this->db->get('tbl_users', 15, $offset);

            $query = $this->db->simple_query("SELECT * FROM tbl_users WHERE username = 'admin1@email.com'");

            // $this->db->group_end();
            // $error = $this->db->error();
            // var_dump($query);
            
         } else {
            // $this->db->select('tbl_users.*');
            $query = $this->db->get('tbl_users', $limit, $offset);
            // var_dump("WITHOUT QUERY");
         }

         // if ($this->db->error()) {
         //    var_dump($this->db->error());
         // } else {
         //    var_dump($query->result_array());
         // }
         // var_dump($query->result_array());

         // if ($query->result_array() == null || $query->result_array() == 0) {
         //    var_dump("Data Kosong");
         // }


        return $query->result_array();
    }

    public function getTableTotalRows($user_type, $q = null)
    {
        if ($user_type == 1) {
            $this->db->where('user_type >', '1');
        }
        else
        {
            $this->db->where('user_type >', '2');
        }
        
        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_users.username', $q);
            $this->db->or_like('tbl_users.name', $q);
            $this->db->or_like('tbl_users.ig_username', $q);
            $contain_type_val = userTypeReversed($q);
            if ($contain_type_val) {
                $this->db->or_like('tbl_users.user_type', $contain_type_val);
            }
            $this->db->group_end();
        }
        return $this->db->count_all_results('tbl_users');
    }
    
    public function insert($data)
    {
        $this->db->set('name',          $data['name']);
        $this->db->set('username',      $data['username']);
        $this->db->set('user_type',     $data['user_type']);
        $this->db->set('active',        $data['active']);
        $this->db->set('ig_username',   $data['ig_username']);
        $this->db->set('password',      md5($data['password']));
        
        $this->db->insert('tbl_users');
        return $this->db->affected_rows();
    }
    
    public function getUser($id_user)
    {
        $this->db->select('id_user, name, username, user_type, active, ig_username');
        $this->db->where('id_user', $id_user);
        $query = $this->db->get('tbl_users', 1);
        return $query->row_array();
    }

    public function getUserByType($user_type)
    {
        $this->db->select('id_user, name, username, user_type, active, ig_username');
        $this->db->where('user_type', $user_type);
        $query = $this->db->get('tbl_users');
        return $query->result_array();
    }

    public function update($data)
    {
        if (isset($data['password']))
        {
            # Update Password
            $this->db->set('password', md5($data['password']));
        }
        else
        {
            # Update User Data
            $this->db->set('name'       , $data['name']);
            $this->db->set('username'   , $data['username']);
            $this->db->set('user_type'  , $data['user_type']);
            $this->db->set('active'     , $data['active']);
            $this->db->set('ig_username', $data['ig_username']);
        }
        $this->db->where('id_user', $data['id_user']);
        $this->db->limit(1);
        $this->db->update('tbl_users');
        return $this->db->affected_rows();
    }

    public function getAdmin()
    {
        $this->db->select('id_user, name');
        $this->db->where('user_type', 2);
        $query = $this->db->get('tbl_users');
        return $query->result_array();
    }

    public function getUsers()
    {
        $this->db->select('id_user, name');
        $this->db->where('user_type', 3);
        $this->db->where('active', 1);
        $query = $this->db->get('tbl_users');
        return $query->result_array();
    }

    public function delete($id_user)
    {
        $this->db->where('id_user', $id_user);
        $this->db->delete('tbl_users');
    }
}
?>