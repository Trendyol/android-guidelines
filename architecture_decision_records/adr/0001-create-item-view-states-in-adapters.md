# Create Item View States in Adapters

* Status: accepted
* Date: 2019-05-08

## Context and Problem Statement

Creation of list items' ViewState in ViewModel/Usecase causes lots of model wrapping/operation during the data flow from ViewModel/Usecase to UI layer.

## Decision

In the context of item view state creation facing concern of tight coupling we decided to create item view states in adapters and neglected creating item view states in viewmodels/usecases, to achieve consistency and seperation of concerns.
