<?php
class Contributor_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getTable($limit = 10, $offset = 0, $q = null, $user_id=null)
    {
        $this->db->select('tbl_contributors.*, tbl_users.name AS user');
        $this->db->join('tbl_users', 'tbl_users.id_user = tbl_contributors.user_id');
        if(!$user_id) {
            $this->db->where('tbl_users.id_user', $user_id);
        }
        $this->db->where('tbl_contributors.user_id', $user_id);
        $this->db->order_by('created', 'DESC');
        $query = $this->db->get('tbl_contributors', $limit, $offset);
        return $query->result();
    }

    public function get_contributor_id_list($user_id) 
    {
        $this->db->select('tbl_contributors.contributor_id');
        $this->db->join('tbl_users', 'tbl_users.id_user = tbl_contributors.user_id');
        if(!$user_id) {
            $this->db->where('tbl_users.id_user', $user_id);
        }
        $this->db->where('tbl_contributors.user_id', $user_id);
        $query = $this->db->get('tbl_contributors');
        return $query->result_array();
    }

    public function getTableTotalRows($q = null)
    {
        return $this->db->count_all_results('tbl_contributors');
    }

    public function getById($contributor_id){
        return $this->db->get_where('tbl_contributors', array('contributor_id' => $contributor_id))->row();
    }
    
    public function insert($data)
    {
        $this->db->set('name', $data['name']);
        $this->db->set('ig_username', $data['ig_username']);
        $this->db->set('user_id', $data['user_id']);
        $this->db->insert('tbl_contributors');
        return $this->db->affected_rows();
    }

    public function update($data)
    {
        $this->db->set('ig_username', $data['ig_username']);
        $this->db->set('user_id', $data['user_id']);
        $this->db->set('name', $data['name']);
        $this->db->set('bidang', $data['bidang']);
        $this->db->where('contributor_id', $data['contributor_id']);
        $this->db->update('tbl_contributors');
        return $this->db->affected_rows();
    }

    public function delete($ig_username){
        $this->db->where('ig_username', $ig_username);
        $this->db->delete('tbl_contributors');
    }

    public function get_content_and_response($ig_username, $interval, $year, $month, $day)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n');
        if (!isset($day)) $day = date('d');

        if($interval == 'daily') {
            $query = $this->db->query('
                SELECT COUNT(id) AS post_count, AVG((response_count / comment_count) * 100) as respon_avg
                FROM tbl_scraping
                WHERE ig_username = "'.$ig_username.'"
                AND DATE(taken_at) = "'.$year.'-'.$month.'-'.$day.'"
            ');
            return $query->result_array();
        } else if($interval == 'weekly') {
            $query = $this->db->query('
                SELECT COUNT(id) AS post_count, AVG((response_count / comment_count) * 100) as respon_avg
                FROM tbl_scraping
                WHERE ig_username = "'.$ig_username.'"
                AND DATE(taken_at) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY))
            ');
            return $query->result_array();
        } else {
            $query = $this->db->query('
                SELECT COUNT(id) AS post_count, AVG((response_count / comment_count) * 100) as respon_avg
                FROM tbl_scraping
                WHERE ig_username = "'.$ig_username.'"
                AND DATE(taken_at) >= DATE(DATE_ADD(NOW(), INTERVAL -1 MONTH))
            ');
            return $query->result_array();
        }
    }

    public function get_like_and_comment($user_id, $interval, $year, $month, $day)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n');
        if (!isset($day)) $day = date('d');

        if($interval == 'daily') {
            $query = $this->db->query('
                SELECT SUM(cr.is_like) AS like_count, SUM(cr.is_comment) AS comment_count
                FROM tbl_contributor_results cr
                JOIN tbl_contributors c ON c.contributor_id = cr.contributor_id
                WHERE c.user_id = '.$user_id.'
                AND DATE(cr.post_date) = "'.$year.'-'.$month.'-'.$day.'"
            ');
            return $query->result_array();
        } else if($interval == 'weekly') {
            $query = $this->db->query('
                SELECT SUM(cr.is_like) AS like_count, SUM(cr.is_comment) AS comment_count
                FROM tbl_contributor_results cr
                JOIN tbl_contributors c ON c.contributor_id = cr.contributor_id
                WHERE c.user_id = '.$user_id.'
                AND DATE(cr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY))
            ');
            return $query->result_array();
        } else {
            $query = $this->db->query('
                SELECT SUM(cr.is_like) AS like_count, SUM(cr.is_comment) AS comment_count
                FROM tbl_contributor_results cr
                JOIN tbl_contributors c ON c.contributor_id = cr.contributor_id
                WHERE c.user_id = '.$user_id.'
                AND DATE(cr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -1 MONTH))
            ');
            return $query->result_array();
        }
    }

    public function get_rank_contributor($user_id, $interval, $year, $month, $day, $isTop=true, $limit=10)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n');
        if (!isset($day)) $day = date('d');

        $orderDirection = "DESC";

        if(!$isTop) {
            $orderDirection = "ASC";
        }

        if($interval == 'daily') {
            $query = $this->db->query('
            SELECT c.contributor_id, c.ig_username, c.name, c.bidang,t
            COUNT(CASE WHEN ccr.is_like > 0 AND DATE(ccr.post_date) = "'.$year.'-'.$month.'-'.$day.'" THEN ccr.id END) AS like_count,
            COUNT(CASE WHEN ccr.is_comment > 0 AND DATE(ccr.post_date) = "'.$year.'-'.$month.'-'.$day.'" THEN ccr.id END) AS comment_count
     FROM tbl_contributors c
     LEFT JOIN tbl_contributor_results ccr ON ccr.contributor_id = c.contributor_id
     WHERE c.user_id = $user_id
     GROUP BY c.contributor_id, c.ig_username, c.name, c.bidang
     ORDER BY like_count '.$orderDirection.'
     LIMIT '.$limit.'
            ');
            return $query->result_array();
        } else if($interval == 'weekly') {
            $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang, 
                (
                SELECT COUNT(ccr.id)
                FROM tbl_contributor_results ccr
                WHERE ccr.is_like > 0
                AND ccr.contributor_id = c.contributor_id
                AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY))
                ) AS like_count, 
                (
                SELECT COUNT(ccr.id)
                FROM tbl_contributor_results ccr
                WHERE ccr.is_comment > 0
                AND ccr.contributor_id = c.contributor_id
                AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY))
                ) AS comment_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
                ORDER BY like_count '.$orderDirection.'
                LIMIT '.$limit.'
            ');
            return $query->result_array();
        } else {
            $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang, 
                (
                SELECT COUNT(ccr.id)
                FROM tbl_contributor_results ccr
                WHERE ccr.is_like > 0
                AND ccr.contributor_id = c.contributor_id
                AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -1 MONTH))
                ) AS like_count, 
                (
                SELECT COUNT(ccr.id)
                FROM tbl_contributor_results ccr
                WHERE ccr.is_comment > 0
                AND ccr.contributor_id = c.contributor_id
                AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -1 MONTH))
                ) AS comment_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
                ORDER BY like_count '.$orderDirection.'
                LIMIT '.$limit.'
            ');
            return $query->result_array();
        }
    }

    public function get_zero_contributor($user_id, $interval, $year, $month, $day)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n');
        if (!isset($day)) $day = date('d');

        $orderDirection = "ASC";
        // TODO: change query for specific user_id in sub query
        // TODO: like_count and comment_count
        if($interval == 'daily') {
            $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang
                FROM tbl_contributors c
                WHERE c.contributor_id NOT IN (
                SELECT DISTINCT contributor_id 
                FROM tbl_contributor_results 
                WHERE is_like = 1 
                AND DATE(post_date) = "'.$year.'-'.$month.'-'.$day.'"
                )
                AND c.user_id = '.$user_id.'
                ORDER BY c.name
            ');
            return $query->result_array();
        } else if($interval == 'weekly') {
            $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang
                FROM tbl_contributors c
                WHERE c.contributor_id NOT IN (
                SELECT DISTINCT contributor_id 
                FROM tbl_contributor_results 
                WHERE is_like = 1 
                AND DATE(post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY))
                )
                AND c.user_id = '.$user_id.'
                ORDER BY c.name
            ');
            return $query->result_array();
        } else {
            $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang
                FROM tbl_contributors c
                WHERE c.contributor_id NOT IN (
                SELECT DISTINCT contributor_id 
                FROM tbl_contributor_results 
                WHERE is_like = 1 
                AND DATE(post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -1 MONTH))
                )
                AND c.user_id = '.$user_id.'
                ORDER BY c.name
            ');
            return $query->result_array();
        }
    }

    function urgent_get_all_contributor($user_id, $interval, $year, $month, $day, $contributor_id) {
        $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_like > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) = "'.$year.'-'.$month.'-'.$day.'"
                ) AS like_count, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_comment > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) = "'.$year.'-'.$month.'-'.$day.'"
                ) AS comment_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
                AND c.contributor_id = '.$contributor_id.'
            ');
        return $query->result_array();
    }

    public function api_get_all_contributor_urgent($user_id, $interval, $year, $month, $day, $contributor_id)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n');
        if (!isset($day)) $day = date('d');

        if($interval == 'daily') {
            $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_like > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) = "'.$year.'-'.$month.'-'.$day.'"
                ) AS like_count, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_comment > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) = "'.$year.'-'.$month.'-'.$day.'"
                ) AS comment_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
                AND c.contributor_id = '.$contributor_id.'
            ');
            return $query->result_array();
        } else if($interval == 'weekly') {
            $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_like > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY))
                ) AS like_count, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_comment > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY))
                ) AS comment_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
                AND c.contributor_id = '.$contributor_id.'
            ');
            return $query->result_array();
        } else {
            $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_like > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -1 MONTH))
                ) AS like_count, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_comment > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -1 MONTH))
                ) AS comment_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
                AND c.contributor_id = '.$contributor_id.'
            ');
            return $query->result_array();
        }
    }

    public function get_all_contributor($user_id, $interval, $year, $month, $day)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n');
        if (!isset($day)) $day = date('d');

        if($interval == 'daily') {
            //TODO: need more optimized
            $c_data = $this->get_contributor_id_list($user_id);
            $data = [];
            for ($i=0; $i < count($c_data); $i++) { 
                $d = $this->urgent_get_all_contributor($user_id, $interval, $year, $month, $day, ($c_data[$i]['contributor_id']));
                array_push($data, $d[0]);
            }
            return $data;
        } else if($interval == 'weekly') {
            $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_like > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY))
                ) AS like_count, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_comment > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY))
                ) AS comment_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
            ');
            return $query->result_array();
        } else {
            $query = $this->db->query('
                SELECT c.contributor_id, c.ig_username, c.name, c.bidang, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_like > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -1 MONTH))
                ) AS like_count, 
                (
                    SELECT COUNT(ccr.id)
                    FROM tbl_contributor_results ccr
                    WHERE ccr.is_comment > 0
                    AND ccr.contributor_id = c.contributor_id
                    AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -1 MONTH))
                ) AS comment_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
            ');
            return $query->result_array();
        }
    }

    public function get_data_line($user_id, $interval, $year, $month, $is_like=true)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n');

        $where_type = "AND is_like > 0";

        if(!$is_like) {
            $where_type = "AND is_comment > 0";
        }

        if($interval == 'daily') {
            $query = $this->db->query('
                SELECT DAY(cr.post_date) AS type_time, COUNT(cr.id) AS type_count
                FROM tbl_contributor_results cr
                JOIN tbl_contributors c ON c.contributor_id = cr.contributor_id
                WHERE MONTH(cr.post_date) = '.$month.' 
                AND c.user_id = '.$user_id.' 
                AND YEAR(cr.post_date) = '.$year.' 
                '.$where_type.'
                GROUP BY type_time
            ');
            return $query->result_array();
        } else if($interval == 'weekly') { //SELECT FLOOR((DayOfMonth(cr.post_date)-1)/7)+1 AS type_time, COUNT(cr.id) AS type_count
            $query = $this->db->query('
                SELECT FROM_DAYS(TO_DAYS(cr.post_date) - MOD(TO_DAYS(cr.post_date) -2, 7)) AS type_time, COUNT(cr.id) AS type_count
                FROM tbl_contributor_results cr
                JOIN tbl_contributors c ON c.contributor_id = cr.contributor_id
                WHERE MONTH(cr.post_date) = '.$month.' 
                AND c.user_id = '.$user_id.' 
                AND YEAR(cr.post_date) = '.$year.' 
                '.$where_type.'
                GROUP BY type_time
            ');
            // reformat data from type_time date to index
            $data = $query->result_array();
            foreach($data as $key=>$value) {
                $data[$key]['type_time'] = $key+1;
            }
            return $data;
        } else {
            $query = $this->db->query('
                SELECT (MONTH(cr.post_date)-1) AS type_time, COUNT(cr.id) AS type_count
                FROM tbl_contributor_results cr
                JOIN tbl_contributors c ON c.contributor_id = cr.contributor_id
                AND c.user_id = '.$user_id.' 
                AND YEAR(cr.post_date) = '.$year.' 
                '.$where_type.'
                GROUP BY type_time
            ');
            return $query->result_array();
        }
    }

    public function get_rank_sector($ig_username, $user_id, $interval, $year, $month, $day)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n');
        if (!isset($day)) $day = date('d');

        if($interval == 'daily') {
            $query = $this->db->query('
                SELECT COUNT(c.contributor_id) AS user_count, c.bidang, c.singkatan,
                (
                    SELECT COUNT(ccr.contributor_id) 
                    FROM tbl_contributors cc
                    JOIN tbl_contributor_results ccr ON cc.contributor_id = ccr.contributor_id
                    WHERE cc.bidang = c.bidang
                    AND ccr.is_like > 0
                    AND DATE(ccr.post_date) = "'.$year.'-'.$month.'-'.$day.'" 
                    AND cc.user_id = '.$user_id.'
                ) AS like_count,
                (
                    SELECT COUNT(id)
                   FROM tbl_scraping
                   WHERE ig_username = "'.$ig_username.'"
                   AND DATE(taken_at) = "'.$year.'-'.$month.'-'.$day.'"
                ) AS post_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
                AND c.bidang IS NOT NULL
                GROUP BY c.bidang, c.singkatan
                ORDER BY c.bidang
            ');
            return $query->result_array();
        } else if($interval == 'weekly') {
            $query = $this->db->query('
                SELECT COUNT(c.contributor_id) AS user_count, c.bidang, c.singkatan,
                (
                    SELECT COUNT(ccr.contributor_id) 
                    FROM tbl_contributors cc
                    JOIN tbl_contributor_results ccr ON cc.contributor_id = ccr.contributor_id
                    WHERE cc.bidang = c.bidang
                    AND ccr.is_like > 0
                    AND DATE(ccr.post_date) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY)) 
                    AND cc.user_id = '.$user_id.'
                ) AS like_count,
                (
                    SELECT COUNT(id)
                   FROM tbl_scraping
                   WHERE ig_username = "'.$ig_username.'"
                   AND DATE(taken_at) >= DATE(DATE_ADD(NOW(), INTERVAL -7 DAY))
                ) AS post_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
                AND c.bidang IS NOT NULL
                GROUP BY c.bidang, c.singkatan
                ORDER BY c.bidang
            ');
            return $query->result_array();
        } else {
            $query = $this->db->query('
                SELECT COUNT(c.contributor_id) AS user_count, c.bidang, c.singkatan,
                (
                    SELECT COUNT(ccr.contributor_id) 
                    FROM tbl_contributors cc
                    JOIN tbl_contributor_results ccr ON cc.contributor_id = ccr.contributor_id
                    WHERE cc.bidang = c.bidang
                    AND ccr.is_like > 0
                    AND YEAR(ccr.post_date) = '.$year.' 
                    AND MONTH(ccr.post_date) = '.$month.' 
                    AND cc.user_id = '.$user_id.'
                ) AS like_count,
                (
                    SELECT COUNT(id)
                   FROM tbl_scraping
                   WHERE ig_username = "'.$ig_username.'"
                   AND YEAR(taken_at) = '.$year.' 
                   AND MONTH(taken_at) = '.$month.'
                ) AS post_count
                FROM tbl_contributors c
                WHERE c.user_id = '.$user_id.'
                AND c.bidang IS NOT NULL
                GROUP BY c.bidang, c.singkatan
                ORDER BY c.bidang
            ');
            return $query->result_array();
        }
    }

    public function getSectors($user_id=null)
    {
        $query = $this->db->query('
            SELECT c.bidang
            FROM tbl_contributors c
            WHERE c.user_id = '.$user_id.'
            GROUP BY c.bidang
            ORDER BY c.bidang
        ');
        return $query->result_array();
    }
}