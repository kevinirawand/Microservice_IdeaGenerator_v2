<?php
class Normalization_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getByCrawling($id_crawling)
    {
        if (empty($id_crawling)) return [];

        $this->db->where('id_crawling', $id_crawling);
        $query = $this->db->get('tbl_normalizations');
        return $query->result_array();
    }

    public function insert_batch($data)
    {
        $id_crawling = $data[0]['id_crawling'];
        $this->db->delete('tbl_normalizations', 'id_crawling = '.$id_crawling);
        $this->db->reset_query();
        $this->db->insert_batch('tbl_normalizations', $data);
        return $this->db->affected_rows();
    }

    public function getTable($limit = 20, $offset = 0, $q = null)
    {
        $this->db->select('tbl_normalizations.*, tbl_extractions.keyword');
        $this->db->join('tbl_extractions', 'tbl_extractions.id_extraction = tbl_normalizations.id_extraction', 'left');
        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_normalizations.normal_text', $q);
            $this->db->or_like('tbl_normalizations.id_crawling', $q);
            $this->db->or_like('tbl_extractions.keyword', $q);
            $this->db->group_end();
        }
        $query = $this->db->get('tbl_normalizations', $limit, $offset);
        return $query->result_array();
    }

    public function getTableTotalRows($q = null)
    {
        $this->db->join('tbl_extractions', 'tbl_extractions.id_extraction = tbl_normalizations.id_extraction', 'left');
        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_normalizations.normal_text', $q);
            $this->db->or_like('tbl_normalizations.id_crawling', $q);
            $this->db->or_like('tbl_extractions.keyword', $q);
            $this->db->group_end();
        }
        return $this->db->count_all_results('tbl_normalizations');
    }
}