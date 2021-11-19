# Unit Test Guideline

### Naming
Unit Test method naming convention should be as follow with enclosed backticks:  `given<Preconditions>, When<MethodIsExecuted>, Then<ShouldReturnExpectedResult>`

```kotlin
fun `Given visibility GONE as parameter, When checkQuickSellTabItem method called, 
Then dolapliteActivityViewStateLiveData update with false`
```

`Given visibility GONE as parameter, When checkQuickSellTabItem method called, Then dolapliteActivityViewStateLiveData update with false`

Every test method should start with `@Test` Annotation

The test method names should not contain the following characters `.:/\[]<>`

Unit Test method names have character limitations. If the name of the test method is written too long, an error may be received as follows: `error while writing …..$1.class (Permission denied...)`

### Unit Test Scenario: Given - When - Then 

Code blocks within the test method should be split with `Given-When-Then` comments to make it more readable and understandable.

Every code block written to satisfy the preconditions is written under the given comment. (every block, creating test observers, building expected response/result model, etc.)

The method to be tested is called under the `When` comment. 

All lines of code related to the validation phase must be placed under the `Then` comment. ( assertThat, verify blocks, etc.)

```kotlin
@Test
fun `Given visibility GONE as parameter, When checkQuickSellTabItem method called, Then dolapliteActivityViewStateLiveData update with false`() {
    //Given
    val visibility = View.GONE
    val observer = dolapLiteViewModel.getDolapliteActivityViewStateLiveData().test()
    val expectedViewState = DolapliteActivityViewState(displayQuickSell = false, needInflateMenu = false)

    //When
    dolapLiteViewModel.checkQuickSellTabItem(visibility)

    //Then
    Truth.assertThat(observer.getValues().last()).isEqualTo(expectedViewState)
}
```

### Test Extension
Test extension is used for capturing the changes in live data.

It creates a test observer using spyk. 

If there is a change in the live data, it will be added to the test observer’s values list. 

Live data changes can then be verified with the values in this list.

Since the values list holds the values of the captured live data, the first or last state of these captured values can be verified by looking at their respective elements such as first, last, or any specific item.

In the project, live data changes can be captured by observers created by using spyk in some old test methods. The test extension does the same thing. This extension should be used in test methods as it simplifies the code and has a more understandable structure.

```kotlin
val viewStateObserver = addressDetailViewModel.getViewState().test()
addressDetailViewModel.setAddress(address, true)

// Then
assertThat(viewStateObserver.getValues().last()).isEqualTo(expectedResult)
```

### Context Usage In Unit Tests And Robolectric

Some view state test methods require context usage.

getApplicationContext method is used to access context for the application under test.

```kotlin
@RunWith(AndroidJUnit4::class)
class WalletCardListNewCardViewStateTest {

    private val context: Context = ApplicationProvider.getApplicationContext()
```

AndroidJunit runner should be specified to use ApplicationProvider.getContext(). Otherwise, the following error will occur. 

:no_entry_sign: <span style="color:red">java.lang.IllegalStateException: No instrumentation registered! Must run under a registering instrumentation.</span>

Also, to prevent the error received below;  Robolectric should be implemented as TestDependencies and the following plugin should be applied to build.gradle file

```kotlin
plugins {  
    id("base.android-conventions")  
}
```
:no_entry_sign:  Resource ID #0x7f0600eb
android.content.res.Resources$NotFoundException: Resource ID #0x7f0600eb
	at org.robolectric.shadows.ShadowLegacyAssetManager.getResName(ShadowLegacyAssetManager.java:1283)
	at org.robolectric.shadows.ShadowLegacyAssetManager.resolveResourceValue(ShadowLegacyAssetManager.java:1066)
	at org.robolectric.shadows.ShadowLegacyAssetManager.resolve(ShadowLegacyAssetManager.java:1026)
	at org.robolectric.shadows.ShadowLegacyAssetManager.getAndResolve(ShadowLegacyAssetManager.java:1020)
	at org.robolectric.shadows.ShadowLegacyAssetManager.getResourceValue(ShadowLegacyAssetManager.java:319)

### Verify Drawable Files With Constant State

In some cases, different drawable files could be returned from methods of the ViewState classes. In these cases, it should be verified whether the conditionally returning drawable file is correct.

To check if the returned drawable file satisfies the expected result; It is checked whether the constantState value of the returned and expected drawable file is equal.

```kotlin
@Test
fun `given isPriceBadgeFilterSelected is false, when getPriceBadgeBackground called, then should return expectedValue`() {
    // Given
    val isPriceBadgeFilterSelected = false
    val viewState = FavoriteSpecialFiltersViewState(
        isPriceBadgeFilterSelected = isPriceBadgeFilterSelected
    )

    // When
    val actualValue = viewState.getPriceBadgeBackground(context)?.constantState

    // Then
    val expectedValue = context.drawable(R.drawable.shape_favorite_oval_white_with_with_gray_border)?.constantState
    Truth.assertThat(actualValue).isEqualTo(expectedValue)
}
```

If the expected drawable file is tried to be verified without constantState value, the following error will occur.

:no_entry_sign: <span style="color:red"> expected:android.graphics.drawable.BitmapDrawable@1fead1b2 but was :android.graphics.drawable.BitmapDrawable@3823d69f
</span>

### Test Rules

There are three test rules used in the project. These are respectively;

`InstantTaskExecuterRule:` JUnit Test Rule that swaps the background executor used by the Architecture Components with a different one that executes each task synchronously. It is used for live data of architecture components used in ViewModel and useCase classes. 

```kotlin
@Rule
@JvmField
val instantExecutorRule = InstantTaskExecutorRule()
```

`RxSchedularTestRule:` Using for testing methods using RxJava.

```kotlin
  @Rule
    @JvmField
    var testSchedulerRule = RxSchedulerTestRule()
```
`TestCoroutineRule:` Using for testing methods using coroutine. To call suspend function testCoroutineRule.runBlockingTest is used. testCoroutineRule.testDispatcher is used for injected dispatcher. 

```kotlin
@get:Rule
    val testCoroutineRule = TestCoroutineRule()
```

```kotlin
@Test
    fun `given order response order list is empty and banner list is not, when mapFrom called, then it should return empty list`() = testCoroutineRule.runBlockingTest  {
        val bannerResponse = OrderBannerResponse(
            imageUrl = "",
            deeplink = ""
        )
        val emptyOrderListWithBannersResponse = OrdersResponse(
            orders = emptyList(),
            banners = null,
            pagination = null,
            orderBannersForInstantChannel = listOf(bannerResponse)
        )

        val actualOrderList = mapper.mapFrom(emptyOrderListWithBannersResponse)

        Truth.assertThat(actualOrderList.orderList).isEmpty()
    }
```
### MockK
The purpose of mock classes is to isolate the ViewModel or useCase classes being tested. Therefore, each class used in the constructors of the ViewModel or useCase classes should be mocked, as seen in the following example.

```kotlin
class InstantDeliveryOnboardingUseCase @Inject constructor(
    private val repository: InstantDeliveryOnboardingRepository,
    private val configurationUseCase: ConfigurationUseCase
) : IOnboardingUseCase {
```

```kotlin
class InstantDeliveryOnboardingUseCaseTest {

    @MockK
    private lateinit var repository: InstantDeliveryOnboardingRepository

    @MockK
    private lateinit var configurationUseCase: ConfigurationUseCase

    private lateinit var useCase: InstantDeliveryOnboardingUseCase

    @Before
    fun setUp() {
        MockKAnnotations.init(this)

        useCase = InstantDeliveryOnboardingUseCase(
            repository = repository,
            configurationUseCase = configurationUseCase
        )
    }
```

If mockK annotation is used in the test class, it should be initialized before use.

```kotlin
@Before
    fun setUp() {
        MockKAnnotations.init(this)
```
If a method of a mocked class is called in the test flow or test method, `every` block is used to specify what that method will return. Otherwise, a `no answer found` error will occur.

```kotlin
every { repository.isSupportMenuOnboardingShowed() } returns true
```

:no_entry_sign: <span style="color:red">io.mockk.MockKException: no answer found for:</span>

If a method returns a unit,  just Run can be used. 

```kotlin
every { updateConfigurationUseCase.updateConfigurationIfRequired(version, any(), any()) } just runs
```

If the parameters sent to the method called in every block are not the same as the parameter values of the method called in the flow, `no answers found` error may occur again.

:warning: Some methods in every block may have parameters with default values. In these cases, when the parameter in which the method is called and the default parameter value are not equal, `no answers found` error will be occurred due to a similar reason.

### Verify
Some cases need to be tested that scenario calls the correct method. In such cases, the `verify` block can be used. The `exactly` parameter can be used to verify that a method is called a certain number. In addition, the parameters `atLeast` or `atMost` can be used to verify the minimum or the maximum number of times the method is called.

Here, it has been verified that the `extractOtpCode` method is called exactly once with the `message` parameter.
```kotlin
verify(exactly = 1) { otpCodeExtractorUseCase.extractOtpCode(message) }
```
:warning: Like the `every` block, when checking the method called with `verify`, the test will fail if the parameters passed to the method do not match the parameter values of the method called in the scenario. Therefore, when checking whether the method is called with validation, attention should be paid to whether the parameter sent to the method is correct.

### Assertion

`Truth` library is used to perform assertions in test methods. With the `assertThat` method, it can be compared whether the returned value of the tested method is the same as the expected value. 
```kotlin
Truth.assertThat(expectedValue).isEqualTo(actualValue)
```
If the compared values are not an instance from a data class, then assertion can be failed. This problem can be solved by converting the class to a data class or by asserting the properties of these instances.

### Parameterized Tests
Parameterized test class can be created when testing a method with all possible inputs.  `@RunWith(ParameterizedRobolectricTestRunner::class)` annotation can be used to create a parameterized test class.

As in the following example, Parameters annotation is used for method (provideParameters) to provide parameters to be injected into the test class constructor by Parameterized.

The test method is created according to these parameters. When the test method is run, it will run consecutively for each set of parameters provided and there will be no need to create a separate test method for each scenario.

```kotlin
@RunWith(ParameterizedRobolectricTestRunner::class)  
@Config(sdk = [28])  
class InstantDeliveryCartProductPriceComparisonDeciderTest constructor(  
    val marketPrice: Double?,  
 val salesPrice: Double?,  
 val expectedResult: Boolean  
){  
    @Test  
  fun `given marketPrice and salesPrice, when decideIsMarketPriceBiggerThanSalesPrice, then should return expectedResult`() {  
        //Given  
  val decider = InstantDeliveryCartProductPriceComparisonDecider()  
  
        //When  
  val actualResult = decider.decideIsMarketPriceBiggerThanSalesPrice(marketPrice, salesPrice)  
  
        //Then  
  Truth.assertThat(actualResult).isEqualTo(expectedResult)  
    }  
  
    companion object {  
        @JvmStatic  
 @ParameterizedRobolectricTestRunner.Parameters(name = "given marketPrice {0} and salesPrice {1} should satisfies expectedResult {2}")  
        fun provideParameters(): List<Array<out Any?>> {  
            return listOf(  
                arrayOf(null, null, false),  
  arrayOf(null, 1.2, false),  
  arrayOf(1.2, null, false),  
  arrayOf(2.1, 1.2, true),  
  arrayOf(1.2, 2.1, false),  
  arrayOf(1.2, 1.2, false)  
            )  
        }  
    }  
}
```
Adding the name parameter to the Parameters annotation provides an optional pattern to derive the test's name from the parameters. Numbers in braces are used to refer to the parameters. According to the example above, the name of the test cases would be:

:white_check_mark: given marketPrice null and salesPrice null should satisfies expectedResult false  
:white_check_mark: given marketPrice null and salesPrice 1.2 should satisfies expectedResult false  
:white_check_mark: given marketPrice 1.2 and salesPrice null should satisfies expectedResult false  
:white_check_mark: given marketPrice 2.1 and salesPrice 1.2 should satisfies expectedResult true  
:white_check_mark: given marketPrice 1.2 and salesPrice 2.1 should satisfies expectedResult false  
:white_check_mark: given marketPrice 1.2 and salesPrice 1.2 should satisfies expectedResult false

### Configure SDK in Test Classes
To manage settings about the configuration is test classes, `@Config` annotation can be used. This annotation can be used for a test method or an entire test class. The most used configuration setting in the test classes of the project is the android SDK level. The level to be emulated can be determined as shown below.
```kotlin
@Config(sdk = [Build.VERSION_CODES.O_MR1])
```
### Factory Classes
In the project, some classes create models to use in test methods called `Factory`. The purpose of these classes is to create the model according to the given parameters and use it in the required method. Because some model classes have too many attributes, recreating these models in every test class needed makes it difficult to write the test. It is aimed to eliminate this difficulty with Factory classes.

```kotlin
//example of Factory object
object InstantDeliveryCartFactory {  
  
    fun createInstantDeliveryCart(  
        itemCount: Int = 4,  
  groups: List<InstantDeliveryGroup> = listOf(createInstantDeliveryGroup("1"), createInstantDeliveryGroup("2")),  
  totalProductPrice: Double = 100.0,  
  totalProductPriceDiscounted: Double = 100.0,  
  deciExceedText: String? = null,  
  bestSellersDeepLink: String? = null,  
  bestSellersTitle: String = ""  
  ): InstantDeliveryCart =  
  InstantDeliveryCart(  
	  itemCount = itemCount,  
	  groups = groups,  
	  totalProductPrice = totalProductPrice,  
	  totalProductPriceDiscounted = totalProductPriceDiscounted,  
	  campaignParameters = listOf(createCampaignParameter()),  
	  cartSummaries = listOf(createSummary()),  
	  deciExceedText = deciExceedText,  
	  channelCartSummaries = listOf(createSummary()),  
	  bestSellersTitle = bestSellersTitle,  
	  bestSellersDeepLink = bestSellersDeepLink,  
	  walletOffer = createInstantDeliveryWalletOffer(),  
	  discountLimitInfoTexts = emptyList()  
 )

//Usage in test methods
@Test  
fun `initializeViewModel should call pageUseCase getCart and update liveData objects`() {  
    // Given  
  val instantDeliveryCart = InstantDeliveryCartFactory.createInstantDeliveryCart()
```

### Articles About Unit Test Practices
<https://medium.com/trendyol-tech/trendyol-android-team-unit-test-practice-907cf8d0346>
<https://medium.com/trendyol-tech/guide-to-trendyol-android-app-unit-testing-b4beebb5665b>
