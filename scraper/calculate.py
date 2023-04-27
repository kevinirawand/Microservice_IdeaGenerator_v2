import pymysql
import json
import os
# import keywords

# Setup weight
WEIGHT_FOLLOWER = 2
WEIGHT_CONTENT_PER_DAY = 2
WEIGHT_ENGAGEMENT_PER_CONTENT = 3
WEIGHT_RESPONSE_COMMENT = 1
WEIGHT_TOTAL_SCORE = 8

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


def get_users_and_targets():
    try:
        cursor.execute(
            "SELECT MAX(ut.id_user) AS id_user, MAX(ut.id_scrap_target) AS id_scrap_target, t.ig_username, COUNT(s.url) AS total_content, SUM(s.follower_count) / COUNT(s.url) AS total_follower, SUM(s.like_count) AS total_engagement, SUM(s.comment_count) AS total_comment, SUM(s.response_count) AS total_response, MAX(s.updated) AS updated FROM tbl_users_scrap_targets ut INNER JOIN tbl_scrap_targets t ON t.id_scrap_target = ut.id_scrap_target INNER JOIN tbl_scraping s ON s.ig_username = t.ig_username WHERE DATE(s.updated) = DATE(NOW()) GROUP BY ut.id_user, ut.id_scrap_target ORDER BY id_user")
        results = cursor.fetchall()
        return results
    except pymysql.InternalError as e:
        print('Error (get_users_and_targets): {!r}, errno is {}'.format(
            e, e.args[0]))
        return None


def get_max(data, user_id):
    max_total_follower = 0          # [0]
    max_content_per_day = 0         # [1]
    max_engagement_per_content = 0  # [2]
    max_response_comment = 0        # [3]

    for item in data:
        if item[0] == user_id:
            if max_total_follower < int(item[4]):
                max_total_follower = int(item[4])
            content_per_day = int(item[3]) / 1  # 344 change to 1 for 1 day
            if max_content_per_day < content_per_day:
                max_content_per_day = content_per_day
            if item[3] > 0:
                engagement_per_content = int(item[5]) / int(item[3])
                if max_engagement_per_content < engagement_per_content:
                    max_engagement_per_content = engagement_per_content
            if item[6] > 0:
                response_comment = int(item[7]) / int(item[6])
                if max_response_comment < response_comment:
                    max_response_comment = response_comment

    return (max_total_follower, max_content_per_day, max_engagement_per_content, max_response_comment)

# [0] `id_user`, [1] `id_scrap_target`, [2] `ig_username`, [3] `total_content`, [4] `total_follower`, [5] `total_engagement`, [6] `total_comment`, [7] `total_response`, [8] `updated`
# val_item = (item[0], item[1], item[2], item[3], int(item[4]), int(item[5]), int(item[6]), int(item[7]), item[8].strftime("%Y-%m-%d %H:%M:%S"))


def setup_value(data):
    val = []
    max_data = None
    user_id = None

    for item in data:
        # steps to total score
        content_per_day = int(item[3]) / 1 # 344 change to 1 for 1 day
        engagement_per_content = 0
        if item[3] > 0:
            engagement_per_content = int(item[5]) / int(item[3])
        response_comment = 0
        if item[6] > 0:
            response_comment = int(item[7]) / int(item[6])

        # Get max value based on user_id
        if user_id != item[0]:
            user_id = item[0]
            max_data = None

        if max_data == None:
            max_data = get_max(data, user_id)

        per_follower = int(item[4])
        if max_data[0] > 0:
            per_follower = int(item[4]) / max_data[0]
        per_content_per_day = content_per_day
        if max_data[1] > 0:
            per_content_per_day = content_per_day / max_data[1]
        per_engagement_per_content = engagement_per_content
        if max_data[2] > 0:
            per_engagement_per_content = engagement_per_content / max_data[2]
        per_response = response_comment
        if max_data[3] > 0:
            per_response = response_comment / max_data[3]

        weight_follower = per_follower * WEIGHT_FOLLOWER
        weight_content_per_day = per_content_per_day * WEIGHT_CONTENT_PER_DAY
        weight_engagement_per_content = per_engagement_per_content * \
            WEIGHT_ENGAGEMENT_PER_CONTENT
        weight_response = per_response * WEIGHT_RESPONSE_COMMENT

        # bypass null response (for different response)
        #if item[6] <= 0:
        #    per_response = None
        #    weight_response = None

        total_score = ((weight_follower + weight_content_per_day +
                        weight_engagement_per_content + weight_response) / WEIGHT_TOTAL_SCORE) * 100

        val_item = (item[0], item[1], item[2], item[3], int(item[4]), int(item[5]), int(item[6]), int(item[7]), item[8], per_follower, per_content_per_day,
                    per_engagement_per_content, per_response, weight_follower, weight_content_per_day, weight_engagement_per_content, weight_response, total_score)

        val.append(val_item)

    return val


def remove_from_database(data):
    try:
        sql = "DELETE FROM `tbl_scraping_result` WHERE DATE(updated) = DATE(NOW()) "
        cursor.execute(sql)
        db.commit()
        print('Info (remove_from_database): data removed')
    except pymysql.InternalError as e:
        print('Error (remove_from_database): {!r}, errno is {}'.format(
            e, e.args[0]))


def save_to_database(data):
    try:
        sql = "INSERT INTO `tbl_scraping_result` (`id_user`, `id_target`, `ig_username`, `total_content`, `total_follower`, `total_engagement`, `total_comment`, `total_response`, `updated`, `per_follower`, `per_content_per_day`, `per_engagement_per_content`, `per_response`, `weight_follower`, `weight_content_per_day`, `weight_engagement_per_content`, `weight_response`, `total_score`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

        val = setup_value(data)

        cursor.executemany(sql, val)
        db.commit()
        print('Info (save_to_database): data saved')
    except pymysql.InternalError as e:
        print('Error (save_to_database): {!r}, errno is {}'.format(
            e, e.args[0]))


def execute():
    data = get_users_and_targets()
    if(data):
        # Remove today data if exist
        remove_from_database(data)
        # Save today data
        save_to_database(data)

        # Save keywords
        # keywords.execute()
    else:
        print("Error (execute): User and Target are empty")

execute()