<?php
class Scrap_target_model extends CI_Model
{
    public function __construct()
    {
        $this->load->database();
    }

    public function getScrap_targetByUser($id_user)
    {
        $this->db->where('id_user', $id_user);
        $this->db->join('tbl_scrap_targets', 'tbl_users_scrap_targets.id_scrap_target = tbl_scrap_targets.id_scrap_target');
        $this->db->select('tbl_users_scrap_targets.*, tbl_scrap_targets.ig_username');
        $query = $this->db->get('tbl_users_scrap_targets');
        return $query->result_array();
    }

    public function insertUsersScrap_targets($data, $id_user)
    {
        $this->db->set('id_scrap_target', $data['id_scrap_target']);
        $this->db->set('id_user', $id_user);
        $this->db->insert('tbl_users_scrap_targets');
        return $this->db->affected_rows();
    }

    public function getScrap_targetAll()
    {
        $this->db->order_by('ig_username', 'ASC');
        $query = $this->db->get('tbl_scrap_targets');
        return $query->result_array();
    }

    public function getTable($limit = 10, $offset = 0, $q = null)
    {
        $this->db->order_by('id_scrap_target', 'DESC');
        $this->db->join('tbl_users', 'tbl_users.id_user = tbl_scrap_targets.id_admin');
        $this->db->join('tbl_engines', 'tbl_engines.id_engine = tbl_scrap_targets.id_engine');
        $this->db->select('tbl_scrap_targets.*, tbl_users.name, tbl_engines.ig_username as engine');
        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_users.name', $q);
            $this->db->or_like('tbl_scrap_targets.ig_username', $q);
            $this->db->or_like('tbl_engines.ig_username', $q);
            $this->db->group_end();
        }
        $query = $this->db->get('tbl_scrap_targets', $limit, $offset);
        return $query->result_array();
    }

    public function getTableTotalRows($q = null)
    {
        $this->db->join('tbl_users', 'tbl_users.id_user = tbl_scrap_targets.id_admin');
        $this->db->join('tbl_engines', 'tbl_engines.id_engine = tbl_scrap_targets.id_engine');
        if ($q) {
            $this->db->group_start();
            $this->db->like('tbl_users.name', $q);
            $this->db->or_like('tbl_scrap_targets.ig_username', $q);
            $this->db->or_like('tbl_engines.ig_username', $q);
            $this->db->group_end();
        }
        return $this->db->count_all_results('tbl_scrap_targets');
    }

    public function insert($data)
    {
        $this->db->set('ig_username', $data['ig_username']);
        $this->db->set('id_admin', $data['id_admin']);
        $this->db->set('id_engine', $data['id_engine']);
        $this->db->insert('tbl_scrap_targets');
        return $this->db->affected_rows();
    }

    public function update($data)
    {
        $this->db->set('ig_username', $data['ig_username']);
        $this->db->set('id_admin', $data['id_admin']);
        $this->db->set('id_engine', $data['id_engine']);
        $this->db->where('id_scrap_target', $data['id_scrap_target']);
        $this->db->update('tbl_scrap_targets');
        return $this->db->affected_rows();
    }

    public function getCategoriesByClient($id_user)
    {
        $this->db->select('category');
        $this->db->distinct();
        $this->db->where('id_user', $id_user);
        $query = $this->db->get('tbl_users_scrap_targets');
        return $query->result_array();
    }

    public function getById($id_scrap_target){
        return $this->db->get_where('tbl_scrap_targets', array('id_scrap_target' => $id_scrap_target))->row();
    }

    public function delete($id_scrap_target){
        $this->db->where('id_scrap_target', $id_scrap_target);
        $this->db->delete('tbl_scrap_targets');
    }

    // delete user scrap target by user id and scrap target id
    public function delete_user_scrap_target($id_user, $id_scrap_target){
        $this->db->where('id_user', $id_user);
        $this->db->where('id_scrap_target', $id_scrap_target);
        $this->db->delete('tbl_users_scrap_targets');
    }

    function get_scrap_targets_by_username($username) {
        return $this->db->get_where('tbl_scrap_targets', array('ig_username' => $username))->row();
    }

    function get_user_scrap_target_by_user_and_target($user_id, $target_id) {
        return $this->db->get_where('tbl_users_scrap_targets', array('id_user' => $user_id, 'id_scrap_target' => $target_id))->row();
    }

    public function self_target($user, $is_self = false, $admin=null, $engine=null) {
        $id_scrap_target = 0;
        $has_targeted = $this->get_scrap_targets_by_username($user['ig_username']);
        if($has_targeted) {
            $id_scrap_target = $has_targeted->id_scrap_target;
        } else {
            if(!$is_self) {
                $admin = current($admin);
                $engine = current($engine);
                $new_scrape_target = $this->insert(array('ig_username' => $user['ig_username'], 'id_admin' => $admin['id_user'], 'id_engine' => $engine['id_engine']));
                if($new_scrape_target) {
                    return $this->self_target($user, true);
                } else {
                    return false;
                }
            }
        }
        if($id_scrap_target == 0) {
            return false;
        }
        $has_scrap_targeted = $this->get_user_scrap_target_by_user_and_target($user['id_user'], $id_scrap_target);

        if($has_scrap_targeted) {
            return true;
        } else {
            return $this->insertUsersScrap_targets(array('id_scrap_target' => $id_scrap_target), $user['id_user']);
        }
    }
}