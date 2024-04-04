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
    #TODO
    *Update*:
    #TODO
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
    #TODO