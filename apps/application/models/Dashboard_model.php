<?php
class Dashboard_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getDashboardA($id_user, $category, $day_count, $id_label)
    {
        // $query = $this->db->query('CALL get_dashboard_a(?,?,?)', array(
        //     'iid_user' => $id_user,
        //     'icategory' => $category,
        //     'idate_start' => $date_start
        // ));

        // $this->db->select('')

        // $this->db->where('id_user', $id_user);
        // $this->db->where('category', $category);
        // $this->db->where('day_count', $day_count);
        
        // $query = $this->db->get('tbl_results');
        // return $query->result_array();

        $query = $this->db->query("CALL p_result_dashboard_a(?,?,?,?)", array(
            'iid_user' => $id_user,
            'iinterval' => $day_count,
            'icategory' => $category,
            'iid_label' => $id_label
        ));
        return $query->result_array();
    }

    public function getDashboardB($id_user)
    {
        $query = $this->db->query("CALL p_scraping_summary_by_client(?)", array(
            'iid_user' => $id_user
        ));
        return $query->result_array();
    }

    public function getSumberKeyword($keyword, $id_user, $category, $day_count)
    {
        $query = $this->db->query("CALL p_get_sumber_keyword(?,?,?,?)", array(
            'iid_user' => $id_user,
            'icategory' => $category,
            'inormal_text' => $keyword,
            'iinterval' => $day_count
        ));
        return $query->result_array();
    }
}