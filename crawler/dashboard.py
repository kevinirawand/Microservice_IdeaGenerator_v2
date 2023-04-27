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

def checking_result_status():
  try:
    cursor.execute("SELECT value FROM tbl_settings WHERE name = 'is_result_need_scraped'")
    result = cursor.fetchone()
    if result and len(result) > 0:
      if result[0]:
        state = int(result[0])
        if state == 1:
          return True
    return False
  except pymysql.InternalError as e:
    print('Error (checking_result_status): {!r}, errno is {}'.format(
        e, e.args[0]))
    return False

def get_user_and_category():
  try:
    cursor.execute("SELECT id_user, category FROM tbl_users_targets GROUP BY id_user, category")
    results = cursor.fetchall()
    return results
  except pymysql.InternalError as e:
    print('Error (get_user_and_category): {!r}, errno is {}'.format(
        e, e.args[0]))
    return None

def get_labels():
  try:
    cursor.execute("SELECT id_label, label_name FROM tbl_labels")
    results = cursor.fetchall()
    return results
  except pymysql.InternalError as e:
    print('Error (get_labels): {!r}, errno is {}'.format(
        e, e.args[0]))
    return None

def dashboard_procedure(id_user, interval, category, id_label):
  try:
    q = "CALL p_result_dashboard_a(%s,%s,%s,%s)"
    cursor.execute(q, (id_user, interval, category, id_label))
    results = cursor.fetchall()
    return results
  except pymysql.InternalError as e:
    print('Error (get_labels): {!r}, errno is {}'.format(
        e, e.args[0]))
    return None

def get_dashboard_result(user_category, labels, intervals):
  data = []
  for uc in user_category:
    for label in labels:
      for interval in intervals:
        label_id = label[0]
        label_name = label[1]
        user_id = uc[0]
        category = uc[1]
        results = dashboard_procedure(user_id, interval, category, label_id)
        for result in results:
          normal_text = result[0]
          modus = result[1]
          total_px = result[2]
          p_value = result[3]
          data.append((user_id, category, label_id, interval, normal_text, modus, total_px, p_value))
  return data

def remove_from_database():
    try:
        sql = "DELETE FROM `tbl_results` WHERE DATE(updated) = DATE(NOW()) "
        cursor.execute(sql)
        db.commit()
        print('Info (remove_from_database): data removed')
    except pymysql.InternalError as e:
        print('Error (remove_from_database): {!r}, errno is {}'.format(
            e, e.args[0]))

def save_to_database(data):
    try:
        sql = "INSERT INTO `tbl_results` (`id_user`, `category`, `id_label`, `day_count`, `normal_text`, `modus`, `total_px`, `p_value`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"

        cursor.executemany(sql, data)
        db.commit()
        print('Info (save_to_database): data saved')
    except pymysql.InternalError as e:
        print('Error (save_to_database): {!r}, errno is {}'.format(
            e, e.args[0]))

def set_setting_to_default():
  try:
    sql = "UPDATE tbl_settings ts SET ts.value = 0 WHERE ts.name = 'is_result_need_scraped'"
    cursor.execute(sql)
    db.commit()
    print('Info (set_setting_to_default): data saved')
  except pymysql.InternalError as e:
    print('Error (set_setting_to_default): {!r}, errno is {}'.format(
          e, e.args[0]))

print()
print("[===] START [===]")
print()
print("Checking state for scrape")
is_available = checking_result_status()

if is_available:
  print("Removing today data if available")
  remove_from_database()

  print("Fetching and Saving data to result table")
  user_category = get_user_and_category()
  labels = get_labels()
  intervals = [1, 7, 30]
  dashboard_result = get_dashboard_result(user_category, labels, intervals)
  save_to_database(dashboard_result)

  print("Set setting state to default value")
  set_setting_to_default()

else:
  print("Do Nothing")

print()
print("[===] FINISH [===]")
print()