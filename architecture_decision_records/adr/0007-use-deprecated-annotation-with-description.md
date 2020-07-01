# Use Deprecated Annotation With Description

* Status: accepted
* Date: 2020-06-18

## Context and Problem Statement

Deprecated annotation usages without any comment or suggestion makes no sense when using existing classes.

## Decision

When we decide to use deprecated annotation in classes, we need to comment reason and alternative to that implementation.

## Sample

```kotlin

@Deprecated(
    message = "This class is deprecated due to unused fields. Check Pixel.Builder for new fields and creation.",
    replaceWith = ReplaceWith(expression = "Pixel", imports = ["com.trendyol.new.package"]
)
class NexusOne() { ... }

```
