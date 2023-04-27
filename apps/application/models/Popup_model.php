<?php
class Popup_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getPopup()
    {
        $query = $this->db->get('tbl_popup', 1);
        return $query->row_array();
    }
    
    public function setPopup($popup)
    {
        $this->db->set('title', $popup['title']);
        $this->db->set('message', $popup['message']);
        $this->db->set('active', $popup['active']);
        $this->db->update('tbl_popup');
        
        return $this->db->affected_rows();
    }
}
