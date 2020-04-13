
# Create Multiple UI & Network Models

* Status: accepted
* Date: 2019-05-01

## Context and Problem Statement

Using response model directly in UI layer causes to create lots of god object, prevent flexibility and increase dependency with each layer.

## Decision

In the context of creating multiple model classes for network and ui layers facing concern of creating god objects and limiting the ability to modularize the application we decided to use multiple model classes and neglected using a single model class, to achieve flexibility and fewer dependencies.
