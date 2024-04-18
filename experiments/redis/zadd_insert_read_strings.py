import json
import redis
import time
def redis_zadd(r, name:str, id_to_score:dict) -> bool:
	return r.zadd(name, id_to_score)

def redis_zrange(r, name:str, _) -> dict:
	return r.zrange(name, 0, -1, withscores=True)

def conduct_exp(exp_am:int, redis_fun, r, flush=False) -> [int, float]:
	total_times = 0
	for _ in range(exp_am):
		if flush:
			r.flushdb()
		exp_time = 0
		for i, data in enumerate(test_data):
			value = {f'{i}:{data["title"]}': len(data["title"])}
			start = time.time()
			flag = redis_fun(r, 'films_by_title_len', value)
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
	exp_am = 20

	print(f'Mean of {exp_am} experiments.')
	print('Please stand by. Setting.')
	i, res = conduct_exp(exp_am, redis_zadd, r, flush=True)
	print(f'Amount of "sets" per experiment = {i}, Mean "sets" elapsed time = {res} sec.')

	print('Please stand by. Reading.')
	i, res = conduct_exp(exp_am, redis_zrange, r)
	print(f'Amount of "gets" per experiment = {i}, Mean "gets" elapsed time = {res} sec.')
	r.flushdb()
	
