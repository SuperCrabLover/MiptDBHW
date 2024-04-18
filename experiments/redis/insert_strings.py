import json
import redis
import time

if __name__ == '__main__':

	r = redis.StrictRedis(host='localhost', port=6379, db=1)
	with open('large-file.json') as input_file:
		test_data = json.load(input_file)
	total_time = 0

	print('Please stand by.')
	for i, data in enumerate(test_data):

		value = str(data).lower().encode('utf-8')
		start = time.time()
		flag = r.set(f'obj:{i}', value)
		end = time.time()
		total_time += end - start
		if flag is False:
			raise Exception('Set error! Aborting')
	print(f'amount of "sets" = {i}, elapsed time = {total_time} sec.')
	
