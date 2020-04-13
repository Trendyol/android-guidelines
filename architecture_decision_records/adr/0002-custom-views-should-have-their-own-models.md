
# Custom Views Should Have Their Own Models

* Status: accepted
* Date: 2019-05-13

## Context and Problem Statement

Using of common models in custom views causes tight coupling and to block moving as a library.

## Decision

In the context of custom view creation facing concern of tight coupling we decided to create models just for custom view's domain and neglected using common UI models, to achieve loose coupling between app components.
