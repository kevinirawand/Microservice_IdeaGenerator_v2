<?php
class Performance_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }


   //  GET TARGETS BY ID
    public function get_targets_by_id($id_user) {
      $query = $this->db->query('
      SELECT ig_username FROM tbl_users_scrap_targets JOIN tbl_scrap_targets ON tbl_scrap_targets.id_scrap_target = tbl_users_scrap_targets.id_scrap_target WHERE tbl_users_scrap_targets.id_user='.$id_user);

      return $query->result_array();
    }

    public function get_history_follower_interaction($id_user, $ig_username, $interval, $year = null, $month = null)
    {
        if (empty($year)) $year = date('Y');
        if (empty($month)) $month = date('n'); # Numeric representation of a month, without leading zeros .. 1 through 12

        if ($interval == 'daily') 
        {
            // FROM table tbl_scraping_result
            // $query = $this->db->query('
            //     SELECT EXTRACT(DAY FROM updated) as day, total_follower, total_engagement 
            //     FROM tbl_scraping_result
            //     WHERE ig_username = "'.$ig_username.'"
            //     AND id_user = '.$id_user.'
            //     AND DATE(updated) BETWEEN "'.date("Y-m-02").'" AND CURDATE()
            //     ORDER BY updated
            // ');
            
            // FROM table tbl_scraping
            $query = $this->db->query('
                SELECT a.day, a.total_engagement, b.follower_count AS total_follower
                FROM tbl_scraping AS b
                JOIN (
                    SELECT EXTRACT(DAY FROM taken_at) as day, SUM(like_count) as total_engagement, MAX(taken_at) as taken_at
                    FROM tbl_scraping
                    WHERE ig_username = "'.$ig_username.'"
                    AND YEAR(taken_at) = "'.$year.'"
                    AND MONTH(taken_at) = "'.$month.'"
                    GROUP BY day
                ) AS a USING(taken_at)
                WHERE ig_username = "'.$ig_username.'"
                ORDER BY a.day
            ');
        }
        else
        {
            // FROM table tbl_scraping_result
            // $query = $this->db->query('
            //     SELECT a.month, a.total_engagement, b.total_follower
            //     FROM tbl_scraping_result as b
            //     JOIN (
            //         SELECT EXTRACT(MONTH FROM updated) as month, SUM(total_engagement) as total_engagement, MAX(id) as id
            //         FROM tbl_scraping_result
            //         WHERE ig_username = "'.$ig_username.'"
            //         AND id_user = '.$id_user.'
            //         AND YEAR(updated) = YEAR(CURDATE())
            //         GROUP BY month
            //     ) as a USING(id)
            //     ORDER BY a.month
            // ');

            // FROM table tbl_scraping
            $query = $this->db->query('
                SELECT a.month, a.total_engagement, b.follower_count as total_follower
                FROM tbl_scraping as b
                JOIN (
                    SELECT MONTH(taken_at) as month, SUM(like_count) as total_engagement, MAX(taken_at) as taken_at
                    FROM tbl_scraping
                    WHERE ig_username = "'.$ig_username.'"
                    AND YEAR(taken_at) = "'.$year.'"
                    GROUP BY month
                ) as a USING(taken_at)
                WHERE ig_username = "'.$ig_username.'"
                ORDER BY a.month
            ');
        }
      //   var_dump($query->result_array());
         // echo $query->result_array();
        return $query->result_array();
    }

    public function get_source_daily($ig_username, $day, $month, $year) {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n'); # Numeric representation of a month, without leading zeros .. 1 through 12
        
        $query = $this->db->query('
            SELECT taken_at, url, like_count, (response_count / comment_count) * 100 as responsiveness, category
            FROM tbl_scraping
            WHERE ig_username = "'.$ig_username.'"
            AND DATE(taken_at) = "'.$year.'-'.$month.'-'.$day.'"
            ORDER BY category DESC
        ');
        return $query->result_array();
    }

    public function get_source_monthly($ig_username, $month, $year) {
        if (!isset($year)) $year = date('Y');

        $query = $this->db->query('
            SELECT taken_at, url, like_count, (response_count / comment_count) * 100 as responsiveness, category
            FROM tbl_scraping
            WHERE ig_username = "'.$ig_username.'"
            AND MONTH(taken_at) = "'.$month.'"
            AND YEAR(taken_at) = "'.$year.'"
            ORDER BY category DESC
        ');
        return $query->result_array();
    }

    public function get_gauge_daily($ig_username, $date) {
        $query = $this->db->query('
            SELECT COUNT(*) as activity, coalesce((SUM(response_count) / SUM(comment_count) * 100)) as responsiveness
            FROM tbl_scraping
            WHERE ig_username = "'.$ig_username.'"
            AND DATE(taken_at) = "'.date("Y-m-d", $date).'"
        ');
        return $query->row_array();
    }

    public function get_gauge_monthly($ig_username, $month, $year) {
        if (!isset($year)) $year = date('Y');
        
        $query = $this->db->query('
            SELECT AVG(activity) as activity, AVG(responsiveness) as responsiveness
            FROM (
                SELECT COUNT(*) as activity, coalesce((SUM(response_count) / SUM(comment_count) * 100)) as responsiveness, DATE(taken_at) as date
                FROM tbl_scraping
                WHERE ig_username = "'.$ig_username.'"
                AND MONTH(taken_at) = "'.$month.'"
                AND YEAR(taken_at) = "'.$year.'"
                GROUP BY date
            ) tbl
        ');
        return $query->row_array();
    }
}