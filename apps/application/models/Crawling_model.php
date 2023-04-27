<?php
class Crawling_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getTable($limit = 10, $offset = 0, $showhHistory = false, $q = null)
    {
        $this->db->order_by('taken_at', 'DESC');
        if (!$showhHistory)
        {
            $this->db->where('is_classified', 0);
        }

        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_crawling.ig_username', $q);
            $this->db->or_like('tbl_crawling.follower_count', $q);
            $this->db->or_like('tbl_crawling.like_count', $q);
            $this->db->or_like('tbl_crawling.caption_text', $q);
            $this->db->or_like('tbl_crawling.taken_at', $q);
            $this->db->or_like('tbl_crawling.id_crawling', $q);
            $this->db->or_like('tbl_crawling.time_frame', $q);
            $this->db->group_end();
        }
        
        $query = $this->db->get('tbl_crawling', $limit, $offset);
        return $query->result_array();
    }

    public function getTableTotalRows($showhHistory = false, $q = null)
    {
        if (!$showhHistory)
        {
            $this->db->where('is_classified', 0);
        }
        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_crawling.ig_username', $q);
            $this->db->or_like('tbl_crawling.follower_count', $q);
            $this->db->or_like('tbl_crawling.like_count', $q);
            $this->db->or_like('tbl_crawling.caption_text', $q);
            $this->db->or_like('tbl_crawling.taken_at', $q);
            $this->db->or_like('tbl_crawling.id_crawling', $q);
            $this->db->or_like('tbl_crawling.time_frame', $q);
            $this->db->group_end();
        }
        return $this->db->count_all_results('tbl_crawling');
    }

    public function getById($id_crawling)
    {
        if (empty($id_crawling)) return [];
        $this->db->where('id_crawling', $id_crawling);
        $query = $this->db->get('tbl_crawling', 1);
        return $query->row_array();
    }

    public function setIsExtracted($id_crawling, $is_extracted = 1)
    {
        if (empty($id_crawling)) return 0;
        $this->db->where('id_crawling', $id_crawling);
        $this->db->set('is_extracted', $is_extracted);
        $this->db->set('is_normalized', 0);
        $this->db->set('is_classified', 0);
        $this->db->limit(1);
        $this->db->update('tbl_crawling');
        return $this->db->affected_rows();
    }

    public function setIsNormalized($id_crawling, $is_normalized = 1)
    {
        if (empty($id_crawling)) return 0;
        $this->db->where('id_crawling', $id_crawling);
        $this->db->set('is_normalized', $is_normalized);
        $this->db->set('is_classified', 0);
        $this->db->limit(1);
        $this->db->update('tbl_crawling');
        return $this->db->affected_rows();
    }

    public function setIsClassified($id_crawling, $is_classified = 1)
    {
        if (empty($id_crawling)) return 0;
        $this->db->where('id_crawling', $id_crawling);
        $this->db->set('is_classified', $is_classified);
        $this->db->limit(1);
        $this->db->update('tbl_crawling');
        return $this->db->affected_rows();
    }
}