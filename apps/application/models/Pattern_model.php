<?php
class Pattern_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function sp_keyword_cycle($args)
    {
        $query = $this->db->query("CALL `p_get_keyword_result_by_user_id`(?)", $args);
        $result = $query->result_array();

        $query->next_result(); 
        $query->free_result();


        $arr = array();

        foreach ($result as $key => $item) {
            $arr[$item['dow']][$key] = $item;
        }

        ksort($arr, SORT_NUMERIC);

        return $arr;
    }

    public function sp_source($id_user, $dow, $keyword, $id_label)
    {
        $query = $this->db->query("CALL `p_get_keyword_result_page_by_keyword`(?, ?, ?, ?)", array(
            'i_user_id' => $id_user,
            'i_dow'     => $dow,
            'i_keyword' => $keyword,
            'i_id_label'=> $id_label
        ));
        $result = $query->result_array();

        $query->next_result(); 
        $query->free_result();
        
        return $result;
    }

}
