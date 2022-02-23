
# Gradle Rules  

 * Status: accepted
 * Date: 2022-02-23

## Context and Problem Statement

DataBinding has a significant negative impact on build times due to the annotation processor it uses.

## Decision

In the context of view and state binding, facing the concern of increased build times; we decided to use viewBinding and neglected dataBinding to achieve shortened build times
