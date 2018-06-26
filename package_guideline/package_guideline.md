# Package Guideline

## common
The common package contains any classes that may be used for common features across the application.

## data
The data package contains networking classes, preferences management, database classes, entity models, network request and response model.

### remote
Remote packages contain all classes and interfaces that handle all communications with remote sources.

### local
Local packages contain all classes and interfaces that handle all communication with the local database that is used to cache data.

## domain
The domain package contains our business objects and contains the Use Case classes used to interact with these from other packages.

## ui
The UI package contains  UI components of the application. UI package has child packages that are organized as feature-by-layer.