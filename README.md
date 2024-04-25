# MiptDBHW

## HW 0 

- DragonFly - CP
- ScyllaDB - AP
- ArenadataDB - CA

## HW 1 (MongoDB)

- **Установка MongoDB**. Для установки `mongodb` я выбрал `docker`. С помощью указанного в слайдах сайта я скачал и установил необходимый образ.
При запуске я вмонтировал специальную папку, чтобы удобнее было передавать датасеты между машиной-хозяином и 
докер-контейнером. 
- **Выбор данных**. Базу данных я выбрал буквально первую попавщуюся на сайте, прикрепленном в слайдах: `Mall_Customers`. С помощью монтированной
папки и утилиты `mongoimport` вне `mongosh` (я выбрал CLI-интерфейс) я успешно импортировал базу данных:
```bash
root@9088b3b9e4e4:~# mongoimport -d Mall_customers -c MallCustomers --type csv --file Mall_Customers.csv --headerline
2024-04-04T17:44:02.100+0000	connected to: mongodb://localhost/
2024-04-04T17:44:02.112+0000	200 document(s) imported successfully. 0 document(s) failed to import.
```
- **Запросы на выборку, обновление и удаление данных**.

    *Create*:
    ```bash
    Mall_customers> db.MallCustomers.insertOne({CustomerUD: 1337, Genre: 'Male', Age: 22, 'Annual Income (k$)': 100500, 'Spending Score (1-100)': 100})
    {
        acknowledged: true,
        insertedId: ObjectId('660eee332c0a22655e7b2da9')
    }
    Mall_customers> db.MallCustomers.find({ "_id": ObjectId("660eee332c0a22655e7b2da9") })
    [
        {
            _id: ObjectId('660eee332c0a22655e7b2da9'),
            CustomerUD: 1337,
            Genre: 'Male',
            Age: 22,
            'Annual Income (k$)': 100500,
            'Spending Score (1-100)': 100
        }
    ]
    ```
    *Update*:
    ```bash
    Mall_customers> db.MallCustomers.updateOne({"_id": ObjectId("660eee332c0a22655e7b2da9")}, {$set: {'Age': 23}})
    {
        acknowledged: true,
        insertedId: null,
        matchedCount: 1,
        modifiedCount: 1,
        upsertedCount: 0
    }
    Mall_customers> db.MallCustomers.find({ "_id": ObjectId("660eee332c0a22655e7b2da9") })
    [
        {
            _id: ObjectId('660eee332c0a22655e7b2da9'),
            CustomerUD: 1337,
            Genre: 'Male',
            Age: 23,
            'Annual Income (k$)': 100500,
            'Spending Score (1-100)': 100
        }
    ]
    ```
    *Read*: 
    ```bash
    Mall_customers> show collections
    MallCustomers
    Mall_customers> db.MallCustomers.findOne()
    {
        _id: ObjectId('660ee6e295acbc82b53815f8'),
        CustomerID: 2,
        Genre: 'Male',
        Age: 21,
        'Annual Income (k$)': 15,
        'Spending Score (1-100)': 81
    }
    ```
    ```bash
    Mall_customers> db.MallCustomers.find({"Age": {"$gt": 69}})
    [
        {
            _id: ObjectId('660ee6e295acbc82b538162d'),
            CustomerID: 61,
            Genre: 'Male',
            Age: 70,
            'Annual Income (k$)': 46,
            'Spending Score (1-100)': 56
        },
        {
            _id: ObjectId('660ee6e295acbc82b538163f'),
            CustomerID: 71,
            Genre: 'Male',
            Age: 70,
            'Annual Income (k$)': 49,
            'Spending Score (1-100)': 55
        }
    ]
    ```

    *Delete*:
    ```bash
    Mall_customers> db.MallCustomers.deleteOne({ "_id": ObjectId("660eee332c0a22655e7b2da9") }, {})
    { acknowledged: true, deletedCount: 1 }
    Mall_customers> db.MallCustomers.find({ "_id": ObjectId("660eee332c0a22655e7b2da9") })
    
    ```

- **Индексы**:
    ```bash
    all_customers> db.MallCustomers.find({'Age':25}).explain('executionStats')
    {
    explainVersion: '1',
    queryPlanner: {
        namespace: 'Mall_customers.MallCustomers',
        indexFilterSet: false,
        parsedQuery: { Age: { '$eq': 25 } },
        queryHash: 'D2E0353D',
        planCacheKey: 'D2E0353D',
        maxIndexedOrSolutionsReached: false,
        maxIndexedAndSolutionsReached: false,
        maxScansToExplodeReached: false,
        winningPlan: {
        stage: 'COLLSCAN',
        filter: { Age: { '$eq': 25 } },
        direction: 'forward'
        },
        rejectedPlans: []
    },
    executionStats: {
        executionSuccess: true,
        nReturned: 3,
        executionTimeMillis: 0,
        totalKeysExamined: 0,
        totalDocsExamined: 200,
        executionStages: {
        stage: 'COLLSCAN',
        filter: { Age: { '$eq': 25 } },
        nReturned: 3,
        executionTimeMillisEstimate: 0,
        works: 201,
        advanced: 3,
        needTime: 197,
        needYield: 0,
        saveState: 0,
        restoreState: 0,
        isEOF: 1,
        direction: 'forward',
        docsExamined: 200
        }
    },
    command: {
        find: 'MallCustomers',
        filter: { Age: 25 },
        '$db': 'Mall_customers'
    },
    serverInfo: {
        host: '9088b3b9e4e4',
        port: 27017,
        version: '7.0.8',
        gitVersion: 'c5d33e55ba38d98e2f48765ec4e55338d67a4a64'
    },
    serverParameters: {
        internalQueryFacetBufferSizeBytes: 104857600,
        internalQueryFacetMaxOutputDocSizeBytes: 104857600,
        internalLookupStageIntermediateDocumentMaxSizeBytes: 104857600,
        internalDocumentSourceGroupMaxMemoryBytes: 104857600,
        internalQueryMaxBlockingSortMemoryUsageBytes: 104857600,
        internalQueryProhibitBlockingMergeOnMongoS: 0,
        internalQueryMaxAddToSetBytes: 104857600,
        internalDocumentSourceSetWindowFieldsMaxMemoryBytes: 104857600,
        internalQueryFrameworkControl: 'trySbeRestricted'
    },
    ok: 1
    }
    ```
    `totalDocsExamined: 200` - просмотрена вся база данных.
    Создаем необходимые индексы:
    ```bash
    Mall_customers> db.MallCustomers.createIndex({'Age':25})
    Age_25
    ```

    Cнова запускаем то же самое:
    ```bash
    Mall_customers> db.MallCustomers.find({'Age':25}).explain('executionStats')
    {
    explainVersion: '1',
    queryPlanner: {
        namespace: 'Mall_customers.MallCustomers',
        indexFilterSet: false,
        parsedQuery: { Age: { '$eq': 25 } },
        queryHash: 'D2E0353D',
        planCacheKey: '68E30953',
        maxIndexedOrSolutionsReached: false,
        maxIndexedAndSolutionsReached: false,
        maxScansToExplodeReached: false,
        winningPlan: {
        stage: 'FETCH',
        inputStage: {
            stage: 'IXSCAN',
            keyPattern: { Age: 25 },
            indexName: 'Age_25',
            isMultiKey: false,
            multiKeyPaths: { Age: [] },
            isUnique: false,
            isSparse: false,
            isPartial: false,
            indexVersion: 2,
            direction: 'forward',
            indexBounds: { Age: [ '[25, 25]' ] }
        }
        },
        rejectedPlans: []
    },
    executionStats: {
        executionSuccess: true,
        nReturned: 3,
        executionTimeMillis: 9,
        totalKeysExamined: 3,
        totalDocsExamined: 3,
        executionStages: {
        stage: 'FETCH',
        nReturned: 3,
        executionTimeMillisEstimate: 10,
        works: 4,
        advanced: 3,
        needTime: 0,
        needYield: 0,
        saveState: 0,
        restoreState: 0,
        isEOF: 1,
        docsExamined: 3,
        alreadyHasObj: 0,
        inputStage: {
            stage: 'IXSCAN',
            nReturned: 3,
            executionTimeMillisEstimate: 10,
            works: 4,
            advanced: 3,
            needTime: 0,
            needYield: 0,
            saveState: 0,
            restoreState: 0,
            isEOF: 1,
            keyPattern: { Age: 25 },
            indexName: 'Age_25',
            isMultiKey: false,
            multiKeyPaths: { Age: [] },
            isUnique: false,
            isSparse: false,
            isPartial: false,
            indexVersion: 2,
            direction: 'forward',
            indexBounds: { Age: [ '[25, 25]' ] },
            keysExamined: 3,
            seeks: 1,
            dupsTested: 0,
            dupsDropped: 0
        }
        }
    },
    command: {
        find: 'MallCustomers',
        filter: { Age: 25 },
        '$db': 'Mall_customers'
    },
    serverInfo: {
        host: '9088b3b9e4e4',
        port: 27017,
        version: '7.0.8',
        gitVersion: 'c5d33e55ba38d98e2f48765ec4e55338d67a4a64'
    },
    serverParameters: {
        internalQueryFacetBufferSizeBytes: 104857600,
        internalQueryFacetMaxOutputDocSizeBytes: 104857600,
        internalLookupStageIntermediateDocumentMaxSizeBytes: 104857600,
        internalDocumentSourceGroupMaxMemoryBytes: 104857600,
        internalQueryMaxBlockingSortMemoryUsageBytes: 104857600,
        internalQueryProhibitBlockingMergeOnMongoS: 0,
        internalQueryMaxAddToSetBytes: 104857600,
        internalDocumentSourceSetWindowFieldsMaxMemoryBytes: 104857600,
        internalQueryFrameworkControl: 'trySbeRestricted'
    },
    ok: 1
    }
    ```
    `totalDocsExamined: 3` - успех!

## HW 2 Redis
- **Установка Redis**. Для установки `redis` я выбрал `docker`. Для экспериментов нам 
	помимо `redis` будет нужен еще и `python`. Готовых `docker` образов под эту задачу я не нашел, поэтому написал свой.
	Я положил его в папку `/experiments/redis`. Чтобы всё заработало необходимо исполнить следующие команды
	в директории, в которой лежит образ: 
	```bash
	sudo docker build -t redis-py .
	sudo docker run -it -v /mongodata:/data/db --name redis-server -d redis-py
	sudo docker exec -it redis-server bash
	```
	Получилось примонтировать к контейнеру уже знакомую нам с прошлой домашки папку, в которую мы положим наш `.json` файл. Кстати, о
	нём. Нашел какой-то случайный репозиторий с `.json` файлом размером `25 mb` 
	[`large-file.json`](https://raw.githubusercontent.com/prust/wikipedia-movie-data/master/movies.json). Его положил в 
	папку `/mongodata` на машине-хозяине. Так же все программы на `python` с помощью 
	жестких ссылок были помещены в `/mongodata`. Последнего можно добиться с помощью команды `ln path_to_sript /mongodata`. Теперь прямо во 
	время работы `docker` контейнера можно менять код скриптов и они автоматически будут обновляться в контейнере.

	Конечно же, можно было бы подключиться к `redis docker container` и использовать локальный питон, но тогда пришлось бы создать
	отдельную виртуальную среду для `redis-py`, поскольку существуеющие среды не хочется трогать. Зато в примененном решении мы получаем отдельный
	'black box' со всеми фантиками.
- **Первый эксперимент**. Запустив контейнер, перейдем в папку `/data/db/` и в ней запустим первый эксперимент, который батчами записывает 
	наш `.json` файл в `redis`, а потом читает. Каждый батч -- обыкновенная строка. Эксперимент запускается несколько раз.
	Запуск производится следующей командой:
	```bash
	python3 insert_strings.py
	```
	На что программа отвечает:
	```
	Mean of 20 experiments.
	Please stand by. Setting.
	Amount of "sets" per experiment = 36272, Mean "sets" elapsed time = 1.7334792852401733 sec.
	Please stand by. Reading.
	Amount of "gets" per experiment = 36272, Mean "gets" elapsed time = 1.573960280418396 sec.	
	```
	То же самое для `hset` и `hgetall`:
	```bash
	python3 hash_insert_strings.py
	```
	На что программа отвечает:
	```
	Mean of 20 experiments.
	Please stand by. Setting.
	Amount of "sets" per experiment = 36272, Mean "sets" elapsed time = 2.6383649468421937 sec.
	Please stand by. Reading.
	Amount of "gets" per experiment = 36272, Mean "gets" elapsed time = 3.03878173828125 sec.
	```
	Ну что сказать `hgetall` O(n)!

	Далее по очереди `zadd`, для этого экспримента в качестве `id` в `zset` используется строка `i:title`, где `i` -- номер в порядке
	вычитывания фильма из `.json` файла, а `title` -- название этого фильма (в теории сюда можно было бы запихнуть в виде строки заместо `title`
	вообще весь `dict` для этого фильма, но для скорости я этого делать не стал). В качестве параметра для сортировки я выбрал длину названия 
	фильма (`title`), потому как это было очень просто отдебажить. В итоге:
	```bash
	python3 zadd_insert_strings.py
	```
	На что программа отвечает:
	```
	Mean of 1 experiments.
	Please stand by. Setting.
	Amount of "sets" per experiment = 36272, Mean "sets" elapsed time = 1.8618367195129395 sec.
	Please stand by. Reading.
	Amount of "gets" per experiment = 36272, Mean "gets" elapsed time = 0.1080770492553711 sec.
	```

	Крайняя структура `list`. Все просто -- добавляем фильмы справа, а потом читаем! Фильмы теперь -- строка из всего `dict` фильма. Все равно работает
	очень бодро:
	```bash
	python3 list_insert_strings.py
	```
	На что программа отвечает:
	```
	Mean of 1 experiments.
	Please stand by. Setting.
	Amount of "sets" per experiment = 36272, Mean "sets" elapsed time = 1.7295863628387451 sec.
	Please stand by. Reading.
	Amount of "gets" per experiment = 36272, Mean "gets" elapsed time = 0.09893512725830078 sec.
	```
- **Второй эксперимент**. Надо поднять кластер на трёх нодах!Ура!
	Я написал два `bash` скрипта один создает кластер, а второй можно вызвать чтобы почистить порты, 
	если выйти безопасно не получилось. Чтобы их использовать нужно поместить их в наш докер контейнер и
	сделать исполняемыми с помощью `chmod +x file_name.sh`, после чего запустить через `./file_name.sh`
 	В файле `cluster_generator.sh` можно альтерировать таймауты и порты для нод. После запуска `cluster_generator.sh`
	`redis` предложит конкретную конфигурацию:
	```
	>>> Performing hash slots allocation on 3 nodes...
	Master[0] -> Slots 0 - 5460
	Master[1] -> Slots 5461 - 10922
	Master[2] -> Slots 10923 - 16383
	M: 41f70293d7f73e845f11320ea9ced5767e5610de localhost:7001
	   slots:[0-5460] (5461 slots) master
	M: 6315ceca833d82615190c3eb3da04eaa7e7b93ec localhost:7002
	   slots:[5461-10922] (5462 slots) master
	M: 3787668c0bb06db7828f89123bcb968184b92207 localhost:7003
	   slots:[10923-16383] (5461 slots) master
	Can I set the above configuration? (type 'yes' to accept):
	```
	
	Ну кто мы такие, чтобы ему отказывать? Конечно же печатаем `yes` и видим:
	```
	>>> Nodes configuration updated
	>>> Assign a different config epoch to each node
	1030:M 18 Apr 2024 20:48:58.585 * configEpoch set to 1 via CLUSTER SET-CONFIG-EPOCH
	1033:M 18 Apr 2024 20:48:58.592 * configEpoch set to 2 via CLUSTER SET-CONFIG-EPOCH
	1036:M 18 Apr 2024 20:48:58.592 * configEpoch set to 3 via CLUSTER SET-CONFIG-EPOCH
	>>> Sending CLUSTER MEET messages to join the cluster
	1030:M 18 Apr 2024 20:48:58.649 * IP address for this node updated to ::1
	1036:M 18 Apr 2024 20:48:58.750 * IP address for this node updated to ::1
	1033:M 18 Apr 2024 20:48:58.750 * IP address for this node updated to ::1
	Waiting for the cluster to join
	.
	>>> Performing Cluster Check (using node localhost:7001)
	M: 41f70293d7f73e845f11320ea9ced5767e5610de localhost:7001
	   slots:[0-5460] (5461 slots) master
	M: 6315ceca833d82615190c3eb3da04eaa7e7b93ec ::1:7002
	   slots:[5461-10922] (5462 slots) master
	M: 3787668c0bb06db7828f89123bcb968184b92207 ::1:7003
	   slots:[10923-16383] (5461 slots) master
	[OK] All nodes agree about slots configuration.
	>>> Check for open slots...
	>>> Check slots coverage...
	[OK] All 16384 slots covered.
	root@f280283dc251:~# 1036:M 18 Apr 2024 20:49:03.571 * Cluster state changed: ok
	1033:M 18 Apr 2024 20:49:03.571 * Cluster state changed: ok
	1030:M 18 Apr 2024 20:49:03.571 * Cluster state changed: ok
	```

	В итоге получится вот так:
	```bash
	root@f280283dc251:~# redis-cli -p 7001
	127.0.0.1:7001> CLUSTER NODES
	6315ceca833d82615190c3eb3da04eaa7e7b93ec ::1:7002@17002 master - 0 1713473560437 2 connected 5461-10922
	41f70293d7f73e845f11320ea9ced5767e5610de ::1:7001@17001 myself,master - 0 1713473558000 1 connected 0-5460
	3787668c0bb06db7828f89123bcb968184b92207 ::1:7003@17003 master - 0 1713473560000 3 connected 10923-16383
	```

	Ну и хватит:
	```bash
	root@f280283dc251:~# ./redis_cleaner.sh 
	Found Redis processes, killing them...
	Killing process with PID: 240
	Killing process with PID: 253
	Killing process with PID: 255
	Killing process with PID: 336
	Killing process with PID: 400
	Killing process with PID: 431
	Killing process with PID: 451
	Killing process with PID: 570
	Killing process with PID: 573
	Killing process with PID: 576
	Killing process with PID: 577
	Killing process with PID: 622
	Killing process with PID: 625
	Killing process with PID: 628
	Killing process with PID: 674
	Killing process with PID: 677
	Killing process with PID: 680
	Killing process with PID: 704
	Killing process with PID: 707
	Killing process with PID: 710
	Killing process with PID: 795
	Killing process with PID: 798
	Killing process with PID: 801
	Killing process with PID: 823
	Killing process with PID: 826
	Killing process with PID: 829
	Killing process with PID: 854
	Killing process with PID: 857
	Killing process with PID: 860
	Killing process with PID: 861
	Killing process with PID: 885
	Killing process with PID: 888
	Killing process with PID: 891
	Killing process with PID: 892
	Killing process with PID: 911
	Killing process with PID: 914
	Killing process with PID: 917
	Killing process with PID: 918
	Killing process with PID: 955
	Killing process with PID: 958
	Killing process with PID: 961
	Killing process with PID: 993
	Killing process with PID: 996
	Killing process with PID: 999
	Killing process with PID: 1030
	Killing process with PID: 1033
	Killing process with PID: 1036
	Killing process with PID: 1073
	Killed
	```
# HW 3 Multi-model YDB

В этом файле будет описан процесс запуска базы данных в `docker` с демонстрацией различных запросов как к импортированным, 
так и к созданным данным. Ответы на все остальные вопросы, указанные в ~~ТЗ~~ ДЗ, находятся в презентации в папке `slides`.



- **Установка YDB**. По традиции для установки `YDB` я выбрал `docker`. В этот раз повезло! Прямо на [сайте](https://ydb.tech/) 
    в самом его низу есть `bash` код для загрузки образа и запуска контейнера. Я был бы не я, если бы не вставил свои пять копеек в этот код! 
    Мне очень понравилась папка `mongodata/`, поэтому маунтить будем именно её. Получилось вот так:
	```bash
    sudo docker pull cr.yandex/yc/yandex-docker-local-ydb:latest
	sudo docker run -d --rm --name ydb-local -h localhost \
    --platform linux/amd64 \
    -p 2135:2135 -p 2136:2136 -p 8765:8765 \
    -v /mongodata/ydb_certs:/ydb_certs -v /mongodata:/ydb_data \
    -e GRPC_TLS_PORT=2135 -e GRPC_PORT=2136 -e MON_PORT=8765 \
    -e YDB_USE_IN_MEMORY_PDISKS=true \
    cr.yandex/yc/yandex-docker-local-ydb:latest
	```
	Как обычно (Вам вообще интересно это читать? Я довольно много времени на это трачу. Совру, если 
    скажу, что это не приносит мне удовольствия, однако. Может быть я графоман? Зачем мне вообще тогда этот МФТИ? Базы данных, файлики... ой) положим в `/mongodata/` на машине-хозяине данные и чудесным образом они появятся у нас на сервере (контейнере)! 
    
    Новая домашка -- новые данные! Нашел такой вот небольшой [`csv`-файл](https://www.stats.govt.nz/assets/Uploads/Business-financial-data/Business-financial-data-December-2023-quarter/Download-data/business-financial-data-december-2023-quarter.zip) попробуем загрузить его в `ydb`. Файл назовем просто: 
	`data.csv`. 
    C каждой домашкой я стараюсь всё меньше использовать `GUI` и все больше интегрировать `CLI`, 
    однако в этом домашнем задании для полноты картины и поддержки общей драматургии повествования 
    `GUI` будет, ведь цель `ydb` -- предоставить 
    максимально удобную базу данных для всех, кому это нужно: для использования в бизнесе и т.д., 
    поэтому разработчики не то что "настоятельно рекомендуют `GUI`", так и вообще демонстрирует это 
    как `killer feature` (возможность построить огромное количество различных информативных графиков).
    Далее (начиная с `CRUD`) обязательно будем работать только в `cli`. Но, чтобы читатель не потерял интереса, сейчас сочиню что-нибудь прикольное в `bash`. 
    Так скачаем же файл не по-крестьянски, а как толковые и образованные люди:
    ```bash
    URL=https://www.stats.govt.nz/assets/Uploads/Business-financial-data/Business-financial-data-December-2023-quarter/Download-data/business-financial-data-december-2023-quarter.zip
    cd /mongodata/ && sudo curl --silent -o ds.zip $URL && sudo unzip -qq ds.zip -d $(pwd)/tmp && sudo rm ds.zip && sudo mv $(pwd)/tmp/* $(pwd)/data.csv && sudo rm -rf $(pwd)/tmp
    ```
    Круто, да? Не очень на самом-то деле. Эти данные нужно обработать: первая строка -- названия колонок, они 
    будут нам только мешать нужно их удалить. Так же было бы здорово пронумеровать строки. Всё это можно сделать с помощью моего `prepare_data.sh` скрипта в папке `/experiments/ydb/`. Его нужно сделать исполняемым `chmod +x /experiments/ydb/prepare_data.sh`, a затем запустить через `sudo`. Теперь наша
    даточка выглядит сногсшибательно:
    ```bash
    head -n 3 indexed_data.csv 
    1,BDCQ.SF1AA2CA,2016.06,1116.386,,F,Dollars,6,Business Data Collection - BDC,Industry by financial variable (NZSIOC Level 2),Sales (operating income),Forestry and Logging,Current prices,Unadjusted,
    2,BDCQ.SF1AA2CA,2016.09,1070.874,,F,Dollars,6,Business Data Collection - BDC,Industry by financial variable (NZSIOC Level 2),Sales (operating income),Forestry and Logging,Current prices,Unadjusted,
    3,BDCQ.SF1AA2CA,2016.12,1054.408,,F,Dollars,6,Business Data Collection - BDC,Industry by financial variable (NZSIOC Level 2),Sales (operating income),Forestry and Logging,Current prices,Unadjusted,
    ```
- **Чтение данных и запросы**.
    Будем использовать `GUI` прямо по инструкции из [QuickStart](https://ydb.tech/docs/en/quickstart), но, чтобы не расслабляться, я буду подгружать данные именно файлом и именно через `cli`! 
    Для начала подключимся к `GUI`, для этого откроем браузер и в `url`-строкe напишем `http://localhost:8765` (один из этих портов мы и пробрасывали, когда запускали `docker`-контейнер). Перед нами откроется прекрасно свёрстанная `web`-страница на вкладке `Databases`. Прямо перед собой читатель (Вы же следуете моим шагам верно?) увидит в списке одно единственное вхождение -- `/local`. Жмем на него и попадаем в нашу базу данных. Тут нет ничего... Надо добавить! Создадим таблицу под те данные, которые 
    мы успели скачать и обработать:
    ```SQL
    CREATE TABLE data (
        _id Uint64,
        _Series_reference String,
        _Period String,
        _Data_value Float,
        _Suppressed String,
        _STATUS String,
        _UNITS String,
        _Magnitude Uint64,
        _Subject String,
        _Group String,
        _Series_title_1 String,
        _Series_title_2 String,
        _Series_title_3 String,
        _Series_title_4 String,
        _Series_title_5 String,
        PRIMARY KEY (_id)
    )
    ```
    Названия колонок не обязательно начинать с `_`, мне просто так удобнее... Проверим, что таблица создалась
    (если мы не верим зеленой галочке внизу):
    ```SQL
    SELECT * from data
    ```
    В ответ получаем названия наших колоночек в первой строчке, а затем многозначительная надпись `No data`.
    Пополним.

    Знаю вы тоже этого хотели; запрыгиваем в `docker`-контейнер командой:
    ```bash
    sudo docker exec -it ydb-local bash
    ```
    Ребята из Яндекса не умеют добавлять строки в `$PATH`, поэтому `ydb` откликается строго в корневой директории 
    и строго через `execute`:
    ```bash
    ./ydb -e grpc://localhost:2136 -d /local import file csv -p data /ydb_data/indexed_data.csv
    ```
    В ответ получаем:
    ```bash
    Elapsed: 0.02853 sec
    ```

    Возвращаемся в `GUI` и дрожащими руками пишем:
    ```SQL
    SELECT * from data
    ```
    И..... О БОЖЕ! Там где должны находиться строки находятся..... всякие глупости....
    
    Диагноз: кодировка, нужно создавать таблицу заново, все типы `String` заменим на тип `Utf8`. Но 
    сначала нужно удалить таблицу:
    ```SQL
    DROP TABLE data
    ```

    Проделав всё заново, наконец-то получаем положительный результат. Ура! Мы загрузили в базу данных
    свои первые данные. Время для `CRUD`!

    - `CREATE`
        В качестве `INSERT` здесь функция `UPSERT`, которая еще и `UPDATE` на самом деле. Добавим новое вхождение:
        ```bash
        ./ydb -e grpc://localhost:2136 -d /local table query execute \ 
          -q '
          UPSERT INTO data (_Data_value, _Group, _Magnitude, _Period, _STATUS, _Series_reference, _Series_title_1, _Series_title_2, _Series_title_3,_Series_title_4, _Series_title_5, _Subject, _Suppressed, _UNITS, _id) VALUES
          (1337, "ABCD",6,	"2024.04", "R",	"EFG", "HIJK", "MNOLP",	"QRST", "UVW",null,	"XYZ",null,	"RUBLES", 100500)
          '
        ```
        В ответ только тишина. Проверим:
        ```bash
        ./ydb -e grpc://localhost:2136 -d /local table query execute \ 
        -q '
        SELECT * FROM data WHERE _id = 100500;
        '
        ```
        ```bash
        ┌─────────────┬────────┬────────────┬───────────┬─────────┬───────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬──────────┬─────────────┬──────────┬────────┐
        │ _Data_value │ _Group │ _Magnitude │ _Period   │ _STATUS │ _Series_reference │ _Series_title_1 │ _Series_title_2 │ _Series_title_3 │ _Series_title_4 │ _Series_title_5 │ _Subject │ _Suppressed │ _UNITS   │ _id    │
        ├─────────────┼────────┼────────────┼───────────┼─────────┼───────────────────┼─────────────────┼─────────────────┼─────────────────┼─────────────────┼─────────────────┼──────────┼─────────────┼──────────┼────────┤
        │ 1337        │ "ABCD" │ 6          │ "2024.04" │ "R"     │ "EFG"             │ "HIJK"          │ "MNOLP"         │ "QRST"          │ "UVW"           │ null            │ "XYZ"    │ null        │ "RUBLES" │ 100500 │
        └─────────────┴────────┴────────────┴───────────┴─────────┴───────────────────┴─────────────────┴─────────────────┴─────────────────┴─────────────────┴─────────────────┴──────────┴─────────────┴──────────┴────────┘
        ```
    - `READ`
        
        Как и было обещано перемещаемся в `cli` с головой. Посчитаем те вхождения, `_STATUS` которых равен 
        `"F"` (от англ. *Failed*):
        ```bash
        root@localhost:/# ./ydb -e grpc://localhost:2136 -d /local table query execute \ 
        -q '
        SELECT COUNT(_id) FROM data WHERE _STATUS = "F";
        '
        ┌─────────┐
        │ column0 │
        ├─────────┤
        │ 4935    │
        └─────────┘
        ```
        Красота! Всего вхождений:
        ```bash
        root@localhost:/# ./ydb -e grpc://localhost:2136 -d /local table query execute \ 
        -q '
        SELECT COUNT(_id) FROM data;
        '
        ┌─────────┐
        │ column0 │
        ├─────────┤
        │ 7395    │
        └─────────┘
        ```
    - `UPDATE`
        Исправим вхождение, которое добавили в самом начале:
        ```bash
        ./ydb -e grpc://localhost:2136 -d /local table query execute \ 
        -q '
        UPDATE data SET _Data_value = 42 WHERE _id = 100500;
        '
        ```
        В ответ снова тишина. Проверим:
        ```bash
        ./ydb -e grpc://localhost:2136 -d /local table query execute \ 
        -q '
        SELECT * FROM data WHERE _id = 100500;
        '
        ```
        ```bash
        ┌─────────────┬────────┬────────────┬───────────┬─────────┬───────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬──────────┬─────────────┬──────────┬────────┐
        │ _Data_value │ _Group │ _Magnitude │ _Period   │ _STATUS │ _Series_reference │ _Series_title_1 │ _Series_title_2 │ _Series_title_3 │ _Series_title_4 │ _Series_title_5 │ _Subject │ _Suppressed │ _UNITS   │ _id    │
        ├─────────────┼────────┼────────────┼───────────┼─────────┼───────────────────┼─────────────────┼─────────────────┼─────────────────┼─────────────────┼─────────────────┼──────────┼─────────────┼──────────┼────────┤
        │ 42          │ "ABCD" │ 6          │ "2024.04" │ "R"     │ "EFG"             │ "HIJK"          │ "MNOLP"         │ "QRST"          │ "UVW"           │ null            │ "XYZ"    │ null        │ "RUBLES" │ 100500 │
        └─────────────┴────────┴────────────┴───────────┴─────────┴───────────────────┴─────────────────┴─────────────────┴─────────────────┴─────────────────┴─────────────────┴──────────┴─────────────┴──────────┴────────┘
        ```
    - `DELETE`
        Удалим вхождение, которое добавили в самом начале:
        ```bash
        ./ydb -e grpc://localhost:2136 -d /local table query execute \ 
        -q '
        DELETE FROM data WHERE _id = 100500;
        '
        ```
        Проверим
        ```bash
        ./ydb -e grpc://localhost:2136 -d /local table query execute \ 
        -q '
        SELECT * FROM data WHERE _id = 100500;
        '
        ```
        ```bash
        ┌─────────────┬────────┬────────────┬───────────┬─────────┬───────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬─────────────────┬──────────┬─────────────┬──────────┬────────┐
        │ _Data_value │ _Group │ _Magnitude │ _Period   │ _STATUS │ _Series_reference │ _Series_title_1 │ _Series_title_2 │ _Series_title_3 │ _Series_title_4 │ _Series_title_5 │ _Subject │ _Suppressed │ _UNITS   │ _id    │
        ├─────────────┼────────┼────────────┼───────────┼─────────┼───────────────────┼─────────────────┼─────────────────┼─────────────────┼─────────────────┼─────────────────┼──────────┼─────────────┼──────────┼────────┤
        └─────────────┴────────┴────────────┴───────────┴─────────┴───────────────────┴─────────────────┴─────────────────┴─────────────────┴─────────────────┴─────────────────┴──────────┴─────────────┴──────────┴────────┘
        ```
    - `INDEX`
        Сформируем индекс из значений колонки `_Magnitude`, для этого в `cli` есть отдельная команда:
        ```bash
        root@localhost:/# ./ydb -e grpc://localhost:2136 -d /local table index add global-sync data --index-name MyIndex --columns  _Magnitude 
        ┌───────────────────────────────────────┬───────┬────────┐
        │ id                                    │ ready │ status │
        ├───────────────────────────────────────┼───────┼────────┤
        │ ydb://buildindex/7?id=281474976727596 │ false │        │
        └───────────────────────────────────────┴───────┴────────┘

        ```
        Создание занимает некоторое время, поэтому колонка `ready` имеет значение `false`. Проверим спустя некоторое время:
        ```bash
        root@localhost:/# ./ydb -e grpc://localhost:2136 -d /local  operation get ydb://buildindex/7?id=281474976727596
        ┌───────────────────────────────────────┬───────┬─────────┬───────┬──────────┬─────────────┬─────────┐
        │ id                                    │ ready │ status  │ state │ progress │ table       │ index   │
        ├───────────────────────────────────────┼───────┼─────────┼───────┼──────────┼─────────────┼─────────┤
        │ ydb://buildindex/7?id=281474976727596 │ true  │ SUCCESS │ Done  │ 100.00%  │ /local/data │ MyIndex │
        └───────────────────────────────────────┴───────┴─────────┴───────┴──────────┴─────────────┴─────────┘
        ```
        Создался! Ну и хорошо! Удаляем:
        ```bash
        root@localhost:/# ./ydb -e grpc://localhost:2136 -d /local table index drop data --index-name MyIndex
        ```
    
    На этом всё, спасибо, что дочитали! <3

