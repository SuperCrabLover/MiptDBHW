import json
import redis
import time
def redis_rpush(r, name:str, val:str) -> bool:
	return r.rpush(name, val)

def redis_lrange(r, name:str) -> str:
	return r.lrange(name, 0, -1)

def conduct_exp(exp_am:int, redis_fun, r, flush=False) -> [int, float]:
	total_times = 0
	for _ in range(exp_am):
		if flush:
			r.flushdb()
		exp_time = 0
		for i, data in enumerate(test_data):
			value = json.dumps(data)
			start = time.time()
			flag = redis_fun(r, 'film_playlist', value)
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
	exp_am = 1

	print(f'Mean of {exp_am} experiments.')
	print('Please stand by. Setting.')
	i, res = conduct_exp(exp_am, redis_rpush, r, flush=True)
	print(f'Amount of "sets" per experiment = {i}, Mean "sets" elapsed time = {res} sec.')
	start = time.time()
	redis_lrange(r, 'film_playlist')
	end = time.time()
	res = end - start
	print('Please stand by. Reading.')
	print(f'Amount of "gets" per experiment = {i}, Mean "gets" elapsed time = {res} sec.')
	r.flushdb()
	
