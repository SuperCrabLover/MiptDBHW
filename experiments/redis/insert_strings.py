import json
import redis
import time

if __name__ == '__main__':

    DEBUG_UPLOAD_LIMIT = 1000

    r = redis.StrictRedis(host='localhost', port=6379, db=1)

    print('Upload json as true-string.')
    with open('data.json', encoding='cp1251') as input_file:
        test_data = json.load(input_file)
        count = len(test_data)
        start = time.time()

        index = 0
        for index, data in enumerate(test_data):
            if DEBUG_UPLOAD_LIMIT and index == DEBUG_UPLOAD_LIMIT:
                break
            value = str(data).lower().encode('utf-8')
            r.set('obj:%s' % index, value)
            r.save()

        end = time.time()
        print('\t', 'Were upload:', index, 'units')
        print('\t', 'Time left:', end - start, 'sec')
