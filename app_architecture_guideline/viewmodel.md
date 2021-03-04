# ViewModel

The objective of ViewModel is providing and keeping data in a lifecycle for UI controllers such as activity and fragment via 
*LiveData*. It also provides to survive data when re-creation(rotations, screen splitting, etc).

When we’re developing a ViewModel, we try to keep it dummy as much as possible using with UseCase classes and we don’t prefer 
using a repository class directly in a ViewModel. Because, at repository layer, we have raw data and this data can not emitted 
UI controllers without converting to UI models. We prefer to give responsibility of the converting process to UseCase. 
ViewModel has only one responsibility during the data flow, to create ViewState wrapped by LiveData.

* ViewModel is mostly created for only one UI controllers such as activity or fragment, but some cases, *SharedViewModel* can 
be created to transfer data between more than one fragments.
* We create lots of LiveData to be observed by UI controllers in ViewModel. For example, one LiveData is created to keep 
states(Loading, Error, Success) of the data; the other one is observed to display any message to user, etc.
* LiveData observation is made in main thread at ViewModel.
* UI controllers have ViewModel’s reference, and ViewModel shouldn’t know anything about the view.

## LiveData
LiveData is a lifecycle-aware observable data holder class that can only observed by app’s components such as activity, 
fragment or services. In most cases, LiveData holds ViewState classes in the app, but in some cases, primitive types are also 
held by *SingleLiveEvent* that extended from MutableLiveData to display Snackbar, AlertDialog, etc. Any changes in LiveData’s 
values is updated in main thread during data flow to trigger observables in UI controller.

![ViewModel](https://github.com/Trendyol/android-guidelines/blob/master/app_architecture_guideline/diagrams/viewmodel.png)

```kotlin
class SampleViewModel @Inject constructor(
    private val fetchUseCase: FetchUseCase
) : BaseViewModel() {

    private val pageViewState = MutableLiveData<PageViewState>()

    fun getPageViewState(): LiveData<PageViewState> = pageViewState

    fun fetchData() {
        fetchUseCase
            .fetchData()
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe({ renderData(it) }, ThrowableReporter::report) // ThrowableReporter is a logger class 
            .also { disposable += it } // disposable is CompositeDisposible in BaseViewModel
                                       // += is extension that is created to add Disposable to CompositeDisposable
    }

    private fun renderData(viewState: PageViewState) {
        pageViewState.value = viewState
    }
}
```
