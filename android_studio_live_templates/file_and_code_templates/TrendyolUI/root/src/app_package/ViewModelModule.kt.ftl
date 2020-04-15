package ${packageName}

import androidx.lifecycle.ViewModel
import com.trendyol.androidcore.annotation.ViewModelKey
import dagger.Binds
import dagger.Module
import dagger.multibindings.IntoMap

@Module
abstract class ${className}ViewModelModule {

    @Binds
    @IntoMap
    @ViewModelKey(${className}ViewModel::class)
    abstract fun bind${className}ViewModel(viewModel: ${className}ViewModel): ViewModel
}
