import json
import redis
import time

if __name__ == '__main__':
	DEBUG_UPLOAD_LIMIT = 1000

	r = redis.StrictRedis(host='localhost', port=6379, db=1)

	print('Upload json as true-string.')
	with open('large-file.json') as input_file:
		test_data = json.load(input_file)
	count = len(test_data)
	total_time = 0

	for i, data in enumerate(test_data):
		if i == DEBUG_UPLOAD_LIMIT:
			break
		value = str(data).lower().encode('utf-8')
		start = time.time()
		r.set('obj:%s' % i, value)
		r.save()
		end = time.time()
		total_time += end - start
	print(f'{i, total_time =}')
