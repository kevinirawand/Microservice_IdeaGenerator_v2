<?php
class Target_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getTargetByUser($id_user)
    {
        $this->db->where('id_user', $id_user);
        $this->db->join('tbl_targets', 'tbl_users_targets.id_target = tbl_targets.id_target');
        $this->db->select('tbl_users_targets.*, tbl_targets.ig_username');
        $query = $this->db->get('tbl_users_targets');
        return $query->result_array();
    }

    public function insertUsersTargets($data, $id_user)
    {
        $this->db->set('id_target', $data['id_target']);
        $this->db->set('category', strtoupper($data['category']));
        $this->db->set('id_user', $id_user);
        $this->db->insert('tbl_users_targets');
        return $this->db->affected_rows();
    }

    public function getTargetAll()
    {
        $this->db->order_by('ig_username', 'ASC');
        $query = $this->db->get('tbl_targets');
        return $query->result_array();
    }

    public function getTable($limit = 10, $offset = 0, $q = null)
    {
        $this->db->order_by('id_target', 'DESC');
        $this->db->join('tbl_users', 'tbl_users.id_user = tbl_targets.id_admin');
        $this->db->join('tbl_engines', 'tbl_engines.id_engine = tbl_targets.id_engine');
        $this->db->select('tbl_targets.*, tbl_users.name, tbl_engines.ig_username as engine');
        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_targets.ig_username', $q);
            $this->db->or_like('tbl_users.name', $q);
            $this->db->or_like('tbl_engines.ig_username', $q);
            $this->db->group_end();
        }
        $query = $this->db->get('tbl_targets', $limit, $offset);
        return $query->result_array();
    }

    public function getTableTotalRows($q = null)
    {   
        $this->db->join('tbl_users', 'tbl_users.id_user = tbl_targets.id_admin');
        $this->db->join('tbl_engines', 'tbl_engines.id_engine = tbl_targets.id_engine');
        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_targets.ig_username', $q);
            $this->db->or_like('tbl_users.name', $q);
            $this->db->or_like('tbl_engines.ig_username', $q);
            $this->db->group_end();
        }
        return $this->db->count_all_results('tbl_targets');
    }

    public function insert($data)
    {
        $this->db->set('ig_username', $data['ig_username']);
        $this->db->set('id_admin', $data['id_admin']);
        $this->db->set('id_engine', $data['id_engine']);
        $this->db->insert('tbl_targets');
        return $this->db->affected_rows();
    }

    public function update($data)
    {
        $this->db->set('ig_username', $data['ig_username']);
        $this->db->set('id_admin', $data['id_admin']);
        $this->db->set('id_engine', $data['id_engine']);
        $this->db->where('id_target', $data['id_target']);
        $this->db->update('tbl_targets');
        return $this->db->affected_rows();
    }

    public function getCategoriesByClient($id_user)
    {
        $this->db->select('category');
        $this->db->distinct();
        $this->db->where('id_user', $id_user);
        $query = $this->db->get('tbl_users_targets');
        return $query->result_array();
    }

    public function getById($id_target){
        return $this->db->get_where('tbl_targets', array('id_target' => $id_target))->row();
    }

    public function delete($id_target){
        $this->db->where('id_target', $id_target);
        $this->db->delete('tbl_targets');
    }

    public function delete_user_target($id_user, $id_target){
        $this->db->where('id_user', $id_user);
        $this->db->where('id_target', $id_target);
        $this->db->delete('tbl_users_targets');
    }
}