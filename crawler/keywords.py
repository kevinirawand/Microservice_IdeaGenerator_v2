import pymysql
import json
import os

config = None

dir_path = os.path.dirname(os.path.realpath(__file__))
with open(dir_path + '/config.json') as json_file:
    config = json.load(json_file)

db = pymysql.connect(host=config['database']['host'],
                     user=config['database']['username'],
                     password=config['database']['password'],
                     db=config['database']['databasename'],
                     charset='utf8mb4',)
cursor = db.cursor()
users = None


def get_keyword_for_last_three_weeks_u9():
    try:
        cursor.execute(
            "SELECT MAX(p.dow) AS dow, p.id_user, p.id_label, SUM(p.count_label) AS count_label, (SELECT normal_text FROM keyword_result_sub krs WHERE krs.id_user = p.id_user AND krs.id_label = p.id_label ORDER BY krs.count_label DESC LIMIT 1) as normal_text, NOW() AS created FROM keyword_result_sub p GROUP BY p.id_user, p.id_label")
        results = cursor.fetchall()
        return results
    except:
        print("Error (get_users_and_targets): unable to fetch data")
        return None

# def get_keyword_for_last_three_weeks():
#     try:
#         cursor.execute(
#             "SELECT MAX(u.id_user) AS id_user, MAX(ut.id_target) AS id_target, MAX(t.ig_username) AS ig_username, MAX(c.id_crawling) AS id_crawling, MAX(c.url) AS url, MAX(c.taken_at) AS taken_at, MAX(DAYOFWEEK(c.taken_at)) AS dow, MAX(cl.id_label) AS id_label, COUNT(cl.id_label) AS count_label, MAX(n.normal_text) AS normal_text, MAX(NOW()) AS created FROM tbl_users u JOIN tbl_users_targets ut ON ut.id_user = u.id_user JOIN tbl_targets t ON t.id_target = ut.id_target JOIN tbl_crawling c ON c.ig_username = t.ig_username JOIN tbl_normalizations n ON n.id_crawling = c.id_crawling JOIN tbl_classifications cl ON cl.id_crawling = c.id_crawling WHERE DAYOFWEEK(c.taken_at) = DAYOFWEEK(NOW()) AND DATE(c.taken_at) BETWEEN DATE(DATE_SUB(NOW(), INTERVAL 3 WEEK)) AND DATE(NOW()) GROUP BY cl.id_label")
#         results = cursor.fetchall()
#         return results
#     except:
#         print("Error (get_users_and_targets): unable to fetch data")
#         return None

# def get_keyword_for_last_two_weeks():
#     try:
#         cursor.execute(
#             "SELECT u.id_user, ut.id_target, t.ig_username, c.id_crawling, c.url, c.taken_at, DAYOFWEEK(c.taken_at) AS dow, n.normal_text, NOW() AS created FROM tbl_users u JOIN tbl_users_targets ut ON ut.id_user = u.id_user JOIN tbl_targets t ON t.id_target = ut.id_target JOIN tbl_crawling c ON c.ig_username = t.ig_username JOIN tbl_normalizations n ON n.id_crawling = c.id_crawling WHERE DAYOFWEEK(c.taken_at) = DAYOFWEEK(NOW()) AND DATE(c.taken_at) BETWEEN DATE(DATE_SUB(NOW(), INTERVAL 2 WEEK)) AND DATE(NOW())")
#         results = cursor.fetchall()
#         return results
#     except:
#         print("Error (get_users_and_targets): unable to fetch data")
#         return None

def remove_from_database(data):
    try:
        sql = "DELETE FROM `tbl_keyword_result` WHERE DATE(created) = DATE(NOW()) "
        cursor.execute(sql)
        db.commit()
        print('Info (remove_from_database): data removed')
    except pymysql.InternalError as e:
        print('Error (remove_from_database): {!r}, errno is {}'.format(
            e, e.args[0]))

def save_to_database(data):
    try:
        sql = "INSERT INTO `tbl_keyword_result` (`dow`, `id_user`, `id_label`, `count_label`, `normal_text`, `created`) VALUES (%s, %s, %s, %s, %s, %s)"

        cursor.executemany(sql, data)
        db.commit()
        print('Info (save_to_database): data saved')
    except pymysql.InternalError as e:
        print('Error (save_to_database): {!r}, errno is {}'.format(
            e, e.args[0]))

def execute():
    data = get_keyword_for_last_three_weeks_u9()
    if(data):
        # Remove today data if exist
        remove_from_database(data)
        # Save today data
        save_to_database(data)
    else:
        print("Error (execute): User and Target are empty")
