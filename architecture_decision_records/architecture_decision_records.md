#  Architecture Decision Records

An architectural decision record (ADR) is a document that captures an important architectural decision made along with its context and consequences.

# Architecture Decision Log

An architecture decision log (ADL) is the collection of all ADRs created and maintained for a particular project (or organization).

#  Draft

In the context of "use case/user story u" facing "concern c" we decided for "option o" and neglected "other options", to achieve "system qualities/desired consequences", accepting "downside d/undesired consequences", because "additional rationale".

## 13.05.2019 - Custom Views Should Have Their Own Models

Status : Adopted

In the context of custom view initialization facing concern of 



## 08.05.2019 - Create Item View States in Adapters

Status: Adopted

In the context of item view state creation facing concern of tight coupling we decided to create item view states in adapters and neglected creating item view states in viewmodels/usecases, to achieve consistency and seperation of concerns. 

## 01.05.2019 - Create Multiple UI&Network Models 

Status: Adopted

In the context of creating multiple model classes for network and ui layers facing concern of creating god objects and limiting the ability to modularize the application we decided to use multiple model classes and neglected using a single model class, to achieve flexibility and fewer dependencies.