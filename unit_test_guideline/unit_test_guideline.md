# Unit Test Guideline

This document serves as a guide for writing unit tests within the project. It includes examples and practical rules for testing LiveData and Kotlin Flow behaviors. Additionally, it covers SDK configuration and the use of Factory classes within test classes.

## 1. Test Naming

Test names directly affect readability and how easily one can understand what the test is verifying. Therefore, names should be clear, define the scenario explicitly, and follow a consistent format.

### 1.1 Format

The standard format is:
```
Given<Preconditions>, When<MethodIsExecuted>, Then<ExpectedResult>
```

With this structure, test scenarios clearly express:
- the preconditions (Given),
- the action being executed (When),
- the expected outcome (Then).

### 1.2 Examples:

```kotlin
@Test
fun `Given visibility GONE, When checkQuickSellTabItem called, Then dolapliteActivityViewState update with false`() { ... }

@Test
fun `Given invalid phone number, When validate is called, Then should return false`() { ... }

@Test
fun `Given empty cart, When checkout is triggered, Then should showEmptyCartWarning`() { ... }
```

### 1.3 Writing Rules

- **Meaningful**: The test name should be able to describe the scenario on its own.
- **Concise but clear**: Overly long names may cause compilation issues or readability problems in the IDE.
- **Avoid special characters**: Characters such as `.:/\[]<>` may cause issues in some runners.
- **Use backticks (``)**: In Kotlin, backticks allow you to write test names like descriptive strings.

### 1.4 Common Mistakes

**Bad Examples:**
```kotlin
fun test1() { ... } 

fun checkSomething() { ... } 

fun shouldReturnTrueIfConditionIsMet() { ... } 
```

**Good Examples:**
```kotlin
fun `Given user under 18, When isEligibleForPayment called, Then should return false`() { ... }

fun `Given network error, When fetchProducts called, Then should emit ErrorState`() { ... }
```

### 1.5 Helpful Tips

- **Focus on a single behavior**: A test should not try to verify multiple things at once.
- **Don't forget negative scenarios**: For example: `Given invalid input, When parseDate called, Then should throw Exception`.
- **Use tables for comprehensive scenarios**: Parameterized tests allow multiple "Given" variations to be tested within a single test class.

## 2. Test Structure: Given — When — Then

Each test method should be divided into three main blocks. This structure improves the readability of the test scenario, makes it easier to identify at which stage an error occurs, and establishes a common language within the team.

### 2.1 Structure

**Given (Setup):**
- Prepare the preconditions required for the test to run.
- Define mock objects (MockK, Mockito, or Fake classes).
- Create fake/data objects.
- Add a test collector or observer for Flow/LiveData.

**When (Action):**
- Call the method under test or trigger the behavior.
- Examples: ViewModel function call, UseCase execution, Repository method invocation.

**Then (Verification):**
- Verify the expected outcome.
- Compare values using Truth.assertThat.
- Check mock behavior using `verify { ... }`.
- Validate the order of Flow/LiveData emissions.

### 2.2 Example:

```kotlin
@Test
fun `Given visibility GONE, When checkQuickSellTabItem called, Then dolapliteActivityViewState update with false`() {
    // Given
    val visibility = View.GONE
    val observer = dolapLiteViewModel.getDolapliteActivityViewState().test()
    val expectedViewState = DolapliteActivityViewState(displayQuickSell = false)

    // When
    dolapLiteViewModel.checkQuickSellTabItem(visibility)

    // Then
    Truth.assertThat(observer.getValues().last())
        .isEqualTo(expectedViewState)
}
```

### 2.3 Best Practices

- **Separate each block**: Always include comment lines like `// Given`, `// When`, `// Then`.
- **Single responsibility**: A test should verify only one behavior.
- **Reduce setup/teardown repetition**:
  - Use `@Before` for common Given preparations.
  - Use `@After` for post-test cleanup.
- **Clearly write expected results**: Prefer meaningful names like `expectedViewState` or `expectedResult`.

### 2.4 Bad and Good Examples

**Bad Example (blocks not separated, unclear):**
```kotlin
@Test
fun testQuickSell() {
    val observer = vm.state.test()
    vm.checkQuickSellTabItem(View.GONE)
    assertThat(observer.values.last()).isEqualTo(false)
}
```

**Good Example (Given-When-Then clearly separated, readable):**
```kotlin
@Test
fun `Given empty cart, When checkout called, Then should showEmptyCartWarning`() {
    // Given
    val observer = viewModel.uiState.test()

    // When
    viewModel.checkout()

    // Then
    Truth.assertThat(observer.getValues().last().showEmptyCartWarning)
        .isTrue()
}
```

### 2.5 Why It Matters

- Tests are much easier to read during code reviews.
- When a test fails, it's easy to identify at which step the error occurred.
- Establishes a common test-writing standard within the team.

## 3. Asynchronous Tests: LiveData and Flow

In the project, both LiveData and kotlinx.coroutines.Flow may be used. In both cases, tests should be deterministic, execute in the expected order, and remain easy to read.

### 3.1 LiveData Tests

**Usage:**
- Use the project-defined `test()` extension function to observe LiveData changes.
- This extension allows LiveData to be easily observed during tests and returns the values as a list.
- During the test, the latest state can be checked using `getValues().last()`.

**Example:**
```kotlin
@Test
fun `Given valid address, When setAddress called, Then viewState updates`() {
    // Given
    val observer = viewModel.getViewState().test()
    val address = "Istanbul"
    val expectedResult = AddressViewState(address, isValid = true)

    // When
    viewModel.setAddress(address, true)

    // Then
    Truth.assertThat(observer.getValues().last()).isEqualTo(expectedResult)
}
```

**Advantages:**
- Simple and readable.
- Allows quick verification in UI state tests.

### 3.2 Flow Tests

A Flow emits values asynchronously, so coroutine test tools should be used when testing it.

#### 3.2.1 Flow Testing with runTest

- Using `runTest` (from kotlinx-coroutines-test), coroutine-based tests run deterministically.
- Flow values can be collected using collection functions like `toList`, `take`, or `first`.

**Example:**
```kotlin
@Test
fun `Given valid input, When flow emits, Then should collect expected values`() = runTest {
    // Given
    val expected = listOf("A", "B", "C")

    // When
    val actual = mutableListOf<String>()
    viewModel.getFlowUnderTest().take(3).toList(actual)

    // Then
    Truth.assertThat(actual).isEqualTo(expected)
}
```

#### 3.2.2 Flow Testing with Turbine

- Turbine makes Flow tests more readable.
- Functions like `awaitItem()` and `awaitComplete()` allow step-by-step verification of the flow.
- Use `cancelAndIgnoreRemainingEvents()` to ignore unnecessary values.

**Example:**
```kotlin
@Test
fun `Given flow emits items, When collect with turbine, Then items are expected`() = runTest {
    viewModel.getFlowUnderTest().test {
        assertThat(awaitItem()).isEqualTo("A")
        assertThat(awaitItem()).isEqualTo("B")
        cancelAndIgnoreRemainingEvents()
    }
}
```

### 3.3 Best Practices

**Write deterministic tests:**
- Use `runTest` and `TestCoroutineScheduler` to achieve time-controlled, deterministic tests.
- Use `advanceUntilIdle()` to wait for all coroutines in the queue to complete.

**Use collection functions for stability:**
- `take()`, `first()`, `toList()` prevent tests from hanging unexpectedly.

**Prefer toList() for state tests, Turbine for event tests:**
- **State**: If the last known value is important (`.last()`), `toList()` is simpler.
- **Event**: If step-by-step verification is needed (`awaitItem()`), Turbine is ideal.

**Always use runTest for Flow and LiveData tests:**
- `runBlockingTest` is now deprecated.
- `runTest` combined with `TestCoroutineDispatcher` is the most up-to-date and recommended approach.

## 4. Using Context and Robolectric

In unit tests, when Android framework dependencies (e.g., Context, Resources, Drawable) are needed, Robolectric should be used. Robolectric allows Android APIs to be simulated on the JVM, enabling tests to be written without requiring a physical device or emulator.

### 4.1 Obtaining Context

In tests, the following method should be preferred to access a Context object:

```kotlin
private val context: Context = ApplicationProvider.getApplicationContext()
```

This approach provides the application's ApplicationContext during tests and works compatibly with Robolectric.

### 4.2 Context Usage Scenarios

**Theme-Dependent Tests**

Some View or Drawable tests require a theme. In such cases, `setTheme` can be used:

```kotlin
private val context = ApplicationProvider.getApplicationContext<Context>().apply {
    setTheme(R.style.AuthenticationPageBaseTheme)
}
```

**Using a Mock Context**

For more isolated tests, `ApplicationProvider.getApplicationContext()` can be preferred. It is particularly useful when stubbing only methods like `getString()`:

```kotlin
val context: Context = ApplicationProvider.getApplicationContext()
```

**Resources / Drawable Validations**

When making Drawable comparisons, `constantState` should be used:

```kotlin
val expectedDrawable = ContextCompat.getDrawable(context, R.drawable.shape_image_viewer_selected_background)

val actualDrawable = viewState.getThumbnailIndicatorDrawable(context)
Truth.assertThat(actualDrawable?.constantState).isEqualTo(expectedDrawable?.constantState)
```

### 4.3 Choosing a Test Runner

For tests that depend on Context and Android APIs, one of the following runners should be used:

- `@RunWith(AndroidJUnit4::class)` → Recommended standard runner for AndroidX tests
- `@RunWith(RobolectricTestRunner::class)` → Especially when Robolectric features are required

### 4.4 Example:

```kotlin
@RunWith(AndroidJUnit4::class)
@Config(sdk = [Build.VERSION_CODES.P]) // Optional SDK level can be specified

class WalletCardListNewCardViewStateTest {
    private val context: Context = ApplicationProvider.getApplicationContext()
   
    @Test
    fun `Given isSelected true, When getThumbnailIndicatorDrawable called, Then should return expected drawable`() {
        // Given
        val viewState = ImageViewerThumbnailViewState(imageUrl = "", isSelected = true)
        val expectedDrawable = ContextCompat.getDrawable(
            context,
            R.drawable.shape_image_viewer_selected_background
        )?.constantState

        // When
        val actualDrawable = viewState.getThumbnailIndicatorDrawable(context)

        // Then
        Truth.assertThat(actualDrawable?.constantState).isEqualTo(expectedDrawable)
    }
}
```

### 4.5 Summary

- **Context access**: `ApplicationProvider.getApplicationContext()`
- **When a theme is required**: `context.setTheme(R.style.YourTestTheme)`
- **For isolated tests**: `mockk<Context>()`
- **Drawable comparisons**: use `constantState`
- **Test runner choice**: `AndroidJUnit4` or `RobolectricTestRunner`

## 5. Mocking and Assertions

In tests, the MockK framework should be used for mocking, and Truth should be used as the standard tool for assertions.

### 5.1 MockK Usage

#### 5.1.1 Basic Setup

- Use `@MockK` annotation to mock dependencies.
- `MockKAnnotations.init(this)` call should be made in the `@Before` block.

```kotlin
@MockK
lateinit var repository: MyRepository

@Before
fun setUp() {
    MockKAnnotations.init(this)
}
```

#### 5.1.2 Defining Behavior

- Use `every { ... } returns ...` to define return values.
- For methods that return Unit, use `just Runs`.

```kotlin
every { repository.getData() } returns expectedResult
every { repository.clearCache() } just runs
```

#### 5.1.3 Call Verification

- Use `verify { ... }` to assert that a method was called.
- You can limit the number of calls using parameters like `exactly`, `atLeast`, or `atMost`.

```kotlin
verify(exactly = 1) { repository.getData() }
verify(atLeast = 1) { repository.clearCache() }
```

#### 5.1.4 Using Slot and Capture

- Use `slot` or `capture` to capture arguments passed to mocked methods.

```kotlin
val capturedSlot = slot<String>()
every { repository.saveData(capture(capturedSlot)) } just runs
repository.saveData("TEST")
Truth.assertThat(capturedSlot.captured).isEqualTo("TEST")
```

#### 5.1.5 Relaxed Mocks

- Use `@RelaxedMockK` to reduce unnecessary stubbing.
- Especially useful for callbacks or interface dependencies.

```kotlin
@RelaxedMockK
lateinit var listener: MyListener
```

### 5.2 Using Truth

#### 5.2.1 Basic Assertions

```kotlin
Truth.assertThat(actual).isEqualTo(expected)
Truth.assertThat(flag).isTrue()
Truth.assertThat(list).containsExactly("A", "B", "C")
```

#### 5.2.2 Data Class vs Non-Data Class

- If the object is a **data class**, `isEqualTo` can be used directly since `equals` is overridden.
- If the object is **not a data class**, its properties should be asserted individually.

**Data Class Example:**
```kotlin
data class User(val id: Int, val name: String)
Truth.assertThat(actualUser).isEqualTo(expectedUser)
```

**Non Data Class Example:**
```kotlin
Truth.assertThat(actualUser.id).isEqualTo(expectedUser.id)
Truth.assertThat(actualUser.name).isEqualTo(expectedUser.name)
```

#### 5.2.3 Collection Assertions

Truth provides rich assertion support for collection tests:

```kotlin
Truth.assertThat(list).isNotEmpty()
Truth.assertThat(list).contains("item1")
Truth.assertThat(list).doesNotContain("itemX")
Truth.assertThat(list).containsExactlyElementsIn(expectedList).inOrder()
```

#### 5.2.4 Exception Assertions

Use `assertThrows` to test for expected exceptions.

```kotlin
val exception = assertThrows<IllegalArgumentException> {
    repository.getDataOrThrow(-1)
}
Truth.assertThat(exception).hasMessageThat().contains("Invalid id")
```

### 5.3 Summary

- **MockK** → to simulate the behavior of dependencies
- **Truth** → to verify the correctness of results
- **Data class** → can be compared directly
- **Non-data class** → assert properties individually
- **Best practice** → follow the Given-When-Then structure: first mocking → then method call → finally assertions

## 6. Test Rules

Some `@Rule` definitions used in unit tests help control asynchronous structures, ensuring that tests are deterministic (produce the same result on every run). The following rules should be used as standard in the project.

### 6.1 InstantTaskExecutorRule

- **Purpose**: Executes background tasks synchronously in tests for Android Architecture Components (LiveData, ViewModel).
- **Why Needed**: LiveData runs on the main thread by default. In a unit test environment, there is no main thread, causing tests to fail.
- **Solution**: Synchronizes all LiveData calls.

```kotlin
@get:Rule
val instantExecutorRule = InstantTaskExecutorRule()
```

### 6.2 TestCoroutineRule

- **Purpose**: Provides a dispatcher for testing coroutine-based code.
- **Why Needed**: Coroutines run on Dispatchers.Main by default, which is not available in the test environment.
- **Solution**: Uses TestCoroutineDispatcher and TestCoroutineScope to make coroutines controllable during tests.

```kotlin
@get:Rule
val testCoroutineRule = TestCoroutineRule()
```

**Example:**
```kotlin
@Test
fun `Given valid input, When useCase is called, Then emits expected result`() =
    testCoroutineRule.runBlockingTest {
        // Given
        coEvery { repository.getData() } returns expectedData

        // When
        val result = useCase.execute()

        // Then
        Truth.assertThat(result).isEqualTo(expectedData)
    }
```

### 6.3 RxSchedulerTestRule

- **Purpose**: Provides control over schedulers to test RxJava streams.
- **Why Needed**: RxJava uses asynchronous schedulers by default (io(), computation(), newThread()), which can lead to non-deterministic tests.
- **Solution**: Replace all schedulers with Schedulers.trampoline() to execute them synchronously.

```kotlin
@get:Rule
val rxSchedulerRule = RxSchedulerTestRule()
```

**Example:**
```kotlin
class RxSchedulerTestRule : TestRule {
    override fun apply(base: Statement, description: Description): Statement {
        return object : Statement() {
            @Throws(Throwable::class)
            override fun evaluate() {
                RxJavaPlugins.setIoSchedulerHandler { Schedulers.trampoline() }
                RxJavaPlugins.setComputationSchedulerHandler { Schedulers.trampoline() }
                RxJavaPlugins.setNewThreadSchedulerHandler { Schedulers.trampoline() }
                try {
                    base.evaluate()
                } finally {
                    RxJavaPlugins.reset()
                }
            }
        }
    }
}
```

### 6.4 Combined Usage

Multiple rules can be used together in most test classes:

```kotlin
@RunWith(AndroidJUnit4::class)
class ExampleViewModelTest {
    @get:Rule
    val instantExecutorRule = InstantTaskExecutorRule()

    @get:Rule
    val testCoroutineRule = TestCoroutineRule()

    @get:Rule
    val rxSchedulerRule = RxSchedulerTestRule()
    // ...
}
```

### 6.5 Summary

- **InstantTaskExecutorRule** → Executes LiveData tests synchronously.
- **TestCoroutineRule** → Provides a dispatcher for coroutine tests.
- **RxSchedulerTestRule** → Executes RxJava streams synchronously.
- **Best practice** → Use these rules together in a test class as needed.

## 7. Which Classes Should Be Tested?

### Test Coverage Guidelines

#### ✅ MUST

| Class Type                          | Description                                                                 |
|-------------------------------------|-----------------------------------------------------------------------------|
| **UseCase, ViewModel, Validator, Decider** | Contains business logic and state management. Critically important.         |
| **ViewState, EpoxyItem**            | Represents states sent to the UI; essential for UI correctness.              |

---

#### ⚖️ MAYBE

| Class Type               | Description                                                                 |
|---------------------------|-----------------------------------------------------------------------------|
| **Mapper, Builder, Extensions** | Simple transformations are optional; if complex business logic exists → **MUST** |
| **Repository**            | Simple CRUD is optional; if caching/error handling etc. exists → **MUST**   |

---

#### 🚫 EXCLUSION

| Class Type                     | Description                                                                 |
|--------------------------------|-----------------------------------------------------------------------------|
| **Activity, Fragment, View, Model** | Mostly UI/carrier classes; if they don't contain business logic, testing is unnecessary. |

## 8. SDK Configuration in Test Classes

The `@Config` annotation can be used to specify the Android SDK level that tests will run on. This annotation can be applied to a test class or individual test methods. The most common usage is with Robolectric to specify the SDK level.

**Example (Robolectric):**

```kotlin
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [Build.VERSION_CODES.O_MR1])
class MyRobolectricTest {
    // tests
}
```

`@Config` can also be used with additional options like `manifest = "..."`, `qualifiers = "..."`.

> **Note**: If you're using `ApplicationProvider.getApplicationContext()`, make sure you're running with an appropriate test runner (AndroidJUnit4 or Robolectric).

### 8.1 SDK Version Selection Details

**Why are different SDK values used?**

When running Robolectric tests, it simulates a specific version of Android framework APIs. Since some APIs or behaviors are only available in certain versions, the appropriate version must be selected with `@Config(sdk = [...])` for tests to run under the correct conditions.

**When is it necessary to change the SDK?**

- To test changes that come with new Android versions like Drawable, Context, Permission, NotificationChannel, etc.
- For example, you might need to use P (28) or Q (29) instead of `Build.VERSION_CODES.O_MR1` (27) because the component being tested behaves differently on API 28+.
- Some UI behaviors (`constantState`, `getColor`, `getDrawable`) work on older SDKs but differ on newer ones.

**How many SDK versions are there?**

There are increasing `Build.VERSION_CODES` constants from Android's first version. (Starting from BASE=1 up to Android 15 = VANILLA_ICE_CREAM = 35 today). Robolectric generally supports the last 3-4 stable versions well.

### 8.2 What Does It Affect in Tests?

- **Resource loading**: signature and behavior of methods like `getDrawable`, `getColor` can change.
- **Theme/Style behaviors**.
- **Platform API availability**: e.g., NotificationChannel is only available on API 26+.
- **Some default framework values**: LayoutInflater, WindowInsets, etc.

### 8.3 Recommendations

- Choose at least one modern stable version (e.g., Q or R) for general tests.
- If you need to test API changes, you can run parametric tests with different SDK values.
- It's logical not to test very old versions (19, 21, etc.) unnecessarily since they no longer have counterparts on current devices.

## 9. Factory Classes

Use Factory objects to create frequently used or large data models in a single line in the project. This makes tests more readable and maintainable.

### 9.1 Factory Implementation Example

```kotlin
object InstantDeliveryCartFactory {
    fun createInstantDeliveryCart(
        itemCount: Int = 4,
        groups: List<InstantDeliveryGroup> = listOf(createInstantDeliveryGroup("1"), createInstantDeliveryGroup("2")),
        totalProductPrice: Double = 100.0,
        totalProductPriceDiscounted: Double = 100.0,
        deciExceedText: String? = null,
        bestSellersDeepLink: String? = null,
        bestSellersTitle: String = ""
    ): InstantDeliveryCart = InstantDeliveryCart(
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
}
```

### 9.2 Usage in Tests

```kotlin
@Test
fun `initializeViewModel should call pageUseCase getCart and update liveData objects`() {
    // Given
    val instantDeliveryCart = InstantDeliveryCartFactory.createInstantDeliveryCart()
    // ...
}
```

### 9.3 Benefits of Using Factory

- **Prevents repetition**: Avoids repeatedly creating the same long models in every test.
- **Flexible customization**: You can override only the fields you want to change with parameters.
- **Maintainability**: Changes to the model structure only need to be updated in one place.
- **Readability**: Tests become cleaner and more focused on the actual test logic.

## 10. Parameterized Tests

Parameterized test classes are used when you need to test a method with all possible input combinations. To create parameterized tests with Robolectric, use `@RunWith(ParameterizedRobolectricTestRunner::class)`.

### 10.1 Implementation Example

```kotlin
@RunWith(ParameterizedRobolectricTestRunner::class)
@Config(sdk = [28])
class InstantDeliveryCartProductPriceComparisonDeciderTest constructor(
    val marketPrice: Double?,
    val salesPrice: Double?,
    val expectedResult: Boolean
) {
    @Test
    fun `given marketPrice and salesPrice, when decideIsMarketPriceBiggerThanSalesPrice, then should return expectedResult`() {
        // Given
        val decider = InstantDeliveryCartProductPriceComparisonDecider()
        // When
        val actualResult = decider.decideIsMarketPriceBiggerThanSalesPrice(marketPrice, salesPrice)
        // Then
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

### 10.2 Test Output

The `name` parameter in `@ParameterizedRobolectricTestRunner.Parameters` generates readable test names for each parameter set:

```
✅ given marketPrice null and salesPrice null should satisfies expectedResult false
✅ given marketPrice null and salesPrice 1.2 should satisfies expectedResult false
✅ given marketPrice 1.2 and salesPrice null should satisfies expectedResult false
✅ given marketPrice 2.1 and salesPrice 1.2 should satisfies expectedResult true
✅ given marketPrice 1.2 and salesPrice 2.1 should satisfies expectedResult false
✅ given marketPrice 1.2 and salesPrice 1.2 should satisfies expectedResult false
```

### 10.3 Benefits of Parameterized Tests

- **Comprehensive coverage**: Tests multiple input combinations with a single test method.
- **Reduced code duplication**: Eliminates the need to write separate test methods for each scenario.
- **Clear test names**: The `name` parameter provides descriptive test names for each parameter set.
- **Easy maintenance**: Adding new test cases only requires updating the parameter list.

## 11. @Before and @After Usage

### 11.1 Purpose and Usage

- **@Before**: Runs before each test method. Used for preparing common dependencies (mock init, test data, dispatcher setup, etc.).
- **@After**: Runs after each test method. Used for resource cleanup (observer dispose, mock clear, temporary file deletion, etc.).

### 11.2 Implementation Example

```kotlin
class MyViewModelTest {
    @MockK lateinit var repository: MyRepository
    private lateinit var viewModel: MyViewModel
    
    @Before
    fun setUp() {
        MockKAnnotations.init(this)
        viewModel = MyViewModel(repository)
    }
    
    @After
    fun tearDown() {
        clearAllMocks()
    }
    
    @Test
    fun `Given valid data, When fetch called, Then returns expected result`() {
        every { repository.getData() } returns "Test"
        val result = viewModel.fetch()
        Truth.assertThat(result).isEqualTo("Test")
    }
}
```

### 11.3 Best Practices

- **Keep setup minimal**: Only include common initialization that all tests need.
- **Clean up resources**: Always clean up mocks, observers, and temporary resources in `@After`.
- **Avoid test-specific setup**: If only one test needs specific setup, do it in that test's Given block instead.
- **Use consistent naming**: Use `setUp()` for `@Before` and `tearDown()` for `@After` methods.

## 12. Drawable Validation

### 12.1 Why Use constantState?

Use `.constantState` for drawable comparisons because equality checks can fail directly for objects like BitmapDrawable.

### 12.2 Implementation Example

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

### 12.3 Common Error Without constantState

**Warning**: If the expected drawable file is validated without `.constantState` value, you'll get this error:

```
❌ expected:android.graphics.drawable.BitmapDrawable@1fead1b2 but was :android.graphics.drawable.BitmapDrawable@3823d69f
```

### 12.4 Best Practices

- **Always use constantState**: For any drawable comparison in tests.
- **Handle null cases**: Use safe calls (`?.constantState`) to avoid null pointer exceptions.
- **Consistent approach**: Apply the same pattern across all drawable validation tests.
- **Clear error messages**: The constantState comparison provides more meaningful test failure messages.

## 13. Other Tips and Best Practices

### 13.1 MockK Tips

- **Pay attention to exact parameter matching**: When using `verify` or `every`; default parameters can cause "no answer found" errors in tests.
- **Parameter matching consistency**: When using MockK, the parameters specified in the `every` block must exactly match the parameters used in the actual call.

### 13.2 Test Method Tips

- **Parameterized tests**: Use `@RunWith(ParameterizedRobolectricTestRunner::class)` and `@ParameterizedRobolectricTestRunner.Parameters` for parameterized tests.
- **Avoid long test method names**: They can cause compilation errors in some environments.

### 13.3 General Test Tips

- **Drawable comparisons**: Don't forget to use `.constantState` for drawable comparisons.
- **Context usage**: Use `ApplicationProvider.getApplicationContext()` for tests requiring Context.
- **Test data creation**: Make test data creation easier with Factory classes.
- **Test rules usage**: Use test rules (`@Rule`) correctly:
  - `InstantTaskExecutorRule` for LiveData
  - `RxSchedulerTestRule` for RxJava
  - `TestCoroutineRule` for Coroutines

### 13.4 Summary Checklist

✅ **Naming**: Follow Given-When-Then format with backticks  
✅ **Structure**: Separate Given, When, Then blocks clearly  
✅ **Mocking**: Use MockK with proper parameter matching  
✅ **Assertions**: Use Truth for all assertions  
✅ **Async**: Use appropriate rules for LiveData/Flow/RxJava  
✅ **Context**: Use ApplicationProvider.getApplicationContext()  
✅ **Drawables**: Always compare with .constantState  
✅ **Factory**: Create Factory classes for complex test data  
✅ **Cleanup**: Use @Before/@After for setup and teardown


### Articles About Unit Test Practices
<https://medium.com/trendyol-tech/trendyol-android-team-unit-test-practice-907cf8d0346>
<https://medium.com/trendyol-tech/guide-to-trendyol-android-app-unit-testing-b4beebb5665b>
