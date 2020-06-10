# No Repository Implemantation to View Model

* Status: accepted
* Date: 2019-11-10

## Context and Problem Statement

implementation repository layer directly in viewModel causes all methods in repositooru to be accessed from view model

## Decision

In the context of implementation repository directly in viewModel facing concern of give the view model access on repository we decided to create useCase class for view model and neglected using repository class in view model to achieve view model is granted access to only the required methods.
