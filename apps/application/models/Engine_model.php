<?php
class Engine_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getTable($limit, $offset, $q = null)
    {
        if ($q) {
            $this->db->group_start();
            $this->db->like('ig_username', $q);
            $this->db->or_like('ig_password', $q);
            $this->db->group_end();
        }
        $query = $this->db->get('tbl_engines', $limit, $offset);
        return $query->result_array();
    }

    public function getTableTotalRows($q = null)
    {
        if ($q) {
            $this->db->group_start();
            $this->db->like('ig_username', $q);
            $this->db->like('ig_password', $q);
            $this->db->group_end();
        }
        return $this->db->count_all_results('tbl_engines');
    }

    public function getById($id_engine)
    {
        $this->db->where('id_engine', $id_engine);
        $query = $this->db->get('tbl_engines', 1);
        return $query->row_array();
    }

    public function update($data)
    {
        $this->db->set('ig_username', $data['ig_username']);
        $this->db->set('ig_password', $data['ig_password']);
        $this->db->where('id_engine', $data['id_engine']);
        $this->db->limit(1);
        $this->db->update('tbl_engines');
        return $this->db->affected_rows();
    }

    public function insert($data)
    {
        $this->db->set('ig_username', $data['ig_username']);
        $this->db->set('ig_password', $data['ig_password']);
        $this->db->insert('tbl_engines');
        return $this->db->affected_rows();
    }

    public function getEngineForOption()
    {
        $this->db->select('id_engine, ig_username');
        $query = $this->db->get('tbl_engines');
        return $query->result_array();
    }

    public function delete($id_engine)
    {
        $this->db->where('id_engine', $id_engine);
        $query = $this->db->delete('tbl_engines');
    }
}