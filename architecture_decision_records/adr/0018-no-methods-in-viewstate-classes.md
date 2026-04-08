# No Methods in ViewState and UiState Classes

* Status: accepted
* Date: 2026-02-09

## Context and Problem Statement

The core problem is that ViewState classes have evolved beyond their intended purpose as simple data containers. They now serve as rule containers that encode visibility logic, formatting rules, business decisions, and transformations. This creates several issues:

- **Business logic in ViewState classes:** Business rules inside state classes, making code review and debugging difficult.
- **Fat domain models in UI state:** UI states hold entire domain models when only a subset of fields is needed, creating tight coupling between UI and domain layers and impacting Compose stability.
- **Mutable state properties:** Some ViewState classes use `var` instead of `val`, breaking unidirectional data flow and creating potential race conditions.
- **Impact on development velocity:** Increased cognitive load, longer code reviews, complex testing, slower Compose migration, and unnecessary recompositions due to unstable state shapes.

## Decision

In the context of standardizing UI layer state management, facing concerns of inconsistent patterns, degraded Compose performance, and blurred separation of concerns, we decided for the **Passive Data Model pattern** and neglected the alternative of keeping the current pattern with guidelines only, to achieve clear separation of concerns, improved testability, and better Compose performance, accepting that existing ViewState classes will need gradual refactoring, because enforcement without tooling has proven ineffective and Compose stability requires immutable, flat state objects.

### The Pattern

**UI State classes must be pure data containers** with the following rules:

1. Defined as `data class` with all properties as `val`.
2. Annotated with `@Immutable` or `@Stable` for Compose stability.
3. Contain only UI-ready types: primitives, `String`, `Color`, `AnnotatedString`, and immutable collections (`ImmutableList`, `PersistentList` from `kotlinx-collections-immutable`).
4. **Must not contain any methods.**
5. Extract only the fields needed from domain models (flat, UI-ready types instead of holding entire domain objects).

**All transformation and decision logic must reside in dedicated mapper classes:**

1. Mappers convert domain models to UI state.
2. Mappers compute visibility flags, format strings, and handle all conditional logic.
3. Mappers should be injectable via `@Inject` constructor.
4. Mappers should contain pure functions (same input always produces same output).

### Layer Responsibilities

- **Domain Layer:** Business logic in domain mappers or use cases. Compute business decisions such as visibility rules and validation states.
- **UI Layer:** UI state is a pure data container. UI mapper handles only UI-specific transformations (string formatting, color resolution).
