# MiptDBHW

## HW 0 (WA)

- ScyllaDB и ArenadataDB обычно относят к категории AP (доступность и устойчивость к разделению)
- DragonFly является распределенной СУБД, направленной на обеспечение согласованности и доступности, поэтому его можно отнести к категории CP (согласованность и устойчивость к разделению).

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
- **Первый эксперимент**. Запустив контейнер, перейдем в папку `/data/db/` и в ней запустим первый эксперимент, который батчами записывает 
	наш `.json` файл в `redis`, а потом читает. Каждый батч -- обыкновенная строка. Эксперимент запускается несколько раз.
	Запуск производится следующей командой:
	```bash
	python3 insert_strings.py
	```
	На что программа отвечает:
	```
	Mean of 10 experiments.
	Please stand by. Setting.
	Amount of "sets" per experiment = 36272, Mean "sets" elapsed time = 1.6883170127868652 sec.
	Please stand by. Reading.
	Amount of "gets" per experiment = 36272, Mean "gets" elapsed time = 1.7036869287490846 sec.
	```
	Запомним последнее из этих двух чисел.
