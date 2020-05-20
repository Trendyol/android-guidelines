# Use Same Mapper Class for Library and Ui Model

* Status: accepted
* Date: 2020-04-15

## Context and Problem Statement

Converting the response model required for the library to ui model and then to library model, causes to unnecessary mapper classes and ui models.

## Decision

In the context of creating library model facing concern of convert process we decided to convert response model to library model in the same mapper class and neglected convert response model to ui model, then to library model in a new mapper class, to achieve use fewer model and class.

## Options <!-- optional -->

* Convert response model to library model in the same mapper class
* Convert to data model to ui model, then to library model another mapper class 

