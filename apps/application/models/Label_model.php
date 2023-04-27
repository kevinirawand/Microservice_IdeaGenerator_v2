<?php
class Label_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getAll()
    {
        $query = $this->db->get('tbl_labels');
        return $query->result_array();
    }
}