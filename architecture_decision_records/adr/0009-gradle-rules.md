  
# Gradle Rules

 * Status: accepted
 * Date: 2021-06-22

## Context and Problem Statement

Number of module count has been increased our build times. Enabling unused plugins and using **gradle.kts** is causing to longer build times.

## Decision
  
 * Disable generating BuildConfig file if its not needed in module.
 * Only enable *databinding* if you're going to use DataBinding in that module.
 * Do not apply *kapt* plugin if you're not going to use.
 * Do not create new variants other than *debug* and *release*.
 * Use groovy scripts on *build.gradle* files.

## Sample

```gradle
android {
	buildFeatures {
	    dataBinding = false
		buildConfig = false  
	}
}
```