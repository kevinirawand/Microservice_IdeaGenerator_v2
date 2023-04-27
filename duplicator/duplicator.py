# mysql solution https://stackoverflow.com/questions/4039748/in-mysql-can-i-copy-one-row-to-insert-into-the-same-table
# https://dba.stackexchange.com/questions/142414/easiest-way-to-duplicate-rows
# CREATE TABLE tmptable_1 SELECT id_user, id_target, ig_username, total_follower, total_content, total_engagement, total_comment, total_response, updated, per_follower, per_content_per_day, per_engagement_per_content, per_response, weight_follower, weight_content_per_day, weight_engagement_per_content, weight_response, total_score FROM tbl_scraping_result WHERE id_user = 12
# UPDATE tmptable_1 SET id_user = <id_target_user>
# INSERT INTO tbl_scraping_result (id_user, id_target, ig_username, total_follower, total_content, total_engagement, total_comment, total_response, updated, per_follower, per_content_per_day, per_engagement_per_content, per_response, weight_follower, weight_content_per_day, weight_engagement_per_content, weight_response, total_score) SELECT * FROM tmptable_1;
# DROP tmptable_1 IF EXISTS tmptable_1
# duplicator/env/*
# duplicator/.env/*
# duplicator/venv/*
# duplicator/config.json

import pymysql
import sys
import json
import os.path

print('Argument List:', str(sys.argv))

dir_path = os.path.dirname(os.path.realpath(__file__))
print(dir_path)

# reading configuration json
with open(dir_path + '/config.json') as json_file:  
    data = json.load(json_file)

# Open database connection
db = pymysql.connect(host=data['database']['host'],
                             user=data['database']['username'],
                             password=data['database']['password'],
                             db=data['database']['databasename'],
                             charset='utf8mb4',)

# prepare a cursor object using cursor() method
cursor = db.cursor()

# get tbl_scraping source data
cursor.execute("SELECT * FROM tbl_scraping eng WHERE eng.id_engine = '"+str(id_engine)+"'")
result = cursor.fetchall()