<?php
class Competitor_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    function get_top_rangking($id_user, $interval, $year, $month)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n'); # Numeric representation of a month, without leading zeros .. 1 through 12

		if ($interval == "daily")
		{   
            $query = $this->db->query('
                SELECT A.id_user, B.ig_username, B.id_scrap_target as id_target, C.total_score, C.updated
                FROM tbl_users_scrap_targets AS A
                
                JOIN tbl_scrap_targets AS B
                USING (id_scrap_target)
                
                LEFT JOIN tbl_scraping_result AS C
                ON B.id_scrap_target = C.id_target
                AND A.id_user = C.id_user
                AND DATE(C.updated) = (
                    SELECT DATE(MAX(updated))
                    FROM tbl_scraping_result
                    WHERE id_user = "'.$id_user.'"
                    AND DATE(updated) <= "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
                )
                
                WHERE A.id_user = "'.$id_user.'"
                ORDER BY C.total_score DESC
            ');
		}
		else
		{
            $day = date( "d" );

            $queryCurrent = '
                SELECT id_target, SUM(total_score)/'.($day-1).' AS total_score
                FROM tbl_scraping_result
                WHERE DATE(updated) >= "'.date( "Y-m-02" ).'"
                AND id_user = "'.$id_user.'"
                GROUP BY id_target
                ';

            $queryHistory = '
                SELECT id_target, SUM(total_score)/31 AS total_score
                FROM tbl_scraping_result
                WHERE DATE(updated) BETWEEN "'.$year.'-12-02" AND "'.($year+1).'-01-01"
                AND id_user = "'.$id_user.'"
                GROUP BY id_target
                ';

            $query = $this->db->query('
                SELECT A.id_user, B.ig_username, B.id_scrap_target as id_target, C.total_score
                FROM tbl_users_scrap_targets AS A
                
                JOIN tbl_scrap_targets AS B
                USING (id_scrap_target)
                
                LEFT JOIN ('.
                    (date('Y') == $year ? $queryCurrent : $queryHistory)
                .') AS C
                ON B.id_scrap_target = C.id_target
                
                WHERE A.id_user = "'.$id_user.'"
                ORDER BY C.total_score DESC
            ');
		}
        return $query->result_array();
    }

    function get_history_target($id_user, $id_target, $interval, $year = null, $month = null)
    {	
        /**
         * Untuk mendapatkan jumlah hari pada bulan & tahun tertentu :
         * a. $num_of_days = date("t", $timestamp);
         * b. $num_of_days = cal_days_in_month(CAL_GREGORIAN, $month, $year);
         */

        if (empty($year)) $year = date('Y');

        $history = [];

        if ($interval == "daily")
        {
            if (empty($month)) $month = date('n');

            $date_from = ($year)."-".($month)."-".("02");
            if($month == 12) {
                $date_until = ($year+1)."-".("01")."-".("01");
            }
            else {
                $date_until = ($year)."-".($month + 1)."-".("01");
            }
            $num_of_days = date("t", strtotime($date_from));
            
            $query = $this->db->query('
                SELECT id_target, ig_username, EXTRACT(DAY FROM updated) as day, total_score 
                FROM tbl_scraping_result
                WHERE id_target = '.$id_target.'
                AND id_user = '.$id_user.'
                AND DATE(updated) BETWEEN "'.$date_from.'" AND "'.$date_until.'"
                ORDER BY updated
            ');

            $result = $query->result_array();
            
            for ($i = 0; $i < $num_of_days; $i++) 
            {
                $history[$i] = null;
            }
            foreach ($result as $row)
            {
                $day = $row["day"] == 1 ? $num_of_days : $row["day"] - 1; // -1 karena hari ini menghitung untuk tanggal kemarin
                $history[$day - 1] = round($row["total_score"], 2); // -1 karena index dimulai dr angka 0
            }
        }
        else
        {
            $query = $this->db->query('
                SELECT id_target, ig_username, MONTH(DATE_SUB(updated, INTERVAL 1 DAY)) AS month, SUM(total_score) as total_score
                FROM tbl_scraping_result
                WHERE id_target = "'.$id_target.'"
                AND id_user = "'.$id_user.'"
                AND DATE(updated) BETWEEN "'.($year).'-01-02" AND "'.($year + 1).'-01-01"
                GROUP BY month, ig_username
                ORDER BY month
            ');
            $result = $query->result_array();

            for ($i = 0; $i < 12; $i++) 
            {
                $history[$i] = null;
            }
            foreach ($result as $row) 
            {
                $month = $row["month"];
                if ($month == date( "n" ) && $year == date( "Y" )) {
                    $days = date( "j" ) - 1;
                } else {
                    $days = cal_days_in_month(CAL_GREGORIAN, $month, $year);
                }
                $history[$month - 1] = round($row["total_score"] / $days, 2);
            }
        }
		return $history;
    }

    function get_top_follower($id_user, $interval, $year, $month)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n'); # Numeric representation of a month, without leading zeros .. 1 through 12

        if ($interval == "daily")
        {
            $query = $this->db->query('
                SELECT B.id_scrap_target AS id_target, B.ig_username, C.total_follower
                FROM tbl_users_scrap_targets AS A
                
                JOIN tbl_scrap_targets AS B
                USING (id_scrap_target)
                
                LEFT JOIN tbl_scraping_result AS C
                ON B.id_scrap_target = C.id_target
                AND A.id_user = C.id_user
                AND DATE(C.updated) = (
                    SELECT DATE(MAX(updated))
                    FROM tbl_scraping_result
                    WHERE id_user = "'.$id_user.'"
                    AND DATE(updated) <= "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
                )
                
                WHERE A.id_user = "'.$id_user.'"
                ORDER BY total_follower DESC
            ');
        }
        else
        {
            if ($year < date('Y')) $month = 12;

            $query = $this->db->query('
                SELECT B.id_scrap_target AS id_target, B.ig_username, C.updated, D.total_follower
                FROM tbl_users_scrap_targets AS A
                
                JOIN tbl_scrap_targets AS B
                USING (id_scrap_target)
                
                LEFT JOIN (
                    SELECT MAX(updated) AS updated, id_target
                    FROM tbl_scraping_result
                    WHERE id_user = "'.$id_user.'"
                    AND DATE(updated) <= "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
                    GROUP BY id_target
                ) AS C
                ON B.id_scrap_target = C.id_target
                
                LEFT JOIN tbl_scraping_result AS D
                ON C.updated = D.updated
                AND A.id_user = D.id_user
                
                WHERE A.id_user = "'.$id_user.'"
                ORDER BY total_follower DESC
            ');
        }
        return $query->result_array();
    }
	
	function get_top_activity($id_user, $interval, $year, $month)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n'); # Numeric representation of a month, without leading zeros .. 1 through 12

        if ($interval == "daily")
        {
            $query = $this->db->query('
                SELECT B.id_scrap_target AS id_target, B.ig_username, C.total_content
                FROM tbl_users_scrap_targets AS A
                
                JOIN tbl_scrap_targets AS B
                USING (id_scrap_target)
                
                LEFT JOIN tbl_scraping_result AS C
                ON B.id_scrap_target = C.id_target
                AND A.id_user = C.id_user
                AND DATE(C.updated) = (
                    SELECT DATE(MAX(updated))
                    FROM tbl_scraping_result
                    WHERE id_user = "'.$id_user.'"
                    AND DATE(updated) <= "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
                )
                
                WHERE A.id_user = "'.$id_user.'"
                ORDER BY total_content DESC
            ');
        }
        else
        {
            $days = $year == date('Y') ? date('j') - 1 : 31;
            $month = $year == date('Y') ? date('n') : 12;

            $query = $this->db->query('
                SELECT B.id_scrap_target AS id_target, B.ig_username, SUM(C.total_content)/'.($days).' AS total_content
                FROM tbl_users_scrap_targets AS A
                
                JOIN tbl_scrap_targets AS B
                USING (id_scrap_target)
                
                LEFT JOIN tbl_scraping_result AS C
                ON B.id_scrap_target = C.id_target
                AND A.id_user = C.id_user
                AND DATE(C.updated) BETWEEN "'.$year.'-'.$month.'-02" AND "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
                
                WHERE A.id_user = "'.$id_user.'"
                GROUP BY id_scrap_target
                ORDER BY total_content DESC
            ');
        }
        return $query->result_array();
    }
	
	function get_top_interaction($id_user, $interval, $year, $month)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n'); # Numeric representation of a month, without leading zeros .. 1 through 12

        if ($interval == "daily")
        {
            $query = $this->db->query('
                SELECT B.id_scrap_target AS id_target,  B.ig_username, (C.total_engagement / C.total_content) AS interaction
                FROM tbl_users_scrap_targets AS A
                
                JOIN tbl_scrap_targets AS B
                USING (id_scrap_target)
                
                LEFT JOIN tbl_scraping_result AS C
                ON B.id_scrap_target = C.id_target
                AND A.id_user = C.id_user
                AND DATE(C.updated) = (
                    SELECT DATE(MAX(updated))
                    FROM tbl_scraping_result
                    WHERE id_user = "'.$id_user.'"
                    AND DATE(updated) <= "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
                )
                
                WHERE A.id_user = "'.$id_user.'"
                ORDER BY interaction DESC
            ');
        }
        else
        {
            if ($year < date('Y')) $month = 12;

            $query = $this->db->query('
                SELECT B.id_scrap_target AS id_target,  B.ig_username, AVG(C.total_engagement / C.total_content) AS interaction
                FROM tbl_users_scrap_targets AS A
                
                JOIN tbl_scrap_targets AS B
                USING (id_scrap_target)
                
                LEFT JOIN tbl_scraping_result AS C
                ON B.id_scrap_target = C.id_target
                AND A.id_user = C.id_user
                AND DATE(C.updated) BETWEEN "'.$year.'-'.$month.'-02" AND "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
                
                WHERE A.id_user = "'.$id_user.'"
                GROUP BY B.id_scrap_target
                ORDER BY interaction DESC
            ');
        }
        return $query->result_array();
    }
	
	function get_top_responsiveness($id_user, $interval, $year, $month)
    {
        if (!isset($year)) $year = date('Y');
        if (!isset($month)) $month = date('n'); # Numeric representation of a month, without leading zeros .. 1 through 12

        if ($interval == "daily")
        {
            $query = $this->db->query('
                SELECT B.id_scrap_target AS id_target,  B.ig_username, (C.total_response * 100 / C.total_comment) AS responsiveness
                FROM tbl_users_scrap_targets AS A
                
                JOIN tbl_scrap_targets AS B
                USING (id_scrap_target)
                
                LEFT JOIN tbl_scraping_result AS C
                ON B.id_scrap_target = C.id_target
                AND A.id_user = C.id_user
                AND DATE(C.updated) = (
                    SELECT DATE(MAX(updated))
                    FROM tbl_scraping_result
                    WHERE id_user = "'.$id_user.'"
                    AND DATE(updated) <= "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
                )
                
                WHERE A.id_user = "'.$id_user.'"
                ORDER BY responsiveness DESC
            ');
        }
        else
        {
            if ($year < date('Y')) $month = 12;

            $query = $this->db->query('
                SELECT B.id_scrap_target AS id_target,  B.ig_username, AVG(C.total_response * 100 / C.total_comment) AS responsiveness
                FROM tbl_users_scrap_targets AS A
                
                JOIN tbl_scrap_targets AS B
                USING (id_scrap_target)
                
                LEFT JOIN tbl_scraping_result AS C
                ON B.id_scrap_target = C.id_target
                AND A.id_user = C.id_user
                AND DATE(C.updated) BETWEEN "'.$year.'-'.$month.'-02" AND "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
                
                WHERE A.id_user = "'.$id_user.'"
                GROUP BY B.id_scrap_target
                ORDER BY responsiveness DESC
            ');
        }
        return $query->result_array();
    }

    function get_report_follower($id_user, $year, $month) 
    {
        $query = $query = $this->db->query('
            SELECT B.id_scrap_target AS id_target, B.ig_username, D.total_follower
            FROM tbl_users_scrap_targets AS A
            
            JOIN tbl_scrap_targets AS B
            USING (id_scrap_target)
            
            LEFT JOIN (
                SELECT MAX(updated) AS updated, id_target
                FROM tbl_scraping_result
                WHERE id_user = "'.$id_user.'"
                AND DATE(updated) <= "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
                GROUP BY id_target
            ) AS C
            ON B.id_scrap_target = C.id_target
            
            LEFT JOIN tbl_scraping_result AS D
            ON C.updated = D.updated
            AND A.id_user = D.id_user
            
            WHERE A.id_user = "'.$id_user.'"
            ORDER BY total_follower DESC
        ');
        return $query->result_array();
    }

    function get_report_activity($id_user, $year, $month) 
    {
        $days = ($year == date('Y') && $month == date('n')) ? (date('j') - 1) : (cal_days_in_month(CAL_GREGORIAN, $month, $year));

        $query = $this->db->query('
            SELECT B.id_scrap_target AS id_target, B.ig_username, FORMAT(SUM(C.total_content)/'.($days).',2) AS total_content
            FROM tbl_users_scrap_targets AS A
            
            JOIN tbl_scrap_targets AS B
            USING (id_scrap_target)
            
            LEFT JOIN tbl_scraping_result AS C
            ON B.id_scrap_target = C.id_target
            AND A.id_user = C.id_user
            AND DATE(C.updated) BETWEEN "'.$year.'-'.$month.'-02" AND "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
            
            WHERE A.id_user = "'.$id_user.'"
            GROUP BY id_scrap_target
            ORDER BY total_content DESC
        ');

        return $query->result_array();
    }

    function get_report_interaction($id_user, $year, $month) 
    {
        $query = $this->db->query('
            SELECT B.id_scrap_target AS id_target,  B.ig_username, FORMAT(AVG(C.total_engagement / C.total_content),2) AS interaction
            FROM tbl_users_scrap_targets AS A
            
            JOIN tbl_scrap_targets AS B
            USING (id_scrap_target)
            
            LEFT JOIN tbl_scraping_result AS C
            ON B.id_scrap_target = C.id_target
            AND A.id_user = C.id_user
            AND DATE(C.updated) BETWEEN "'.$year.'-'.$month.'-02" AND "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
            
            WHERE A.id_user = "'.$id_user.'"
            GROUP BY B.id_scrap_target
            ORDER BY interaction DESC
        ');

        return $query->result_array();
    }

    function get_report_responsiveness($id_user, $year, $month) 
    {
        $query = $this->db->query('
            SELECT B.id_scrap_target AS id_target,  B.ig_username, FORMAT(AVG(C.total_response * 100 / C.total_comment),2) AS responsiveness
            FROM tbl_users_scrap_targets AS A
            
            JOIN tbl_scrap_targets AS B
            USING (id_scrap_target)
            
            LEFT JOIN tbl_scraping_result AS C
            ON B.id_scrap_target = C.id_target
            AND A.id_user = C.id_user
            AND DATE(C.updated) BETWEEN "'.$year.'-'.$month.'-02" AND "'.$year.'-'.$month.'-01" + INTERVAL 1 MONTH
            
            WHERE A.id_user = "'.$id_user.'"
            GROUP BY B.id_scrap_target
            ORDER BY responsiveness DESC
        ');

        return $query->result_array();
    }
}