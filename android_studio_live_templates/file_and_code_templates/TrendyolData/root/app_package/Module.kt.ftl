package ${packageName}

<#assign camelCaseClassName = className?substring(0,1)?lower_case + className?substring(1)>
import ${packageName}.source.${className}DataSource
<#if includeLocalDataSource>
import ${packageName}.source.local.${className}LocalDataSource
</#if>
import ${packageName}.source.remote.${className}RemoteDataSource
import ${packageName}.source.remote.${className}Service
import dagger.Binds
import dagger.Module
import dagger.Provides
import retrofit2.Retrofit
import javax.inject.Singleton

@Module
abstract class ${className}Module {

    @Binds
    abstract fun bind${className}RemoteDataSource(${camelCaseClassName}RemoteDataSource: ${className}RemoteDataSource): ${className}DataSource.Remote
    <#if includeLocalDataSource>

    @Binds
    abstract fun bind${className}LocalDataSource(${camelCaseClassName}LocalDataSource: ${className}LocalDataSource): ${className}DataSource.Local
    </#if>

    @Module
    companion object {

        @JvmStatic
        @Provides
        @Singleton
        internal fun provide${className}Service(retrofit: Retrofit): ${className}Service {
            return retrofit.create(${className}Service::class.java)
        }
    }
}
