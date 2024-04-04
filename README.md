# MiptDBHW

## HW 0

- ScyllaDB и ArenadataDB обычно относят к категории AP (доступность и устойчивость к разделению)
- DragonFly является распределенной СУБД, направленной на обеспечение согласованности и доступности, поэтому его можно отнести к категории CP (согласованность и устойчивость к разделению).

## HW 1

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
    all_customers> db.MallCustomers.find({ "Age": { "$gt": 25 } }).explain('executionStats')
    {
    explainVersion: '1',
    queryPlanner: {
        namespace: 'Mall_customers.MallCustomers',
        indexFilterSet: false,
        parsedQuery: { Age: { '$gt': 25 } },
        queryHash: '7D528C65',
        planCacheKey: '7D528C65',
        maxIndexedOrSolutionsReached: false,
        maxIndexedAndSolutionsReached: false,
        maxScansToExplodeReached: false,
        winningPlan: {
        stage: 'COLLSCAN',
        filter: { Age: { '$gt': 25 } },
        direction: 'forward'
        },
        rejectedPlans: []
    },
    executionStats: {
        executionSuccess: true,
        nReturned: 162,
        executionTimeMillis: 0,
        totalKeysExamined: 0,
        totalDocsExamined: 200,
        executionStages: {
        stage: 'COLLSCAN',
        filter: { Age: { '$gt': 25 } },
        nReturned: 162,
        executionTimeMillisEstimate: 0,
        works: 201,
        advanced: 162,
        needTime: 38,
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
        filter: { Age: { '$gt': 25 } },
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
    Mall_customers> db.MallCustomers.createIndex({"Age": 1})
    Age_1
    Mall_customers> db.MallCustomers.find({ "Age": { "$gt": 25 } }).explain('executionStats')
    {
    explainVersion: '1',
    queryPlanner: {
        namespace: 'Mall_customers.MallCustomers',
        indexFilterSet: false,
        parsedQuery: { Age: { '$gt': 25 } },
        queryHash: '7D528C65',
        planCacheKey: '2DDA8D6F',
        maxIndexedOrSolutionsReached: false,
        maxIndexedAndSolutionsReached: false,
        maxScansToExplodeReached: false,
        winningPlan: {
        stage: 'FETCH',
        inputStage: {
            stage: 'IXSCAN',
            keyPattern: { Age: 1 },
            indexName: 'Age_1',
            isMultiKey: false,
            multiKeyPaths: { Age: [] },
            isUnique: false,
            isSparse: false,
            isPartial: false,
            indexVersion: 2,
            direction: 'forward',
            indexBounds: { Age: [ '(25, inf.0]' ] }
        }
        },
        rejectedPlans: []
    },
    executionStats: {
        executionSuccess: true,
        nReturned: 162,
        executionTimeMillis: 0,
        totalKeysExamined: 162,
        totalDocsExamined: 162,
        executionStages: {
        stage: 'FETCH',
        nReturned: 162,
        executionTimeMillisEstimate: 0,
        works: 163,
        advanced: 162,
        needTime: 0,
        needYield: 0,
        saveState: 0,
        restoreState: 0,
        isEOF: 1,
        docsExamined: 162,
        alreadyHasObj: 0,
        inputStage: {
            stage: 'IXSCAN',
            nReturned: 162,
            executionTimeMillisEstimate: 0,
            works: 163,
            advanced: 162,
            needTime: 0,
            needYield: 0,
            saveState: 0,
            restoreState: 0,
            isEOF: 1,
            keyPattern: { Age: 1 },
            indexName: 'Age_1',
            isMultiKey: false,
            multiKeyPaths: { Age: [] },
            isUnique: false,
            isSparse: false,
            isPartial: false,
            indexVersion: 2,
            direction: 'forward',
            indexBounds: { Age: [ '(25, inf.0]' ] },
            keysExamined: 162,
            seeks: 1,
            dupsTested: 0,
            dupsDropped: 0
        }
        }
    },
    command: {
        find: 'MallCustomers',
        filter: { Age: { '$gt': 25 } },
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