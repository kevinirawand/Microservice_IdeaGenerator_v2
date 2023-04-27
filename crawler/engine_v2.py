import json
import os.path
import pymysql
import yaml
import time
import tzlocal
import pytz
import datetime
import keywords

from InstagramAPI import InstagramAPI

from collections import Counter

data = None
id_engine = None
crawling_cycle = None
target = []

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

# define engine id and crawling cycle
id_engine = data['id_engine']
crawling_cycle = data['crawling_cycle']
custom_cycle_num_days = data['custom_cycle_num_days']

# Database logic
def saveToDatabase(data):
	try:
		with db.cursor() as cursor:
			# select first for same ID
			sql = "SELECT * FROM `tbl_crawling` WHERE `url`=%s"
			cursor.execute(sql, (data['url']))
			result = cursor.fetchone()

			if((result == None) and (data['engagement'] == 'H')):
				# print("sebelum insert")
				# Create a new record
				try:
					# print(data)
					# text_sql = "INSERT INTO `tbl_crawling` (`ig_username`, `follower_count`, `taken_at`, `like_count`, `caption_text`, `time_frame`, `created`, `url`) VALUES ('"+data['ig_username']+"', '"+str(data['follower_count'])+"', '"+str(data['taken_at'])+"', '"+str(data['like_count'])+"', '"+data['caption_text']+"', '"+str(data['time_frame'])+"', '"+data['created']+"', '"+data['url']+"')"
					# print(text_sql)	

					sql = "INSERT INTO `tbl_crawling` (`ig_username`, `follower_count`, `taken_at`, `like_count`, `caption_text`, `time_frame`, `created`, `url`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
					cursor.execute(sql, (data['ig_username'],data['follower_count'],data['taken_at'],data['like_count'],data['caption_text'],data['time_frame'],data['created'],data['url']))
					# print(sql)
					print('{} is saved'.format(data['url']))
				except pymysql.InternalError as e:
					print('Got error {!r}, errno is {}'.format(e, e.args[0]))

			else:
				pass
			
		# connection is not autocommit by default. So you must commit to save
		# your changes.
		db.commit()
	except pymysql.InternalError as e:
		print('Got error {!r}, errno is {}'.format(e, e.args[0]))


def getTimeFrame(time):
	# 02:00 - 07:59
	if((time.hour >= 2 and time.minute >= 0) and (time.hour <= 7 and time.minute <= 59)):
		return 1
	# 08:00 - 12:59
	elif((time.hour >= 8 and time.minute >= 0) and (time.hour <= 12 and time.minute <= 59)):
		return 2
	# 13:00 - 15:59
	elif((time.hour >= 13 and time.minute >= 0) and (time.hour <= 15 and time.minute <= 59)):
		return 3
	# 16:00 - 17:59
	elif((time.hour >= 16 and time.minute >= 0) and (time.hour <= 17 and time.minute <= 59)):
		return 4
	# 18:00 - 21:59
	elif((time.hour >= 18 and time.minute >= 0) and (time.hour <= 21 and time.minute <= 59)):
		return 5
	# 22:00 - 01:59
	# else if((time.hour > 22 && time.minute > 0) && (time.hour < 1 && time.minute < 59))
	else:
		return 6


def calculateDbEngagementRange(username):
	results = []
	post_likers = []
	try:
		with db.cursor() as cursor:
			# select first for same ID
			sql = "SELECT url, like_count FROM `tbl_crawling` WHERE `ig_username`=%s ORDER BY taken_at LIMIT 10"
			cursor.execute(sql, (username,))
			results = cursor.fetchall()
			if(len(results) > 0):
				for row in results:
					url = row[0]
					like_count = row[1]
					# Now print fetched result
					#   print ("target_id = %s,target_username = %s" % (target_id, target_username))
					post_likers.append(like_count)
					print(post_likers)
			else:
				result = calculateApiEngagementRange(username)
				return result
		# connection is not autocommit by default. So you must commit to save
		# your changes.
		db.commit()
	except pymysql.InternalError as e:
		print('Got error {!r}, errno is {}'.format(e, e.args[0]))

	post_likers.sort()
	highest = post_likers[len(post_likers)-1]
	roundup = (highest - post_likers[0]) / 4
	# results.append(roundup)
	# results.append(post_likers[0])
	# print(roundup, " - hasil dari ", post_likers)
	return results	


def calculateApiEngagementRange(username):
	print("Calculating engagement range for ", username)
	results = []
	InstagramAPI.searchUsername(username)
	user_data = InstagramAPI.LastJson
	userpk = user_data['user']['pk']
	InstagramAPI.getUserFeed(userpk)
	data = InstagramAPI.LastJson
	post_likers = []
	for item in data['items']:
		dataLike = item['like_count']
		post_likers.append(dataLike)
		print('Likers ', item['like_count'])
		print('https://instagram.com/p/', item['code'])
	post_likers.sort()
	highest = post_likers[len(data['items'])-1]
	# Searching for spike
	spike_rate = highest / post_likers[len(data['items'])-2]
	if(spike_rate > 2):
		del post_likers[-1]
		highest = post_likers[len(data['items'])-2]
	roundup = (highest - post_likers[0]) / 4
	results.append(roundup)
	results.append(post_likers[0])
	print(roundup, " - hasil dari ", post_likers)
	return results


def getTotalUserFeedFocusOn(username, results):
		InstagramAPI.searchUsername(username)
		data = InstagramAPI.LastJson
		userpk = data['user']['pk']
		print('Searching posts data with username :', username, ' (', userpk,')')
		dataFollower = data['user']['follower_count']
		print('Total Follower: ', dataFollower)
		# avgLike = calculateEngagementRange(data['items'])
		next_max_id = ''
		loop_state = True
		now = datetime.datetime.now()
		now_today = now.strftime("%d")
		while loop_state:
				InstagramAPI.getUserFeed(userpk, next_max_id, None)
				temp = InstagramAPI.LastJson
				# avgLike, lowest = calculateEngagementRange(temp['items'])
				for item in temp["items"]:
						# print('====================')
						# print(item['code'])
						url = "https://instagram.com/p/" + item['code']
						ts = int(item['taken_at'])
						# print(url)
						local_timezone = tzlocal.get_localzone() # get pytz timezone
						taken_at_local_time = datetime.datetime.fromtimestamp(ts, local_timezone)
						# print(taken_at_local_time)
						taken_at_day = taken_at_local_time.strftime("%d")
						# now = datetime.datetime.now()
						# now_today = now.strftime("%d")
						# # yesterday = now + datetime.timedelta(days=-1)
						# # now_yesterday = yesterday.strftime("%d")
						# # print("now_today "+str(now_today))
						# # print("now_yesterday "+str(now_yesterday))
						# # print("taken_at_day "+str(taken_at_day))
						
						date_format = "%Y/%m/%d"
						taken_at_local_time_formatted = datetime.datetime.strptime(taken_at_local_time.strftime(date_format), date_format)
						now_formatted = datetime.datetime.strptime(now.strftime(date_format), date_format)
						datediff_now_taken_at = now_formatted - taken_at_local_time_formatted

						if(crawling_cycle == 'daily'):
							if(datediff_now_taken_at.days != 1 and now_today != taken_at_day):
								loop_state = False
								break
						elif(crawling_cycle == 'weekly'):
							if((datediff_now_taken_at.days <= 0 or datediff_now_taken_at.days > 7) and now_today != taken_at_day):
								loop_state = False
								break
						elif(crawling_cycle == 'monthly'):
							if((datediff_now_taken_at.days <= 0 or datediff_now_taken_at.days > 30) and now_today != taken_at_day):
								loop_state = False
								break
						elif(crawling_cycle == 'yearly'):
							if((datediff_now_taken_at.days <= 0 or datediff_now_taken_at.days > 365) and now_today != taken_at_day):
								loop_state = False
								break
						elif(crawling_cycle == 'custom'):
							if((datediff_now_taken_at.days <= 0 or datediff_now_taken_at.days > int(custom_cycle_num_days)) and now_today != taken_at_day):
								loop_state = False
								break
						else:
							print("Crawling cycle is not in list!")
							loop_state = False
							break
						
						if(now_today != taken_at_day and loop_state == True):
							dataLike = item['like_count']
							timeFrame = getTimeFrame(taken_at_local_time)
							created = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
							updated = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
							engagement = 'L'
							r1 = results[1] + results[0]
							r2 = r1 + results[0]
							r3 = r2 + results[0]
							print("............")
							print("Range: ",results[1],"-",r1,";",r1,"-",r2,";",r2,"-",r3,";",">",r3)
							if((dataLike >= results[1]) and (dataLike < r1)):
								engagement = 'L'	
								# print(dataLike, "sebagai ", engagement, "Range ", r2, " - ", r3)
							elif((dataLike >= r1) and (dataLike < r2)):
								engagement = 'M'	
							elif((dataLike >= r2) and (dataLike < r3)):
								engagement = 'H'	
								# print(dataLike, "sebagai ", engagement, "Range ", r3, " - ", r4)
							elif(dataLike >= r3):
								engagement = 'H'	
								# print(dataLike, "sebagai ", engagement, "Range ", r4)
							print(url)
							print(taken_at_local_time)
							print(dataLike)
							print(engagement)
							print("akhir")
							# print(url)
							# print(taken_at_local_time)

							# ready to save 
							saveData = {'ig_username': username, 'follower_count': dataFollower, 'taken_at': taken_at_local_time, 'like_count': dataLike, 'caption_text': item['caption']['text'], 'time_frame': timeFrame, 'created': created, 'updated': updated, 'url': url, 'is_extracted': '0', 'engagement': engagement}
							saveToDatabase(saveData)

				if temp["more_available"] is False:
						pass
				next_max_id = temp["next_max_id"]



# Start Program
# get target username
try:
	# Execute the SQL command
	cursor.execute("SELECT tg.ig_username FROM tbl_targets tg INNER JOIN tbl_engines en ON en.id_engine = tg.id_engine WHERE en.id_engine = '"+str(id_engine)+"'")
	# Fetch all the rows in a list of lists.
	results = cursor.fetchall()

	for row in results:
		target_username = row[0]
		# Now print fetched result
		target.append(target_username)
except:
   print ("Error: unable to fetch data")

# get client username
try:
	# Execute the SQL command
	cursor.execute("SELECT us.ig_username FROM tbl_users us INNER JOIN tbl_engines en ON en.id_engine = us.id_engine WHERE en.id_engine = '"+str(id_engine)+"'")
	# Fetch all the rows in a list of lists.
	results = cursor.fetchall()

	for row in results:
		target_username = row[0]
		# Now print fetched result
		target.append(target_username)
except:
   print ("Error: unable to fetch data")

print(target) 



try:
	# print(target)
	# Login
	cursor.execute("SELECT * FROM tbl_engines eng WHERE eng.id_engine = '"+str(id_engine)+"'")
	# Fetch all the rows in a list of lists.
	result = cursor.fetchall()

	InstagramAPI = InstagramAPI(result[0][1], result[0][2])
	InstagramAPI.login()
	# Get username and pk info
	for target_username in target:
		try:
			print("==========START==========")
			calculation_result = calculateApiEngagementRange(target_username)
			getTotalUserFeedFocusOn(target_username, calculation_result)
			print("===========END===========")
		except Exception as e: print(e)
	
  # Save keywords
	keywords.execute()
except KeyboardInterrupt:
	print("Stopped by user")
        
