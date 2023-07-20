# Using Fragment Result API

* Status: accepted
* Date: 2023-20-07

## Context and Problem Statement

In modern Android applications, we use a single activity pattern and our infrastructure is based on
fragments. When dialog and bottom sheets are taken into account, communication between fragments has
an important place.
There are several options when it comes to communication and taking a result from a fragment. In our
project we mostly use callbacks which has some disadvantages like increasing coupling and not being
able to handle recreation of the fragments.

## Decision

In the context of the problem stated above, we decided to handle these communications using Google's
recommended Fragment Result API due to the several advantages it provides compared to other
communication methods.
For more details, please visit the page below.
[Fragment Result API](https://developer.android.com/guide/fragments/communicate#fragment-result)