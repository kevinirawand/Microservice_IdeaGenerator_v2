<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Template {
    protected $CI;

    private $user;
    private $menu;

    public function __construct()
    {
        $this->CI =& get_instance();
        $this->CI->load->helper('MY_user');

        $this->initUser();
        $this->initMenu();
    }

    public function show($template, $content, $title, $scripts = array())
    {
        $data['user']       = $this->user;
        $data['menu']       = $this->menu;
        $data['content']    = $content;
        $data['title']      = $title;
        $data['activeMenu'] = $this->CI->uri->segment(1, '');
        $data['scripts']    = $scripts;
        $this->CI->load->view($template, $data);
    }

    private function initUser()
    {
        $this->user = $this->CI->auth_model->getUser();
        $this->user['has_contributor'] = $this->CI->auth_model->hasContributor($this->user);
    }

    private function initMenu()
    {
        $user = $this->user;
        $menu = array();
        switch ($user['user_type']) 
        {
            case '1':
                $menu[] = array('caption' => 'Tracking Menu',       'icon' => 'fa-chart-bar',           'uri' => 'menu/tracking');
                $menu[] = array('caption' => 'Crawler Engine',      'icon' => 'fa-microchip',           'uri' => 'engine');
            case '2':
                $menu[] = array('caption' => 'Crawling Targets',    'icon' => 'fa-search-plus',         'uri' => 'target');
                $menu[] = array('caption' => 'Crawling',            'icon' => 'fa-cloud-download-alt',  'uri' => 'crawling');
                $menu[] = array('caption' => 'Extraction',          'icon' => 'fa-share-square',        'uri' => 'extraction');
                $menu[] = array('caption' => 'Normalization',       'icon' => 'fa-font',                'uri' => 'normalization');
                $menu[] = array('caption' => 'Classification',      'icon' => 'fa-tags',                'uri' => 'classification');
                $menu[] = array('caption' => 'Scraping Targets',    'icon' => 'fa-search-plus',         'uri' => 'scrap_target');
                $menu[] = array('caption' => 'Users',               'icon' => 'fa-users',               'uri' => 'user');
                $menu[] = array('caption' => 'Report',              'icon' => 'fa-file-excel',          'uri' => 'report');
                $menu[] = array('caption' => 'Pop Up',              'icon' => 'fa-comment-alt',         'uri' => 'popup');
                $menu[] = array('caption' => 'Contributors',              'icon' => 'fa-users',         'uri' => 'contributor');
                break;
            case '3':
                $menu[] = array('caption' => 'Home',                'icon' => 'dist/image/02-Home/icon_home.svg',       'uri' => 'home');
                $menu[] = array('caption' => 'Viral Analysis',      'icon' => 'dist/image/02-Home/icon_viral.svg',      'uri' => 'viral', 'submenu' => [
                    array('caption' => 'Daily',  	'icon' => 'fa-circle', 'uri' => 'daily'),
                    array('caption' => 'Weekly', 	'icon' => 'fa-circle', 'uri' => 'weekly'),
                    array('caption' => 'Monthly', 	'icon' => 'fa-circle', 'uri' => 'monthly')
                ]);
                // $menu[] = array('caption' => 'Pattern',             'icon' => 'dist/image/02-Home/icon_keyword.svg',    'uri' => 'pattern');
                $menu[] = array('caption' => 'Competitor',          'icon' => 'dist/image/02-Home/icon_competitor.svg', 'uri' => 'competitor', 'submenu' => [
                    array('caption' => 'Daily',		'icon' => 'fa-circle', 'uri' => 'daily'),
                    array('caption' => 'Monthly',	'icon' => 'fa-circle', 'uri' => 'monthly')
                ]);
                $menu[] = array('caption' => 'Self Performance',    'icon' => 'dist/image/02-Home/icon_performance.svg','uri' => 'performance', 'submenu' => [
                    array('caption' => 'Daily',		'icon' => 'fa-circle', 'uri' => 'daily'),
                    array('caption' => 'Monthly',	'icon' => 'fa-circle', 'uri' => 'monthly')
                ]);
                if($user['has_contributor']) {
                    $menu[] = array('caption' => 'Contributor',             'icon' => 'dist/image/02-Home/icon_keyword.svg',    'uri' => 'contributors', 'submenu' => [
                        array('caption' => 'Daily',		'icon' => 'fa-circle', 'uri' => 'daily'),
                        array('caption' => 'Weekly',	'icon' => 'fa-circle', 'uri' => 'weekly'),
                        array('caption' => 'Monthly', 	'icon' => 'fa-circle', 'uri' => 'monthly'),
                        array('caption' => 'Config',	'icon' => 'fa-circle', 'uri' => 'config')
                    ]);
                }
                break;
            default:
                break;
        }
        $this->menu = $menu;
    }
}
