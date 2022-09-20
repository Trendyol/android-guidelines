
## ViewModel's LiveData, StateFlow, Event, Channel & ViewState Naming Conventions

#### 
>*__We should abide by these generic naming conventions to make our job easier when migrating LiveData to StateFlow in the future.__*

>*Every liveData, stateFlow ActionEvent.. etc. must have a public and a prive field as below. They should be placed top to bottom like this;*

    private val _statusViewState = MutableStateFlow(MealFilterStatusViewState())
    val statusViewState = _statusViewState.asStateFlow()

    private val _pageViewState = MutableLiveData<JustForYouPageViewState>()
    val pageViewState : LiveData<JustForYouPageViewState> = _pageViewState

    private val _showCities = SingleLiveEvent<InternationalCitySelectionArguments>() 
    val showCities: LiveData<InternationalCitySelectionArguments> = _showCities

>*Every listing Fragment must have* ***pageViewState*** *and* ***statusViewState***

| Type | Private Attribute Name | Private Included Class | Public Attribute Name | Public Included Class    | Description                |
| :-------- | :-------- | :------- | :------------------------- | :------------------------- | :-------------------------|
| `ProductDetailPageViewState` | `_pageViewState`| `MutableLiveData<T> / MutableStateFlow<T> / MutableSharedFlow<T>`| `pageViewState` | `LiveData<ProductDetailPageViewState> / StateFlow<T> / SharedFlow<T>`  | for __main__ recyclerView listing in a fragment |
| `ProductDetailSliderPageViewState` | `_sliderPageViewState` | `MutableLiveData<T> / MutableStateFlow<T> / MutableSharedFlow<T>`| `sliderPageViewState`| `LiveData<ProductDetailSliderPageViewState> / StateFlow<T> / SharedFlow<T>` |  for __sublisting__ in a fragment |
| `ProductDetailStatusViewState` | `_statusViewState` | `MutableLiveData<T> / MutableStateFlow<T> / MutableSharedFlow<T>` | `statusViewState`| `LiveData<ProductDetailStatusViewState> / StateFlow<T> / SharedFlow<T>`  | for __main__ state management in a fragment |
| `ProductDetailSliderViewState` | `_sliderStatusViewState` | `MutableLiveData<T> / MutableStateFlow<T> / MutableSharedFlow<T>` | `sliderStatusViewState`| `LiveData<ProductDetailSliderViewState> / StateFlow<T> / SharedFlow<T>` | for __sub__ state management in a fragment|
| `Boolean` | `_isFavorite` | `MutableLiveData<T> / MutableStateFlow<T> / MutableSharedFlow<T>` | `isFavorite`| `LiveData<Boolean> / StateFlow<T> / SharedFlow<T>`  | primitive type's responsibility should described by naming  |


> *Every Action Event, Channel etc. must have a keyword to start of the event's name like;* ***navigate, send, show, close, start***

> *SingleLiveEvent can be used for ***passing a parameter*** from viewModel to Fragment with an action.*

> *ActionEvent can be used for ***passing a triggered event*** from viewmodel to fragment.*

| Private Attribute Name | Public Attribute Name| Included Class|Description|
| :-------- | :------- | :------------------------- | :------------------------- |
| `_showVariantsDialog` | `showVariantsDialog` | `SingleLiveEvent<T>/Channel<T>` | __show__ keyword can be used for showing popup, dialog etc. on UI to user. |
| `_navigateOtherMerchants` | `navigateOtherMerchants` | `ActionEvent/ActionChannel` | __navigate__ keyword can be used for navigating to a fragment.|
| `_sendAddFavoriteClick`| `sendAddFavoriteClick` | `ActionEvent/ActionChannel` | __send__ keyword can be used for sending an analytic event or firebase event etc. |
| `_showHeaderOnBoarding`| `showHeaderOnBoarding` | `ActionEvent/ActionChannel` | __show__ keyword can be used for showing a dialog or onBoarding on the screen. |
| `_closePopup`| `closePopup`| `ActionEvent` | __close__ keyword can be used for closing a dialog or onBoarding on the screen.|
| `_startAuthentication`| `startAuthentication`| `ActionEvent/ActionChannel` | __start__ keyword can be used for starting a flow like authentication flow. |
| `_addressAdditionEvent`| `addressAdditionEvent`| `ActionEvent/ActionChannel` | add __event__ at to end of the naming of the ActionEvent attribute when the attribute in created inside of __SharedViewModel__ |

  