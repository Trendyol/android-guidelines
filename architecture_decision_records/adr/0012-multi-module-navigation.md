
# Gradle Rules  

 * Status: deprecated
 * Date: 2021-06-24

## Decision

In the context of in app navigation between module facing concern of creating circular dependencies and causing longer build times we decided for creating navigation module and neglected using reflection to create fragment instances, to achieve in app navigation, accepting using argument classes as DTO, because using reflection breaks type safety.
