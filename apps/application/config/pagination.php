<?php
defined('BASEPATH') OR exit('No direct script access allowed');

$config = array();

$config['page_query_string'] = TRUE;

$config['full_tag_open'] = '<ul class="pagination pagination-sm inline">';
$config['full_tag_close'] = '</ul>';

$config['cur_tag_open'] = '<li class="active"><a>';
$config['cur_tag_close'] = '</a></li>';

$config['num_tag_open'] = $config['first_tag_open'] = $config['last_tag_open'] = $config['next_tag_open'] = $config['prev_tag_open'] = '<li>';
$config['num_tag_close'] = $config['first_tag_close'] = $config['last_tag_close'] = $config['next_tag_close'] = $config['prev_tag_close'] = '</li>';