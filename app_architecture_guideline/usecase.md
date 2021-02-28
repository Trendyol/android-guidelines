# UseCase
Connection between ViewModel and Repository for data flow is made in UseCase. It’s responsible from business logic, and it 
decides data source, converts/prepares/manipulates remote/local models for UI layer as UI models.

* UseCase can have different and multiple UseCase classes and repositories to provide data that is ready.
* UseCase use *Mapper* to convert remote/local models to UI models.
* We try to create single responsible use case classes to develop more testable code like just fetching data from remote or 
just delete data from local, etc.

### Mapper
Remote or local models are not used directly at UI layer in the app and at this point, Mapper converts and manipulates models 
that are gotten from data sources. Mapper is a functional interface that converts a value based on one or more input values, 
besides this it doesn’t contain any logic. It has only one responsibility in our data flow.

### Decider
When we need to create data with condition or any fields provided from different sources in the mapper, we create a new class 
which we named Decider. Our motivation is that we move any logic to different classes and take out from encapsulation to 
create testable codes.

![UseCase Diagram](https://github.com/Trendyol/android-guidelines/blob/master/app_architecture_guideline/diagrams/use-case.png)

```kotlin
// Simple UseCase Implementation
class UseCase @Inject constructor(
    private val repository: Repository,
    private val mapper: Mapper
) {

    fun fetchData(): Observable<Resource<Data>> =
        repository
            .fetchData()
            .mapOnData { // mapOnData is an extension function to wrap data with Resource
                mapper.mapFromResponse(it) 
            }

    fun saveData(data: Data): Completable = repository.saveData(data)
}

// Simple Mapper Implementation
class ModelMapper @Inject constructor(
    private val decider: Decider
) : Mapper<ResponseModel?, UIModel> {

    override fun mapFromResponse(type: ResponseModel?): UIModel =
        UIModel(
            id = type?.id.orZero(),
            name = type?.name.orEmpty(),
            color = decider.provideColor(type?.status)
        )
}

// Simple Decider Implementation
class Decider @Inject constructor() {
    fun provideColor(status: String?) : Int =
        when(status) {
            "SOLD_OUT" -> Color.GRAY
            "AVAILABLE" -> Color.GREEN
            "ALMOST_SOLD_OUT" -> Color.RED
            else -> Color.BLACK
        }
}
```
