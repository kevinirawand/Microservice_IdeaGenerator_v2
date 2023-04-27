<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Dashboard extends CI_Controller {
    var $user = array();

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('user_model');
        $this->load->model('target_model');
        $this->load->model('dashboard_model');
        $this->load->helper('MY_user');
        $this->auth_model->cekLogin(true);

        $this->load->library('template');
        $this->user = $this->auth_model->getUser();
    }

	public function index()
	{
        $this->load->helper('MY_user');
        $user = $this->user_model->getUser();
        $data['user'] = $user;
		$this->load->view('dashboard/index', $data);
    }

    public function a($category = null, $day_offset = 30, $id_label = null)
    {
        $this->load->helper('form');

        if ($id_label != null) {
            $this->api_dashboard_a($category, $day_offset, $id_label);
            return;
        }

        $categories = $this->target_model->getCategoriesByClient($this->user['id_user']);
        if (!$category) redirect('dashboard/a/'.$categories[0]['category'].'/'.$day_offset,'refresh');
        
        // $dateStart = date('Y-m-d H:i:s', mktime(23, 59, 59, date('m'), date('d') - $day_offset));
        // $chartData = $this->dashboard_model->getDashboardA($this->user['id_user'], urldecode($category), $dateStart);
        // $data['chart_publik'] = array_filter($chartData, function($v) {
        //     return $v['label_name'] == 'Publik';
        // });
        $data['day_offset'] = $day_offset;
        $data['categories'] = $categories;
        $data['activeCategory'] = $category;
        $data['options_day_count'] = array(
            '1' => 'Daily',
            '7' => 'Weekly',
            '100' => 'Monthly'
        );
        $content = $this->load->view('dashboard/dashboard_a', $data, true);

        $js = array('dist/js/dashboard_a.js');
        $this->template->show('template/client2', $content, 'Dashboard', $js);
    }

    public function b($api = null)
    {
        if ($api != null) {
            $this->api_dashboard_b();
            return;
        }

        $content = $this->load->view('dashboard/dashboard_b', null, true);

        $js = array('dist/js/dashboard_b.js');
        $this->template->show('template/client', $content, 'Dashboard', $js);
    }
    
    public function api_dashboard_a($category = null, $day_offset = 30, $id_label = null)
    {
        // $dateStart = date('Y-m-d H:i:s', mktime(23, 59, 59, date('m'), date('d') - $day_offset));
        $chartData = $this->dashboard_model->getDashboardA($this->user['id_user'], urldecode($category), $day_offset, $id_label);

        header('Content-Type: application/json');
        echo json_encode($chartData);
    }

    public function api_dashboard_b()
    {
        $chartData = $this->dashboard_model->getDashboardB($this->user['id_user']);

        header('Content-Type: application/json');
        echo json_encode($chartData);
    }

    public function init_dashboard_a($id_user)
    {
        $postData = array(
            id_user => $this->user['id_user'],
            day_count => '',
            category => '',
            normal_text => '',
            modus => '',
            total_px => '',
            p_value => ''
        );
    }
}

/* QUERY GET DASHBOARD v1
SELECT 
	tbl_users_targets.id_user, tbl_users_targets.id_target, tbl_users_targets.category,
    tbl_targets.ig_username,
    tbl_crawling.id_crawling, tbl_crawling.url, tbl_crawling.taken_at,
    tbl_normalizations.normal_text,
    tbl_labels.label_name
FROM 
	tbl_users_targets
INNER JOIN
	tbl_targets ON tbl_targets.id_target = tbl_users_targets.id_target
RIGHT JOIN
	tbl_crawling ON tbl_crawling.ig_username = tbl_targets.ig_username
RIGHT JOIN
	tbl_normalizations ON tbl_normalizations.id_crawling = tbl_crawling.id_crawling
INNER JOIN
	tbl_classifications ON tbl_classifications.id_normalization = tbl_normalizations.id_normalization
INNER JOIN
	tbl_labels ON tbl_labels.id_label = tbl_classifications.id_label
WHERE
	tbl_users_targets.id_user = 4 AND
    tbl_users_targets.category = "PUBLIC FIGURE" AND
    DATE(tbl_crawling.taken_at) = '2019-11-21'
 */