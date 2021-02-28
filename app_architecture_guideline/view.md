# UI/View
In the app, UI controller classes such as activities and fragments have ViewModel’s reference, observe LiveData in ViewModel 
to display data, trigger showing UI components like Snackbar and also update custom views. During data flow, observing 
LiveData that holds ViewState is the most important part of Data Binding. Every UI controllers and custom views in the app, 
have its own ViewState. For example, fragment has single ViewState to keep data status for Success, Loading and Error; to 
update custom views in the fragment, different ViewState classes have been used. Because, if fragment’s ViewState is used to 
update specific view, all parts of fragment will be updated unnecessarily.

## DataBinding
Data Binding provides to bind observable data to UI components and prevent boilerplate codes at the UI objects. We use Data 
Binding at all UI development process to update related UI components.

## ViewState
This class is created after data emission in ViewModel for UI updates, it contains all data and logics that is needed by UI 
controllers or view. We don’t prefer directly to use any types of classes that exists under android package such as Context in 
ViewModel, and ViewState provides a solution us when we need to follow this approach. Another usage of ViewState is that when 
we develop user interface for a fragment or a feature, we prefer to create custom views and ViewStates to update these views. 
Using ViewState classes not only creates more testable code, but also makes layout files in the app more readable.

![UI/View](https://github.com/Trendyol/android-guidelines/blob/master/app_architecture_guideline/diagrams/ui.png)

```kotlin
data class PageViewState(
    private val status: Status,
    private val error: ResourceError?,
    private val uiData: Data?
) {
    fun getStateInfo(context: Context): State =
        when (status) {
            Status.LOADING -> ...
            Status.SUCCESS -> ...
            Status.ERROR -> ...
        }

    fun getMessageVisibility(): Int = if(uiData?.message.isNullOrEmpty()) View.GONE else View.VISIBLE
    
    fun getMessage(): String? = uiData?.message

    fun getTitle(context: Context): String = uiData?.title ?: context.getString(R.string.title)
    
    fun getImageUrl(): String? = uiData?.imageUrl
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools">

    <data>
        <variable
            name="viewState"
            type="com.application.PageViewState" />
    </data>

    <com.erkutaras.statelayout.StateLayout
        android:id="@+id/stateLayout"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        app:showState="@{viewState.getStateInfo(context)}">

        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="vertical">

            <androidx.appcompat.widget.AppCompatImageView
                android:id="@+id/imageView"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:scaleType="fitCenter"
                app:imageUrl="@{viewState.getImageUrl()}" />

            <androidx.appcompat.widget.AppCompatTextView
                android:id="@+id/textViewTitle"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="@{viewState.getTitle(context)}"
                tools:text="Title" />

            <androidx.appcompat.widget.AppCompatTextView
                android:id="@+id/textViewMessage"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="@{viewState.getMessage()}"
                android:visibility="@{viewState.getMessageVisibility()}"
                tools:text="Message" />

        </LinearLayout>
    </com.erkutaras.statelayout.StateLayout>
</layout>
```
