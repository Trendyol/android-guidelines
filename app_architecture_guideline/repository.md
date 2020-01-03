# Repository
Repository is an abstraction of data flow in the app and this layer is responsible to provide/update related data for 
ViewModel with remote/local data sources. When we are implementing a new repository component for the app, we name and 
allocate it in a package considering related domain and API endpoint. Because we have a Domain Specific Language(DSL) in 
our company and Domain Driven Design(DDD) is important for us.


Almost all repositories in the app have remote and local data sources with its needs. At this layer, we also manage threading 
with RxJava2 and wrap provided data with a model named Resource that holds status of the flow as Success, Loading and Error. 
For example, when we call remote API:

* thread is changed to IO thread from main thread to prevent blocking UI
* remote data source is called
* when response is provided, data is wrapped

![Repository](https://github.com/Trendyol/android-guidelines/blob/feature/app_arch/app_architecture_guideline/diagrams/repository.png)

```kotlin
class Repository @Inject constructor(
    private val local: DataSource.Local, 
    private val remote: DataSource.Remote
) {

    override fun getLocalData(): Observable<Entity> =
        local
            .getEntity()
            .subscribeOn(Schedulers.io()) // changing thread
    

    override fun fetchList(id: Long): Observable<Resource<Response>> =
        remote
            .fetchList(id)
            .remote() // extension function to change thread and to wrap response
}
```


## Remote Data Source
This is the part where we communicate with REST API, so that the data source is used to fetch data remotely. When retrieving 
the data, we use type-safe HTTP client *Retrofit*.

To start data flow from web server, related parameters as ready to come from repository and request model creation isn’t made 
in here and then HTTP request is made with Retrofit. At this moment, RxJava2 comes to scene again for providing data flow and 
Retrofit returns data as Single or Completable. If the response isn’t important for the flow, return type of API service’s 
method is Completable, otherwise it is Single. After the successful response which is Single, the data is converted into an 
Observable in Remote Data Source to continue data flow.

![Remote Data Source](https://github.com/Trendyol/android-guidelines/blob/feature/app_arch/app_architecture_guideline/diagrams/remote-data-source.png)

```kotlin
class RemoteDataSource @Inject constructor(
    private val remoteService: RemoteService
) : DataSource.Remote {

    override fun fetchList(id: Long): Observable<ListResponseModel> =
        remoteService
            .list(id) // returns Single
            .toObservable() // convert in an Observable

    override fun fetchSearch(requestModel: SearchRequestModel): Observable<SearchResponseModel> =
        remoteService
            .search(requestModel) // returns Single
            .toObservable() // convert in an Observable
  

    override fun removeItem(id: Long): Completable =
        remoteService
            .remove(id)
}
```

## Local Data Source
At local data source, we’re using data storage with *Room* persistence library that is part of Android Architecture Components
(AAC), and *SharedPreferences API*. Besides these, the data source is also used for caching data in memory. We decide the type 
of implementation related to our use cases. All data can be converted to Observable according to data flow.

* While using **Room**, *Data Access Object(DAO)* provided from Room Database is used to persist changes and get Entities. At next 
step, related Entities start to hold data as wrapped with Observable or not in local data source.
* With **SharedPreferences API**, key-value datas are saved to private file in the system. SharedPreferences isn’t used to store 
only key-value data, it can also used to store any object as JSON string. When this type of storage is selected, to create 
object from JSON representation or convert the object to JSON, Gson is used.
* In some use cases like info texts, data is provided remotely at first and then, it is cached in **memory** as any types of data 
structure.

![Local Data Source](https://github.com/Trendyol/android-guidelines/blob/feature/app_arch/app_architecture_guideline/diagrams/local-data-source.png)

```kotlin
// Local Data source with Room
class RoomLocalDataSource @Inject constructor(
    private val dao: Dao
) : DataSource.Local {

    override fun getEntity(id: Int): Entity =
        dao.getEntity(id)

    override fun saveEntity(data: AnyData) {
        dao.clear()
        dao.insertEntity(AppVersionEntity(data.field1, data.filed2))
    }
}

// Local Data source with SharedPreferences
class SharedPreferencesLocalDataSource @Inject constructor(
    private val sharedPreferences: SharedPreferences
) : DataSource.Local {
    private val KEY = "sp_key"
  
    override fun getData(): String = sharedPreferences.getString(KEY, "")

    override fun saveData(sval: String) {
        sharedPreferences
            .edit()
            .putString(KEY, sval)
            .apply()
    }
}

// Local Data source with Memory Caching
class MemoryLocalDataSource @Inject constructor() : DataSource.Local {
    private val map: HashMap<Long, String> = HashMap()
    
    override fun getItem(id: Long): String = map[id]

    override fun saveMap(data: List<AnyData>) {
        data.forEach { map[it.id] = it.name }
    }
}
```
