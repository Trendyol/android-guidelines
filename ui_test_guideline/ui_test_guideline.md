# UI Test Guideline

- Test method naming convention should be as follow: **givenPreconditionsWhenStateUnderTestThenExpectedBehavior**
- Each test method should have related Jira link just as below:
```kotlin
     /**
     * @see https://****.com/browse/MLBS-881
     */
    @Test
    fun givenPreconditionsThenExpectedBehavior()
```
