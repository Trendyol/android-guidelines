# Navigation Between Activities and Fragments

* Status: accepted
* Date: 2022-03-09

## Context and Problem Statement

Navigation on multi module application requires indirect solutions and putting all navigation abstraction into single file invalidates cache every time changed and against single-responsibility and interface segregation principles.

## Decision

In the context of navigation facing concern of cache issues we decided for creating `[FeatureName]FragmentProvider` or `[FeatureName]ActivityIntentProvider` navigation interfaces into `:[feature-name]:api` and neglected `:navigation` modules, to achieve this we may need to split features into `:[feature-name]:api` and `:[feature-name]:impl` modules, accepting creating more modules, because this way is more flexible and only break the for modules that are using changed feature(s).
