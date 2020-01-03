# App Architecture Guideline

Trendyol Android App is being developed with reactive programming concepts and therefore Model-View-ViewModel(MVVM) is the 
most suitable pattern for the team. When we had started to implement **MVVM** properly, we also started to use recommended 
libraries like other developers who love to develop with clean coding.


All layers at the app have their own responsibilities during data flow and these layers are developed as smaller as possible. If unrelated responsibilities are implemented at the same layers; readability and maintenance of the code will be harder and it can eliminate refactoring in the feature. As a result, when we develop the app, we’re trying to implement recommended architecture with common architectural principles, thus the app has more testable and sustainable code base. We are an open-minded, enthusiastic and curious team to try new approaches; because of this, the architecture can change according to best approaches in the future. 🤗 You can find whole architectural diagram of Trendyol Android App.

### Trendyol Android App Architecture
![Trendyol Android App Architecture](https://github.com/Trendyol/android-guidelines/blob/feature/app_arch/app_architecture_guideline/diagrams/trendyol-app-arch-diagram.png)

## Layers
You can find detailed explanation about related layers which are implemented in Trendyol Android Application.

* [Repository](repository.md)
* [UseCase](usecase.md)
* [ViewModel](viewmodel.md)
* [UI/View](view.md)
