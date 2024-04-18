import json
import redis
import time

if __name__ == '__main__':
	r = redis.StrictRedis(host='localhost', port=6379, db=1)
	with open('large-file.json') as input_file:
		test_data = json.load(input_file)
	total_time = 0

	print('Please stand by. Setting.')
	for i, data in enumerate(test_data):
		value = str(data).lower().encode('utf-8')
		start = time.time()
		flag = r.set(f'obj:{i}', value)
		end = time.time()
		total_time += end - start
		if flag is False:
			raise Exception('Set error! Aborting')
	print(f'amount of "sets" = {i}, "sets" elapsed time = {total_time} sec.')

	total_time = 0
	print('Please stand by. Reading.')
	for i, _ in enumerate(test_data):
		start = time.time()
		__ = r.get(f'obj:{i}')
		end = time.time()
		total_time += end - start
	print(f'amount of "gets" = {i}, "gets" elapsed time = {total_time} sec.')
	
