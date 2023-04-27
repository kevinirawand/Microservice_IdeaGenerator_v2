<?php
class Classification_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getTable($limit = 10, $offset = 0, $q = null)
    {
        $this->db->select('tbl_classifications.id_normalization, tbl_classifications.id_crawling, normal_text, label_name');
        $this->db->join('tbl_normalizations', 'tbl_classifications.id_normalization = tbl_normalizations.id_normalization');
        $this->db->join('tbl_labels', 'tbl_classifications.id_label = tbl_labels.id_label');
        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_classifications.id_crawling', $q);
            $this->db->or_like('tbl_labels.label_name', $q);
            $this->db->or_like('tbl_normalizations.normal_text', $q);
            $this->db->group_end();
        }
        $query = $this->db->get('tbl_classifications', $limit, $offset);
        return $query->result_array();
    }

    public function getTableTotalRows($q = null)
    {
        $this->db->join('tbl_normalizations', 'tbl_classifications.id_normalization = tbl_normalizations.id_normalization');
        $this->db->join('tbl_labels', 'tbl_classifications.id_label = tbl_labels.id_label');
        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_classifications.id_crawling', $q);
            $this->db->or_like('tbl_labels.label_name', $q);
            $this->db->or_like('tbl_normalizations.normal_text', $q);
            $this->db->group_end();
        }
        return $this->db->count_all_results('tbl_classifications');
    }

    public function classification($data, $id_crawling)
    {
        if (empty($data)) return 0;
        $this->db->where('id_crawling', $id_crawling);
        $this->db->delete('tbl_classifications');
        $this->db->reset_query();

        $postData = array();
        foreach ($data as $key => $value) {
            $postData[] = array(
                'id_normalization' => $key,
                'id_label' => $value,
                'id_crawling' => $id_crawling
            );
        }
        $this->db->insert_batch('tbl_classifications', $postData);
        return $this->db->affected_rows();
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
        $this->db->limit(1);
        $this->db->update('tbl_crawling');
        return $this->db->affected_rows();
    }

    public function setIsNormalized($id_crawling, $is_normalized = 1)
    {
        if (empty($id_crawling)) return 0;
        $this->db->where('id_crawling', $id_crawling);
        $this->db->set('is_normalized', $is_normalized);
        $this->db->limit(1);
        $this->db->update('tbl_crawling');
        return $this->db->affected_rows();
    }
}