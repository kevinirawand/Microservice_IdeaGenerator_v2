<?php

class Menu_model extends CI_Model
{
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }

    public function getTrackingMenu( $q = null )
    {
        if ($q) {
            $this->db->group_start();
            $this->db->like('name', $q);
            $this->db->group_end();
        }
        $this->db->select('tbl_tracking_menu.*, tbl_users.name, tbl_users.active');
        $this->db->join('tbl_users', 'tbl_tracking_menu.id_user = tbl_users.id_user', 'left');
        
        $query = $this->db->get('tbl_tracking_menu');
        return $query->result_array();
    }
    
    public function increaseClick($menu_field, $id_user)
    {
        $this->db->query('
            UPDATE tbl_tracking_menu
            SET '.$menu_field.' = '.$menu_field.' + 1
            WHERE id_user = "'.$id_user.'"
        ');
        return $this->db->affected_rows();
    }

    public function insertUser($id_user)
    {
        $this->db->set('id_user', $id_user);
        $this->db->insert('tbl_tracking_menu');

        return $this->db->affected_rows();
    }

    public function deleteUser($id_user)
    {
        $this->db->where('id_user', $id_user);
        $this->db->delete('tbl_tracking_menu');
    }
}
