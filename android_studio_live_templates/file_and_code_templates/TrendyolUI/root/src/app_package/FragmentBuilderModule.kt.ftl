package ${packageName}

import com.trendyol.ui.di.FragmentScope
import dagger.Module
import dagger.android.ContributesAndroidInjector

@Module
abstract class ${className}FragmentBuilderModule {

    @ContributesAndroidInjector()
    @FragmentScope
    abstract fun provide${className}Fragment(): ${className}Fragment
}
