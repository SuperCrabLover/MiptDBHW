import json
import redis
import time
def redis_set(r, key:str, val:str) -> bool:
	return r.set(key, val)

def redis_get(r, key:str, val:str = None) -> str:
	return r.get(key)

def conduct_exp(exp_am:int, redis_fun, r, flush=False) -> [int, float]:
	total_times = 0
	for _ in range(exp_am):
		if flush:
			r.flushdb()
		exp_time = 0
		for i, data in enumerate(test_data):
			value = str(data).lower().encode('utf-8')
			start = time.time()
			flag = redis_fun(r, f'obj:{i}', value)
			end = time.time()
			exp_time += end - start
			if flag is False:
				raise Exception('Error! Aborting.')
		total_times += exp_time
	return i, total_times / exp_am

if __name__ == '__main__':
	r = redis.StrictRedis(host='localhost', port=6379, db=0)
	with open('large-file.json') as input_file:
		test_data = json.load(input_file)
	exp_am = 10

	print(f'Mean of {exp_am} experiments.')
	print('Please stand by. Setting.')
	i, res = conduct_exp(exp_am, redis_set, r, flush=True)
	print(f'Amount of "sets" per experiment = {i}, Mean "sets" elapsed time = {res} sec.')

	print('Please stand by. Reading.')
	i, res = conduct_exp(exp_am, redis_get, r)
	print(f'Amount of "gets" per experiment = {i}, Mean "gets" elapsed time = {res} sec.')
	
