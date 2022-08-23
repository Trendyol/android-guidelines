
## ViewModel's LiveData & ViewState Naming Conventions

#### 

>*Every listing Fragment must have* ***pageViewState*** *and* ***statusViewState***

| Attribute Name | Included Class     | Description                |
| :-------- | :------- | :------------------------- |
| `pageViewStateLiveData` | `ProductDetailPageViewState` | for __main__ recyclerView listing in a fragment |
| `sliderPageViewStateLiveData` | `ProductDetailSliderPageViewState` | for __sublisting__ in a fragment |
| `statusViewStateLiveData` | `ProductDetailStatusViewState` | for __main__ state management in a fragment |
| `sliderStatusViewStateLiveData` | `ProductDetailSliderViewState` | for __sub__ state management in a fragment|
| `isFavoriteLiveData` | `Boolean` | add __LiveData__ to the end of the naming of the primitive type |


> *Every Action Event must have a keyword to start of the event's name like;* ***navigate, send, show, close, start***

> *SingleLiveEvent can be used for ***passing a parameter*** from viewModel to Fragment with an action.*

> *ActionEvent can be used for ***passing a triggered event*** from viewmodel to fragment.*

| Attribute Name | Included Class     | Description                |
| :-------- | :------- | :------------------------- |
| `successLiveEvent` | `SingleLiveEvent` | add __LiveEvent__ to the end of the naming of the SingleLiveEvent attribute. |
| `navigateOtherMerchantsActionEvent` | `ActionEvent` | add __ActionEvent__ to the end, and __navigate__ at the beginning of the naming of the ActionEvent attribute. __navigate__ keyword can be used for navigating to a fragment.|
| `sendAddFavoriteClickEvent`| `ActionEvent` | add __"ActionEvent"__ to the end, and __"send"__ at the beginning of the naming of the ActionEvent attribute. __send__ keyword can be used for sending an analytic event or firebase event etc. |
| `showHeaderOnBoardingActionEvent`| `ActionEvent` | add __ActionEvent__ to the end, and __show__ at to beginning of the naming of the ActionEvent attribute. __show__ keyword can be used for showing a dialog or onBoarding on the screen. |
| `closePopupActionEvent`| `ActionEvent` | add __ActionEvent__ to the end, and __close__ at to beginning of the naming of the ActionEvent attribute. __close__ keyword can be used for closing a dialog or onBoarding on the screen.|
| `startAuthenticationActionEvent`| `ActionEvent` | add __ActionEvent__ to the end, and __start__ at to beginning of the naming of the ActionEvent attribute. __start__ keyword can be used for starting a flow like authentication flow. |

  