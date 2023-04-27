<?php
class Viral_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function isDataExist($timestamp)
    {
        $query = $this->db->query('
            SELECT * FROM tbl_results
            WHERE DATE(updated) = "'.date( "Y-m-d", $timestamp ).'"
            LIMIT 0,1
        ');

        if ($query->num_rows() > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public function getLatestUpdate($id_user)
    {
        $query = $this->db->query('
            SELECT DATE(MAX(updated)) as lastdate FROM tbl_results
            WHERE id_user = "'.$id_user.'"
        ');

        if ($query->num_rows() > 0)
        {
            return $query->row_array()['lastdate'];
        }
        else
        {
            return false;
        }
    }

    public function get_keywords($id_user, $category, $id_label, $day_count, $offset)
    {
        // $query = $this->db->query('
		// 	SELECT * FROM tbl_results
		// 	WHERE id_user = "'.$id_user.'"
		// 	AND category = "'.$category.'"
		// 	AND id_label = "'.$id_label.'"
        //     AND day_count = "'.$day_count.'"
        //     AND DATE(updated) = "'.date( "Y-m-d" ).'"
		// 	ORDER BY p_value DESC
		// 	LIMIT '.$offset.',5
		// ');
        $query = $this->db->query('
			SELECT * FROM tbl_results
			WHERE id_user = "'.$id_user.'"
			AND category = "'.$category.'"
			AND id_label = "'.$id_label.'"
            AND day_count = "'.$day_count.'"
            AND DATE(updated) = (
                SELECT DATE(MAX(updated))
                FROM tbl_results
                WHERE id_user = "'.$id_user.'"
            )
			ORDER BY p_value DESC
			LIMIT '.$offset.',5
		');
        return $query->result_array();
    }

    public function get_keyword_source($keyword, $id_user, $category, $day_count)
    {
        $query = $this->db->query("CALL p_get_sumber_keyword(?,?,?,?)", array(
            'iid_user' => $id_user,
            'icategory' => $category,
            'inormal_text' => $keyword,
            'iinterval' => $day_count
        ));
        return $query->result_array();
    }

    public function search_keyword($keyword, $id_user, $category, $day_count)
    {
        // $result = [1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => []];
        // for ($i=0; $i < 6; $i++) { 
            
            $query = $this->db->query('
                SELECT * FROM tbl_results
                WHERE id_user = '.$id_user.'
                AND category = "'.$category.'"
                AND day_count = '.$day_count.'
                AND	normal_text LIKE "%'.$keyword.'%"
                AND DATE(updated) = "'.date( "Y-m-d" ).'"
                ORDER BY id_label ASC, p_value DESC
            ');
            return $query->result_array();
            
        // }
    }
}