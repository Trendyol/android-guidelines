# UI Test Guideline

- Test method naming convention should be as follow: **givenPreconditionsWhenStateUnderTestThenExpectedBehavior**
- Each test method should have related Jira link just as below:
```kotlin
     /**
     * @see https://jtracker.trendyol.com/browse/MLBS-881
     */
    @Test
    fun givenPreconditionsThenExpectedBehavior()
```
- Emulator device's cpu/abi should be x86_64 to prevent "Process instrumentation crashed..." error when tests are running.
- Window animation scale, Transition animation scale and Animator duration scale options should be setted as "Animation off" in the developer options to prevent crashes when the element is not found because of the animations.
