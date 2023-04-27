<?php
class Extraction_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getTable($limit = 10, $offset = 0, $q = null)
    {
        $this->db->where('is_normalize', 0);
        $this->db->group_start();
        $this->db->like('tbl_extractions.id_crawling', $q);
        $this->db->or_like('tbl_extractions.keyword', $q);
        $this->db->group_end();
        $this->db->order_by('id_crawling', 'DESC');
        $query = $this->db->get('tbl_extractions', $limit, $offset);
        return $query->result_array();
    }

    public function getTableTotalRows($q = null)
    {
        $this->db->where('is_normalize', 0);
        $this->db->group_start();
        $this->db->like('tbl_extractions.id_crawling', $q);
        $this->db->or_like('tbl_extractions.keyword', $q);
        $this->db->group_end();
        return $this->db->count_all_results('tbl_extractions');
    }

    public function getById($id_extraction)
    {
        if (empty($id_extraction)) return [];
        $this->db->where('id_extraction', $id_extraction);
        $query = $this->db->get('tbl_extractions', 1);
        return $query->row_array();
    }

    public function insert_batch($data)
    {
        $id_crawling = $data[0]['id_crawling'];
        $this->db->delete('tbl_extractions', 'id_crawling = '.$id_crawling);
        $this->db->delete('tbl_normalizations', 'id_crawling = '.$id_crawling);
        $this->db->delete('tbl_classifications', 'id_crawling = '.$id_crawling);
        $this->db->reset_query();
        $this->db->insert_batch('tbl_extractions', $data);
        return $this->db->affected_rows();
    }

    public function getByCrawling($id_crawling)
    {
        if (empty($id_crawling)) return [];

        $this->db->where('id_crawling', $id_crawling);
        $query = $this->db->get('tbl_extractions');
        return $query->result_array();
    }
}