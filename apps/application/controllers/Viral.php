<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Viral extends CI_Controller {
    var $user = array();

    var $category;
    var $day_count;
    var $interval;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('auth_model');
        $this->load->model('user_model');
        $this->load->model('target_model');
        $this->load->model('dashboard_model');
        $this->load->model('viral_model');
        $this->load->helper('MY_user');
        $this->auth_model->cekLogin(true);

        $this->load->library('template');
        $this->user = $this->auth_model->getUser();

        $this->load->model('menu_model');
    }

	public function index()
	{
        $this->load->helper('MY_user');
        $user = $this->user_model->getUser();
        $data['user'] = $user;
		$this->load->view('dashboard/index', $data);
    }

    public function daily($category = null)
    {
		$data['interval'] = "daily";
		$data['category'] = urldecode($category);
        $this->serve($data);

        $this->menu_model->increaseClick('viral_d', $this->user['id_user']);
    }

    public function weekly($category = null)
    {
        $data['interval'] = "weekly";
		$data['category'] = urldecode($category);
        $this->serve($data);

        $this->menu_model->increaseClick('viral_w', $this->user['id_user']);
    }

    public function monthly($category = null)
    {
        $data['interval'] = "monthly";
		$data['category'] = urldecode($category);
        $this->serve($data);

        $this->menu_model->increaseClick('viral_m', $this->user['id_user']);
    }
	
	private function serve($data)
	{
		$categories = $this->target_model->getCategoriesByClient($this->user['id_user']);
        if ($data['category'] == null) redirect('viral/'.$data['interval'].'/'.$categories[0]['category'],'refresh');
		
        $data['categories'] = $categories;
        $data['isDataExist'] = $this->viral_model->isDataExist(time());
        $data['latestUpdate'] = $this->viral_model->getLatestUpdate($this->user['id_user']);
        $data['isDataExist'] = $data['latestUpdate'] == date("Y-m-d");
		
		$content = $this->load->view('client/viral', $data, true);
        $js = array('dist/js/viral.js');
        $this->template->show('template/client3', $content, 'Viral Analysis', $js);
	}
	
	// delete soon
    private function init_dashboard($range)
    {
        $categories = $this->target_model->getCategoriesByClient($this->user['id_user']);
        if ($this->category == null) redirect('viral/'.$range.'/'.$categories[0]['category'],'refresh');
        
        $data['categories'] = $categories;
        $data['activeCategory'] = $this->category;
        $data['interval'] = $this->interval;

        $content = $this->load->view('client/viral', $data, true);
        $js = array('dist/js/viral.js');
        $this->template->show('template/client3', $content, 'Viral Analysis', $js);
    }

    private function init_api($id_label)
    {
        $chartData = $this->dashboard_model->getDashboardA($this->user['id_user'], $this->category, $this->day_count, $id_label);
        
        header('Content-Type: application/json');
        echo json_encode($chartData);
    }

    public function api_get_sumber_keyword($keyword = null, $category, $interval)
    {
        if (!$keyword) return;
        $keyword = urldecode($keyword);
        $category = urldecode($category);
        $resp = $this->dashboard_model->getSumberKeyword($keyword, $this->user['id_user'], $category, $day_count);
        
        header('Content-Type: application/json');
        echo json_encode($resp);
    }

    public function api_get_keywords()
    {
		$id_user	= $this->user['id_user'];
		$category	= $this->input->get("category");
		$id_label   = $this->input->get("id_label");
        $interval   = $this->input->get("interval");
		$offset     = $this->input->get("offset");
		
		switch ($interval)
		{
			case "daily":
				$day_count = 1; break;
			case "weekly":
				$day_count = 7; break;
			default:
				$day_count = 30; break;
		}
        
        $resp = $this->viral_model->get_keywords($id_user, $category, $id_label, $day_count, $offset);
		header('Content-Type: application/json');
        echo json_encode($resp);
    }

    public function api_get_source()
    {
        $id_user    = $this->user['id_user'];
        $keyword    = $this->input->get("keyword", true);
        $category   = $this->input->get("category", true);
        $interval   = $this->input->get("interval");

        switch ($interval)
		{
			case "daily":
				$day_count = 1; break;
			case "weekly":
				$day_count = 7; break;
			default:
				$day_count = 30; break;
        }

        $resp = $this->viral_model->get_keyword_source($keyword, $id_user, $category, $day_count);
        header('Content-Type: application/json');
        echo json_encode($resp);
    }

    public function api_search() 
    {
        $id_user    = $this->user['id_user'];
        $keyword    = $this->input->get("keyword", true);
        $category   = $this->input->get("category", true);
        $interval   = $this->input->get("interval");

        switch ($interval)
		{
			case "daily":
				$day_count = 1; break;
			case "weekly":
				$day_count = 7; break;
			default:
				$day_count = 30; break;
        }

        $resp = $this->viral_model->search_keyword($keyword, $id_user, $category, $day_count);
        header('Content-Type: application/json');
        echo json_encode($resp);
    }

    // public function daily($category = null, $day_offset = 30, $id_label = null)
    public function a($category = null)
    {
        // $this->load->helper('form');

        // if ($id_label != null) {
        //     $this->api_dashboard_a($category, $day_offset, $id_label);
        //     return;
        // }

        // $day_offset = ($range == 'monthly') ? 30 : (($range == 'weekly') ? 7 : 1 );

        $categories = $this->target_model->getCategoriesByClient($this->user['id_user']);
        if (!$category) redirect('viral/daily/'.$categories[0]['category'],'refresh');
        
        // $dateStart = date('Y-m-d H:i:s', mktime(23, 59, 59, date('m'), date('d') - $day_offset));
        // $chartData = $this->dashboard_model->getDashboardA($this->user['id_user'], urldecode($category), $dateStart);
        // $data['chart_publik'] = array_filter($chartData, function($v) {
        //     return $v['label_name'] == 'Publik';
        // });
        // $data['day_offset'] = $day_offset;
        $data['categories'] = $categories;
        $data['activeCategory'] = $category;
        $data['options_day_count'] = array(
            '1' => 'Daily',
            '7' => 'Weekly',
            '100' => 'Monthly'
        );
        $content = $this->load->view('client/viral', $data, true);

        $js = array('dist/js/dashboard_a.js');
        $this->template->show('template/client2', $content, 'Viral Analysis', $js);
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